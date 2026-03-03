import 'package:flutter/material.dart';
import 'booking_page_2.dart';

// ─── Color Palette ────────────────────────────────────────────────────────────
class AppColors {
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
  int _selectedService = 0;
  int _selectedStaff = 0;
  DateTime _selectedDate = DateTime.now();
  int _selectedTime = 3;

  late AnimationController _shimmerController;

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
      avatarColor: Color(0xFF3A2A6A),
    ),
    StaffModel(
      name: 'Isabelle Roy',
      role: 'Color Specialist',
      rating: 4.8,
      initials: 'IR',
      avatarColor: Color(0xFF1A3A2A),
    ),
    StaffModel(
      name: 'Lena Park',
      role: 'Senior Artist',
      rating: 4.7,
      initials: 'LP',
      avatarColor: Color(0xFF3A1A1A),
    ),
    StaffModel(
      name: 'Any Available',
      role: 'First Available',
      rating: 0,
      initials: '✦',
      avatarColor: Color(0xFF2A2A10),
    ),
  ];

  final List<String> _times = const [
    '9:00',
    '10:00',
    '11:00',
    '2:00',
    '3:00',
    '3:30',
    '4:00',
    '5:30',
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
                    _buildSectionHeader(
                      'Select Date',
                      Icons.calendar_month_outlined,
                    ),
                    const SizedBox(height: 14),
                    _buildDateRow(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Select Time', Icons.schedule_outlined),
                    const SizedBox(height: 14),
                    _buildTimeGrid(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomButton()),
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
        onTap: () => Navigator.pop(context),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.textPrimary,
          size: 18,
        ),
      ),
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
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1E12), Color(0xFF141408)],
          ),
          border: Border.all(color: AppColors.cardBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Salon image strip
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
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
                          AppColors.card.withOpacity(0.85),
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
          return GestureDetector(
            onTap: () => setState(() => _selectedService = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 155,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                    selected
                        ? AppColors.goldDim.withOpacity(0.6)
                        : AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? AppColors.gold : AppColors.cardBorder,
                  width: selected ? 1.5 : 1,
                ),
                boxShadow:
                    selected
                        ? [
                          BoxShadow(
                            color: AppColors.gold.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ]
                        : [],
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
                                  ? AppColors.gold.withOpacity(0.2)
                                  : AppColors.surface,
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
                        '\$${s.price.toStringAsFixed(0)}',
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
          return GestureDetector(
            onTap: () => setState(() => _selectedStaff = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 82,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color:
                    selected
                        ? AppColors.goldDim.withOpacity(0.5)
                        : AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? AppColors.gold : AppColors.cardBorder,
                  width: selected ? 1.5 : 1,
                ),
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
                        const Icon(Icons.star, color: AppColors.gold, size: 9),
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
          );
        },
      ),
    );
  }

  // ── Date Picker (Calendar) ────────────────────────────────────────────────────
  Widget _buildDateRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.gold,
              onPrimary: Colors.black,
              surface: AppColors.card,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.gold),
            ),
          ),
          child: CalendarDatePicker(
            initialDate: _selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 90)),
            onDateChanged: (date) {
              setState(() => _selectedDate = date);
            },
          ),
        ),
      ),
    );
  }

  // ── Time Grid ─────────────────────────────────────────────────────────────────
  Widget _buildTimeGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 2.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _times.length,
        itemBuilder: (context, index) {
          final selected = _selectedTime == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTime = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: selected ? AppColors.gold : AppColors.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected ? AppColors.gold : AppColors.cardBorder,
                ),
                boxShadow:
                    selected
                        ? [
                          BoxShadow(
                            color: AppColors.gold.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                        : [],
              ),
              child: Center(
                child: Text(
                  '${_times[index]} PM',
                  style: TextStyle(
                    color: selected ? Colors.black : AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Bottom CTA ────────────────────────────────────────────────────────────────
  Widget _buildBottomButton() {
    final service = _services[_selectedService];
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 36),
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                service.title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              Text(
                '\$${service.price.toStringAsFixed(2)}',
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
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BookingPage2(
                          service: _services[_selectedService],
                          staff: _staff[_selectedStaff],
                          date: _selectedDate,
                          time: _times[_selectedTime],
                        ),
                  ),
                );
              },
              child: Container(
                height: 54,
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
                      'Continue',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.black, size: 18),
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
