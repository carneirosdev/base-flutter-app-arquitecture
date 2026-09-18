class SessionEntity {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  SessionEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory SessionEntity.fromJson(Map<String, dynamic> json) {
    return SessionEntity(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
    };
  }
}