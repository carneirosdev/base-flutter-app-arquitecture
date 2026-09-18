import 'package:app_template/core/router/app_route.dart';
import 'package:app_template/core/router/app_route_pages.dart';
import 'package:app_template/core/upgrade/upgrader_messages_pt.dart';
import 'package:app_template/injector/dependency_injector.dart';
import 'package:app_template/services/local_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;
import 'package:upgrader/upgrader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjector.init();

  final notificationService = injector.get<LocalNotificationService>();
  await notificationService.initialize();
  await notificationService.requestPermissions();

  runApp(const App(initialRoute: AppRoute.WELCOME));
}

/// Raiz da aplicação.
///
/// O tema vem inteiramente do design system (`kit.AppTheme`) — não definas
/// temas inline nem cores fora dos tokens do kit.
class App extends StatelessWidget {
  const App({super.key, required this.initialRoute, this.isDarkMode = false});

  final String initialRoute;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'App Template',
      debugShowCheckedModeBanner: false,
      theme: kit.AppTheme.light,
      darkTheme: kit.AppTheme.dark,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      fallbackLocale: const Locale('en'),
      builder: (context, child) => UpgradeAlert(
        upgrader: Upgrader(
          messages: UpgraderMessagesPt(),
          durationUntilAlertAgain: const Duration(days: 1),
        ),
        barrierDismissible: false,
        showIgnore: false,
        showReleaseNotes: true,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
