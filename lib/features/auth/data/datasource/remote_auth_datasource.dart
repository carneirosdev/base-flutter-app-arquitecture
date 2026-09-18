import 'dart:developer';

import 'package:app_template/core/network/api_exception.dart';
import 'package:app_template/features/base/data/datasource/remote_datasource.dart';

class RemoteAuthDatasource extends RemoteDatasource {
  final String _baseUrl = '/auth';

  RemoteAuthDatasource({required super.clientClient});

  Future<dynamic> login(String phone, String password) async {
    log('[RemoteAuthDatasource] iniciando login para: $phone',
        name: 'RemoteAuthDatasource');

    final response = await clientClient.post(
      '$_baseUrl/login',
      body: {'phone': phone, 'password': password},
    );

    log('[RemoteAuthDatasource] login bem-sucedido para: $phone',
        name: 'RemoteAuthDatasource');
    return response.data;
  }

  Future<void> registerStart({
    required String name,
    required String phone,
    required String password,
  }) async {
    log('[RemoteAuthDatasource] iniciando registo para: $phone',
        name: 'RemoteAuthDatasource');

    final response = await clientClient.post(
      '$_baseUrl/register/start',
      body: {'name': name, 'phone': phone, 'password': password, 'email': null},
    );

    if (response.statusCode! > 299) {
      throw Exception('Falha no registo: ${response.message}');
    }
    log('[RemoteAuthDatasource] registo iniciado com sucesso para: $phone',
        name: 'RemoteAuthDatasource');
  }

  Future<void> passwordResetStart({required String phone}) async {
    log('[RemoteAuthDatasource] iniciando recuperação de senha para: $phone',
        name: 'RemoteAuthDatasource');
    await clientClient.post(
      '$_baseUrl/password/reset/start',
      body: {'phone': phone},
    );
    log('[RemoteAuthDatasource] código de recuperação enviado para: $phone',
        name: 'RemoteAuthDatasource');
  }

  Future<void> passwordResetConfirm({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    log('[RemoteAuthDatasource] confirmando recuperação de senha para: $phone',
        name: 'RemoteAuthDatasource');
    await clientClient.post(
      '$_baseUrl/password/reset/confirm',
      body: {'phone': phone, 'code': code, 'newPassword': newPassword},
    );
    log('[RemoteAuthDatasource] senha redefinida para: $phone',
        name: 'RemoteAuthDatasource');
  }

  Future<void> registerResend({required String phone}) async {
    log('[RemoteAuthDatasource] reenviar OTP para: $phone',
        name: 'RemoteAuthDatasource');
    await clientClient.post(
      '$_baseUrl/register/resend',
      body: {'phone': phone},
    );
    log('[RemoteAuthDatasource] OTP reenviado para: $phone',
        name: 'RemoteAuthDatasource');
  }

  Future<dynamic> registerConfirm({
    required String phone,
    required String code,
  }) async {
    log('[RemoteAuthDatasource] confirmando código para: $phone',
        name: 'RemoteAuthDatasource');
    try {
      final response = await clientClient.post(
        '$_baseUrl/register/confirm',
        body: {'phone': phone, 'code': code},
      );

      log('[RemoteAuthDatasource] confirmação bem-sucedida para: $phone',
          name: 'RemoteAuthDatasource');
      return response.data;
    } on ApiException catch (e) {
      if (e.code == 'UNAUTHORIZED') {
        throw ApiException(
          code: 'INVALID_CODE',
          message: 'O código é inválido ou já expirou. Tenta novamente.',
          statusCode: e.statusCode,
        );
      }
      rethrow;
    }
  }
}
