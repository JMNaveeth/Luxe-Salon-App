import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../booking pages/booking_page_1.dart' as booking_page;
import '../bottom_nav.dart';
import 'favorite_salons_store.dart';
import 'booking_history_page.dart';
import '../home page/selected_shop.dart' as shop_detail;
import '../../shop_owner_page/shop_gallery.dart';
import '../../theme/app_colors.dart';

// ─── Settings Item Model ──────────────────────────────────────────────────────
class SettingsItem {
  final IconData icon;
  final String label;
  final bool isToggle;
  final bool isDestructive;
  final VoidCallback? onTap;
  SettingsItem({
    required this.icon,
    required this.label,
    this.isToggle = false,
    this.isDestructive = false,
    this.onTap,
  });
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  bool _darkMode = false;
  int _selectedNav = 4; // PROFILE active
  File? _profileImage;
  String _userName = 'Alex Sterling';
  String _userEmail = 'alex.sterling@email.com';
  String _userPhone = '077 123 4567';

  void _openFavoriteSalonsPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const FavoriteSalonsPage()));
  }

  void _openBookingHistoryPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const BookingHistoryPage()));
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 800,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() => _profileImage = File(picked.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              source == ImageSource.camera
                  ? 'Camera is not available on this device'
                  : 'Could not open gallery',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _pickImageDesktop() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        setState(() => _profileImage = File(result.files.single.path!));
      }
    } catch (e) {
      debugPrint('File picker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open file picker: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showImageSourceSheet() {
    final isDesktop =
        Platform.isWindows || Platform.isMacOS || Platform.isLinux;

    // On desktop, use native file picker
    if (isDesktop) {
      _pickImageDesktop();
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textMuted,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Change Profile Photo',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: AppColors.gold,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      'Take Photo',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.photo_library,
                        color: AppColors.gold,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      'Choose from Gallery',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                  if (_profileImage != null)
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                      ),
                      title: const Text(
                        'Remove Photo',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() => _profileImage = null);
                      },
                    ),
                ],
              ),
            ),
          ),
    );
  }

  void _showEditProfileSheet() {
    final nameCtrl = TextEditingController(text: _userName);
    final emailCtrl = TextEditingController(text: _userEmail);
    final phoneCtrl = TextEditingController(text: _userPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 22),
                _editField(nameCtrl, 'Full Name', Icons.person_outline),
                const SizedBox(height: 14),
                _editField(
                  emailCtrl,
                  'Email Address',
                  Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                _editField(
                  phoneCtrl,
                  'Phone Number',
                  Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _userName = nameCtrl.text.trim();
                        _userEmail = emailCtrl.text.trim();
                        _userPhone = phoneCtrl.text.trim();
                      });
                      nameCtrl.dispose();
                      emailCtrl.dispose();
                      phoneCtrl.dispose();
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'SAVE CHANGES',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _editField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
      ),
    );
  }

  List<SettingsItem> get _generalSettings => [
    SettingsItem(icon: Icons.shield_outlined, label: 'Account Security'),
    SettingsItem(icon: Icons.credit_card_outlined, label: 'Payment Methods'),
    SettingsItem(
      icon: Icons.dark_mode_outlined,
      label: 'Dark Mode',
      isToggle: true,
    ),
    SettingsItem(icon: Icons.help_outline, label: 'Help & Support'),
  ];

  List<SettingsItem> get _accountSettings => [
    SettingsItem(
      icon: Icons.favorite_border,
      label: 'Favorite Salons',
      onTap: _openFavoriteSalonsPage,
    ),
    SettingsItem(
      icon: Icons.history,
      label: 'Booking History',
      onTap: _openBookingHistoryPage,
    ),
    SettingsItem(icon: Icons.star_outline, label: 'My Reviews'),
    SettingsItem(icon: Icons.logout, label: 'Log Out', isDestructive: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildProfileHeader(),
                    const SizedBox(height: 28),
                    _buildStatsRow(),
                    const SizedBox(height: 28),
                    _buildSection('GENERAL SETTINGS', _generalSettings),
                    const SizedBox(height: 24),
                    _buildSection('MY ACCOUNT', _accountSettings),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LuxeBottomNav(currentIndex: _selectedNav),
          ),
        ],
      ),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.bg,
      elevation: 0,

      title: const Text(
        'Profile',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.bold,
          fontFamily: 'Georgia',
        ),
      ),
      centerTitle: true,
      actions: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _showEditProfileSheet,
            child: Container(
              margin: const EdgeInsets.only(right: 14),
              child: const Icon(
                Icons.edit_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Profile Header ────────────────────────────────────────────────────────────
  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.gold.withOpacity(0.35),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.15),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              // Avatar
              ClipOval(
                child:
                    _profileImage != null
                        ? Image.file(
                          _profileImage!,
                          width: 92,
                          height: 92,
                          fit: BoxFit.cover,
                        )
                        : Image.network(
                          'https://i.pravatar.cc/200?img=60',
                          width: 92,
                          height: 92,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Container(
                                width: 92,
                                height: 92,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surface,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.gold,
                                  size: 46,
                                ),
                              ),
                        ),
              ),
              // Camera badge
              Positioned(
                bottom: 4,
                right: 4,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _showImageSourceSheet,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.bg, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                        size: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _userName,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.workspace_premium, color: AppColors.gold, size: 14),
              SizedBox(width: 5),
              Text(
                'PREMIUM MEMBER',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Stats Row ─────────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            _buildStatItem('28', 'Bookings'),
            _buildStatDivider(),
            _buildStatItem('2,450', 'LUXE Pts'),
            _buildStatDivider(),
            _buildStatItem('4.9', 'Avg Rating'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 36, color: AppColors.cardBorder);
  }

  // ── Settings Section ──────────────────────────────────────────────────────────
  Widget _buildSection(String title, List<SettingsItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: Column(
              children:
                  items.asMap().entries.map((e) {
                    final i = e.key;
                    final item = e.value;
                    return Column(
                      children: [
                        if (i != 0)
                          Divider(
                            height: 1,
                            color: AppColors.divider,
                            indent: 56,
                            endIndent: 16,
                          ),
                        _buildSettingsRow(item),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsRow(SettingsItem item) {
    final isDestructive = item.isDestructive;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (item.isToggle) {
            setState(() => _darkMode = !_darkMode);
          } else {
            item.onTap?.call();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color:
                      isDestructive
                          ? Colors.red.withOpacity(0.08)
                          : AppColors.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.icon,
                  color: isDestructive ? Colors.redAccent : AppColors.gold,
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    color:
                        isDestructive
                            ? Colors.redAccent
                            : AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (item.isToggle)
                _buildToggle(_darkMode)
              else
                Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggle(bool value) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () => setState(() => _darkMode = !_darkMode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 46,
          height: 26,
          decoration: BoxDecoration(
            color: value ? AppColors.toggleActive : AppColors.toggleInactive,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color:
                  value
                      ? AppColors.gold.withOpacity(0.5)
                      : AppColors.cardBorder,
              width: 1,
            ),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.all(3),
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FavoriteSalonsPage extends StatefulWidget {
  const FavoriteSalonsPage({super.key});

  @override
  State<FavoriteSalonsPage> createState() => _FavoriteSalonsPageState();
}

class _FavoriteSalonsPageState extends State<FavoriteSalonsPage> {
  @override
  Widget build(BuildContext context) {
    final favorites = FavoriteSalonStore.favorites;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          'Favorite Salons',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body:
          favorites.isEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.favorite_border,
                        size: 54,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No favorite salons yet',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Touch the heart on any salon card to add it here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(18),
                itemCount: favorites.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final salon = favorites[index];
                  return _FavoriteSalonCard(
                    salon: salon,
                    onFavoriteToggle: () {
                      setState(() {
                        FavoriteSalonStore.setFavorite(salon, false);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${salon.name} removed from favorites'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}

class _FavoriteSalonCard extends StatelessWidget {
  final FavoriteSalonEntry salon;
  final VoidCallback onFavoriteToggle;

  const _FavoriteSalonCard({
    required this.salon,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(22),
                ),
                child: Image.network(
                  salon.imageUrl,
                  width: 120,
                  height: 135,
                  fit: BoxFit.cover,
                ),
              ),
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
                        '${salon.rating}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${salon.reviewCount})',
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
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.pink.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: AppColors.pink,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon.name,
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
                          salon.distance,
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
                  Row(
                    children: [
                      _buildFavoriteCardButton(
                        icon: Icons.design_services_outlined,
                        label: 'Services',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => shop_detail.SalonDetailPage(
                                    salonName: salon.name,
                                    imageUrl: salon.imageUrl,
                                    distance: salon.distance,
                                    rating: salon.rating,
                                    reviewCount: salon.reviewCount,
                                    services: salon.services,
                                  ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 6),
                      _buildFavoriteCardButton(
                        icon: Icons.photo_library_outlined,
                        label: 'Gallery',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => ShopGalleryPage(shopName: salon.name),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => booking_page.BookingPage1(
                                      salonName: salon.name,
                                    ),
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

  Widget _buildFavoriteCardButton({
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
