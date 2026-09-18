import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:app_template/core/router/app_route.dart';

import 'package:app_template/features/base/data/argument.dart';

@singleton
class NavigationService {
  void navigateToMain({int? index = 0}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var args = Argument();
      Get.offAllNamed(AppRoute.HOME, arguments: args);
    });
  }

  void goBack({dynamic result}) {
    Get.back(result: result);
  }

  void navigateToWelcome() {
    Get.offAllNamed(AppRoute.WELCOME);
  }

  void closeAllDialog() {
    Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
  }

  void logout() {
    Get.offAllNamed(AppRoute.LOGIN);
  }

  void navigateTo(String routeName, {Argument? arguments}) {
    Get.toNamed(routeName, arguments: arguments);
  }
}
