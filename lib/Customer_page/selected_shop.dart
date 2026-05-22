import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

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
  SpaService({
    required this.name,
    required this.subtitle,
    required this.price,
    this.added = false,
  });
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class SalonDetailPage extends StatefulWidget {
  final String salonName;
  final String imageUrl;
  final String distance;
  final double rating;
  final int reviewCount;
  final List<SpaService> services;

  const SalonDetailPage({
    super.key,
    required this.salonName,
    required this.imageUrl,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.services,
  });

  @override
  State<SalonDetailPage> createState() => _SalonDetailPageState();
}

class _SalonDetailPageState extends State<SalonDetailPage> {
  late final List<SpaService> _services;
  final List<Specialist> _specialists = const [
    Specialist('Diana', 'https://i.pravatar.cc/100?img=47'),
    Specialist('Marcus', 'https://i.pravatar.cc/100?img=60'),
    Specialist('Sofia', 'https://i.pravatar.cc/100?img=21'),
    Specialist('Julian', 'https://i.pravatar.cc/100?img=65'),
    Specialist('Aliara', 'https://i.pravatar.cc/100?img=25'),
  ];

  int get _total =>
      _services.where((s) => s.added).fold(0, (sum, s) => sum + s.price);
  int get _addedCount => _services.where((s) => s.added).length;

  @override
  void initState() {
    super.initState();
    _services =
        widget.services
            .map(
              (service) => SpaService(
                name: service.name,
                subtitle: service.subtitle,
                price: service.price,
                added: service.added,
              ),
            )
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.salonName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.distance,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${widget.rating.toStringAsFixed(1)} (${widget.reviewCount})',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(
                'Services',
                '${_addedCount > 0 ? _addedCount : _services.length} AVAILABLE',
              ),
              const SizedBox(height: 12),
              Expanded(child: _buildServiceGallery()),
            ],
          ),
        ),
      ),
    );
  }

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
        Text(
          widget.rating.toStringAsFixed(1),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '(${widget.reviewCount})',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
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
                  border: Border.all(
                    color: AppColors.gold.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    s.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          color: AppColors.surface,
                          child: const Icon(
                            Icons.person,
                            color: AppColors.gold,
                            size: 28,
                          ),
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

  // ── Service Gallery ──────────────────────────────────────────────────────────
  Widget _buildServiceGallery() {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _services.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final svc = _services[index];
          return _buildServiceCard(svc: svc, index: index);
        },
      ),
    );
  }

  Widget _buildServiceCard({required SpaService svc, required int index}) {
    final isSelected = svc.added;
    final accent =
        [
          AppColors.gold,
          AppColors.blue,
          AppColors.pink,
          AppColors.goldDim,
        ][index % 4];

    final icon =
        [
          Icons.spa,
          Icons.content_cut,
          Icons.auto_awesome,
          Icons.self_improvement,
        ][index % 4];

    return Container(
      width: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? accent : Colors.white,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.18),
                  accent.withValues(alpha: 0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            svc.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            svc.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              height: 1.35,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                'Rs ${svc.price}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => setState(() => svc.added = !svc.added),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isSelected ? accent : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? accent : AppColors.goldDim,
                        width: 1.4,
                      ),
                    ),
                    child: Icon(
                      isSelected ? Icons.check : Icons.add,
                      color: isSelected ? Colors.black : accent,
                      size: 18,
                    ),
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
