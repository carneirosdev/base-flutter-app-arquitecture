import 'dart:async';

import 'package:app_template/injector/dependency_injector.dart';
import 'package:app_template/shared/base/controllers/base_controller.dart';
import 'package:flutter/material.dart';

/// Estado base para páginas com `StatefulWidget` ligadas a um controller.
///
/// Resolve o controller a partir do injector e cancela automaticamente as
/// subscrições registadas com [listenTo] quando a página é destruída.
abstract class BaseViewState<T extends StatefulWidget, C extends BaseController>
    extends State<T> with AutomaticKeepAliveClientMixin {
  late final C controller = injector.get<C>();

  final List<StreamSubscription<dynamic>> _subscriptions = [];

  @override
  bool get wantKeepAlive => true;

  /// Regista uma subscrição para cancelamento automático no [dispose].
  void listenTo(StreamSubscription<dynamic> subscription) {
    _subscriptions.add(subscription);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
