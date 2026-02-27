import 'package:flutter/material.dart';

void main() {
  runApp(const SalonApp());
}

class SalonApp extends StatelessWidget {
  const SalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity History',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF0F0E0A)),
      home: const ActivityHistoryScreen(),
    );
  }
}

// --- Data Models ---
enum ActivityCategory { bookings, services, finance, staff, stock }

class ActivityItem {
  final String title;
  final String description;
  final String date;
  final ActivityCategory category;
  final IconData icon;

  const ActivityItem({
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.icon,
  });
}

// --- Main Screen ---
class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  State<ActivityHistoryScreen> createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
  int _selectedTab = 0; // 0=All, 1=Bookings, 2=Finance
  int _selectedDay = 5;
  int _selectedNavIndex = 1;

  final List<String> _tabs = ['All Logs', 'Bookings', 'Finance'];

  final List<ActivityItem> _activities = const [
    ActivityItem(
      title: 'New Booking Received',
      description: 'Luxury Spa Mani-Pedi for Sarah J.',
      date: 'Oct 24, 10:30 AM',
      category: ActivityCategory.bookings,
      icon: Icons.calendar_today_outlined,
    ),
    ActivityItem(
      title: 'Service Price Updated',
      description: '"Bridal Package" adjusted to \$240.00',
      date: 'Oct 23, 02:15 PM',
      category: ActivityCategory.services,
      icon: Icons.do_not_disturb_on_outlined,
    ),
    ActivityItem(
      title: 'Payout Processed',
      description: 'Weekly earnings of \$4,020.00 sent to bank.',
      date: 'Oct 22, 09:00 AM',
      category: ActivityCategory.finance,
      icon: Icons.account_balance_wallet_outlined,
    ),
    ActivityItem(
      title: 'Staff Member Added',
      description: 'Elena Rodriguez joined as Senior Stylist.',
      date: 'Oct 21, 11:45 AM',
      category: ActivityCategory.staff,
      icon: Icons.person_add_outlined,
    ),
    ActivityItem(
      title: 'Inventory Warning',
      description: 'Low Stock: Gold Leaf Hair Serum (3 left)',
      date: 'Oct 20, 04:30 PM',
      category: ActivityCategory.stock,
      icon: Icons.warning_amber_outlined,
    ),
  ];

  List<ActivityItem> get _filtered {
    if (_selectedTab == 0) return _activities;
    if (_selectedTab == 1) {
      return _activities
          .where((a) => a.category == ActivityCategory.bookings)
          .toList();
    }
    return _activities
        .where((a) => a.category == ActivityCategory.finance)
        .toList();
  }

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
                    const SizedBox(height: 16),
                    _TabBar(
                      tabs: _tabs,
                      selectedIndex: _selectedTab,
                      onTap: (i) => setState(() => _selectedTab = i),
                    ),
                    const SizedBox(height: 16),
                    _CalendarStrip(
                      selectedDay: _selectedDay,
                      onDaySelected: (d) => setState(() => _selectedDay = d),
                    ),
                    const SizedBox(height: 24),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) =>
                          _ActivityCard(item: _filtered[i]),
                    ),
                    const SizedBox(height: 24),
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
              color: const Color(0xFF1A1910),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2E2D1A)),
            ),
            child: const Icon(Icons.chevron_left,
                color: Color(0xFFD4A843), size: 20),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Activity History',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE8E8E8),
                fontFamily: 'Georgia',
              ),
            ),
          ),
        ),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1910),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF2E2D1A)),
          ),
          child: const Icon(Icons.tune,
              color: Color(0xFF888877), size: 17),
        ),
      ],
    );
  }
}

