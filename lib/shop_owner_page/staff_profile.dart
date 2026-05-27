import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'staff_management.dart';

// ─── Supplementary Data Models ────────────────────────────────────────────────

class ScheduleEntry {
  final String day;
  final String startTime;
  final String endTime;
  final bool isOff;

  const ScheduleEntry({
    required this.day,
    required this.startTime,
    required this.endTime,
    this.isOff = false,
  });
}

class BookingRecord {
  final String clientName;
  final String clientInitial;
  final String service;
  final String date;
  final String time;
  final String status; // 'completed', 'upcoming', 'cancelled'
  final double amount;

  const BookingRecord({
    required this.clientName,
    required this.clientInitial,
    required this.service,
    required this.date,
    required this.time,
    required this.status,
    required this.amount,
  });
}

// ─── Staff Profile Screen ─────────────────────────────────────────────────────

class StaffProfileScreen extends StatefulWidget {
  final StaffMember member;

  const StaffProfileScreen({super.key, required this.member});

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ── Sample weekly schedule ──
  final List<ScheduleEntry> _schedule = const [
    ScheduleEntry(day: 'MON', startTime: '09:00 AM', endTime: '06:00 PM'),
    ScheduleEntry(day: 'TUE', startTime: '09:00 AM', endTime: '06:00 PM'),
    ScheduleEntry(day: 'WED', startTime: '10:00 AM', endTime: '07:00 PM'),
    ScheduleEntry(day: 'THU', startTime: '09:00 AM', endTime: '06:00 PM'),
    ScheduleEntry(day: 'FRI', startTime: '09:00 AM', endTime: '08:00 PM'),
    ScheduleEntry(day: 'SAT', startTime: '10:00 AM', endTime: '05:00 PM'),
    ScheduleEntry(day: 'SUN', startTime: '', endTime: '', isOff: true),
  ];

  // ── Sample service specialties ──
  final List<Map<String, dynamic>> _specialties = const [
    {'name': 'Haircut & Style', 'icon': Icons.content_cut, 'color': Color(0xFF4F8CFF)},
    {'name': 'Hair Coloring', 'icon': Icons.palette_outlined, 'color': Color(0xFF7C6CFF)},
    {'name': 'Deep Conditioning', 'icon': Icons.spa_outlined, 'color': Color(0xFF2BB673)},
    {'name': 'Keratin Treatment', 'icon': Icons.auto_awesome_outlined, 'color': Color(0xFFFFA44D)},
    {'name': 'Blowout & Finish', 'icon': Icons.air_outlined, 'color': Color(0xFFFF4FA3)},
    {'name': 'Balayage', 'icon': Icons.brush_outlined, 'color': Color(0xFFFF5C6F)},
  ];

