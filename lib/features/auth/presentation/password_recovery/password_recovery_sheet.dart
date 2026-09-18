import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;
import 'package:app_template/features/auth/presentation/login/widgets/sheet_handle.dart';
import 'package:app_template/features/auth/presentation/password_recovery/password_recovery_controller.dart';
import 'package:app_template/features/auth/presentation/password_recovery/widgets/password_recovery_form.dart';
import 'package:app_template/features/auth/presentation/reset_code/reset_code_controller.dart';
import 'package:app_template/features/auth/presentation/reset_code/reset_code_sheet.dart';
import 'package:app_template/injector/dependency_injector.dart';

class PasswordRecoverySheet extends StatelessWidget {
  const PasswordRecoverySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = injector.get<PasswordRecoveryController>();

    return Container(
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHandle(),
            const SizedBox(height: kit.AppSpacing.sm),
            _BackButton(onTap: () => Navigator.of(context).pop()),
            const SizedBox(height: kit.AppSpacing.sm),
            Text(
              'RECUPERAR\nPALAVRA PASSE',
              style: kit.AppTypography.blackStyle(
                color: kit.AppColors.textPrimary,
                fontSize: kit.AppTypography.MDDisplayFontSize,
                height: 1.0,
              ),
            ),
            const SizedBox(height: kit.AppSpacing.md),
            Text(
              'Insere o teu número de telefone para receberes um código de verificação.',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),
            PasswordRecoveryForm(controller: controller),
            const SizedBox(height: kit.AppSpacing.lg),
            Obx(
              () => kit.AppButton(
                label: 'Enviar código',
                onPressed: () async {
                  await controller.sendResetCode();
                  if (!controller.codeSent.value) return;
                  controller.codeSent.value = false;
                  if (!context.mounted) return;
                  final phone =
                      '${controller.selectedDialCode}${controller.phoneTextController.text.trim()}';
                  injector.get<ResetCodeController>().phone = phone;
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
                        child: const ResetCodeSheet(),
                      ),
                    );
                  });
                },
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
