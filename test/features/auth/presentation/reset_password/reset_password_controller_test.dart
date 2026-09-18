import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_template/core/network/api_exception.dart';
import 'package:app_template/features/auth/domain/repository/user_repository.dart';
import 'package:app_template/features/auth/presentation/reset_password/reset_password_controller.dart';
import 'package:app_template/injector/dependency_injector.dart';
import 'package:app_template/services/navigation_service.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockNavigationService extends Mock implements NavigationService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockUserRepository mockRepository;
  late ResetPasswordController controller;

  setUp(() {
    Get.testMode = true;

    mockRepository = MockUserRepository();

    if (injector.isRegistered<UserRepository>()) {
      injector.unregister<UserRepository>();
    }
    if (injector.isRegistered<NavigationService>()) {
      injector.unregister<NavigationService>();
    }

    injector.registerSingleton<UserRepository>(mockRepository);
    injector.registerSingleton<NavigationService>(MockNavigationService());

    controller = ResetPasswordController();
    controller.phone = '+244923456789';
    controller.code = '123456';
  });

  tearDown(() {
    injector.unregister<UserRepository>();
    injector.unregister<NavigationService>();
    Get.reset();
  });

  group('resetPassword — validação', () {
    test('não chama API quando palavra-passe está vazia', () async {
      controller.newPasswordController.text = '';
      controller.confirmPasswordController.text = '';

      await controller.resetPassword();

      verifyNever(() => mockRepository.passwordResetConfirm(
            phone: any(named: 'phone'),
            code: any(named: 'code'),
            newPassword: any(named: 'newPassword'),
          ));
    });

    test('não chama API quando palavra-passe tem menos de 8 caracteres', () async {
      controller.newPasswordController.text = 'curta';
      controller.confirmPasswordController.text = 'curta';

      await controller.resetPassword();

      verifyNever(() => mockRepository.passwordResetConfirm(
            phone: any(named: 'phone'),
            code: any(named: 'code'),
            newPassword: any(named: 'newPassword'),
          ));
    });

    test('não chama API quando palavras-passe não coincidem', () async {
      controller.newPasswordController.text = 'senha12345';
      controller.confirmPasswordController.text = 'senha99999';

      await controller.resetPassword();

      verifyNever(() => mockRepository.passwordResetConfirm(
            phone: any(named: 'phone'),
            code: any(named: 'code'),
            newPassword: any(named: 'newPassword'),
          ));
    });
  });

  group('resetPassword — fluxo de sucesso', () {
    test('chama passwordResetConfirm com phone, code e newPassword corretos', () async {
      controller.newPasswordController.text = 'novaSenha123';
      controller.confirmPasswordController.text = 'novaSenha123';

      when(() => mockRepository.passwordResetConfirm(
            phone: '+244923456789',
            code: '123456',
            newPassword: 'novaSenha123',
          )).thenAnswer((_) async {});

      await controller.resetPassword();

      verify(() => mockRepository.passwordResetConfirm(
            phone: '+244923456789',
            code: '123456',
            newPassword: 'novaSenha123',
          )).called(1);
    });

    test('isLoading é false após sucesso', () async {
      controller.newPasswordController.text = 'novaSenha123';
      controller.confirmPasswordController.text = 'novaSenha123';

      when(() => mockRepository.passwordResetConfirm(
            phone: any(named: 'phone'),
            code: any(named: 'code'),
            newPassword: any(named: 'newPassword'),
          )).thenAnswer((_) async {});

      await controller.resetPassword();

      expect(controller.isLoading.value, isFalse);
    });
  });

  group('resetPassword — fluxo de erro', () {
    test('isLoading é false após erro de API', () async {
      controller.newPasswordController.text = 'novaSenha123';
      controller.confirmPasswordController.text = 'novaSenha123';

      when(() => mockRepository.passwordResetConfirm(
            phone: any(named: 'phone'),
            code: any(named: 'code'),
            newPassword: any(named: 'newPassword'),
          )).thenThrow(const ApiException(
        code: 'INVALID_CODE',
        message: 'Código inválido ou expirado',
        statusCode: 401,
      ));

      await controller.resetPassword();

      expect(controller.isLoading.value, isFalse);
    });
  });
}
