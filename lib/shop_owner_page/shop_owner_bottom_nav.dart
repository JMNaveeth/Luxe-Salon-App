import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class ShopOwnerBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const ShopOwnerBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = [
    {'icon': Icons.grid_view_outlined, 'active': Icons.grid_view_rounded, 'label': 'Dashboard'},
    {'icon': Icons.history_outlined, 'active': Icons.history_rounded, 'label': 'Activity'},
    {'icon': Icons.manage_accounts_outlined, 'active': Icons.manage_accounts_rounded, 'label': 'Management'},
    {'icon': Icons.settings_outlined, 'active': Icons.settings_rounded, 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: Border(
          top: BorderSide(color: AppColors.gold.withOpacity(0.08), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              return _NavItem(
                icon: _items[i]['icon'] as IconData,
                activeIcon: _items[i]['active'] as IconData,
                label: _items[i]['label'] as String,
                isActive: i == selectedIndex,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onTap(i);
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.gold.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOut,
              width: isActive ? 36 : 22,
              height: isActive ? 36 : 22,
              decoration: BoxDecoration(
                gradient: isActive ? AppColors.primaryGradient : null,
                color: isActive ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? Colors.transparent : AppColors.textMuted.withOpacity(0.18),
                  width: 1,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withOpacity(0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? Colors.white : AppColors.textMuted,
                  size: isActive ? 18 : 19,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: isActive ? AppColors.gold : AppColors.textMuted,
                fontSize: 9.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 2),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.45),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
