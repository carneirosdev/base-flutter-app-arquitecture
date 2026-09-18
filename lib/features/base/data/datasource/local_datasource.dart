import 'package:app_template/core/database/app_database.dart';

abstract class LocalDatasource {
  AppDatabaseClient database;
  LocalDatasource({required this.database});
}
