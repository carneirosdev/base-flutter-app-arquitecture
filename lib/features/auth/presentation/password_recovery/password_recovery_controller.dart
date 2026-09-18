import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:app_template/shared/base/controllers/base_controller.dart';

class PasswordRecoveryController extends BaseController {
  final phoneTextController = TextEditingController();
  String selectedDialCode = '+244';
  final codeSent = false.obs;

  bool _isPhoneValid(String rawPhone) {
    if (rawPhone.isEmpty) {
      showValidationError('Por favor, insira o número de telefone');
      return false;
    }
    return true;
  }

  Future<void> sendResetCode() async {
    final rawPhone = phoneTextController.text.trim();
    if (!_isPhoneValid(rawPhone)) return;

    final phone = '$selectedDialCode$rawPhone';
    log('[PasswordRecoveryController] a enviar código para: $phone',
        name: 'PasswordRecoveryController');

    try {
      isLoading.value = true;
      await userRepository.passwordResetStart(phone: phone);
      log('[PasswordRecoveryController] código enviado para: $phone',
          name: 'PasswordRecoveryController');
      codeSent.value = true;
    } catch (e, st) {
      showAppError(e);
      log('[PasswordRecoveryController] erro ao enviar código: $e',
          name: 'PasswordRecoveryController', error: e, stackTrace: st);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneTextController.dispose();
    super.onClose();
  }
}