  // ── Sample booking history ──
  final List<BookingRecord> _bookings = const [
    BookingRecord(
      clientName: 'Aisha Patel',
      clientInitial: 'A',
      service: 'Hair Coloring',
      date: 'Today',
      time: '10:30 AM',
      status: 'upcoming',
      amount: 2800,
    ),
    BookingRecord(
      clientName: 'Rahul Mehta',
      clientInitial: 'R',
      service: 'Haircut & Style',
      date: 'Today',
      time: '12:00 PM',
      status: 'upcoming',
      amount: 650,
    ),
    BookingRecord(
      clientName: 'Sneha Iyer',
      clientInitial: 'S',
      service: 'Keratin Treatment',
      date: 'Yesterday',
      time: '03:00 PM',
      status: 'completed',
      amount: 4500,
    ),
    BookingRecord(
      clientName: 'Priya Kapoor',
      clientInitial: 'P',
      service: 'Balayage',
      date: 'May 25',
      time: '11:00 AM',
      status: 'completed',
      amount: 5200,
    ),
    BookingRecord(
      clientName: 'Nisha Roy',
      clientInitial: 'N',
      service: 'Deep Conditioning',
      date: 'May 24',
      time: '02:30 PM',
      status: 'completed',
      amount: 1200,
    ),
    BookingRecord(
      clientName: 'Ankit Singh',
      clientInitial: 'A',
      service: 'Blowout & Finish',
      date: 'May 23',
      time: '04:00 PM',
      status: 'cancelled',
      amount: 900,
    ),
    BookingRecord(
      clientName: 'Divya Nair',
      clientInitial: 'D',
      service: 'Hair Coloring',
      date: 'May 22',
      time: '10:00 AM',
      status: 'completed',
      amount: 3100,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final member = widget.member;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // ── Collapsible Hero Header ──
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.bg,
            elevation: 0,
            leading: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: AppColors.gold,
                    size: 22,
                  ),
                ),
              ),
            ),
            title: AnimatedOpacity(
              opacity: innerBoxIsScrolled ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                member.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _HeroSection(member: member),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: AppColors.bg,
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.gold,
                  unselectedLabelColor: AppColors.textMuted,
                  indicatorColor: AppColors.gold,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 2.5,
                  labelStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                  tabs: const [
                    Tab(text: 'SCHEDULE'),
                    Tab(text: 'SPECIALTIES'),
                    Tab(text: 'BOOKINGS'),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // ── Tab 1: Weekly Schedule ──
            _ScheduleTab(schedule: _schedule),

            // ── Tab 2: Service Specialties ──
            _SpecialtiesTab(specialties: _specialties),

            // ── Tab 3: Booking History ──
            _BookingsTab(bookings: _bookings),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final StaffMember member;

  const _HeroSection({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: member.avatarColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: member.avatarColor.withOpacity(0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: member.avatarColor.withOpacity(0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: member.imagePath != null &&
                              member.imagePath!.isNotEmpty
                          ? (member.imagePath!.startsWith('http')
                              ? Image.network(
                                  member.imagePath!,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(member.imagePath!),
                                  fit: BoxFit.cover,
                                ))
                          : Center(
                              child: Text(
                                member.name.substring(0, 1),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: member.avatarColor,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                            ),
                    ),
                  ),
                  // On-duty indicator
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: member.isOnDuty
                            ? AppColors.green
                            : AppColors.textMuted,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.bg, width: 2.5),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // Name / Role / Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontFamily: 'Georgia',
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.role,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: member.isOnDuty
                            ? AppColors.greenFaint
                            : AppColors.cardBorder,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: member.isOnDuty
                                  ? AppColors.green
                                  : AppColors.textMuted,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            member.isOnDuty ? 'On Duty' : 'Day Off',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: member.isOnDuty
                                  ? AppColors.green
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Rating badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.goldFaint,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.gold, size: 18),
                    const SizedBox(height: 2),
                    Text(
                      member.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.gold,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const Text(
                      'RATING',
                      style: TextStyle(
                        fontSize: 8,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Quick Stats Row
          Row(
            children: [
              _QuickStat(label: 'Bookings', value: '14', sub: 'today'),
              _dividerV(),
              _QuickStat(label: 'This Week', value: '62', sub: 'sessions'),
              _dividerV(),
              _QuickStat(label: 'Total', value: '1,248', sub: 'all time'),
              _dividerV(),
              _QuickStat(label: 'Revenue', value: '₹84K', sub: 'this month'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dividerV() => Container(
        width: 1,
        height: 32,
        color: AppColors.cardBorder,
        margin: const EdgeInsets.symmetric(horizontal: 10),
      );
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final String sub;

  const _QuickStat(
      {required this.label, required this.value, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              fontFamily: 'Georgia',
            ),
          ),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tab 1: Weekly Schedule ───────────────────────────────────────────────────

class _ScheduleTab extends StatelessWidget {
  final List<ScheduleEntry> schedule;

  const _ScheduleTab({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      children: [
        _SectionLabel(label: 'WEEKLY SCHEDULE', icon: Icons.calendar_month_outlined),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: List.generate(schedule.length, (i) {
              final entry = schedule[i];
              final isLast = i == schedule.length - 1;
              return Column(
                children: [
                  _ScheduleRow(entry: entry),
                  if (!isLast)
                    const Divider(
                        height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                ],
              );
            }),
          ),
        ),

        const SizedBox(height: 24),
        _SectionLabel(label: 'BREAK TIMES', icon: Icons.coffee_outlined),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              _BreakRow(day: 'Lunch Break', time: '01:00 PM – 01:30 PM', icon: Icons.lunch_dining_outlined),
              const SizedBox(height: 10),
              _BreakRow(day: 'Short Break', time: '04:00 PM – 04:15 PM', icon: Icons.local_cafe_outlined),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final ScheduleEntry entry;

  const _ScheduleRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Day chip
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: entry.isOff ? AppColors.divider : AppColors.goldFaint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                entry.day,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color:
                      entry.isOff ? AppColors.textMuted : AppColors.gold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Time range or Off
          Expanded(
            child: entry.isOff
                ? Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Day Off',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.schedule_outlined,
                              size: 13, color: AppColors.textMuted),
                          const SizedBox(width: 5),
                          Text(
                            '${entry.startTime}  –  ${entry.endTime}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '9 hours shift',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
          ),

          // Active indicator
          if (!entry.isOff)
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.green,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

class _BreakRow extends StatelessWidget {
  final String day;
  final String time;
  final IconData icon;

  const _BreakRow(
      {required this.day, required this.time, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.orangeFaint,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: AppColors.orange),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Tab 2: Service Specialties ───────────────────────────────────────────────

class _SpecialtiesTab extends StatelessWidget {
  final List<Map<String, dynamic>> specialties;

  const _SpecialtiesTab({required this.specialties});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      children: [
        _SectionLabel(
            label: 'SERVICE SPECIALTIES',
            icon: Icons.auto_awesome_outlined),
        const SizedBox(height: 14),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.55,
          ),
          itemCount: specialties.length,
          itemBuilder: (context, index) {
            final sp = specialties[index];
            final Color color = sp['color'] as Color;
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(sp['icon'] as IconData,
                        size: 18, color: color),
                  ),
                  Text(
                    sp['name'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 24),
        _SectionLabel(
            label: 'PERFORMANCE METRICS',
            icon: Icons.bar_chart_outlined),
        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              _PerformanceBar(
                label: 'Client Satisfaction',
                value: 0.96,
                color: AppColors.green,
                display: '96%',
              ),
              const SizedBox(height: 14),
              _PerformanceBar(
                label: 'On-Time Rate',
                value: 0.89,
                color: AppColors.gold,
                display: '89%',
              ),
              const SizedBox(height: 14),
              _PerformanceBar(
                label: 'Rebooking Rate',
                value: 0.72,
                color: AppColors.purple,
                display: '72%',
              ),
              const SizedBox(height: 14),
              _PerformanceBar(
                label: 'Revenue Contribution',
                value: 0.84,
                color: AppColors.orange,
                display: '84%',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PerformanceBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final String display;

  const _PerformanceBar({
    required this.label,
    required this.value,
    required this.color,
    required this.display,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              display,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// ─── Tab 3: Booking History ───────────────────────────────────────────────────

class _BookingsTab extends StatelessWidget {
  final List<BookingRecord> bookings;

  const _BookingsTab({required this.bookings});

  // Helper to group by date
  Map<String, List<BookingRecord>> _groupByDate() {
    final Map<String, List<BookingRecord>> grouped = {};
    for (final b in bookings) {
      grouped.putIfAbsent(b.date, () => []).add(b);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDate();
    final dates = grouped.keys.toList();

    // Summary stats
    final completed =
        bookings.where((b) => b.status == 'completed').length;
    final upcoming = bookings.where((b) => b.status == 'upcoming').length;
    final cancelled =
        bookings.where((b) => b.status == 'cancelled').length;
    final totalRevenue =
        bookings.where((b) => b.status == 'completed').fold<double>(
              0,
              (sum, b) => sum + b.amount,
            );

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      children: [
        // Summary chips
        Row(
          children: [
            _BookingSummaryChip(
                label: 'Done',
                count: completed,
                color: AppColors.green,
                bg: AppColors.greenFaint),
            const SizedBox(width: 8),
            _BookingSummaryChip(
                label: 'Upcoming',
                count: upcoming,
                color: AppColors.gold,
                bg: AppColors.goldFaint),
            const SizedBox(width: 8),
            _BookingSummaryChip(
                label: 'Cancelled',
                count: cancelled,
                color: AppColors.red,
                bg: AppColors.pinkFaint),
          ],
        ),

        const SizedBox(height: 12),

        // Revenue chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.purpleFaint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.currency_rupee,
                    size: 18, color: AppColors.purple),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL REVENUE (SHOWN)',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  Text(
                    '₹ ${totalRevenue.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        _SectionLabel(
            label: 'BOOKING HISTORY', icon: Icons.receipt_long_outlined),
        const SizedBox(height: 14),

        // Grouped list
        ...dates.map((date) {
          final list = grouped[date]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 4),
                child: Text(
                  date.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: List.generate(list.length, (i) {
                    final isLast = i == list.length - 1;
                    return Column(
                      children: [
                        _BookingRow(booking: list[i]),
                        if (!isLast)
                          const Divider(
                              height: 1,
                              color: AppColors.divider,
                              indent: 16,
                              endIndent: 16),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }),
      ],
    );
  }
}

class _BookingSummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color bg;

  const _BookingSummaryChip({
    required this.label,
    required this.count,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
                fontFamily: 'Georgia',
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingRow extends StatelessWidget {
  final BookingRecord booking;

  const _BookingRow({required this.booking});

  Color get _statusColor {
    switch (booking.status) {
      case 'completed':
        return AppColors.green;
      case 'upcoming':
        return AppColors.gold;
      case 'cancelled':
        return AppColors.red;
      default:
        return AppColors.textMuted;
    }
  }

  Color get _statusBg {
    switch (booking.status) {
      case 'completed':
        return AppColors.greenFaint;
      case 'upcoming':
        return AppColors.goldFaint;
      case 'cancelled':
        return AppColors.pinkFaint;
      default:
        return AppColors.divider;
    }
  }

  IconData get _statusIcon {
    switch (booking.status) {
      case 'completed':
        return Icons.check_circle_outline;
      case 'upcoming':
        return Icons.schedule_outlined;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Client avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.goldFaint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                booking.clientInitial,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.clientName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${booking.service}  ·  ${booking.time}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Amount + status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹ ${booking.amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_statusIcon, size: 10, color: _statusColor),
                    const SizedBox(width: 3),
                    Text(
                      booking.status[0].toUpperCase() +
                          booking.status.substring(1),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: _statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Shared Section Label ─────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.gold),
        const SizedBox(width: 7),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.w800,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
