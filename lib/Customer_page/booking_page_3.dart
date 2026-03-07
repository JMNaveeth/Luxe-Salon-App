import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'booking_page_1.dart';
import 'bottom_nav.dart';

// ─── Color Palette ────────────────────────────────────────────────────────────
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
  static const stepInactive = Color(0xFF222215);
}

enum _StepState { done, active, inactive }

// ─── Sri Lanka Bank Enum ──────────────────────────────────────────────────────
enum SLBank {
  boc,
  peoples,
  amana,
  commercial,
  sampath,
  hatton,
  nsb,
  dfcc,
  seylan,
  ndb,
  other,
}

// ─── Bank Theme Model ─────────────────────────────────────────────────────────
class SLBankTheme {
  final SLBank bank;
  final String name;
  final String shortName;
  final List<Color> gradientColors;
  final Color accentColor;
  final bool isMastercard;

  // BIN prefixes — SORTED longest→shortest so longest match wins
  // Each entry: digits only, no spaces
  final List<String> prefixes;

  const SLBankTheme({
    required this.bank,
    required this.name,
    required this.shortName,
    required this.gradientColors,
    required this.accentColor,
    required this.isMastercard,
    required this.prefixes,
  });
}

// ─── Bank Definitions ─────────────────────────────────────────────────────────
// IMPORTANT: within each bank, longer prefixes come FIRST.
// The detector tries longest prefix first to avoid false short-prefix matches.
const List<SLBankTheme> kSLBankThemes = [
  // ── 1. Bank of Ceylon ── green + gold ─────────────────────────────────────
  SLBankTheme(
    bank: SLBank.boc,
    name: 'Bank of Ceylon',
    shortName: 'BOC',
    gradientColors: [Color(0xFF1B6B2A), Color(0xFF0D4A18), Color(0xFF072E0F)],
    accentColor: Color(0xFFFFB800),
    isMastercard: false,
    prefixes: [
      '459526', '459527', '459528', // 6-digit first
      '401100', '401101',
      '4595', '4011', // 4-digit after
    ],
  ),
  // ── 2. People's Bank ── deep green ────────────────────────────────────────
  SLBankTheme(
    bank: SLBank.peoples,
    name: "People's Bank",
    shortName: "PEOPLES",
    gradientColors: [Color(0xFF1A5C1A), Color(0xFF0E3D0E), Color(0xFF092609)],
    accentColor: Color(0xFF66BB6A),
    isMastercard: false,
    prefixes: ['540355', '540356', '450800', '450801', '5403', '4508'],
  ),
  // ── 3. Amāna Bank ── purple ────────────────────────────────────────────────
  SLBankTheme(
    bank: SLBank.amana,
    name: 'Amāna Bank',
    shortName: 'AMANA',
    gradientColors: [Color(0xFF3A2070), Color(0xFF220E50), Color(0xFF100630)],
    accentColor: Color(0xFF9C6FD4),
    isMastercard: false,
    prefixes: ['469100', '469101', '413000', '413001', '4691', '4130'],
  ),
  // ── 4. Commercial Bank ── navy blue ───────────────────────────────────────
  SLBankTheme(
    bank: SLBank.commercial,
    name: 'Commercial Bank',
    shortName: 'COMBANK',
    gradientColors: [Color(0xFF0A2A5E), Color(0xFF061A40), Color(0xFF030E25)],
    accentColor: Color(0xFF4A90D9),
    isMastercard: false,
    prefixes: ['411700', '411701', '530600', '530601', '4117', '5306'],
  ),
  // ── 5. Sampath Bank ── bright orange ──────────────────────────────────────
  SLBankTheme(
    bank: SLBank.sampath,
    name: 'Sampath Bank',
    shortName: 'SAMPATH',
    gradientColors: [Color(0xFFF47B20), Color(0xFFE8650A), Color(0xFFD05500)],
    accentColor: Color(0xFFFFB74D),
    isMastercard: false,
    prefixes: ['521111', '521112', '432300', '432301', '5211', '4323'],
  ),
  // ── 6. HNB ── amber/brown ─────────────────────────────────────────────────
  SLBankTheme(
    bank: SLBank.hatton,
    name: 'Hatton National Bank',
    shortName: 'HNB',
    gradientColors: [Color(0xFF7A4A10), Color(0xFF4E2D08), Color(0xFF281504)],
    accentColor: Color(0xFFD4A843),
    isMastercard: false,
    prefixes: ['437534', '437535', '543200', '543201', '4375', '5432'],
  ),
  // ── 7. NSB ── teal ────────────────────────────────────────────────────────
  SLBankTheme(
    bank: SLBank.nsb,
    name: 'National Savings Bank',
    shortName: 'NSB',
    gradientColors: [Color(0xFF006060), Color(0xFF003D3D), Color(0xFF001E1E)],
    accentColor: Color(0xFF26C6DA),
    isMastercard: false,
    prefixes: ['481400', '481401', '481500', '481501', '4814', '4815'],
  ),
  // ── 8. DFCC Bank ── steel blue ────────────────────────────────────────────
  SLBankTheme(
    bank: SLBank.dfcc,
    name: 'DFCC Bank',
    shortName: 'DFCC',
    gradientColors: [Color(0xFF1A3A6A), Color(0xFF0E2248), Color(0xFF06112A)],
    accentColor: Color(0xFF5E9BCC),
    isMastercard: false,
    prefixes: ['457301', '457302', '457400', '457401', '4573', '4574'],
  ),
  // ── 9. Seylan Bank ── dark cyan ───────────────────────────────────────────
  SLBankTheme(
    bank: SLBank.seylan,
    name: 'Seylan Bank',
    shortName: 'SEYLAN',
    gradientColors: [Color(0xFF005A5A), Color(0xFF003838), Color(0xFF001A1A)],
    accentColor: Color(0xFF00BCD4),
    isMastercard: true,
    prefixes: ['514186', '514187', '428600', '428601', '5141', '4286'],
  ),
  // ── 10. NDB Bank ── dark black + red ──────────────────────────────────────
  SLBankTheme(
    bank: SLBank.ndb,
    name: 'NDB Bank',
    shortName: 'NDB',
    gradientColors: [Color(0xFF1A0A0A), Color(0xFF100505), Color(0xFF0A0202)],
    accentColor: Color(0xFFC41E2A),
    isMastercard: false,
    prefixes: ['462200', '462201', '550000', '550001', '4622', '5500'],
  ),
];

// ─── Generic fallback theme ───────────────────────────────────────────────────
const SLBankTheme kGenericTheme = SLBankTheme(
  bank: SLBank.other,
  name: '',
  shortName: '',
  gradientColors: [Color(0xFF2A2820), Color(0xFF1A1810), Color(0xFF0A0A06)],
  accentColor: Color(0xFFD4A843),
  isMastercard: false,
  prefixes: [],
);

// ─── Detect Sri Lankan bank by BIN prefix ────────────────────────────────────
//
//  1. Strip spaces from input
//  2. Need at least 4 digits to match
//  3. Try 6-digit BIN first (most precise)
//  4. Fall back to 4-digit BIN prefix
//  5. No SL bank match → generic theme
//
SLBankTheme detectSLBank(String rawNumber) {
  final digits = rawNumber.replaceAll(' ', '');
  if (digits.length < 4) return kGenericTheme;

  final bin6 = digits.length >= 6 ? digits.substring(0, 6) : null;
  final bin4 = digits.substring(0, 4);

  // Try 6-digit match first
  if (bin6 != null) {
    for (final theme in kSLBankThemes) {
      for (final prefix in theme.prefixes) {
        if (prefix.length == 6 && prefix == bin6) return theme;
      }
    }
  }

  // Fall back to 4-digit match
  for (final theme in kSLBankThemes) {
    for (final prefix in theme.prefixes) {
      if (prefix.length == 4 && prefix == bin4) return theme;
    }
  }

  return kGenericTheme;
}

// ─── Saved Card Model ─────────────────────────────────────────────────────────
class _SavedCard {
  final String id;
  final String cardNumber; // last 4 digits
  final String holderName;
  final String expiry;
  final SLBankTheme bankTheme;
  final bool isDefault;

  const _SavedCard({
    required this.id,
    required this.cardNumber,
    required this.holderName,
    required this.expiry,
    required this.bankTheme,
    this.isDefault = false,
  });

  String get maskedDisplay => '•••• •••• •••• $cardNumber';
}

// ─── Mock Saved Cards ─────────────────────────────────────────────────────────
final List<_SavedCard> _mockSavedCards = [
  _SavedCard(
    id: 'card_1',
    cardNumber: '4526',
    holderName: 'NAVEETH ASHAN',
    expiry: '09/27',
    bankTheme: kSLBankThemes[0], // BOC
    isDefault: true,
  ),
  _SavedCard(
    id: 'card_2',
    cardNumber: '8831',
    holderName: 'NAVEETH ASHAN',
    expiry: '03/28',
    bankTheme: kSLBankThemes[4], // Sampath
    isDefault: false,
  ),
];

// ─── Page ─────────────────────────────────────────────────────────────────────
class BookingPage3 extends StatefulWidget {
  final ServiceModel service;
  final StaffModel staff;
  final DateTime date;
  final String time;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String customerNote;

  const BookingPage3({
    super.key,
    required this.service,
    required this.staff,
    required this.date,
    required this.time,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerNote,
  });

  @override
  State<BookingPage3> createState() => _BookingPage3State();
}

