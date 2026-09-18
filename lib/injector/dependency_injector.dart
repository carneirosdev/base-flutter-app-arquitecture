import 'package:app_template/core/database/app_cache.dart';
import 'package:app_template/core/database/app_database.dart';
import 'package:app_template/core/network/app_http_client.dart';
import 'package:app_template/features/auth/data/datasource/local_auth_datasource.dart';
import 'package:app_template/features/auth/data/datasource/remote_auth_datasource.dart';
import 'package:app_template/features/auth/data/repository/user_repository_impl.dart';
import 'package:app_template/features/auth/domain/repository/user_repository.dart';
import 'package:app_template/features/auth/domain/usecase/login_usecase.dart';
import 'package:app_template/features/auth/presentation/login/login_controller.dart';
import 'package:app_template/features/auth/presentation/password_recovery/password_recovery_controller.dart';
import 'package:app_template/features/auth/presentation/reset_code/reset_code_controller.dart';
import 'package:app_template/features/auth/presentation/reset_password/reset_password_controller.dart';
import 'package:app_template/features/auth/presentation/signup/signup_controller.dart';
import 'package:app_template/features/auth/presentation/verification/verification_code_controller.dart';
import 'package:app_template/features/auth/presentation/welcome/welcome_controller.dart';
import 'package:app_template/features/home/presentation/home/home_controller.dart';
import 'package:app_template/infra/cache/sqlite_cache_client.dart';
import 'package:app_template/infra/database_impl/sqlite_app_database.dart';
import 'package:app_template/infra/network/dio_client.dart';
import 'package:app_template/services/local_notification_service.dart';
import 'package:app_template/services/navigation_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final injector = GetIt.instance;

/// Composição de dependências da aplicação.
///
/// Regista aqui todos os clientes, datasources, repositórios, usecases e
/// controllers — nunca instancies estas classes diretamente nos widgets.
class DependencyInjector {
  static Future<void> init() async {
    await dotenv.load(fileName: '.env');

    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    final appId = dotenv.env['APP_ID'];
    final appKey = dotenv.env['APP_KEY'];

    // ─── Core Services ──────────────────────────────────────────────────

    injector.registerLazySingleton(() => NavigationService());
    injector.registerLazySingleton(() => LocalNotificationService());

    injector.registerLazySingleton<AppHttpClient>(
      () => DioClient(
        baseUrl: baseUrl,
        appId: appId,
        appKey: appKey,
        onTokensRefreshed: ({
          required String accessToken,
          required String refreshToken,
          required int expiresIn,
        }) async {
          await injector.get<LocalAuthDatasource>().saveTokens(
                accessToken: accessToken,
                refreshToken: refreshToken,
                expiresIn: expiresIn,
              );
        },
        onSessionExpired: () async {
          await injector.get<LocalAuthDatasource>().clearSession();
        },
      ),
    );

    injector.registerLazySingleton<AppDatabaseClient>(() {
      final database = SqliteAppDatabase();
      database.init();
      return database;
    });

    injector.registerLazySingleton<AppCacheClient>(
      () => SqliteCacheClient(database: injector()),
    );

    final sharedPreferences = await SharedPreferences.getInstance();
    injector.registerLazySingleton(() => sharedPreferences);

    // ─── Data Sources ───────────────────────────────────────────────────

    injector.registerLazySingleton(
      () => LocalAuthDatasource(
        database: injector(),
        sharedPreferences: injector(),
      ),
    );

    injector.registerLazySingleton(
      () => RemoteAuthDatasource(clientClient: injector<AppHttpClient>()),
    );

    // ─── Repositories ───────────────────────────────────────────────────

    injector.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        local: injector<LocalAuthDatasource>(),
        remote: injector<RemoteAuthDatasource>(),
        httpClient: injector<AppHttpClient>(),
      ),
    );

    // ─── UseCases ───────────────────────────────────────────────────────

    injector.registerLazySingleton(
      () => LoginUseCase(repository: injector<UserRepository>()),
    );

    // ─── Controllers ────────────────────────────────────────────────────

    injector.registerLazySingleton(() => WelcomeController());
    injector.registerLazySingleton(() => LoginController());
    injector.registerLazySingleton(() => SignUpController());
    injector.registerLazySingleton(() => VerificationCodeController());
    injector.registerLazySingleton(() => PasswordRecoveryController());
    injector.registerLazySingleton(() => ResetCodeController());
    injector.registerLazySingleton(() => ResetPasswordController());
    injector.registerLazySingleton(() => HomeController());
  }
}
