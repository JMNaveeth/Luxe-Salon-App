import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(const DashboardApp());

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Georgia',
      ),
      home: const DashboardPage(),
    );
  }
}

// ─── Palette ──────────────────────────────────────────────────────────────────
class AppColors {
  static const bg = Color(0xFF111109);
  static const surface = Color(0xFF1A1A0E);
  static const card = Color(0xFF1C1C10);
  static const cardBorder = Color(0xFF272714);
  static const gold = Color(0xFFD4A843);
  static const goldDim = Color(0xFF6B5218);
  static const goldFaint = Color(0xFF22200A);
  static const chartBar = Color(0xFF3A3010);
  static const chartBarActive = Color(0xFFD4A843);
  static const textPrimary = Color(0xFFF5EDD6);
  static const textSecondary = Color(0xFF8A7A55);
  static const textMuted = Color(0xFF504530);
  static const divider = Color(0xFF1E1E0E);
  static const green = Color(0xFF6BBF6F);
  static const greenFaint = Color(0xFF0E1A0E);
  static const orange = Color(0xFFD4874A);
  static const red = Color(0xFFD46B6B);
}

// ─── Bar Chart Data ───────────────────────────────────────────────────────────
class BarData {
  final String label;
  final double value;
  final bool isActive;
  const BarData(this.label, this.value, {this.isActive = false});
}

// ─── Staff Model ──────────────────────────────────────────────────────────────
class StaffMember {
  final String name;
  final String role;
  final String imageUrl;
  final int productivity;
  final String badge;
  const StaffMember({
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.productivity,
    required this.badge,
  });
}

// ─── Appointment Model ────────────────────────────────────────────────────────
class Appointment {
  final String time;
  final String name;
  final String service;
  final bool isNew;
  const Appointment({
    required this.time,
    required this.name,
    required this.service,
    this.isNew = false,
  });
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedNav = 0; // Dashboard active

  final List<BarData> _chartData = const [
    BarData('MON', 0.45),
    BarData('TUE', 0.62),
    BarData('WED', 0.55),
    BarData('THU', 0.80),
    BarData('FRI', 0.95),
    BarData('SAT', 1.0, isActive: true),
    BarData('SUN', 0.38),
  ];

  final List<StaffMember> _staff = const [
    StaffMember(
      name: 'Julianne',
      role: 'Senior Stylist',
      imageUrl: 'https://i.pravatar.cc/100?img=47',
      productivity: 94,
      badge: 'TOP',
    ),
    StaffMember(
      name: 'Adelaide',
      role: 'Hair Colourist',
      imageUrl: 'https://i.pravatar.cc/100?img=25',
      productivity: 82,
      badge: '',
    ),
  ];

