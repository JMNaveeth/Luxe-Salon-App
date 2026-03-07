import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'booking_page_1.dart';
import 'booking_page_3.dart';
import 'bottom_nav.dart';
import '../theme/app_colors.dart';

enum _StepState { done, active, inactive }

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

class _BookingPage2State extends State<BookingPage2> {
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _submitted = false;

  // ── Validators ──
  static final _emailRegex = RegExp(
    r'^[\w.+-]+@[\w-]+(\.[a-zA-Z]+)*\.[a-zA-Z]{3,}$',
  );
  // SL numbers: 07X XXXX XXX (10 digits) or +947X XXXX XXX
  static final _slPhoneRegex = RegExp(r'^(?:\+94|0)7[0-9]{8}$');

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    if (v.trim().length < 2) return 'Enter at least 2 characters';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone number is required';
    final digits = v.replaceAll(RegExp(r'[\s\-]'), '');
    if (!_slPhoneRegex.hasMatch(digits))
      return 'Enter a valid SL number (07X XXXX XXX)';
    return null;
  }

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
  void dispose() {
    for (final c in [_nameCtrl, _emailCtrl, _phoneCtrl, _noteCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
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
                const SizedBox(height: 28),
                _buildContinueButton(),
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
      backgroundColor: AppColors.bg,
      elevation: 0,
      leading: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ),
      ),
      title: const Text(
        'Your Details',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.bold,
          fontFamily: 'Georgia',
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.divider, height: 1),
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
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone || isActive ? AppColors.gold : AppColors.stepInactive,
            border:
                isActive
                    ? Border.all(
                      color: AppColors.goldLight.withOpacity(0.4),
                      width: 2,
                    )
                    : null,
          ),
          child:
              isDone
                  ? const Icon(Icons.check, color: Colors.black, size: 16)
                  : Center(
                    child: Text(
                      '$n',
                      style: TextStyle(
                        color:
                            isActive ? Colors.black : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isDone || isActive ? AppColors.gold : AppColors.textMuted,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool active) => Expanded(
    child: Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        color: active ? AppColors.gold : AppColors.stepInactive,
      ),
    ),
  );

  // ── Booking Summary Banner ──────────────────────────────────────────────────
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
            colors: [Color(0xFF1A1830), Color(0xFF101020)],
          ),
          border: Border.all(color: AppColors.goldDim, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.goldDim,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.content_cut,
                color: AppColors.gold,
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
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'with ${widget.staff.name}  •  ${_formatDate(widget.date)}  •  ${widget.time}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Rs ${widget.service.price.toStringAsFixed(0)}',
              style: const TextStyle(
                color: AppColors.gold,
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
          Icon(icon, color: AppColors.gold, size: 16),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
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
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Form(
          key: _formKey,
          autovalidateMode:
              _submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
          child: Column(
            children: [
              _inputField(
                _nameCtrl,
                'Full Name',
                'Nimal Perera',
                Icons.person_outline,
                TextInputType.name,
                validator: _validateName,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s'.\-]")),
                ],
              ),
              const SizedBox(height: 14),
              _inputField(
                _emailCtrl,
                'Email Address',
                'hello@gmail.com',
                Icons.mail_outline,
                TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 14),
              _inputField(
                _phoneCtrl,
                'Phone Number',
                '077 123 4567',
                Icons.phone_outlined,
                TextInputType.phone,
                validator: _validatePhone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-]')),
                  LengthLimitingTextInputFormatter(15),
                ],
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
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
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
          validator: validator,
          inputFormatters: inputFormatters,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFCF6679),
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFCF6679),
                width: 1.5,
              ),
            ),
            errorStyle: const TextStyle(color: Color(0xFFCF6679), fontSize: 11),
          ),
        ),
      ],
    );
  }

  // ── Continue Button ──────────────────────────────────────────────────────────
  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() => _submitted = true);
            if (!_formKey.currentState!.validate()) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BookingPage3(
                      service: widget.service,
                      staff: widget.staff,
                      date: widget.date,
                      time: widget.time,
                      customerName: _nameCtrl.text,
                      customerEmail: _emailCtrl.text,
                      customerPhone: _phoneCtrl.text,
                      customerNote: _noteCtrl.text,
                    ),
              ),
            );
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.goldLight, AppColors.gold],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.4),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CONTINUE TO PAYMENT',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
