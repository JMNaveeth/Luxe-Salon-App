import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'sh_ow_activty.dart';
import 'sh_ow_home.dart';
import 'shop_gallery.dart';
import 'shop_owner_bottom_nav.dart';
import 'shop_owner_settings.dart';
import 'staff_management.dart';
import 'service_management.dart';

class ShopOwnerManagementScreen extends StatefulWidget {
  const ShopOwnerManagementScreen({super.key});

  @override
  State<ShopOwnerManagementScreen> createState() =>
      _ShopOwnerManagementScreenState();
}

class _ShopOwnerManagementScreenState extends State<ShopOwnerManagementScreen> {
  final int _selectedNavIndex = 2;

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
      case 3:
        destination = const ShopOwnerSettingsScreen();
        break;
      default:
        return;
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute<void>(builder: (_) => destination));
  }

  void _openStaffManagement() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const StaffManagementScreen()),
    );
  }

  void _openServiceManagement() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ServiceManagementScreen()),
    );
  }

  void _openGalleryManagement() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (_) => const ShopGalleryPage(
              shopName: 'The Gilded Touch',
              isOwnerMode: true,
            ),
      ),
    );
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
                            Icons.manage_accounts_outlined,
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
                                'Management',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'STAFF AND SERVICE CONTROL CENTER',
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
                    _buildOverviewCard(),
                    const SizedBox(height: 16),
                    _buildManagementTile(
                      icon: Icons.people_outline,
                      title: 'Staff Management',
                      subtitle: 'View team members, schedules, and performance',
                      onTap: _openStaffManagement,
                    ),
                    const SizedBox(height: 12),
                    _buildManagementTile(
                      icon: Icons.grid_view_outlined,
                      title: 'Service Management',
                      subtitle:
                          'Edit services, pricing, timing, and availability',
                      onTap: _openServiceManagement,
                    ),
                    const SizedBox(height: 12),
                    _buildManagementTile(
                      icon: Icons.photo_library_outlined,
                      title: 'Gallery Management',
                      subtitle: 'Add, edit, and remove salon images and videos',
                      onTap: _openGalleryManagement,
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

  Widget _buildOverviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage your team and catalog from one place.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Jump into staff scheduling or service pricing without leaving the owner dashboard.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
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
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.gold, size: 22),
              ),
              const SizedBox(width: 14),
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
