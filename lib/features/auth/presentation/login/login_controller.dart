import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:app_template/core/router/app_route.dart';
import 'package:app_template/shared/base/controllers/base_controller.dart';

class LoginController extends BaseController {
  final phoneTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final obscurePassword = true.obs;
  String selectedDialCode = '+244';

  @override
  void onClose() {
    phoneTextController.dispose();
    passwordTextController.dispose();
    super.onClose();
  }

  bool validateInputs(String rawPhone, String password) {
    if (rawPhone.isEmpty) {
      showValidationError('Por favor, insira o número de telefone');
      return false;
    }

    if (password.isEmpty) {
      showValidationError('Por favor, insira a palavra-passe');
      return false;
    }

    if (password.length < 8) {
      showValidationError('A palavra-passe deve ter no mínimo 8 caracteres');
      return false;
    }

    return true;
  }

  Future<void> login() async {
    final rawPhone = phoneTextController.text.trim();
    final password = passwordTextController.text;

    if (!validateInputs(rawPhone, password)) return;

    final phone = '$selectedDialCode$rawPhone';

    try {
      isLoading.value = true;
      log('[LoginController] iniciando login para: $phone',
          name: 'LoginController');

      final result = await userRepository.login(phone, password);
      isLoading.value = false;

      log('[LoginController] login bem-sucedido para userId: ${result?.userId}',
          name: 'LoginController');
      showSuccess('Bem-vindo!', 'Login efetuado com sucesso.');
      unawaited(Get.offAllNamed(AppRoute.HOME));
    } catch (e, st) {
      isLoading.value = false;
      showAppError(e);
      log('[LoginController] erro no login: $e',
          name: 'LoginController', error: e, stackTrace: st);
    }
  }

  void goToSignUp() {
    Get.toNamed(AppRoute.SIGN_UP);
  }
}
