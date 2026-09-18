# Template Base Flutter — Regras do Projeto para Claude

> Este repositório é um **template**. Ao iniciar um projeto novo:
> 1. Renomeia `name: app_template` no `pubspec.yaml` e substitui
>    `package:app_template/` em todos os imports.
> 2. Ajusta `routePrefix` em `lib/core/router/app_route.dart`.
> 3. Corre `flutter create .` para gerar `android/` e `ios/` com o
>    `applicationId`/bundle id do novo projeto.
> 4. Copia `.env.example` para `.env` e preenche as variáveis.
> 5. Adapta o design system em `lib/core/design_system/` à marca do projeto
>    (tokens, tema e componentes).
> 6. Coloca os assets do projeto em `assets/` (incluindo `img_logo.png`).
> 7. Apaga esta caixa e documenta aqui as regras específicas do projeto
>    (endpoints da API, domínio, integrações).

### Nunca faças hardcoded de cores, styles, tipografia, espaçamento ou outros — vai sempre buscar aos tokens do design system

## 0. Core em primeiro lugar — antes de qualquer implementação

Antes de implementar qualquer funcionalidade de rede, erro, base de dados ou routing, **verifica sempre `lib/core/`** para ver se a abstração já existe.

### Rede (`lib/core/network/`)

| Classe | Ficheiro | Uso |
|---|---|---|
| `AppHttpClient` | `app_http_client.dart` | Interface HTTP — `get`, `post`, `put`, `delete`, `setAuthorizationToken` |
| `BaseResponse<T>` | `base_response.dart` | Envelope genérico de resposta — `data`, `message`, `statusCode` |
| `ApiException` | `api_exception.dart` | Exceção de API com `code`, `message`, `statusCode`, `details`, `userFriendlyTitle` |

A implementação está em `lib/infra/network/dio_client.dart`.

**Nunca crias um cliente HTTP próprio** — usa `AppHttpClient`. **Nunca lances exceções de rede brutas** — usa `ApiException`.

### Erros (`lib/core/error/`)

| Exceção | Quando usar |
|---|---|
| `ApiException` | Erros HTTP vindos do servidor |
| `AuthUserNotFound` | Utilizador não encontrado |
| `AuthWrongPassword` | Password incorreta |
| `AuthWeakPassword` | Password demasiado fraca |
| `AuthInvalidEmail` | Email inválido |
| `ActionRequiresAuth` | 401 Não autorizado |
| `BadRequestException` | 400 Dados inválidos |
| `ForbiddenException` | 403 Sem permissão |
| `NotFoundException` | 404 Não encontrado |
| `ConflictException` | 409 Conflito |

As exceções de autenticação vivem em `auth_exceptions.dart` e são reexportadas por `exceptions.dart`.

**Nunca crias novas classes de exceção** sem verificar se já existe uma equivalente aqui.

### Base de dados (`lib/core/database/`)

| Classe | Ficheiro | Uso |
|---|---|---|
| `AppCacheClient` | `app_cache.dart` | Cache com expiração — `put`, `get`, `delete`, `clear`, `clearExpired` |
| `AppDatabaseClient` | `app_database.dart` | SQL local — `insert`, `query`, `update`, `delete` |

Implementações em `lib/infra/cache/` e `lib/infra/database_impl/`.

### Routing (`lib/core/router/`)

| Constante / Classe | Ficheiro | Uso |
|---|---|---|
| `AppRoute.WELCOME`, `AppRoute.LOGIN`, `AppRoute.SIGN_UP`, `AppRoute.HOME`, `AppRoute.SPLASH`, `AppRoute.ONBOARDING` | `app_route.dart` | Constantes de rota — usa sempre estas, nunca strings literais |
| `AppPages` | `app_route_pages.dart` | Lista de `GetPage` — regista aqui todas as novas rotas |

**Nunca uses strings de rota literais** — usa sempre `AppRoute.*`.

### Tema

