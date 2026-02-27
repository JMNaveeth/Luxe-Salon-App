import 'package:flutter/material.dart';

void main() => runApp(const CheckoutApp());

class CheckoutApp extends StatelessWidget {
  const CheckoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure Checkout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Georgia',
      ),
      home: const SecureCheckoutPage(),
    );
  }
}

// ─── Palette ──────────────────────────────────────────────────────────────────
class AppColors {
  static const bg = Color(0xFF151510);
  static const surface = Color(0xFF1E1E14);
  static const card = Color(0xFF232318);
  static const cardBorder = Color(0xFF2E2E1E);
  static const gold = Color(0xFFD4A843);
  static const goldDark = Color(0xFFB8922E);
  static const goldDim = Color(0xFF5A4A1A);
  static const textPrimary = Color(0xFFF5EDD6);
  static const textSecondary = Color(0xFF8A7A55);
  static const textMuted = Color(0xFF5A5035);
  static const green = Color(0xFF4CAF50);
  static const red = Color(0xFFE57373);
  static const divider = Color(0xFF252515);

  // Credit card gradient
  static const cardGradientStart = Color(0xFFB8922E);
  static const cardGradientEnd = Color(0xFF6B5015);
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class SecureCheckoutPage extends StatefulWidget {
  const SecureCheckoutPage({super.key});

  @override
  State<SecureCheckoutPage> createState() => _SecureCheckoutPageState();
}

class _SecureCheckoutPageState extends State<SecureCheckoutPage> {
  bool _loyaltyEnabled = true;
  int _selectedCard = 0; // 0 = Visa 8824, 1 = Mastercard 1092

  final double _subtotal = 150.00;
  final double _loyaltyDiscount = -25.00;
  final double _taxFees = 12.50;

  double get _total => _subtotal + (_loyaltyEnabled ? _loyaltyDiscount : 0) + _taxFees;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildSectionLabel('Booking Summary'),
                      const SizedBox(height: 12),
                      _buildBookingSummaryCard(),
                      const SizedBox(height: 16),
                      _buildLoyaltyCard(),
                      const SizedBox(height: 24),
                      _buildPaymentMethodHeader(),
                      const SizedBox(height: 14),
                      _buildCreditCardVisual(),
                      const SizedBox(height: 14),
                      _buildCardOption(
                        index: 0,
                        label: 'Visa ending in 8824',
                        sublabel: 'Primary Method',
                        icon: Icons.credit_card,
                      ),
                      _buildCardOption(
                        index: 1,
                        label: 'Mastercard ending in 1092',
                        sublabel: 'Personal Card',
                        icon: Icons.credit_card_outlined,
                      ),
                      const SizedBox(height: 24),
                      _buildPriceSummary(),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomButton(),
          ),
        ],
      ),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.bg,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {},
        child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18),
      ),
      title: const Text(
        'Secure Checkout',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  // ── Section Label ────────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // ── Booking Summary Card ──────────────────────────────────────────────────────
  Widget _buildBookingSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SIGNATURE TREATMENT',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Elite Hair Sculpting',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'with Senior Stylist Marco',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: 13),
                    SizedBox(width: 5),
                    Text(
                      'Oct 24, 2023 at 2:30 PM',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://images.unsplash.com/photo-1560066984-138daaa0f4f4?w=200',
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: AppColors.surface,
                child: const Icon(Icons.spa, color: AppColors.gold, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Loyalty Points Card ──────────────────────────────────────────────────────
  Widget _buildLoyaltyCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.stars_outlined, color: AppColors.gold, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Loyalty Points',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Use 598 points for \$25.00 discount',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          _buildToggle(),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return GestureDetector(
      onTap: () => setState(() => _loyaltyEnabled = !_loyaltyEnabled),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          color: _loyaltyEnabled ? AppColors.gold : AppColors.textMuted,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: _loyaltyEnabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  // ── Payment Method Header ─────────────────────────────────────────────────────
  Widget _buildPaymentMethodHeader() {
    return Row(
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: const [
              Icon(Icons.add, color: AppColors.gold, size: 16),
              SizedBox(width: 3),
              Text(
                'Add Card',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Credit Card Visual ────────────────────────────────────────────────────────
  Widget _buildCreditCardVisual() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB8922E),
            Color(0xFF8A6A1A),
            Color(0xFF5A4010),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle top-left
          Positioned(
            top: -30,
            left: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 40,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Chip icon
                    Container(
                      width: 36,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: const Icon(Icons.memory, color: Colors.white54, size: 18),
                    ),
                    const Spacer(),
                    const Text(
                      'VISA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Card number
                const Text(
                  'CARD NUMBER',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 9,
                    letterSpacing: 1,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '• • • •    • • • •    • • • •    8 8 2 4',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'CARD HOLDER',
                          style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'ALEXANDER DUPONT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'EXPIRES',
                          style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '09 / 26',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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

  // ── Card Option Row ───────────────────────────────────────────────────────────
  Widget _buildCardOption({
    required int index,
    required String label,
    required String sublabel,
    required IconData icon,
  }) {
    final selected = _selectedCard == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedCard = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.cardBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.gold : AppColors.textSecondary,
                  width: 2,
                ),
                color: selected ? AppColors.gold : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.black, size: 12)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: selected ? AppColors.textPrimary : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sublabel,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                  ),
                ],
              ),
            ),
            const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }

  // ── Price Summary ─────────────────────────────────────────────────────────────
  Widget _buildPriceSummary() {
    return Column(
      children: [
        _buildPriceRow('Service Subtotal', '\$${_subtotal.toStringAsFixed(2)}', highlight: false),
        const SizedBox(height: 10),
        if (_loyaltyEnabled)
          _buildPriceRow(
            'Loyalty Discount',
            '-\$${_loyaltyDiscount.abs().toStringAsFixed(2)}',
            highlight: false,
            valueColor: AppColors.green,
          ),
        if (_loyaltyEnabled) const SizedBox(height: 10),
        _buildPriceRow('Tax & Fees', '\$${_taxFees.toStringAsFixed(2)}', highlight: false),
        const SizedBox(height: 16),
        Divider(color: AppColors.divider),
        const SizedBox(height: 12),
        _buildPriceRow(
          'Total Amount',
          '\$${_total.toStringAsFixed(2)}',
          highlight: true,
        ),
      ],
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    required bool highlight,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: highlight ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: highlight ? 16 : 13,
            fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: highlight
                ? AppColors.gold
                : (valueColor ?? AppColors.textPrimary),
            fontSize: highlight ? 22 : 13,
            fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
            fontStyle: highlight ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ],
    );
  }

  // ── Bottom Confirm Button ─────────────────────────────────────────────────────
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, color: Colors.black, size: 18),
              const SizedBox(width: 10),
              Text(
                'Confirm & Pay \$${_total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}