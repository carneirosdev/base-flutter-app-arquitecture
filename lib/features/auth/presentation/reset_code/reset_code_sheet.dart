import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;
import 'package:app_template/features/auth/presentation/login/widgets/sheet_handle.dart';
import 'package:app_template/features/auth/presentation/password_recovery/password_recovery_sheet.dart';
import 'package:app_template/features/auth/presentation/reset_code/reset_code_controller.dart';
import 'package:app_template/features/auth/presentation/reset_code/widgets/reset_code_otp_boxes.dart';
import 'package:app_template/features/auth/presentation/reset_password/reset_password_controller.dart';
import 'package:app_template/features/auth/presentation/reset_password/reset_password_sheet.dart';
import 'package:app_template/injector/dependency_injector.dart';
import 'package:app_template/services/sms_retriever_service.dart';

class ResetCodeSheet extends StatefulWidget {
  const ResetCodeSheet({super.key});

  @override
  State<ResetCodeSheet> createState() => _ResetCodeSheetState();
}

class _ResetCodeSheetState extends State<ResetCodeSheet> {
  late final ResetCodeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = injector.get<ResetCodeController>();
    _controller.startSmsListener();
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
        minHeight: MediaQuery.of(context).size.height * 0.55,
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
                    child: const PasswordRecoverySheet(),
                  ),
                );
              });
            }),
            const SizedBox(height: kit.AppSpacing.sm),
            Text(
              'CONFIRMA O\nTEU CÓDIGO',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: kit.AppColors.neutralBlack,
                height: 1.0,
              ),
            ),
            const SizedBox(height: kit.AppSpacing.md),
            Text(
              'Insere o código de 6 dígitos enviado para o teu número de telefone.',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 26),
            ResetCodeOtpBoxes(
              controllers: controller.digitControllers,
              focusNodes: controller.focusNodes,
              onDigitChanged: controller.onDigitChanged,
              onPastedDigits: controller.onPastedDigits,
            ),
            const SizedBox(height: kit.AppSpacing.lg),
            kit.AppButton(
              label: 'Continuar',
              onPressed: () {
                controller.confirm();
                if (!controller.codeConfirmed.value) return;
                controller.codeConfirmed.value = false;
                if (!context.mounted) return;
                final resetController = injector.get<ResetPasswordController>();
                resetController.phone = controller.phone;
                resetController.code = controller.code;
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
                      child: const ResetPasswordSheet(),
                    ),
                  );
                });
              },
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
