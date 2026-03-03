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
  // ── 5. Sampath Bank ── dark red ───────────────────────────────────────────
  SLBankTheme(
    bank: SLBank.sampath,
    name: 'Sampath Bank',
    shortName: 'SAMPATH',
    gradientColors: [Color(0xFF8B1010), Color(0xFF5C0808), Color(0xFF300404)],
    accentColor: Color(0xFFFF6B35),
    isMastercard: true,
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
  // ── 10. NDB Bank ── indigo ────────────────────────────────────────────────
  SLBankTheme(
    bank: SLBank.ndb,
    name: 'NDB Bank',
    shortName: 'NDB',
    gradientColors: [Color(0xFF1A1A6A), Color(0xFF0E0E48), Color(0xFF06062A)],
    accentColor: Color(0xFF7986CB),
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

// ─── Page ─────────────────────────────────────────────────────────────────────
class BookingPage2 extends StatefulWidget {
  final ServiceModel service;
  final StaffModel staff;
  final DateTime date;
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
  // Controllers
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _cardNumberCtrl = TextEditingController();
  final _cardNameCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  SLBankTheme _bankTheme = kGenericTheme;
  bool _showCvv = false;
  bool _saveCard = true;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

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

    // ── KEY FIX: listen to card number changes and re-detect ──────────────────
    _cardNumberCtrl.addListener(_onCardNumberChanged);
    _cardNameCtrl.addListener(() => setState(() {}));
    _expiryCtrl.addListener(() => setState(() {}));

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  // ── Card number change handler ────────────────────────────────────────────
  void _onCardNumberChanged() {
    final detected = detectSLBank(_cardNumberCtrl.text);
    // Always call setState so card visual updates live as digits are typed
    setState(() => _bankTheme = detected);
  }

  @override
  void dispose() {
    _cardNumberCtrl.removeListener(_onCardNumberChanged);
    for (final c in [
      _nameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _noteCtrl,
      _cardNumberCtrl,
      _cardNameCtrl,
      _expiryCtrl,
      _cvvCtrl,
    ]) {
      c.dispose();
    }
    _pulseCtrl.dispose();
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
                _buildSectionHeader('Customer Details', Icons.person_outline),
                const SizedBox(height: 14),
                _buildCustomerForm(),
                const SizedBox(height: 24),
                _buildSectionHeader(
                  'Payment Method',
                  Icons.credit_card_outlined,
                ),
                const SizedBox(height: 14),
                _buildCreditCardVisual(),
                const SizedBox(height: 8),
                if (_bankTheme.bank != SLBank.other) _buildBankBadge(),
                const SizedBox(height: 16),
                _buildCardForm(),
                const SizedBox(height: 24),
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
        child: Column(
          children: [
            _inputField(
              _nameCtrl,
              'Full Name',
              'Nimal Perera',
              Icons.person_outline,
              TextInputType.name,
            ),
            const SizedBox(height: 14),
            _inputField(
              _emailCtrl,
              'Email Address',
              'hello@example.lk',
              Icons.mail_outline,
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            _inputField(
              _phoneCtrl,
              'Phone Number',
              '+94 77 123 4567',
              Icons.phone_outlined,
              TextInputType.phone,
            ),
            const SizedBox(height: 14),
            _inputField(
              _noteCtrl,
              'Special Notes (optional)',
              'Allergies, preferences...',
              Icons.notes_outlined,
              null,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController ctrl,
    String label,
    String hint,
    IconData icon,
    TextInputType? keyboardType, {
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
          controller: ctrl,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: _AppColors.textPrimary, fontSize: 14),
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

  // ── Bank Detected Badge ───────────────────────────────────────────────────────
  Widget _buildBankBadge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: _bankTheme.gradientColors.first.withOpacity(0.25),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _bankTheme.accentColor.withOpacity(0.5),
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
                      color: _bankTheme.accentColor.withOpacity(
                        _pulseAnim.value,
                      ),
                    ),
                  ),
            ),
            const SizedBox(width: 9),
            Text(
              '${_bankTheme.name} card detected',
              style: TextStyle(
                color: _bankTheme.accentColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.verified_outlined,
              color: _bankTheme.accentColor,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  // ── Credit Card Visual ────────────────────────────────────────────────────────
  // AnimatedContainer smoothly transitions colors when bank changes
  Widget _buildCreditCardVisual() {
    final t = _bankTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: AnimatedContainer(
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
              color: t.gradientColors.first.withOpacity(0.55),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: t.accentColor.withOpacity(0.15),
              blurRadius: 40,
              spreadRadius: -5,
              offset: const Offset(0, 20),
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
                    // Top row: Bank name + contactless icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _bankNameWidget(t)),
                        const SizedBox(width: 8),
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
                    // EMV Chip + Card number
                    Row(
                      children: [
                        _chip(),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            _maskedCard,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.92),
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
                              ],
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
                                _cardNameCtrl.text.isEmpty
                                    ? 'YOUR NAME'
                                    : _cardNameCtrl.text.toUpperCase(),
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
                              _expiryCtrl.text.isEmpty
                                  ? 'MM/YY'
                                  : _expiryCtrl.text,
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

      // ── People's Bank: Leaf/nature pattern ────────────────────────────────
      case SLBank.peoples:
        return Stack(
          children: [
            // Large organic sweep
            Positioned(
              right: -70,
              bottom: -80,
              child: _waveShape(300, 180, t.accentColor, 0.10, rotate: 0.3),
            ),
            Positioned(
              right: -50,
              bottom: -60,
              child: _waveShape(240, 130, Colors.white, 0.04, rotate: 0.25),
            ),
            // Leaf-like arcs
            Positioned(
              left: -30,
              top: -30,
              child: _arcLine(120, t.accentColor, 0.09, 2),
            ),
            Positioned(
              left: -10,
              top: -10,
              child: _arcLine(80, Colors.white, 0.05, 1.5),
            ),
            // Small decorative dots
            Positioned(right: 50, top: 20, child: _oval(8, Colors.white, 0.12)),
            Positioned(right: 70, top: 35, child: _oval(5, Colors.white, 0.08)),
            Positioned(
              right: 40,
              top: 40,
              child: _oval(6, t.accentColor, 0.15),
            ),
            // Diagonal stripe
            Positioned(
              left: 30,
              bottom: 25,
              child: Transform.rotate(
                angle: -0.6,
                child: Container(
                  width: 100,
                  height: 1.5,
                  color: t.accentColor.withOpacity(0.08),
                ),
              ),
            ),
          ],
        );

      // ── Amāna Bank: Islamic geometric / star pattern ──────────────────────
      case SLBank.amana:
        return Stack(
          children: [
            // Large geometric circle
            Positioned(
              right: -60,
              top: -60,
              child: _arcLine(220, t.accentColor, 0.08, 2),
            ),
            Positioned(
              right: -40,
              top: -40,
              child: _arcLine(180, t.accentColor, 0.06, 1.5),
            ),
            Positioned(
              right: -20,
              top: -20,
              child: _arcLine(140, Colors.white, 0.04, 1),
            ),
            // Star/diamond pattern
            Positioned(
              left: 15,
              bottom: 30,
              child: _diamond(20, t.accentColor, 0.18),
            ),
            Positioned(
              left: 40,
              bottom: 20,
              child: _diamond(14, Colors.white, 0.08),
            ),
            Positioned(
              left: 28,
              bottom: 50,
              child: _diamond(10, t.accentColor, 0.12),
            ),
            // Sweep from bottom
            Positioned(
              left: -80,
              bottom: -50,
              child: _waveShape(280, 100, t.accentColor, 0.06, rotate: 0.1),
            ),
          ],
        );

      // ── Commercial Bank: Strong diagonal bands ────────────────────────────
      case SLBank.commercial:
        return Stack(
          children: [
            // Bold diagonal bands
            Positioned(
              right: -40,
              top: -20,
              child: Transform.rotate(
                angle: -0.55,
                child: Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                    color: t.accentColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -60,
              top: 10,
              child: Transform.rotate(
                angle: -0.55,
                child: Container(
                  width: 250,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            // Globe-like arcs
            Positioned(
              left: -50,
              bottom: -50,
              child: _arcLine(160, t.accentColor, 0.08, 2),
            ),
            Positioned(
              left: -30,
              bottom: -30,
              child: _arcLine(120, Colors.white, 0.04, 1.5),
            ),
            // Corner accent
            Positioned(
              right: 15,
              bottom: 15,
              child: _oval(40, t.accentColor, 0.12),
            ),
            Positioned(
              right: 25,
              bottom: 25,
              child: _oval(20, Colors.white, 0.08),
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

      // ── HNB: Lion/heritage pattern ────────────────────────────────────────
      case SLBank.hatton:
        return Stack(
          children: [
            // Large decorative circle (shield-like)
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: t.accentColor.withOpacity(0.12),
                    width: 3,
                  ),
                ),
              ),
            ),
            Positioned(
              right: -10,
              top: -10,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: t.accentColor.withOpacity(0.08),
                    width: 2,
                  ),
                ),
              ),
            ),
            // Cross pattern inside circle
            Positioned(
              right: 30,
              top: 30,
              child: Container(
                width: 60,
                height: 2,
                color: t.accentColor.withOpacity(0.10),
              ),
            ),
            Positioned(
              right: 58,
              top: 2,
              child: Container(
                width: 2,
                height: 60,
                color: t.accentColor.withOpacity(0.10),
              ),
            ),
            // Wave from bottom-left
            Positioned(
              left: -60,
              bottom: -40,
              child: _waveShape(240, 100, Colors.black, 0.15, rotate: -0.15),
            ),
            Positioned(
              left: -40,
              bottom: -25,
              child: _waveShape(180, 65, t.accentColor, 0.10, rotate: -0.1),
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

      // ── NDB: Geometric modern ─────────────────────────────────────────────
      case SLBank.ndb:
        return Stack(
          children: [
            // Layered rectangles
            Positioned(
              right: -30,
              top: -20,
              child: Transform.rotate(
                angle: 0.3,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: t.accentColor.withOpacity(0.08),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -10,
              top: 0,
              child: Transform.rotate(
                angle: 0.3,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: t.accentColor.withOpacity(0.04),
                  ),
                ),
              ),
            ),
            // Bottom sweep
            Positioned(
              left: -70,
              bottom: -30,
              child: _waveShape(260, 80, t.accentColor, 0.06, rotate: -0.1),
            ),
            Positioned(
              left: 20,
              bottom: 15,
              child: _oval(10, t.accentColor, 0.15),
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

    // Default Visa
    return Text(
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
            _buildAcceptedBanksRow(),
            const SizedBox(height: 18),

            // Card Number
            _lbl('Card Number'),
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
                          suffixIcon: GestureDetector(
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
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
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

  // ── Accepted Banks Row ────────────────────────────────────────────────────────
  Widget _buildAcceptedBanksRow() {
    final banks = [
      {'label': 'BOC', 'bank': SLBank.boc, 'color': const Color(0xFF1B6B2A)},
      {
        'label': "PEOPLE'S",
        'bank': SLBank.peoples,
        'color': const Color(0xFF1A5C1A),
      },
      {
        'label': 'AMĀNA',
        'bank': SLBank.amana,
        'color': const Color(0xFF3A2070),
      },
      {
        'label': 'COMBANK',
        'bank': SLBank.commercial,
        'color': const Color(0xFF0A2A5E),
      },
      {
        'label': 'SAMPATH',
        'bank': SLBank.sampath,
        'color': const Color(0xFF8B1010),
      },
      {'label': 'HNB', 'bank': SLBank.hatton, 'color': const Color(0xFF7A4A10)},
      {'label': 'NSB', 'bank': SLBank.nsb, 'color': const Color(0xFF006060)},
      {'label': 'DFCC', 'bank': SLBank.dfcc, 'color': const Color(0xFF1A3A6A)},
      {
        'label': 'SEYLAN',
        'bank': SLBank.seylan,
        'color': const Color(0xFF005A5A),
      },
      {'label': 'NDB', 'bank': SLBank.ndb, 'color': const Color(0xFF1A1A6A)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Accepted Cards',
          style: TextStyle(
            color: _AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                banks.map((b) {
                  final color = b['color'] as Color;
                  // ── FIX: compare by SLBank enum, not by string ──────────────────
                  final isActive = _bankTheme.bank == b['bank'] as SLBank;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 7),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(isActive ? 0.35 : 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: color.withOpacity(isActive ? 1.0 : 0.3),
                        width: isActive ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      b['label'] as String,
                      style: TextStyle(
                        color: color.withOpacity(isActive ? 1.0 : 0.6),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  // ── Confirm Button ────────────────────────────────────────────────────────────
  Widget _buildConfirmButton() {
    final total = widget.service.price + 12.50;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
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
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {},
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
                    const Icon(
                      Icons.lock_outline,
                      color: Colors.black,
                      size: 18,
                    ),
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
          ),
        ],
      ),
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
    final text = newValue.text.replaceAll('/', '');
    if (text.length <= 2) return newValue.copyWith(text: text);
    final result = '${text.substring(0, 2)}/${text.substring(2)}';
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
