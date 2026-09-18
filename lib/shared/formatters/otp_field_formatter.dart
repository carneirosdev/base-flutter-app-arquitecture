import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class OtpFieldFormatter extends TextInputFormatter {
  final void Function(String digits) onPaste;

  const OtpFieldFormatter({required this.onPaste});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onPaste(digits));
      return TextEditingValue(
        text: digits[0],
        selection: const TextSelection.collapsed(offset: 1),
      );
    }
    if (digits.isEmpty) return const TextEditingValue();
    return TextEditingValue(
      text: digits,
      selection: const TextSelection.collapsed(offset: 1),
    );
  }
}
