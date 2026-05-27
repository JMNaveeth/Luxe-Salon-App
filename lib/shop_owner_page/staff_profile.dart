import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import 'staff_management.dart';

// ─── Mutable Data Models ───────────────────────────────────────────────────────

class ScheduleEntry {
  String day;
  String startTime;
  String endTime;
  bool isOff;

  ScheduleEntry({
    required this.day,
    required this.startTime,
    required this.endTime,
    this.isOff = false,
  });

  ScheduleEntry copyWith({
    String? startTime,
    String? endTime,
    bool? isOff,
  }) {
    return ScheduleEntry(
      day: day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isOff: isOff ?? this.isOff,
    );
  }
}

class BookingRecord {
  final String clientName;
  final String clientInitial;
  final String service;
  final String date;
  final String time;
  String status; // mutable — owner can cancel upcoming
  final double amount;

  BookingRecord({
    required this.clientName,
    required this.clientInitial,
    required this.service,
    required this.date,
    required this.time,
    required this.status,
    required this.amount,
  });
}

// ─── All Available Specialties Pool ───────────────────────────────────────────

const List<Map<String, dynamic>> kAllSpecialties = [
  {'name': 'Haircut & Style',    'icon': Icons.content_cut,          'color': Color(0xFF4F8CFF)},
  {'name': 'Hair Coloring',      'icon': Icons.palette_outlined,      'color': Color(0xFF7C6CFF)},
  {'name': 'Deep Conditioning',  'icon': Icons.spa_outlined,          'color': Color(0xFF2BB673)},
  {'name': 'Keratin Treatment',  'icon': Icons.auto_awesome_outlined, 'color': Color(0xFFFFA44D)},
  {'name': 'Blowout & Finish',   'icon': Icons.air_outlined,          'color': Color(0xFFFF4FA3)},
  {'name': 'Balayage',           'icon': Icons.brush_outlined,        'color': Color(0xFFFF5C6F)},
  {'name': 'Beard Grooming',     'icon': Icons.face_outlined,         'color': Color(0xFF4F8CFF)},
  {'name': 'Scalp Treatment',    'icon': Icons.healing_outlined,      'color': Color(0xFF2BB673)},
  {'name': 'Highlights',         'icon': Icons.light_mode_outlined,   'color': Color(0xFFFFA44D)},
  {'name': 'Makeup & Glam',      'icon': Icons.face_retouching_natural_outlined, 'color': Color(0xFFFF4FA3)},
  {'name': 'Nail Art',           'icon': Icons.back_hand_outlined,    'color': Color(0xFF7C6CFF)},
  {'name': 'Waxing',             'icon': Icons.water_drop_outlined,   'color': Color(0xFFFF5C6F)},
];

// ─── Staff Profile Screen ─────────────────────────────────────────────────────

class StaffProfileScreen extends StatefulWidget {
  final StaffMember member;
  final Function(StaffMember)? onMemberUpdated;

  const StaffProfileScreen({
    super.key,
    required this.member,
    this.onMemberUpdated,
  });

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ── Edit mode flag ──
  bool _isEditing = false;

  // ── Editable personal info ──
  late TextEditingController _nameController;
  late String _selectedRole;
  late bool _isOnDuty;
  String? _imagePath;

  // ── Schedule ──
  late List<ScheduleEntry> _schedule;

  // ── Specialties: names of currently selected ──
  late List<String> _selectedSpecialtyNames;

  // ── Bookings ──
  late List<BookingRecord> _bookings;

