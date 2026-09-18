import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_template/core/network/api_exception.dart';
import 'package:app_template/features/auth/domain/entities/user_entity.dart';
import 'package:app_template/features/auth/domain/repository/user_repository.dart';
import 'package:app_template/features/auth/presentation/password_recovery/password_recovery_controller.dart';
import 'package:app_template/injector/dependency_injector.dart';
import 'package:app_template/services/navigation_service.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockNavigationService extends Mock implements NavigationService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockUserRepository mockRepository;
  late PasswordRecoveryController controller;

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

    controller = PasswordRecoveryController();
  });

  tearDown(() {
    injector.unregister<UserRepository>();
    injector.unregister<NavigationService>();
    Get.reset();
  });

  group('sendResetCode', () {
    test('mostra erro de validação quando telefone está vazio', () async {
      controller.phoneTextController.text = '';

      await controller.sendResetCode();

      verifyNever(() => mockRepository.passwordResetStart(phone: any(named: 'phone')));
    });

    test('chama passwordResetStart com telefone formatado quando válido', () async {
      controller.phoneTextController.text = '923456789';
      controller.selectedDialCode = '+244';

      when(() => mockRepository.passwordResetStart(phone: '+244923456789'))
          .thenAnswer((_) async {});

      await controller.sendResetCode();

      verify(() => mockRepository.passwordResetStart(phone: '+244923456789')).called(1);
    });

    test('define codeSent como true após sucesso', () async {
      controller.phoneTextController.text = '923456789';

      when(() => mockRepository.passwordResetStart(phone: any(named: 'phone')))
          .thenAnswer((_) async {});

      await controller.sendResetCode();

      expect(controller.codeSent.value, isTrue);
    });

    test('não define codeSent quando API falha', () async {
      controller.phoneTextController.text = '923456789';

      when(() => mockRepository.passwordResetStart(phone: any(named: 'phone')))
          .thenThrow(const ApiException(
        code: 'NOT_FOUND',
        message: 'Número não encontrado',
        statusCode: 404,
      ));

      await controller.sendResetCode();

      expect(controller.codeSent.value, isFalse);
    });

    test('isLoading é false após conclusão (sucesso)', () async {
      controller.phoneTextController.text = '923456789';

      when(() => mockRepository.passwordResetStart(phone: any(named: 'phone')))
          .thenAnswer((_) async {});

      await controller.sendResetCode();

      expect(controller.isLoading.value, isFalse);
    });

    test('isLoading é false após conclusão (erro)', () async {
      controller.phoneTextController.text = '923456789';

      when(() => mockRepository.passwordResetStart(phone: any(named: 'phone')))
          .thenThrow(Exception('erro'));

      await controller.sendResetCode();

      expect(controller.isLoading.value, isFalse);
    });
  });

  group('dispose', () {
    test('dispõe phoneTextController ao fechar', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}

// ignore_for_file: avoid_implementing_value_types
class FakeUserEntity extends Fake implements UserEntity {}
