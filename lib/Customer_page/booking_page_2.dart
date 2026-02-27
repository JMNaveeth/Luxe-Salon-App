import 'package:flutter/material.dart';

void main() => runApp(const CheckoutPaymentApp());

class CheckoutPaymentApp extends StatelessWidget {
  const CheckoutPaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure Checkout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
      ),
      home: const CheckoutPaymentPage(),
    );
  }
}

// ─── Palette ──────────────────────────────────────────────────────────────────
class AppColors {
  static const bg = Color(0xFF131309);
  static const surface = Color(0xFF1B1B10);
  static const card = Color(0xFF1E1E12);
  static const cardBorder = Color(0xFF2A2A18);
  static const gold = Color(0xFFD4A843);
  static const goldDim = Color(0xFF6B5218);
  static const textPrimary = Color(0xFFF5EDD6);
  static const textSecondary = Color(0xFF8A7A55);
  static const textMuted = Color(0xFF504530);
  static const divider = Color(0xFF222214);
  static const stepInactive = Color(0xFF2A2A1A);
}

// ─── Step State ───────────────────────────────────────────────────────────────
enum StepState { done, active, inactive }

// ─── Order Row Model ──────────────────────────────────────────────────────────
class OrderRow {
  final String name;
  final String sub;
  final double amount;
  const OrderRow(this.name, this.sub, this.amount);
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class CheckoutPaymentPage extends StatefulWidget {
  const CheckoutPaymentPage({super.key});

  @override
  State<CheckoutPaymentPage> createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
  int _selectedPayment = 0;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildStepIndicator(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildEliteCard(),
                          const SizedBox(height: 28),
                          _buildSectionLabel('Order Summary'),
                          const SizedBox(height: 14),
                          _buildOrderSummary(),
                          const SizedBox(height: 28),
                          _buildSectionLabel('Payment Method'),
                          const SizedBox(height: 14),
                          _buildPaymentOption(
                            index: 0,
                            icon: Icons.credit_card,
                            label: 'Credit Card',
                            sublabel: 'Ending in 8842',
                          ),
                          const SizedBox(height: 10),
                          _buildPaymentOption(
                            index: 1,
                            icon: Icons.apple,
                            label: 'Apple Pay',
                            sublabel: 'Tap to pay',
                          ),
                          const SizedBox(height: 110),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(),
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
      leading: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18),
      title: const Text(
        'Secure Checkout',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.bold,
          fontFamily: 'Georgia',
        ),
      ),
      centerTitle: true,
    );
  }

  // ── Step Indicator ───────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          _buildStep(number: 1, label: 'DETAILS', state: StepState.done),
          _buildStepLine(active: true),
          _buildStep(number: 2, label: 'PAYMENT', state: StepState.active),
          _buildStepLine(active: false),
          _buildStep(number: 3, label: 'CONFIRM', state: StepState.inactive),
        ],
      ),
    );
  }

  Widget _buildStep({required int number, required String label, required StepState state}) {
    final isDone = state == StepState.done;
    final isActive = state == StepState.active;
    final isInactive = state == StepState.inactive;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isInactive ? AppColors.stepInactive : AppColors.gold,
            border: Border.all(
              color: isInactive ? AppColors.cardBorder : AppColors.gold,
              width: 2,
            ),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, color: Colors.black, size: 16)
                : Text(
                    '$number',
                    style: TextStyle(
                      color: isInactive ? AppColors.textMuted : Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: isInactive ? AppColors.textMuted : AppColors.gold,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine({required bool active}) {
    return Expanded(
      child: Container(
        height: 1.5,
        margin: const EdgeInsets.only(bottom: 18),
        color: active ? AppColors.gold : AppColors.cardBorder,
      ),
    );
  }

  // ── Elite Rewards Card ────────────────────────────────────────────────────────
  Widget _buildEliteCard() {
    return Container(
      height: 155,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA07828), Color(0xFF7A5818), Color(0xFF4A3408)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            right: -10,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'ELITE REWARDS CARD',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 9,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Visa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: 34,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: const Icon(Icons.memory, color: Colors.white38, size: 16),
                ),
                const SizedBox(height: 10),
                const Text(
                  '★ ★ ★ ★    ★ ★ ★ ★    ★ ★ ★ ★    8 8 4 2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'CARD HOLDER',
                          style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 1),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'JULIANNE STERLING',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
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
                          'EXPIRY',
                          style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 1),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '09/27',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
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

  // ── Section Label ────────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 1.5,
          color: AppColors.gold,
          margin: const EdgeInsets.only(right: 8),
        ),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
      ],
    );
  }

  // ── Order Summary ────────────────────────────────────────────────────────────
  Widget _buildOrderSummary() {
    const rows = [
      OrderRow('The Gilded Touch Facial', '90 mins · Upper East Side', 185.00),
      OrderRow('Luxury Surcharge', '', 25.00),
      OrderRow('Service Fee', '', 12.50),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        children: [
          ...rows.asMap().entries.map((e) {
            final row = e.value;
            return Column(
              children: [
                if (e.key != 0)
                  Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              row.name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (row.sub.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                row.sub,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        '\$${row.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          Divider(height: 1, color: AppColors.cardBorder),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: const [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  '\$222.50',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Payment Option ────────────────────────────────────────────────────────────
  Widget _buildPaymentOption({
    required int index,
    required IconData icon,
    required String label,
    required String sublabel,
  }) {
    final selected = _selectedPayment == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected ? AppColors.gold.withOpacity(0.15) : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: selected ? AppColors.gold : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: selected ? AppColors.textPrimary : AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sublabel,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.gold : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.gold : AppColors.textSecondary,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.black, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Bar ────────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.info_outline, color: AppColors.textMuted, size: 13),
                SizedBox(width: 5),
                Text(
                  'Auto-renewing membership includes perks',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock_outline, color: Colors.black, size: 18),
                  SizedBox(width: 10),
                  Text(
                    'CONFIRM & PAY \$222.50',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}