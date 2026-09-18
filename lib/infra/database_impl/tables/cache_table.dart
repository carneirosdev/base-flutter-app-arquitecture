class CacheTable {
  static const String tableName = 'cache';

  static const String create =
      '''
    CREATE TABLE $tableName (
      key TEXT PRIMARY KEY,
      value TEXT,
      expiry INTEGER
    )
  ''';
}
