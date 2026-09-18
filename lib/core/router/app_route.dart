/// Prefixo de todas as rotas da aplicação.
///
/// Renomeia para o nome do novo projeto ao inicializar o template.
const String routePrefix = '/app';

/// Constantes de rota da aplicação.
///
/// Usa sempre estas constantes na navegação — nunca strings literais.
/// Cada nova rota registada em [AppPages] deve ter aqui a sua constante.
class AppRoute {
  static const String SPLASH = '$routePrefix/splash';
  static const String ONBOARDING = '$routePrefix/onboarding';
  static const String WELCOME = '$routePrefix/welcome';
  static const String LOGIN = '$routePrefix/login';
  static const String SIGN_UP = '$routePrefix/signup';
  static const String HOME = '$routePrefix/home';
}