class _BookingPage3State extends State<BookingPage3>
    with TickerProviderStateMixin {
  // Controllers
  final _cardNumberCtrl = TextEditingController();
  final _cardNameCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  SLBankTheme _bankTheme = kGenericTheme;
  bool _showCvv = false;
  bool _saveCard = true;
  bool _agreeTerms = false;

  // ── Saved card state ──
  _SavedCard? _selectedSavedCard;
  bool _useNewCard = false; // false = show saved cards, true = new card form
  bool _isProcessing = false;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  // ── Card animation controllers ──
  late AnimationController _flipCtrl;
  late Animation<double> _flipAnim;
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmerAnim;
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;
  late AnimationController _tiltCtrl;
  late Animation<double> _tiltAnim;
  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;
  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;
  late AnimationController _numberSlideCtrl;
  late Animation<double> _numberSlideAnim;
  final FocusNode _cvvFocus = FocusNode();
  final FocusNode _cardNumberFocus = FocusNode();
  bool _showBack = false;
  bool _isCardFocused = false;
  int _prevDigitCount = 0;
  SLBank _prevBank = SLBank.other;

  // Date formatting helpers
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  String _formatDate(DateTime d) =>
      '${_weekdays[d.weekday - 1]}, ${_months[d.month - 1]} ${d.day}';

  @override
  void initState() {
    super.initState();

    // ── Pre-select the default saved card ──
    if (_mockSavedCards.isNotEmpty) {
      _selectedSavedCard = _mockSavedCards.firstWhere(
        (c) => c.isDefault,
        orElse: () => _mockSavedCards.first,
      );
      _bankTheme = _selectedSavedCard!.bankTheme;
    }

    // ── KEY FIX: listen to card number changes and re-detect ──────────────────
    _cardNumberCtrl.addListener(_onCardNumberChanged);
    _cardNameCtrl.addListener(() => setState(() {}));
    _expiryCtrl.addListener(() => setState(() {}));
    _cvvCtrl.addListener(() => setState(() {}));

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // ── Flip animation (for CVV focus) ──
    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnim = Tween<double>(
      begin: 0,
      end: math.pi,
    ).animate(CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOutCubic));

    // ── Shimmer sweep ──
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _shimmerAnim = Tween<double>(
      begin: -1.5,
      end: 2.5,
    ).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));

    // ── Scale bounce on bank change ──
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.04), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.04, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOut));

    // ── Tilt animation on digit entry — stronger Y-axis rotation ──
    _tiltCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _tiltAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.06), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.06, end: -0.04), weight: 35),
      TweenSequenceItem(tween: Tween(begin: -0.04, end: 0.015), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.015, end: 0.0), weight: 15),
    ]).animate(CurvedAnimation(parent: _tiltCtrl, curve: Curves.easeOutBack));

    // ── Floating hover animation (continuous while focused) ──
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _floatAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    // ── Digit glow pulse ──
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _glowAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeOut));

    // ── Number slide-in animation ──
    _numberSlideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _numberSlideAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -2.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: -2.0, end: 0.0), weight: 40),
    ]).animate(
      CurvedAnimation(parent: _numberSlideCtrl, curve: Curves.easeOut),
    );

    // ── CVV focus → flip card ──
    _cvvFocus.addListener(() {
      if (_cvvFocus.hasFocus && !_showBack) {
        setState(() => _showBack = true);
        _flipCtrl.forward();
      } else if (!_cvvFocus.hasFocus && _showBack) {
        setState(() => _showBack = false);
        _flipCtrl.reverse();
      }
    });

    // ── Card number focus → start floating ──
    _cardNumberFocus.addListener(() {
      if (_cardNumberFocus.hasFocus) {
        setState(() => _isCardFocused = true);
        _floatCtrl.repeat(reverse: true);
      } else {
        setState(() => _isCardFocused = false);
        _floatCtrl.stop();
        _floatCtrl.animateTo(0, duration: const Duration(milliseconds: 300));
      }
    });
  }

  // ── Card number change handler ────────────────────────────────────────────
  void _onCardNumberChanged() {
    final detected = detectSLBank(_cardNumberCtrl.text);
    final digits = _cardNumberCtrl.text.replaceAll(' ', '').length;

    // Animations on each new digit typed
    if (digits > _prevDigitCount && digits > 0) {
      // Alternating Y-axis tilt direction based on digit count
      _tiltCtrl.forward(from: 0);
      // Glow pulse on each digit
      _glowCtrl.forward(from: 0);
      // Number slide-in effect
      _numberSlideCtrl.forward(from: 0);
      // Shimmer on every completed group of 4 digits
      if (digits % 4 == 0) {
        _shimmerCtrl.forward(from: 0);
      }
    }
    _prevDigitCount = digits;

    // Scale bounce + shimmer on bank detection change
    if (detected.bank != _prevBank) {
      _scaleCtrl.forward(from: 0);
      if (detected.bank != SLBank.other) {
        _shimmerCtrl.forward(from: 0);
      }
      _prevBank = detected.bank;
    }

    setState(() => _bankTheme = detected);
  }

  @override
  void dispose() {
    _cardNumberCtrl.removeListener(_onCardNumberChanged);
    _cvvFocus.dispose();
    _cardNumberFocus.dispose();
    _flipCtrl.dispose();
    _shimmerCtrl.dispose();
    _scaleCtrl.dispose();
    _tiltCtrl.dispose();
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    _numberSlideCtrl.dispose();
    for (final c in [_cardNumberCtrl, _cardNameCtrl, _expiryCtrl, _cvvCtrl]) {
      c.dispose();
    }
    _pulseCtrl.dispose();
    super.dispose();
  }

  String get _maskedCard {
    // If a saved card is selected, show its masked number
    if (!_useNewCard && _selectedSavedCard != null) {
      return _selectedSavedCard!.maskedDisplay;
    }
    final raw = _cardNumberCtrl.text.replaceAll(' ', '');
    if (raw.isEmpty) return '•••• •••• •••• ••••';
    final padded = raw.padRight(16, '•');
    return '${padded.substring(0, 4)} ${padded.substring(4, 8)} '
        '${padded.substring(8, 12)} ${padded.substring(12, 16)}';
  }

  String get _displayHolder {
    if (!_useNewCard && _selectedSavedCard != null) {
      return _selectedSavedCard!.holderName;
    }
    return _cardNameCtrl.text.isEmpty
        ? 'YOUR NAME'
        : _cardNameCtrl.text.toUpperCase();
  }

  String get _displayExpiry {
    if (!_useNewCard && _selectedSavedCard != null) {
      return _selectedSavedCard!.expiry;
    }
    return _expiryCtrl.text.isEmpty ? 'MM/YY' : _expiryCtrl.text;
  }

  SLBankTheme get _activeBankTheme {
    if (!_useNewCard && _selectedSavedCard != null) {
      return _selectedSavedCard!.bankTheme;
    }
    return _bankTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.bg,
      bottomNavigationBar: const LuxeBottomNav(currentIndex: 2),
      body: CustomScrollView(
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
                _buildSectionHeader(
                  'Payment Method',
                  Icons.credit_card_outlined,
                ),
                const SizedBox(height: 14),
                // ── Saved Cards Section ──
                if (_mockSavedCards.isNotEmpty) _buildSavedCardsSection(),
                if (_mockSavedCards.isNotEmpty) const SizedBox(height: 16),
                _buildCreditCardVisual(),
                const SizedBox(height: 8),
                if (_activeBankTheme.bank != SLBank.other) _buildBankBadge(),
                const SizedBox(height: 16),
                // Only show card form if adding new card
                if (_useNewCard || _mockSavedCards.isEmpty) _buildCardForm(),
                if (_useNewCard || _mockSavedCards.isEmpty)
                  const SizedBox(height: 24),
                if (!_useNewCard && _mockSavedCards.isNotEmpty)
                  const SizedBox(height: 8),
                _buildConfirmButton(),
                const SizedBox(height: 32),
              ],
            ),
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
      leading: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: _AppColors.textPrimary,
            size: 18,
          ),
        ),
      ),
      title: const Text(
        'Payment',
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
          _buildStep(2, 'DETAILS', _StepState.done),
          _buildStepLine(true),
          _buildStep(3, 'CONFIRM', _StepState.active),
        ],
      ),
    );
  }

  Widget _buildStep(int n, String label, _StepState state) {
    final isDone = state == _StepState.done;
    final isActive = state == _StepState.active;
    final isInactive = state == _StepState.inactive;
    final bg =
        isInactive
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
            color: bg,
            border: Border.all(
              color: isInactive ? _AppColors.cardBorder : bg,
              width: 2,
            ),
            boxShadow:
                isActive
                    ? [
                      BoxShadow(
                        color: _AppColors.gold.withOpacity(0.45),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ]
                    : null,
          ),
          child: Center(
            child:
                isDone
                    ? const Icon(Icons.check, color: Colors.black, size: 16)
                    : Text(
                      '$n',
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

  Widget _buildStepLine(bool active) => Expanded(
    child: Container(
      height: 1.5,
      margin: const EdgeInsets.only(bottom: 18),
      color: active ? _AppColors.gold : _AppColors.cardBorder,
    ),
  );

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
              child: const Icon(
                Icons.content_cut,
                color: _AppColors.gold,
                size: 22,
              ),
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
                    'with ${widget.staff.name}  •  ${_formatDate(widget.date)}  •  ${widget.time}',
                    style: const TextStyle(
                      color: _AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Rs ${widget.service.price.toStringAsFixed(0)}',
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

  // ── Saved Cards Section ───────────────────────────────────────────────────────
  Widget _buildSavedCardsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Saved cards list ──
          ..._mockSavedCards.map((card) {
            final isSelected =
                !_useNewCard && _selectedSavedCard?.id == card.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSavedCard = card;
                      _useNewCard = false;
                      _bankTheme = card.bankTheme;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? card.bankTheme.gradientColors.first.withOpacity(
                                0.18,
                              )
                              : _AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            isSelected
                                ? card.bankTheme.accentColor.withOpacity(0.7)
                                : _AppColors.cardBorder,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Radio indicator
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? card.bankTheme.accentColor
                                      : _AppColors.textSecondary,
                              width: 2,
                            ),
                          ),
                          child:
                              isSelected
                                  ? Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: card.bankTheme.accentColor,
                                      ),
                                    ),
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 12),
                        // Bank color bar
                        Container(
                          width: 4,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: card.bankTheme.gradientColors,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Card info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    card.bankTheme.shortName,
                                    style: TextStyle(
                                      color: card.bankTheme.accentColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  if (card.isDefault) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _AppColors.gold.withOpacity(
                                          0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'DEFAULT',
                                        style: TextStyle(
                                          color: _AppColors.gold,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '•••• •••• •••• ${card.cardNumber}',
                                style: const TextStyle(
                                  color: _AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                  fontFamily: 'Courier',
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Expiry
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'EXPIRES',
                              style: TextStyle(
                                color: _AppColors.textMuted,
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              card.expiry,
                              style: const TextStyle(
                                color: _AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          // ── Add New Card Button ──
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _useNewCard = true;
                  _selectedSavedCard = null;
                  _bankTheme = kGenericTheme;
                  _cardNumberCtrl.clear();
                  _cardNameCtrl.clear();
                  _expiryCtrl.clear();
                  _cvvCtrl.clear();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color:
                      _useNewCard
                          ? _AppColors.gold.withOpacity(0.08)
                          : _AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        _useNewCard
                            ? _AppColors.gold.withOpacity(0.5)
                            : _AppColors.cardBorder,
                    width: _useNewCard ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              _useNewCard
                                  ? _AppColors.gold
                                  : _AppColors.textSecondary,
                          width: 2,
                        ),
                      ),
                      child:
                          _useNewCard
                              ? Center(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _AppColors.gold,
                                  ),
                                ),
                              )
                              : null,
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _AppColors.gold.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add_card_outlined,
                        color: _AppColors.gold,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Add New Card',
                      style: TextStyle(
                        color: _AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color:
                          _useNewCard ? _AppColors.gold : _AppColors.textMuted,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bank Detected Badge ───────────────────────────────────────────────────────
  Widget _buildBankBadge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: _activeBankTheme.gradientColors.first.withOpacity(0.25),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _activeBankTheme.accentColor.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnim,
              builder:
                  (_, __) => Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _activeBankTheme.accentColor.withOpacity(
                        _pulseAnim.value,
                      ),
                    ),
                  ),
            ),
            const SizedBox(width: 9),
            Text(
              '${_activeBankTheme.name} card detected',
              style: TextStyle(
                color: _activeBankTheme.accentColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.verified_outlined,
              color: _activeBankTheme.accentColor,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  // ── Credit Card Visual ────────────────────────────────────────────────────────
  // 3D flip, tilt, shimmer, scale, float, and glow animations
  Widget _buildCreditCardVisual() {
    final t = _activeBankTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _flipAnim,
          _shimmerAnim,
          _scaleAnim,
          _tiltAnim,
          _floatAnim,
          _glowAnim,
          _numberSlideAnim,
        ]),
        builder: (context, _) {
          final flipValue = _flipAnim.value;
          final showBack = flipValue > math.pi / 2;

          // Floating offset: gentle up/down sway while card field focused
          final floatOffset =
              _isCardFocused ? math.sin(_floatAnim.value * math.pi) * 6.0 : 0.0;

          // Alternating tilt direction based on digit count
          final tiltDirection = _prevDigitCount.isEven ? 1.0 : -1.0;
          final tiltValue = _tiltAnim.value * tiltDirection;

          return Transform.translate(
            offset: Offset(0, -floatOffset),
            child: Transform(
              alignment: Alignment.center,
              transform:
                  Matrix4.identity()
                    ..setEntry(3, 2, 0.0012) // perspective
                    ..rotateY(flipValue + tiltValue) // flip + Y-tilt
                    ..rotateX(
                      _isCardFocused
                          ? math.sin(_floatAnim.value * math.pi * 2) * 0.012
                          : 0,
                    ) // subtle X-axis breathing
                    ..scale(_scaleAnim.value.clamp(0.95, 1.1)),
              child: showBack ? _buildCardBack(t) : _buildCardFront(t),
            ),
          );
        },
      ),
    );
  }

  // ── Card Front ────────────────────────────────────────────────────────────────
  Widget _buildCardFront(SLBankTheme t) {
    final glowIntensity = _glowAnim.value;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: t.gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: t.gradientColors.first.withOpacity(
              0.55 + glowIntensity * 0.2,
            ),
            blurRadius: 28 + glowIntensity * 12,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: t.accentColor.withOpacity(0.15 + glowIntensity * 0.25),
            blurRadius: 40 + glowIntensity * 20,
            spreadRadius: -5 + glowIntensity * 8,
            offset: const Offset(0, 20),
          ),
          // Dynamic accent glow ring on digit entry
          if (glowIntensity > 0)
            BoxShadow(
              color: t.accentColor.withOpacity(glowIntensity * 0.3),
              blurRadius: 60,
              spreadRadius: glowIntensity * 4,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Bank-specific decorative background
            _cardBg(t),
            // Subtle noise/texture overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.06),
                      Colors.transparent,
                      Colors.black.withOpacity(0.12),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
            // Shimmer glare sweep
            AnimatedBuilder(
              animation: _shimmerAnim,
              builder: (context, _) {
                return Positioned.fill(
                  child: IgnorePointer(
                    child: Transform.translate(
                      offset: Offset(
                        _shimmerAnim.value *
                            MediaQuery.of(context).size.width *
                            0.6,
                        0,
                      ),
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.12),
                              Colors.white.withOpacity(0.18),
                              Colors.white.withOpacity(0.12),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Holographic stripe
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 45,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      t.accentColor.withOpacity(0.0),
                      t.accentColor.withOpacity(0.04),
                      Colors.white.withOpacity(0.03),
                      t.accentColor.withOpacity(0.05),
                      t.accentColor.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Card content
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: Bank name + HNB label or contactless icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _bankNameWidget(t)),
                      const SizedBox(width: 8),
                      // For HNB show "INTERNATIONAL DEBIT" label
                      if (t.bank == SLBank.hatton)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'INTERNATIONAL DEBIT',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.45),
                              fontSize: 7,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      // For Commercial Bank show "INTERNATIONAL SHOPPING DEBIT CARD"
                      if (t.bank == SLBank.commercial)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'INTERNATIONAL SHOPPING\nDEBIT CARD',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.45),
                              fontSize: 6.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              height: 1.3,
                            ),
                          ),
                        ),
                      // For NDB show "Debit" label
                      if (t.bank == SLBank.ndb)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Debit',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.55),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      // For Sampath show "SMART SHOPPER" + "INTERNATIONAL DEBIT CARD"
                      if (t.bank == SLBank.sampath)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'SMART SHOPPER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                'INTERNATIONAL DEBIT CARD',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.65),
                                  fontSize: 5.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(width: 4),
                      // Contactless icon
                      Transform.rotate(
                        angle: math.pi / 2,
                        child: Icon(
                          Icons.wifi,
                          color: Colors.white.withOpacity(0.4),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // EMV Chip + Card number with slide & glow
                  Row(
                    children: [
                      _chip(),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(_numberSlideAnim.value, 0),
                          child: Text(
                            _maskedCard,
                            style: TextStyle(
                              color: Colors.white.withOpacity(
                                0.92 + glowIntensity * 0.08,
                              ),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.5,
                              fontFamily: 'Courier',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                                // Glow shadow on digit entry
                                if (glowIntensity > 0)
                                  Shadow(
                                    color: t.accentColor.withOpacity(
                                      glowIntensity * 0.8,
                                    ),
                                    blurRadius: 12 + glowIntensity * 8,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Bottom row: Holder + Expiry + Network
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _cardMeta('CARD HOLDER'),
                            const SizedBox(height: 2),
                            Text(
                              _displayHolder,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.88),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _cardMeta('VALID\nTHRU'),
                          const SizedBox(height: 2),
                          Text(
                            _displayExpiry,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.88),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      _networkBadge(t),
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

  // ── Card Back (CVV side) ──────────────────────────────────────────────────────
  Widget _buildCardBack(SLBankTheme t) {
    return Transform(
      alignment: Alignment.center,
      transform:
          Matrix4.identity()
            ..rotateY(math.pi), // mirror so text reads correctly
      child: Container(
        height: 210,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                t.gradientColors.map((c) {
                  final hsl = HSLColor.fromColor(c);
                  return hsl
                      .withLightness((hsl.lightness * 0.7).clamp(0, 1))
                      .toColor();
                }).toList(),
          ),
          boxShadow: [
            BoxShadow(
              color: t.gradientColors.first.withOpacity(0.55),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              // Magnetic stripe
              Positioned(
                top: 28,
                left: 0,
                right: 0,
                height: 42,
                child: Container(color: Colors.black.withOpacity(0.85)),
              ),
              // Signature strip + CVV
              Positioned(
                top: 86,
                left: 22,
                right: 22,
                child: Row(
                  children: [
                    // Signature strip
                    Expanded(
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            // Italic signature lines
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  3,
                                  (_) => Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    height: 1,
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // CVV box
                    Container(
                      width: 56,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: t.accentColor.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _cvvCtrl.text.isEmpty ? '•••' : _cvvCtrl.text,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                            fontFamily: 'Courier',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // CVV label
              Positioned(
                top: 128,
                right: 22,
                child: Text(
                  'CVV / CVC',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              // Bank name at bottom
              Positioned(
                bottom: 16,
                left: 22,
                child: Text(
                  t.name,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Network badge at bottom right
              Positioned(bottom: 12, right: 22, child: _networkBadge(t)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardMeta(String text) => Text(
    text,
    style: TextStyle(
      color: Colors.white.withOpacity(0.38),
      fontSize: 6,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
      height: 1.2,
    ),
  );

  // ── Per-bank decorative backgrounds (realistic card designs) ─────────────────

  // Helper: curved wave shape
  Widget _waveShape(
    double w,
    double h,
    Color color,
    double opacity, {
    double rotate = 0,
  }) {
    return Transform.rotate(
      angle: rotate,
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(h * 0.5),
          color: color.withOpacity(opacity),
        ),
      ),
    );
  }

  // Helper: thin arc line
  Widget _arcLine(double size, Color color, double opacity, double strokeW) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ArcPainter(color.withOpacity(opacity), strokeW),
      ),
    );
  }

  // Helper: diamond shape
  Widget _diamond(double size, Color color, double opacity) {
    return Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.15),
          color: color.withOpacity(opacity),
        ),
      ),
    );
  }

  // Helper: horizontal stripe band
  Widget _stripeBand(double height, Color color, double opacity) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: color.withOpacity(opacity)),
    );
  }

  Widget _cardBg(SLBankTheme t) {
    switch (t.bank) {
      // ── BOC: Ocean waves + large helm compass (matching real card) ────────
      case SLBank.boc:
        return Stack(
          children: [
            // Subtle lighter gradient wash bottom-right area
            Positioned(
              right: -30,
              bottom: -30,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Flowing ocean wave lines (multiple sweeping curves)
            Positioned.fill(
              child: CustomPaint(
                painter: _WaveLinePainter(
                  color: t.accentColor.withOpacity(0.12),
                  waveCount: 5,
                  strokeWidth: 1.2,
                  amplitude: 18,
                  yStart: 0.42,
                  ySpacing: 0.09,
                ),
              ),
            ),
            // Second set of thinner wave lines
            Positioned.fill(
              child: CustomPaint(
                painter: _WaveLinePainter(
                  color: Colors.white.withOpacity(0.05),
                  waveCount: 4,
                  strokeWidth: 0.8,
                  amplitude: 14,
                  yStart: 0.48,
                  ySpacing: 0.08,
                  phaseShift: 0.5,
                ),
              ),
            ),
            // Large ship's helm/compass watermark — bottom right
            Positioned(
              right: 10,
              bottom: 10,
              child: _compassWheel(130, t.accentColor.withOpacity(0.10)),
            ),
            // Small BOC emblem circle near top-left (behind bank name)
            Positioned(
              left: 15,
              top: 12,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: t.accentColor.withOpacity(0.20),
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: _compassWheel(18, t.accentColor.withOpacity(0.18)),
                ),
              ),
            ),
          ],
        );

      // ── People's Bank: Geometric abstract art (matching real card) ────────
      case SLBank.peoples:
        return Stack(
          children: [
            // Full-card geometric abstract pattern
            Positioned.fill(
              child: CustomPaint(
                painter: _PeoplesGeoPainter(
                  baseColor: t.gradientColors[0],
                  accentColor: t.accentColor,
                ),
              ),
            ),
            // Large ornate People's Bank seal/emblem — left side
            Positioned(
              left: 8,
              top: 8,
              child: SizedBox(
                width: 42,
                height: 42,
                child: CustomPaint(
                  painter: _PeoplesSealPainter(
                    color: Colors.white.withOpacity(0.55),
                  ),
                ),
              ),
            ),
            // Subtle dark wash over top-right for text readability
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 180,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.black.withOpacity(0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      // ── Amāna Bank: World globe watermark (matching real card) ────────────
      case SLBank.amana:
        return Stack(
          children: [
            // Subtle lighter gradient wash center-right (behind globe)
            Positioned(
              right: -20,
              top: 10,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Large world globe watermark — center-right of card
            Positioned(
              right: 20,
              top: 10,
              bottom: 10,
              child: AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: _GlobePainter(
                    color: Colors.white.withOpacity(0.12),
                    fillColor: Colors.white.withOpacity(0.03),
                  ),
                ),
              ),
            ),
            // Very subtle purple sheen bottom-left
            Positioned(
              left: -60,
              bottom: -40,
              child: Container(
                width: 180,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  gradient: RadialGradient(
                    colors: [
                      t.accentColor.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      // ── Commercial Bank: Constellation connected dots ─────────────────────
      case SLBank.commercial:
        return Stack(
          children: [
            // Subtle radial glow from center-right
            Positioned(
              right: -20,
              top: -10,
              child: Container(
                width: 260,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF1A4080).withOpacity(0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Constellation pattern across entire card
            Positioned.fill(
              child: CustomPaint(
                painter: _ConstellationPainter(
                  dotColor: Colors.white.withOpacity(0.25),
                  lineColor: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            // Secondary glow bottom-left
            Positioned(
              left: -40,
              bottom: -30,
              child: Container(
                width: 180,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF0D3A6E).withOpacity(0.30),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      // ── Sampath Bank: Bold red swoosh ─────────────────────────────────────
      case SLBank.sampath:
        return Stack(
          children: [
            // Large dramatic swoosh
            Positioned(
              right: -60,
              top: -80,
              child: _waveShape(340, 200, t.accentColor, 0.12, rotate: 0.35),
            ),
            Positioned(
              right: -40,
              top: -60,
              child: _waveShape(280, 150, Colors.white, 0.04, rotate: 0.3),
            ),
            // Inner swoosh
            Positioned(
              right: -20,
              top: -30,
              child: _waveShape(200, 90, t.accentColor, 0.06, rotate: 0.25),
            ),
            // Bottom accent line
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      t.accentColor.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Dot pattern
            Positioned(
              left: 15,
              bottom: 25,
              child: _oval(6, t.accentColor, 0.20),
            ),
            Positioned(
              left: 30,
              bottom: 18,
              child: _oval(4, Colors.white, 0.10),
            ),
          ],
        );

      // ── HNB: Dark charcoal with large N watermark (matching real card) ───
      case SLBank.hatton:
        return Stack(
          children: [
            // Subtle horizontal line texture across card
            Positioned.fill(
              child: CustomPaint(
                painter: _HnbLinesPainter(
                  color: Colors.white.withOpacity(0.025),
                ),
              ),
            ),
            // Large stylized "N" watermark — right side
            Positioned(
              right: 15,
              top: 15,
              bottom: 15,
              child: AspectRatio(
                aspectRatio: 0.75,
                child: CustomPaint(
                  painter: _HnbNPainter(color: Colors.white.withOpacity(0.06)),
                ),
              ),
            ),
            // Very subtle lighter gradient wash top-left
            Positioned(
              left: -30,
              top: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.03),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Bottom edge subtle line
            Positioned(
              left: 20,
              right: 20,
              bottom: 0,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      // ── NSB: Modern teal with wave bands ──────────────────────────────────
      case SLBank.nsb:
        return Stack(
          children: [
            // Stacked wave bands
            Positioned(
              left: -100,
              bottom: -30,
              child: _waveShape(400, 80, t.accentColor, 0.10, rotate: -0.08),
            ),
            Positioned(
              left: -80,
              bottom: -10,
              child: _waveShape(360, 60, Colors.white, 0.04, rotate: -0.06),
            ),
            Positioned(
              left: -60,
              bottom: 15,
              child: _waveShape(320, 40, t.accentColor, 0.06, rotate: -0.04),
            ),
            // Sun/circle motif top-right
            Positioned(
              right: -40,
              top: -40,
              child: _oval(130, t.accentColor, 0.08),
            ),
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: t.accentColor.withOpacity(0.10),
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        );

      // ── DFCC: Clean corporate lines ───────────────────────────────────────
      case SLBank.dfcc:
        return Stack(
          children: [
            // Vertical accent bars
            Positioned(
              right: 30,
              top: 0,
              bottom: 0,
              child: Container(
                width: 2,
                color: t.accentColor.withOpacity(0.06),
              ),
            ),
            Positioned(
              right: 40,
              top: 0,
              bottom: 0,
              child: Container(
                width: 1,
                color: t.accentColor.withOpacity(0.04),
              ),
            ),
            // Corner quadrant
            Positioned(
              right: -50,
              bottom: -50,
              child: _arcLine(180, t.accentColor, 0.08, 2.5),
            ),
            Positioned(
              right: -30,
              bottom: -30,
              child: _arcLine(130, Colors.white, 0.04, 1.5),
            ),
            // Top-left corner accent
            Positioned(
              left: -30,
              top: -30,
              child: _oval(100, t.accentColor, 0.06),
            ),
            Positioned(
              left: 60,
              top: 15,
              child: Container(
                width: 40,
                height: 1.5,
                color: t.accentColor.withOpacity(0.10),
              ),
            ),
          ],
        );

      // ── Seylan: Modern swoosh design ──────────────────────────────────────
      case SLBank.seylan:
        return Stack(
          children: [
            // Bold swoosh
            Positioned(
              left: -80,
              top: -40,
              child: _waveShape(350, 140, t.accentColor, 0.10, rotate: 0.2),
            ),
            Positioned(
              left: -60,
              top: -20,
              child: _waveShape(300, 100, Colors.white, 0.04, rotate: 0.15),
            ),
            // Bottom arc
            Positioned(
              right: -40,
              bottom: -40,
              child: _arcLine(140, t.accentColor, 0.10, 2),
            ),
            // Small details
            Positioned(right: 20, top: 15, child: _oval(8, Colors.white, 0.10)),
            Positioned(
              right: 35,
              top: 25,
              child: _oval(5, t.accentColor, 0.15),
            ),
          ],
        );

      // ── NDB: Bold red angular chevrons ────────────────────────────────────
      case SLBank.ndb:
        return Stack(
          children: [
            // Full-card red chevron pattern
            Positioned.fill(
              child: CustomPaint(
                painter: _NdbChevronPainter(color: const Color(0xFFC41E2A)),
              ),
            ),
            // Subtle red glow from left edge
            Positioned(
              left: -30,
              top: 20,
              child: Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFC41E2A).withOpacity(0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Very subtle dark overlay on right side for contrast
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      // ── Default: Clean minimal ────────────────────────────────────────────
      default:
        return Stack(
          children: [
            Positioned(
              right: -50,
              top: -50,
              child: _oval(200, Colors.white, 0.04),
            ),
            Positioned(
              left: -40,
              bottom: -40,
              child: _oval(160, Colors.white, 0.03),
            ),
            Positioned(
              right: 30,
              bottom: 20,
              child: Container(
                width: 50,
                height: 1,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ],
        );
    }
  }

  // Compass/helm wheel for BOC card
  Widget _compassWheel(double size, Color color) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CompassPainter(color)),
    );
  }

  Widget _oval(double size, Color color, double opacity) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withOpacity(opacity),
    ),
  );

  Widget _bankNameWidget(SLBankTheme t) {
    // No bank detected → minimal placeholder
    if (t.name.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white10),
        ),
        child: const Text(
          'DEBIT CARD',
          style: TextStyle(
            color: Colors.white30,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      );
    }

    // Detected bank → realistic bank branding
    // For BOC, add extra left padding to avoid overlapping the emblem circle
    final leftPad = (t.bank == SLBank.boc) ? 38.0 : 0.0;

    // HNB: "HNB" with bird icon + "INTERNATIONAL DEBIT"
    if (t.bank == SLBank.hatton) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'HNB',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 3.0,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          // HNB bird/arrow icon
          Transform.translate(
            offset: const Offset(0, -2),
            child: Icon(
              Icons.arrow_upward_rounded,
              color: const Color(0xFFE8A730),
              size: 18,
            ),
          ),
        ],
      );
    }

    // People's Bank: "PEOPLE'S BANK" + emblem + "DEBIT CLASSIC"
    if (t.bank == SLBank.peoples) {
      return Padding(
        padding: const EdgeInsets.only(left: 46),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "PEOPLE'S",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                height: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'BANK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                    height: 1.0,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'DEBIT CLASSIC',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 7,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Commercial Bank: green logo circle + "COMMERCIAL BANK" text
    if (t.bank == SLBank.commercial) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Green logo circle (stylized "C" emblem)
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2E8B57),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E8B57).withOpacity(0.4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'C',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'COMMERCIAL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.5,
                  height: 1.0,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'BANK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4.0,
                  height: 1.0,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Sampath Bank: green circle logo + "Sampath Bank" text
    if (t.bank == SLBank.sampath) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Green circle logo
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2E7D32),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4),
              ],
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Sampath Bank',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Sampath Bank: green circle logo + "Sampath Bank" text
    if (t.bank == SLBank.sampath) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Green circle logo
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2E7D32),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4),
              ],
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Sampath Bank',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // NDB Bank: red triangle logo + "NDB bank" + tagline
    if (t.bank == SLBank.ndb) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Red triangle logo
              CustomPaint(
                size: const Size(18, 18),
                painter: _NdbTrianglePainter(color: const Color(0xFFC41E2A)),
              ),
              const SizedBox(width: 6),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'NDB ',
                      style: TextStyle(
                        color: const Color(0xFFC41E2A),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    TextSpan(
                      text: 'bank',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.0,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              'The future is banking on us',
              style: TextStyle(
                color: const Color(0xFFC41E2A).withOpacity(0.85),
                fontSize: 7,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      );
    }

    // Amāna has a special layout: "Amāna Bank" (mixed case) + "It's Your Bank" tagline
    if (t.bank == SLBank.amana) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Amāna Bank',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: Text(
              "It's Your Bank",
              style: TextStyle(
                color: Colors.white.withOpacity(0.50),
                fontSize: 9,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: leftPad),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Bank short name
          Text(
            t.shortName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
                Shadow(
                  color: t.accentColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Card type label (beside bank name)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Debit Card',
              style: TextStyle(
                color: Colors.white.withOpacity(0.50),
                fontSize: 9,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip() => Container(
    width: 40,
    height: 30,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFD4C68A),
          Color(0xFFB8A860),
          Color(0xFFD4C68A),
          Color(0xFFA89848),
        ],
        stops: [0.0, 0.3, 0.6, 1.0],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          // Top chip lines
          Container(
            height: 1.2,
            decoration: BoxDecoration(
              color: const Color(0xFFA89040).withOpacity(0.5),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const Spacer(),
          // Middle chip area
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFA89040).withOpacity(0.4),
                      width: 0.7,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFA89040).withOpacity(0.4),
                      width: 0.7,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Bottom chip line
          Container(
            height: 1.2,
            decoration: BoxDecoration(
              color: const Color(0xFFA89040).withOpacity(0.5),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _networkBadge(SLBankTheme t) {
    // Mastercard – overlapping circles
    if (t.isMastercard) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEB001B),
            ),
          ),
          Transform.translate(
            offset: const Offset(-10, 0),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF79E1B).withOpacity(0.9),
              ),
            ),
          ),
        ],
      );
    }

    // Default Visa (with Platinum subtitle for HNB)
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'VISA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: 1,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 4,
                offset: const Offset(1, 2),
              ),
            ],
          ),
        ),
        if (t.bank == SLBank.hatton)
          Text(
            'Platinum',
            style: TextStyle(
              color: Colors.white.withOpacity(0.50),
              fontSize: 8,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        if (t.bank == SLBank.commercial)
          Text(
            'Debit',
            style: TextStyle(
              color: Colors.white.withOpacity(0.50),
              fontSize: 8,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        // Sampath: Blue "Platinum" badge matching real card
        if (t.bank == SLBank.sampath)
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Text(
              'Platinum',
              style: TextStyle(
                color: Colors.white,
                fontSize: 7,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
      ],
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
            // Card Number
            _lbl('Card Number'),
            const SizedBox(height: 7),
            TextFormField(
              controller: _cardNumberCtrl,
              focusNode: _cardNumberFocus,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CardNumberFormatter(),
              ],
              maxLength: 19,
              style: const TextStyle(
                color: _AppColors.textPrimary,
                fontSize: 16,
                letterSpacing: 1.8,
                fontFamily: 'Courier',
              ),
              decoration: InputDecoration(
                hintText: '0000  0000  0000  0000',
                counterText: '',
                hintStyle: const TextStyle(
                  color: _AppColors.textMuted,
                  fontSize: 14,
                  letterSpacing: 1,
                  fontFamily: 'Courier',
                ),
                prefixIcon: const Icon(
                  Icons.credit_card_outlined,
                  color: _AppColors.textSecondary,
                  size: 18,
                ),
                // Show bank-colored verified icon when detected
                suffixIcon:
                    _bankTheme.bank != SLBank.other
                        ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.verified,
                            color: _bankTheme.accentColor,
                            size: 18,
                          ),
                        )
                        : null,
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
                // Focus border uses bank accent color when detected
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color:
                        _bankTheme.bank != SLBank.other
                            ? _bankTheme.accentColor
                            : _AppColors.gold,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),
            _lbl('Cardholder Name'),
            const SizedBox(height: 7),
            TextFormField(
              controller: _cardNameCtrl,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(
                color: _AppColors.textPrimary,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
              decoration: _fieldDeco(
                hint: 'AS ON CARD',
                icon: Icons.badge_outlined,
              ),
            ),

            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _lbl('Expiry Date'),
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
                        decoration: _fieldDeco(
                          hint: 'MM / YY',
                          icon: Icons.date_range_outlined,
                        ).copyWith(counterText: ''),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _lbl('CVV / CVC'),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _cvvCtrl,
                        focusNode: _cvvFocus,
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
                        decoration: _fieldDeco(
                          hint: '•••',
                          icon: Icons.lock_outline,
                        ).copyWith(
                          counterText: '',
                          suffixIcon: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => setState(() => _showCvv = !_showCvv),
                              child: Icon(
                                _showCvv
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: _AppColors.textMuted,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
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
                          color:
                              _saveCard
                                  ? _AppColors.gold
                                  : _AppColors.textSecondary,
                          width: 1.5,
                        ),
                      ),
                      child:
                          _saveCard
                              ? const Icon(
                                Icons.check,
                                color: Colors.black,
                                size: 13,
                              )
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
                    const Icon(
                      Icons.shield_outlined,
                      color: _AppColors.textMuted,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lbl(String text) => Text(
    text,
    style: const TextStyle(
      color: _AppColors.textSecondary,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ),
  );

  InputDecoration _fieldDeco({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _AppColors.textMuted, fontSize: 13),
      prefixIcon: Icon(icon, color: _AppColors.textSecondary, size: 18),
      filled: true,
      fillColor: _AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
    );
  }

  // ── Payment Processing ────────────────────────────────────────────────────────
  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    // Simulate payment processing delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // If user checked "save card" while adding new card, add it to saved list
    if (_useNewCard && _saveCard) {
      final rawNum = _cardNumberCtrl.text.replaceAll(' ', '');
      if (rawNum.length >= 4) {
        _mockSavedCards.add(
          _SavedCard(
            id: 'card_${DateTime.now().millisecondsSinceEpoch}',
            cardNumber: rawNum.substring(rawNum.length - 4),
            holderName: _cardNameCtrl.text.toUpperCase(),
            expiry: _expiryCtrl.text,
            bankTheme: _bankTheme,
          ),
        );
      }
    }

    setState(() => _isProcessing = false);

    if (!mounted) return;
    _showBookingConfirmation();
  }

  // ── Booking Confirmation Bottom Sheet ─────────────────────────────────────────
  void _showBookingConfirmation() {
    HapticFeedback.heavyImpact();

    final servicePrice = widget.service.price;
    final platformFee = servicePrice * 0.10;
    final total = servicePrice + platformFee;
    final bookingRef =
        'LXS-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    final paidWith =
        !_useNewCard && _selectedSavedCard != null
            ? '${_selectedSavedCard!.bankTheme.shortName} •••• ${_selectedSavedCard!.cardNumber}'
            : '${_bankTheme.shortName} •••• ${_cardNumberCtrl.text.replaceAll(' ', '').length >= 4 ? _cardNumberCtrl.text.replaceAll(' ', '').substring(_cardNumberCtrl.text.replaceAll(' ', '').length - 4) : '****'}';

    final savedNewCard = _useNewCard && _saveCard;

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder:
            (ctx, anim, secondAnim) => _ConfirmationSheet(
              bookingRef: bookingRef,
              serviceTitle: widget.service.title,
              stylistName: widget.staff.name,
              date: _formatDate(widget.date),
              time: widget.time,
              duration: widget.service.duration,
              paidWith: paidWith,
              total: total,
              savedNewCard: savedNewCard,
              onViewBooking: () {
                Navigator.of(ctx).pop();
              },
              onBackHome: () {
                Navigator.of(ctx).popUntil((route) => route.isFirst);
              },
            ),
        transitionsBuilder: (ctx, anim, secondAnim, child) {
          return FadeTransition(opacity: anim, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // ── Confirm Button ────────────────────────────────────────────────────────────
  Widget _buildConfirmButton() {
    final servicePrice = widget.service.price;
    final platformFee = servicePrice * 0.10;
    final total = servicePrice + platformFee;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          // ── Price Breakdown ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _AppColors.cardBorder),
            ),
            child: Column(
              children: [
                _priceRow('Service Charge', servicePrice),
                const SizedBox(height: 10),
                _priceRow('Platform Fee (10%)', platformFee),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: _AppColors.cardBorder, height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: _AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Rs ${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: _AppColors.gold,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Georgia',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Agree Terms Checkbox ──
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => setState(() => _agreeTerms = !_agreeTerms),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: _agreeTerms ? _AppColors.gold : Colors.transparent,
                      border: Border.all(
                        color:
                            _agreeTerms
                                ? _AppColors.gold
                                : _AppColors.textSecondary,
                        width: 1.5,
                      ),
                    ),
                    child:
                        _agreeTerms
                            ? const Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 13,
                            )
                            : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'I agree to the ',
                        style: const TextStyle(
                          color: _AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                              color: _AppColors.gold.withOpacity(0.9),
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationColor: _AppColors.gold.withOpacity(0.5),
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Cancellation Policy',
                            style: TextStyle(
                              color: _AppColors.gold.withOpacity(0.9),
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationColor: _AppColors.gold.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── SSL Notice ──
          Row(
            children: [
              const Icon(Icons.lock, color: _AppColors.textMuted, size: 12),
              const SizedBox(width: 5),
              const Text(
                'Secured by 256-bit SSL encryption',
                style: TextStyle(color: _AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Confirm & Pay Button ──
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _agreeTerms && !_isProcessing ? _processPayment : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        _agreeTerms
                            ? [_AppColors.goldLight, _AppColors.gold]
                            : [_AppColors.goldDim, _AppColors.goldDim],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow:
                      _agreeTerms
                          ? [
                            BoxShadow(
                              color: _AppColors.gold.withOpacity(0.4),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ]
                          : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      _isProcessing
                          ? [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'PROCESSING...',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ]
                          : [
                            Icon(
                              Icons.lock_outline,
                              color:
                                  _agreeTerms ? Colors.black : Colors.black38,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'CONFIRM & PAY Rs ${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                color:
                                    _agreeTerms ? Colors.black : Colors.black38,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: _AppColors.textSecondary, fontSize: 13),
        ),
        Text(
          'Rs ${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            color: _AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── Custom Painters ──────────────────────────────────────────────────────────

// Arc painter for circular decorative elements
class _ArcPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  _ArcPainter(this.color, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0,
      math.pi * 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

// Compass / ship-helm wheel painter for BOC card (realistic)
class _CompassPainter extends CustomPainter {
  final Color color;
  _CompassPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // Outer ring
    paint.strokeWidth = r * 0.04;
    canvas.drawCircle(center, r * 0.92, paint);

    // Second ring
    paint.strokeWidth = r * 0.025;
    canvas.drawCircle(center, r * 0.80, paint);

    // Inner ring
    paint.strokeWidth = r * 0.02;
    canvas.drawCircle(center, r * 0.38, paint);

    // Hub circle (filled)
    canvas.drawCircle(
      center,
      r * 0.12,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
    // Hub ring
    paint.strokeWidth = r * 0.015;
    canvas.drawCircle(center, r * 0.18, paint);

    // 8 main spokes — from hub to outer ring
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final innerPt = Offset(
        center.dx + r * 0.20 * math.cos(angle),
        center.dy + r * 0.20 * math.sin(angle),
      );
      final outerPt = Offset(
        center.dx + r * 0.78 * math.cos(angle),
        center.dy + r * 0.78 * math.sin(angle),
      );
      paint.strokeWidth = r * 0.03;
      canvas.drawLine(innerPt, outerPt, paint);
    }

    // 8 handle knobs (circles at end of spokes, on outer ring)
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final knobCenter = Offset(
        center.dx + r * 0.92 * math.cos(angle),
        center.dy + r * 0.92 * math.sin(angle),
      );
      // Knob circle (filled)
      final knobR = (i % 2 == 0) ? r * 0.075 : r * 0.055;
      canvas.drawCircle(
        knobCenter,
        knobR,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
      // Knob ring highlight
      paint.strokeWidth = r * 0.012;
      canvas.drawCircle(knobCenter, knobR, paint);
    }

    // Cardinal point arrows (N, E, S, W) — small triangles outside the ring
    final arrowPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2 - math.pi / 2; // starts at top
      final tipDist = r * 1.0;
      final baseDist = r * 0.85;
      final halfW = r * 0.045;
      final tip = Offset(
        center.dx + tipDist * math.cos(angle),
        center.dy + tipDist * math.sin(angle),
      );
      final baseL = Offset(
        center.dx + baseDist * math.cos(angle - halfW / baseDist),
        center.dy + baseDist * math.sin(angle - halfW / baseDist),
      );
      final baseR = Offset(
        center.dx + baseDist * math.cos(angle + halfW / baseDist),
        center.dy + baseDist * math.sin(angle + halfW / baseDist),
      );
      final path =
          Path()
            ..moveTo(tip.dx, tip.dy)
            ..lineTo(baseL.dx, baseL.dy)
            ..lineTo(baseR.dx, baseR.dy)
            ..close();
      canvas.drawPath(path, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(_CompassPainter old) => old.color != color;
}

// World globe painter for Amāna Bank card (latitude/longitude grid + continent outlines)
class _GlobePainter extends CustomPainter {
  final Color color;
  final Color fillColor;
  _GlobePainter({required this.color, required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 * 0.92;
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..strokeCap = StrokeCap.round;

    // Filled globe background (very subtle)
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill,
    );

    // Outer circle (globe edge)
    paint.strokeWidth = 1.5;
    canvas.drawCircle(Offset(cx, cy), r, paint);

    // Horizontal latitude lines
    paint.strokeWidth = 0.7;
    for (double lat = -0.6; lat <= 0.6; lat += 0.3) {
      final y = cy + r * lat;
      final halfW = r * math.sqrt(1.0 - lat * lat);
      // Slight curve for latitude lines (elliptical arcs)
      final path = Path();
      path.moveTo(cx - halfW, y);
      path.quadraticBezierTo(cx, y + r * 0.08 * lat, cx + halfW, y);
      canvas.drawPath(path, paint);
    }
    // Equator (slightly thicker)
    paint.strokeWidth = 1.0;
    canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), paint);

    // Vertical longitude lines (ellipses viewed from angle)
    paint.strokeWidth = 0.7;
    for (double frac in [-0.5, -0.25, 0.0, 0.25, 0.5]) {
      final horizR = r * frac.abs().clamp(0.15, 1.0);
      final oval = Rect.fromCenter(
        center: Offset(cx + r * frac * 0.6, cy),
        width: horizR * 1.2,
        height: r * 2,
      );
      canvas.save();
      // Clip to globe circle so lines don't go outside
      canvas.clipPath(
        Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
      );
      canvas.drawOval(oval, paint);
      canvas.restore();
    }
    // Center meridian
    paint.strokeWidth = 0.9;
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
    );
    canvas.drawLine(Offset(cx, cy - r), Offset(cx, cy + r), paint);
    canvas.restore();

    // Continent-like land mass hints (simplified blobs)
    final landPaint =
        Paint()
          ..color = color.withOpacity(0.6)
          ..style = PaintingStyle.fill;

    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
    );

    // Asia landmass (large blob right-center, like the real card)
    final asia = Path();
    asia.moveTo(cx + r * 0.05, cy - r * 0.55);
    asia.quadraticBezierTo(
      cx + r * 0.35,
      cy - r * 0.50,
      cx + r * 0.50,
      cy - r * 0.30,
    );
    asia.quadraticBezierTo(
      cx + r * 0.65,
      cy - r * 0.10,
      cx + r * 0.55,
      cy + r * 0.05,
    );
    asia.quadraticBezierTo(
      cx + r * 0.40,
      cy + r * 0.15,
      cx + r * 0.20,
      cy + r * 0.10,
    );
    asia.quadraticBezierTo(
      cx + r * 0.10,
      cy + r * 0.05,
      cx + r * 0.05,
      cy - r * 0.10,
    );
    asia.quadraticBezierTo(
      cx - r * 0.05,
      cy - r * 0.35,
      cx + r * 0.05,
      cy - r * 0.55,
    );
    canvas.drawPath(asia, landPaint);

    // Africa (blob center-left below equator)
    final africa = Path();
    africa.moveTo(cx - r * 0.10, cy - r * 0.15);
    africa.quadraticBezierTo(
      cx + r * 0.05,
      cy - r * 0.10,
      cx + r * 0.05,
      cy + r * 0.10,
    );
    africa.quadraticBezierTo(
      cx + r * 0.00,
      cy + r * 0.35,
      cx - r * 0.08,
      cy + r * 0.40,
    );
    africa.quadraticBezierTo(
      cx - r * 0.18,
      cy + r * 0.30,
      cx - r * 0.15,
      cy + r * 0.05,
    );
    africa.quadraticBezierTo(
      cx - r * 0.18,
      cy - r * 0.10,
      cx - r * 0.10,
      cy - r * 0.15,
    );
    canvas.drawPath(africa, landPaint);

    // Europe (small blob top-left)
    final europe = Path();
    europe.moveTo(cx - r * 0.15, cy - r * 0.35);
    europe.quadraticBezierTo(
      cx - r * 0.02,
      cy - r * 0.40,
      cx + r * 0.02,
      cy - r * 0.30,
    );
    europe.quadraticBezierTo(
      cx - r * 0.03,
      cy - r * 0.20,
      cx - r * 0.12,
      cy - r * 0.18,
    );
    europe.quadraticBezierTo(
      cx - r * 0.20,
      cy - r * 0.25,
      cx - r * 0.15,
      cy - r * 0.35,
    );
    canvas.drawPath(europe, landPaint);

    // India/Sri Lanka peninsula
    final india = Path();
    india.moveTo(cx + r * 0.25, cy - r * 0.10);
    india.quadraticBezierTo(
      cx + r * 0.35,
      cy + r * 0.00,
      cx + r * 0.30,
      cy + r * 0.20,
    );
    india.quadraticBezierTo(
      cx + r * 0.25,
      cy + r * 0.25,
      cx + r * 0.20,
      cy + r * 0.15,
    );
    india.quadraticBezierTo(
      cx + r * 0.18,
      cy + r * 0.00,
      cx + r * 0.25,
      cy - r * 0.10,
    );
    canvas.drawPath(india, landPaint);

    // Small island below India (Sri Lanka!)
    canvas.drawCircle(
      Offset(cx + r * 0.28, cy + r * 0.28),
      r * 0.03,
      landPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_GlobePainter old) => old.color != color;
}

// People's Bank — geometric abstract art pattern (circles, semicircles, petals)
class _PeoplesGeoPainter extends CustomPainter {
  final Color baseColor;
  final Color accentColor;
  _PeoplesGeoPainter({required this.baseColor, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Palette of greens matching the real People's Bank card
    final colors = [
      const Color(0xFF2E7D32).withOpacity(0.35), // medium green
      const Color(0xFF4CAF50).withOpacity(0.30), // light green
      const Color(0xFF1B5E20).withOpacity(0.40), // dark green
      const Color(0xFF81C784).withOpacity(0.25), // pale green
      const Color(0xFF388E3C).withOpacity(0.30), // forest green
      const Color(0xFFA5D6A7).withOpacity(0.20), // very light green
      const Color(0xFF2E7D32).withOpacity(0.18), // olive tint
    ];

    final paint = Paint()..style = PaintingStyle.fill;

    // Large background circles (overlapping, like the real card)
    final circles = [
      [w * 0.15, h * 0.3, w * 0.28, colors[0]],
      [w * 0.45, h * 0.15, w * 0.22, colors[1]],
      [w * 0.75, h * 0.55, w * 0.30, colors[2]],
      [w * 0.30, h * 0.75, w * 0.20, colors[3]],
      [w * 0.60, h * 0.85, w * 0.18, colors[4]],
      [w * 0.90, h * 0.20, w * 0.16, colors[5]],
      [w * 0.05, h * 0.80, w * 0.15, colors[1]],
      [w * 0.55, h * 0.45, w * 0.14, colors[3]],
      [w * 0.20, h * 0.55, w * 0.12, colors[6]],
      [w * 0.82, h * 0.80, w * 0.13, colors[0]],
      [w * 0.35, h * 0.40, w * 0.06, colors[4]],
      [w * 0.70, h * 0.35, w * 0.05, colors[5]],
      [w * 0.50, h * 0.65, w * 0.04, colors[1]],
    ];

    for (final c in circles) {
      paint.color = c[3] as Color;
      canvas.drawCircle(
        Offset(c[0] as double, c[1] as double),
        c[2] as double,
        paint,
      );
    }

    // Semicircles / half-moon shapes
    void drawSemi(double x, double y, double r, Color col, double start) {
      paint.color = col;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(x, y), radius: r),
        start,
        math.pi,
        true,
        paint,
      );
    }

    drawSemi(0, h * 0.5, w * 0.12, colors[2], 0);
    drawSemi(w, h * 0.4, w * 0.10, colors[0], math.pi);
    drawSemi(w * 0.40, 0, w * 0.14, colors[6], math.pi / 2);
    drawSemi(w * 0.65, h, w * 0.12, colors[3], -math.pi / 2);
    drawSemi(w * 0.25, h, w * 0.09, colors[5], -math.pi / 2);

    // Petal / leaf shapes
    void drawPetal(double px, double py, double sz, Color col, double angle) {
      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(angle);
      paint.color = col;
      final path =
          Path()
            ..moveTo(0, 0)
            ..quadraticBezierTo(sz * 0.8, -sz * 0.3, sz, 0)
            ..quadraticBezierTo(sz * 0.8, sz * 0.3, 0, 0);
      canvas.drawPath(path, paint);
      canvas.restore();
    }

    drawPetal(w * 0.12, h * 0.15, w * 0.15, colors[4], 0.3);
    drawPetal(w * 0.65, h * 0.10, w * 0.12, colors[6], 1.8);
    drawPetal(w * 0.80, h * 0.70, w * 0.14, colors[1], 3.5);
    drawPetal(w * 0.10, h * 0.65, w * 0.10, colors[2], 5.0);
    drawPetal(w * 0.50, h * 0.50, w * 0.08, colors[5], 2.2);

    // Circle ring outlines
    final ringPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
    ringPaint.color = Colors.white.withOpacity(0.06);
    canvas.drawCircle(Offset(w * 0.30, h * 0.30), w * 0.18, ringPaint);
    canvas.drawCircle(Offset(w * 0.70, h * 0.60), w * 0.22, ringPaint);
    ringPaint.color = const Color(0xFF1B5E20).withOpacity(0.15);
    canvas.drawCircle(Offset(w * 0.50, h * 0.20), w * 0.10, ringPaint);
  }

  @override
  bool shouldRepaint(_PeoplesGeoPainter old) => false;
}

// People's Bank ornate seal/emblem painter
class _PeoplesSealPainter extends CustomPainter {
  final Color color;
  _PeoplesSealPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;

    // Outer decorative ring (scalloped edge)
    final outerPath = Path();
    for (int i = 0; i < 24; i++) {
      final a1 = i * 2 * math.pi / 24;
      final a2 = (i + 1) * 2 * math.pi / 24;
      final midA = (a1 + a2) / 2;
      final p1 = Offset(
        cx + r * 0.92 * math.cos(a1),
        cy + r * 0.92 * math.sin(a1),
      );
      final bump = Offset(
        cx + r * 1.0 * math.cos(midA),
        cy + r * 1.0 * math.sin(midA),
      );
      final p2 = Offset(
        cx + r * 0.92 * math.cos(a2),
        cy + r * 0.92 * math.sin(a2),
      );
      if (i == 0) outerPath.moveTo(p1.dx, p1.dy);
      outerPath.quadraticBezierTo(bump.dx, bump.dy, p2.dx, p2.dy);
    }
    outerPath.close();
    canvas.drawPath(outerPath, paint);

    // Inner rings
    canvas.drawCircle(Offset(cx, cy), r * 0.78, paint);
    paint.strokeWidth = 0.8;
    canvas.drawCircle(Offset(cx, cy), r * 0.68, paint);

    // Center circle (filled)
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.30,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
    paint.strokeWidth = 0.6;
    canvas.drawCircle(Offset(cx, cy), r * 0.45, paint);

    // Radial decorative spokes
    for (int i = 0; i < 12; i++) {
      final angle = i * 2 * math.pi / 12;
      final inner = Offset(
        cx + r * 0.45 * math.cos(angle),
        cy + r * 0.45 * math.sin(angle),
      );
      final outer = Offset(
        cx + r * 0.68 * math.cos(angle),
        cy + r * 0.68 * math.sin(angle),
      );
      canvas.drawLine(inner, outer, paint..strokeWidth = 0.5);
    }
  }

  @override
  bool shouldRepaint(_PeoplesSealPainter old) => old.color != color;
}

// HNB — Large stylized "N" letter watermark
class _HnbNPainter extends CustomPainter {
  final Color color;
  _HnbNPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Draw a large stylized "N" shape
    final path = Path();
    final strokeW = w * 0.18;

    // Left vertical bar
    path.addRect(Rect.fromLTWH(0, 0, strokeW, h));

    // Right vertical bar
    path.addRect(Rect.fromLTWH(w - strokeW, 0, strokeW, h));

    // Diagonal bar connecting top-left to bottom-right
    path.moveTo(0, 0);
    path.lineTo(strokeW, 0);
    path.lineTo(w, h);
    path.lineTo(w - strokeW, h);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_HnbNPainter old) => old.color != color;
}

// HNB — subtle horizontal line texture
class _HnbLinesPainter extends CustomPainter {
  final Color color;
  _HnbLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 0.5;
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_HnbLinesPainter old) => old.color != color;
}

// Flowing ocean wave-line painter (sinusoidal curves)
class _WaveLinePainter extends CustomPainter {
  final Color color;
  final int waveCount;
  final double strokeWidth;
  final double amplitude;
  final double yStart; // 0..1 fraction of card height
  final double ySpacing; // spacing between waves as fraction
  final double phaseShift;

  _WaveLinePainter({
    required this.color,
    this.waveCount = 4,
    this.strokeWidth = 1.0,
    this.amplitude = 15,
    this.yStart = 0.45,
    this.ySpacing = 0.08,
    this.phaseShift = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    for (int w = 0; w < waveCount; w++) {
      final baseY = size.height * (yStart + w * ySpacing);
      final phase = (w * 0.7) + phaseShift;
      final amp = amplitude * (1.0 - w * 0.08); // slightly smaller each line
      final path = Path();
      path.moveTo(-10, baseY);
      for (double x = -10; x <= size.width + 10; x += 2) {
        final t = x / size.width;
        final y = baseY + amp * math.sin((t * 2.5 + phase) * math.pi);
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_WaveLinePainter old) =>
      old.color != color || old.waveCount != waveCount;
}

// Sampath Bank — Flowing orange wave swooshes
class _SampathWavePainter extends CustomPainter {
  final Color baseColor;
  _SampathWavePainter({required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Draw multiple flowing wave curves across the card
    final waves = [
      // Large background wave (lightest)
      _SWave(
        yStart: 0.10,
        amplitude: h * 0.35,
        freq: 1.2,
        phase: 0.0,
        opacity: 0.12,
        sw: 40,
      ),
      // Medium wave
      _SWave(
        yStart: 0.25,
        amplitude: h * 0.30,
        freq: 1.0,
        phase: 0.5,
        opacity: 0.10,
        sw: 30,
      ),
      // Flowing center waves
      _SWave(
        yStart: 0.40,
        amplitude: h * 0.25,
        freq: 1.4,
        phase: 1.0,
        opacity: 0.15,
        sw: 20,
      ),
      _SWave(
        yStart: 0.50,
        amplitude: h * 0.20,
        freq: 1.6,
        phase: 1.5,
        opacity: 0.12,
        sw: 18,
      ),
      // Lower waves
      _SWave(
        yStart: 0.60,
        amplitude: h * 0.18,
        freq: 1.3,
        phase: 2.0,
        opacity: 0.10,
        sw: 15,
      ),
      _SWave(
        yStart: 0.70,
        amplitude: h * 0.15,
        freq: 1.8,
        phase: 0.8,
        opacity: 0.08,
        sw: 12,
      ),
      // Thin accent lines
      _SWave(
        yStart: 0.35,
        amplitude: h * 0.22,
        freq: 1.1,
        phase: 0.3,
        opacity: 0.20,
        sw: 2,
      ),
      _SWave(
        yStart: 0.55,
        amplitude: h * 0.18,
        freq: 1.5,
        phase: 1.2,
        opacity: 0.18,
        sw: 2,
      ),
      _SWave(
        yStart: 0.75,
        amplitude: h * 0.12,
        freq: 1.7,
        phase: 2.5,
        opacity: 0.15,
        sw: 2,
      ),
    ];

    for (final wave in waves) {
      final paint =
          Paint()
            ..color = baseColor.withOpacity(wave.opacity)
            ..style = wave.sw > 3 ? PaintingStyle.fill : PaintingStyle.stroke
            ..strokeWidth = wave.sw > 3 ? 0 : wave.sw.toDouble();

      final path = Path();
      final baseY = h * wave.yStart;

      path.moveTo(-10, baseY);
      for (double x = -10; x <= w + 10; x += 2) {
        final t = x / w;
        final y =
            baseY +
            wave.amplitude *
                math.sin((t * wave.freq + wave.phase) * math.pi * 2);
        path.lineTo(x, y);
      }

      if (wave.sw > 3) {
        // Fill down to bottom for thick waves
        path.lineTo(w + 10, h + 10);
        path.lineTo(-10, h + 10);
        path.close();
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_SampathWavePainter old) => old.baseColor != baseColor;
}

class _SWave {
  final double yStart, amplitude, freq, phase, opacity;
  final num sw;
  const _SWave({
    required this.yStart,
    required this.amplitude,
    required this.freq,
    required this.phase,
    required this.opacity,
    required this.sw,
  });
}

// NDB Bank — Bold angular chevron/arrow shapes
class _NdbChevronPainter extends CustomPainter {
  final Color color;
  _NdbChevronPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Draw 3 layered chevron/arrow shapes pointing right
    // Each chevron is a V-shape rotated to point right
    final chevrons = [
      // Largest (back) — farthest left, most transparent
      _ChevronData(
        tipX: w * 0.42,
        centerY: h * 0.50,
        wingW: w * 0.38,
        wingH: h * 0.90,
        thickness: w * 0.10,
        opacity: 0.55,
      ),
      // Medium (middle)
      _ChevronData(
        tipX: w * 0.32,
        centerY: h * 0.50,
        wingW: w * 0.30,
        wingH: h * 0.78,
        thickness: w * 0.09,
        opacity: 0.70,
      ),
      // Smallest (front) — brightest
      _ChevronData(
        tipX: w * 0.22,
        centerY: h * 0.50,
        wingW: w * 0.22,
        wingH: h * 0.65,
        thickness: w * 0.08,
        opacity: 0.90,
      ),
    ];

    for (final c in chevrons) {
      final paint =
          Paint()
            ..color = color.withOpacity(c.opacity)
            ..style = PaintingStyle.fill;

      // Chevron pointing right: tip at right, wings extend left-up and left-down
      final path = Path();
      // Outer edge
      path.moveTo(c.tipX, c.centerY); // tip point
      path.lineTo(c.tipX - c.wingW, c.centerY - c.wingH / 2); // top-left
      path.lineTo(
        c.tipX - c.wingW + c.thickness,
        c.centerY - c.wingH / 2,
      ); // top-left inner
      path.lineTo(c.tipX - c.thickness * 0.3, c.centerY); // inner tip
      path.lineTo(
        c.tipX - c.wingW + c.thickness,
        c.centerY + c.wingH / 2,
      ); // bottom-left inner
      path.lineTo(c.tipX - c.wingW, c.centerY + c.wingH / 2); // bottom-left
      path.close();

      canvas.drawPath(path, paint);

      // Add a subtle bright edge highlight on the inner edge
      final edgePaint =
          Paint()
            ..color = color.withOpacity(c.opacity * 0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0;
      final edgePath = Path();
      edgePath.moveTo(c.tipX - c.wingW + c.thickness, c.centerY - c.wingH / 2);
      edgePath.lineTo(c.tipX - c.thickness * 0.3, c.centerY);
      edgePath.lineTo(c.tipX - c.wingW + c.thickness, c.centerY + c.wingH / 2);
      canvas.drawPath(edgePath, edgePaint);
    }
  }

  @override
  bool shouldRepaint(_NdbChevronPainter old) => old.color != color;
}

class _ChevronData {
  final double tipX, centerY, wingW, wingH, thickness, opacity;
  const _ChevronData({
    required this.tipX,
    required this.centerY,
    required this.wingW,
    required this.wingH,
    required this.thickness,
    required this.opacity,
  });
}

// NDB Bank — Red triangle logo mark
class _NdbTrianglePainter extends CustomPainter {
  final Color color;
  _NdbTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();
    // Upward pointing triangle
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // Inner smaller triangle cut-out for depth
    final innerPaint =
        Paint()
          ..color = color.withOpacity(0.4)
          ..style = PaintingStyle.fill;
    final inner = Path();
    final inset = size.width * 0.22;
    inner.moveTo(size.width / 2, inset * 0.8);
    inner.lineTo(size.width - inset, size.height - inset * 0.4);
    inner.lineTo(inset, size.height - inset * 0.4);
    inner.close();
    canvas.drawPath(inner, innerPaint);
  }

  @override
  bool shouldRepaint(_NdbTrianglePainter old) => old.color != color;
}

// Commercial Bank — Constellation / connected-dots pattern
class _ConstellationPainter extends CustomPainter {
  final Color dotColor;
  final Color lineColor;
  _ConstellationPainter({required this.dotColor, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42); // fixed seed for consistent pattern
    final dotPaint = Paint()..color = dotColor;
    final linePaint =
        Paint()
          ..color = lineColor
          ..strokeWidth = 0.8;

    // Generate constellation points
    final points = <Offset>[];
    final count = 35;
    for (int i = 0; i < count; i++) {
      points.add(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
      );
    }

    // Draw connecting lines between nearby points
    final maxDist = size.width * 0.28;
    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final dx = points[i].dx - points[j].dx;
        final dy = points[i].dy - points[j].dy;
        final dist = math.sqrt(dx * dx + dy * dy);
        if (dist < maxDist) {
          final opacity = (1.0 - dist / maxDist) * 0.6;
          linePaint.color = lineColor.withOpacity(lineColor.opacity * opacity);
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }

    // Draw dots with varying sizes
    for (int i = 0; i < points.length; i++) {
      final radius = 1.0 + rng.nextDouble() * 2.0;
      dotPaint.color = dotColor.withOpacity(
        dotColor.opacity * (0.5 + rng.nextDouble() * 0.5),
      );
      canvas.drawCircle(points[i], radius, dotPaint);

      // Some dots get a subtle glow ring
      if (i % 4 == 0) {
        final glowPaint =
            Paint()
              ..color = dotColor.withOpacity(dotColor.opacity * 0.15)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.0;
        canvas.drawCircle(points[i], radius + 3, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_ConstellationPainter old) =>
      old.dotColor != dotColor || old.lineColor != lineColor;
}

// ─── Formatters ───────────────────────────────────────────────────────────────
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll('/', '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    // Clamp first digit of month: only 0 or 1
    if (digits.length >= 1) {
      final d1 = int.parse(digits[0]);
      if (d1 > 1) digits = '0$d1';
    }

    // Clamp second digit of month: 01–12
    if (digits.length >= 2) {
      final month = int.parse(digits.substring(0, 2));
      if (month < 1) digits = '01${digits.substring(2)}';
      if (month > 12) digits = '12${digits.substring(2)}';
    }

    // Clamp first digit of year: must be 2–9
    if (digits.length >= 3) {
      final y1 = int.parse(digits[2]);
      if (y1 < 2)
        digits =
            '${digits.substring(0, 2)}2${digits.length > 3 ? digits.substring(3) : ''}';
    }

    if (digits.length > 4) digits = digits.substring(0, 4);

    if (digits.length <= 2) {
      return TextEditingValue(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
    }

    final result = '${digits.substring(0, 2)}/${digits.substring(2)}';
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ENHANCED BOOKING CONFIRMATION SHEET
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _ConfirmationSheet extends StatefulWidget {
  final String bookingRef;
  final String serviceTitle;
  final String stylistName;
  final String date;
  final String time;
  final String duration;
  final String paidWith;
  final double total;
  final bool savedNewCard;
  final VoidCallback onViewBooking;
  final VoidCallback onBackHome;

  const _ConfirmationSheet({
    required this.bookingRef,
    required this.serviceTitle,
    required this.stylistName,
    required this.date,
    required this.time,
    required this.duration,
    required this.paidWith,
    required this.total,
    required this.savedNewCard,
    required this.onViewBooking,
    required this.onBackHome,
  });

  @override
  State<_ConfirmationSheet> createState() => _ConfirmationSheetState();
}

class _ConfirmationSheetState extends State<_ConfirmationSheet>
    with TickerProviderStateMixin {
  // ── Animation controllers ──
  late AnimationController _iconCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _contentCtrl;
  late AnimationController _particleCtrl;
  late AnimationController _shimmerCtrl;
  late AnimationController _priceCtrl;

  // ── Animations ──
  late Animation<double> _iconScale;
  late Animation<double> _iconRotate;
  late Animation<double> _checkDraw;
  late Animation<double> _glowPulse;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _buttonsFade;
  late Animation<Offset> _buttonsSlide;
  late Animation<double> _priceValue;

  // Staggered row animations
  final List<Animation<double>> _rowFades = [];
  final List<Animation<Offset>> _rowSlides = [];

  // Particle data
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();

    // ── Icon bounce (0→600ms) ──
    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _iconScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.9), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 25),
    ]).animate(CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOut));

    _iconRotate = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _iconCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _checkDraw = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconCtrl,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    // ── Glow pulse (infinite loop) ──
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _glowPulse = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    // ── Content stagger (delayed start) ──
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.1, 0.35, curve: Curves.easeOut),
      ),
    );

    _cardFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );

    // 7 detail rows — staggered
    for (int i = 0; i < 7; i++) {
      final start = 0.25 + i * 0.06;
      final end = (start + 0.15).clamp(0.0, 1.0);
      _rowFades.add(
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _contentCtrl,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );
      _rowSlides.add(
        Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentCtrl,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );
    }

    _buttonsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );
    _buttonsSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    // ── Particles ──
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    final rng = math.Random();
    _particles = List.generate(18, (_) => _Particle(rng));

    // ── Shimmer on booking ref ──
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // ── Price counter ──
    _priceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _priceValue = Tween<double>(
      begin: 0,
      end: widget.total,
    ).animate(CurvedAnimation(parent: _priceCtrl, curve: Curves.easeOutCubic));

    // ── Start sequence ──
    _iconCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _glowCtrl.repeat(reverse: true);
        _particleCtrl.repeat();
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _contentCtrl.forward();
        _shimmerCtrl.repeat();
      }
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _priceCtrl.forward();
    });
  }

  @override
  void dispose() {
    _iconCtrl.dispose();
    _glowCtrl.dispose();
    _contentCtrl.dispose();
    _particleCtrl.dispose();
    _shimmerCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // ── Animated Success Icon with particles ──
            SizedBox(
              width: 120,
              height: 120,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _iconCtrl,
                  _glowCtrl,
                  _particleCtrl,
                ]),
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ParticlePainter(
                      particles: _particles,
                      progress: _particleCtrl.value,
                      color: const Color(0xFF5DBD7A),
                    ),
                    child: Center(
                      child: Transform.rotate(
                        angle: _iconRotate.value,
                        child: Transform.scale(
                          scale: _iconScale.value,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF7EDBA0),
                                  Color(0xFF5DBD7A),
                                  Color(0xFF3A9B58),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF5DBD7A,
                                  ).withOpacity(_glowPulse.value),
                                  blurRadius: 40,
                                  spreadRadius: 8,
                                ),
                                BoxShadow(
                                  color: const Color(
                                    0xFF7EDBA0,
                                  ).withOpacity(_glowPulse.value * 0.5),
                                  blurRadius: 60,
                                  spreadRadius: 15,
                                ),
                              ],
                            ),
                            child: CustomPaint(
                              painter: _CheckPainter(
                                progress: _checkDraw.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ── Title ──
            FadeTransition(
              opacity: _titleFade,
              child: SlideTransition(
                position: _titleSlide,
                child: const Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    color: _AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),

            // ── Subtitle ──
            FadeTransition(
              opacity: _subtitleFade,
              child: Text(
                'Your appointment has been scheduled',
                style: TextStyle(
                  color: _AppColors.textSecondary.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Scrollable content: details card + buttons ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    FadeTransition(
                      opacity: _cardFade,
                      child: SlideTransition(
                        position: _cardSlide,
                        child: _buildDetailsCard(),
                      ),
                    ),
                    if (widget.savedNewCard) const SizedBox(height: 14),
                    if (widget.savedNewCard)
                      FadeTransition(
                        opacity: _buttonsFade,
                        child: _buildSavedCardBanner(),
                      ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _buttonsFade,
                      child: SlideTransition(
                        position: _buttonsSlide,
                        child: Column(
                          children: [
                            _buildViewBookingBtn(),
                            const SizedBox(height: 10),
                            _buildBackHomeBtn(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Details Card ──
  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Booking Ref with shimmer ──
          AnimatedBuilder(
            animation: _shimmerCtrl,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Booking Reference',
                    style: TextStyle(
                      color: _AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [
                          _AppColors.gold.withOpacity(0.12),
                          _AppColors.goldLight.withOpacity(
                            0.06 +
                                0.12 *
                                    math
                                        .sin(_shimmerCtrl.value * math.pi * 2)
                                        .abs(),
                          ),
                          _AppColors.gold.withOpacity(0.12),
                        ],
                        stops: [0.0, _shimmerCtrl.value, 1.0],
                      ),
                      border: Border.all(
                        color: _AppColors.gold.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      widget.bookingRef,
                      style: const TextStyle(
                        color: _AppColors.gold,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // ── Dashed divider ──
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final dashWidth = 5.0;
                final dashSpace = 3.0;
                final dashCount =
                    (constraints.maxWidth / (dashWidth + dashSpace)).floor();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(dashCount, (_) {
                    return SizedBox(
                      width: dashWidth,
                      height: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: _AppColors.cardBorder.withOpacity(0.6),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),

          // ── Staggered detail rows ──
          _animatedRow(
            0,
            Icons.content_cut_outlined,
            'Service',
            widget.serviceTitle,
          ),
          const SizedBox(height: 12),
          _animatedRow(1, Icons.person_outline, 'Stylist', widget.stylistName),
          const SizedBox(height: 12),
          _animatedRow(2, Icons.calendar_today_outlined, 'Date', widget.date),
          const SizedBox(height: 12),
          _animatedRow(3, Icons.access_time_outlined, 'Time', widget.time),
          const SizedBox(height: 12),
          _animatedRow(4, Icons.timer_outlined, 'Duration', widget.duration),

          // ── Dashed divider ──
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final dashWidth = 5.0;
                final dashSpace = 3.0;
                final dashCount =
                    (constraints.maxWidth / (dashWidth + dashSpace)).floor();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(dashCount, (_) {
                    return SizedBox(
                      width: dashWidth,
                      height: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: _AppColors.cardBorder.withOpacity(0.6),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),

          // ── Payment row ──
          _animatedRow(
            5,
            Icons.credit_card_outlined,
            'Paid with',
            widget.paidWith,
          ),
          const SizedBox(height: 14),

          // ── Animated Total ──
          FadeTransition(
            opacity: _rowFades.length > 6 ? _rowFades[6] : _cardFade,
            child: SlideTransition(
              position: _rowSlides.length > 6 ? _rowSlides[6] : _cardSlide,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      _AppColors.gold.withOpacity(0.06),
                      _AppColors.gold.withOpacity(0.02),
                    ],
                  ),
                  border: Border.all(color: _AppColors.gold.withOpacity(0.12)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _AppColors.gold.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.payments_outlined,
                        color: _AppColors.gold,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Total Paid',
                      style: TextStyle(
                        color: _AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    AnimatedBuilder(
                      animation: _priceValue,
                      builder: (context, _) {
                        return Text(
                          'Rs ${_priceValue.value.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: _AppColors.gold,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Georgia',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Animated Row ──
  Widget _animatedRow(int index, IconData icon, String label, String value) {
    return FadeTransition(
      opacity: _rowFades[index],
      child: SlideTransition(
        position: _rowSlides[index],
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: _AppColors.textSecondary, size: 14),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: _AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                value,
                style: const TextStyle(
                  color: _AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Saved Card Banner ──
  Widget _buildSavedCardBanner() {
    return FadeTransition(
      opacity: _buttonsFade,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: _AppColors.green.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _AppColors.green.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _AppColors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: _AppColors.green,
                size: 14,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Card saved for future bookings',
                style: TextStyle(
                  color: _AppColors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── View Booking Button ──
  Widget _buildViewBookingBtn() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: widget.onViewBooking,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFEDD07A), _AppColors.gold, Color(0xFFB8912D)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _AppColors.gold.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long_outlined, color: Colors.black, size: 18),
              SizedBox(width: 8),
              Text(
                'VIEW BOOKING DETAILS',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Back Home Button ──
  Widget _buildBackHomeBtn() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: widget.onBackHome,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: _AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _AppColors.cardBorder),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.home_outlined,
                color: _AppColors.textSecondary,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'BACK TO HOME',
                style: TextStyle(
                  color: _AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// CONFIRMATION PAINTERS & MODELS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// ── Particle model ──
class _Particle {
  final double angle;
  final double distance;
  final double size;
  final double speed;
  final double opacity;

  _Particle(math.Random rng)
    : angle = rng.nextDouble() * math.pi * 2,
      distance = 40.0 + rng.nextDouble() * 28.0,
      size = 1.5 + rng.nextDouble() * 2.5,
      speed = 0.5 + rng.nextDouble() * 1.5,
      opacity = 0.3 + rng.nextDouble() * 0.7;
}

// ── Gold particle painter ──
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final p in particles) {
      final t = (progress * p.speed) % 1.0;
      // Particles spiral outward then fade
      final dist = p.distance + t * 20;
      final angle = p.angle + t * math.pi * 0.5;
      final fadeOut = (1.0 - t).clamp(0.0, 1.0);
      final fadeIn = (t * 3.0).clamp(0.0, 1.0);
      final alpha = p.opacity * fadeOut * fadeIn;

      final dx = center.dx + math.cos(angle) * dist;
      final dy = center.dy + math.sin(angle) * dist;

      final paint =
          Paint()
            ..color = color.withOpacity(alpha)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.size * 0.5);

      canvas.drawCircle(Offset(dx, dy), p.size, paint);

      // Tiny highlight
      final hlPaint = Paint()..color = Colors.white.withOpacity(alpha * 0.4);
      canvas.drawCircle(
        Offset(dx - p.size * 0.3, dy - p.size * 0.3),
        p.size * 0.35,
        hlPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) =>
      old.progress != progress;
}

// ── Animated checkmark painter ──
class _CheckPainter extends CustomPainter {
  final double progress;

  _CheckPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 4.5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final s = size.width * 0.28;

    // Check mark path: two segments
    final p1 = Offset(cx - s * 0.5, cy + s * 0.05);
    final p2 = Offset(cx - s * 0.05, cy + s * 0.45);
    final p3 = Offset(cx + s * 0.55, cy - s * 0.4);

    final path = Path();

    if (progress <= 0.5) {
      // First stroke segment (0→0.5)
      final t = progress / 0.5;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p1.dx + (p2.dx - p1.dx) * t, p1.dy + (p2.dy - p1.dy) * t);
    } else {
      // Full first segment + partial second
      final t = (progress - 0.5) / 0.5;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(p2.dx + (p3.dx - p2.dx) * t, p2.dy + (p3.dy - p2.dy) * t);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckPainter old) => old.progress != progress;
}
