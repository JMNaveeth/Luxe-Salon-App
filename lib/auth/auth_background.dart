import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_colors.dart';

class AuthBackground extends StatefulWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _floatController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Animated Gradient Background ────────────────────────────────
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(
                      math.sin(_bgController.value * 2 * math.pi) * 0.5,
                      math.cos(_bgController.value * 2 * math.pi) * 0.5 - 1,
                    ),
                    end: Alignment(
                      math.cos(_bgController.value * 2 * math.pi) * 0.5,
                      math.sin(_bgController.value * 2 * math.pi) * 0.5 + 1,
                    ),
                    colors: const [
                      Color(0xFFF5F8FF),
                      Color(0xFFE5EEFF),
                      Color(0xFFDCE8FF),
                      Color(0xFFF0F4FF),
                    ],
                  ),
                ),
              );
            },
          ),

          // ── Gradient Orbs (3D depth effect) ────────────────────────────
          _AnimatedOrb(
            controller: _bgController,
            size: 350,
            color: const Color(0xFF5B8CFF),
            top: -120,
            right: -80,
            phaseOffset: 0,
          ),
          _AnimatedOrb(
            controller: _bgController,
            size: 300,
            color: const Color(0xFF6A5CFF),
            bottom: -60,
            left: -120,
            phaseOffset: math.pi * 0.7,
          ),
          _AnimatedOrb(
            controller: _bgController,
            size: 200,
            color: const Color(0xFF3FD1C1),
            top: 200,
            right: -60,
            phaseOffset: math.pi * 1.3,
          ),

          // ── Floating 3D Salon Elements ─────────────────────────────────
          _Floating3DElement(
            controller: _floatController,
            icon: Icons.content_cut,
            size: 52,
            top: 80,
            right: 30,
            phaseOffset: 0,
            rotationIntensity: 0.2,
          ),
          _Floating3DElement(
            controller: _floatController,
            icon: Icons.spa_outlined,
            size: 44,
            top: 180,
            left: 20,
            phaseOffset: math.pi * 0.6,
            rotationIntensity: 0.15,
          ),
          _Floating3DElement(
            controller: _floatController,
            icon: Icons.brush_outlined,
            size: 38,
            top: 350,
            right: 50,
            phaseOffset: math.pi * 1.2,
            rotationIntensity: 0.18,
          ),
          _Floating3DElement(
            controller: _floatController,
            icon: Icons.auto_awesome,
            size: 32,
            top: 500,
            left: 40,
            phaseOffset: math.pi * 0.3,
            rotationIntensity: 0.25,
          ),
          _Floating3DElement(
            controller: _floatController,
            icon: Icons.face_retouching_natural,
            size: 36,
            top: 650,
            right: 25,
            phaseOffset: math.pi * 1.5,
            rotationIntensity: 0.12,
          ),

          // ── Floating Particles ─────────────────────────────────────────
          ..._buildParticles(),

          // ── Pulse Ring (center decoration) ─────────────────────────────
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = 0.8 + _pulseController.value * 0.4;
                  final opacity = 0.08 - _pulseController.value * 0.05;
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.gold.withOpacity(opacity.clamp(0.0, 1.0)),
                          width: 1.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Glass Overlay ──────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.02),
                  Colors.white.withOpacity(0.08),
                ],
              ),
            ),
          ),

          // ── Content ────────────────────────────────────────────────────
          SafeArea(child: widget.child),
        ],
      ),
    );
  }

  List<Widget> _buildParticles() {
    final particles = <Widget>[];
    final rng = math.Random(42);
    for (int i = 0; i < 12; i++) {
      final top = rng.nextDouble() * 800;
      final left = rng.nextDouble() * 400;
      final size = 3.0 + rng.nextDouble() * 4;
      final delay = rng.nextDouble() * math.pi * 2;

      particles.add(
        Positioned(
          top: top,
          left: left,
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              final phase = (_floatController.value * 2 * math.pi) + delay;
              final y = math.sin(phase) * 8;
              final opacity = 0.1 + math.sin(phase * 0.5) * 0.08;
              return Transform.translate(
                offset: Offset(0, y),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(opacity.clamp(0.0, 1.0)),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    return particles;
  }
}

// ─── Animated Gradient Orb ──────────────────────────────────────────────────
class _AnimatedOrb extends StatelessWidget {
  final AnimationController controller;
  final double size;
  final Color color;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double phaseOffset;

  const _AnimatedOrb({
    required this.controller,
    required this.size,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.phaseOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final phase = (controller.value * 2 * math.pi) + phaseOffset;
          final dx = math.sin(phase) * 25;
          final dy = math.cos(phase) * 20;
          final scaleVal = 1.0 + math.sin(phase * 0.5) * 0.08;

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
                      color.withOpacity(0.18),
                      color.withOpacity(0.08),
                      color.withOpacity(0.02),
                      color.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.3, 0.6, 1.0],
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

// ─── Floating 3D Salon Element ──────────────────────────────────────────────
class _Floating3DElement extends StatelessWidget {
  final AnimationController controller;
  final IconData icon;
  final double size;
  final double? top;
  final double? left;
  final double? right;
  final double phaseOffset;
  final double rotationIntensity;

  const _Floating3DElement({
    required this.controller,
    required this.icon,
    required this.size,
    this.top,
    this.left,
    this.right,
    this.phaseOffset = 0,
    this.rotationIntensity = 0.15,
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
          final yOffset = math.sin(phase) * 15;
          final xOffset = math.cos(phase * 0.7) * 5;
          final rotation = math.sin(phase * 0.5) * rotationIntensity;
          final scale = 1.0 + math.sin(phase * 0.8) * 0.06;

          return Transform.translate(
            offset: Offset(xOffset, yOffset),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateY(rotation)
                ..rotateZ(rotation * 0.3),
              alignment: Alignment.center,
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(size * 0.28),
                    border: Border.all(
                      color: AppColors.gold.withOpacity(0.12),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 1,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.gold.withOpacity(0.4),
                    size: size * 0.45,
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
