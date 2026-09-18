import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_template/features/auth/domain/repository/user_repository.dart';
import 'package:app_template/features/auth/presentation/reset_code/reset_code_controller.dart';
import 'package:app_template/injector/dependency_injector.dart';
import 'package:app_template/services/navigation_service.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockNavigationService extends Mock implements NavigationService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ResetCodeController controller;

  setUp(() {
    Get.testMode = true;

    if (injector.isRegistered<UserRepository>()) {
      injector.unregister<UserRepository>();
    }
    if (injector.isRegistered<NavigationService>()) {
      injector.unregister<NavigationService>();
    }

    injector.registerSingleton<UserRepository>(MockUserRepository());
    injector.registerSingleton<NavigationService>(MockNavigationService());

    controller = ResetCodeController();
    controller.phone = '+244923456789';
  });

  tearDown(() {
    injector.unregister<UserRepository>();
    injector.unregister<NavigationService>();
    Get.reset();
  });

  void fillCode(String digits) {
    for (var i = 0; i < digits.length && i < 6; i++) {
      controller.digitControllers[i].text = digits[i];
    }
  }

  group('confirm', () {
    test('não confirma quando código tem menos de 6 dígitos', () {
      fillCode('12345');

      controller.confirm();

      expect(controller.codeConfirmed.value, isFalse);
    });

    test('não confirma quando código está vazio', () {
      controller.confirm();

      expect(controller.codeConfirmed.value, isFalse);
    });

    test('define codeConfirmed como true com 6 dígitos válidos', () {
      fillCode('123456');

      controller.confirm();

      expect(controller.codeConfirmed.value, isTrue);
    });
  });

  group('code getter', () {
    test('retorna concatenação dos 6 dígitos', () {
      fillCode('654321');

      expect(controller.code, '654321');
    });

    test('retorna string vazia quando nenhum dígito inserido', () {
      expect(controller.code, '');
    });
  });

  group('onDigitChanged', () {
    test('avança foco ao inserir dígito em posição intermédia', () {
      expect(() => controller.onDigitChanged(2, '5'), returnsNormally);
    });

    test('não avança foco na última posição', () {
      expect(() => controller.onDigitChanged(5, '9'), returnsNormally);
    });

    test('recua foco ao apagar em posição intermédia', () {
      expect(() => controller.onDigitChanged(3, ''), returnsNormally);
    });

    test('não recua foco na primeira posição', () {
      expect(() => controller.onDigitChanged(0, ''), returnsNormally);
    });
  });
}
