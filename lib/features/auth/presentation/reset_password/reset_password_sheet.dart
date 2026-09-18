import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;
import 'package:app_template/features/auth/presentation/login/widgets/sheet_handle.dart';
import 'package:app_template/features/auth/presentation/reset_code/reset_code_sheet.dart';
import 'package:app_template/features/auth/presentation/reset_password/reset_password_controller.dart';
import 'package:app_template/features/auth/presentation/reset_password/widgets/reset_password_form.dart';
import 'package:app_template/injector/dependency_injector.dart';

class ResetPasswordSheet extends StatelessWidget {
  const ResetPasswordSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = injector.get<ResetPasswordController>();

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
                    child: const ResetCodeSheet(),
                  ),
                );
              });
            }),
            const SizedBox(height: kit.AppSpacing.sm),
            Text(
              'NOVA\nPALAVRA PASSE',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: kit.AppColors.neutralBlack,
                height: 1.0,
              ),
            ),
            const SizedBox(height: kit.AppSpacing.md),
            Text(
              'Define a tua nova palavra-passe. Usa no mínimo 8 caracteres.',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 26),
            ResetPasswordForm(controller: controller),
            const SizedBox(height: kit.AppSpacing.lg),
            Obx(
              () => kit.AppButton(
                label: 'Redefinir palavra-passe',
                onPressed: controller.resetPassword,
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
