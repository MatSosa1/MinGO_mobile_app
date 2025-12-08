import 'package:mingo/src/domain/repositories/datasource_repository.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl extends UserRepository {
  final DatasourceRepository datasource;

  UserRepositoryImpl({required this.datasource});

  @override
  Future<User?> loginUser(String email, String password) async {
    try {
      final userModel = await datasource.getUserByUsername(email, password);
      return userModel;
    } catch (e) {
      print('Error en loginUser: $e'); 
      return null;
    }
  }

  @override
  Future<User> registerUser(User user) async {
    try {
      if (user is! UserModel) {
        throw Exception("El usuario debe contener contraseña para el registro");
      }

      final createdUser = await datasource.createUser(user);
      return createdUser;
    } catch (e) {
      print('Error en registerUser: $e');
      rethrow;
    }
  }
  
  @override
  Future<User?> setKnowledgeLevel(User user, int score) async {
    String knowledgeLevel = 'Principiante';

    if (score > 31) {
      knowledgeLevel = 'Avanzado';
    }
    else if (score > 16) {
      knowledgeLevel = 'Intermedio';
    }

    try {
      final model = await datasource.setKnowledgeLevel(knowledgeLevel, user.id!);

      return model;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}