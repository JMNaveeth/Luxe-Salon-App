import 'package:flutter/material.dart';
import 'customer_home.dart' as home_page;
import 'custo_activity_history.dart' as activity_page;
import 'booking_page_1.dart' as booking_page;
import 'customer_profile.dart' as profile_page;

// ─── Shared Colors (matches home palette) ─────────────────────────────────────
class NavColors {
  static const surface = Color(0xFF2A2A1E);
  static const gold = Color(0xFFD4A843);
  static const textSecondary = Color(0xFF9A9070);
}

// ─── Shared Bottom Navigation Bar ─────────────────────────────────────────────
// Pass [currentIndex] to highlight the active tab:
//   0 = HOME, 1 = ACTIVITY, 2 = BOOKINGS, 3 = PROFILE
class LuxeBottomNav extends StatelessWidget {
  final int currentIndex;
  const LuxeBottomNav({super.key, required this.currentIndex});

  static const _items = [
    {'icon': Icons.home_outlined, 'label': 'HOME'},
    {'icon': Icons.history_outlined, 'label': 'ACTIVITY'},
    {'icon': Icons.calendar_today_outlined, 'label': 'BOOKINGS'},
    {'icon': Icons.person_outline, 'label': 'PROFILE'},
  ];

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return; // already on this page

    Widget destination;
    switch (index) {
      case 0:
        destination = const home_page.HomeScreen();
        break;
      case 1:
        destination = const activity_page.ActivityCenterPage();
        break;
      case 2:
        destination = const booking_page.SecureCheckoutPage();
        break;
      case 3:
        destination = const profile_page.ProfilePage();
        break;
      default:
        return;
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => destination));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NavColors.surface,
        border: Border(
          top: BorderSide(color: NavColors.gold.withOpacity(0.2), width: 1),
        ),
      ),
      padding: const EdgeInsets.only(top: 10, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final selected = i == currentIndex;
          return GestureDetector(
            onTap: () => _onTap(context, i),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 64,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _items[i]['icon'] as IconData,
                    color: selected ? NavColors.gold : NavColors.textSecondary,
                    size: 22,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _items[i]['label'] as String,
                    style: TextStyle(
                      color:
                          selected ? NavColors.gold : NavColors.textSecondary,
                      fontSize: 9,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (selected)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: NavColors.gold,
                        shape: BoxShape.circle,
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
