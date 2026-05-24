import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';

// ─── Segment model ───────────────────────────────────────────────────────────
class _Segment {
  final String label;
  final Color color;
  final int points;
  final IconData icon;
  final String? special; // 'try_again' | 'coupon' | 'trial'

  const _Segment({
    required this.label,
    required this.color,
    required this.icon,
    this.points = 0,
    this.special,
  });
}

const _kSegments = [
  _Segment(label: '5 pts',       color: Color(0xFF8B5CF6), icon: Icons.star_rounded,        points: 5),
  _Segment(label: '50 pts',      color: Color(0xFFEC4899), icon: Icons.auto_awesome_rounded, points: 50),
  _Segment(label: '10 pts',      color: Color(0xFF0EA5E9), icon: Icons.star_half_rounded,    points: 10),
  _Segment(label: 'Try Again',   color: Color(0xFF94A3B8), icon: Icons.refresh_rounded,      special: 'try_again'),
  _Segment(label: '25 pts',      color: Color(0xFF10B981), icon: Icons.workspace_premium,    points: 25),
  _Segment(label: '100 pts!',    color: Color(0xFFF59E0B), icon: Icons.emoji_events_rounded, points: 100),
  _Segment(label: 'Free Trial',  color: Color(0xFFEF4444), icon: Icons.card_giftcard_rounded, special: 'trial'),
  _Segment(label: '15 pts',      color: Color(0xFF06B6D4), icon: Icons.star_rounded,         points: 15),
];

const _kSegCount = 8;

// ─── Page ────────────────────────────────────────────────────────────────────
class SpinWheelPage extends StatefulWidget {
  const SpinWheelPage({super.key});

  @override
  State<SpinWheelPage> createState() => _SpinWheelPageState();
}

