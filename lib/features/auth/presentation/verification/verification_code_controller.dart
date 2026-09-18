import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:app_template/core/router/app_route.dart';
import 'package:app_template/services/sms_retriever_service.dart';
import 'package:app_template/shared/base/controllers/base_controller.dart';

class VerificationCodeController extends BaseController {
  final List<TextEditingController> digitControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final resendCountdown = 60.obs;
  final canResend = false.obs;
  Timer? _countdownTimer;

  String phone = '';

  String get code => digitControllers.map((c) => c.text).join();

  void startResendTimer() {
    _countdownTimer?.cancel();
    resendCountdown.value = 60;
    canResend.value = false;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value <= 1) {
        timer.cancel();
        resendCountdown.value = 0;
        canResend.value = true;
        return;
      }
      resendCountdown.value--;
    });
  }

  Future<void> startSmsListener() async {
    log('[VerificationCodeController] aguardando código SMS', name: 'VerificationCodeController');
    final sms = await SmsRetrieverService.startSmsRetrieval();
    if (sms == null) return;
    final match = RegExp(r'\d{6}').firstMatch(sms);
    if (match == null) return;
    log('[VerificationCodeController] código SMS recebido', name: 'VerificationCodeController');
    onPastedDigits(0, match.group(0)!);
  }

  void onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void onPastedDigits(int startIndex, String digits) {
    for (int i = 0; i < digits.length && (startIndex + i) < 6; i++) {
      digitControllers[startIndex + i].text = digits[i];
    }
    final lastFilledIndex = (startIndex + digits.length - 1).clamp(0, 5);
    focusNodes[lastFilledIndex].requestFocus();
  }

  Future<void> verify() async {
    if (code.length < 6) {
      showValidationError('Insere os 6 dígitos do código');
      return;
    }
    log('[VerificationCodeController] iniciando verificação para: $phone',
        name: 'VerificationCodeController');
    try {
      isLoading.value = true;

      await userRepository.registerConfirm(phone: phone, code: code);

      log('[VerificationCodeController] conta confirmada para: $phone',
          name: 'VerificationCodeController');
      showSuccess('Conta criada!', 'A tua conta foi criada com sucesso.');
      unawaited(Get.offAllNamed(AppRoute.HOME));
    } catch (e, st) {
      log('[VerificationCodeController] erro na verificação: $e',
          name: 'VerificationCodeController', error: e, stackTrace: st);
      showAppError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendCode() async {
    if (!canResend.value) return;
    log('[VerificationCodeController] reenviar código para: $phone',
        name: 'VerificationCodeController');
    try {
      isLoading.value = true;
      await userRepository.registerResend(phone: phone);
      startResendTimer();
      showSuccess('Código enviado', 'Um novo código foi enviado para o teu número.');
      log('[VerificationCodeController] código reenviado para: $phone',
          name: 'VerificationCodeController');
    } catch (e, st) {
      log('[VerificationCodeController] erro ao reenviar código: $e',
          name: 'VerificationCodeController', error: e, stackTrace: st);
      showAppError(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    for (final controller in digitControllers) {
      controller.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
