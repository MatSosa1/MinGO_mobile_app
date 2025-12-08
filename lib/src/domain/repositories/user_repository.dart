import 'package:mingo/src/domain/entities/user.dart';

abstract class UserRepository {
  Future<User?> loginUser(String email, String password);
  Future<User> registerUser(User user);

  // Knowledge Test
  Future<User?> setKnowledgeLevel(User user, int score);
}