O tema vem inteiramente do design system: `kit.AppTheme.light` e `kit.AppTheme.dark`, aplicados em `lib/main.dart`. **Não definas temas inline nos widgets** nem crias uma cópia local do tema.

---

## 1. Design system em primeiro lugar

O design system vive **dentro do projeto**, em `lib/core/design_system/`. Não há dependência externa: cada projeto adapta os tokens e os componentes à sua marca.

```
lib/core/design_system/
├── design_system.dart        # barrel — o único import
├── tokens/                   # colors, spacing, radius, shadows, typography
├── theme/app_theme.dart      # ThemeData light/dark derivado dos tokens
└── components/               # AppButton, AppTextField, AppPasswordField
```

Importa sempre o barrel com alias `kit`:

```dart
import 'package:app_template/core/design_system/design_system.dart' as kit;
```

**Nunca importes ficheiros de dentro do design system diretamente** — só o barrel.

Componentes disponíveis:

| Componente | Classe |
|---|---|
| Botão principal | `kit.AppButton` (variantes `primary`, `secondary`, `outline`, `ghost`; tamanhos `sm`, `md`, `lg`) |
| Campo de texto | `kit.AppTextField` |
| Campo de palavra-passe | `kit.AppPasswordField` |

Tokens disponíveis:

```dart
kit.AppColors.*        // primary, secondary, background, textPrimary, textSecondary, danger, …
kit.AppSpacing.*       // xs=4, sm=8, md=16, lg=24, xl=32, xxl=48
kit.AppRadius.*        // radius4 … radius86
kit.AppShadows.*       // card, dialog
kit.AppTypography.*    // tamanhos, pesos, lineHeight, blackStyle()
```

**Antes de criar qualquer widget, verifica se já existe um componente no design system.** Se o componente é genérico e reutilizável em qualquer projeto, cria-o em `components/` e exporta-o no barrel. Se é específico deste produto mas partilhado entre features, vai para `lib/shared/widgets/`. Se só serve um ecrã, fica no `widgets/` dessa feature.

A família de letra é aplicada globalmente pelo `AppTheme` (Inter via `google_fonts`) — **não definas `fontFamily` nos widgets**.

### Regra de design — estados de carregamento

**Qualquer carregamento (loading) deve ser demonstrado com um Skeleton Loader** (placeholder com o formato do conteúdo real, efeito shimmer), **nunca** com um `CircularProgressIndicator` a ocupar o ecrã.

- Constrói o skeleton com a mesma estrutura/layout do conteúdo final (mesmas caixas, alturas, espaçamentos) para evitar saltos de layout ao carregar.
- Usa `SkeletonBox` e `ShimmerSweep` de `lib/shared/widgets/shimmer_skeleton.dart`.
- Usa sempre os tokens (`kit.AppColors`, `kit.AppRadius`, `kit.AppSpacing`) para o skeleton — nada hardcoded.

Exemplo de referência: `lib/features/home/presentation/home/widgets/home_placeholder.dart`.

---

## 2. Widgets reutilizáveis

- Extrai cada secção visual para o seu próprio ficheiro em `widgets/` dentro da feature.
- Um widget = uma responsabilidade. Se um widget faz mais do que uma coisa, divide.
- Widgets sem estado devem ser `StatelessWidget`. Só usa `StatefulWidget` para estado UI local (animações, foco, toggle).
- Nunca coloca lógica de negócio dentro de um widget — apenas apresentação.
- Passa dependências por construtor, nunca acedes diretamente ao `injector` dentro de um widget filho.

Estrutura de pastas por feature:

```
lib/features/<feature>/
├── data/
│   ├── datasource/          # remote_*_datasource.dart, local_*_datasource.dart
│   ├── model/               # *_model.dart (fromJson/toEntity)
│   └── repository/          # *_repository_impl.dart
├── domain/
│   ├── entities/            # entidades puras
│   ├── repository/          # contrato (interface)
│   └── usecase/             # uma operação de negócio por ficheiro
└── presentation/<screen>/
    ├── <screen>_page.dart      # página principal (compõe os widgets)
    ├── <screen>_controller.dart # lógica + estado (GetX)
    └── widgets/
        ├── <screen>_header.dart
        └── ...
```

