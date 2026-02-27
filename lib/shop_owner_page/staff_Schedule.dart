import 'package:flutter/material.dart';

void main() {
  runApp(const SalonApp());
}

class SalonApp extends StatelessWidget {
  const SalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staff Schedule',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF0F0E0A)),
      home: const StaffScheduleScreen(),
    );
  }
}

// --- Data Model ---
class TimeSlot {
  final String time;
  final String label;
  final bool isBreak;
  bool isEnabled;

  TimeSlot({
    required this.time,
    required this.label,
    this.isBreak = false,
    this.isEnabled = true,
  });
}

// --- Main Screen ---
class StaffScheduleScreen extends StatefulWidget {
  const StaffScheduleScreen({super.key});

  @override
  State<StaffScheduleScreen> createState() => _StaffScheduleScreenState();
}

class _StaffScheduleScreenState extends State<StaffScheduleScreen> {
  int _selectedDay = 5; // October 5
  int _selectedNavIndex = 0;

  final List<TimeSlot> _slots = [
    TimeSlot(time: '09:00 AM', label: 'Morning Shift'),
    TimeSlot(time: '10:00 AM', label: 'Morning Shift'),
    TimeSlot(time: '11:00 AM', label: 'Break Time', isBreak: true, isEnabled: false),
    TimeSlot(time: '12:00 PM', label: 'Lunch Back'),
    TimeSlot(time: '01:00 PM', label: 'Afternoon Shift'),
  ];

  // Calendar
  final int _year = 2023;
  final int _month = 10; // October

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E0A),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _AppBar(),
                    const SizedBox(height: 20),
                    _StaffCard(),
                    const SizedBox(height: 16),
                    _CalendarCard(
                      year: _year,
                      month: _month,
                      selectedDay: _selectedDay,
                      onDaySelected: (d) => setState(() => _selectedDay = d),
                    ),
                    const SizedBox(height: 24),
                    _DailySlotsHeader(
                      onBulkApply: () {},
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _slots.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _TimeSlotCard(
                        slot: _slots[i],
                        onToggle: (val) =>
                            setState(() => _slots[i].isEnabled = val),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            _BottomNavBar(
              selectedIndex: _selectedNavIndex,
              onTap: (i) => setState(() => _selectedNavIndex = i),
            ),
          ],
        ),
      ),
      floatingActionButton: _GoldFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// --- App Bar ---
class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2A2A1A)),
            ),
            child: const Icon(Icons.chevron_left,
                color: Color(0xFFD4A843), size: 20),
          ),
        ),
        const Expanded(
          child: Column(
            children: [
              Text(
                'Staff Schedule',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE8E8E8),
                  fontFamily: 'Georgia',
                ),
              ),
              Text(
                'Manage Availability',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF777766),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF2A2A1A)),
          ),
          child: const Icon(Icons.more_vert,
              color: Color(0xFF888877), size: 18),
        ),
      ],
    );
  }
}

