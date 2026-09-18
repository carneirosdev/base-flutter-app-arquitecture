export 'package:app_template/core/error/exceptions/auth_exceptions.dart';

class MessageException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  MessageException(this.message, [this.stackTrace]);
}

// Erro para 401 Unauthorized
class ActionRequiresAuth implements Exception {
  final String _message;

  ActionRequiresAuth([String? message])
    : _message = message ?? 'Autenticação é necessária.';

  @override
  String toString() => _message;
}

// Erro para 400 Bad Request
class BadRequestException implements Exception {
  final String _message;

  BadRequestException([String? message])
    : _message =
          message ?? 'Requisição inválida. Verifique os dados inseridos.';

  @override
  String toString() => _message;
}

// Erro para 403 Forbidden
class ForbiddenException implements Exception {
  final String _message;

  ForbiddenException([String? message])
    : _message = message ?? 'Você não tem permissão para realizar esta ação.';

  @override
  String toString() => _message;
}

// Erro para 404 Not Found
class NotFoundException implements Exception {
  final String _message;

  NotFoundException([String? message])
    : _message = message ?? 'O recurso solicitado não foi encontrado.';

  @override
  String toString() => _message;
}

// Erro para 405 Method Not Allowed
class MethodNotAllowedException implements Exception {
  final String _message;

  MethodNotAllowedException([String? message])
    : _message = message ?? 'O método HTTP utilizado não é permitido.';

  @override
  String toString() => _message;
}

// Erro para 409 Conflict
class ConflictException implements Exception {
  final String _message;

  ConflictException([String? message])
    : _message = message ?? 'Houve um conflito com a solicitação.';

  @override
  String toString() => _message;
}

// Erro para 429 Too Many Requests
class TooManyRequestsException implements Exception {
  final String _message;

  TooManyRequestsException([String? message])
    : _message =
          message ??
          'Você fez muitas solicitações. Tente novamente mais tarde.';

  @override
  String toString() => _message;
}

// Erro para 500 Internal Server Error
class InternalServerErrorException implements Exception {
  final String _message;

  InternalServerErrorException([String? message])
    : _message = message ?? 'Ocorreu um erro interno no servidor.';

  @override
  String toString() => _message;
}

// Erro para 503 Service Unavailable
class ServiceUnavailableException implements Exception {
  final String _message;

  ServiceUnavailableException([String? message])
    : _message =
          message ??
          'O serviço está temporariamente indisponível. Tente novamente mais tarde.';

  @override
  String toString() => _message;
}

class GenericHttpException implements Exception {
  final String _message;
  final int?
  statusCode; // Opcional, para armazenar o código de status se disponível

  GenericHttpException([String? message, this.statusCode])
    : _message = message ?? 'Ocorreu um erro desconhecido.';

  @override
  String toString() => _message;
}