  // ── Roles list ──
  static const List<String> _roles = [
    'Master Barber',
    'Senior Colorist',
    'Stylist Specialist',
    'Aesthetician',
    'Makeup Artist',
    'Receptionist',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _nameController = TextEditingController(text: widget.member.name);
    _selectedRole   = widget.member.role;
    _isOnDuty       = widget.member.isOnDuty;
    _imagePath      = widget.member.imagePath;

    _schedule = [
      ScheduleEntry(day: 'MON', startTime: '09:00 AM', endTime: '06:00 PM'),
      ScheduleEntry(day: 'TUE', startTime: '09:00 AM', endTime: '06:00 PM'),
      ScheduleEntry(day: 'WED', startTime: '10:00 AM', endTime: '07:00 PM'),
      ScheduleEntry(day: 'THU', startTime: '09:00 AM', endTime: '06:00 PM'),
      ScheduleEntry(day: 'FRI', startTime: '09:00 AM', endTime: '08:00 PM'),
      ScheduleEntry(day: 'SAT', startTime: '10:00 AM', endTime: '05:00 PM'),
      ScheduleEntry(day: 'SUN', startTime: '', endTime: '', isOff: true),
    ];

    _selectedSpecialtyNames = [
      'Haircut & Style',
      'Hair Coloring',
      'Deep Conditioning',
      'Keratin Treatment',
      'Blowout & Finish',
      'Balayage',
    ];

    _bookings = [
      BookingRecord(clientName: 'Aisha Patel',   clientInitial: 'A', service: 'Hair Coloring',    date: 'Today',     time: '10:30 AM', status: 'upcoming',  amount: 2800),
      BookingRecord(clientName: 'Rahul Mehta',   clientInitial: 'R', service: 'Haircut & Style',  date: 'Today',     time: '12:00 PM', status: 'upcoming',  amount: 650),
      BookingRecord(clientName: 'Sneha Iyer',    clientInitial: 'S', service: 'Keratin Treatment',date: 'Yesterday', time: '03:00 PM', status: 'completed', amount: 4500),
      BookingRecord(clientName: 'Priya Kapoor',  clientInitial: 'P', service: 'Balayage',         date: 'May 25',    time: '11:00 AM', status: 'completed', amount: 5200),
      BookingRecord(clientName: 'Nisha Roy',     clientInitial: 'N', service: 'Deep Conditioning',date: 'May 24',    time: '02:30 PM', status: 'completed', amount: 1200),
      BookingRecord(clientName: 'Ankit Singh',   clientInitial: 'A', service: 'Blowout & Finish', date: 'May 23',    time: '04:00 PM', status: 'cancelled', amount: 900),
      BookingRecord(clientName: 'Divya Nair',    clientInitial: 'D', service: 'Hair Coloring',    date: 'May 22',    time: '10:00 AM', status: 'completed', amount: 3100),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // ── Toggle edit mode ──
  void _toggleEdit() {
    if (_isEditing) {
      _saveChanges();
    } else {
      setState(() => _isEditing = true);
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _nameController.text = widget.member.name;
      _selectedRole = widget.member.role;
      _isOnDuty     = widget.member.isOnDuty;
      _imagePath    = widget.member.imagePath;
    });
  }

  void _saveChanges() {
    final name = _nameController.text.trim();
    final updated = StaffMember(
      name:       name.isEmpty ? widget.member.name : name,
      role:       _selectedRole,
      rating:     widget.member.rating,
      statusText: _isOnDuty ? 'Available today' : 'DAY OFF',
      isOnDuty:   _isOnDuty,
      avatarColor: widget.member.avatarColor,
      imagePath:  _imagePath,
    );
    widget.onMemberUpdated?.call(updated);
    setState(() => _isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: AppColors.white, size: 18),
            SizedBox(width: 8),
            Text('Profile saved successfully', style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Image picker ──
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() => _imagePath = result.path);
    }
  }

