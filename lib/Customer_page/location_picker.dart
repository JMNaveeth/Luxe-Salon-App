import 'package:flutter/material.dart';
import 'sl_location_data.dart';

/// Luxe-themed full-screen location picker.
/// Lets users drill down: Province → District → Area.
/// Returns the selected area string via Navigator.pop.
class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  // Palette (matches home)
  static const _bg = Color(0xFF1A1A12);
  static const _surface = Color(0xFF2A2A1E);
  static const _card = Color(0xFF252518);
  static const _cardBorder = Color(0xFF353520);
  static const _gold = Color(0xFFD4A843);
  static const _textPrimary = Color(0xFFF5EDD6);
  static const _textSecondary = Color(0xFF9A9070);
  static const _textMuted = Color(0xFF6A6040);

  String? _selectedProvince;
  String? _selectedDistrict;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── What to show ────────────────────────────────────────────────────────
  List<String> get _currentItems {
    if (_selectedProvince == null) {
      return slLocations.keys.toList();
    }
    if (_selectedDistrict == null) {
      return slLocations[_selectedProvince]!.keys.toList();
    }
    return slLocations[_selectedProvince]![_selectedDistrict]!;
  }

  List<String> get _filteredItems {
    if (_searchQuery.isEmpty) return _currentItems;
    final q = _searchQuery.toLowerCase();
    return _currentItems.where((e) => e.toLowerCase().contains(q)).toList();
  }

  String get _title {
    if (_selectedProvince == null) return 'Select Province';
    if (_selectedDistrict == null) return 'Select District';
    return 'Select Area';
  }

  String get _subtitle {
    if (_selectedProvince == null) return '9 Provinces in Sri Lanka';
    if (_selectedDistrict == null) return '$_selectedProvince Province';
    return '$_selectedDistrict District';
  }

  IconData get _leadingIcon {
    if (_selectedProvince == null) return Icons.map_outlined;
    if (_selectedDistrict == null) return Icons.domain_outlined;
    return Icons.location_on_outlined;
  }

  void _onItemTap(String item) {
    setState(() {
      _searchCtrl.clear();
      _searchQuery = '';
      if (_selectedProvince == null) {
        _selectedProvince = item;
      } else if (_selectedDistrict == null) {
        _selectedDistrict = item;
      } else {
        // Area selected — return result
        final result = '$item, $_selectedDistrict';
        Navigator.of(context).pop(result);
      }
    });
  }

  void _onBack() {
    setState(() {
      _searchCtrl.clear();
      _searchQuery = '';
      if (_selectedDistrict != null) {
        _selectedDistrict = null;
      } else if (_selectedProvince != null) {
        _selectedProvince = null;
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _onBack,
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: _textPrimary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _title,
                          style: const TextStyle(
                            color: _textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _subtitle,
                          style: const TextStyle(
                            color: _textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Breadcrumb pills
                  if (_selectedProvince != null) _buildPill(_selectedProvince!),
                  if (_selectedDistrict != null) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.chevron_right,
                        color: _textMuted,
                        size: 14,
                      ),
                    ),
                    _buildPill(_selectedDistrict!),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Search bar ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _gold.withOpacity(0.25), width: 1),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(color: _textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText:
                        'Search ${_title.replaceAll("Select ", "").toLowerCase()}…',
                    hintStyle: const TextStyle(color: _textMuted, fontSize: 13),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: _gold,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ── List ──────────────────────────────────────────────────
            Expanded(
              child:
                  items.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off, color: _textMuted, size: 40),
                            const SizedBox(height: 10),
                            const Text(
                              'No matches found',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 4,
                        ),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => _buildItem(items[i]),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Breadcrumb pill ──────────────────────────────────────────────────────
  Widget _buildPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _gold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _gold.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: _gold,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // ── Single list item ─────────────────────────────────────────────────────
  Widget _buildItem(String name) {
    final isArea = _selectedDistrict != null;
    return GestureDetector(
      onTap: () => _onItemTap(name),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _gold.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_leadingIcon, color: _gold, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              isArea ? Icons.check_circle_outline : Icons.chevron_right,
              color: _gold,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
