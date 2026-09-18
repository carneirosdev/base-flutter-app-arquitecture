import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;
import 'package:app_template/features/auth/presentation/signup/widgets/country_codes.dart';
import 'package:app_template/features/auth/presentation/signup/widgets/phone_field/country_button.dart';
import 'package:app_template/features/auth/presentation/signup/widgets/phone_field/country_picker_sheet.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({
    super.key,
    required this.controller,
    required this.onCountryCodeChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onCountryCodeChanged;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  CountryCode _selected = kCountryCodes.first;
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() => _isFocused = _focusNode.hasFocus);

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _openPicker() async {
    final result = await showModalBottomSheet<CountryCode>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: const CountryPickerSheet(),
      ),
    );
    if (result == null) return;
    setState(() => _selected = result);
    widget.onCountryCodeChanged(result.dialCode);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Número de telefone',
          style: TextStyle(
            fontSize: kit.AppTypography.MDTextFontSize,
            fontWeight: kit.AppTypography.fontWeightRegular,
            color: kit.AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        _fieldContainer(),
      ],
    );
  }

  Widget _fieldContainer() {
    final borderColor = _isFocused
        ? kit.AppColors.inputFocusColor
        : kit.AppColors.neutralGray.withValues(alpha: 0.4);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: _isFocused ? kit.AppColors.background : kit.AppColors.white,
        borderRadius: BorderRadius.circular(kit.AppRadius.radius30),
        border: Border.all(color: borderColor),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: kit.AppColors.inputFocusColor.withValues(alpha: 0.2),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : const [],
      ),
      child: Row(
        children: [
          CountryButton(country: _selected, onTap: _openPicker),
          Container(
            width: 1,
            height: 22,
            color: kit.AppColors.neutralGray.withValues(alpha: 0.4),
          ),
          Expanded(child: _input()),
        ],
      ),
    );
  }

  Widget _input() {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(
        fontSize: kit.AppTypography.LGTextFontSize,
        fontWeight: kit.AppTypography.fontWeightRegular,
        color: kit.AppColors.textPrimary,
      ),
      decoration: const InputDecoration(
        hintText: 'Número de telefone',
        hintStyle: TextStyle(
          fontSize: kit.AppTypography.LGTextFontSize,
          fontWeight: kit.AppTypography.fontWeightBold,
          color: kit.AppColors.neutralGray,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
