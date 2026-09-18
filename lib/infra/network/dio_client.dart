import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:app_template/core/network/api_exception.dart';
import 'package:app_template/core/network/app_http_client.dart';
import 'package:app_template/core/network/base_response.dart';
import 'package:app_template/core/router/app_route.dart';

class DioClient extends AppHttpClient {
  final Dio _client = Dio();
  late final Dio _refreshClient;

  String? _bearerToken;
  String? _refreshToken;

  final Future<void> Function({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  })? _onTokensRefreshed;

  final Future<void> Function()? _onSessionExpired;

  DioClient({
    required String baseUrl,
    String? appId,
    String? appKey,
    Future<void> Function({
      required String accessToken,
      required String refreshToken,
      required int expiresIn,
    })? onTokensRefreshed,
    Future<void> Function()? onSessionExpired,
  })  : _onTokensRefreshed = onTokensRefreshed,
        _onSessionExpired = onSessionExpired {
    this.baseUrl = baseUrl;
    defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final timeout = Duration(seconds: timeoutInSeconds);

    _client.options.baseUrl = baseUrl;
    _client.options.contentType = 'application/json';
    _client.options.headers.addAll(defaultHeaders);
    _client.options.connectTimeout = timeout;
    _client.options.receiveTimeout = timeout;
    _client.options.sendTimeout = timeout;

    _refreshClient = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        contentType: 'application/json',
        connectTimeout: timeout,
        receiveTimeout: timeout,
        sendTimeout: timeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-App-Id': appId ?? '',
          'X-App-Key': appKey ?? '',
        },
      ),
    );

    _client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (appId != null) options.headers['X-App-Id'] = appId;
          if (appKey != null) options.headers['X-App-Key'] = appKey;
          if (_bearerToken != null) {
            options.headers['Authorization'] = 'Bearer $_bearerToken';
          }
          handler.next(options);
        },
      ),
    );

    _client.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (error, handler) async {
          final isUnauthorized = error.response?.statusCode == 401;
          final isRetry = error.requestOptions.extra['_isRetry'] == true;

          if (!isUnauthorized || isRetry || _refreshToken == null) {
            handler.next(error);
            return;
          }

          try {
            log('[DioClient] token expirado, a renovar…', name: 'DioClient');

            final response = await _refreshClient.post(
              '/auth/refresh',
              data: jsonEncode({'refreshToken': _refreshToken}),
            );

            final data = response.data as Map<String, dynamic>;
            final newAccessToken = data['accessToken'] as String;
            final newRefreshToken = data['refreshToken'] as String;
            final expiresIn = data['expiresIn'] as int;

            _bearerToken = newAccessToken;
            _refreshToken = newRefreshToken;

            await _onTokensRefreshed?.call(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
              expiresIn: expiresIn,
            );

            log('[DioClient] token renovado com sucesso', name: 'DioClient');

            final retryOptions = error.requestOptions
              ..headers['Authorization'] = 'Bearer $newAccessToken'
              ..extra['_isRetry'] = true;

            final retryResponse = await _client.fetch(retryOptions);
            handler.resolve(retryResponse);
          } catch (e) {
            log('[DioClient] falha ao renovar token: $e', name: 'DioClient');
            _bearerToken = null;
            _refreshToken = null;
            await _onSessionExpired?.call();
            unawaited(Get.offAllNamed(AppRoute.WELCOME));
            handler.next(error);
          }
        },
      ),
    );
  }

  @override
  void setAuthorizationToken(String token) {
    _bearerToken = token;
    _client.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void setRefreshToken(String token) {
    _refreshToken = token;
  }

  @override
  Future<BaseResponse<dynamic>> get<T>(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final data = await _client.get(url, options: Options(headers: headers));
      return BaseResponse<dynamic>(
        data: data.data,
        statusCode: data.statusCode ?? 0,
        message: data.statusMessage,
      );
    } catch (e) {
      if (e is DioException) throw _toDomainException(e, url);
      rethrow;
    }
  }

  @override
  Future<BaseResponse<dynamic>> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final data =
          await _client.delete(url, options: Options(headers: headers));
      return BaseResponse<dynamic>(
        data: data.data,
        statusCode: data.statusCode ?? 0,
        message: data.statusMessage,
      );
    } catch (e) {
      if (e is DioException) throw _toDomainException(e, url);
      rethrow;
    }
  }

  @override
  Future<BaseResponse<dynamic>> post(
    String url, {
    required Object body,
    Map<String, String>? headers,
  }) async {
    try {
      final finalUrl = url.startsWith('http') ? url : '$baseUrl$url';
      log('[DioClient] POST $finalUrl body: $body', name: 'DioClient');

      final data = await _client.post(
        finalUrl,
        data: jsonEncode(body),
        options: Options(contentType: 'application/json', headers: headers),
      );

      return BaseResponse<dynamic>(
        data: data.data,
        statusCode: data.statusCode ?? 0,
        message: data.statusMessage,
      );
    } catch (e) {
      if (e is DioException) throw _toDomainException(e, url);
      log('[DioClient] erro inesperado em $url: $e', name: 'DioClient');
      rethrow;
    }
  }

  @override
  Future<BaseResponse<dynamic>> put<T>(
    String url, {
    required Object body,
    Map<String, String>? headers,
  }) async {
    try {
      final data = await _client.put(
        url,
        data: jsonEncode(body),
        options: Options(contentType: 'application/json', headers: headers),
      );
      return BaseResponse<dynamic>(
        data: data.data,
        statusCode: data.statusCode ?? 0,
        message: data.statusMessage,
      );
    } catch (e) {
      if (e is DioException) throw _toDomainException(e, url);
      rethrow;
    }
  }

  ApiException _toDomainException(DioException error, String url) {
    final response = error.response;

    if (response != null) {
      final data = response.data;
      final statusCode = response.statusCode ?? 0;

      if (data is Map<String, dynamic> && data.containsKey('message')) {
        final details = data['details'] is Map<String, dynamic>
            ? data['details'] as Map<String, dynamic>
            : null;
        log('[DioClient] erro do servidor ($url): ${data['message']}',
            name: 'DioClient');
        return ApiException(
          code: data['code'] as String? ?? 'ERROR',
          message: data['message'] as String,
          statusCode: statusCode,
          details: details,
        );
      }

      log('[DioClient] resposta sem estrutura em $url: $data',
          name: 'DioClient');
      return ApiException(
        code: 'ERROR',
        message: 'Ocorreu um erro inesperado. Tenta novamente.',
        statusCode: statusCode,
      );
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown) {
      return const ApiException(
        code: 'NETWORK_ERROR',
        message: 'Sem ligação à internet. Verifica a tua rede.',
        statusCode: 0,
      );
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const ApiException(
        code: 'TIMEOUT',
        message: 'A ligação expirou. Tenta novamente.',
        statusCode: 0,
      );
    }

    return const ApiException(
      code: 'ERROR',
      message: 'Ocorreu um erro inesperado. Tenta novamente.',
      statusCode: 0,
    );
  }
}
