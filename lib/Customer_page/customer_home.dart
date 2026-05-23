import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottom_nav.dart';
import 'booking_page_1.dart' as booking_page;
import 'customer_profile.dart';
import 'favorite_salons_store.dart';
import 'location_picker.dart';
import 'selected_shop.dart' as shop_detail;
import '../shop_owner_page/shop_gallery.dart';
import '../theme/app_colors.dart';

// ─── Home Screen ──────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedLocation = 'Select Location';
  final GlobalKey<AnimatedListState> _recommendedListKey =
      GlobalKey<AnimatedListState>();
  bool _filtersApplied = false;

  // Filter state variables
  double _maxDistance = 10.0;
  double _minRating = 3.5;
  double _maxPrice = 2000.0;
  String _selectedServiceType = 'All';

  int get _activeFilterCount {
    if (!_filtersApplied) {
      return 0;
    }

    int count = 0;
    if (_maxDistance < 10.0) count++;
    if (_minRating > 0.0) count++;
    if (_maxPrice < 2000.0) count++;
    if (_selectedServiceType != 'All') count++;
    if (_selectedLocation != 'Select Location') count++;
    return count;
  }

  List<Map<String, dynamic>> get _filteredSalons {
    if (!_filtersApplied) {
      return List<Map<String, dynamic>>.from(_salons);
    }

    return _salons.where((salon) {
      // 1. Distance filter
      final String distStr = salon['distance'] as String;
      final distMatch = RegExp(r'([\d.]+)\s*km').firstMatch(distStr);
      if (distMatch != null) {
        final dist = double.tryParse(distMatch.group(1) ?? '') ?? 0.0;
        if (dist > _maxDistance) return false;
      }

      // 2. Rating filter
      final rating = salon['rating'] as double;
      if (rating < _minRating) return false;

      // 3. Price filter (any service is <= _maxPrice)
      final services = salon['services'] as List<shop_detail.SpaService>;
      final hasMatchingPrice = services.any((s) => s.price <= _maxPrice);
      if (!hasMatchingPrice) return false;

      // 4. Service type filter
      if (_selectedServiceType != 'All') {
        final hasMatchingService = services.any((s) {
          final name = s.name.toLowerCase();
          final type = _selectedServiceType.toLowerCase();
          if (type == 'haircut' &&
              (name.contains('cut') ||
                  name.contains('trim') ||
                  name.contains('styling')))
            return true;
          if (type == 'facial' && name.contains('facial')) return true;
          if (type == 'spa/massage' &&
              (name.contains('spa') ||
                  name.contains('massage') ||
                  name.contains('cleanse') ||
                  name.contains('pedi') ||
                  name.contains('mani')))
            return true;
          if (type == 'treatment' && name.contains('treatment')) return true;
          return false;
        });
        if (!hasMatchingService) return false;
      }

      // 5. Location filter
      if (_selectedLocation != 'Select Location') {
        final area = _selectedLocation.split(',').first.trim().toLowerCase();
        final salonAddress = distStr.toLowerCase();
        if (!salonAddress.contains(area)) return false;
      }

      return true;
    }).toList();
  }

  // Salon data
  final List<Map<String, dynamic>> _salons = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=400',
      'name': 'Aura Hair Studio',
      'distance': '1.2 km \u00b7 Colombo 07',
      'rating': 4.9,
      'reviewCount': 214,
      'darkTheme': false,
      'favorite': false,
      'services': <shop_detail.SpaService>[
        shop_detail.SpaService(
          name: 'Signature Cut & Blow Dry',
          subtitle: '60 mins · Precision styling',
          price: 120,
        ),
        shop_detail.SpaService(
          name: 'Keratin Smooth Treatment',
          subtitle: '120 mins · Frizz control',
          price: 180,
        ),
        shop_detail.SpaService(
          name: 'Luxury Scalp Spa',
          subtitle: '45 mins · Relaxing cleanse',
          price: 85,
        ),
      ],
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=400',
      'name': 'Lumi\u00e8re Salon & Spa',
      'distance': '0.8 km \u00b7 Bambalapitiya',
      'rating': 4.7,
      'reviewCount': 189,
      'darkTheme': true,
      'favorite': false,
      'services': <shop_detail.SpaService>[
        shop_detail.SpaService(
          name: 'Glow Facial Ritual',
          subtitle: '60 mins · Deep nourishment',
          price: 110,
        ),
        shop_detail.SpaService(
          name: 'Relaxing Back Massage',
          subtitle: '90 mins · Muscle release',
          price: 150,
        ),
        shop_detail.SpaService(
          name: 'Bridal Hair Styling',
          subtitle: '150 mins · Event ready',
          price: 220,
        ),
      ],
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=400',
      'name': 'Glamour Unisex Salon',
      'distance': '2.5 km \u00b7 Nugegoda',
      'rating': 4.8,
      'reviewCount': 156,
      'darkTheme': false,
      'favorite': false,
      'services': <shop_detail.SpaService>[
        shop_detail.SpaService(
          name: 'Men’s Classic Haircut',
          subtitle: '30 mins · Clean finish',
          price: 45,
        ),
        shop_detail.SpaService(
          name: 'Beard Trim & Shape',
          subtitle: '20 mins · Defined edges',
          price: 25,
        ),
        shop_detail.SpaService(
          name: 'Express Mani-Pedi',
          subtitle: '50 mins · Grooming combo',
          price: 70,
        ),
      ],
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1596178065887-1198b6148b2b?w=400',
      'name': 'Vogue Style Salon',
      'distance': '8.2 km \u00b7 Mount Lavinia',
      'rating': 3.8,
      'reviewCount': 92,
      'darkTheme': false,
      'favorite': false,
      'services': <shop_detail.SpaService>[
        shop_detail.SpaService(
          name: 'Classic Pedicure & Manicure',
          subtitle: '45 mins · Nail care',
          price: 900,
        ),
        shop_detail.SpaService(
          name: 'Smoothing Hair Spa',
          subtitle: '60 mins · Nourishing treatment',
          price: 1500,
        ),
      ],
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?w=400',
      'name': 'Royal Elite Spa',
      'distance': '3.5 km \u00b7 Colombo 03',
      'rating': 4.9,
      'reviewCount': 340,
      'darkTheme': true,
      'favorite': false,
      'services': <shop_detail.SpaService>[
        shop_detail.SpaService(
          name: 'Ultra Luxury Day Package',
          subtitle: '180 mins · Full body treatment',
          price: 2500,
        ),
        shop_detail.SpaService(
          name: 'Royal Caviar Facial',
          subtitle: '90 mins · Anti-aging ritual',
          price: 3000,
        ),
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    for (final salon in _salons) {
      salon['favorite'] = FavoriteSalonStore.isFavorite(
        salon['name'] as String,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                _buildRecommendedSection(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const LuxeBottomNav(currentIndex: 0),
      ),
    );
  }

  // ── Top Bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CustomerProfilePage(),
                    ),
                  ),
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
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
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
                ],
              ),
            ),
          ),
          const Spacer(),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap:
                  () => showSearch(
                    context: context,
                    delegate: _SalonSearchDelegate(),
                  ),
              child: Container(
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
            ),
          ),
          const SizedBox(width: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Stack(
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
          ),
        ],
      ),
    );
  }

  // ── Recommended Section ───────────────────────────────────────────────────
  Widget _buildRecommendedSection() {
    final salons = _filteredSalons;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          // Filter Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Explore Salons',
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Filter Button with Badge
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _showFilterBottomSheet(context),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _activeFilterCount > 0
                                  ? AppColors.gold.withOpacity(0.12)
                                  : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                _activeFilterCount > 0
                                    ? AppColors.gold.withOpacity(0.5)
                                    : AppColors.gold.withOpacity(0.15),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_list_rounded,
                              color:
                                  _activeFilterCount > 0
                                      ? AppColors.goldDim
                                      : AppColors.gold,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Filter',
                              style: TextStyle(
                                color:
                                    _activeFilterCount > 0
                                        ? AppColors.goldDim
                                        : AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_activeFilterCount > 0)
                        Positioned(
                          top: -6,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                '$_activeFilterCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Active filter chips row
          _buildActiveFilterChips(),
          const SizedBox(height: 12),
          // Salons List
          if (salons.isEmpty)
            _buildEmptyState()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: salons.length,
              itemBuilder: (context, index) {
                final salon = salons[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildSalonCard(
                    key: ValueKey(salon['imageUrl'] as String),
                    imageUrl: salon['imageUrl'] as String,
                    name: salon['name'] as String,
                    distance: salon['distance'] as String,
                    rating: salon['rating'] as double,
                    reviewCount: salon['reviewCount'] as int,
                    services: salon['services'] as List<shop_detail.SpaService>,
                    darkTheme: salon['darkTheme'] as bool,
                    isFavorite: salon['favorite'] as bool,
                    onFavoriteToggle: () {
                      setState(() {
                        // Toggle favorite inside original list
                        final origIndex = _salons.indexWhere(
                          (s) => s['name'] == salon['name'],
                        );
                        if (origIndex != -1) {
                          final newFavoriteState =
                              !(_salons[origIndex]['favorite'] as bool);
                          _salons[origIndex]['favorite'] = newFavoriteState;
                          FavoriteSalonStore.setFavorite(
                            FavoriteSalonEntry(
                              name: _salons[origIndex]['name'] as String,
                              imageUrl:
                                  _salons[origIndex]['imageUrl'] as String,
                              distance:
                                  _salons[origIndex]['distance'] as String,
                              rating: _salons[origIndex]['rating'] as double,
                              reviewCount:
                                  _salons[origIndex]['reviewCount'] as int,
                              darkTheme:
                                  _salons[origIndex]['darkTheme'] as bool,
                              services:
                                  _salons[origIndex]['services']
                                      as List<shop_detail.SpaService>,
                            ),
                            newFavoriteState,
                          );
                        }
                      });
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChips() {
    if (!_filtersApplied) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            _buildPlaceholderChip(
              'Service (Any)',
              Icons.face_retouching_natural_outlined,
              () => _showFilterBottomSheet(context),
            ),
            const SizedBox(width: 8),
            _buildPlaceholderChip(
              'Distance (Any)',
              Icons.directions_car_outlined,
              () => _showFilterBottomSheet(context),
            ),
            const SizedBox(width: 8),
            _buildPlaceholderChip(
              'Rating (Any)',
              Icons.star_border_rounded,
              () => _showFilterBottomSheet(context),
            ),
            const SizedBox(width: 8),
            _buildPlaceholderChip(
              'Price (Any)',
              Icons.payments_outlined,
              () => _showFilterBottomSheet(context),
            ),
          ],
        ),
      );
    }

    final List<Widget> chips = [];

    // Location chip
    if (_selectedLocation != 'Select Location') {
      chips.add(
        _buildActiveChip(
          label: 'Location: ${_selectedLocation.split(',').first.trim()}',
          onClear: () {
            setState(() {
              _selectedLocation = 'Select Location';
            });
          },
        ),
      );
    }

    // Service chip
    if (_selectedServiceType != 'All') {
      chips.add(
        _buildActiveChip(
          label: 'Service: $_selectedServiceType',
          onClear: () {
            setState(() {
              _selectedServiceType = 'All';
            });
          },
        ),
      );
    }

    // Distance chip
    if (_maxDistance < 10.0) {
      chips.add(
        _buildActiveChip(
          label: 'Distance: up to ${_maxDistance.toStringAsFixed(1)} km',
          onClear: () {
            setState(() {
              _maxDistance = 10.0;
            });
          },
        ),
      );
    }

    // Rating chip
    if (_minRating > 0.0) {
      chips.add(
        _buildActiveChip(
          label: 'Rating: ${_minRating.toStringAsFixed(1)}+ ★',
          onClear: () {
            setState(() {
              _minRating = 0.0;
            });
          },
        ),
      );
    }

    // Price chip
    if (_maxPrice < 2000.0) {
      chips.add(
        _buildActiveChip(
          label: 'Price: under Rs. ${_maxPrice.toInt()}',
          onClear: () {
            setState(() {
              _maxPrice = 2000.0;
            });
          },
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children:
            chips
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: c,
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildPlaceholderChip(
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold.withOpacity(0.15), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.gold.withOpacity(0.7)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.8),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveChip({
    required String label,
    required VoidCallback onClear,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gold.withOpacity(0.15),
            AppColors.gold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.goldDim,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onClear,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 10,
                color: AppColors.goldDim,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    // Create temporary draft variables copying the current filter state
    double tempMaxDistance = _filtersApplied ? _maxDistance : 10.0;
    double tempMinRating = _filtersApplied ? _minRating : 0.0;
    double tempMaxPrice = _filtersApplied ? _maxPrice : 2000.0;
    String tempSelectedServiceType =
        _filtersApplied ? _selectedServiceType : 'All';
    String tempSelectedLocation =
        _filtersApplied ? _selectedLocation : 'Select Location';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // Count of active filters in draft state (for the Clear All button visibility)
            int getTempActiveFilterCount() {
              int count = 0;
              if (tempMaxDistance < 10.0) count++;
              if (tempMinRating > 0.0) count++;
              if (tempMaxPrice < 2000.0) count++;
              if (tempSelectedServiceType != 'All') count++;
              if (tempSelectedLocation != 'Select Location') count++;
              return count;
            }

            // Live count of shops matching the DRAFT (temp) filter values
            int getPreviewCount() {
              return _salons.where((salon) {
                // 1. Distance filter
                final String distStr = salon['distance'] as String;
                final distMatch = RegExp(r'([\d.]+)\s*km').firstMatch(distStr);
                if (distMatch != null) {
                  final dist = double.tryParse(distMatch.group(1) ?? '') ?? 0.0;
                  if (dist > tempMaxDistance) return false;
                }
                // 2. Rating filter
                final rating = salon['rating'] as double;
                if (rating < tempMinRating) return false;
                // 3. Price filter
                final services =
                    salon['services'] as List<shop_detail.SpaService>;
                final hasMatchingPrice = services.any(
                  (s) => s.price <= tempMaxPrice,
                );
                if (!hasMatchingPrice) return false;
                // 4. Service type filter
                if (tempSelectedServiceType != 'All') {
                  final hasMatchingService = services.any((s) {
                    final name = s.name.toLowerCase();
                    final type = tempSelectedServiceType.toLowerCase();
                    if (type == 'haircut' &&
                        (name.contains('cut') ||
                            name.contains('trim') ||
                            name.contains('styling')))
                      return true;
                    if (type == 'facial' && name.contains('facial'))
                      return true;
                    if (type == 'spa/massage' &&
                        (name.contains('spa') ||
                            name.contains('massage') ||
                            name.contains('cleanse') ||
                            name.contains('pedi') ||
                            name.contains('mani')))
                      return true;
                    if (type == 'treatment' && name.contains('treatment'))
                      return true;
                    return false;
                  });
                  if (!hasMatchingService) return false;
                }
                // 5. Location filter
                if (tempSelectedLocation != 'Select Location') {
                  final area =
                      tempSelectedLocation
                          .split(',')
                          .first
                          .trim()
                          .toLowerCase();
                  final salonAddress = distStr.toLowerCase();
                  if (!salonAddress.contains(area)) return false;
                }
                return true;
              }).length;
            }

            return Container(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.inactive.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filter Salons',
                            style: GoogleFonts.outfit(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (getTempActiveFilterCount() > 0)
                            GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  tempMaxDistance = 10.0;
                                  tempMinRating = 0.0;
                                  tempMaxPrice = 2000.0;
                                  tempSelectedServiceType = 'All';
                                  tempSelectedLocation = 'Select Location';
                                });
                              },
                              child: Text(
                                'Clear All',
                                style: GoogleFonts.outfit(
                                  color: AppColors.error,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Location Selection Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Selected Location',
                            style: GoogleFonts.outfit(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.of(
                                context,
                              ).push<String>(
                                MaterialPageRoute(
                                  builder: (_) => const LocationPickerPage(),
                                ),
                              );
                              if (result != null) {
                                setModalState(() {
                                  tempSelectedLocation = result;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.gold.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: AppColors.gold,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    tempSelectedLocation
                                        .split(',')
                                        .first
                                        .trim(),
                                    style: GoogleFonts.outfit(
                                      color: AppColors.gold,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: AppColors.gold,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Service Type Category
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Service Category',
                        style: GoogleFonts.outfit(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          _buildServiceFilterChip(
                            service: 'All',
                            selectedService: tempSelectedServiceType,
                            onSelected: () {
                              setModalState(() {
                                tempSelectedServiceType = 'All';
                              });
                            },
                          ),
                          _buildServiceFilterChip(
                            service: 'Haircut',
                            selectedService: tempSelectedServiceType,
                            onSelected: () {
                              setModalState(() {
                                tempSelectedServiceType = 'Haircut';
                              });
                            },
                          ),
                          _buildServiceFilterChip(
                            service: 'Facial',
                            selectedService: tempSelectedServiceType,
                            onSelected: () {
                              setModalState(() {
                                tempSelectedServiceType = 'Facial';
                              });
                            },
                          ),
                          _buildServiceFilterChip(
                            service: 'Spa/Massage',
                            selectedService: tempSelectedServiceType,
                            onSelected: () {
                              setModalState(() {
                                tempSelectedServiceType = 'Spa/Massage';
                              });
                            },
                          ),
                          _buildServiceFilterChip(
                            service: 'Treatment',
                            selectedService: tempSelectedServiceType,
                            onSelected: () {
                              setModalState(() {
                                tempSelectedServiceType = 'Treatment';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Distance Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Distance Radius',
                            style: GoogleFonts.outfit(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            tempMaxDistance >= 10.0
                                ? 'Any distance'
                                : 'Within ${tempMaxDistance.toStringAsFixed(1)} km',
                            style: GoogleFonts.outfit(
                              color: AppColors.gold,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.gold,
                          inactiveTrackColor: AppColors.gold.withOpacity(0.12),
                          thumbColor: Colors.white,
                          overlayColor: AppColors.gold.withOpacity(0.12),
                          valueIndicatorColor: AppColors.gold,
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Slider(
                          value: tempMaxDistance,
                          min: 0.5,
                          max: 10.0,
                          divisions: 19,
                          label: '${tempMaxDistance.toStringAsFixed(1)} km',
                          onChanged: (val) {
                            setModalState(() {
                              tempMaxDistance = val;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Rating Chips
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Minimum Rating',
                        style: GoogleFonts.outfit(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildRatingChip(
                            rating: 0.0,
                            label: 'Any',
                            selectedRating: tempMinRating,
                            onSelected: () {
                              setModalState(() {
                                tempMinRating = 0.0;
                              });
                            },
                          ),
                          _buildRatingChip(
                            rating: 3.5,
                            label: '3.5+ ★',
                            selectedRating: tempMinRating,
                            onSelected: () {
                              setModalState(() {
                                tempMinRating = 3.5;
                              });
                            },
                          ),
                          _buildRatingChip(
                            rating: 4.5,
                            label: '4.5+ ★',
                            selectedRating: tempMinRating,
                            onSelected: () {
                              setModalState(() {
                                tempMinRating = 4.5;
                              });
                            },
                          ),
                          _buildRatingChip(
                            rating: 4.7,
                            label: '4.7+ ★',
                            selectedRating: tempMinRating,
                            onSelected: () {
                              setModalState(() {
                                tempMinRating = 4.7;
                              });
                            },
                          ),
                          _buildRatingChip(
                            rating: 4.8,
                            label: '4.8+ ★',
                            selectedRating: tempMinRating,
                            onSelected: () {
                              setModalState(() {
                                tempMinRating = 4.8;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Max Price Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Maximum Service Price',
                            style: GoogleFonts.outfit(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            tempMaxPrice >= 2000.0
                                ? 'Any price'
                                : 'Under Rs. ${tempMaxPrice.toInt()}',
                            style: GoogleFonts.outfit(
                              color: AppColors.gold,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.gold,
                          inactiveTrackColor: AppColors.gold.withOpacity(0.12),
                          thumbColor: Colors.white,
                          overlayColor: AppColors.gold.withOpacity(0.12),
                        ),
                        child: Slider(
                          value: tempMaxPrice,
                          min: 100,
                          max: 2000,
                          divisions: 19,
                          label: 'Rs. ${tempMaxPrice.toInt()}',
                          onChanged: (val) {
                            setModalState(() {
                              tempMaxPrice = val;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Live shop count preview
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder:
                              (child, animation) => FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                              ),
                          child: Container(
                            key: ValueKey(getPreviewCount()),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: AppColors.gold.withOpacity(0.25),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.storefront_outlined,
                                  size: 16,
                                  color: AppColors.gold,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${getPreviewCount()} ${getPreviewCount() == 1 ? 'shop' : 'shops'} available',
                                  style: GoogleFonts.outfit(
                                    color: AppColors.gold,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Apply Filters button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.gold.withOpacity(0.25),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Update the main filter state variables only when "Apply Filters" is pressed!
                                  setState(() {
                                    _filtersApplied = true;
                                    _maxDistance = tempMaxDistance;
                                    _minRating = tempMinRating;
                                    _maxPrice = tempMaxPrice;
                                    _selectedServiceType =
                                        tempSelectedServiceType;
                                    _selectedLocation = tempSelectedLocation;
                                  });
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  'Apply Filters',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildServiceFilterChip({
    required String service,
    required String selectedService,
    required VoidCallback onSelected,
  }) {
    final isSelected = selectedService == service;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          service,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.gold,
        backgroundColor: AppColors.chipUnselected,
        checkmarkColor: Colors.white,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (selected) => onSelected(),
      ),
    );
  }

  Widget _buildRatingChip({
    required double rating,
    required String label,
    required double selectedRating,
    required VoidCallback onSelected,
  }) {
    final isSelected = selectedRating == rating;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ChoiceChip(
          label: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          selected: isSelected,
          selectedColor: AppColors.gold,
          backgroundColor: AppColors.chipUnselected,
          checkmarkColor: Colors.white,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (selected) => onSelected(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: AppColors.error,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Salons Match Filters',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try widening your range or selecting different service categories to discover options.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _filtersApplied = false;
                _maxDistance = 10.0;
                _minRating = 0.0;
                _maxPrice = 2000.0;
                _selectedServiceType = 'All';
                _selectedLocation = 'Select Location';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Reset All Filters',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalonCard({
    Key? key,
    required String imageUrl,
    required String name,
    required String distance,
    required double rating,
    required int reviewCount,
    required List<shop_detail.SpaService> services,
    bool darkTheme = false,
    bool isFavorite = false,
    VoidCallback? onFavoriteToggle,
  }) {
    return Container(
      key: key,
      height: 135,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Thumbnail ──────────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(22),
                ),
                child: Image.network(
                  imageUrl,
                  width: 120,
                  height: 135,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        width: 120,
                        height: 135,
                        color: AppColors.surface,
                        child: const Center(
                          child: Icon(
                            Icons.content_cut,
                            color: AppColors.gold,
                            size: 32,
                          ),
                        ),
                      ),
                ),
              ),
              // Rating badge
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.gold,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '$rating',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($reviewCount)',
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(
                            alpha: 0.85,
                          ),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Favourite
              Positioned(
                top: 8,
                right: 8,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutBack,
                      scale: isFavorite ? 1.18 : 1.0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color:
                              isFavorite
                                  ? Colors.white
                                  : Colors.black.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isFavorite
                                    ? AppColors.pink.withValues(alpha: 0.2)
                                    : Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          boxShadow:
                              isFavorite
                                  ? [
                                    BoxShadow(
                                      color: AppColors.pink.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                  : [],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (child, animation) {
                            final curvedAnimation = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutBack,
                            );
                            return ScaleTransition(
                              scale: curvedAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            key: ValueKey<bool>(isFavorite),
                            color: isFavorite ? AppColors.pink : Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Info ───────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Distance & reviews
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.gold,
                          size: 10,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          distance,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Action buttons row
                  Row(
                    children: [
                      _buildCardIconBtn(
                        icon: Icons.design_services_outlined,
                        label: 'Services',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => shop_detail.SalonDetailPage(
                                    salonName: name,
                                    imageUrl: imageUrl,
                                    distance: distance,
                                    rating: rating,
                                    reviewCount: reviewCount,
                                    services: services,
                                  ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 6),
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
                      const Spacer(),
                      // BOOK button
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => const booking_page.BookingPage1(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'BOOK',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSalonItem({
    required Map<String, dynamic> salon,
    required int index,
    required Animation<double> animation,
  }) {
    final imageUrl = salon['imageUrl'] as String;
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildSalonCard(
          key: ValueKey(imageUrl),
          imageUrl: imageUrl,
          name: salon['name'] as String,
          distance: salon['distance'] as String,
          rating: salon['rating'] as double,
          reviewCount: salon['reviewCount'] as int,
          services: salon['services'] as List<shop_detail.SpaService>,
          darkTheme: salon['darkTheme'] as bool,
          isFavorite: salon['favorite'] as bool,
          onFavoriteToggle: () {
            setState(() {
              final newFavoriteState = !(_salons[index]['favorite'] as bool);
              _salons[index]['favorite'] = newFavoriteState;
              FavoriteSalonStore.setFavorite(
                FavoriteSalonEntry(
                  name: salon['name'] as String,
                  imageUrl: imageUrl,
                  distance: salon['distance'] as String,
                  rating: salon['rating'] as double,
                  reviewCount: salon['reviewCount'] as int,
                  darkTheme: salon['darkTheme'] as bool,
                  services: salon['services'] as List<shop_detail.SpaService>,
                ),
                newFavoriteState,
              );
            });
          },
        ),
      ),
    );
  }

  void _moveSalonToTop(int index) {
    if (index <= 0) {
      return;
    }
    final movedSalon = _salons[index];
    _salons.removeAt(index);
    _salons.insert(0, movedSalon);
    setState(() {});
  }

  // ── Small icon button for salon card ──────────────────────────────────────
  Widget _buildCardIconBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: -1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.gold, size: 16),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Salon Search Delegate ──────────────────────────────────────────────────
class _SalonSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, String>> _salons = const [
    {
      'name': 'Aura Hair Studio',
      'location': '1.2 km · Colombo 07',
      'image':
          'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=400',
    },
    {
      'name': 'Lumière Salon & Spa',
      'location': '0.8 km · Bambalapitiya',
      'image':
          'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=400',
    },
    {
      'name': 'Glamour Unisex Salon',
      'location': '2.5 km · Nugegoda',
      'image':
          'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=400',
    },
    {
      'name': 'Salon De Rose',
      'location': '3.1 km · Dehiwala',
      'image':
          'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?w=400',
    },
    {
      'name': 'The Grand Salon',
      'location': '1.8 km · Wellawatte',
      'image':
          'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?w=400',
    },
    {
      'name': 'Luxe Beauty Lounge',
      'location': '4.0 km · Mount Lavinia',
      'image':
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400',
    },
  ];

  @override
  String get searchFieldLabel => 'Search salons...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.gold),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 15),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.gold,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(
            Icons.clear,
            color: AppColors.textSecondary,
            size: 20,
          ),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final filtered =
        query.isEmpty
            ? _salons
            : _salons
                .where(
                  (s) => s['name']!.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

    return Container(
      color: AppColors.background,
      child:
          filtered.isEmpty
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_off,
                      color: AppColors.textSecondary,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No salons found for "$query"',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: filtered.length,
                separatorBuilder:
                    (_, __) => Divider(
                      color: AppColors.gold.withOpacity(0.12),
                      height: 1,
                    ),
                itemBuilder: (context, i) {
                  final salon = filtered[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        salon['image']!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.content_cut,
                                color: AppColors.gold,
                                size: 22,
                              ),
                            ),
                      ),
                    ),
                    title: Text(
                      salon['name']!,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.gold,
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          salon['location']!,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.gold,
                      size: 14,
                    ),
                    onTap: () => close(context, salon['name']!),
                  );
                },
              ),
    );
  }
}
