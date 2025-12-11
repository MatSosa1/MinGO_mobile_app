import 'package:mingo/src/domain/entities/user.dart';

class UserModel extends User {
  final String? password; 

  const UserModel({
    super.id,
    required super.name,
    required super.email,
    required super.birthDate,
    required super.knowledgeLevel,
    required super.role,
    this.password,
    // Puedes agregar isFirstTime al constructor si deseas manejarlo en la entidad también
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'], 
      name: json['user_name'],
      email: json['user_email'],
      birthDate: DateTime.parse(json['user_birth_date']),
      knowledgeLevel: json['user_knowledge_level'] ?? 'Principiante',
      role: json['role_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': name,
      'user_password': password,
      'user_email': email,
      'user_birth_date': birthDate.toIso8601String(),
      'user_knowledge_level': knowledgeLevel,
      'role_id': role,
      'user_first_time_login': true, 
    };
  }
}