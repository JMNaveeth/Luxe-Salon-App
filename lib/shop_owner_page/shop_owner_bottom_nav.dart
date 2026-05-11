import 'package:flutter/material.dart';

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
    {'icon': Icons.grid_view_outlined, 'label': 'Dashboard'},
    {'icon': Icons.settings_outlined, 'label': 'Settings'},
    {'icon': Icons.history_outlined, 'label': 'Activity'},
    {'icon': Icons.manage_accounts_outlined, 'label': 'Management'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border(
          top: BorderSide(color: AppColors.gold.withOpacity(0.18)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(_items.length, (i) {
            final selected = i == selectedIndex;
            return Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _items[i]['icon'] as IconData,
                        size: 21,
                        color: selected ? AppColors.gold : AppColors.inactive,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _items[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700,
                          color: selected ? AppColors.gold : AppColors.inactive,
                        ),
                      ),
                      const SizedBox(height: 3),
                      if (selected)
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
