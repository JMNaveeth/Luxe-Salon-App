import 'package:flutter/material.dart';

void main() => runApp(const SalonApp());

class SalonApp extends StatelessWidget {
  const SalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salon Details',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Georgia',
      ),
      home: const SalonDetailPage(),
    );
  }
}

// ─── Palette ──────────────────────────────────────────────────────────────────
class AppColors {
  static const bg = Color(0xFF151510);
  static const surface = Color(0xFF1E1E15);
  static const card = Color(0xFF232318);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFE8C870);
  static const goldDim = Color(0xFF8A6A20);
  static const textPrimary = Color(0xFFF5EDD6);
  static const textSecondary = Color(0xFF907F5A);
  static const divider = Color(0xFF2A2A1E);
  static const btnBg = Color(0xFFD4A843);
}

// ─── Data Models ──────────────────────────────────────────────────────────────
class Specialist {
  final String name;
  final String imageUrl;
  const Specialist(this.name, this.imageUrl);
}

class SpaService {
  final String name;
  final String subtitle;
  final int price;
  bool added;
  SpaService({required this.name, required this.subtitle, required this.price, this.added = false});
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class SalonDetailPage extends StatefulWidget {
  const SalonDetailPage({super.key});

  @override
  State<SalonDetailPage> createState() => _SalonDetailPageState();
}

class _SalonDetailPageState extends State<SalonDetailPage> {
  final List<SpaService> _services = [
    SpaService(name: 'Signature Gold Facial', subtitle: '60 mins · Intensive therapy', price: 120),
    SpaService(name: 'Elite Hair Sculpting', subtitle: '120 mins · Master stylist', price: 89),
    SpaService(name: '24K Polish & Mani', subtitle: '45 mins · Luxury finish', price: 65),
    SpaService(name: 'Royal Thai Massage', subtitle: '90 mins · Deep tissue', price: 180),
  ];

  int get _total => _services.where((s) => s.added).fold(0, (sum, s) => sum + s.price);
  int get _addedCount => _services.where((s) => s.added).length;

  final List<Specialist> _specialists = const [
    Specialist('Diana', 'https://i.pravatar.cc/100?img=47'),
    Specialist('Marcus', 'https://i.pravatar.cc/100?img=60'),
    Specialist('Sofia', 'https://i.pravatar.cc/100?img=21'),
    Specialist('Julian', 'https://i.pravatar.cc/100?img=65'),
    Specialist('Aliara', 'https://i.pravatar.cc/100?img=25'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeroSliver(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 18),
                      _buildRatingRow(),
                      const SizedBox(height: 10),
                      _buildTitle(),
                      const SizedBox(height: 8),
                      _buildLocation(),
                      const SizedBox(height: 28),
                      _buildSectionHeader('Expert Specialists', 'VIEW TEAM'),
                      const SizedBox(height: 16),
                      _buildSpecialists(),
                      const SizedBox(height: 28),
                      _buildSectionHeader(
                        'Select Services',
                        '${_addedCount > 0 ? _addedCount : _services.length} AVAILABLE',
                      ),
                      const SizedBox(height: 12),
                      _buildServiceList(),
                      const SizedBox(height: 28),
                      _buildAboutSection(),
                      // Bottom padding so FAB doesn't overlap
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bottom bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  // ── Hero Image ───────────────────────────────────────────────────────────────
  Widget _buildHeroSliver() {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: AppColors.bg,
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite_border, color: Colors.white, size: 20),
        ),
      ],
      title: Column(
        children: [
          const Text(
            'Salon Details',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Text(
            'ELITE PARTNER',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1600334129128-685c5582fd35?w=800',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surface,
                child: const Center(
                  child: Icon(Icons.spa, color: AppColors.gold, size: 64),
                ),
              ),
            ),
            // Bottom gradient to blend into background
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.bg, Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Rating Row ───────────────────────────────────────────────────────────────
  Widget _buildRatingRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'TOP RATED',
            style: TextStyle(
              color: Colors.black,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.star, color: AppColors.gold, size: 16),
        const SizedBox(width: 4),
        const Text(
          '4.9',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 4),
        const Text(
          '(126)',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  // ── Title ────────────────────────────────────────────────────────────────────
  Widget _buildTitle() {
    return const Text(
      'The Gilded Touch',
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        height: 1.1,
      ),
    );
  }

  // ── Location ─────────────────────────────────────────────────────────────────
  Widget _buildLocation() {
    return Row(
      children: const [
        Icon(Icons.location_on_outlined, color: AppColors.gold, size: 15),
        SizedBox(width: 5),
        Text(
          '125 East 65th St, Upper East Side, NY',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  // ── Section Header ───────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, String action) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          action,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // ── Specialists ──────────────────────────────────────────────────────────────
  Widget _buildSpecialists() {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _specialists.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final s = _specialists[i];
          return Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold.withOpacity(0.5), width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    s.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.person, color: AppColors.gold, size: 28),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                s.name,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Service List ─────────────────────────────────────────────────────────────
  Widget _buildServiceList() {
    return Column(
      children: _services.asMap().entries.map((entry) {
        final i = entry.key;
        final svc = entry.value;
        return Column(
          children: [
            if (i != 0)
              Divider(color: AppColors.divider, height: 1),
            _buildServiceRow(svc),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildServiceRow(SpaService svc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  svc.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  svc.subtitle,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '\$${svc.price}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => setState(() => svc.added = !svc.added),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: svc.added ? AppColors.gold : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: svc.added ? AppColors.gold : AppColors.goldDim,
                  width: 1.5,
                ),
              ),
              child: Icon(
                svc.added ? Icons.check : Icons.add,
                color: svc.added ? Colors.black : AppColors.gold,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── About ────────────────────────────────────────────────────────────────────
  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'About',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Experience the pinnacle of New York luxury. Our therapists utilise gold-infused products and ancient techniques to provide a restorative experience that transcends the ordinary. Located in the heart of the Upper East Side, our sanctuary offers a private escape from the urban hustle.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            height: 1.65,
          ),
        ),
      ],
    );
  }

  // ── Bottom Bar ───────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'TOTAL ESTIMATE',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    '\$$_total',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    '/ session',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.btnBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'CONTINUE',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}