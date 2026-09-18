import 'package:app_template/core/network/app_http_client.dart';

abstract class RemoteDatasource {
  AppHttpClient clientClient;
  RemoteDatasource({required this.clientClient});
}
