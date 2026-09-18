import 'package:app_template/features/auth/domain/entities/session_entity.dart';
import 'package:app_template/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final String userId;
  final SessionModel session;

  UserModel({
    required this.userId,
    required this.session,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String,
      session: SessionModel.fromJson(json['session'] as Map<String, dynamic>),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      session: session.toEntity(),
    );
  }
}

class SessionModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  SessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as int,
    );
  }

  SessionEntity toEntity() {
    return SessionEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );
  }
}
