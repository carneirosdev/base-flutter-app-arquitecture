import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;
import 'package:app_template/features/auth/presentation/login/login_controller.dart';
import 'package:app_template/features/auth/presentation/login/widgets/sheet_handle.dart';
import 'package:app_template/features/auth/presentation/password_recovery/password_recovery_sheet.dart';
import 'package:app_template/features/auth/presentation/signup/signup_sheet.dart';
import 'package:app_template/features/auth/presentation/signup/widgets/phone_field.dart';
import 'package:app_template/injector/dependency_injector.dart';

class LoginSheet extends StatelessWidget {
  const LoginSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = injector.get<LoginController>();

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
            _CloseButton(onTap: () => Navigator.of(context).pop()),
            const SizedBox(height: kit.AppSpacing.sm),
            Text(
              'ENTRAR',
              style: kit.AppTypography.blackStyle(
                color: kit.AppColors.textPrimary,
                fontSize: kit.AppTypography.MDDisplayFontSize,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 25),
            PhoneField(
              controller: controller.phoneTextController,
              onCountryCodeChanged: (code) =>
                  controller.selectedDialCode = code,
            ),
            const SizedBox(height: kit.AppSpacing.md),
            kit.AppPasswordField(
              label: 'Palavra passe',
              hint: 'Escreva aqui a sua palavra passe',
              controller: controller.passwordTextController,
            ),
            const SizedBox(height: 26),
            Obx(
              () => kit.AppButton(
                label: 'Entrar',
                onPressed: controller.login,
                size: kit.ButtonSize.lg,
                isLoading: controller.isLoading.value,
              ),
            ),
            const SizedBox(height: kit.AppSpacing.md),
            const _ForgotPassword(),
            const SizedBox(height: kit.AppSpacing.md),
            kit.AppButton(
              label: 'Ainda não tenho uma conta',
              variant: kit.ButtonVariant.secondary,
              size: kit.ButtonSize.lg,
              onPressed: () {
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
              },
            ),
            const SizedBox(height: kit.AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

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
            child: const Icon(Icons.close, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }
}

class _ForgotPassword extends StatelessWidget {
  const _ForgotPassword();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Esqueceu a passe?',
          style: TextStyle(
            fontSize: kit.AppTypography.XLTextFontSize,
            fontWeight: kit.AppTypography.fontWeightMedium,
            color: kit.AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: kit.AppSpacing.xs),
        GestureDetector(
          onTap: () {
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
          },
          child: const Text(
            'Recupere aqui',
            style: TextStyle(
              fontSize: kit.AppTypography.XLTextFontSize,
              fontWeight: kit.AppTypography.fontWeightMedium,
              color: kit.AppColors.textOnPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
