import 'dart:developer';

import 'package:app_template/shared/base/controllers/base_controller.dart';

/// Controller do ecrã inicial.
///
/// Exemplo mínimo da camada de apresentação: apenas estado observável e
/// delegação para o repositório/usecases. Substitui o conteúdo pela lógica
/// do novo projeto.
class HomeController extends BaseController {
  Future<void> logout() async {
    log('[HomeController] iniciando logout', name: 'HomeController');
    try {
      isLoading.value = true;
      await userRepository.logout();
      log('[HomeController] logout concluído', name: 'HomeController');
      navigationService.navigateToWelcome();
    } catch (error, stackTrace) {
      showAppError(error);
      log(
        '[HomeController] erro no logout: $error',
        name: 'HomeController',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