// --- Staff Card ---
class _StaffCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1910),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2E2D1A)),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF8A9BAA).withOpacity(0.3),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                  color: const Color(0xFF8A9BAA).withOpacity(0.5), width: 1.5),
            ),
            child: const Center(
              child: Text(
                'M',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8A9BAA),
                  fontFamily: 'Georgia',
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marcus Thorne',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE8E8E8),
                    fontFamily: 'Georgia',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Master Stylist • Level 4',
                  style: TextStyle(fontSize: 12, color: Color(0xFF888877)),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                const Text(
                  'Change',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD4A843),
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: Color(0xFFD4A843), size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Calendar ---
class _CalendarCard extends StatelessWidget {
  final int year;
  final int month;
  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  const _CalendarCard({
    required this.year,
    required this.month,
    required this.selectedDay,
    required this.onDaySelected,
  });

  static const _weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  static const _monthNames = [
    '', 'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    // October 2023 starts on Sunday
    final firstWeekday = DateTime(year, month, 1).weekday % 7;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1910),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2E2D1A)),
      ),
      child: Column(
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.chevron_left,
                  color: Color(0xFFD4A843), size: 20),
              Text(
                '${_monthNames[month]} $year',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE8E8E8),
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: Color(0xFFD4A843), size: 20),
            ],
          ),
          const SizedBox(height: 14),

          // Weekday labels
          Row(
            children: _weekdays.map((d) {
              return Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: const TextStyle(
                      fontSize: 9,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF555544),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // Day grid
          _buildDayGrid(firstWeekday, daysInMonth),
        ],
      ),
    );
  }

  Widget _buildDayGrid(int firstWeekday, int daysInMonth) {
    final cells = <Widget>[];

    // Empty cells before month start
    for (int i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final isSelected = day == selectedDay;
      final isToday = day == 10; // highlight 10th as example "today"
      cells.add(
        GestureDetector(
          onTap: () => onDaySelected(day),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? const Color(0xFFD4A843)
                  : Colors.transparent,
              border: isToday && !isSelected
                  ? Border.all(color: const Color(0xFFD4A843), width: 1.5)
                  : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      isSelected ? FontWeight.w800 : FontWeight.w400,
                  color: isSelected
                      ? const Color(0xFF0A0A0A)
                      : isToday
                          ? const Color(0xFFD4A843)
                          : const Color(0xFFCCCCBB),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 4,
      crossAxisSpacing: 0,
      childAspectRatio: 1,
      children: cells,
    );
  }
}

// --- Daily Slots Header ---
class _DailySlotsHeader extends StatelessWidget {
  final VoidCallback onBulkApply;

  const _DailySlotsHeader({required this.onBulkApply});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Daily Time Slots',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE8E8E8),
            fontFamily: 'Georgia',
          ),
        ),
        GestureDetector(
          onTap: onBulkApply,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4A843), Color(0xFFB8861F)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4A843).withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.flash_on_rounded,
                    color: Color(0xFF0A0A0A), size: 13),
                SizedBox(width: 4),
                Text(
                  'Bulk Apply',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0A0A0A),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// --- Time Slot Card ---
class _TimeSlotCard extends StatelessWidget {
  final TimeSlot slot;
  final ValueChanged<bool> onToggle;

  const _TimeSlotCard({required this.slot, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1910),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: slot.isBreak
              ? const Color(0xFF222215)
              : const Color(0xFF2E2D1A),
        ),
      ),
      child: Row(
        children: [
          // Clock icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: slot.isBreak
                  ? const Color(0xFF1E1E14)
                  : const Color(0xFF252410),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              slot.isBreak
                  ? Icons.do_not_disturb_on_outlined
                  : Icons.schedule_outlined,
              color: slot.isBreak
                  ? const Color(0xFF444433)
                  : const Color(0xFFD4A843),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),

          // Time + label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.time,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: slot.isBreak
                        ? const Color(0xFF555544)
                        : const Color(0xFFE8E8E8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  slot.label,
                  style: TextStyle(
                    fontSize: 11,
                    color: slot.isBreak
                        ? const Color(0xFF444433)
                        : const Color(0xFF888877),
                  ),
                ),
              ],
            ),
          ),

          // Toggle
          _GoldToggle(
            value: slot.isEnabled,
            isBreak: slot.isBreak,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}

// --- Custom Gold Toggle ---
class _GoldToggle extends StatelessWidget {
  final bool value;
  final bool isBreak;
  final ValueChanged<bool> onChanged;

  const _GoldToggle({
    required this.value,
    required this.onChanged,
    this.isBreak = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 42,
        height: 24,
        decoration: BoxDecoration(
          color: value
              ? (isBreak ? const Color(0xFF3A3A28) : const Color(0xFFD4A843))
              : const Color(0xFF252520),
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: value
                  ? (isBreak
                      ? const Color(0xFF666655)
                      : const Color(0xFF0A0A0A))
                  : const Color(0xFF444440),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

// --- FAB ---
class _GoldFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4A843), Color(0xFFB8861F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4A843).withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.add, color: Color(0xFF0A0A0A), size: 26),
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
    {'icon': Icons.calendar_today_outlined, 'label': 'SCHEDULE'},
    {'icon': Icons.people_outline, 'label': 'STAFF'},
    {'icon': Icons.people_outline, 'label': 'CLIENTS'},
    {'icon': Icons.storefront_outlined, 'label': 'SHOP'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFF111109),
        border: Border(top: BorderSide(color: Color(0xFF222215))),
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
                        : const Color(0xFF444433),
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
                          : const Color(0xFF444433),
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