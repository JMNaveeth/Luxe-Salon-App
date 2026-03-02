import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'booking_page_1.dart' as booking_page;
import 'location_picker.dart';
import '../shop_owner_page/service_management.dart';
import '../shop_owner_page/shop_gallery.dart';

// main() is not needed here, entry is in main.dart

class LuxeApp extends StatelessWidget {
  const LuxeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luxe Salon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A12),
        fontFamily: 'Georgia',
      ),
      home: const HomeScreen(),
    );
  }
}

// ─── Color Palette ────────────────────────────────────────────────────────────
class AppColors {
  static const background = Color(0xFF1A1A12);
  static const cardDark = Color(0xFF252518);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFE8C065);
  static const darkGreen = Color(0xFF1E2A1A);
  static const surface = Color(0xFF2A2A1E);
  static const textPrimary = Color(0xFFF5EDD6);
  static const textSecondary = Color(0xFF9A9070);
  static const white = Color(0xFFFFFFFF);
  static const heartBg = Color(0x33FFFFFF);
  static const tagBg = Color(0xFFD4A843);
  static const ratingBg = Color(0xFFD4A843);
}

// ─── Home Screen ──────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedService = 0;
  String _selectedLocation = 'Select Location';

  // Salon-specific service categories
  final List<Map<String, dynamic>> _services = [
    {'icon': Icons.content_cut, 'label': 'HAIRCUT'},
    {'icon': Icons.face_retouching_natural_outlined, 'label': 'FACIAL'},
    {'icon': Icons.brush_outlined, 'label': 'COLOR'},
    {'icon': Icons.back_hand_outlined, 'label': 'NAILS'},
    {'icon': Icons.straighten, 'label': 'STYLING'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              _buildLocationRow(),
              _buildServicesSection(),
              _buildRecommendedSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const LuxeBottomNav(currentIndex: 0),
    );
  }

  // ── Top Bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withOpacity(0.3),
                  border: Border.all(color: AppColors.gold, width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://i.pravatar.cc/100?img=47',
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => const Icon(
                          Icons.person,
                          color: AppColors.gold,
                          size: 28,
                        ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'VIP',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 6,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Welcome back,',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
              Text(
                'Julianne',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
              Positioned(
                top: 6,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Location Row ──────────────────────────────────────────────────────────
  Widget _buildLocationRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.of(context).push<String>(
            MaterialPageRoute(builder: (_) => const LocationPickerPage()),
          );
          if (result != null) {
            setState(() => _selectedLocation = result);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.gold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.gold,
                size: 16,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  _selectedLocation.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.gold,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Services Section ──────────────────────────────────────────────────────
  Widget _buildServicesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            children: [
              const Text(
                'Browse Services',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Text(
                'VIEW ALL',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_services.length, (i) {
                final selected = i == _selectedService;
                return Padding(
                  padding: EdgeInsets.only(
                    right: i < _services.length - 1 ? 10 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedService = i),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            color:
                                selected ? AppColors.gold : AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
                            border:
                                selected
                                    ? null
                                    : Border.all(
                                      color: AppColors.gold.withOpacity(0.2),
                                      width: 1,
                                    ),
                            boxShadow:
                                selected
                                    ? [
                                      BoxShadow(
                                        color: AppColors.gold.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                    : [],
                          ),
                          child: Icon(
                            _services[i]['icon'] as IconData,
                            color: selected ? Colors.black : AppColors.gold,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          _services[i]['label'] as String,
                          style: TextStyle(
                            color:
                                selected
                                    ? AppColors.gold
                                    : AppColors.textSecondary,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ── Recommended Section ───────────────────────────────────────────────────
  Widget _buildRecommendedSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          Row(
            children: const [
              Text(
                'Top Salons Near You',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSalonCard(
            imageUrl:
                'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=600',
            name: 'Aura Hair Studio',
            distance: '1.3 miles · Upper East Side',
            tags: ['Haircut', 'Colour', 'Blowout'],
            rating: 4.9,
            reviewCount: 214,
          ),
          const SizedBox(height: 16),
          _buildSalonCard(
            imageUrl:
                'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=600',
            name: 'Lumière Salon & Facial Bar',
            distance: '1.2 miles · Madison Ave',
            tags: ['Facial', 'Haircut', 'Waxing'],
            rating: 4.7,
            reviewCount: 189,
            darkTheme: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSalonCard({
    required String imageUrl,
    required String name,
    required String distance,
    required List<String> tags,
    required double rating,
    required int reviewCount,
    bool darkTheme = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: darkTheme ? AppColors.darkGreen : AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.gold.withOpacity(darkTheme ? 0.25 : 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with overlays
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  imageUrl,
                  height: 165,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        height: 165,
                        color: AppColors.surface,
                        child: const Center(
                          child: Icon(
                            Icons.content_cut,
                            color: AppColors.gold,
                            size: 48,
                          ),
                        ),
                      ),
                ),
              ),
              // Gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.55),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Favourite button
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.heartBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              // Rating badge on image
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.black, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        '$rating  ($reviewCount)',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Info section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.gold,
                            size: 13,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              distance,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Service tags
                      Wrap(
                        spacing: 6,
                        children:
                            tags
                                .map(
                                  (t) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.gold.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: AppColors.gold.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      t,
                                      style: const TextStyle(
                                        color: AppColors.gold,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Services & Gallery row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCardIconBtn(
                          icon: Icons.design_services_outlined,
                          label: 'Services',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ServiceManagementScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildCardIconBtn(
                          icon: Icons.photo_library_outlined,
                          label: 'Gallery',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ShopGalleryPage(shopName: name),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // BOOK button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => const booking_page.SecureCheckoutPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'BOOK',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 0.8,
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

  // ── Small icon button for salon card ──────────────────────────────────────
  Widget _buildCardIconBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.gold.withOpacity(0.30), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.gold, size: 18),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
