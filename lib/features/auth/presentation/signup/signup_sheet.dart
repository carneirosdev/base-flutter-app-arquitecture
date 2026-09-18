import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;
import 'package:app_template/features/auth/presentation/login/login_sheet.dart';
import 'package:app_template/features/auth/presentation/login/widgets/sheet_handle.dart';
import 'package:app_template/features/auth/presentation/signup/signup_controller.dart';
import 'package:app_template/features/auth/presentation/signup/widgets/phone_field.dart';
import 'package:app_template/features/auth/presentation/verification/verification_code_sheet.dart';
import 'package:app_template/injector/dependency_injector.dart';

class SignUpSheet extends StatelessWidget {
  const SignUpSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = injector.get<SignUpController>();

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
                    child: const LoginSheet(),
                  ),
                );
              });
            }),
            const SizedBox(height: kit.AppSpacing.sm),
            Text(
              'CRIAR CONTA',
              style: kit.AppTypography.blackStyle(
                color: kit.AppColors.textPrimary,
                fontSize: kit.AppTypography.MDDisplayFontSize,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 25),
            PhoneField(
              controller: controller.phoneTextController,
              onCountryCodeChanged: (code) => controller.selectedDialCode = code,
            ),
            const SizedBox(height: kit.AppSpacing.md),
            kit.AppTextField(
              label: 'Nome',
              hint: 'Insira o primeiro e o último nome',
              controller: controller.nameTextController,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: kit.AppSpacing.md),
            kit.AppPasswordField(
              label: 'Palavra-passe',
              hint: 'Escreva aqui a tua palavra-passe',
              controller: controller.passwordTextController,
            ),
            const SizedBox(height: kit.AppSpacing.xs),
            const Text(
              'Usa uma senha forte com no mínimo 8 caracteres.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: kit.AppColors.neutralGray,
              ),
            ),
            const SizedBox(height: kit.AppSpacing.md),
            kit.AppPasswordField(
              label: 'Confirmar palavra-passe',
              hint: 'Repita a palavra-passe',
              controller: controller.confirmPasswordTextController,
            ),
            const SizedBox(height: 26),
            Obx(
              () => kit.AppButton(
                label: 'Avançar',
                onPressed: () async {
                  await controller.signUp();
                  if (!controller.signUpSucceeded.value) return;
                  controller.signUpSucceeded.value = false;
                  if (!context.mounted) return;
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
                        child: const VerificationCodeSheet(),
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
    return GestureDetector(
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
    );
  }
}
