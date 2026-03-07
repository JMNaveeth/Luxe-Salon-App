import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ShopGalleryPage extends StatefulWidget {
  final String shopName;
  const ShopGalleryPage({super.key, required this.shopName});

  @override
  State<ShopGalleryPage> createState() => _ShopGalleryPageState();
}

class _ShopGalleryPageState extends State<ShopGalleryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _categories = [
    'All',
    'Haircuts',
    'Colour',
    'Facials',
    'Nails',
    'Interior',
  ];

  // Sample gallery images per category
  final Map<String, List<String>> _galleryImages = {
    'All': [
      'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=400',
      'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400',
      'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=400',
      'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=400',
      'https://images.unsplash.com/photo-1595476108010-b4d1f102b1b1?w=400',
      'https://images.unsplash.com/photo-1605497788044-5a32c7078486?w=400',
      'https://images.unsplash.com/photo-1516975080664-ed2fc6a32937?w=400',
      'https://images.unsplash.com/photo-1559599101-f09722fb4948?w=400',
      'https://images.unsplash.com/photo-1457972729786-0411a3b2b626?w=400',
    ],
    'Haircuts': [
      'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=400',
      'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=400',
      'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400',
    ],
    'Colour': [
      'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=400',
      'https://images.unsplash.com/photo-1595476108010-b4d1f102b1b1?w=400',
    ],
    'Facials': [
      'https://images.unsplash.com/photo-1516975080664-ed2fc6a32937?w=400',
      'https://images.unsplash.com/photo-1559599101-f09722fb4948?w=400',
    ],
    'Nails': [
      'https://images.unsplash.com/photo-1457972729786-0411a3b2b626?w=400',
      'https://images.unsplash.com/photo-1605497788044-5a32c7078486?w=400',
    ],
    'Interior': [
      'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=400',
      'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=400',
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.textPrimary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.shopName,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georgia',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Photo Gallery',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.gold.withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.photo_library_outlined,
                      color: AppColors.gold,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Category Tabs ─────────────────────────────────────
            TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppColors.gold,
              indicatorWeight: 2.5,
              labelColor: AppColors.gold,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              tabs: _categories.map((c) => Tab(text: c.toUpperCase())).toList(),
            ),

            const SizedBox(height: 12),

            // ── Photo Grid ────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children:
                    _categories.map((cat) {
                      final images = _galleryImages[cat] ?? [];
                      if (images.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.photo_outlined,
                                color: AppColors.textMuted,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No photos in $cat',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.85,
                            ),
                        itemCount: images.length,
                        itemBuilder:
                            (_, i) => _buildGalleryTile(images[i], cat, i),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryTile(String url, String category, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Full-screen image viewer
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => _FullImagePage(imageUrl: url, tag: '$category-$index'),
            ),
          );
        },
        child: Hero(
          tag: '$category-$index',
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.gold.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      color: AppColors.surface,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.textMuted,
                          size: 32,
                        ),
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Full-screen image viewer ──────────────────────────────────────────────────
class _FullImagePage extends StatelessWidget {
  final String imageUrl;
  final String tag;
  const _FullImagePage({required this.imageUrl, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Hero(
            tag: tag,
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder:
                    (_, __, ___) => const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white38,
                      size: 64,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
