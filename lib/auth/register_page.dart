import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/premium_widgets.dart';
import 'auth_background.dart';

class RegisterPage extends StatefulWidget {
  final String role;
  const RegisterPage({super.key, required this.role});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please agree to Terms & Conditions',
            style: GoogleFonts.outfit(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Replace with Supabase registration
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                'Account created successfully!',
                style: GoogleFonts.outfit(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: AppColors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) Navigator.pop(context);
      });
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

              const SizedBox(height: 28),

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
                  isCustomer ? Icons.person_add_outlined : Icons.add_business_outlined,
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
                "Create Account",
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
                    "Join as ${widget.role}",
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

              const SizedBox(height: 32),

              // ── Form Fields ────────────────────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    PremiumTextField(
                      controller: _nameController,
                      label: "Full Name",
                      hint: "Enter your full name",
                      icon: Icons.person_outline,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Name is required';
                        if (v.trim().length < 2) return 'At least 2 characters';
                        return null;
                      },
                    ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: 0.08, end: 0),

                    const SizedBox(height: 18),

                    PremiumTextField(
                      controller: _emailController,
                      label: "Email Address",
                      hint: "Enter your email",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email is required';
                        if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
                        return null;
                      },
                    ).animate().fadeIn(delay: 600.ms, duration: 400.ms).slideY(begin: 0.08, end: 0),

                    const SizedBox(height: 18),

                    PremiumTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      hint: "07X XXX XXXX",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Phone is required';
                        return null;
                      },
                    ).animate().fadeIn(delay: 700.ms, duration: 400.ms).slideY(begin: 0.08, end: 0),

                    const SizedBox(height: 18),

                    PremiumTextField(
                      controller: _passwordController,
                      label: "Password",
                      hint: "Create a strong password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Password is required';
                        if (v.length < 6) return 'At least 6 characters';
                        return null;
                      },
                    ).animate().fadeIn(delay: 800.ms, duration: 400.ms).slideY(begin: 0.08, end: 0),

                    const SizedBox(height: 18),

                    PremiumTextField(
                      controller: _confirmPasswordController,
                      label: "Confirm Password",
                      hint: "Re-enter your password",
                      icon: Icons.lock_reset_outlined,
                      isPassword: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Please confirm password';
                        if (v != _passwordController.text) return 'Passwords don\'t match';
                        return null;
                      },
                    ).animate().fadeIn(delay: 900.ms, duration: 400.ms).slideY(begin: 0.08, end: 0),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Terms & Conditions ─────────────────────────────────────
              GestureDetector(
                onTap: () => setState(() => _agreeTerms = !_agreeTerms),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(
                        color: _agreeTerms ? AppColors.gold : Colors.transparent,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: _agreeTerms ? AppColors.gold : AppColors.cardBorder,
                          width: 1.5,
                        ),
                      ),
                      child: _agreeTerms
                          ? const Icon(Icons.check, color: Colors.white, size: 15)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(text: "I agree to the "),
                            TextSpan(
                              text: "Terms of Service",
                              style: GoogleFonts.outfit(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: GoogleFonts.outfit(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),

              const SizedBox(height: 28),

              // ── Sign Up Button ─────────────────────────────────────────
              PremiumButton(
                text: _isLoading ? "Creating Account..." : "Create Account",
                icon: _isLoading ? null : Icons.arrow_forward_rounded,
                enabled: !_isLoading,
                onPressed: _handleRegister,
              ).animate().fadeIn(delay: 1100.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 28),

              // ── Already Have Account ───────────────────────────────────
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: GoogleFonts.outfit(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Sign In",
                        style: GoogleFonts.outfit(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 1200.ms, duration: 400.ms),

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
