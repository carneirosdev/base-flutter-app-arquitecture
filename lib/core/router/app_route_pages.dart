import 'package:app_template/core/router/app_route.dart';
import 'package:app_template/features/auth/presentation/welcome/welcome_page.dart';
import 'package:app_template/features/home/presentation/home/home_page.dart';
import 'package:get/get.dart';

/// Registo de todas as rotas da aplicação.
///
/// Cada nova rota precisa de uma constante em [AppRoute] e de uma entrada
/// em [routes].
class AppPages {
  static const INITIAL = AppRoute.WELCOME;

  static final routes = [
    GetPage(
      name: AppRoute.WELCOME,
      page: () => const WelcomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoute.HOME,
      page: () => const HomePage(),
      transition: Transition.fadeIn,
    ),
  ];
}
