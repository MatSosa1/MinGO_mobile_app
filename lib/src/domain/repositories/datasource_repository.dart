import 'package:mingo/src/data/models/user_model.dart';

abstract class DatasourceRepository {
  Future<UserModel?> getUserByUsername(String username, String password);
  Future<UserModel> createUser(UserModel model);
}
