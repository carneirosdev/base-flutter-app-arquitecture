import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:app_template/core/router/app_route.dart';
import 'package:app_template/shared/base/controllers/base_controller.dart';

class ResetPasswordController extends BaseController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String phone = '';
  String code = '';

  bool _validateInputs(String newPassword, String confirmPassword) {
    if (newPassword.isEmpty) {
      showValidationError('Por favor, insira a nova palavra-passe');
      return false;
    }
    if (newPassword.length < 8) {
      showValidationError('A palavra-passe deve ter no mínimo 8 caracteres');
      return false;
    }
    if (newPassword != confirmPassword) {
      showValidationError('As palavras-passe não coincidem');
      return false;
    }
    return true;
  }

  Future<void> resetPassword() async {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (!_validateInputs(newPassword, confirmPassword)) return;

    log('[ResetPasswordController] a redefinir senha para: $phone',
        name: 'ResetPasswordController');

    try {
      isLoading.value = true;
      await userRepository.passwordResetConfirm(
        phone: phone,
        code: code,
        newPassword: newPassword,
      );
      log('[ResetPasswordController] senha redefinida para: $phone',
          name: 'ResetPasswordController');
      showSuccess(
        'Palavra-passe redefinida!',
        'Podes agora fazer login com a nova palavra-passe.',
      );
      unawaited(Get.offAllNamed(AppRoute.WELCOME));
    } catch (e, st) {
      showAppError(e);
      log('[ResetPasswordController] erro na redefinição: $e',
          name: 'ResetPasswordController', error: e, stackTrace: st);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
