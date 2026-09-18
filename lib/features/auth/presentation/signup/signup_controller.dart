import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:app_template/features/auth/presentation/verification/verification_code_controller.dart';
import 'package:app_template/injector/dependency_injector.dart';
import 'package:app_template/shared/base/controllers/base_controller.dart';

class SignUpController extends BaseController {
  final nameTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final signUpSucceeded = false.obs;
  String selectedDialCode = '+244';

  @override
  void onClose() {
    nameTextController.dispose();
    phoneTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.onClose();
  }

  bool validateInputs({
    required String name,
    required String phone,
    required String password,
    required String confirmPassword,
  }) {


    if (phone.isEmpty) {
      showValidationError('Por favor, insira seu telefone');
      return false;
    }

    if (name.isEmpty) {
      showValidationError('Por favor, insira o seu nome');
      return false;
    }

    final nameParts = name.split(' ').where((part) => part.isNotEmpty).toList();
    if (nameParts.length < 2) {
      showValidationError('Por favor, insira o primeiro e o último nome');
      return false;
    }

    if (password.isEmpty) {
      showValidationError('Por favor, insira sua senha');
      return false;
    }

    if (password.length < 8) {
      showValidationError('A palavra-passe deve ter no mínimo 8 caracteres');
      return false;
    }

    if (confirmPassword.isEmpty) {
      showValidationError('Por favor, confirme sua senha');
      return false;
    }

    if (password != confirmPassword) {
      showValidationError('As senhas não coincidem');
      return false;
    }

    return true;
  }

  /// Realiza o sign up via Supabase
  Future<void> signUp() async {
    final name = nameTextController.text.trim();
    final rawPhone = phoneTextController.text.trim();
    final password = passwordTextController.text;
    final confirmPassword = confirmPasswordTextController.text;

    if (!validateInputs(
      name: name,
      phone: rawPhone,
      password: password,
      confirmPassword: confirmPassword,
    )) {
      return;
    }

    final phone = '$selectedDialCode$rawPhone';

    try {
      isLoading.value = true;
      log('[SignUpController] iniciando registo para: $phone',
          name: 'SignUpController');

      await userRepository.registerStart(
        name: name,
        phone: phone,
        password: password,
      );

      isLoading.value = false;

      log('[SignUpController] registo iniciado para: $phone',
          name: 'SignUpController');
      injector.get<VerificationCodeController>().phone = phone;
      signUpSucceeded.value = true;
    } catch (e, st) {
      isLoading.value = false;
      showAppError(e);
      log('[SignUpController] erro no registo: $e',
          name: 'SignUpController', error: e, stackTrace: st);
    }
  }

  void goToLogin() {
    Get.back();
  }
}
