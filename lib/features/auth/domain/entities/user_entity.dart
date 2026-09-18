import 'package:app_template/features/auth/domain/entities/session_entity.dart';

/// Utilizador autenticado e a respetiva sessão.
class UserEntity {
  final String userId;
  final SessionEntity session;

  UserEntity({required this.userId, required this.session});
}
