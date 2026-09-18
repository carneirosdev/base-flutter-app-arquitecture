import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_template/core/network/api_exception.dart';
import 'package:app_template/features/auth/domain/repository/user_repository.dart';
import 'package:app_template/injector/dependency_injector.dart';

import 'package:app_template/services/navigation_service.dart';

class BaseController extends GetxController {
  @protected
  final NavigationService navigationService = injector.get<NavigationService>();
  @protected
  UserRepository userRepository = injector.get<UserRepository>();

  var isLoading = false.obs;

  @protected
  void showValidationError(String message) {
    if (Get.context == null || Get.isSnackbarOpen) return;
    Get.snackbar(
      'Atenção',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  @protected
  void showSuccess(String title, String message) {
    if (Get.context == null || Get.isSnackbarOpen) return;
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  @protected
  void showAppError(dynamic error) {
    final apiError = error is ApiException ? error : null;
    final title = apiError?.userFriendlyTitle ?? 'Erro';
    final message = _formatErrorMessage(apiError);
    final duration = _errorDuration(apiError);

    if (Get.context == null || Get.isSnackbarOpen) return;
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: duration,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  String _formatErrorMessage(ApiException? error) {
    if (error == null) return 'Ocorreu um erro inesperado. Tenta novamente.';
    final details = error.details;
    final message = error.userFriendlyMessage;
    if (details == null || details.isEmpty) return message;
    final bullets = details.values.map((value) => '• $value').join('\n');
    return '$message\n$bullets';
  }

  Duration _errorDuration(ApiException? error) {
    final detailCount = error?.details?.length ?? 0;
    final seconds = (3 + detailCount).clamp(3, 6);
    return Duration(seconds: seconds);
  }
}
