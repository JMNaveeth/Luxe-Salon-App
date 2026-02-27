import 'package:flutter/material.dart';

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
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF0A0A0A)),
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
      price: '\$85.00',
      duration: '60 MINS',
      avatarBg: const Color(0xFF2A2218),
      isActive: true,
    ),
    ServiceItem(
      name: 'Parisian Balaya...',
      price: '\$240.00',
      duration: '180 MINS',
      avatarBg: const Color(0xFF2A1E18),
      isActive: true,
    ),
    ServiceItem(
      name: 'Royal Spa Mani...',
      price: '\$55.00',
      duration: '45 MINS',
      avatarBg: const Color(0xFF1E2A20),
      isActive: false,
    ),
    ServiceItem(
      name: 'Beard Sculpting',
      price: '\$45.00',
      duration: '30 MINS',
      avatarBg: const Color(0xFF1A1E2A),
      isActive: true,
    ),
    ServiceItem(
      name: 'Gold Facial Tre...',
      price: '\$120.00',
      duration: '90 MINS',
      avatarBg: const Color(0xFF2A2418),
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
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
                            color: Color(0xFFE8E8E8),
                            fontFamily: 'Georgia',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: const Color(0xFF2A2A2A)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.tune,
                                  color: Color(0xFFD4A843), size: 12),
                              SizedBox(width: 4),
                              Text(
                                'FILTER',
                                style: TextStyle(
                                  fontSize: 9,
                                  letterSpacing: 1.5,
                                  color: Color(0xFFD4A843),
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
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
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
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: const Icon(Icons.chevron_left,
                  color: Color(0xFFD4A843), size: 20),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'SERVICE MANAGEMENT',
                style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 2.5,
                  color: Color(0xFFE8E8E8),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: const Icon(Icons.search,
                color: Color(0xFF888888), size: 18),
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
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PORTFOLIO OVERVIEW',
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 2,
              color: Color(0xFFD4A843),
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
                  color: Color(0xFFE8E8E8),
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
                    color: Color(0xFF888888),
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
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD4A843), Color(0xFFB8861F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4A843).withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline,
                color: Color(0xFF0A0A0A), size: 18),
            SizedBox(width: 8),
            Text(
              'ADD NEW SERVICE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
                color: Color(0xFF0A0A0A),
              ),
            ),
          ],
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
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: service.isActive
              ? const Color(0xFF2A2A2A)
              : const Color(0xFF1E1E1E),
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
            child: const Icon(Icons.person_outline,
                color: Color(0xFF555555), size: 28),
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
                    color: service.isActive
                        ? const Color(0xFFE8E8E8)
                        : const Color(0xFF666666),
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
                        color: Color(0xFFD4A843),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 10,
                      color: const Color(0xFF333333),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      service.duration,
                      style: const TextStyle(
                        fontSize: 10,
                        letterSpacing: 1,
                        color: Color(0xFF666666),
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
              _GoldToggle(
                value: service.isActive,
                onChanged: onToggle,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF555555),
                  size: 16,
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
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 38,
        height: 22,
        decoration: BoxDecoration(
          color: value ? const Color(0xFFD4A843) : const Color(0xFF2A2A2A),
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
              color: value ? const Color(0xFF0A0A0A) : const Color(0xFF555555),
              shape: BoxShape.circle,
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

  const _BottomNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

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
        color: Color(0xFF111111),
        border: Border(top: BorderSide(color: Color(0xFF1E1E1E))),
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _items[i]['icon'] as IconData,
                    size: 20,
                    color: selected
                        ? const Color(0xFFD4A843)
                        : const Color(0xFF444444),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _items[i]['label'] as String,
                    style: TextStyle(
                      fontSize: 8,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? const Color(0xFFD4A843)
                          : const Color(0xFF444444),
                    ),
                  ),
                  if (selected) ...[
                    const SizedBox(height: 3),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4A843),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}