import 'package:flutter/material.dart';

import '../auth/role_selection_page.dart';
import '../theme/app_colors.dart';
import 'sh_ow_activty.dart';
import 'sh_ow_home.dart';
import 'shop_owner_bottom_nav.dart';
import 'shop_owner_management.dart';

class ShopOwnerSettingsScreen extends StatefulWidget {
  const ShopOwnerSettingsScreen({super.key});

  @override
  State<ShopOwnerSettingsScreen> createState() =>
      _ShopOwnerSettingsScreenState();
}

class _ShopOwnerSettingsScreenState extends State<ShopOwnerSettingsScreen> {
  final int _selectedNavIndex = 3;
  bool _notificationsEnabled = true;
  bool _autoAcceptBookings = false;

  void _navigateToSection(int index) {
    if (index == _selectedNavIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = const DashboardPage();
        break;
      case 1:
        destination = const ActivityHistoryScreen();
        break;
      case 2:
        destination = const ShopOwnerManagementScreen();
        break;
      default:
        return;
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute<void>(builder: (_) => destination));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: const Icon(
                            Icons.settings_outlined,
                            color: AppColors.gold,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Settings',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'SHOP PREFERENCES & ACCOUNT CONTROL',
                                style: TextStyle(
                                  fontSize: 9,
                                  letterSpacing: 2,
                                  color: Color(0xFF606888),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildProfileCard(),
                    const SizedBox(height: 16),
                    _buildToggleCard(
                      title: 'Notifications',
                      subtitle: 'Receive booking, payout, and staff alerts',
                      value: _notificationsEnabled,
                      onChanged:
                          (value) =>
                              setState(() => _notificationsEnabled = value),
                    ),
                    const SizedBox(height: 12),
                    _buildToggleCard(
                      title: 'Auto-accept bookings',
                      subtitle: 'Instantly confirm trusted repeat clients',
                      value: _autoAcceptBookings,
                      onChanged:
                          (value) =>
                              setState(() => _autoAcceptBookings = value),
                    ),
                    const SizedBox(height: 16),
                    _buildActionCard(
                      icon: Icons.storefront_outlined,
                      title: 'Shop details',
                      subtitle: 'Update business name, address, and hours',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Shop details opening soon...'),
                            backgroundColor: AppColors.gold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildActionCard(
                      icon: Icons.lock_outline,
                      title: 'Security',
                      subtitle: 'Change password and login verification',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Security settings opening soon...'),
                            backgroundColor: AppColors.gold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildActionCard(
                      icon: Icons.logout,
                      title: 'Log out',
                      subtitle: 'Sign out of the shop owner account',
                      isDestructive: true,
                      onTap: () {
                        // Real log out navigation
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const RoleSelectionPage(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            ShopOwnerBottomNav(
              selectedIndex: _selectedNavIndex,
              onTap: _navigateToSection,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gold.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            AppColors.card,
            AppColors.card.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: AppColors.gold,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                'https://i.pravatar.cc/100?img=47',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'The Gilded Touch',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'ELITE PARTNER',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.qr_code_scanner,
            color: AppColors.gold,
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: value ? AppColors.card : AppColors.card.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: value ? AppColors.gold.withOpacity(0.4) : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: value ? AppColors.gold : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.gold,
            activeTrackColor: AppColors.gold.withOpacity(0.3),
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.bg,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        splashColor: (isDestructive ? AppColors.error : AppColors.gold)
            .withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (isDestructive ? AppColors.error : AppColors.gold)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? AppColors.error : AppColors.gold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color:
                            isDestructive
                                ? AppColors.error
                                : AppColors.textPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: isDestructive ? AppColors.error.withOpacity(0.5) : AppColors.gold.withOpacity(0.5),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
