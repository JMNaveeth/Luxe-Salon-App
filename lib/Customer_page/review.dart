import 'package:flutter/material.dart';

void main() => runApp(const FeedbackApp());

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Georgia',
      ),
      home: const FeedbackPage(),
    );
  }
}

// ─── Palette ──────────────────────────────────────────────────────────────────
class AppColors {
  static const bg = Color(0xFF131309);
  static const surface = Color(0xFF1C1C10);
  static const card = Color(0xFF1E1E12);
  static const cardBorder = Color(0xFF2A2A18);
  static const gold = Color(0xFFD4A843);
  static const goldDim = Color(0xFF6B5218);
  static const goldFaint = Color(0xFF26200A);
  static const textPrimary = Color(0xFFF5EDD6);
  static const textSecondary = Color(0xFF8A7A55);
  static const textMuted = Color(0xFF504530);
  static const inputBg = Color(0xFF1A1A0E);
  static const inputBorder = Color(0xFF2E2E18);
  static const chipSelected = Color(0xFF2E2810);
  static const chipUnselected = Color(0xFF1A1A0E);
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _rating = 4; // 4 stars selected by default
  final TextEditingController _reviewController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<String> _tags = [
    'Professionalism',
    'Cleanliness',
    'Style',
    'Value',
    'Punctuality',
  ];

  final Set<String> _selectedTags = {'Professionalism', 'Style'};

  @override
  void dispose() {
    _reviewController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  // ── Hero Section ──────────────────────────────────────────────────────────────
  Widget _buildHeroSection() {
    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background photo
          Image.network(
            'https://images.unsplash.com/photo-1605497788044-5a32c7078486?w=600',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.surface,
              child: const Center(
                child: Icon(Icons.person, color: AppColors.gold, size: 80),
              ),
            ),
          ),
          // Dark gradient overlay — top and bottom
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.55),
                  Colors.transparent,
                  Colors.transparent,
                  AppColors.bg.withOpacity(0.95),
                ],
                stops: const [0.0, 0.25, 0.55, 1.0],
              ),
            ),
          ),
          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 18),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'FEEDBACK',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 36), // balance
                  ],
                ),
              ),
            ),
          ),
          // Name + title at bottom of hero
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'Julian Harrison',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Master Stylist',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '  ·  ',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                    ),
                    Text(
                      'Maison de Luxe',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Content Section ───────────────────────────────────────────────────────────
  Widget _buildContentSection() {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rate your experience
          _buildSectionLabel('RATE YOUR EXPERIENCE'),
          const SizedBox(height: 14),
          _buildStarRating(),
          const SizedBox(height: 24),
          // Review text input
          _buildReviewInput(),
          const SizedBox(height: 28),
          // What did you love most
          _buildSectionLabel('WHAT DID YOU LOVE MOST?'),
          const SizedBox(height: 14),
          _buildTagChips(),
          const SizedBox(height: 32),
          // Submit button
          _buildSubmitButton(),
          const SizedBox(height: 14),
          // Disclaimer
          const Center(
            child: Text(
              'Your review will be shared publicly on the stylist\'s profile to help\nother clients make informed decisions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Label ─────────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
      ),
    );
  }

  // ── Star Rating ───────────────────────────────────────────────────────────────
  Widget _buildStarRating() {
    return Row(
      children: List.generate(5, (i) {
        final filled = i < _rating;
        return GestureDetector(
          onTap: () => setState(() => _rating = i + 1),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                filled ? Icons.star : Icons.star_border,
                key: ValueKey('$i-$filled'),
                color: filled ? AppColors.gold : AppColors.textMuted,
                size: 36,
              ),
            ),
          ),
        );
      }),
    );
  }

  // ── Review Input ──────────────────────────────────────────────────────────────
  Widget _buildReviewInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: TextField(
        controller: _reviewController,
        focusNode: _focusNode,
        maxLines: 5,
        minLines: 4,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 13,
          height: 1.6,
        ),
        decoration: const InputDecoration(
          hintText:
              'Share your thoughts about the service, the atmosphere, or anything else you\'d like us to know...',
          hintStyle: TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
            height: 1.6,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        cursorColor: AppColors.gold,
        onTap: () => setState(() {}),
      ),
    );
  }

  // ── Tag Chips ─────────────────────────────────────────────────────────────────
  Widget _buildTagChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _tags.map((tag) {
        final selected = _selectedTags.contains(tag);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (selected) {
                _selectedTags.remove(tag);
              } else {
                _selectedTags.add(tag);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color:
                  selected ? AppColors.chipSelected : AppColors.chipUnselected,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected
                    ? AppColors.gold.withOpacity(0.6)
                    : AppColors.inputBorder,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tag,
                  style: TextStyle(
                    color: selected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: 5),
                  const Icon(Icons.check, color: AppColors.gold, size: 14),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Submit Button ─────────────────────────────────────────────────────────────
  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () => _handleSubmit(),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'SUBMIT REVIEW',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.card,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: const [
            Icon(Icons.check_circle_outline, color: AppColors.gold, size: 20),
            SizedBox(width: 10),
            Text(
              'Thank you! Review submitted.',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}