class UserProfileEntity {
  final String id;
  final String name;
  final String surname;
  final String? avatarUrl;
  String get fullName => '$name $surname';

  UserProfileEntity({
    required this.id,
    required this.name,
    required this.surname,
    this.avatarUrl,
  });

  factory UserProfileEntity.fromJson(Map<String, dynamic> json) {
    return UserProfileEntity(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'avatar_url': avatarUrl,
    };
  }
}
