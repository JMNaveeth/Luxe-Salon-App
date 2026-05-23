import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/premium_widgets.dart';
import '../Customer_page/home page/customer_home.dart';
import '../shop_owner_page/sh_ow_home.dart';
import 'auth_background.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final String role;
  const LoginPage({super.key, required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // TODO: Replace with Supabase auth
    setState(() => _isLoading = true);

    // Simulate login delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Navigate based on role
      Widget destination;
      if (widget.role == "Customer") {
        destination = const HomeScreen();
      } else {
        destination = const DashboardPage();
      }

      Navigator.pushAndRemoveUntil(
        context,
        PremiumPageRoute(page: destination),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCustomer = widget.role == "Customer";

    return AuthBackground(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ── Back Button ────────────────────────────────────────────
              _buildBackButton()
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: -0.3, end: 0),

              const SizedBox(height: 32),

              // ── Role Icon ──────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: isCustomer
                      ? AppColors.primaryGradient
                      : const LinearGradient(
                          colors: [Color(0xFF7C6CFF), Color(0xFFB06AB3)],
                        ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: (isCustomer
                              ? AppColors.gold
                              : const Color(0xFF7C6CFF))
                          .withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  isCustomer ? Icons.person_outline : Icons.storefront_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 500.ms).scale(
                    begin: const Offset(0.7, 0.7),
                    curve: Curves.easeOutBack,
                  ),

              const SizedBox(height: 24),

              // ── Title ──────────────────────────────────────────────────
              Text(
                "Welcome Back",
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(begin: 0.15, end: 0),

              const SizedBox(height: 6),

              Row(
                children: [
                  Text(
                    "${widget.role} Sign In",
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 24,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(begin: 0.15, end: 0),

              const SizedBox(height: 40),

              // ── Form ───────────────────────────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    PremiumTextField(
                      controller: _emailController,
                      label: "Email Address",
                      hint: "Enter your email",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 20),

                    PremiumTextField(
                      controller: _passwordController,
                      label: "Password",
                      hint: "Enter your password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Password is required';
                        if (v.length < 6) return 'At least 6 characters';
                        return null;
                      },
                    ).animate().fadeIn(delay: 600.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── Remember Me & Forgot Password ──────────────────────────
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _rememberMe ? AppColors.gold : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _rememberMe ? AppColors.gold : AppColors.cardBorder,
                              width: 1.5,
                            ),
                          ),
                          child: _rememberMe
                              ? const Icon(Icons.check, color: Colors.white, size: 14)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Remember me",
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // TODO: Forgot password flow
                    },
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.outfit(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 700.ms, duration: 400.ms),

              const SizedBox(height: 32),

              // ── Login Button ───────────────────────────────────────────
              PremiumButton(
                text: _isLoading ? "Signing In..." : "Sign In",
                icon: _isLoading ? null : Icons.login_rounded,
                enabled: !_isLoading,
                onPressed: _handleLogin,
              ).animate().fadeIn(delay: 800.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 24),

              // ── Divider ────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.cardBorder,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "or",
                      style: GoogleFonts.outfit(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.cardBorder,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 900.ms, duration: 400.ms),

              const SizedBox(height: 24),

              // ── Social Login Buttons ───────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _SocialButton(
                      icon: Icons.g_mobiledata_rounded,
                      label: "Google",
                      onTap: () {
                        // TODO: Google sign in
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _SocialButton(
                      icon: Icons.apple,
                      label: "Apple",
                      onTap: () {
                        // TODO: Apple sign in
                      },
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 1000.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 32),

              // ── Sign Up Link ───────────────────────────────────────────
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.outfit(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PremiumPageRoute(page: RegisterPage(role: widget.role)),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.outfit(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 1100.ms, duration: 400.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.textPrimary,
          size: 18,
        ),
      ),
    );
  }
}

// ─── Social Login Button ────────────────────────────────────────────────────
class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
