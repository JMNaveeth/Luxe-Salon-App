import 'package:flutter/material.dart';

void main() => runApp(const LoyaltyApp());

class LoyaltyApp extends StatelessWidget {
  const LoyaltyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loyalty & Rewards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Georgia',
      ),
      home: const LoyaltyPage(),
    );
  }
}

// ─── Palette ──────────────────────────────────────────────────────────────────
class AppColors {
  static const bg = Color(0xFF131309);
  static const surface = Color(0xFF1E1E12);
  static const card = Color(0xFF1C1C10);
  static const cardBorder = Color(0xFF2A2A18);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFE8C060);
  static const goldDim = Color(0xFF6B5218);
  static const goldFaint = Color(0xFF2A2210);
  static const textPrimary = Color(0xFFF5EDD6);
  static const textSecondary = Color(0xFF8A7A55);
  static const textMuted = Color(0xFF504530);
  static const divider = Color(0xFF222214);
  static const green = Color(0xFF6BBF6B);
  static const red = Color(0xFFE07070);
  static const progressBg = Color(0xFF2A2A18);
}

// ─── Models ───────────────────────────────────────────────────────────────────
class RewardCard {
  final IconData icon;
  final String title;
  final String subtitle;
  final int points;
  const RewardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.points,
  });
}

class ActivityItem {
  final IconData icon;
  final String title;
  final String date;
  final int points;
  const ActivityItem({
    required this.icon,
    required this.title,
    required this.date,
    required this.points,
  });
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class LoyaltyPage extends StatefulWidget {
  const LoyaltyPage({super.key});

  @override
  State<LoyaltyPage> createState() => _LoyaltyPageState();
}

class _LoyaltyPageState extends State<LoyaltyPage> {
  int _selectedNav = 2; // LUXE tab active

  final List<RewardCard> _rewards = const [
    RewardCard(
      icon: Icons.content_cut,
      title: '15% Off Haircut',
      subtitle: 'Valid for Master Stylists only',
      points: 500,
    ),
    RewardCard(
      icon: Icons.face_retouching_natural_outlined,
      title: 'Free Face Mask',
      subtitle: 'Add-on to any facial booking',
      points: 350,
    ),
    RewardCard(
      icon: Icons.brush_outlined,
      title: 'Free Blowout',
      subtitle: 'With any colour service',
      points: 700,
    ),
    RewardCard(
      icon: Icons.local_offer_outlined,
      title: '\$20 Voucher',
      subtitle: 'Off your next visit',
      points: 1000,
    ),
  ];

