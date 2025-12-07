import 'package:mingo/src/data/models/user_model.dart';
import 'package:mingo/src/domain/entities/user.dart';
import 'package:mingo/src/domain/repositories/datasource_repository.dart';
import 'package:mingo/src/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final DatasourceRepository datasource;

  UserRepositoryImpl({required this.datasource});

  @override
  Future<User?> loginUser(String name, String password) async {
    try {
      final userModel = await datasource.getUserByUsername(name, password);

      return userModel;
    } catch (e) {
      print('Error en loginUser: $e');
      return null;
    }
  }

  @override
  Future<User> registerUser(User user) async {
    try {
      final userModel = UserModel(
        name: user.name,
        password: (user is UserModel) ? user.password : '',
        birthDate: user.birthDate,
        role: user.role,
      );

      final createdUser = await datasource.createUser(userModel);

      return createdUser;
    } catch (e) {
      print('Error en registerUser: $e');
      rethrow;
    }
  }
}
