/// Design system da aplicação.
///
/// É o único ponto de entrada para cores, espaçamentos, tipografia, tema e
/// componentes visuais. Importa-o sempre com o alias `kit`:
///
/// ```dart
/// import 'package:app_template/core/design_system/design_system.dart' as kit;
/// ```
///
/// Cada projeto tem o seu design system: adapta os tokens e os componentes
/// daqui, ou substitui esta pasta por um package próprio mantendo a mesma
/// superfície pública para não tocar nos ecrãs.
library;

// Tokens
export 'package:app_template/core/design_system/tokens/colors.dart';
export 'package:app_template/core/design_system/tokens/radius.dart';
export 'package:app_template/core/design_system/tokens/shadows.dart';
export 'package:app_template/core/design_system/tokens/spacing.dart';
export 'package:app_template/core/design_system/tokens/typography.dart';

// Tema
export 'package:app_template/core/design_system/theme/app_theme.dart';

// Componentes
export 'package:app_template/core/design_system/components/app_button.dart';
export 'package:app_template/core/design_system/components/app_password_field.dart';
export 'package:app_template/core/design_system/components/app_text_field.dart';