  final List<ActivityItem> _activities = const [
    ActivityItem(
      icon: Icons.content_cut,
      title: 'Signature Haircut',
      date: 'OCT 24, 2023',
      points: 120,
    ),
    ActivityItem(
      icon: Icons.oil_barrel_outlined,
      title: 'Beard Oil Premium',
      date: 'OCT 12, 2023',
      points: 45,
    ),
    ActivityItem(
      icon: Icons.card_giftcard_outlined,
      title: 'Hair Wax Discount',
      date: 'SEP 28, 2023',
      points: -250,
    ),
    ActivityItem(
      icon: Icons.face_retouching_natural_outlined,
      title: 'Gold Facial Treatment',
      date: 'SEP 10, 2023',
      points: 180,
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
                      _buildMembershipCard(),
                      const SizedBox(height: 20),
                      _buildNextTierProgress(),
                      const SizedBox(height: 28),
                      _buildSectionHeader('Exclusive Rewards', 'View All'),
                      const SizedBox(height: 14),
                      _buildRewardsGrid(),
                      const SizedBox(height: 28),
                      _buildSectionHeader('Recent Activity', ''),
                      const SizedBox(height: 14),
                      _buildActivityList(),
                      const SizedBox(height: 100),
                    ],
                  ),
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
        'Loyalty & Rewards',
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
          child: const Icon(Icons.info_outline,
              color: AppColors.textSecondary, size: 22),
        ),
      ],
    );
  }

  // ── Membership Card ───────────────────────────────────────────────────────────
  Widget _buildMembershipCard() {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2A2008),
            Color(0xFF1A1405),
            Color(0xFF0E0D05),
          ],
        ),
        border: Border.all(color: AppColors.gold.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative crown/circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withOpacity(0.06),
              ),
            ),
          ),
          // Crown icon top-right
          Positioned(
            top: 20,
            right: 20,
            child: Icon(
              Icons.workspace_premium,
              color: AppColors.gold.withOpacity(0.6),
              size: 44,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.gold.withOpacity(0.5), width: 1),
                      ),
                      child: const Text(
                        'LUXE Privilege',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.gold.withOpacity(0.2),
                      ),
                      child: const Icon(Icons.settings_outlined,
                          color: AppColors.gold, size: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'GOLD MEMBER',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'CURRENT BALANCE',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 9,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      '2,450',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(width: 6),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'LUXE Points',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
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

  // ── Next Tier Progress ────────────────────────────────────────────────────────
  Widget _buildNextTierProgress() {
    const double progress = 0.82;
    const int pointsNeeded = 750;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Next Tier Progress',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                '82%',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            '$pointsNeeded points to Platinum Level',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
          const SizedBox(height: 14),
          // Progress bar
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.progressBg,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: const LinearGradient(
                      colors: [AppColors.goldDim, AppColors.gold],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Icon(Icons.star_outline, color: AppColors.gold, size: 14),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Platinum members receive complimentary style consultation on arrival',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Section Header ────────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, String action) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (action.isNotEmpty)
          Text(
            action,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
      ],
    );
  }

  // ── Rewards Grid ──────────────────────────────────────────────────────────────
  Widget _buildRewardsGrid() {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _rewards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final r = _rewards[i];
          return Container(
            width: 148,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon circle
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(r.icon, color: AppColors.gold, size: 22),
                ),
                const SizedBox(height: 10),
                Text(
                  r.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  r.subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 9,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                // Redeem button
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Redeem for ${r.points} pts',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Activity List ─────────────────────────────────────────────────────────────
  Widget _buildActivityList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        children: _activities.asMap().entries.map((e) {
          final i = e.key;
          final a = e.value;
          final isEarned = a.points > 0;
          return Column(
            children: [
              if (i != 0)
                Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isEarned
                            ? AppColors.gold.withOpacity(0.1)
                            : AppColors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        a.icon,
                        color: isEarned ? AppColors.gold : AppColors.red,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            a.date,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 10,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isEarned
                              ? '+${a.points}'
                              : '${a.points}',
                          style: TextStyle(
                            color: isEarned ? AppColors.green : AppColors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEarned ? 'POINTS EARNED' : 'REDEEMED',
                          style: TextStyle(
                            color: isEarned
                                ? AppColors.textMuted
                                : AppColors.red.withOpacity(0.7),
                            fontSize: 8,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Bottom Navigation ─────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'HOME'},
      {'icon': Icons.calendar_today_outlined, 'label': 'BOOK'},
      {'icon': Icons.stars_outlined, 'label': 'LUXE'},
      {'icon': Icons.person_outline, 'label': 'PROFILE'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
            top: BorderSide(color: AppColors.gold.withOpacity(0.2), width: 1)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = i == _selectedNav;
              // Centre button (index 1 = BOOK) gets FAB treatment
              if (i == 1) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedNav = i),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withOpacity(0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.black, size: 26),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'BOOK',
                        style: TextStyle(
                          color: selected
                              ? AppColors.gold
                              : AppColors.textSecondary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return GestureDetector(
                onTap: () => setState(() => _selectedNav = i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    Icon(
                      items[i]['icon'] as IconData,
                      color: selected
                          ? AppColors.gold
                          : AppColors.textSecondary,
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
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        letterSpacing: 0.5,
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
        ],
      ),
    );
  }
}