import '../../domain/entities/user.dart';

class UserModel extends User {
  final String password;

  const UserModel({
    super.id,
    required super.name,
    required super.email,
    required this.password,
    required super.birthDate,
    super.knowledgeLevel = 'Principiante',
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'] as int,
      name: json['user_name'] as String,
      email: json['user_email'] as String,
      password: '', 
      birthDate: DateTime.parse(json['user_birth_date'] as String),
      knowledgeLevel: json['user_knowledge_level'] as String,
      role: json['role_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': name,
      'user_email': email,
      'user_password': password,
      'user_birth_date': birthDate.toIso8601String(),
      'user_knowledge_level': knowledgeLevel,
      'role_id': role,
    };
  }
}