import 'package:flutter/material.dart';

void main() {
  runApp(const SalonApp());
}

class SalonApp extends StatelessWidget {
  const SalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salon Onboarding',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        fontFamily: 'Georgia',
      ),
      home: const SalonDetailsScreen(),
    );
  }
}

class SalonDetailsScreen extends StatefulWidget {
  const SalonDetailsScreen({super.key});

  @override
  State<SalonDetailsScreen> createState() => _SalonDetailsScreenState();
}

class _SalonDetailsScreenState extends State<SalonDetailsScreen> {
  final _salonNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _salonNameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Top navigation row
                    Row(
                      children: [
                        _BackButton(),
                        const Expanded(
                          child: Center(
                            child: _StepIndicator(),
                          ),
                        ),
                        const SizedBox(width: 40), // balance the back button
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Title
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE8E8E8),
                          height: 1.2,
                        ),
                        children: [
                          TextSpan(text: 'Create your '),
                          TextSpan(
                            text: 'Legacy',
                            style: TextStyle(
                              color: Color(0xFFD4A843),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Tell us about your salon to begin your journey with\nour elite network.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF888888),
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Gallery Master Photo section
                    const _SectionLabel(text: 'GALLERY MASTER PHOTO'),
                    const SizedBox(height: 10),
                    _PhotoUploadBox(),

                    const SizedBox(height: 28),

                    // Salon Name
                    const _SectionLabel(text: 'SALON NAME'),
                    const SizedBox(height: 10),
                    _InputField(
                      controller: _salonNameController,
                      hintText: 'e.g. Maison de Luxe',
                      prefixIcon: Icons.storefront_outlined,
                    ),

                    const SizedBox(height: 20),

                    // Business Address
                    const _SectionLabel(text: 'BUSINESS ADDRESS'),
                    const SizedBox(height: 10),
                    _InputField(
                      controller: _addressController,
                      hintText: 'Street address, City, Zip',
                      prefixIcon: Icons.location_on_outlined,
                    ),

                    const SizedBox(height: 20),

                    // Contact Number
                    const _SectionLabel(text: 'CONTACT NUMBER'),
                    const SizedBox(height: 10),
                    _InputField(
                      controller: _contactController,
                      hintText: '+1 (555) 000-0000',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            _BottomCTA(),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.maybePop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: const Icon(
          Icons.chevron_left,
          color: Color(0xFFD4A843),
          size: 22,
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'STEP 1 OF 4',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 2,
            color: Color(0xFFD4A843),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'SALON DETAILS',
          style: TextStyle(
            fontSize: 13,
            letterSpacing: 3,
            color: Color(0xFFE8E8E8),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        // Progress bar
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (i) {
            return Container(
              width: i == 0 ? 24 : 16,
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: i == 0
                    ? const Color(0xFFD4A843)
                    : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        letterSpacing: 2,
        color: Color(0xFF888888),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _PhotoUploadBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF2A2A2A),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: const Icon(
                Icons.add,
                color: Color(0xFFD4A843),
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Upload primary salon image',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFCCCCCC),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'High resolution JPG or PNG',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFFE8E8E8),
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF444444),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: const Color(0xFF555555),
            size: 18,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class _BottomCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        border: Border(
          top: BorderSide(color: Color(0xFF1A1A1A)),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4A843), Color(0xFFB8861F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4A843).withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CONTINUE TO SERVICES',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: Color(0xFF0A0A0A),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF0A0A0A),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'SECURE ONBOARDING • POWERED BY ELITE SYSTEMS',
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 1.5,
              color: Color(0xFF3A3A3A),
            ),
          ),
        ],
      ),
    );
  }
}