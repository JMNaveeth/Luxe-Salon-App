import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_colors.dart';

class AuthBackground extends StatefulWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Gradient Background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(
                      math.sin(_controller.value * 2 * math.pi) * 0.5,
                      math.cos(_controller.value * 2 * math.pi) * 0.5 - 1,
                    ),
                    end: Alignment(
                      math.cos(_controller.value * 2 * math.pi) * 0.5,
                      math.sin(_controller.value * 2 * math.pi) * 0.5 + 1,
                    ),
                    colors: [
                      AppColors.bg,
                      const Color(0xFFDCE8FF),
                      const Color(0xFFF0F4FF),
                      AppColors.white,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Floating 3D-like Blobs
          Positioned(
            top: -100,
            right: -50,
            child: _AnimatedBlob(
              controller: _controller,
              color: AppColors.primaryGradient.colors[0].withOpacity(0.3),
              size: 300,
              offsetMultiplier: 0.2,
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: _AnimatedBlob(
              controller: _controller,
              color: AppColors.primaryGradient.colors[1].withOpacity(0.2),
              size: 400,
              offsetMultiplier: -0.15,
            ),
          ),
          
          // Glass Overlay
          Container(
            color: Colors.white.withOpacity(0.1),
          ),
          
          // Content
          SafeArea(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

class _AnimatedBlob extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final double size;
  final double offsetMultiplier;

  const _AnimatedBlob({
    required this.controller,
    required this.color,
    required this.size,
    required this.offsetMultiplier,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double offset = math.sin(controller.value * 2 * math.pi) * 50 * offsetMultiplier;
        return Transform.translate(
          offset: Offset(offset, -offset),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 100,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