class _SpinWheelPageState extends State<SpinWheelPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  double _rotation = 0.0;
  bool _spinning = false;
  bool _spunToday = false;
  DateTime? _nextSpin;
  String _countdown = '';
  _Segment? _result;
  Timer? _cdTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    );
    _ctrl.addListener(() => setState(() => _rotation = _anim.value));
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) _onDone();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _cdTimer?.cancel();
    super.dispose();
  }

  // ── Spin logic ──────────────────────────────────────────────────────────────
  void _spin() {
    if (_spinning || _spunToday) return;

    final rng = Random();
    final target = rng.nextInt(_kSegCount);
    final segAngle = (2 * pi) / _kSegCount;

    // Desired final rotation: segment `target` centre at top indicator
    // Centre of segment i (unrotated) is at angle: i*segAngle + segAngle/2 from
    // the top (drawing starts at -pi/2). We want:
    //   _newRot + target*segAngle + segAngle/2 - pi/2 ≡ -pi/2  (mod 2π)
    //   _newRot ≡ -(target*segAngle + segAngle/2)             (mod 2π)
    double desired = -(target * segAngle + segAngle / 2);
    desired = ((desired % (2 * pi)) + 2 * pi) % (2 * pi);

    final curNorm = _rotation % (2 * pi);
    double delta = desired - curNorm;
    if (delta <= 0) delta += 2 * pi;

    final endRot = _rotation + 5 * 2 * pi + delta;

    _anim = Tween<double>(begin: _rotation, end: endRot).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );

    setState(() {
      _spinning = true;
      _result = null;
    });
    _ctrl.forward(from: 0);
  }

  void _onDone() {
    final segAngle = (2 * pi) / _kSegCount;
    int idx = ((-_rotation / segAngle).floor()) % _kSegCount;
    idx = ((idx % _kSegCount) + _kSegCount) % _kSegCount;

    setState(() {
      _spinning = false;
      _result = _kSegments[idx];
      _spunToday = true;
      _nextSpin = DateTime.now().add(const Duration(hours: 24));
    });
    _startCountdown();
    _showResult(_kSegments[idx]);
  }

  void _startCountdown() {
    _cdTimer?.cancel();
    _cdTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _nextSpin == null) return;
      final diff = _nextSpin!.difference(DateTime.now());
      if (diff.isNegative) {
        setState(() {
          _spunToday = false;
          _countdown = '';
        });
        _cdTimer?.cancel();
        return;
      }
      final h = diff.inHours.toString().padLeft(2, '0');
      final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
      setState(() => _countdown = '$h:$m:$s');
    });
  }

  void _showResult(_Segment seg) {
    final isSpecial = seg.special != null;
    final title = seg.special == 'try_again'
        ? 'Better luck next time! 😅'
        : seg.special == 'trial'
            ? '🎁 Free Trial Unlocked!'
            : seg.special == 'coupon'
                ? '🎟️ Coupon Saved!'
                : '🎉 +${seg.points} Points!';
    final sub = seg.special == 'try_again'
        ? 'Come back tomorrow for another spin.'
        : isSpecial
            ? 'Added to your Rewards page.'
            : 'Points added to your profile.';

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [seg.color, seg.color.withOpacity(0.6)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(seg.icon, color: Colors.white, size: 34),
              ),
              const SizedBox(height: 16),
              Text(title,
                  style: GoogleFonts.outfit(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Text(sub,
                  style: GoogleFonts.outfit(
                      color: AppColors.textSecondary, fontSize: 13),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Next spin in 24:00:00',
                  style: GoogleFonts.outfit(
                      color: AppColors.textMuted, fontSize: 12)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: seg.color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Awesome!',
                      style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F0FF), Color(0xFFEDE9FE), Color(0xFFF8F0FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── App bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 18, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      color: AppColors.textPrimary,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text('Spin the Wheel',
                        style: GoogleFonts.outfit(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Header card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    children: [
                      const Text('🎡', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Daily Reward Spin',
                                style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textPrimary)),
                            Text('Win up to 100 pts, coupons & free trials',
                                style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // ── Indicator pin
              const Icon(Icons.arrow_drop_down_rounded,
                  size: 48, color: Color(0xFF7C3AED)),

              // ── Wheel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CustomPaint(
                    painter: _WheelPainter(rotation: _rotation),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Button or countdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: _spunToday && _countdown.isNotEmpty
                    ? _CountdownCard(countdown: _countdown)
                    : _SpinButton(
                        spinning: _spinning,
                        onTap: _spin,
                      ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Countdown card ───────────────────────────────────────────────────────────
class _CountdownCard extends StatelessWidget {
  final String countdown;
  const _CountdownCard({required this.countdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Text('Next spin in',
              style: GoogleFonts.outfit(
                  color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 4),
          Text(countdown,
              style: GoogleFonts.outfit(
                  color: const Color(0xFF7C3AED),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2)),
        ],
      ),
    );
  }
}

// ─── Spin button ──────────────────────────────────────────────────────────────
class _SpinButton extends StatelessWidget {
  final bool spinning;
  final VoidCallback onTap;
  const _SpinButton({required this.spinning, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: spinning ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: spinning
              ? const LinearGradient(
                  colors: [Color(0xFFD1D5DB), Color(0xFFE5E7EB)])
              : const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFFA855F7)]),
          borderRadius: BorderRadius.circular(18),
          boxShadow: spinning
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            spinning ? 'Spinning...' : '🎡  SPIN NOW',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Wheel painter ────────────────────────────────────────────────────────────
class _WheelPainter extends CustomPainter {
  final double rotation;
  _WheelPainter({required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    final seg = (2 * pi) / _kSegCount;

    for (int i = 0; i < _kSegCount; i++) {
      final start = rotation + i * seg - pi / 2;

      // Segment fill
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        start,
        seg,
        true,
        Paint()..color = _kSegments[i].color,
      );

      // White divider
      final lineEnd = Offset(c.dx + r * cos(start), c.dy + r * sin(start));
      canvas.drawLine(c, lineEnd, Paint()..color = Colors.white..strokeWidth = 2.5);

      // Label text
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(start + seg / 2);

      final tp = TextPainter(
        text: TextSpan(
          text: _kSegments[i].label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: r * 0.65);

      tp.paint(canvas, Offset(r * 0.42 - tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    // Outer ring
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke,
    );

    // Centre hub
    canvas.drawCircle(c, 24, Paint()..color = Colors.white);
    canvas.drawCircle(c, 20,
        Paint()..color = const Color(0xFF7C3AED));
    canvas.drawCircle(c, 8, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_WheelPainter old) => old.rotation != rotation;
}