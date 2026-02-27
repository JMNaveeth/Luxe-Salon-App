import 'package:flutter/material.dart';

void main() {
  runApp(const SalonApp());
}

class SalonApp extends StatelessWidget {
  const SalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staff Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF0A0A0A)),
      home: const StaffManagementScreen(),
    );
  }
}

// --- Data Model ---
class StaffMember {
  final String name;
  final String role;
  final double rating;
  final String statusText;
  final bool isOnDuty;
  final Color avatarColor;

  const StaffMember({
    required this.name,
    required this.role,
    required this.rating,
    required this.statusText,
    required this.isOnDuty,
    required this.avatarColor,
  });
}

// --- Main Screen ---
class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  int _selectedNavIndex = 1;

  final List<StaffMember> _staff = const [
    StaffMember(
      name: 'Julian Harrison',
      role: 'Master Barber',
      rating: 4.9,
      statusText: '14 Bookings today',
      isOnDuty: true,
      avatarColor: Color(0xFFD4856A),
    ),
    StaffMember(
      name: 'Elena Rodriguez',
      role: 'Senior Colorist',
      rating: 5.0,
      statusText: '8 Bookings today',
      isOnDuty: true,
      avatarColor: Color(0xFFC47A5A),
    ),
    StaffMember(
      name: 'Marcus Thorne',
      role: 'Stylist Specialist',
      rating: 4.7,
      statusText: 'DAY OFF',
      isOnDuty: false,
      avatarColor: Color(0xFF8A9BAA),
    ),
    StaffMember(
      name: 'Sophia Chen',
      role: 'Aesthetician',
      rating: 4.8,
      statusText: '6 Bookings today',
      isOnDuty: true,
      avatarColor: Color(0xFFD4A07A),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final onDutyCount = _staff.where((s) => s.isOnDuty).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Header
                    _Header(),

                    const SizedBox(height: 20),

                    // Add New Staff Button
                    _AddStaffButton(),

                    const SizedBox(height: 20),

                    // Stats Row
                    _StatsRow(
                      totalStaff: _staff.length,
                      onDuty: onDutyCount,
                    ),

                    const SizedBox(height: 20),

                    // Staff Cards
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _staff.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _StaffCard(member: _staff[index]),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Nav
            _BottomNavBar(
              selectedIndex: _selectedNavIndex,
              onTap: (i) => setState(() => _selectedNavIndex = i),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Header ---
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Staff Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE8E8E8),
                  fontFamily: 'Georgia',
                ),
              ),
              SizedBox(height: 3),
              Text(
                'SALON ROSTER & ROSTERS',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 2,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: const Icon(
            Icons.settings_outlined,
            color: Color(0xFFD4A843),
            size: 18,
          ),
        ),
      ],
    );
  }
}

// --- Add Staff Button ---
class _AddStaffButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD4A843), Color(0xFFB8861F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4A843).withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_outlined,
                color: Color(0xFF0A0A0A), size: 18),
            SizedBox(width: 8),
            Text(
              'ADD NEW STAFF',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
                color: Color(0xFF0A0A0A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Stats Row ---
class _StatsRow extends StatelessWidget {
  final int totalStaff;
  final int onDuty;

  const _StatsRow({required this.totalStaff, required this.onDuty});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            label: 'TOTAL STAFF',
            value: totalStaff.toString(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            label: 'ON DUTY',
            value: onDuty.toString(),
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              letterSpacing: 1.5,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE8E8E8),
              fontFamily: 'Georgia',
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Staff Card ---
class _StaffCard extends StatelessWidget {
  final StaffMember member;

  const _StaffCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        children: [
          // Top section: avatar + info + menu
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: member.avatarColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: member.avatarColor.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      member.name.substring(0, 1),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: member.avatarColor,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name + role + rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE8E8E8),
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        member.role,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF888888),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Status dot
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: member.isOnDuty
                                  ? const Color(0xFF4CAF50)
                                  : const Color(0xFF555555),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),

                          // Rating
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFD4A843), size: 12),
                          const SizedBox(width: 3),
                          Text(
                            member.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFD4A843),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Divider
                          Container(
                            width: 1,
                            height: 10,
                            color: const Color(0xFF333333),
                          ),
                          const SizedBox(width: 8),

                          // Booking / status text
                          Icon(
                            member.isOnDuty
                                ? Icons.calendar_today_outlined
                                : Icons.wb_sunny_outlined,
                            size: 11,
                            color: member.isOnDuty
                                ? const Color(0xFF888888)
                                : const Color(0xFFD4A843),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            member.statusText,
                            style: TextStyle(
                              fontSize: 11,
                              color: member.isOnDuty
                                  ? const Color(0xFF888888)
                                  : const Color(0xFFD4A843),
                              fontWeight: member.isOnDuty
                                  ? FontWeight.w400
                                  : FontWeight.w700,
                              letterSpacing:
                                  member.isOnDuty ? 0 : 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3-dot menu
                GestureDetector(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.more_horiz,
                        color: Color(0xFF555555), size: 20),
                  ),
                ),
              ],
            ),
          ),

          // Manage Schedule Button
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: const Center(
                child: Text(
                  'MANAGE SCHEDULE',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFD4A843),
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

// --- Bottom Nav Bar ---
class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = [
    {'icon': Icons.grid_view_outlined, 'label': 'OVERVIEW'},
    {'icon': Icons.people_outline, 'label': 'STAFF'},
    {'icon': Icons.calendar_month_outlined, 'label': 'CALENDAR'},
    {'icon': Icons.business_outlined, 'label': 'BUSINESS'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        border: Border(top: BorderSide(color: Color(0xFF1E1E1E))),
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _items[i]['icon'] as IconData,
                    size: 20,
                    color: selected
                        ? const Color(0xFFD4A843)
                        : const Color(0xFF444444),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _items[i]['label'] as String,
                    style: TextStyle(
                      fontSize: 8,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? const Color(0xFFD4A843)
                          : const Color(0xFF444444),
                    ),
                  ),
                  if (selected) ...[
                    const SizedBox(height: 3),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4A843),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}