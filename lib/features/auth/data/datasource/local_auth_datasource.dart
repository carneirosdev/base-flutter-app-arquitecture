import 'package:app_template/features/base/data/datasource/local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthDatasource extends LocalDatasource {
  final SharedPreferences sharedPreferences;

  static const _keyAccessToken = 'auth_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserId = 'user_id';
  static const _keyExpiresIn = 'session_expires_in';

  LocalAuthDatasource({
    required super.database,
    required this.sharedPreferences,
  });

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required int expiresIn,
  }) async {
    await sharedPreferences.setString(_keyAccessToken, accessToken);
    await sharedPreferences.setString(_keyRefreshToken, refreshToken);
    await sharedPreferences.setString(_keyUserId, userId);
    await sharedPreferences.setInt(_keyExpiresIn, expiresIn);
  }

  Future<int> getExpiresIn() async {
    return sharedPreferences.getInt(_keyExpiresIn) ?? 0;
  }

  Future<String?> getAccessToken() async {
    return sharedPreferences.getString(_keyAccessToken);
  }

  Future<String?> getRefreshToken() async {
    return sharedPreferences.getString(_keyRefreshToken);
  }

  Future<String?> getUserId() async {
    return sharedPreferences.getString(_keyUserId);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) async {
    await sharedPreferences.setString(_keyAccessToken, accessToken);
    await sharedPreferences.setString(_keyRefreshToken, refreshToken);
    await sharedPreferences.setInt(_keyExpiresIn, expiresIn);
  }

  Future<void> clearSession() async {
    await sharedPreferences.remove(_keyAccessToken);
    await sharedPreferences.remove(_keyRefreshToken);
    await sharedPreferences.remove(_keyUserId);
    await sharedPreferences.remove(_keyExpiresIn);
  }
}