`lib/features/auth/` é o exemplo de referência completo desta estrutura.

---

## 3. Separação de lógica de negócio da UI

Segue estritamente a Clean Architecture já adoptada no projeto:

```
Presentation  →  Domain  →  Data
(UI + Controller)  (Entities + UseCases + Repository interface)  (Models + DataSources + Repository impl)
```

Regras rígidas:

- **Controllers** (`GetxController`, estendem `BaseController`) — apenas estado observável, validação de inputs e delegação para UseCases/Repository. Sem `Widget`, sem `BuildContext`.
- **UseCases** — uma única operação de negócio. Sem estado, sem UI. Ver `login_usecase.dart`.
- **Repository** — contrato (interface) no domínio, implementação nos dados.
- **Widgets/Pages** — apenas constroem a árvore de widgets. Sem `if (email.contains('@'))`, sem chamadas HTTP, sem acesso à base de dados.

---

## 4. TDD — Test-Driven Development

**Escreve sempre o teste antes da implementação.**

Ordem obrigatória:
1. Escreve o teste que falha (Red)
2. Escreve o mínimo de código para passar (Green)
3. Refatora mantendo os testes a passar (Refactor)

Estrutura de testes espelhada à estrutura do código:

```
test/
├── features/
│   └── auth/
│       ├── domain/
│       │   └── usecase/login_usecase_test.dart
│       ├── data/
│       │   └── repository/user_repository_impl_test.dart
│       └── presentation/
│           └── login/login_controller_test.dart
└── shared/
    └── widgets/...
```

Cobertura mínima obrigatória por camada:

| Camada | Mínimo |
|---|---|
| UseCases | 100% |
| Controllers | 80% |
| Repository impl | 80% |
| Widgets | smoke test (renderiza sem erros) |

Para controllers usa `GetX` com `Get.testMode = true`. Para repositórios usa fakes ou `mocktail`.

---

## 5. Logs — Observabilidade do App

Usa sempre `dart:developer` para logs estruturados. **Nunca uses `print()`.**

Padrão obrigatório:

```dart
import 'dart:developer';

// Início de operação
log('[NomeClasse] iniciando operação X', name: 'NomeClasse');

// Sucesso
log('[NomeClasse] operação X concluída: ${resultado}', name: 'NomeClasse');

// Erro (com stacktrace)
log('[NomeClasse] erro na operação X: $e', name: 'NomeClasse', error: e, stackTrace: st);
```

Onde colocar logs:

- **Controllers**: início e fim de cada método público, erros no catch.
- **UseCases**: entrada (parâmetros) e saída (resultado ou erro).
- **Repository impl**: chamadas remotas (URL/método), respostas (status), erros.
- **DataSources**: queries e respostas.

Exemplo num controller:

```dart
Future<void> login() async {
  log('[LoginController] iniciando login para: $phone', name: 'LoginController');
  try {
    isLoading.value = true;
    final result = await userRepository.login(phone, password);
    log('[LoginController] login bem-sucedido: ${result?.userId}', name: 'LoginController');
  } catch (e, st) {
    showAppError(e);
    log('[LoginController] erro no login: $e', name: 'LoginController', error: e, stackTrace: st);
  } finally {
    isLoading.value = false;
  }
}
```

---

## 6. Object Calisthenics

Aplica as 9 regras obrigatoriamente em código novo:

