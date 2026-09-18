import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:app_template/core/error/exceptions/exceptions.dart';

@singleton
class ResourceService {
  String exceptionMessage(Exception? exception) {
    if (exception == null) return '';

    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.connectionError:
          return 'Conexão falhou. Por favor, verifique sua internet e tente novamente.';
        case DioExceptionType.sendTimeout:
          return 'O tempo para enviar dados ao servidor foi excedido.';
        case DioExceptionType.receiveTimeout:
          return 'O servidor demorou muito para responder. Por favor, tente novamente mais tarde.';
        case DioExceptionType.badResponse:
          if (exception.response != null) {
            return 'O servidor respondeu com o código de status ${exception.response?.statusCode}.';
          } else {
            return 'A resposta do servidor foi inválida ou inesperada.';
          }
        case DioExceptionType.cancel:
          return 'A solicitação foi cancelada antes de ser concluída.';
        case DioExceptionType.unknown:
          return 'Ocorreu um erro inesperado. Verifique sua conexão ou tente novamente mais tarde.';
        default:
          return 'Um erro desconhecido ocorreu. Por favor, tente novamente.';
      }
    } else if (exception is ActionRequiresAuth) {
      return exception.toString();
    } else if (exception is MessageException) {
      return exception.message;
    } else if (exception is ActionRequiresAuth) {
      return exception.toString();
    } else if (exception is BadRequestException) {
      return exception.toString();
    } else if (exception is ForbiddenException) {
      return exception.toString();
    } else if (exception is NotFoundException) {
      return exception.toString();
    } else if (exception is MethodNotAllowedException) {
      return exception.toString();
    } else if (exception is ConflictException) {
      return exception.toString();
    } else if (exception is TooManyRequestsException) {
      return exception.toString();
    } else if (exception is InternalServerErrorException) {
      return exception.toString();
    } else if (exception is ServiceUnavailableException) {
      return exception.toString();
    } else if (exception.runtimeType is GenericHttpException) {
      return exception.toString();
    }

    return 'Não foi possivel executar essa operação';
  }
}
