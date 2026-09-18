import 'package:app_template/core/network/base_response.dart';

abstract class AppHttpClient {
  late String baseUrl;
  late Map<String, String> defaultHeaders = {};
  late int timeoutInSeconds = 30;

  Future<BaseResponse> get<T>(String url, {Map<String, String>? headers});

  Future<BaseResponse> put<T>(
    String url, {
    required Object body,
    Map<String, String>? headers,
  });

  Future<BaseResponse> post(
    String url, {
    required Object body,
    Map<String, String>? headers,
  });

  Future<BaseResponse> delete(String url, {Map<String, String>? headers});

  void setAuthorizationToken(String token);

  void setRefreshToken(String token);
}
