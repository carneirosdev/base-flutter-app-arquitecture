abstract class AppCacheClient {
  Future<void> init();
  Future<void> put(String key, dynamic value, {Duration? expiry});
  Future<dynamic> get(String key);
  Future<void> delete(String key);
  Future<void> clear();
  Future<void> clearExpired();
}
