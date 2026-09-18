abstract class AppDatabaseClient {
  Future<void> init();

  Future<int> insert(String table, Map<String, dynamic> values);

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  });

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  });

  Future<int> delete(String table, {String? where, List<Object?>? whereArgs});

  Future<void> close();
}
