import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'customer_home.dart' as home_page;
import 'custo_activity_history.dart' as activity_page;
import 'booking_page_1.dart' as booking_page;
import 'customer_profile.dart' as profile_page;

// ─── Shared Colors (matches home palette) ─────────────────────────────────────
class NavColors {
  static const surface = Color(0xFF2A2A1E);
  static const gold = Color(0xFFD4A843);
  static const textSecondary = Color(0xFF9A9070);
}

// ─── Scissor Cut Page Transition ──────────────────────────────────────────────
class ScissorCutRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  ScissorCutRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(milliseconds: 800),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              return CustomPaint(
                foregroundPainter: _ScissorCutPainter(animation.value),
                child: ClipPath(
                  clipper: _ScissorClipper(animation.value),
                  child: child,
                ),
              );
            },
          );
        },
      );
}

class _ScissorClipper extends CustomClipper<Path> {
  final double progress;
  _ScissorClipper(this.progress);

  @override
  Path getClip(Size size) {
    final path = Path();
    // Cut from center outward like scissors opening
    final cutY = size.height * (1 - progress);
    path.addRect(Rect.fromLTRB(0, cutY, size.width, size.height));
    // Add top portion with a zigzag cut edge
    if (progress > 0.3) {
      final topProgress = ((progress - 0.3) / 0.7).clamp(0.0, 1.0);
      path.addRect(
        Rect.fromLTRB(
          0,
          0,
          size.width,
          cutY * (1 - topProgress) + size.height * topProgress,
        ),
      );
    }
    return path;
  }

  @override
  bool shouldReclip(_ScissorClipper oldClipper) =>
      oldClipper.progress != progress;
}

class _ScissorCutPainter extends CustomPainter {
  final double progress;
  _ScissorCutPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    // Scissor position moves across the screen
    final scissorX = size.width * progress;
    final scissorY = size.height * 0.5;
    final angle = math.sin(progress * math.pi * 3) * 0.3;

    canvas.save();
    canvas.translate(scissorX, scissorY);
    canvas.rotate(math.pi / 2);

    final paint =
        Paint()
          ..color = NavColors.gold.withOpacity((1 - progress) * 0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;

    // Top blade
    canvas.save();
    canvas.rotate(-0.4 + angle);
    final topBlade =
        Path()
          ..moveTo(0, 0)
          ..lineTo(-4, -18)
          ..lineTo(2, -16)
          ..lineTo(0, 0);
    canvas.drawPath(topBlade, paint);
    canvas.restore();

    // Bottom blade
    canvas.save();
    canvas.rotate(0.4 - angle);
    final bottomBlade =
        Path()
          ..moveTo(0, 0)
          ..lineTo(4, -18)
          ..lineTo(-2, -16)
          ..lineTo(0, 0);
    canvas.drawPath(bottomBlade, paint);
    canvas.restore();

    // Handle circles
    canvas.drawCircle(const Offset(0, 0), 3, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_ScissorCutPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ─── Shared Bottom Navigation Bar ─────────────────────────────────────────────
// Pass [currentIndex] to highlight the active tab:
//   0 = HOME, 1 = ACTIVITY, 2 = BOOKINGS, 3 = PROFILE
class LuxeBottomNav extends StatelessWidget {
  final int currentIndex;
  const LuxeBottomNav({super.key, required this.currentIndex});

  static const _items = [
    {'icon': Icons.home_outlined, 'label': 'HOME'},
    {'icon': Icons.history_outlined, 'label': 'ACTIVITY'},
    {'icon': Icons.calendar_today_outlined, 'label': 'BOOKINGS'},
    {'icon': Icons.person_outline, 'label': 'PROFILE'},
  ];

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = const home_page.HomeScreen();
        break;
      case 1:
        destination = const activity_page.ActivityCenterPage();
        break;
      case 2:
        destination = const booking_page.BookingPage1();
        break;
      case 3:
        destination = const profile_page.ProfilePage();
        break;
      default:
        return;
    }

    // Use scissor animation for all page transitions
    Navigator.of(context).pushReplacement(ScissorCutRoute(page: destination));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NavColors.surface,
        border: Border(
          top: BorderSide(color: NavColors.gold.withOpacity(0.2), width: 1),
        ),
      ),
      padding: EdgeInsets.only(
        top: 6,
        bottom: MediaQuery.of(context).padding.bottom.clamp(8, 20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final selected = i == currentIndex;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onTap(context, i),
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 56,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _items[i]['icon'] as IconData,
                      color:
                          selected ? NavColors.gold : NavColors.textSecondary,
                      size: 19,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _items[i]['label'] as String,
                      style: TextStyle(
                        color:
                            selected ? NavColors.gold : NavColors.textSecondary,
                        fontSize: 8,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        letterSpacing: 0.4,
                      ),
                    ),
                    if (selected) ...[
                      const SizedBox(height: 2),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: NavColors.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
