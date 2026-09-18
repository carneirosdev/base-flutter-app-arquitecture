class ApiException implements Exception {
  final String code;
  final String message;
  final Map<String, dynamic>? details;
  final int statusCode;

  const ApiException({
    required this.code,
    required this.message,
    required this.statusCode,
    this.details,
  });

  String get userFriendlyTitle => switch (code) {
        'BAD_REQUEST' => 'Dados inválidos',
        'UNAUTHORIZED' => 'Acesso negado',
        'AUTH_INVALID_CREDENTIALS' => 'Credenciais inválidas',
        'FORBIDDEN' => 'Sem permissão',
        'NOT_FOUND' => 'Não encontrado',
        'CONFLICT' => 'Conflito',
        'INVALID_CODE' => 'Código inválido',
        'NETWORK_ERROR' => 'Sem ligação',
        'TIMEOUT' => 'Tempo esgotado',
        _ => 'Erro',
      };

  String get userFriendlyMessage => switch (code) {
        'AUTH_INVALID_CREDENTIALS' =>
          'Número de telefone ou palavra-passe incorretos.',
        'NETWORK_ERROR' => 'Sem ligação à internet. Verifica a tua rede.',
        'TIMEOUT' => 'A ligação expirou. Tenta novamente.',
        _ => message,
      };
}
