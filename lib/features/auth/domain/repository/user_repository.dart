import 'package:app_template/features/auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<void> logout();
  Future<void> loadUserPreferences();
  Future<void> saveUserPreferences();
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> updateUserProfile(UserEntity user);
  Future<UserEntity?> login(String phone, String password);
  Future<void> registerStart({
    required String name,
    required String phone,
    required String password,
  });
  Future<UserEntity?> registerConfirm({
    required String phone,
    required String code,
  });
  Future<void> registerResend({required String phone});
  Future<void> passwordResetStart({required String phone});
  Future<void> passwordResetConfirm({
    required String phone,
    required String code,
    required String newPassword,
  });
}
