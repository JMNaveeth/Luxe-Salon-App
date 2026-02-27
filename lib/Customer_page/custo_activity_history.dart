import 'package:flutter/material.dart';

void main() => runApp(const ActivityApp());

class ActivityApp extends StatelessWidget {
  const ActivityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Center',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Georgia',
      ),
      home: const ActivityCenterPage(),
    );
  }
}

// ─── Palette ──────────────────────────────────────────────────────────────────
class AppColors {
  static const bg = Color(0xFF131309);
  static const surface = Color(0xFF1C1C10);
  static const card = Color(0xFF1E1E12);
  static const cardBorder = Color(0xFF2A2A18);
  static const gold = Color(0xFFD4A843);
  static const goldFaint = Color(0xFF26200A);
  static const textPrimary = Color(0xFFF5EDD6);
  static const textSecondary = Color(0xFF8A7A55);
  static const textMuted = Color(0xFF504530);
  static const divider = Color(0xFF1E1E10);
  static const green = Color(0xFF5BAD6F);
  static const greenFaint = Color(0xFF0E1E0E);
  static const blue = Color(0xFF5B8EAD);
  static const blueFaint = Color(0xFF0A1520);
  static const purple = Color(0xFF9B7FD4);
  static const purpleFaint = Color(0xFF16101E);
  static const orange = Color(0xFFD4874A);
  static const orangeFaint = Color(0xFF201408);
}

// ─── Activity Item Model ──────────────────────────────────────────────────────
class ActivityEntry {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String description;
  final String time;
  final String? badge; // e.g. 'JUST NOW'
  final String filter; // 'all', 'bookings', 'payments', 'loyalty'

  const ActivityEntry({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.description,
    required this.time,
    this.badge,
    required this.filter,
  });
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class ActivityCenterPage extends StatefulWidget {
  const ActivityCenterPage({super.key});

  @override
  State<ActivityCenterPage> createState() => _ActivityCenterPageState();
}

class _ActivityCenterPageState extends State<ActivityCenterPage>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  int _selectedNav = 3; // Activity active

  final List<String> _tabs = ['All', 'Bookings', 'Payments', 'Loyalty'];

  final List<ActivityEntry> _todayEntries = const [
    ActivityEntry(
      icon: Icons.calendar_today_outlined,
      iconColor: AppColors.gold,
      iconBg: AppColors.goldFaint,
      title: 'Booking Confirmed',
      description:
          'Your appointment with Master Stylist Julian is confirmed for 4:30 PM today.',
      time: 'JUST NOW',
      badge: 'JUST NOW',
      filter: 'bookings',
    ),
    ActivityEntry(
      icon: Icons.check_circle_outline,
      iconColor: AppColors.green,
      iconBg: AppColors.greenFaint,
      title: 'Payment Success',
      description:
          'Payment for "Signature Gold Facial" has been processed successfully. Invoice #8621.',
      time: '2H AGO',
      filter: 'payments',
    ),
  ];

  final List<ActivityEntry> _yesterdayEntries = const [
    ActivityEntry(
      icon: Icons.workspace_premium_outlined,
      iconColor: AppColors.purple,
      iconBg: AppColors.purpleFaint,
      title: 'Elite Status Reached',
      description:
          'Congratulations! You\'ve unlocked Gold Member perks. Enjoy 10% off your next visit.',
      time: 'YESTERDAY',
      filter: 'loyalty',
    ),
    ActivityEntry(
      icon: Icons.star_outline,
      iconColor: AppColors.orange,
      iconBg: AppColors.orangeFaint,
      title: 'Review Your Experience',
      description:
          'How was your haircut with Elena? Share your feedback to earn 50 loyalty points.',
      time: 'YESTERDAY',
      filter: 'bookings',
    ),
    ActivityEntry(
      icon: Icons.content_cut,
      iconColor: AppColors.gold,
      iconBg: AppColors.goldFaint,
      title: 'Haircut Appointment',
      description:
          'Your haircut with Senior Stylist Marco was completed. See you next time!',
      time: 'YESTERDAY',
      filter: 'bookings',
    ),
    ActivityEntry(
      icon: Icons.local_offer_outlined,
      iconColor: AppColors.blue,
      iconBg: AppColors.blueFaint,
      title: 'Loyalty Points Earned',
      description:
          '+120 LUXE points added to your account from your last visit.',
      time: 'YESTERDAY',
      filter: 'loyalty',
    ),
  ];

  List<ActivityEntry> _filtered(List<ActivityEntry> entries) {
    if (_selectedTab == 0) return entries;
    final key = _tabs[_selectedTab].toLowerCase();
    return entries.where((e) => e.filter == key).toList();
  }

  @override
  Widget build(BuildContext context) {
    final todayFiltered = _filtered(_todayEntries);
    final yesterdayFiltered = _filtered(_yesterdayEntries);

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
                    _buildTabBar(),
                    const SizedBox(height: 20),
                    if (todayFiltered.isNotEmpty) ...[
                      _buildGroupLabel('TODAY'),
                      const SizedBox(height: 10),
                      ...todayFiltered.map((e) => _buildActivityCard(e)),
                      const SizedBox(height: 24),
                    ],
                    if (yesterdayFiltered.isNotEmpty) ...[
                      _buildGroupLabel('YESTERDAY'),
                      const SizedBox(height: 10),
                      ...yesterdayFiltered.map((e) => _buildActivityCard(e)),
                    ],
                    if (todayFiltered.isEmpty && yesterdayFiltered.isEmpty)
                      _buildEmptyState(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
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
      leading: const Icon(Icons.arrow_back_ios_new,
          color: AppColors.textPrimary, size: 18),
      title: const Text(
        'Activity Center',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.bold,
          fontFamily: 'Georgia',
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 14),
          child: const Icon(Icons.tune_outlined,
              color: AppColors.textSecondary, size: 22),
        ),
      ],
    );
  }

  // ── Tab Bar ───────────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final selected = i == _selectedTab;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected ? AppColors.gold : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                _tabs[i],
                style: TextStyle(
                  color: selected
                      ? AppColors.gold
                      : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Group Label ───────────────────────────────────────────────────────────────
  Widget _buildGroupLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.8,
        ),
      ),
    );
  }

  // ── Activity Card ─────────────────────────────────────────────────────────────
  Widget _buildActivityCard(ActivityEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: entry.iconBg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(entry.icon, color: entry.iconColor, size: 22),
            ),
            const SizedBox(width: 14),
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
                          entry.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Time / badge
                      if (entry.badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColors.gold.withOpacity(0.4),
                                width: 1),
                          ),
                          child: Text(
                            entry.badge!,
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      else
                        Text(
                          entry.time,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            letterSpacing: 0.3,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.goldFaint,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.inbox_outlined,
                  color: AppColors.gold, size: 30),
            ),
            const SizedBox(height: 16),
            const Text(
              'No activity yet',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your recent activity will appear here.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Navigation ─────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.calendar_today_outlined, 'label': 'Bookings'},
      {'icon': Icons.explore_outlined, 'label': 'Explore'},
      {'icon': Icons.notifications_outlined, 'label': 'Activity'},
      {'icon': Icons.person_outline, 'label': 'Profile'},
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
                    color: selected
                        ? AppColors.gold
                        : AppColors.textSecondary,
                    fontSize: 9,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
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