  final List<Appointment> _agenda = const [
    Appointment(
      time: '10:00',
      name: 'Julian Rivera',
      service: 'Royal Signature Haircut',
    ),
    Appointment(
      time: '11:30',
      name: 'Aria Montgomery',
      service: 'Gold Facial Spa',
      isNew: true,
    ),
    Appointment(
      time: '13:00',
      name: 'Marcus Wells',
      service: 'Elite Hair Sculpting',
    ),
  ];

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
                      _buildBusinessOverview(),
                      const SizedBox(height: 20),
                      _buildWeeklyGrowthChart(),
                      const SizedBox(height: 28),
                      _buildStaffPerformanceSection(),
                      const SizedBox(height: 20),
                      _buildQuickStatsRow(),
                      const SizedBox(height: 28),
                      _buildTodayAgendaSection(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _buildBottomNav(),
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
      titleSpacing: 16,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold.withOpacity(0.5), width: 1.5),
          ),
          child: ClipOval(
            child: Image.network(
              'https://i.pravatar.cc/100?img=47',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                  Icons.business, color: AppColors.gold, size: 22),
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ELITE PARTNER',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const Text(
            'The Gilded Touch',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 6),
          child: IconButton(
            icon: const Icon(Icons.insights_outlined,
                color: AppColors.textSecondary, size: 22),
            onPressed: () {},
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 14),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textSecondary, size: 22),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  // ── Business Overview ─────────────────────────────────────────────────────────
  Widget _buildBusinessOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Business Overview',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.gold.withOpacity(0.3), width: 1),
              ),
              child: const Text(
                'TODAY',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                label: 'TOTAL REVENUE',
                value: '\$4,280',
                badge: '+12.5%',
                badgePositive: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                label: 'BOOKINGS',
                value: '24',
                badge: '5 Pending',
                badgePositive: null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required String badge,
    bool? badgePositive,
  }) {
    Color badgeColor;
    Color badgeBg;
    if (badgePositive == true) {
      badgeColor = AppColors.green;
      badgeBg = AppColors.greenFaint;
    } else if (badgePositive == false) {
      badgeColor = AppColors.red;
      badgeBg = Colors.red.withOpacity(0.08);
    } else {
      badgeColor = AppColors.orange;
      badgeBg = AppColors.orange.withOpacity(0.1);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: badgeColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Weekly Growth Chart ───────────────────────────────────────────────────────
  Widget _buildWeeklyGrowthChart() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Weekly Growth',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'REVENUE · APPOINTMENTS',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 8,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Peak label
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '\$1.2k',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 8),
          // Bar chart
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _chartData.map((bar) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          height: 80 * bar.value,
                          decoration: BoxDecoration(
                            color: bar.isActive
                                ? AppColors.chartBarActive
                                : AppColors.chartBar,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          // Day labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _chartData.map((bar) {
              return Expanded(
                child: Text(
                  bar.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: bar.isActive
                        ? AppColors.gold
                        : AppColors.textMuted,
                    fontSize: 9,
                    fontWeight: bar.isActive
                        ? FontWeight.w800
                        : FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Staff Performance ─────────────────────────────────────────────────────────
  Widget _buildStaffPerformanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Staff Performance',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              'VIEW ALL',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: _staff.asMap().entries.map((e) {
            final s = e.value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: e.key < _staff.length - 1 ? 12 : 0),
                child: _buildStaffCard(s),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStaffCard(StaffMember s) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  s.imageUrl,
                  width: double.infinity,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.person, color: AppColors.gold, size: 36),
                    ),
                  ),
                ),
              ),
              if (s.badge.isNotEmpty)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      s.badge,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            s.name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            s.role.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 8,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          // Productivity bar
          Row(
            children: [
              const Text(
                'PRODUCTIVITY',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 7,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${s.productivity}%',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: s.productivity / 100,
              backgroundColor: AppColors.cardBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Stats Row ───────────────────────────────────────────────────────────
  Widget _buildQuickStatsRow() {
    final stats = [
      {'icon': Icons.calendar_today_outlined, 'label': 'BOOKINGS', 'value': '24'},
      {'icon': Icons.attach_money_outlined, 'label': 'PRICING', 'value': '\$1.2k'},
      {'icon': Icons.show_chart_outlined, 'label': 'AVERAGE', 'value': '\$145'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: stats.asMap().entries.map((e) {
          final i = e.key;
          final s = e.value;
          return Expanded(
            child: Row(
              children: [
                if (i != 0)
                  Container(
                    width: 1,
                    height: 36,
                    color: AppColors.cardBorder,
                  ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(s['icon'] as IconData,
                          color: AppColors.gold, size: 20),
                      const SizedBox(height: 6),
                      Text(
                        s['value'] as String,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        s['label'] as String,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 8,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Today's Agenda ────────────────────────────────────────────────────────────
  Widget _buildTodayAgendaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              "Today's Agenda",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              'View All',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder, width: 1),
          ),
          child: Column(
            children: _agenda.asMap().entries.map((e) {
              final i = e.key;
              final appt = e.value;
              return Column(
                children: [
                  if (i != 0)
                    Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                  _buildAgendaRow(appt),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAgendaRow(Appointment appt) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Time
          SizedBox(
            width: 40,
            child: Text(
              appt.time,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Avatar dot
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.goldFaint,
              border: Border.all(
                  color: AppColors.gold.withOpacity(0.3), width: 1.5),
            ),
            child: const Icon(Icons.person_outline,
                color: AppColors.gold, size: 18),
          ),
          const SizedBox(width: 12),
          // Name + service
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appt.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  appt.service,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Badge or arrow
          if (appt.isNew)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            )
          else
            const Icon(Icons.chevron_right,
                color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }

  // ── Bottom Navigation ─────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.grid_view_outlined, 'label': 'Dashboard'},
      {'icon': Icons.calendar_month_outlined, 'label': 'Schedule'},
      {'icon': Icons.group_outlined, 'label': 'Clients'},
      {'icon': Icons.insert_chart_outlined, 'label': 'Reports'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
            top: BorderSide(
                color: AppColors.gold.withOpacity(0.2), width: 1)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final selected = i == _selectedNav;
          return GestureDetector(
            onTap: () => setState(() => _selectedNav = i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Icon(
                  items[i]['icon'] as IconData,
                  color: selected ? AppColors.gold : AppColors.textSecondary,
                  size: 22,
                ),
                const SizedBox(height: 3),
                Text(
                  items[i]['label'] as String,
                  style: TextStyle(
                    color: selected ? AppColors.gold : AppColors.textSecondary,
                    fontSize: 9,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                if (selected)
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}