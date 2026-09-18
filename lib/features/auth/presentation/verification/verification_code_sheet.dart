import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;
import 'package:app_template/features/auth/presentation/login/widgets/sheet_handle.dart';
import 'package:app_template/features/auth/presentation/signup/signup_sheet.dart';
import 'package:app_template/features/auth/presentation/verification/verification_code_controller.dart';
import 'package:app_template/features/auth/presentation/verification/widgets/otp_input_boxes.dart';
import 'package:app_template/injector/dependency_injector.dart';
import 'package:app_template/services/sms_retriever_service.dart';

class VerificationCodeSheet extends StatefulWidget {
  const VerificationCodeSheet({super.key});

  @override
  State<VerificationCodeSheet> createState() => _VerificationCodeSheetState();
}

class _VerificationCodeSheetState extends State<VerificationCodeSheet> {
  late final VerificationCodeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = injector.get<VerificationCodeController>();
    _controller.startSmsListener();
    _controller.startResendTimer();
  }

  @override
  void dispose() {
    SmsRetrieverService.stopSmsRetrieval();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.50,
      ),
      padding: const EdgeInsets.fromLTRB(
        kit.AppSpacing.lg,
        kit.AppSpacing.sm,
        kit.AppSpacing.lg,
        kit.AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: kit.AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: kit.AppShadows.dialog,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHandle(),
            const SizedBox(height: kit.AppSpacing.sm),
            _BackButton(onTap: () {
              Navigator.of(context).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showModalBottomSheet(
                  context: Get.context!,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(ctx).viewInsets.bottom,
                    ),
                    child: const SignUpSheet(),
                  ),
                );
              });
            }),
            const SizedBox(height: kit.AppSpacing.sm),
            Text(
              'CONFIRMA O\nTEU NÚMERO',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: kit.AppColors.neutralBlack,
                height: 1.0,
              ),
            ),
            const SizedBox(height: kit.AppSpacing.md),
            Text(
              'Inseriste o código de 6 dígitos enviado para o teu número de telefone.',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 26),
            OtpInputBoxes(controller: controller),
            const SizedBox(height: kit.AppSpacing.md),
            const _ResendCode(),
            const SizedBox(height: 26),
            Obx(
              () => kit.AppButton(
                label: 'Confirmar',
                onPressed: controller.verify,
                isLoading: controller.isLoading.value,
              ),
            ),
            const SizedBox(height: kit.AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF001319),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }
}

class _ResendCode extends StatelessWidget {
  const _ResendCode();

  @override
  Widget build(BuildContext context) {
    final controller = injector.get<VerificationCodeController>();
    return Obx(() {
      final active = controller.canResend.value;
      final seconds = controller.resendCountdown.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Não recebeu o código?',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: kit.AppSpacing.xs),
          GestureDetector(
            onTap: active ? controller.resendCode : null,
            child: Text(
              active ? 'Reenviar' : 'Reenviar em ${seconds}s',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: kit.AppTypography.fontWeightMedium,
                color: active ? kit.AppColors.primary : kit.AppColors.neutralGray,
              ),
            ),
          ),
        ],
      );
    });
  }
}
