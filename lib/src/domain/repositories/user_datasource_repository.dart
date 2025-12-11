import 'package:mingo/src/data/models/user_model.dart';

abstract class UserDatasource {
  Future<UserModel?> getUserByEmail(String email, String password);
  Future<UserModel> createUser(UserModel model);

  Future<UserModel?> setKnowledgeLevel(String knowledgeLevel, int userId);
}
