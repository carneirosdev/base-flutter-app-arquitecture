import 'dart:convert';
import 'dart:developer';

import 'package:app_template/core/network/app_http_client.dart';
import 'package:app_template/features/auth/data/datasource/local_auth_datasource.dart';
import 'package:app_template/features/auth/data/datasource/remote_auth_datasource.dart';
import 'package:app_template/features/auth/data/model/user_model.dart';
import 'package:app_template/features/auth/domain/entities/session_entity.dart';
import 'package:app_template/features/auth/domain/entities/user_entity.dart';
import 'package:app_template/features/auth/domain/repository/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final LocalAuthDatasource _local;
  final RemoteAuthDatasource _remote;
  final AppHttpClient _httpClient;

  UserRepositoryImpl({
    required LocalAuthDatasource local,
    required RemoteAuthDatasource remote,
    required AppHttpClient httpClient,
  })  : _local = local,
        _remote = remote,
        _httpClient = httpClient;

  @override
  Future<UserEntity?> getCurrentUser() async {
    log('[UserRepositoryImpl] a carregar utilizador da sessão local',
        name: 'UserRepositoryImpl');

    final accessToken = await _local.getAccessToken();
    if (accessToken == null) return null;

    final refreshToken = await _local.getRefreshToken();
    final userId = await _local.getUserId();
    final expiresIn = await _local.getExpiresIn();

    if (refreshToken == null || userId == null) return null;

    _httpClient.setAuthorizationToken(accessToken);
    _httpClient.setRefreshToken(refreshToken);

    return UserEntity(
      userId: userId,
      session: SessionEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: expiresIn,
      ),
    );
  }

  @override
  Future<void> loadUserPreferences() {
    log('[UserRepositoryImpl] loading user preferences',
        name: 'UserRepositoryImpl');
    throw UnimplementedError();
  }

  @override
  Future<UserEntity?> login(String phone, String password) async {
    try {
      log('[UserRepositoryImpl] iniciando login para: $phone',
          name: 'UserRepositoryImpl');

      final data = await _remote.login(phone, password);
      final sessionModel = SessionModel.fromJson(data as Map<String, dynamic>);
      final userId = _decodeJwtSub(sessionModel.accessToken) ?? '';

      final user = UserEntity(
        userId: userId,
        session: sessionModel.toEntity(),
      );

      await _local.saveSession(
        accessToken: user.session.accessToken,
        refreshToken: user.session.refreshToken,
        userId: user.userId,
        expiresIn: user.session.expiresIn,
      );
      _httpClient.setAuthorizationToken(user.session.accessToken);
      _httpClient.setRefreshToken(user.session.refreshToken);

      log('[UserRepositoryImpl] login bem-sucedido para userId: $userId',
          name: 'UserRepositoryImpl');
      return user;
    } catch (e, st) {
      log('[UserRepositoryImpl] erro no login: $e',
          name: 'UserRepositoryImpl', error: e, stackTrace: st);
      rethrow;
    }
  }

  String? _decodeJwtSub(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final data = jsonDecode(decoded) as Map<String, dynamic>;
      return data['sub'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> registerStart({
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      log('[UserRepositoryImpl] iniciando registo para: $phone',
          name: 'UserRepositoryImpl');

      await _remote.registerStart(name: name, phone: phone, password: password);

      log('[UserRepositoryImpl] registo iniciado para: $phone',
          name: 'UserRepositoryImpl');
    } catch (e, st) {
      log('[UserRepositoryImpl] erro no registo: $e',
          name: 'UserRepositoryImpl', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<UserEntity?> registerConfirm({
    required String phone,
    required String code,
  }) async {
    try {
      log('[UserRepositoryImpl] confirmando código para: $phone',
          name: 'UserRepositoryImpl');

      final data = await _remote.registerConfirm(phone: phone, code: code);
      final user = UserModel.fromJson(data as Map<String, dynamic>).toEntity();

      await _local.saveSession(
        accessToken: user.session.accessToken,
        refreshToken: user.session.refreshToken,
        userId: user.userId,
        expiresIn: user.session.expiresIn,
      );
      _httpClient.setAuthorizationToken(user.session.accessToken);
      _httpClient.setRefreshToken(user.session.refreshToken);

      log('[UserRepositoryImpl] sessão guardada para userId: ${user.userId}',
          name: 'UserRepositoryImpl');
      return user;
    } catch (e, st) {
      log('[UserRepositoryImpl] erro na confirmação: $e',
          name: 'UserRepositoryImpl', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> registerResend({required String phone}) async {
    try {
      log('[UserRepositoryImpl] reenviar OTP para: $phone',
          name: 'UserRepositoryImpl');
      await _remote.registerResend(phone: phone);
      log('[UserRepositoryImpl] OTP reenviado para: $phone',
          name: 'UserRepositoryImpl');
    } catch (e, st) {
      log('[UserRepositoryImpl] erro ao reenviar OTP: $e',
          name: 'UserRepositoryImpl', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> passwordResetStart({required String phone}) async {
    try {
      log('[UserRepositoryImpl] iniciando recuperação de senha para: $phone',
          name: 'UserRepositoryImpl');
      await _remote.passwordResetStart(phone: phone);
      log('[UserRepositoryImpl] código enviado para: $phone',
          name: 'UserRepositoryImpl');
    } catch (e, st) {
      log('[UserRepositoryImpl] erro na recuperação: $e',
          name: 'UserRepositoryImpl', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> passwordResetConfirm({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    try {
      log('[UserRepositoryImpl] confirmando recuperação para: $phone',
          name: 'UserRepositoryImpl');
      await _remote.passwordResetConfirm(
        phone: phone,
        code: code,
        newPassword: newPassword,
      );
      log('[UserRepositoryImpl] senha redefinida para: $phone',
          name: 'UserRepositoryImpl');
    } catch (e, st) {
      log('[UserRepositoryImpl] erro na confirmação de recuperação: $e',
          name: 'UserRepositoryImpl', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    log('[UserRepositoryImpl] a terminar sessão', name: 'UserRepositoryImpl');
    await _local.clearSession();
    _httpClient.setAuthorizationToken('');
    log('[UserRepositoryImpl] sessão terminada', name: 'UserRepositoryImpl');
  }

  @override
  Future<void> saveUserPreferences() {
    log('[UserRepositoryImpl] saving user preferences',
        name: 'UserRepositoryImpl');
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> updateUserProfile(UserEntity user) {
    log('[UserRepositoryImpl] updating profile for: ${user.userId}',
        name: 'UserRepositoryImpl');
    throw UnimplementedError();
  }
}
