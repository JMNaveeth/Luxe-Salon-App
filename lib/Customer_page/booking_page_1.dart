import 'package:flutter/material.dart';
import 'booking_page_2.dart';
import 'bottom_nav.dart';
import '../theme/app_colors.dart';

// ─── Models ───────────────────────────────────────────────────────────────────
class ServiceModel {
  final String title;
  final String subtitle;
  final String duration;
  final double price;
  final IconData icon;
  const ServiceModel({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.price,
    required this.icon,
  });
}

class StaffModel {
  final String name;
  final String role;
  final double rating;
  final String initials;
  final Color avatarColor;
  const StaffModel({
    required this.name,
    required this.role,
    required this.rating,
    required this.initials,
    required this.avatarColor,
  });
}

// ─── Step Enum ────────────────────────────────────────────────────────────────
enum BookingStepState { done, active, inactive }

// ─── Page ─────────────────────────────────────────────────────────────────────
class BookingPage1 extends StatefulWidget {
  const BookingPage1({super.key});

  @override
  State<BookingPage1> createState() => _BookingPage1State();
}

class _BookingPage1State extends State<BookingPage1>
    with SingleTickerProviderStateMixin {
  int _selectedService = -1;
  int _selectedStaff = -1;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 11, minute: 0);

  late AnimationController _shimmerController;

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

  String _formatDate(DateTime d) {
    return '${_weekdays[d.weekday - 1]}, ${_months[d.month - 1]} ${d.day}';
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final min = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$min $period';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.gold,
              onPrimary: Colors.black,
              surface: AppColors.card,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.bg,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // Mock bookings mirroring Supabase representation
  // Map of date string "YYYY-MM-DD" to list of booked TimeOfDay slots
  final Map<String, List<TimeOfDay>> _mockSupabaseBookings = {
    // Inject some fake bookings for today
    "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}":
        [
          const TimeOfDay(hour: 10, minute: 0),
          const TimeOfDay(hour: 10, minute: 30),
          const TimeOfDay(hour: 14, minute: 0),
        ],
  };

  // Fixed interval for available slots
  final int _slotIntervalMins = 30;

  // Check if a generated slot heavily overlaps with any booked slots
  bool _isSlotAvailable(TimeOfDay slot) {
    if (_selectedService == -1) return true; // Only apply if service selected

    final dateKey =
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
    final bookedSlots = _mockSupabaseBookings[dateKey] ?? [];

    // Requested time in minutes from midnight
    final requestedStart = slot.hour * 60 + slot.minute;

    // Duration in minutes (extracted from service model like "60 min")
    final durationString = _services[_selectedService].duration;
    final durationMins = int.tryParse(durationString.split(' ')[0]) ?? 60;
    final requestedEnd = requestedStart + durationMins;

    for (var booked in bookedSlots) {
      final bookedStart = booked.hour * 60 + booked.minute;
      // We assume other bookings take roughly 60 mins for mock purposes
      // (In actual Supabase, the DB constraint evaluates the exact duration)
      final bookedEnd = bookedStart + 60;

      // Overlap formula: Start1 < End2 AND Start2 < End1
      if (requestedStart < bookedEnd && bookedStart < requestedEnd) {
        return false; // Intersects!
      }
    }
    return true; // Safe to book
  }

  void _pickTime() {
    if (_selectedService == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a service first to calculate time constraints.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.textPrimary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Generate slots from 9:00 AM to 6:00 PM
    List<TimeOfDay> generatedSlots = [];
    for (int hour = 9; hour < 18; hour++) {
      for (int minute = 0; minute < 60; minute += _slotIntervalMins) {
        generatedSlots.add(TimeOfDay(hour: hour, minute: minute));
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Available Times',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: generatedSlots.length,
                  itemBuilder: (context, index) {
                    final slot = generatedSlots[index];
                    final isAvailable = _isSlotAvailable(slot);
                    final isSelected = _selectedTime == slot;

                    return InkWell(
                      onTap:
                          isAvailable
                              ? () {
                                setState(() => _selectedTime = slot);
                                Navigator.pop(context);
                              }
                              : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.gold
                                  : isAvailable
                                  ? AppColors.bg
                                  : AppColors.cardBorder.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppColors.gold
                                    : AppColors.cardBorder,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _formatTime(slot),
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Colors.black
                                    : isAvailable
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            decoration:
                                isAvailable ? null : TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  final List<ServiceModel> _services = const [
    ServiceModel(
      title: 'Elite Hair Sculpting',
      subtitle: 'Precision cut & style by master artists',
      duration: '60 min',
      price: 120.00,
      icon: Icons.content_cut,
    ),
    ServiceModel(
      title: 'Luxury Color Treatment',
      subtitle: 'Full balayage & toning therapy',
      duration: '120 min',
      price: 220.00,
      icon: Icons.palette_outlined,
    ),
    ServiceModel(
      title: 'Scalp Ritual',
      subtitle: 'Deep cleanse & revitalizing massage',
      duration: '45 min',
      price: 85.00,
      icon: Icons.spa_outlined,
    ),
    ServiceModel(
      title: 'Signature Blowout',
      subtitle: 'Voluminous finish with premium products',
      duration: '40 min',
      price: 65.00,
      icon: Icons.air,
    ),
  ];

  final List<StaffModel> _staff = const [
    StaffModel(
      name: 'Marco Silva',
      role: 'Master Stylist',
      rating: 4.9,
      initials: 'MS',
      avatarColor: Color(0xFF2A2060),
    ),
    StaffModel(
      name: 'Isabelle Roy',
      role: 'Color Specialist',
      rating: 4.8,
      initials: 'IR',
      avatarColor: Color(0xFF1A3050),
    ),
    StaffModel(
      name: 'Lena Park',
      role: 'Senior Artist',
      rating: 4.7,
      initials: 'LP',
      avatarColor: Color(0xFF3A1A30),
    ),
    StaffModel(
      name: 'Any Available',
      role: 'First Available',
      rating: 0,
      initials: '✦',
      avatarColor: Color(0xFF1E2440),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                  _buildSalonCard(),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Select Service', Icons.auto_awesome),
                  const SizedBox(height: 12),
                  _buildServiceList(),
                  const SizedBox(height: 24),
                  _buildSectionHeader(
                    'Select Staff',
                    Icons.person_pin_outlined,
                  ),
                  const SizedBox(height: 14),
                  _buildStaffRow(),
                  const SizedBox(height: 24),
                  _buildDateTimePickers(),
                  const SizedBox(height: 24),
                  _buildContinueButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const LuxeBottomNav(currentIndex: 2),
      ),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,

      title: const Text(
        'Book Appointment',
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
          _buildStep(
            number: 1,
            label: 'BOOKING',
            state: BookingStepState.active,
          ),
          _buildStepLine(active: false),
          _buildStep(
            number: 2,
            label: 'DETAILS',
            state: BookingStepState.inactive,
          ),
          _buildStepLine(active: false),
          _buildStep(
            number: 3,
            label: 'CONFIRM',
            state: BookingStepState.inactive,
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required int number,
    required String label,
    required BookingStepState state,
  }) {
    final isActive = state == BookingStepState.active;
    final isDone = state == BookingStepState.done;
    final isInactive = state == BookingStepState.inactive;

    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isInactive ? AppColors.stepInactive : AppColors.gold,
            border: Border.all(
              color: isInactive ? AppColors.cardBorder : AppColors.gold,
              width: 2,
            ),
            boxShadow:
                isActive
                    ? [
                      BoxShadow(
                        color: AppColors.gold.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                    : null,
          ),
          child: Center(
            child:
                isDone
                    ? const Icon(Icons.check, color: Colors.black, size: 16)
                    : Text(
                      '$number',
                      style: TextStyle(
                        color: isInactive ? AppColors.textMuted : Colors.black,
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
            color: isInactive ? AppColors.textMuted : AppColors.gold,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
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
        decoration: BoxDecoration(
          gradient:
              active
                  ? const LinearGradient(
                    colors: [AppColors.gold, AppColors.goldDim],
                  )
                  : null,
          color: active ? null : AppColors.cardBorder,
        ),
      ),
    );
  }

  // ── Salon Card ───────────────────────────────────────────────────────────────
  Widget _buildSalonCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.surface,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 12),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Column(
          children: [
            // Salon image strip
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: Stack(
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=800',
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          height: 130,
                          color: AppColors.surface,
                          child: const Center(
                            child: Icon(
                              Icons.store,
                              color: AppColors.gold,
                              size: 40,
                            ),
                          ),
                        ),
                  ),
                  // Gradient overlay
                  Container(
                    height: 130,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.surface.withValues(alpha: 0.95),
                        ],
                      ),
                    ),
                  ),
                  // Rating badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.black, size: 12),
                          SizedBox(width: 3),
                          Text(
                            '4.9',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Salon name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Text(
                'L\'Élégance Salon',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                  fontStyle: FontStyle.italic,
                ),
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

  // ── Services ─────────────────────────────────────────────────────────────────
  Widget _buildServiceList() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final s = _services[index];
          final selected = _selectedService == index;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => setState(() => _selectedService = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 155,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? AppColors.gold : Colors.white,
                    width: selected ? 1.5 : 2,
                  ),
                  boxShadow:
                      selected
                          ? [
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ]
                          : [
                            BoxShadow(
                              color: AppColors.textPrimary.withValues(
                                alpha: 0.04,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color:
                                selected
                                    ? AppColors.gold.withValues(alpha: 0.2)
                                    : AppColors.bg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            s.icon,
                            color:
                                selected
                                    ? AppColors.gold
                                    : AppColors.textSecondary,
                            size: 18,
                          ),
                        ),
                        if (selected)
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.gold,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 12,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      s.title,
                      style: TextStyle(
                        color:
                            selected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          s.duration,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          'Rs ${s.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color:
                                selected
                                    ? AppColors.gold
                                    : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Staff ────────────────────────────────────────────────────────────────────
  Widget _buildStaffRow() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: _staff.length,
        itemBuilder: (context, index) {
          final s = _staff[index];
          final selected = _selectedStaff == index;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => setState(() => _selectedStaff = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 82,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? AppColors.gold : Colors.white,
                    width: selected ? 1.5 : 2,
                  ),
                  boxShadow:
                      selected
                          ? [
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ]
                          : [
                            BoxShadow(
                              color: AppColors.textPrimary.withValues(
                                alpha: 0.04,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: s.avatarColor,
                        border: Border.all(
                          color: selected ? AppColors.gold : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          s.initials,
                          style: TextStyle(
                            color:
                                selected
                                    ? AppColors.gold
                                    : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      s.name.split(' ').first,
                      style: TextStyle(
                        color:
                            selected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (s.rating > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.gold,
                            size: 9,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${s.rating}',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Date & Time Picker Buttons ────────────────────────────────────────────
  Widget _buildDateTimePickers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textPrimary.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.gold,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(_selectedDate),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _pickTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textPrimary.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.schedule_outlined,
                        color: AppColors.gold,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Time',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatTime(_selectedTime),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Continue Button ─────────────────────────────────────────────────────────
  Widget _buildContinueButton() {
    final hasService = _selectedService >= 0;
    final hasStaff = _selectedStaff >= 0;
    final canContinue = hasService && hasStaff;
    final service = hasService ? _services[_selectedService] : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasService ? service!.title : 'No service selected',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              Text(
                hasService
                    ? 'Rs ${service!.price.toStringAsFixed(2)}'
                    : 'Rs 0.00',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap:
                    canContinue
                        ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => BookingPage2(
                                    service: _services[_selectedService],
                                    staff: _staff[_selectedStaff],
                                    date: _selectedDate,
                                    time: _formatTime(_selectedTime),
                                  ),
                            ),
                          );
                        }
                        : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                !hasService && !hasStaff
                                    ? 'Please select a service and staff'
                                    : !hasService
                                    ? 'Please select a service'
                                    : 'Please select a staff member',
                                style: const TextStyle(
                                  color: Colors.white,
                                ), // Set text color to white to be visible on dark background or set explicitly
                              ),
                              backgroundColor:
                                  AppColors
                                      .textPrimary, // Made background darker so white text is readable
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: canContinue ? AppColors.primaryGradient : null,
                    color: canContinue ? null : AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow:
                        canContinue
                            ? [
                              BoxShadow(
                                color: AppColors.gold.withValues(alpha: 0.3),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ]
                            : [],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color:
                              canContinue
                                  ? Colors.white
                                  : AppColors.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color:
                            canContinue
                                ? Colors.black
                                : AppColors.textSecondary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