// --- Tab Bar ---
class _TabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _TabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFD4A843)
                    : const Color(0xFF1A1910),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFD4A843)
                      : const Color(0xFF2E2D1A),
                ),
              ),
              child: Row(
                children: [
                  if (i == 1)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: selected
                            ? const Color(0xFF0A0A0A)
                            : const Color(0xFF888877),
                      ),
                    ),
                  if (i == 2)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 12,
                        color: selected
                            ? const Color(0xFF0A0A0A)
                            : const Color(0xFF888877),
                      ),
                    ),
                  Text(
                    tabs[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? const Color(0xFF0A0A0A)
                          : const Color(0xFF888877),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// --- Calendar Strip ---
class _CalendarStrip extends StatelessWidget {
  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  const _CalendarStrip({
    required this.selectedDay,
    required this.onDaySelected,
  });

  static const _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    // October 2023 starts on Sunday (weekday index 0)
    // Show days 1–11 to match design
    const int startDay = 1;
    const int endDay = 11;
    const int firstWeekday = 0; // Sunday

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1910),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2E2D1A)),
      ),
      child: Column(
        children: [
          // Month header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.chevron_left, color: Color(0xFFD4A843), size: 20),
              Text(
                'October 2023',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE8E8E8),
                ),
              ),
              Icon(Icons.chevron_right, color: Color(0xFFD4A843), size: 20),
            ],
          ),
          const SizedBox(height: 12),

          // Weekday labels
          Row(
            children: _weekdays.map((d) {
              return Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF555544),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Days row — show a partial first week + row 2
          _buildGrid(startDay, endDay, firstWeekday),
        ],
      ),
    );
  }

  Widget _buildGrid(int startDay, int endDay, int firstWeekday) {
    final List<Widget> cells = [];

    // Leading empty cells
    for (int i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox());
    }

    for (int day = startDay; day <= endDay; day++) {
      final isSelected = day == selectedDay;
      cells.add(
        GestureDetector(
          onTap: () => onDaySelected(day),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? const Color(0xFFD4A843)
                  : Colors.transparent,
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
      childAspectRatio: 1,
      children: cells,
    );
  }
}

// --- Category helpers ---
extension _CatExt on ActivityCategory {
  String get label {
    switch (this) {
      case ActivityCategory.bookings:
        return 'BOOKINGS';
      case ActivityCategory.services:
        return 'SERVICES';
      case ActivityCategory.finance:
        return 'FINANCE';
      case ActivityCategory.staff:
        return 'STAFF';
      case ActivityCategory.stock:
        return 'STOCK';
    }
  }

  Color get color {
    switch (this) {
      case ActivityCategory.bookings:
        return const Color(0xFF4A9B6F);
      case ActivityCategory.services:
        return const Color(0xFF9B6B4A);
      case ActivityCategory.finance:
        return const Color(0xFF4A7B9B);
      case ActivityCategory.staff:
        return const Color(0xFF7B4A9B);
      case ActivityCategory.stock:
        return const Color(0xFF9B4A4A);
    }
  }

  Color get bgColor {
    switch (this) {
      case ActivityCategory.bookings:
        return const Color(0xFF1A2E24);
      case ActivityCategory.services:
        return const Color(0xFF2E221A);
      case ActivityCategory.finance:
        return const Color(0xFF1A2430);
      case ActivityCategory.staff:
        return const Color(0xFF241A30);
      case ActivityCategory.stock:
        return const Color(0xFF2E1A1A);
    }
  }

  Color get iconBg {
    switch (this) {
      case ActivityCategory.bookings:
        return const Color(0xFF1E3828);
      case ActivityCategory.services:
        return const Color(0xFF38281E);
      case ActivityCategory.finance:
        return const Color(0xFF1E2E3C);
      case ActivityCategory.staff:
        return const Color(0xFF281E3C);
      case ActivityCategory.stock:
        return const Color(0xFF3C1E1E);
    }
  }
}

// --- Activity Card ---
class _ActivityCard extends StatelessWidget {
  final ActivityItem item;

  const _ActivityCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cat = item.category;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1910),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2E2D1A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cat.iconBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cat.color.withOpacity(0.3)),
            ),
            child: Icon(item.icon, color: cat.color, size: 20),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE8E8E8),
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: cat.bgColor,
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(color: cat.color.withOpacity(0.4)),
                      ),
                      child: Text(
                        cat.label,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: cat.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF888877),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time_outlined,
                        size: 11, color: Color(0xFF555544)),
                    const SizedBox(width: 4),
                    Text(
                      item.date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF555544),
                      ),
                    ),
                  ],
                ),
              ],
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
    {'icon': Icons.grid_view_outlined, 'label': 'Dashboard'},
    {'icon': Icons.history_outlined, 'label': 'Activity'},
    {'icon': Icons.calendar_today_outlined, 'label': 'Bookings'},
    {'icon': Icons.person_outline, 'label': 'Profile'},
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
                      fontSize: 9,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
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