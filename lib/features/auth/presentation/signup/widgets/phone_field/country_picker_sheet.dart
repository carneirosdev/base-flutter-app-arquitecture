import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;
import 'package:app_template/features/auth/presentation/signup/widgets/country_codes.dart';
import 'package:app_template/features/auth/presentation/signup/widgets/phone_field/country_not_found.dart';
import 'package:app_template/features/auth/presentation/signup/widgets/phone_field/country_tile.dart';
import 'package:app_template/shared/widgets/drag_handle.dart';

class CountryPickerSheet extends StatefulWidget {
  const CountryPickerSheet({super.key});

  @override
  State<CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<CountryPickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CountryCode> get _filtered {
    if (_query.isEmpty) return kCountryCodes;
    final lower = _query.toLowerCase();
    return kCountryCodes
        .where((country) =>
            country.name.toLowerCase().contains(lower) ||
            country.dialCode.contains(_query))
        .toList();
  }

  CountryCode? get _manualEntry {
    final query = _query.trim();
    if (!query.startsWith('+') || query.length < 2) return null;
    if (!RegExp(r'^\+\d+$').hasMatch(query)) return null;
    return CountryCode(
      name: 'Indicativo personalizado',
      flag: '🌍',
      dialCode: query,
    );
  }

  void _onQueryChanged(String value) => setState(() => _query = value);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: kit.AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 12), child: DragHandle()),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              'Selecionar país',
              style: TextStyle(
                fontSize: kit.AppTypography.XLTextFontSize,
                fontWeight: kit.AppTypography.fontWeightBold,
                color: kit.AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _searchField(),
          ),
          const SizedBox(height: 8),
          Expanded(child: _results()),
        ],
      ),
    );
  }

  Widget _searchField() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(kit.AppRadius.radius30),
      borderSide: BorderSide(
        color: kit.AppColors.neutralGray.withValues(alpha: 0.4),
      ),
    );
    return TextField(
      controller: _searchController,
      autofocus: true,
      onChanged: _onQueryChanged,
      decoration: InputDecoration(
        hintText: 'Pesquisar país ou indicativo (ex: +244)',
        hintStyle: const TextStyle(
          fontSize: kit.AppTypography.MDTextFontSize,
          color: kit.AppColors.neutralGray,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: kit.AppColors.neutralGray,
          size: 20,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kit.AppRadius.radius30),
          borderSide: const BorderSide(color: kit.AppColors.inputFocusColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: kit.AppColors.background,
      ),
    );
  }

  Widget _results() {
    if (_filtered.isEmpty && _manualEntry == null) {
      return const CountryNotFound();
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        if (_manualEntry != null)
          CountryTile(
            country: _manualEntry!,
            isCustom: true,
            onTap: () => Get.back(result: _manualEntry),
          ),
        ..._filtered.map(
          (country) => CountryTile(
            country: country,
            onTap: () => Get.back(result: country),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