| # | Regra | Aplicação em Dart/Flutter |
|---|---|---|
| 1 | **Um nível de indentação por método** | Extrai condições aninhadas para métodos privados |
| 2 | **Sem `else` após `return`** | Early return sempre que possível |
| 3 | **Envolve primitivos e strings com valor semântico** | Cria value objects para Email, Password, Nome, etc. |
| 4 | **Colecções de primeira classe** | Cria classes para listas com comportamento (ex: `UserList`) |
| 5 | **Um ponto por linha** | Sem `a.b.c.d()` — extrai para variável intermédia |
| 6 | **Sem abreviações** | `controller` não `ctrl`, `repository` não `repo`, `index` não `idx` |
| 7 | **Mantém entidades pequenas** | Ficheiros < 50 linhas (widgets), classes < 200 linhas |
| 8 | **Sem classes com mais de 2 variáveis de instância** | Agrupa variáveis relacionadas em value objects |
| 9 | **Sem getters/setters** | Expõe comportamento, não dados (`isValid()` em vez de `getValid`) |

Exemplos práticos:

```dart
// MAL — múltiplos níveis de indentação
void validate() {
  if (name.isNotEmpty) {
    if (email.contains('@')) {
      if (password.length >= 6) {
        // lógica
      }
    }
  }
}

// BEM — early return + métodos extraídos
void validate() {
  if (!_hasValidName()) return;
  if (!_hasValidEmail()) return;
  if (!_hasValidPassword()) return;
  // lógica
}

// MAL — primitivo sem semântica
void login(String email, String password) { ... }

// BEM — value objects
void login(Email email, Password password) { ... }
```

---

## 7. Tratamento de erros da API

O servidor deve retornar erros com esta estrutura:

```json
{
  "code": "BAD_REQUEST",
  "message": "Validation failed",
  "details": {
    "phone": "must be a valid E.164 phone number",
    "password": "must be at least 8 characters"
  }
}
```

**Regras obrigatórias:**

- **Nunca mostrar erros técnicos ao utilizador** — sem `DioException`, stacktraces, códigos HTTP, nem `.toString()` de exceções.
- O `DioClient` é o único lugar onde `DioException` é tratado — converte-o sempre em `ApiException` (`lib/core/network/api_exception.dart`).
- Se a resposta não tiver estrutura definida → `ApiException` com mensagem genérica: *"Ocorreu um erro inesperado. Tenta novamente."*
- Nos `catch` dos controllers usa sempre **`showAppError(e)`** (método de `BaseController`) — nunca `_showError(e.toString())`.
- `showAppError` compõe automaticamente: título por código + `message` do servidor + bullets com os `details`.

**Fluxo de erros:**

```
DioException → DioClient._toDomainException() → ApiException → showAppError() → Snackbar amigável
```

**Títulos de snackbar por código:**

| Código | Título |
|---|---|
| `BAD_REQUEST` | Dados inválidos |
| `UNAUTHORIZED` | Acesso negado |
| `FORBIDDEN` | Sem permissão |
| `NOT_FOUND` | Não encontrado |
| `CONFLICT` | Conflito |
| outros | Erro |

**Exemplo num controller:**

```dart
try {
  await userRepository.registerStart(...);
} catch (e, st) {
  showAppError(e);  // ← sempre isto, nunca _showError(e.toString())
  log('[Controller] erro: $e', name: 'Controller', error: e, stackTrace: st);
}
```

---

## 8. Convenções gerais

- **Língua do código**: inglês para nomes de classes, métodos e variáveis. Português para strings visíveis ao utilizador.
- **Nomes de ficheiros**: `snake_case` sempre.
- **Imports**: nunca relativos — usa sempre imports absolutos de package (`package:app_template/...`). Para o design system usa sempre o barrel com o alias `as kit`.
- **Estado observável**: usa `Rx` do GetX (`RxBool`, `RxString`, etc.) apenas em controllers.
- **Navegação**: usa sempre `NavigationService` ou `Get.toNamed()` / `Get.offAllNamed()`.
- **Injeção de dependências**: regista no `lib/injector/dependency_injector.dart`. Nunca instanciar diretamente.
- **Segredos**: só em `.env` (nunca commitado). O `.env.example` documenta as chaves necessárias.
- **Sem comentários óbvios**: só comenta o *porquê*, nunca o *quê*.