import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../theme/app_colors.dart';
import 'auth_background.dart';
import 'login_page.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text(
              "Welcome to Luxe Salon",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),
            const SizedBox(height: 12),
            Text(
              "Please select your role to continue",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 800.ms).slideY(begin: 0.3, end: 0),
            const Spacer(),
            _RoleCard(
              title: "Customer",
              subtitle: "Book your favorite stylists",
              icon: Icons.person_outline,
              gradient: AppColors.primaryGradient,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage(role: "Customer")),
              ),
            ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2, end: 0),
            const SizedBox(height: 20),
            _RoleCard(
              title: "Shop Owner",
              subtitle: "Manage your salon efficiently",
              icon: Icons.storefront_outlined,
              gradient: const LinearGradient(
                colors: [Color(0xFF7C6CFF), Color(0xFFB06AB3)],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage(role: "Shop Owner")),
              ),
            ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.2, end: 0),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  double _rotationX = 0;
  double _rotationY = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _rotationY += details.delta.dx / 100;
          _rotationX -= details.delta.dy / 100;
          _rotationX = _rotationX.clamp(-0.2, 0.2);
          _rotationY = _rotationY.clamp(-0.2, 0.2);
        });
      },
      onPanEnd: (_) {
        setState(() {
          _rotationX = 0;
          _rotationY = 0;
        });
      },
      onTap: widget.onTap,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(_rotationX)
          ..rotateY(_rotationY),
        alignment: Alignment.center,
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 120,
          borderRadius: 24,
          blur: 20,
          alignment: Alignment.bottomCenter,
          border: 2,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.2),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: widget.gradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.gradient as LinearGradient).colors[0].withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        widget.subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: AppColors.gold, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
