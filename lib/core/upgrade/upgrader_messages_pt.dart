import 'package:upgrader/upgrader.dart';

/// Mensagens personalizadas em Português para o diálogo de atualização.
class UpgraderMessagesPt extends UpgraderMessages {
  @override
  String get buttonTitleIgnore => 'Ignorar';

  @override
  String get buttonTitleLater => 'Mais Tarde';

  @override
  String get buttonTitleUpdate => 'Atualizar Agora';

  @override
  String get releaseNotes => 'Novidades';

  @override
  String get body =>
      'Uma nova versão do {{appName}} está disponível! '
      'A versão {{currentAppStoreVersion}} já está disponível, '
      'você tem a versão {{currentInstalledVersion}}.';

  @override
  String get title => 'Atualização Disponível';

  @override
  String get prompt => 'Deseja atualizar agora?';
}
