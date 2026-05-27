import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import 'sh_ow_activty.dart';
import 'sh_ow_home.dart';
import 'shop_owner_bottom_nav.dart';
import 'shop_owner_management.dart';
import 'shop_owner_settings.dart';

// --- Data Model ---
class ServiceItem {
  final String name;
  final String price;
  final String duration;
  final Color avatarBg;
  bool isActive;
  String? imagePath;

  ServiceItem({
    required this.name,
    required this.price,
    required this.duration,
    required this.avatarBg,
    this.isActive = true,
    this.imagePath,
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
  final int _selectedNavIndex = 2;

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

  void _navigateToSection(int index) {
    if (index == _selectedNavIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = const DashboardPage();
        break;
      case 1:
        destination = const ActivityHistoryScreen();
        break;
      case 3:
        destination = const ShopOwnerSettingsScreen();
        break;
      default:
        destination = const ShopOwnerManagementScreen();
        break;
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute<void>(builder: (_) => destination));
  }

  Future<void> _showAddServiceDialog() async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final durationController = TextEditingController();
    String? selectedImagePath;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            Future<void> pickImage() async {
              final picker = ImagePicker();
              final result = await picker.pickImage(source: ImageSource.gallery);
              if (result != null) {
                setLocalState(() {
                  selectedImagePath = result.path;
                });
              }
            }

            return AlertDialog(
              backgroundColor: AppColors.card,
              title: const Text('Add New Service'),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.cardBorder, width: 1.5),
                          ),
                          child: selectedImagePath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(selectedImagePath!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: AppColors.divider,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.add_photo_alternate_outlined,
                                        color: AppColors.gold,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Upload Service Image',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Tap to browse gallery',
                                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Service name'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          hintText: 'e.g. Rs 100.00',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: durationController,
                        decoration: const InputDecoration(
                          labelText: 'Duration',
                          hintText: 'e.g. 60 MINS',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final price = priceController.text.trim();
                    final duration = durationController.text.trim();

                    if (name.isEmpty || price.isEmpty || duration.isEmpty) {
                      return;
                    }

                    setState(() {
                      _services.insert(
                        0,
                        ServiceItem(
                          name: name,
                          price: price,
                          duration: duration,
                          avatarBg: const Color(0xFF2A1E3A),
                          isActive: true,
                          imagePath: selectedImagePath,
                        ),
                      );
                    });

                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    priceController.dispose();
    durationController.dispose();
  }

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
                    _PortfolioOverviewCard(
                      totalServices: _services.length,
                      activeServices: _services.where((s) => s.isActive).length,
                      inactiveServices: _services.where((s) => !s.isActive).length,
                    ),

                    const SizedBox(height: 16),

                    // Add New Service Button
                    _AddNewServiceButton(onTap: _showAddServiceDialog),

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
            ShopOwnerBottomNav(
              selectedIndex: _selectedNavIndex,
              onTap: _navigateToSection,
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
  final int totalServices;
  final int activeServices;
  final int inactiveServices;

  const _PortfolioOverviewCard({
    required this.totalServices,
    required this.activeServices,
    required this.inactiveServices,
  });

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
              Text(
                '$totalServices',
                style: const TextStyle(
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
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.greenFaint,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: AppColors.green, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$activeServices',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.orangeFaint,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.remove_circle_outline, color: AppColors.orange, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'Not Active',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$inactiveServices',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.orange,
                        ),
                      ),
                    ],
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
  final VoidCallback onTap;

  const _AddNewServiceButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
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
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: service.avatarBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: service.imagePath != null && service.imagePath!.isNotEmpty
                  ? (service.imagePath!.startsWith('http')
                      ? Image.network(service.imagePath!, fit: BoxFit.cover)
                      : Image.file(File(service.imagePath!), fit: BoxFit.cover))
                  : const Icon(
                      Icons.person_outline,
                      color: AppColors.textMuted,
                      size: 28,
                    ),
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
