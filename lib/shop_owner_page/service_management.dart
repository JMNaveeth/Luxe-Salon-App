import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

void main() {
  runApp(const SalonApp());
}

class SalonApp extends StatelessWidget {
  const SalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: AppColors.bg),
      home: const ServiceManagementScreen(),
    );
  }
}

// --- Data Model ---
class ServiceItem {
  final String name;
  final String price;
  final String duration;
  final Color avatarBg;
  bool isActive;

  ServiceItem({
    required this.name,
    required this.price,
    required this.duration,
    required this.avatarBg,
    this.isActive = true,
  });
}

// --- Main Screen ---
class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({super.key});

  @override
  State<ServiceManagementScreen> createState() =>
      _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
  int _selectedNavIndex = 1;

  final List<ServiceItem> _services = [
    ServiceItem(
      name: 'Luxury Signatu...',
      price: 'Rs 85.00',
      duration: '60 MINS',
      avatarBg: const Color(0xFF2A1E3A),
      isActive: true,
    ),
    ServiceItem(
      name: 'Parisian Balaya...',
      price: 'Rs 240.00',
      duration: '180 MINS',
      avatarBg: const Color(0xFF2A1830),
      isActive: true,
    ),
    ServiceItem(
      name: 'Royal Spa Mani...',
      price: 'Rs 55.00',
      duration: '45 MINS',
      avatarBg: const Color(0xFF152A30),
      isActive: false,
    ),
    ServiceItem(
      name: 'Beard Sculpting',
      price: 'Rs 45.00',
      duration: '30 MINS',
      avatarBg: const Color(0xFF1A2040),
      isActive: true,
    ),
    ServiceItem(
      name: 'Gold Facial Tre...',
      price: 'Rs 120.00',
      duration: '90 MINS',
      avatarBg: const Color(0xFF2A2038),
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _AppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Portfolio Overview Card
                    _PortfolioOverviewCard(),

                    const SizedBox(height: 16),

                    // Add New Service Button
                    _AddNewServiceButton(),

                    const SizedBox(height: 24),

                    // Current Offerings Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current Offerings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            fontFamily: 'Georgia',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.tune, color: AppColors.gold, size: 12),
                              SizedBox(width: 4),
                              Text(
                                'FILTER',
                                style: TextStyle(
                                  fontSize: 9,
                                  letterSpacing: 1.5,
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Services List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _services.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _ServiceCard(
                          service: _services[index],
                          onToggle: (val) {
                            setState(() => _services[index].isActive = val);
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            _BottomNavBar(
              selectedIndex: _selectedNavIndex,
              onTap: (i) => setState(() => _selectedNavIndex = i),
            ),
          ],
        ),
      ),
    );
  }
}

// --- App Bar ---
class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: AppColors.gold,
                  size: 20,
                ),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'SERVICE MANAGEMENT',
                style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 2.5,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Portfolio Overview Card ---
class _PortfolioOverviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PORTFOLIO OVERVIEW',
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 2,
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '24',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(width: 10),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  'Boutique Services',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Add New Service Button ---
class _AddNewServiceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.gold, AppColors.goldDim],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, color: AppColors.bg, size: 18),
              SizedBox(width: 8),
              Text(
                'ADD NEW SERVICE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                  color: AppColors.bg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Service Card ---
class _ServiceCard extends StatelessWidget {
  final ServiceItem service;
  final ValueChanged<bool> onToggle;

  const _ServiceCard({required this.service, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: service.isActive ? AppColors.cardBorder : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          // Avatar placeholder
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: service.avatarBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.textMuted,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        service.isActive
                            ? AppColors.textPrimary
                            : const Color(0xFF606888),
                    fontFamily: 'Georgia',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      service.price,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 10,
                      color: AppColors.cardBorder,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      service.duration,
                      style: const TextStyle(
                        fontSize: 10,
                        letterSpacing: 1,
                        color: Color(0xFF606888),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Toggle + Edit
          Column(
            children: [
              _GoldToggle(value: service.isActive, onChanged: onToggle),
              const SizedBox(height: 8),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.textMuted,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Custom Gold Toggle ---
class _GoldToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _GoldToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 38,
          height: 22,
          decoration: BoxDecoration(
            color: value ? AppColors.gold : AppColors.cardBorder,
            borderRadius: BorderRadius.circular(11),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: value ? AppColors.bg : AppColors.textMuted,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Bottom Nav Bar ---
class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  static const _items = [
    {'icon': Icons.bar_chart_outlined, 'label': 'STATS'},
    {'icon': Icons.grid_view_outlined, 'label': 'SERVICES'},
    {'icon': Icons.calendar_today_outlined, 'label': 'BOOKINGS'},
    {'icon': Icons.person_outline, 'label': 'PROFILE'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
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
                      size: 20,
                      color: selected ? AppColors.gold : AppColors.inactive,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _items[i]['label'] as String,
                      style: TextStyle(
                        fontSize: 8,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                        color: selected ? AppColors.gold : AppColors.inactive,
                      ),
                    ),
                    if (selected) ...[
                      const SizedBox(height: 3),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
