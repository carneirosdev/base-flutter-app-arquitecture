import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:app_template/services/sms_retriever_service.dart';
import 'package:app_template/shared/base/controllers/base_controller.dart';

class ResetCodeController extends BaseController {
  final List<TextEditingController> digitControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  final codeConfirmed = false.obs;

  String phone = '';

  String get code => digitControllers.map((c) => c.text).join();

  Future<void> startSmsListener() async {
    log('[ResetCodeController] aguardando código SMS', name: 'ResetCodeController');
    final sms = await SmsRetrieverService.startSmsRetrieval();
    if (sms == null) return;
    final match = RegExp(r'\d{6}').firstMatch(sms);
    if (match == null) return;
    log('[ResetCodeController] código SMS recebido', name: 'ResetCodeController');
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

  void confirm() {
    log('[ResetCodeController] a confirmar código para: $phone',
        name: 'ResetCodeController');
    if (code.length < 6) {
      showValidationError('Insere os 6 dígitos do código');
      return;
    }
    codeConfirmed.value = true;
  }

  @override
  void onClose() {
    for (final controller in digitControllers) {
      controller.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
