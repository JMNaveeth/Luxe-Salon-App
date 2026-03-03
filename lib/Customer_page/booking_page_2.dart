import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'booking_page_1.dart'; // for ServiceModel, StaffModel

// ─── Color Palette (shared) ───────────────────────────────────────────────────
// Reuse AppColors from booking_page_1.dart or redefine here if standalone.
// For standalone use, AppColors is redefined below:
class _AppColors {
  static const bg = Color(0xFF0D0D08);
  static const surface = Color(0xFF161610);
  static const card = Color(0xFF1A1A12);
  static const cardBorder = Color(0xFF272718);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFE8C270);
  static const goldDim = Color(0xFF4A3A10);
  static const textPrimary = Color(0xFFF5EDD6);
  static const textSecondary = Color(0xFF8A7A55);
  static const textMuted = Color(0xFF4A4025);
  static const divider = Color(0xFF1E1E12);
  static const green = Color(0xFF5DBD7A);
  static const red = Color(0xFFE57373);
  static const stepInactive = Color(0xFF222215);
  static const stepDone = Color(0xFF2E4A2E);
}

enum _StepState { done, active, inactive }

// ─── Card Type ────────────────────────────────────────────────────────────────
enum CardType { visa, mastercard, amex, unknown }

CardType detectCardType(String number) {
  if (number.startsWith('4')) return CardType.visa;
  if (number.startsWith('5') || number.startsWith('2')) return CardType.mastercard;
  if (number.startsWith('3')) return CardType.amex;
  return CardType.unknown;
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class BookingPage2 extends StatefulWidget {
  final ServiceModel service;
  final StaffModel staff;
  final Map<String, String> date;
  final String time;

  const BookingPage2({
    super.key,
    required this.service,
    required this.staff,
    required this.date,
    required this.time,
  });

  @override
  State<BookingPage2> createState() => _BookingPage2State();
}

class _BookingPage2State extends State<BookingPage2>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _cardNumberCtrl = TextEditingController();
  final _cardNameCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  int _selectedPaymentTab = 0; // 0=card, 1=wallet
  CardType _cardType = CardType.unknown;
  bool _showCvv = false;
  bool _saveCard = true;

  late AnimationController _cardFlipCtrl;
  late Animation<double> _cardFlipAnim;

  @override
  void initState() {
    super.initState();
    _cardNumberCtrl.addListener(() {
      setState(() => _cardType = detectCardType(_cardNumberCtrl.text));
    });
    _cardFlipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _cardFlipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardFlipCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _noteCtrl.dispose();
    _cardNumberCtrl.dispose();
    _cardNameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _cardFlipCtrl.dispose();
    super.dispose();
  }

  String get _maskedCard {
    final raw = _cardNumberCtrl.text.replaceAll(' ', '');
    if (raw.isEmpty) return '•••• •••• •••• ••••';
    final padded = raw.padRight(16, '•');
    return '${padded.substring(0, 4)} ${padded.substring(4, 8)} '
        '${padded.substring(8, 12)} ${padded.substring(12, 16)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    _buildStepIndicator(),
                    const SizedBox(height: 20),
                    _buildBookingSummaryBanner(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Customer Details', Icons.person_outline),
                    const SizedBox(height: 14),
                    _buildCustomerForm(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Payment Method', Icons.credit_card_outlined),
                    const SizedBox(height: 14),
                    _buildPaymentTabs(),
                    const SizedBox(height: 16),
                    if (_selectedPaymentTab == 0) ...[
                      _buildCreditCardVisual(),
                      const SizedBox(height: 20),
                      _buildCardForm(),
                    ] else
                      _buildWalletOptions(),
                    const SizedBox(height: 110),
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
      backgroundColor: _AppColors.bg,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: _AppColors.textPrimary,
          size: 18,
        ),
      ),
      title: const Text(
        'Your Details',
        style: TextStyle(
          color: _AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.bold,
          fontFamily: 'Georgia',
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: _AppColors.divider, height: 1),
      ),
    );
  }

  // ── Step Indicator ───────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          _buildStep(1, 'BOOKING', _StepState.done),
          _buildStepLine(true),
          _buildStep(2, 'DETAILS', _StepState.active),
          _buildStepLine(false),
          _buildStep(3, 'CONFIRM', _StepState.inactive),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String label, _StepState state) {
    final isDone = state == _StepState.done;
    final isActive = state == _StepState.active;
    final isInactive = state == _StepState.inactive;

    Color circleBg = isInactive
        ? _AppColors.stepInactive
        : isDone
            ? _AppColors.green
            : _AppColors.gold;

    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleBg,
            border: Border.all(
              color: isInactive ? _AppColors.cardBorder : circleBg,
              width: 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: _AppColors.gold.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, color: Colors.black, size: 16)
                : Text(
                    '$number',
                    style: TextStyle(
                      color: isInactive ? _AppColors.textMuted : Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: isInactive ? _AppColors.textMuted : _AppColors.gold,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool active) {
    return Expanded(
      child: Container(
        height: 1.5,
        margin: const EdgeInsets.only(bottom: 18),
        color: active ? _AppColors.gold : _AppColors.cardBorder,
      ),
    );
  }

  // ── Booking Summary Banner ────────────────────────────────────────────────────
  Widget _buildBookingSummaryBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2A2010), Color(0xFF1A1408)],
          ),
          border: Border.all(color: _AppColors.goldDim, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _AppColors.goldDim,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.content_cut, color: _AppColors.gold, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.service.title,
                    style: const TextStyle(
                      color: _AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'with ${widget.staff.name}  •  ${widget.date['day']} ${widget.date['date']}  •  ${widget.time} PM',
                    style: const TextStyle(
                      color: _AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '\$${widget.service.price.toStringAsFixed(0)}',
              style: const TextStyle(
                color: _AppColors.gold,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section Header ───────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Icon(icon, color: _AppColors.gold, size: 16),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: _AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }

  // ── Customer Form ────────────────────────────────────────────────────────────
  Widget _buildCustomerForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _AppColors.cardBorder),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInputField(
                controller: _nameCtrl,
                label: 'Full Name',
                hint: 'Alexandra Dupont',
                icon: Icons.person_outline,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 14),
              _buildInputField(
                controller: _emailCtrl,
                label: 'Email Address',
                hint: 'hello@example.com',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              _buildInputField(
                controller: _phoneCtrl,
                label: 'Phone Number',
                hint: '+1 (555) 000 0000',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 14),
              _buildInputField(
                controller: _noteCtrl,
                label: 'Special Notes (optional)',
                hint: 'Allergies, preferences...',
                icon: Icons.notes_outlined,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(
            color: _AppColors.textPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: _AppColors.textMuted,
              fontSize: 13,
            ),
            prefixIcon: Icon(icon, color: _AppColors.textSecondary, size: 18),
            filled: true,
            fillColor: _AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _AppColors.gold, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ── Payment Tabs ─────────────────────────────────────────────────────────────
  Widget _buildPaymentTabs() {
    final tabs = [
      {'label': 'Card', 'icon': Icons.credit_card},
      {'label': 'Wallet', 'icon': Icons.account_balance_wallet_outlined},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _AppColors.cardBorder),
        ),
        child: Row(
          children: tabs.asMap().entries.map((e) {
            final i = e.key;
            final tab = e.value;
            final selected = _selectedPaymentTab == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedPaymentTab = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: selected ? _AppColors.gold : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tab['icon'] as IconData,
                        color: selected ? Colors.black : _AppColors.textSecondary,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tab['label'] as String,
                        style: TextStyle(
                          color: selected ? Colors.black : _AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Credit Card Visual ───────────────────────────────────────────────────────
  Widget _buildCreditCardVisual() {
    Color c1, c2, c3;
    String networkLabel;
    Widget networkBadge;

    switch (_cardType) {
      case CardType.mastercard:
        c1 = const Color(0xFF1A1050);
        c2 = const Color(0xFF2A1840);
        c3 = const Color(0xFF0D0820);
        networkLabel = 'MASTERCARD';
        networkBadge = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEB001B),
              ),
            ),
            Transform.translate(
              offset: const Offset(-8, 0),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF79E1B).withOpacity(0.9),
                ),
              ),
            ),
          ],
        );
        break;
      case CardType.amex:
        c1 = const Color(0xFF003087);
        c2 = const Color(0xFF002060);
        c3 = const Color(0xFF001040);
        networkLabel = 'AMEX';
        networkBadge = Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'AMEX',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        );
        break;
      default: // visa
        c1 = const Color(0xFFB8922E);
        c2 = const Color(0xFF7A5818);
        c3 = const Color(0xFF3A2808);
        networkLabel = 'VISA';
        networkBadge = const Text(
          'VISA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: 1,
          ),
        );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        height: 185,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [c1, c2, c3],
          ),
          boxShadow: [
            BoxShadow(
              color: c1.withOpacity(0.5),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -20,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            // Card content
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Chip
                      Container(
                        width: 38,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.35),
                              Colors.white.withOpacity(0.15),
                            ],
                          ),
                        ),
                        child: GridView.count(
                          crossAxisCount: 2,
                          padding: const EdgeInsets.all(4),
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(
                            4,
                            (_) => Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // NFC icon
                      Icon(
                        Icons.wifi,
                        color: Colors.white.withOpacity(0.5),
                        size: 22,
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Card number
                  Text(
                    _maskedCard,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.5,
                      fontFamily: 'Courier',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Bottom row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CARD HOLDER',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 8,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _cardNameCtrl.text.isEmpty
                                ? 'YOUR NAME'
                                : _cardNameCtrl.text.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'EXPIRES',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 8,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _expiryCtrl.text.isEmpty
                                ? 'MM/YY'
                                : _expiryCtrl.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      networkBadge,
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Card Type Chips ───────────────────────────────────────────────────────────
  Widget _buildCardTypeChips() {
    final types = [
      {'label': 'Visa', 'color': const Color(0xFF1A4A8A)},
      {'label': 'Mastercard', 'color': const Color(0xFF3A1A5A)},
      {'label': 'Amex', 'color': const Color(0xFF1A3A7A)},
    ];
    return Row(
      children: types.map((t) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: (t['color'] as Color).withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (t['color'] as Color).withOpacity(0.4),
            ),
          ),
          child: Text(
            t['label'] as String,
            style: const TextStyle(
              color: _AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Card Form ────────────────────────────────────────────────────────────────
  Widget _buildCardForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accepted card chips
            Row(
              children: [
                const Text(
                  'Accepted: ',
                  style: TextStyle(
                    color: _AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                _buildCardTypeChips(),
              ],
            ),
            const SizedBox(height: 18),

            // Card number
            const Text(
              'Card Number',
              style: TextStyle(
                color: _AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 7),
            TextFormField(
              controller: _cardNumberCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CardNumberFormatter(),
              ],
              maxLength: 19,
              style: const TextStyle(
                color: _AppColors.textPrimary,
                fontSize: 16,
                letterSpacing: 1.5,
                fontFamily: 'Courier',
              ),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: '0000 0000 0000 0000',
                hintStyle: const TextStyle(
                  color: _AppColors.textMuted,
                  fontSize: 14,
                  letterSpacing: 1,
                  fontFamily: 'Courier',
                ),
                counterText: '',
                prefixIcon: const Icon(
                  Icons.credit_card_outlined,
                  color: _AppColors.textSecondary,
                  size: 18,
                ),
                suffixIcon: _cardType != CardType.unknown
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.verified,
                          color: _AppColors.gold,
                          size: 18,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: _AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: _AppColors.gold, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Card holder name
            const Text(
              'Cardholder Name',
              style: TextStyle(
                color: _AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 7),
            TextFormField(
              controller: _cardNameCtrl,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(
                color: _AppColors.textPrimary,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'AS ON CARD',
                hintStyle: const TextStyle(
                  color: _AppColors.textMuted,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
                prefixIcon: const Icon(Icons.badge_outlined,
                    color: _AppColors.textSecondary, size: 18),
                filled: true,
                fillColor: _AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: _AppColors.gold, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Expiry & CVV row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Expiry Date',
                        style: TextStyle(
                          color: _AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _expiryCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _ExpiryFormatter(),
                        ],
                        maxLength: 5,
                        style: const TextStyle(
                          color: _AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'MM / YY',
                          counterText: '',
                          hintStyle: const TextStyle(
                            color: _AppColors.textMuted,
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(Icons.date_range_outlined,
                              color: _AppColors.textSecondary, size: 18),
                          filled: true,
                          fillColor: _AppColors.surface,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _AppColors.cardBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _AppColors.cardBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: _AppColors.gold, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CVV / CVC',
                        style: TextStyle(
                          color: _AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _cvvCtrl,
                        keyboardType: TextInputType.number,
                        obscureText: !_showCvv,
                        maxLength: 4,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          color: _AppColors.textPrimary,
                          fontSize: 14,
                          letterSpacing: 3,
                        ),
                        decoration: InputDecoration(
                          hintText: '•••',
                          counterText: '',
                          hintStyle: const TextStyle(
                            color: _AppColors.textMuted,
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: _AppColors.textSecondary, size: 18),
                          suffixIcon: GestureDetector(
                            onTap: () =>
                                setState(() => _showCvv = !_showCvv),
                            child: Icon(
                              _showCvv
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: _AppColors.textMuted,
                              size: 18,
                            ),
                          ),
                          filled: true,
                          fillColor: _AppColors.surface,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _AppColors.cardBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _AppColors.cardBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: _AppColors.gold, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Save card toggle
            GestureDetector(
              onTap: () => setState(() => _saveCard = !_saveCard),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: _saveCard ? _AppColors.gold : Colors.transparent,
                      border: Border.all(
                        color: _saveCard
                            ? _AppColors.gold
                            : _AppColors.textSecondary,
                        width: 1.5,
                      ),
                    ),
                    child: _saveCard
                        ? const Icon(Icons.check,
                            color: Colors.black, size: 13)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Save card for future bookings',
                    style: TextStyle(
                      color: _AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.shield_outlined,
                      color: _AppColors.textMuted, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Wallet Options ────────────────────────────────────────────────────────────
  Widget _buildWalletOptions() {
    final options = [
      {
        'label': 'Apple Pay',
        'sub': 'Pay with Touch ID or Face ID',
        'icon': Icons.apple,
        'color': const Color(0xFF1A1A2A),
      },
      {
        'label': 'Google Pay',
        'sub': 'Pay with your Google account',
        'icon': Icons.g_mobiledata,
        'color': const Color(0xFF1A2A1A),
      },
      {
        'label': 'PayPal',
        'sub': 'Fast & secure wallet payment',
        'icon': Icons.account_balance_wallet_outlined,
        'color': const Color(0xFF1A1A3A),
      },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: options.map((o) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (o['color'] as Color),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    o['icon'] as IconData,
                    color: _AppColors.textPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        o['label'] as String,
                        style: const TextStyle(
                          color: _AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        o['sub'] as String,
                        style: const TextStyle(
                          color: _AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: _AppColors.textMuted,
                  size: 14,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Bottom Bar ────────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    final total = widget.service.price + 12.50;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 36),
      decoration: BoxDecoration(
        color: _AppColors.bg,
        border: Border(
            top: BorderSide(color: _AppColors.divider, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.lock, color: _AppColors.textMuted, size: 12),
              const SizedBox(width: 5),
              const Text(
                'Secured by 256-bit SSL encryption',
                style: TextStyle(color: _AppColors.textMuted, fontSize: 11),
              ),
              const Spacer(),
              Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: _AppColors.gold,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // Navigate to confirmation page (step 3)
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_AppColors.goldLight, _AppColors.gold],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _AppColors.gold.withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline,
                      color: Colors.black, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    'CONFIRM & PAY \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
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

// ─── Text Input Formatters ────────────────────────────────────────────────────
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final result = buffer.toString();
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('/', '');
    if (text.length <= 2) return newValue.copyWith(text: text);
    final result = '${text.substring(0, 2)}/${text.substring(2)}';
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}