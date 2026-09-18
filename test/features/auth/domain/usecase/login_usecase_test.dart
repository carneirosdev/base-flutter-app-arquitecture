import 'package:app_template/core/network/api_exception.dart';
import 'package:app_template/features/auth/domain/entities/session_entity.dart';
import 'package:app_template/features/auth/domain/entities/user_entity.dart';
import 'package:app_template/features/auth/domain/repository/user_repository.dart';
import 'package:app_template/features/auth/domain/usecase/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository repository;
  late LoginUseCase useCase;

  final user = UserEntity(
    userId: 'user-1',
    session: SessionEntity(
      accessToken: 'access',
      refreshToken: 'refresh',
      expiresIn: 3600,
    ),
  );

  setUp(() {
    repository = MockUserRepository();
    useCase = LoginUseCase(repository: repository);
  });

  test('delega para o repositório e devolve o utilizador autenticado',
      () async {
    when(() => repository.login('+244900000000', 'secret'))
        .thenAnswer((_) async => user);

    final result = await useCase.execute('+244900000000', 'secret');

    expect(result, user);
    verify(() => repository.login('+244900000000', 'secret')).called(1);
  });

  test('devolve null quando o repositório não autentica', () async {
    when(() => repository.login(any(), any())).thenAnswer((_) async => null);

    final result = await useCase.execute('+244900000000', 'secret');

    expect(result, isNull);
  });

  test('propaga a ApiException vinda do repositório', () async {
    when(() => repository.login(any(), any())).thenThrow(
      const ApiException(
        code: 'AUTH_INVALID_CREDENTIALS',
        message: 'Credenciais inválidas',
        statusCode: 401,
      ),
    );

    expect(
      () => useCase.execute('+244900000000', 'errada'),
      throwsA(isA<ApiException>()),
    );
  });
}
