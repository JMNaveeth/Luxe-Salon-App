import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/premium_widgets.dart';
import 'auth_background.dart';
import 'login_page.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoController;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          children: [
            const Spacer(flex: 2),

            // ── Animated Logo / Brand ────────────────────────────────────
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                final scale = 1.0 + _logoController.value * 0.05;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.content_cut,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                );
              },
            ).animate().fadeIn(duration: 600.ms).scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutBack,
                  duration: 800.ms,
                ),

            const SizedBox(height: 28),

            // ── Title ────────────────────────────────────────────────────
            Text(
              "Luxe Salon",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: 8),

            Text(
              "Your premium beauty destination",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                letterSpacing: 0.3,
              ),
            ).animate().fadeIn(delay: 500.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),

            const Spacer(flex: 1),

            // ── Subtitle ─────────────────────────────────────────────────
            Text(
              "How would you like to continue?",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
              ),
            ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

            const SizedBox(height: 20),

            // ── Customer Card ────────────────────────────────────────────
            _PremiumRoleCard(
              title: "Customer",
              subtitle: "Book services & enjoy luxury treatments",
              icon: Icons.person_outline,
              gradient: AppColors.primaryGradient,
              badge: "POPULAR",
              onTap: () => Navigator.push(
                context,
                PremiumPageRoute(page: const LoginPage(role: "Customer")),
              ),
            ).animate().fadeIn(delay: 700.ms, duration: 500.ms).slideY(begin: 0.15, end: 0),

            const SizedBox(height: 16),

            // ── Shop Owner Card ──────────────────────────────────────────
            _PremiumRoleCard(
              title: "Shop Owner",
              subtitle: "Manage your salon & grow your business",
              icon: Icons.storefront_outlined,
              gradient: const LinearGradient(
                colors: [Color(0xFF7C6CFF), Color(0xFF9B6CFF), Color(0xFFB06AB3)],
              ),
              badge: "BUSINESS",
              onTap: () => Navigator.push(
                context,
                PremiumPageRoute(page: const LoginPage(role: "Shop Owner")),
              ),
            ).animate().fadeIn(delay: 850.ms, duration: 500.ms).slideY(begin: 0.15, end: 0),

            const Spacer(flex: 2),

            // ── Footer ──────────────────────────────────────────────────
            Text(
              "By continuing, you agree to our Terms of Service",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 11,
                color: AppColors.textMuted.withOpacity(0.7),
              ),
            ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Premium Role Card ──────────────────────────────────────────────────────
class _PremiumRoleCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final String badge;
  final VoidCallback onTap;

  const _PremiumRoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.badge,
    required this.onTap,
  });

  @override
  State<_PremiumRoleCard> createState() => _PremiumRoleCardState();
}

class _PremiumRoleCardState extends State<_PremiumRoleCard>
    with SingleTickerProviderStateMixin {
  double _rotationX = 0;
  double _rotationY = 0;
  bool _isPressed = false;
  late AnimationController _hoverController;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _rotationY += details.delta.dx / 150;
          _rotationX -= details.delta.dy / 150;
          _rotationX = _rotationX.clamp(-0.12, 0.12);
          _rotationY = _rotationY.clamp(-0.12, 0.12);
        });
      },
      onPanEnd: (_) {
        setState(() {
          _rotationX = 0;
          _rotationY = 0;
        });
      },
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_rotationX)
            ..rotateY(_rotationY),
          alignment: Alignment.center,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.gold.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: (widget.gradient as LinearGradient).colors[0].withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 1,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: widget.gradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.gradient as LinearGradient).colors[0].withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (widget.gradient as LinearGradient).colors[0].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.badge,
                              style: GoogleFonts.outfit(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: (widget.gradient as LinearGradient).colors[0],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.goldFaint,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.gold,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
