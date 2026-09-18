import 'package:app_template/core/design_system/components/app_text_field.dart';
import 'package:app_template/core/design_system/tokens/colors.dart';
import 'package:flutter/material.dart';

/// Campo de palavra-passe com alternância de visibilidade.
class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _isObscured = true;

  void _toggleVisibility() => setState(() => _isObscured = !_isObscured);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
      obscureText: _isObscured,
      suffixIcon: IconButton(
        onPressed: _toggleVisibility,
        color: AppColors.neutralGray,
        icon: Icon(
          _isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        tooltip: _isObscured ? 'Mostrar palavra-passe' : 'Ocultar palavra-passe',
      ),
    );
  }
}
