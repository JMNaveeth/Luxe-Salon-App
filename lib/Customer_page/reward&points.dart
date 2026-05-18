import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'bottom_nav.dart';

// ─── Models ───────────────────────────────────────────────────────────────────
class TierData {
  final String name;
  final List<Color> backgroundColors;
  final Color accentColor;
  final Color textColor;
  final IconData icon;
  final String nextTier;
  final double progress;
  final int pointsToNext;
  final int currentBalance;

  const TierData({
    required this.name,
    required this.backgroundColors,
    required this.accentColor,
    required this.textColor,
    required this.icon,
    required this.nextTier,
    required this.progress,
    required this.pointsToNext,
    required this.currentBalance,
  });
}

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
  int _currentTierIndex = 1; // Default to Gold
  late PageController _tierPageController;

  @override
  void initState() {
    super.initState();
    _tierPageController = PageController(
      viewportFraction: 0.9,
      initialPage: _currentTierIndex,
    );
  }

  @override
  void dispose() {
    _tierPageController.dispose();
    super.dispose();
  }

  final List<TierData> _tiers = const [
    TierData(
      name: 'BRONZE MEMBER',
      backgroundColors: [
        Color(0xFF4A3B32),
        Color(0xFF2A211C),
        Color(0xFF1C1510),
      ],
      accentColor: Color(0xFFCD7F32), // Bronze
      textColor: Colors.white70,
      icon: Icons.star_border_rounded,
      nextTier: 'Silver',
      progress: 0.95,
      pointsToNext: 150,
      currentBalance: 850,
    ),
    TierData(
      name: 'GOLD MEMBER',
      backgroundColors: [
        Color(0xFF2A2338),
        Color(0xFF1B1728),
        Color(0xFF13101C),
      ],
      accentColor: AppColors.gold,
      textColor: Colors.white,
      icon: Icons.workspace_premium_rounded,
      nextTier: 'Platinum',
      progress: 0.82,
      pointsToNext: 750,
      currentBalance: 2450,
    ),
    TierData(
      name: 'PLATINUM MEMBER',
      backgroundColors: [
        Color(0xFF25303E),
        Color(0xFF18202A),
        Color(0xFF0F151C),
      ],
      accentColor: Color(0xFFE5E4E2), // Platinum/Silver
      textColor: Colors.white,
      icon: Icons.diamond_outlined,
      nextTier: 'Diamond',
      progress: 0.45,
      pointsToNext: 3500,
      currentBalance: 6500,
    ),
    TierData(
      name: 'DIAMOND MEMBER',
      backgroundColors: [
        Color(0xFF1A3344),
        Color(0xFF11222E),
        Color(0xFF0A151D),
      ],
      accentColor: Color(0xFF4FC3F7), // Diamond Blue
      textColor: Colors.white,
      icon: Icons.diamond_rounded,
      nextTier: 'Max Tier Reached',
      progress: 1.0,
      pointsToNext: 0,
      currentBalance: 12500,
    ),
  ];

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
      title: 'Rs 20 Voucher',
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
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: _tierPageController,
                    onPageChanged:
                        (index) => setState(() => _currentTierIndex = index),
                    itemCount: _tiers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _buildMembershipCard(_tiers[index]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Pagination dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _tiers.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentTierIndex == index ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color:
                            _currentTierIndex == index
                                ? _tiers[_currentTierIndex].accentColor
                                : AppColors.inactive,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      _buildNextTierProgress(_tiers[_currentTierIndex]),
                      const SizedBox(height: 28),
                      _buildSectionHeader('Exclusive Rewards', 'View All'),
                      const SizedBox(height: 14),
                      _buildRewardsGrid(),
                      const SizedBox(height: 28),
                      _buildSectionHeader('Recent Activity', ''),
                      const SizedBox(height: 14),
                      _buildActivityList(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const LuxeBottomNav(currentIndex: 3),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.bg,
      elevation: 0,
      leading: const Icon(
        Icons.arrow_back_ios_new,
        color: AppColors.textPrimary,
        size: 18,
      ),
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
          child: const Icon(
            Icons.info_outline,
            color: AppColors.textSecondary,
            size: 22,
          ),
        ),
      ],
    );
  }

  // ── Membership Card ───────────────────────────────────────────────────────────
  Widget _buildMembershipCard(TierData tier) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: tier.backgroundColors,
        ),
        border: Border.all(
          color: tier.accentColor.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: tier.accentColor.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative crown/circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    tier.accentColor.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tier.accentColor.withOpacity(0.05),
              ),
            ),
          ),
          // Crown icon top-right
          Positioned(
            top: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(tier.icon, color: tier.accentColor, size: 38),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            tier.accentColor.withOpacity(0.3),
                            tier.accentColor.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: tier.accentColor.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: tier.accentColor, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            'LUXE Privilege',
                            style: TextStyle(
                              color: tier.accentColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tier.accentColor.withOpacity(0.15),
                        border: Border.all(
                          color: tier.accentColor.withOpacity(0.3),
                        ),
                      ),
                      child: Icon(
                        Icons.settings_outlined,
                        color: tier.accentColor,
                        size: 13,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ShaderMask(
                  shaderCallback:
                      (bounds) => LinearGradient(
                        colors: [
                          tier.accentColor.withOpacity(0.6),
                          tier.accentColor,
                          tier.accentColor.withOpacity(0.8),
                        ],
                      ).createShader(bounds),
                  child: Text(
                    tier.name,
                    style: TextStyle(
                      color: tier.textColor,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'CURRENT BALANCE',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${tier.currentBalance}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Padding(
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
  Widget _buildNextTierProgress(TierData tier) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface, // Brighter card surface
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tier.accentColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Next Tier Progress',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${(tier.progress * 100).toInt()}%',
                style: TextStyle(
                  color: tier.accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            tier.pointsToNext > 0
                ? '${tier.pointsToNext} points to ${tier.nextTier} Level'
                : 'Maximum tier reached',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          // Progress bar
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: tier.accentColor.withOpacity(
                    0.15,
                  ), // Softer background matched to theme
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: tier.progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: [
                        tier.accentColor.withOpacity(0.6),
                        tier.accentColor,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.star_outline, color: tier.accentColor, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${tier.name.split(' ')[0]} members receive complimentary style consultation on arrival',
                  style: const TextStyle(
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
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
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
        children:
            _activities.asMap().entries.map((e) {
              final i = e.key;
              final a = e.value;
              final isEarned = a.points > 0;
              return Column(
                children: [
                  if (i != 0)
                    Divider(
                      height: 1,
                      color: AppColors.divider,
                      indent: 16,
                      endIndent: 16,
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                isEarned
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
                              isEarned ? '+${a.points}' : '${a.points}',
                              style: TextStyle(
                                color:
                                    isEarned ? AppColors.green : AppColors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isEarned ? 'POINTS EARNED' : 'REDEEMED',
                              style: TextStyle(
                                color:
                                    isEarned
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
  // Note: we removed _buildBottomNav here because bottomNavigationBar is replaced with LuxeBottomNav
}