  // ── Time picker for schedule ──
  Future<void> _pickTime(int index, bool isStart) async {
    final entry = _schedule[index];
    final parts = (isStart ? entry.startTime : entry.endTime).split(RegExp(r'[ :]'));
    int hour   = int.tryParse(parts[0]) ?? 9;
    final min  = int.tryParse(parts[1]) ?? 0;
    final isPm = parts.length > 2 && parts[2] == 'PM';
    if (isPm && hour != 12) hour += 12;
    if (!isPm && hour == 12) hour = 0;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: min),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.gold,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      final formatted = picked.format(context);
      setState(() {
        if (isStart) {
          _schedule[index] = _schedule[index].copyWith(startTime: formatted);
        } else {
          _schedule[index] = _schedule[index].copyWith(endTime: formatted);
        }
      });
    }
  }

  // ── Specialties dialog (add) ──
  void _showAddSpecialtyDialog() {
    final unselected = kAllSpecialties
        .where((s) => !_selectedSpecialtyNames.contains(s['name'] as String))
        .toList();

    if (unselected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All specialties already added!')),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'ADD SPECIALTY',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            ...unselected.map((sp) {
              final Color color = sp['color'] as Color;
              return ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(sp['icon'] as IconData, size: 18, color: color),
                ),
                title: Text(
                  sp['name'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                trailing: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.goldFaint,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, size: 16, color: AppColors.gold),
                ),
                onTap: () {
                  setState(() {
                    _selectedSpecialtyNames.add(sp['name'] as String);
                  });
                  Navigator.pop(ctx);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  // ── Cancel booking confirmation ──
  Future<void> _cancelBooking(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Cancel Booking?'),
        content: Text(
          'Cancel booking for ${_bookings[index].clientName} at ${_bookings[index].time}?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _bookings[index].status = 'cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> activeSpecialties = kAllSpecialties
        .where((s) => _selectedSpecialtyNames.contains(s['name'] as String))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: _isEditing ? 310 : 270,
            pinned: true,
            backgroundColor: AppColors.bg,
            elevation: 0,
            leading: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Icon(Icons.chevron_left, color: AppColors.gold, size: 22),
                ),
              ),
            ),
            title: AnimatedOpacity(
              opacity: innerBoxIsScrolled ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                _isEditing ? 'Editing Profile' : widget.member.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            actions: [
              if (_isEditing) ...[
                // Cancel edit
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _cancelEdit,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                // Save
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _saveChanges,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 8, 12, 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.gold, AppColors.goldDim],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check, size: 14, color: AppColors.white),
                          SizedBox(width: 4),
                          Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Edit button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: _toggleEdit,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 8, 12, 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.goldFaint,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 14, color: AppColors.gold),
                          SizedBox(width: 5),
                          Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _HeroSection(
                nameController: _nameController,
                selectedRole: _selectedRole,
                isOnDuty: _isOnDuty,
                imagePath: _imagePath,
                member: widget.member,
                isEditing: _isEditing,
                onPickImage: _pickImage,
                onRoleChanged: (r) => setState(() => _selectedRole = r),
                onDutyChanged: (v) => setState(() => _isOnDuty = v),
                roles: _roles,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: AppColors.bg,
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.gold,
                  unselectedLabelColor: AppColors.textMuted,
                  indicatorColor: AppColors.gold,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 2.5,
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                  unselectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2),
                  tabs: const [
                    Tab(text: 'SCHEDULE'),
                    Tab(text: 'SPECIALTIES'),
                    Tab(text: 'BOOKINGS'),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // ── Tab 1: Schedule ──
            _ScheduleTab(
              schedule: _schedule,
              isEditing: _isEditing,
              onToggleOff: (i, val) => setState(() => _schedule[i] = _schedule[i].copyWith(isOff: val)),
              onPickTime: _pickTime,
            ),

            // ── Tab 2: Specialties ──
            _SpecialtiesTab(
              activeSpecialties: activeSpecialties,
              isEditing: _isEditing,
              onRemove: (name) => setState(() => _selectedSpecialtyNames.remove(name)),
              onAdd: _showAddSpecialtyDialog,
            ),

            // ── Tab 3: Bookings ──
            _BookingsTab(
              bookings: _bookings,
              isEditing: _isEditing,
              onCancelBooking: _cancelBooking,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final TextEditingController nameController;
  final String selectedRole;
  final bool isOnDuty;
  final String? imagePath;
  final StaffMember member;
  final bool isEditing;
  final VoidCallback onPickImage;
  final ValueChanged<String> onRoleChanged;
  final ValueChanged<bool> onDutyChanged;
  final List<String> roles;

  const _HeroSection({
    required this.nameController,
    required this.selectedRole,
    required this.isOnDuty,
    required this.imagePath,
    required this.member,
    required this.isEditing,
    required this.onPickImage,
    required this.onRoleChanged,
    required this.onDutyChanged,
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.fromLTRB(20, 86, 20, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // ── Edit banner ──
          if (isEditing) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.goldFaint,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Row(
                children: [
                  Icon(Icons.edit_note_outlined, size: 16, color: AppColors.gold),
                  SizedBox(width: 8),
                  Text(
                    'Editing mode — tap fields to update, then press Save.',
                    style: TextStyle(fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // ── Avatar / Photo picker ──
              GestureDetector(
                onTap: isEditing ? onPickImage : null,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: member.avatarColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isEditing
                              ? AppColors.gold
                              : member.avatarColor.withOpacity(0.4),
                          width: isEditing ? 2.5 : 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: member.avatarColor.withOpacity(0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: imagePath != null && imagePath!.isNotEmpty
                            ? (imagePath!.startsWith('http')
                                ? Image.network(imagePath!, fit: BoxFit.cover)
                                : Image.file(File(imagePath!), fit: BoxFit.cover))
                            : Center(
                                child: Text(
                                  member.name.substring(0, 1),
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: member.avatarColor,
                                    fontFamily: 'Georgia',
                                  ),
                                ),
                              ),
                      ),
                    ),

                    // On-duty indicator
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: isOnDuty ? AppColors.green : AppColors.textMuted,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.bg, width: 2.5),
                        ),
                      ),
                    ),

                    // Camera overlay in edit mode
                    if (isEditing)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.bg, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, size: 12, color: AppColors.white),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // ── Name / Role / Duty ──
              Expanded(
                child: isEditing
                    ? _EditablePersonalInfo(
                        nameController: nameController,
                        selectedRole: selectedRole,
                        isOnDuty: isOnDuty,
                        roles: roles,
                        onRoleChanged: onRoleChanged,
                        onDutyChanged: onDutyChanged,
                      )
                    : _StaticPersonalInfo(member: member),
              ),

              const SizedBox(width: 8),

              // ── Rating badge ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.goldFaint,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.gold, size: 18),
                    const SizedBox(height: 2),
                    Text(
                      member.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.gold,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const Text(
                      'RATING',
                      style: TextStyle(fontSize: 8, letterSpacing: 1, fontWeight: FontWeight.w700, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Quick Stats ──
          Row(
            children: [
              _QuickStat(value: '14',    sub: 'today'),
              _divider(),
              _QuickStat(value: '62',    sub: 'this week'),
              _divider(),
              _QuickStat(value: '1,248', sub: 'all time'),
              _divider(),
              _QuickStat(value: '₹84K',  sub: 'revenue'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1, height: 32, color: AppColors.cardBorder,
        margin: const EdgeInsets.symmetric(horizontal: 8),
      );
}

class _StaticPersonalInfo extends StatelessWidget {
  final StaffMember member;
  const _StaticPersonalInfo({required this.member});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          member.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontFamily: 'Georgia',
            height: 1.1,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          member.role,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: member.isOnDuty ? AppColors.greenFaint : AppColors.cardBorder,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6, height: 6,
                decoration: BoxDecoration(
                  color: member.isOnDuty ? AppColors.green : AppColors.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                member.isOnDuty ? 'On Duty' : 'Day Off',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: member.isOnDuty ? AppColors.green : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditablePersonalInfo extends StatelessWidget {
  final TextEditingController nameController;
  final String selectedRole;
  final bool isOnDuty;
  final List<String> roles;
  final ValueChanged<String> onRoleChanged;
  final ValueChanged<bool> onDutyChanged;

  const _EditablePersonalInfo({
    required this.nameController,
    required this.selectedRole,
    required this.isOnDuty,
    required this.roles,
    required this.onRoleChanged,
    required this.onDutyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name field
        TextField(
          controller: nameController,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontFamily: 'Georgia',
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            filled: true,
            fillColor: AppColors.surface,
            hintText: 'Staff Name',
            hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
            ),
          ),
        ),

        const SizedBox(height: 6),

        // Role dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedRole,
              isDense: true,
              isExpanded: true,
              dropdownColor: AppColors.card,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (v) { if (v != null) onRoleChanged(v); },
            ),
          ),
        ),

        const SizedBox(height: 6),

        // On-duty toggle
        GestureDetector(
          onTap: () => onDutyChanged(!isOnDuty),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isOnDuty ? AppColors.greenFaint : AppColors.cardBorder,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isOnDuty ? AppColors.green.withOpacity(0.3) : AppColors.cardBorder,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isOnDuty ? Icons.toggle_on_outlined : Icons.toggle_off_outlined,
                  size: 14,
                  color: isOnDuty ? AppColors.green : AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  isOnDuty ? 'On Duty' : 'Day Off',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isOnDuty ? AppColors.green : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String value;
  final String sub;
  const _QuickStat({required this.value, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary, fontFamily: 'Georgia')),
          Text(sub,
              style: const TextStyle(
                  fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ─── Tab 1: Schedule ──────────────────────────────────────────────────────────

class _ScheduleTab extends StatelessWidget {
  final List<ScheduleEntry> schedule;
  final bool isEditing;
  final void Function(int, bool) onToggleOff;
  final Future<void> Function(int, bool) onPickTime;

  const _ScheduleTab({
    required this.schedule,
    required this.isEditing,
    required this.onToggleOff,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      children: [
        _SectionLabel(label: 'WEEKLY SCHEDULE', icon: Icons.calendar_month_outlined),
        const SizedBox(height: 14),

        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: List.generate(schedule.length, (i) {
              final entry = schedule[i];
              final isLast = i == schedule.length - 1;
              return Column(
                children: [
                  isEditing
                      ? _EditableScheduleRow(
                          entry: entry,
                          index: i,
                          onToggleOff: onToggleOff,
                          onPickTime: onPickTime,
                        )
                      : _ReadOnlyScheduleRow(entry: entry),
                  if (!isLast)
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                ],
              );
            }),
          ),
        ),

        const SizedBox(height: 24),
        _SectionLabel(label: 'BREAK TIMES', icon: Icons.coffee_outlined),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              _BreakRow(label: 'Lunch Break', time: '01:00 PM – 01:30 PM', icon: Icons.lunch_dining_outlined),
              const SizedBox(height: 10),
              _BreakRow(label: 'Short Break', time: '04:00 PM – 04:15 PM', icon: Icons.local_cafe_outlined),
            ],
          ),
        ),
      ],
    );
  }
}

// Read-only schedule row
class _ReadOnlyScheduleRow extends StatelessWidget {
  final ScheduleEntry entry;
  const _ReadOnlyScheduleRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _DayChip(day: entry.day, isOff: entry.isOff),
          const SizedBox(width: 14),
          Expanded(
            child: entry.isOff
                ? _OffBadge()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.schedule_outlined, size: 13, color: AppColors.textMuted),
                          const SizedBox(width: 5),
                          Text('${entry.startTime}  –  ${entry.endTime}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        ],
                      ),
                      const Text('9 hours shift',
                          style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    ],
                  ),
          ),
          if (!entry.isOff)
            Container(
              width: 6, height: 6,
              decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}

// Editable schedule row
class _EditableScheduleRow extends StatelessWidget {
  final ScheduleEntry entry;
  final int index;
  final void Function(int, bool) onToggleOff;
  final Future<void> Function(int, bool) onPickTime;

  const _EditableScheduleRow({
    required this.entry,
    required this.index,
    required this.onToggleOff,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          _DayChip(day: entry.day, isOff: entry.isOff),
          const SizedBox(width: 12),

          Expanded(
            child: entry.isOff
                ? _OffBadge()
                : Row(
                    children: [
                      // Start time button
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onPickTime(index, true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.goldFaint,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.schedule_outlined, size: 12, color: AppColors.gold),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    entry.startTime,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.gold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text('–', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ),
                      // End time button
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onPickTime(index, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.goldFaint,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.schedule_outlined, size: 12, color: AppColors.gold),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    entry.endTime,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.gold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          const SizedBox(width: 10),

          // Day-off toggle
          Transform.scale(
            scale: 0.75,
            child: Switch(
              value: !entry.isOff,
              activeColor: AppColors.gold,
              onChanged: (v) => onToggleOff(index, !v),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  final String day;
  final bool isOff;
  const _DayChip({required this.day, required this.isOff});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isOff ? AppColors.divider : AppColors.goldFaint,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: isOff ? AppColors.textMuted : AppColors.gold,
          ),
        ),
      ),
    );
  }
}

class _OffBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text('Day Off',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
    );
  }
}

class _BreakRow extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;
  const _BreakRow({required this.label, required this.time, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: AppColors.orangeFaint, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 16, color: AppColors.orange),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
      ],
    );
  }
}

// ─── Tab 2: Specialties ───────────────────────────────────────────────────────

class _SpecialtiesTab extends StatelessWidget {
  final List<Map<String, dynamic>> activeSpecialties;
  final bool isEditing;
  final ValueChanged<String> onRemove;
  final VoidCallback onAdd;

  const _SpecialtiesTab({
    required this.activeSpecialties,
    required this.isEditing,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final items = [...activeSpecialties];
    if (isEditing) items.add({'_addCard': true});

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      children: [
        _SectionLabel(label: 'SERVICE SPECIALTIES', icon: Icons.auto_awesome_outlined),
        const SizedBox(height: 14),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.55,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final sp = items[index];

            // Add card
            if (sp.containsKey('_addCard')) {
              return GestureDetector(
                onTap: onAdd,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.goldFaint,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.gold.withOpacity(0.3), width: 1.5),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline, size: 28, color: AppColors.gold),
                      SizedBox(height: 6),
                      Text(
                        'Add Specialty',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final Color color = sp['color'] as Color;
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(sp['icon'] as IconData, size: 18, color: color),
                      ),
                      Text(
                        sp['name'] as String,
                        style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary, height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Remove button in edit mode
                if (isEditing)
                  Positioned(
                    top: 6, right: 6,
                    child: GestureDetector(
                      onTap: () => onRemove(sp['name'] as String),
                      child: Container(
                        width: 22, height: 22,
                        decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 13, color: AppColors.white),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),

        const SizedBox(height: 24),
        _SectionLabel(label: 'PERFORMANCE METRICS', icon: Icons.bar_chart_outlined),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: const Column(
            children: [
              _PerformanceBar(label: 'Client Satisfaction', value: 0.96, color: AppColors.green,  display: '96%'),
              SizedBox(height: 14),
              _PerformanceBar(label: 'On-Time Rate',        value: 0.89, color: AppColors.gold,   display: '89%'),
              SizedBox(height: 14),
              _PerformanceBar(label: 'Rebooking Rate',      value: 0.72, color: AppColors.purple, display: '72%'),
              SizedBox(height: 14),
              _PerformanceBar(label: 'Revenue Contribution',value: 0.84, color: AppColors.orange, display: '84%'),
            ],
          ),
        ),
      ],
    );
  }
}

class _PerformanceBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final String display;

  const _PerformanceBar({
    required this.label,
    required this.value,
    required this.color,
    required this.display,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
            Text(display, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// ─── Tab 3: Bookings ─────────────────────────────────────────────────────────

class _BookingsTab extends StatelessWidget {
  final List<BookingRecord> bookings;
  final bool isEditing;
  final Future<void> Function(int) onCancelBooking;

  const _BookingsTab({
    required this.bookings,
    required this.isEditing,
    required this.onCancelBooking,
  });

  Map<String, List<_IndexedBooking>> _groupByDate() {
    final Map<String, List<_IndexedBooking>> grouped = {};
    for (int i = 0; i < bookings.length; i++) {
      final b = bookings[i];
      grouped.putIfAbsent(b.date, () => []).add(_IndexedBooking(index: i, booking: b));
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDate();
    final dates   = grouped.keys.toList();

    final completed   = bookings.where((b) => b.status == 'completed').length;
    final upcoming    = bookings.where((b) => b.status == 'upcoming').length;
    final cancelled   = bookings.where((b) => b.status == 'cancelled').length;
    final totalRevenue = bookings
        .where((b) => b.status == 'completed')
        .fold<double>(0, (s, b) => s + b.amount);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      children: [
        // Summary chips
        Row(
          children: [
            _SummaryChip(label: 'Done',      count: completed, color: AppColors.green,  bg: AppColors.greenFaint),
            const SizedBox(width: 8),
            _SummaryChip(label: 'Upcoming',  count: upcoming,  color: AppColors.gold,   bg: AppColors.goldFaint),
            const SizedBox(width: 8),
            _SummaryChip(label: 'Cancelled', count: cancelled, color: AppColors.red,    bg: AppColors.pinkFaint),
          ],
        ),

        const SizedBox(height: 12),

        // Revenue strip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: AppColors.purpleFaint, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.currency_rupee, size: 18, color: AppColors.purple),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOTAL REVENUE (SHOWN)',
                      style: TextStyle(fontSize: 9, letterSpacing: 1.2, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                  Text('₹ ${totalRevenue.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary, fontFamily: 'Georgia')),
                ],
              ),
            ],
          ),
        ),

        if (isEditing) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.orangeFaint,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.orange.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: AppColors.orange),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Tap "Cancel" on upcoming bookings to cancel them.',
                    style: TextStyle(fontSize: 11, color: AppColors.orange, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 20),
        _SectionLabel(label: 'BOOKING HISTORY', icon: Icons.receipt_long_outlined),
        const SizedBox(height: 14),

        ...dates.map((date) {
          final list = grouped[date]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 4),
                child: Text(
                  date.toUpperCase(),
                  style: const TextStyle(fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w700, color: AppColors.textMuted),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: List.generate(list.length, (i) {
                    final isLast = i == list.length - 1;
                    final ib = list[i];
                    return Column(
                      children: [
                        _BookingRow(
                          booking: ib.booking,
                          isEditing: isEditing,
                          onCancel: ib.booking.status == 'upcoming'
                              ? () => onCancelBooking(ib.index)
                              : null,
                        ),
                        if (!isLast)
                          const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }),
      ],
    );
  }
}

class _IndexedBooking {
  final int index;
  final BookingRecord booking;
  _IndexedBooking({required this.index, required this.booking});
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color bg;

  const _SummaryChip({required this.label, required this.count, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(count.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color, fontFamily: 'Georgia')),
            Text(label,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}

class _BookingRow extends StatelessWidget {
  final BookingRecord booking;
  final bool isEditing;
  final VoidCallback? onCancel;

  const _BookingRow({required this.booking, required this.isEditing, this.onCancel});

  Color get _statusColor {
    switch (booking.status) {
      case 'completed': return AppColors.green;
      case 'upcoming':  return AppColors.gold;
      case 'cancelled': return AppColors.red;
      default:          return AppColors.textMuted;
    }
  }

  Color get _statusBg {
    switch (booking.status) {
      case 'completed': return AppColors.greenFaint;
      case 'upcoming':  return AppColors.goldFaint;
      case 'cancelled': return AppColors.pinkFaint;
      default:          return AppColors.divider;
    }
  }

  IconData get _statusIcon {
    switch (booking.status) {
      case 'completed': return Icons.check_circle_outline;
      case 'upcoming':  return Icons.schedule_outlined;
      case 'cancelled': return Icons.cancel_outlined;
      default:          return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Client avatar
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: AppColors.goldFaint, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(booking.clientInitial,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.gold, fontFamily: 'Georgia')),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.clientName,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text('${booking.service}  ·  ${booking.time}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹ ${booking.amount.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontFamily: 'Georgia')),
              const SizedBox(height: 4),

              // Cancel button (edit mode, upcoming only)
              if (isEditing && onCancel != null)
                GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.pinkFaint,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.red.withOpacity(0.3)),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.red)),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(color: _statusBg, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon, size: 10, color: _statusColor),
                      const SizedBox(width: 3),
                      Text(
                        booking.status[0].toUpperCase() + booking.status.substring(1),
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _statusColor),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.gold),
        const SizedBox(width: 7),
        Text(label,
            style: const TextStyle(
                fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w800, color: AppColors.textMuted)),
      ],
    );
  }
}
