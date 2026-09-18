import 'package:flutter/material.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;
import 'package:app_template/features/auth/presentation/verification/verification_code_controller.dart';
import 'package:app_template/shared/formatters/otp_field_formatter.dart';

class OtpInputBoxes extends StatelessWidget {
  final VerificationCodeController controller;

  const OtpInputBoxes({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(6, (i) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 5 ? 5 : 0),
            child: AspectRatio(
              aspectRatio: 1,
              child: TextField(
                controller: controller.digitControllers[i],
                focusNode: controller.focusNodes[i],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  OtpFieldFormatter(
                    onPaste: (digits) => controller.onPastedDigits(i, digits),
                  ),
                ],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) => controller.onDigitChanged(i, value),
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: kit.AppColors.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
