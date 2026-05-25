import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';

enum GalleryMediaType { image, video }

class GalleryItem {
  final String source;
  final String category;
  final GalleryMediaType type;

  const GalleryItem({
    required this.source,
    required this.category,
    required this.type,
  });
}

class ShopGalleryPage extends StatefulWidget {
  final String shopName;
  final bool isOwnerMode;
  const ShopGalleryPage({
    super.key,
    required this.shopName,
    this.isOwnerMode = false,
  });

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
    'Videos',
  ];

  late List<GalleryItem> _items;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _items = [
      const GalleryItem(
        source:
            'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=400',
        category: 'Colour',
        type: GalleryMediaType.image,
      ),
      const GalleryItem(
        source:
            'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400',
        category: 'Haircuts',
        type: GalleryMediaType.image,
      ),
      const GalleryItem(
        source:
            'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=400',
        category: 'Interior',
        type: GalleryMediaType.image,
      ),
      const GalleryItem(
        source:
            'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=400',
        category: 'Haircuts',
        type: GalleryMediaType.image,
      ),
      const GalleryItem(
        source:
            'https://images.unsplash.com/photo-1595476108010-b4d1f102b1b1?w=400',
        category: 'Colour',
        type: GalleryMediaType.image,
      ),
      const GalleryItem(
        source:
            'https://images.unsplash.com/photo-1516975080664-ed2fc6a32937?w=400',
        category: 'Facials',
        type: GalleryMediaType.image,
      ),
      const GalleryItem(
        source:
            'https://images.unsplash.com/photo-1605497788044-5a32c7078486?w=400',
        category: 'Nails',
        type: GalleryMediaType.image,
      ),
      const GalleryItem(
        source:
            'https://images.unsplash.com/photo-1457972729786-0411a3b2b626?w=400',
        category: 'Nails',
        type: GalleryMediaType.image,
      ),
      const GalleryItem(
        source: 'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
        category: 'Videos',
        type: GalleryMediaType.video,
      ),
      const GalleryItem(
        source: 'https://samplelib.com/lib/preview/mp4/sample-10s.mp4',
        category: 'Videos',
        type: GalleryMediaType.video,
      ),
    ];
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

            if (widget.isOwnerMode)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _OwnerActionButton(
                        icon: Icons.add_photo_alternate_outlined,
                        label: 'Add Image',
                        onTap:
                            () =>
                                _showMediaDialog(type: GalleryMediaType.image),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _OwnerActionButton(
                        icon: Icons.video_library_outlined,
                        label: 'Add Video',
                        onTap:
                            () =>
                                _showMediaDialog(type: GalleryMediaType.video),
                      ),
                    ),
                  ],
                ),
              ),

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
                      final media = _itemsForCategory(cat);
                      if (media.isEmpty) {
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
                                'No media in $cat',
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
                        itemCount: media.length,
                        itemBuilder: (_, i) => _buildGalleryTile(media[i], i),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<GalleryItem> _itemsForCategory(String category) {
    if (category == 'All') return List<GalleryItem>.from(_items);
    if (category == 'Videos') {
      return _items
          .where((item) => item.type == GalleryMediaType.video)
          .toList();
    }
    return _items
        .where(
          (item) =>
              item.category == category && item.type == GalleryMediaType.image,
        )
        .toList();
  }

  void _showMediaDialog({
    required GalleryMediaType type,
    GalleryItem? existing,
  }) {
    final sourceController = TextEditingController(
      text: existing?.source ?? '',
    );
    // Build dropdown options for categories (exclude 'All' and 'Videos')
    final List<String> dropdownOptions =
        _categories.where((cat) => cat != 'All' && cat != 'Videos').toList();

    // Ensure selectedCategory is one of the available dropdown options to avoid
    // DropdownButton assertion failures when value isn't present in items.
    String selectedCategory = existing?.category ?? dropdownOptions.first;
    if (!dropdownOptions.contains(selectedCategory)) {
      selectedCategory = dropdownOptions.first;
    }

    XFile? pickedFile;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: Text(existing == null ? 'Add media' : 'Edit media'),
          content: StatefulBuilder(
            builder: (context, setLocalState) {
              Future<void> pickFromDevice() async {
                final picker = ImagePicker();
                XFile? result;
                if (type == GalleryMediaType.image) {
                  result = await picker.pickImage(source: ImageSource.gallery);
                } else {
                  result = await picker.pickVideo(source: ImageSource.gallery);
                }
                if (result != null) {
                  pickedFile = result;
                  setLocalState(() {});
                }
              }

              String? previewPath = pickedFile?.path ?? (existing?.source);

              return SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (previewPath != null && previewPath.isNotEmpty)
                      Container(
                        height: 140,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.surface,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              type == GalleryMediaType.image
                                  ? (previewPath.startsWith('http')
                                      ? Image.network(
                                        previewPath,
                                        fit: BoxFit.cover,
                                      )
                                      : Image.file(
                                        File(previewPath),
                                        fit: BoxFit.cover,
                                      ))
                                  : (previewPath.startsWith('http')
                                      ? Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF1C2238),
                                              Color(0xFF0F1322),
                                            ],
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.play_circle_fill_rounded,
                                            color: Colors.white,
                                            size: 54,
                                          ),
                                        ),
                                      )
                                      : Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF1C2238),
                                              Color(0xFF0F1322),
                                            ],
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.play_circle_fill_rounded,
                                            color: Colors.white,
                                            size: 54,
                                          ),
                                        ),
                                      )),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: pickFromDevice,
                            icon: const Icon(Icons.folder_open_outlined),
                            label: const Text('Choose from device'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedCategory,
                            items:
                                dropdownOptions
                                    .map(
                                      (cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setLocalState(() => selectedCategory = value);
                            },
                            decoration: const InputDecoration(
                              labelText: 'Category',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // prefer picked file over existing/source text
                // retrieve picked file from the StatefulBuilder by re-opening same logic
                // we can access the choices via the dialog's widget tree; simpler approach:
                // use ImagePicker again to pick if necessary
                // For simplicity, attempt to use the chosen file path from the UI state by
                // re-picking if no file was picked previously.
                // NOTE: the pick operation updated a local `pickedFile` inside the builder.
                // To keep this synchronous here, we'll trigger a fresh pick if no existing/source present.
                // First try: if existing has source and no new pick was done, use existing.source.

                final String? finalPath = pickedFile?.path ?? existing?.source;
                if (finalPath == null || finalPath.isEmpty) return;

                setState(() {
                  if (existing != null) {
                    _items.remove(existing);
                  }
                  _items.insert(
                    0,
                    GalleryItem(
                      source: finalPath!,
                      category:
                          selectedCategory == 'Videos'
                              ? 'Videos'
                              : selectedCategory,
                      type:
                          selectedCategory == 'Videos'
                              ? GalleryMediaType.video
                              : type,
                    ),
                  );
                });

                Navigator.of(dialogContext).pop();
              },
              child: Text(existing == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  void _removeMedia(GalleryItem item) {
    setState(() => _items.remove(item));
  }

  Future<void> _confirmDeleteMedia(GalleryItem item) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text('Delete media?'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      _removeMedia(item);
    }
  }

  Widget _buildGalleryTile(GalleryItem item, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => _FullMediaPage(
                    item: item,
                    tag: '${item.category}-$index',
                  ),
            ),
          );
        },
        child: Hero(
          tag: '${item.category}-$index',
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.gold.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child:
                      item.type == GalleryMediaType.image
                          ? (item.source.startsWith('http')
                              ? Image.network(
                                item.source,
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
                              )
                              : Image.file(
                                File(item.source),
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
                              ))
                          : Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF1C2238), Color(0xFF0F1322)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_fill_rounded,
                                color: Colors.white,
                                size: 54,
                              ),
                            ),
                          ),
                ),
                if (item.type == GalleryMediaType.video)
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'VIDEO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                if (widget.isOwnerMode)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Row(
                      children: [
                        _ActionIconButton(
                          icon: Icons.edit_outlined,
                          onTap:
                              () => _showMediaDialog(
                                type: item.type,
                                existing: item,
                              ),
                        ),
                        const SizedBox(width: 8),
                        _ActionIconButton(
                          icon: Icons.delete_outline,
                          onTap: () => _confirmDeleteMedia(item),
                        ),
                      ],
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

class _OwnerActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OwnerActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

// ── Full-screen media viewer ─────────────────────────────────────────────────
class _FullMediaPage extends StatelessWidget {
  final GalleryItem item;
  final String tag;
  const _FullMediaPage({required this.item, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Hero(
            tag: tag,
            child:
                item.type == GalleryMediaType.image
                    ? InteractiveViewer(
                      child:
                          item.source.startsWith('http')
                              ? Image.network(
                                item.source,
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (_, __, ___) => const Icon(
                                      Icons.broken_image_outlined,
                                      color: Colors.white38,
                                      size: 64,
                                    ),
                              )
                              : Image.file(
                                File(item.source),
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (_, __, ___) => const Icon(
                                      Icons.broken_image_outlined,
                                      color: Colors.white38,
                                      size: 64,
                                    ),
                              ),
                    )
                    : Container(
                      width: 320,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121826),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: 92,
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Video Preview',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.source,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
