import 'package:flutter/material.dart';

void main() => runApp(const ProfileApp());

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Georgia',
      ),
      home: const ProfilePage(),
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
  static const goldDim = Color(0xFF6B5218);
  static const textPrimary = Color(0xFFF5EDD6);
  static const textSecondary = Color(0xFF8A7A55);
  static const textMuted = Color(0xFF504530);
  static const divider = Color(0xFF1E1E10);
  static const toggleActive = Color(0xFFD4A843);
  static const toggleInactive = Color(0xFF2A2A18);
}

// ─── Settings Item Model ──────────────────────────────────────────────────────
class SettingsItem {
  final IconData icon;
  final String label;
  final bool isToggle;
  final bool isDestructive;
  SettingsItem({
    required this.icon,
    required this.label,
    this.isToggle = false,
    this.isDestructive = false,
  });
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _darkMode = true;
  int _selectedNav = 3; // PROFILE active

  final List<SettingsItem> _generalSettings = [
    SettingsItem(icon: Icons.shield_outlined, label: 'Account Security'),
    SettingsItem(icon: Icons.credit_card_outlined, label: 'Payment Methods'),
    SettingsItem(icon: Icons.notifications_outlined, label: 'Notifications'),
    SettingsItem(icon: Icons.dark_mode_outlined, label: 'Dark Mode', isToggle: true),
    SettingsItem(icon: Icons.help_outline, label: 'Help & Support'),
  ];

  final List<SettingsItem> _accountSettings = [
    SettingsItem(icon: Icons.bookmark_border, label: 'Saved Salons'),
    SettingsItem(icon: Icons.history, label: 'Booking History'),
    SettingsItem(icon: Icons.star_outline, label: 'My Reviews'),
    SettingsItem(
      icon: Icons.logout,
      label: 'Log Out',
      isDestructive: true,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildProfileHeader(),
                    const SizedBox(height: 28),
                    _buildStatsRow(),
                    const SizedBox(height: 28),
                    _buildSection('GENERAL SETTINGS', _generalSettings),
                    const SizedBox(height: 24),
                    _buildSection('MY ACCOUNT', _accountSettings),
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
        'Profile',
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
          child: const Icon(Icons.edit_outlined,
              color: AppColors.textSecondary, size: 20),
        ),
      ],
    );
  }

  // ── Profile Header ────────────────────────────────────────────────────────────
  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.gold.withOpacity(0.35), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.15),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              // Avatar
              ClipOval(
                child: Image.network(
                  'https://i.pravatar.cc/200?img=60',
                  width: 92,
                  height: 92,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 92,
                    height: 92,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                    ),
                    child: const Icon(Icons.person,
                        color: AppColors.gold, size: 46),
                  ),
                ),
              ),
              // Camera badge
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bg, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt_outlined,
                      color: Colors.black, size: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Alex Sterling',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.workspace_premium, color: AppColors.gold, size: 14),
              SizedBox(width: 5),
              Text(
                'PREMIUM MEMBER',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Stats Row ─────────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            _buildStatItem('28', 'Bookings'),
            _buildStatDivider(),
            _buildStatItem('2,450', 'LUXE Pts'),
            _buildStatDivider(),
            _buildStatItem('4.9', 'Avg Rating'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.cardBorder,
    );
  }

  // ── Settings Section ──────────────────────────────────────────────────────────
  Widget _buildSection(String title, List<SettingsItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: Column(
              children: items.asMap().entries.map((e) {
                final i = e.key;
                final item = e.value;
                return Column(
                  children: [
                    if (i != 0)
                      Divider(
                          height: 1,
                          color: AppColors.divider,
                          indent: 56,
                          endIndent: 16),
                    _buildSettingsRow(item),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsRow(SettingsItem item) {
    final isDestructive = item.isDestructive;

    return GestureDetector(
      onTap: () {
        if (item.isToggle) {
          setState(() => _darkMode = !_darkMode);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withOpacity(0.08)
                    : AppColors.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.icon,
                color: isDestructive ? Colors.redAccent : AppColors.gold,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  color: isDestructive
                      ? Colors.redAccent
                      : AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (item.isToggle)
              _buildToggle(_darkMode)
            else
              Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(bool value) {
    return GestureDetector(
      onTap: () => setState(() => _darkMode = !_darkMode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 46,
        height: 26,
        decoration: BoxDecoration(
          color: value ? AppColors.toggleActive : AppColors.toggleInactive,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: value
                ? AppColors.gold.withOpacity(0.5)
                : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 220),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final selected = i == _selectedNav;

          // BOOK = floating gold circle
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
                    child: const Icon(Icons.add, color: Colors.black, size: 26),
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
                  color: selected ? AppColors.gold : AppColors.textSecondary,
                  size: 22,
                ),
                const SizedBox(height: 3),
                Text(
                  items[i]['label'] as String,
                  style: TextStyle(
                    color: selected ? AppColors.gold : AppColors.textSecondary,
                    fontSize: 9,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
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
    );
  }
}