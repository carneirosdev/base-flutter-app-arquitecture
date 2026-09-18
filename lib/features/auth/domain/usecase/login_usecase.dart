import 'dart:developer';

import 'package:app_template/features/auth/domain/entities/user_entity.dart';
import 'package:app_template/features/auth/domain/repository/user_repository.dart';

/// Autentica o utilizador com telefone e palavra-passe.
///
/// Exemplo de referência da camada de domínio: um usecase representa uma
/// única operação de negócio, não guarda estado e não conhece a UI.
class LoginUseCase {
  final UserRepository _repository;

  LoginUseCase({required UserRepository repository})
      : _repository = repository;

  Future<UserEntity?> execute(String phone, String password) async {
    log('[LoginUseCase] executando login para: $phone', name: 'LoginUseCase');
    final user = await _repository.login(phone, password);
    log(
      '[LoginUseCase] login concluído para userId: ${user?.userId}',
      name: 'LoginUseCase',
    );
    return user;
  }
}
