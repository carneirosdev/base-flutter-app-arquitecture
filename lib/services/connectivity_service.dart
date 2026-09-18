import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService {
  final _connectivity = Connectivity();

  final isOnline = false.obs;

  bool _isResultOnline(List<ConnectivityResult> results) {
    return results.isNotEmpty &&
        results.any((r) => r != ConnectivityResult.none);
  }

  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    isOnline.value = _isResultOnline(results);
    return isOnline.value;
  }

  void init() {
    checkConnectivity();
    _connectivity.onConnectivityChanged.listen((results) {
      final online = _isResultOnline(results);
      isOnline.value = online;
      log('ConnectivityService: estado → ${online ? 'online' : 'offline'}');
    });
  }
}
