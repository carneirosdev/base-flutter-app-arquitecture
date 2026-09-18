import 'package:app_template/infra/database_impl/tables/cache_table.dart';
import 'package:sqflite/sqflite.dart';

Future<void> createTables(Database db, int version, String path) async {
  await db.execute(CacheTable.create);
}

Future<void> migrate(Database db) async {
  //Add Data Migrations
}
