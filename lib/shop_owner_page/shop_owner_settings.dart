import 'package:flutter/material.dart';

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
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildActionCard(
                      icon: Icons.lock_outline,
                      title: 'Security',
                      subtitle: 'Change password and login verification',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildActionCard(
                      icon: Icons.logout,
                      title: 'Log out',
                      subtitle: 'Sign out of the shop owner account',
                      isDestructive: true,
                      onTap: () {},
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.gold.withOpacity(0.25),
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
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The Gilded Touch',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Elite partner shop owner account',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
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
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: (isDestructive ? AppColors.error : AppColors.gold)
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? AppColors.error : AppColors.gold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color:
                            isDestructive
                                ? AppColors.error
                                : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
