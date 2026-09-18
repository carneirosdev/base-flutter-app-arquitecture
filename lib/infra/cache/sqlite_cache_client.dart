import 'package:app_template/core/database/app_cache.dart';
import 'package:app_template/core/database/app_database.dart';

class SqliteCacheClient implements AppCacheClient {
  final AppDatabaseClient database;
  final String _table = 'cache';

  SqliteCacheClient({required this.database});

  @override
  Future<void> init() async {
    // Database init is handled elsewhere
  }

  @override
  Future<void> put(String key, dynamic value, {Duration? expiry}) async {
    final expiryTime = expiry != null
        ? DateTime.now().add(expiry).millisecondsSinceEpoch
        : null;

    // Remove a entrada existente antes de inserir a nova
    await delete(key);
    await database.insert(_table, {
      'key': key,
      'value': value.toString(),
      'expiry': expiryTime,
    });
  }

  @override
  Future<dynamic> get(String key) async {
    final results = await database.query(
      _table,
      where: 'key = ?',
      whereArgs: [key],
    );

    if (results.isEmpty) return null;

    final row = results.first;
    final expiry = row['expiry'] as int?;

    if (expiry != null && DateTime.now().millisecondsSinceEpoch > expiry) {
      await delete(key);
      return null;
    }

    return row['value'];
  }

  @override
  Future<void> delete(String key) async {
    await database.delete(_table, where: 'key = ?', whereArgs: [key]);
  }

  @override
  Future<void> clear() async {
    await database.delete(_table);
  }

  @override
  Future<void> clearExpired() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await database.delete(
      _table,
      where: 'expiry < ? AND expiry IS NOT NULL',
      whereArgs: [now],
    );
  }
}
