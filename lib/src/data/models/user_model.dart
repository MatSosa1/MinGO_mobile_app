import 'package:mingo/src/domain/entities/user.dart';

class UserModel extends User {
  final String password;

  const UserModel({
    required super.name,
    required this.password,
    required super.birthDate,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['user_name'] as String,
      password: json['user_password'] as String,
      birthDate: DateTime.parse(json['user_birth_date'] as String),
      role: json['role_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': name,
      'user_password': password,
      'user_birth_date': birthDate.toIso8601String(),
      'role_name': role,
    };
  }
}
