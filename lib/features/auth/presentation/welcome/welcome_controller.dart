import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:app_template/core/router/app_route.dart';
import 'package:app_template/shared/base/controllers/base_controller.dart';

class WelcomeController extends BaseController {
  final _isSessionValid = false.obs;
  Completer<void>? _sessionCheckCompleter;

  @override
  void onInit() {
    super.onInit();
    _checkSession();
  }

  Future<void> _checkSession() async {
    _sessionCheckCompleter = Completer<void>();
    log('[WelcomeController] a verificar sessão', name: 'WelcomeController');
    try {
      final user = await userRepository.getCurrentUser();
      if (user != null) {
        log('[WelcomeController] sessão ativa → HOME', name: 'WelcomeController');
        _isSessionValid.value = true;
        _sessionCheckCompleter!.complete();
        unawaited(Get.offAllNamed(AppRoute.HOME));
      } else {
        log('[WelcomeController] sem sessão ativa', name: 'WelcomeController');
        _sessionCheckCompleter!.complete();
      }
    } catch (e, st) {
      log('[WelcomeController] erro ao verificar sessão: $e',
          name: 'WelcomeController', error: e, stackTrace: st);
      if (!_sessionCheckCompleter!.isCompleted) {
        _sessionCheckCompleter!.complete();
      }
    }
  }

  /// Retorna true se navegou para HOME, false se deve mostrar o login.
  Future<bool> handleEnterButton() async {
    log('[WelcomeController] botão entrar pressionado', name: 'WelcomeController');
    isLoading.value = true;
    try {
      final isPending = _sessionCheckCompleter != null &&
          !_sessionCheckCompleter!.isCompleted;
      if (isPending) {
        log('[WelcomeController] aguardando verificação de sessão',
            name: 'WelcomeController');
        await _sessionCheckCompleter!.future;
      }

      if (_isSessionValid.value) {
        log('[WelcomeController] sessão válida → HOME', name: 'WelcomeController');
        unawaited(Get.offAllNamed(AppRoute.HOME));
        return true;
      }

      log('[WelcomeController] sem sessão → mostrar login',
          name: 'WelcomeController');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}