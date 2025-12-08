import '../../domain/entities/user.dart';

class UserModel extends User {
  final String password;

  const UserModel({
    super.id,
    required super.name,
    required super.email,
    required this.password,
    required super.birthDate,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      password: '', 
      birthDate: DateTime.parse(json['birth_date'] as String),
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'birth_date': birthDate.toIso8601String(),
      'role': role,
    };
  }
}