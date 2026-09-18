# Template Base — Arquitetura Flutter

Template de arranque para novos projetos Flutter: Clean Architecture,
GetX para estado e navegação, `get_it` para injeção de dependências,
Dio para rede, SQLite para persistência local e um design system próprio,
sem dependências de UI externas.

O que vem no template é **estrutura**, não domínio: a única feature funcional
é `auth`, incluída como exemplo de referência das quatro camadas.

## Como iniciar um projeto novo

1. **Copia o repositório** (ou usa-o como template no GitHub) e entra na pasta.

2. **Renomeia o package.** Muda `name: app_template` no `pubspec.yaml` e
   substitui `package:app_template/` por `package:<novo_nome>/` em todos os
   ficheiros `.dart`:

   ```bash
   grep -rl 'package:app_template/' lib test \
     | xargs sed -i 's|package:app_template/|package:<novo_nome>/|g'
   ```

3. **Gera as pastas nativas** com o bundle id do projeto — o template não as
   inclui de propósito, para não arrastar identificadores de outro projeto:

   ```bash
   flutter create . --org com.exemplo --project-name <novo_nome> \
     --platforms android,ios
   ```

4. **Configura o ambiente:**

   ```bash
   cp .env.example .env    # preenche API_BASE_URL, APP_ID, APP_KEY
   flutter pub get
   ```

5. **Ajusta o prefixo das rotas** em `lib/core/router/app_route.dart`
   (`routePrefix`).

6. **Coloca os assets** do projeto em `assets/` (o ecrã de boas-vindas
   espera `assets/img_logo.png`).

7. **Atualiza o `CLAUDE.md`**: apaga a caixa de instruções do topo e
   documenta aí as regras específicas do novo projeto.

8. Corre a app:

   ```bash
   flutter run
   ```

## Estrutura

```
lib/
├── main.dart                 # bootstrap: DI, notificações, GetMaterialApp
├── core/                     # abstrações — sem dependências de implementação
│   ├── design_system/        # tokens, tema e componentes visuais
│   ├── network/              # AppHttpClient, BaseResponse, ApiException
│   ├── error/exceptions/     # exceções de domínio e de HTTP
│   ├── database/             # AppDatabaseClient, AppCacheClient
│   ├── router/               # AppRoute (constantes) + AppPages (GetPage)
│   └── upgrade/              # mensagens PT do diálogo de atualização
├── infra/                    # implementações concretas do core
│   ├── network/dio_client.dart
│   ├── database_impl/        # SQLite + migrações
│   └── cache/                # cache com expiração sobre SQLite
├── features/
│   ├── base/                 # contratos partilhados (Local/RemoteDatasource…)
│   ├── auth/                 # exemplo de referência das 4 camadas
│   └── home/                 # ecrã inicial de arranque (substituir)
├── injector/                 # composição de dependências (get_it)
├── services/                 # navegação, notificações, conectividade, SMS
├── shared/                   # BaseController, BaseViewState, widgets comuns
└── l10n/                     # ficheiros ARB
```

A dependência entre camadas é sempre num sentido:
`presentation → domain → data`. O `core` não conhece nenhuma feature;
o `infra` implementa o `core`.

## Regras do projeto

As regras obrigatórias (design system primeiro, TDD, logs estruturados,
Object Calisthenics, tratamento de erros da API) estão em
[CLAUDE.md](CLAUDE.md). Lê antes de escrever código.

## Design system

O design system vive dentro do projeto, em `lib/core/design_system/` — não há
package externo, para que cada projeto tenha o seu. Importa-se sempre pelo
barrel, com o alias `kit`:

```dart
import 'package:app_template/core/design_system/design_system.dart' as kit;
```

```
lib/core/design_system/
├── design_system.dart        # barrel — o único import permitido
├── tokens/                   # colors, spacing, radius, shadows, typography
├── theme/app_theme.dart      # ThemeData light/dark derivado dos tokens
└── components/               # AppButton, AppTextField, AppPasswordField
```

O tema da app é `kit.AppTheme.light` / `kit.AppTheme.dark`, aplicado no
`main.dart`. Para adaptar a identidade visual do projeto começa pelos tokens
em `tokens/colors.dart` e `tokens/typography.dart` — o tema e os componentes
derivam daí. A família de letra é Inter, carregada via `google_fonts`.

Se preferires extrair o design system para um package partilhado entre
projetos, mantém a mesma superfície pública (`kit.AppColors`, `kit.AppButton`,
…) e só o import do barrel muda.

## Testes

```bash
flutter test
flutter test --coverage
```

Os testes espelham a estrutura de `lib/`. Em `test/features/auth/` estão
exemplos de testes de controller com `Get.testMode = true` e fakes.
