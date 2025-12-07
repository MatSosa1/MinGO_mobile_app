import 'package:mingo/src/domain/entities/user.dart';

abstract class UserRepository {
  Future<User?> loginUser(String name, String password);
  Future<User> registerUser(User user);
}
