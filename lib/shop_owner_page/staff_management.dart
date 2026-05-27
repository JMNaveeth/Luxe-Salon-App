import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import 'sh_ow_activty.dart';
import 'sh_ow_home.dart';
import 'shop_owner_bottom_nav.dart';
import 'shop_owner_management.dart';
import 'shop_owner_settings.dart';
import 'staff_profile.dart';

void main() {
  runApp(const SalonApp());
}

class SalonApp extends StatelessWidget {
  const SalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staff Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: AppColors.bg),
      home: const StaffManagementScreen(),
    );
  }
}

// --- Data Model ---
class StaffMember {
  final String name;
  final String role;
  final double rating;
  final String statusText;
  final bool isOnDuty;
  final Color avatarColor;
  final String? imagePath;

  const StaffMember({
    required this.name,
    required this.role,
    required this.rating,
    required this.statusText,
    required this.isOnDuty,
    required this.avatarColor,
    this.imagePath,
  });
}

// --- Main Screen ---
class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  final int _selectedNavIndex = 2;

  final List<StaffMember> _staff = [
    const StaffMember(
      name: 'Julian Harrison',
      role: 'Master Barber',
      rating: 4.9,
      statusText: '14 Bookings today',
      isOnDuty: true,
      avatarColor: Color(0xFFD4856A),
    ),
    const StaffMember(
      name: 'Elena Rodriguez',
      role: 'Senior Colorist',
      rating: 5.0,
      statusText: '8 Bookings today',
      isOnDuty: true,
      avatarColor: Color(0xFFC47A5A),
    ),
    const StaffMember(
      name: 'Marcus Thorne',
      role: 'Stylist Specialist',
      rating: 4.7,
      statusText: 'DAY OFF',
      isOnDuty: false,
      avatarColor: Color(0xFF8A9BAA),
    ),
    const StaffMember(
      name: 'Sophia Chen',
      role: 'Aesthetician',
      rating: 4.8,
      statusText: '6 Bookings today',
      isOnDuty: true,
      avatarColor: Color(0xFFD4A07A),
    ),
  ];

  Future<void> _showDeleteConfirmationDialog(int index) async {
    final member = _staff[index];
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text('Delete Staff Member'),
          content: Text(
            'Are you sure you want to permanently remove "${member.name}"?',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      setState(() {
        _staff.removeAt(index);
      });
    }
  }

  Future<void> _showEditStaffDialog(int index) async {
    final member = _staff[index];
    final nameController = TextEditingController(text: member.name);
    final statusController = TextEditingController(text: member.statusText);
    String selectedRole = member.role;
    bool isOnDuty = member.isOnDuty;
    String? selectedImagePath = member.imagePath;

    String? nameErrorText;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            Future<void> pickImage() async {
              final picker = ImagePicker();
              final result = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (result != null) {
                setLocalState(() {
                  selectedImagePath = result.path;
                });
              }
            }

            return AlertDialog(
              backgroundColor: AppColors.card,
              title: const Text('Edit Staff Member'),
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
                            border: Border.all(
                              color: AppColors.cardBorder,
                              width: 1.5,
                            ),
                          ),
                          child:
                              selectedImagePath != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child:
                                        selectedImagePath!.startsWith('http')
                                            ? Image.network(
                                              selectedImagePath!,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.file(
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
                                        'Upload Staff Photo',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Tap to browse gallery',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        onChanged: (val) {
                          if (nameErrorText != null) {
                            setLocalState(() {
                              nameErrorText = null;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Staff Name',
                          errorText: nameErrorText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        dropdownColor: AppColors.card,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Master Barber',
                            child: Text('Master Barber'),
                          ),
                          DropdownMenuItem(
                            value: 'Senior Colorist',
                            child: Text('Senior Colorist'),
                          ),
                          DropdownMenuItem(
                            value: 'Stylist Specialist',
                            child: Text('Stylist Specialist'),
                          ),
                          DropdownMenuItem(
                            value: 'Aesthetician',
                            child: Text('Aesthetician'),
                          ),
                          DropdownMenuItem(
                            value: 'Makeup Artist',
                            child: Text('Makeup Artist'),
                          ),
                          DropdownMenuItem(
                            value: 'Receptionist',
                            child: Text('Receptionist'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setLocalState(() {
                              selectedRole = val;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: statusController,
                        decoration: const InputDecoration(
                          labelText: 'Status Message',
                          hintText: 'e.g. 14 Bookings today, Day Off',
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text(
                          'On Duty Today',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        value: isOnDuty,
                        activeColor: AppColors.gold,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (val) {
                          setLocalState(() {
                            isOnDuty = val;
                          });
                        },
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
                    final statusText = statusController.text.trim();

                    if (name.isEmpty) {
                      setLocalState(() {
                        nameErrorText = 'Staff name cannot be empty';
                      });
                      return;
                    }

                    setState(() {
                      _staff[index] = StaffMember(
                        name: name,
                        role: selectedRole,
                        rating: member.rating,
                        statusText:
                            statusText.isNotEmpty
                                ? statusText
                                : (isOnDuty ? 'Available today' : 'DAY OFF'),
                        isOnDuty: isOnDuty,
                        avatarColor: member.avatarColor,
                        imagePath: selectedImagePath,
                      );
                    });

                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    statusController.dispose();
  }

  Future<void> _showAddStaffDialog() async {
    final nameController = TextEditingController();
    final statusController = TextEditingController();
    String selectedRole = 'Master Barber';
    bool isOnDuty = true;
    String? selectedImagePath;

    String? nameErrorText;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            Future<void> pickImage() async {
              final picker = ImagePicker();
              final result = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (result != null) {
                setLocalState(() {
                  selectedImagePath = result.path;
                });
              }
            }

            return AlertDialog(
              backgroundColor: AppColors.card,
              title: const Text('Add New Staff'),
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
                            border: Border.all(
                              color: AppColors.cardBorder,
                              width: 1.5,
                            ),
                          ),
                          child:
                              selectedImagePath != null
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
                                        'Upload Staff Photo',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Tap to browse gallery',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        onChanged: (val) {
                          if (nameErrorText != null) {
                            setLocalState(() {
                              nameErrorText = null;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Staff Name',
                          errorText: nameErrorText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        dropdownColor: AppColors.card,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Master Barber',
                            child: Text('Master Barber'),
                          ),
                          DropdownMenuItem(
                            value: 'Senior Colorist',
                            child: Text('Senior Colorist'),
                          ),
                          DropdownMenuItem(
                            value: 'Stylist Specialist',
                            child: Text('Stylist Specialist'),
                          ),
                          DropdownMenuItem(
                            value: 'Aesthetician',
                            child: Text('Aesthetician'),
                          ),
                          DropdownMenuItem(
                            value: 'Makeup Artist',
                            child: Text('Makeup Artist'),
                          ),
                          DropdownMenuItem(
                            value: 'Receptionist',
                            child: Text('Receptionist'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setLocalState(() {
                              selectedRole = val;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: statusController,
                        decoration: const InputDecoration(
                          labelText: 'Status Message',
                          hintText: 'e.g. 14 Bookings today, Day Off',
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text(
                          'On Duty Today',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        value: isOnDuty,
                        activeColor: AppColors.gold,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (val) {
                          setLocalState(() {
                            isOnDuty = val;
                          });
                        },
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
                    final statusText = statusController.text.trim();

                    if (name.isEmpty) {
                      setLocalState(() {
                        nameErrorText = 'Staff name cannot be empty';
                      });
                      return;
                    }

                    // Predefined avatar color palettes
                    final avatarColors = [
                      const Color(0xFFD4856A),
                      const Color(0xFFC47A5A),
                      const Color(0xFFD4A07A),
                      const Color(0xFF8A9BAA),
                    ];
                    final assignedColor =
                        avatarColors[_staff.length % avatarColors.length];

                    setState(() {
                      _staff.insert(
                        0,
                        StaffMember(
                          name: name,
                          role: selectedRole,
                          rating: 5.0,
                          statusText:
                              statusText.isNotEmpty
                                  ? statusText
                                  : (isOnDuty ? 'Available today' : 'DAY OFF'),
                          isOnDuty: isOnDuty,
                          avatarColor: assignedColor,
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
    statusController.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final onDutyCount = _staff.where((s) => s.isOnDuty).length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Header
                    _Header(),

                    const SizedBox(height: 20),

                    // Stats Row
                    _StatsRow(totalStaff: _staff.length, onDuty: onDutyCount),

                    const SizedBox(height: 20),

                    // Add New Staff Button
                    _AddStaffButton(onTap: _showAddStaffDialog),

                    const SizedBox(height: 20),

                    // Staff Cards
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _staff.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder:
                          (context, index) => _StaffCard(
                            member: _staff[index],
                            onEdit: () => _showEditStaffDialog(index),
                            onDelete:
                                () => _showDeleteConfirmationDialog(index),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder:
                                      (_) => StaffProfileScreen(
                                        member: _staff[index],
                                        onMemberUpdated: (updated) {
                                          setState(() {
                                            _staff[index] = updated;
                                          });
                                        },
                                      ),
                                ),
                              );
                            },
                          ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Nav
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

// --- Header ---
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
              'STAFF MANAGEMENT',
              style: TextStyle(
                fontSize: 13,
                letterSpacing: 2.5,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 38, height: 38),
      ],
    );
  }
}

// --- Add Staff Button ---
class _AddStaffButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddStaffButton({required this.onTap});

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
              Icon(Icons.person_add_outlined, color: AppColors.bg, size: 18),
              SizedBox(width: 8),
              Text(
                'ADD NEW STAFF',
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

// --- Stats Row ---
class _StatsRow extends StatelessWidget {
  final int totalStaff;
  final int onDuty;

  const _StatsRow({required this.totalStaff, required this.onDuty});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(label: 'TOTAL STAFF', value: totalStaff.toString()),
        ),
        const SizedBox(width: 12),
        Expanded(child: _StatBox(label: 'ON DUTY', value: onDuty.toString())),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              letterSpacing: 1.5,
              color: Color(0xFF606888),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontFamily: 'Georgia',
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Staff Card ---
class _StaffCard extends StatelessWidget {
  final StaffMember member;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _StaffCard({
    required this.member,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            // Top section: avatar + info + menu
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: member.avatarColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: member.avatarColor.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          member.imagePath != null &&
                                  member.imagePath!.isNotEmpty
                              ? (member.imagePath!.startsWith('http')
                                  ? Image.network(
                                    member.imagePath!,
                                    fit: BoxFit.cover,
                                  )
                                  : Image.file(
                                    File(member.imagePath!),
                                    fit: BoxFit.cover,
                                  ))
                              : Center(
                                child: Text(
                                  member.name.substring(0, 1),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: member.avatarColor,
                                    fontFamily: 'Georgia',
                                  ),
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name + role + rating
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          member.role,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Status dot
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color:
                                    member.isOnDuty
                                        ? AppColors.green
                                        : AppColors.textMuted,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),

                            // Rating
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.gold,
                              size: 12,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              member.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.gold,
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Divider
                            Container(
                              width: 1,
                              height: 10,
                              color: AppColors.cardBorder,
                            ),
                            const SizedBox(width: 8),

                            // Booking / status text
                            Icon(
                              member.isOnDuty
                                  ? Icons.calendar_today_outlined
                                  : Icons.wb_sunny_outlined,
                              size: 11,
                              color:
                                  member.isOnDuty
                                      ? AppColors.textSecondary
                                      : AppColors.gold,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              member.statusText,
                              style: TextStyle(
                                fontSize: 11,
                                color:
                                    member.isOnDuty
                                        ? AppColors.textSecondary
                                        : AppColors.gold,
                                fontWeight:
                                    member.isOnDuty
                                        ? FontWeight.w400
                                        : FontWeight.w700,
                                letterSpacing: member.isOnDuty ? 0 : 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 3-dot menu
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_horiz,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    color: AppColors.surface,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: AppColors.cardBorder,
                        width: 1,
                      ),
                    ),
                      onSelected: (value) {
                        if (value == 'delete') {
                          onDelete();
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: AppColors.red,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                  ),
                ],
              ),
            ),

            // View Profile Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'VIEW PROFILE',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gold,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.chevron_right,
                        size: 14,
                        color: AppColors.gold,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ); // Material
  }
}
