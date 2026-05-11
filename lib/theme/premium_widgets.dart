import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

// ─── Premium Gradient Button ─────────────────────────────────────────────────
class PremiumButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool enabled;
  final IconData? icon;
  final double height;

  const PremiumButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.icon,
    this.height = 58,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              if (widget.enabled) {
                _controller.forward();
                setState(() => _isPressed = true);
              }
            },
            onTapUp: (_) {
              _controller.reverse();
              setState(() => _isPressed = false);
              if (widget.enabled) widget.onPressed();
            },
            onTapCancel: () {
              _controller.reverse();
              setState(() => _isPressed = false);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: widget.enabled ? AppColors.primaryGradient : null,
                color: widget.enabled ? null : AppColors.inactive,
                borderRadius: BorderRadius.circular(18),
                boxShadow: widget.enabled
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withOpacity(_isPressed ? 0.5 : 0.3),
                          blurRadius: _isPressed ? 28 : 22,
                          offset: const Offset(0, 8),
                          spreadRadius: _isPressed ? 1 : 0,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    widget.text,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Premium Text Field ──────────────────────────────────────────────────────
class PremiumTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData icon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const PremiumTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    required this.icon,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
  });

  @override
  State<PremiumTextField> createState() => _PremiumTextFieldState();
}

class _PremiumTextFieldState extends State<PremiumTextField> {
  bool _obscure = true;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _focused ? AppColors.gold : AppColors.cardBorder,
              width: _focused ? 1.5 : 1,
            ),
            boxShadow: _focused
                ? [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.textPrimary.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Focus(
            onFocusChange: (f) => setState(() => _focused = f),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword && _obscure,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                prefixIcon: Container(
                  margin: const EdgeInsets.only(left: 14, right: 10),
                  child: Icon(
                    widget.icon,
                    color: _focused ? AppColors.gold : AppColors.textMuted,
                    size: 20,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      )
                    : null,
                hintText: widget.hint ?? widget.label,
                hintStyle: GoogleFonts.outfit(
                  color: AppColors.textMuted.withOpacity(0.6),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                errorStyle: GoogleFonts.outfit(
                  color: AppColors.error,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Premium Card ────────────────────────────────────────────────────────────
class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;
  final bool glow;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.glow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: glow ? AppColors.gold.withOpacity(0.2) : AppColors.cardBorder.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(glow ? 0.12 : 0.06),
            blurRadius: glow ? 24 : 16,
            offset: const Offset(0, 6),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─── Floating Salon Element (3D-like animated) ───────────────────────────────
class FloatingSalonElement extends StatelessWidget {
  final AnimationController controller;
  final IconData icon;
  final double size;
  final double top;
  final double? left;
  final double? right;
  final double phaseOffset;
  final Color color;

  const FloatingSalonElement({
    super.key,
    required this.controller,
    required this.icon,
    this.size = 40,
    this.top = 0,
    this.left,
    this.right,
    this.phaseOffset = 0,
    this.color = AppColors.gold,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final phase = (controller.value * 2 * math.pi) + phaseOffset;
          final yOffset = math.sin(phase) * 12;
          final rotation = math.sin(phase * 0.5) * 0.15;
          final scale = 1.0 + math.sin(phase * 0.7) * 0.05;

          return Transform.translate(
            offset: Offset(0, yOffset),
            child: Transform.rotate(
              angle: rotation,
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(size * 0.3),
                    border: Border.all(
                      color: color.withOpacity(0.15),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: color.withOpacity(0.35),
                    size: size * 0.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Animated Gradient Orb ──────────────────────────────────────────────────
class AnimatedGradientOrb extends StatelessWidget {
  final AnimationController controller;
  final double size;
  final Color color;
  final Alignment alignment;
  final double phaseOffset;

  const AnimatedGradientOrb({
    super.key,
    required this.controller,
    this.size = 200,
    this.color = AppColors.gold,
    this.alignment = Alignment.topRight,
    this.phaseOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final phase = (controller.value * 2 * math.pi) + phaseOffset;
        final dx = math.sin(phase) * 20;
        final dy = math.cos(phase) * 15;
        final scaleVal = 1.0 + math.sin(phase * 0.5) * 0.1;

        return Transform.translate(
          offset: Offset(dx, dy),
          child: Transform.scale(
            scale: scaleVal,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(0.15),
                    color.withOpacity(0.05),
                    color.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Section Header Widget ──────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.gold, size: 16),
            ),
            const SizedBox(width: 10),
          ],
          Text(
            title,
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          if (actionText != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionText!,
                style: GoogleFonts.outfit(
                  color: AppColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Premium Page Transition ─────────────────────────────────────────────────
class PremiumPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  PremiumPageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0.08, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
        );
}

// ─── Shimmer Loading Effect ──────────────────────────────────────────────────
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(1.0 + 2.0 * _controller.value, 0),
              colors: const [
                Color(0xFFE8EEFF),
                Color(0xFFF8FBFF),
                Color(0xFFE8EEFF),
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
