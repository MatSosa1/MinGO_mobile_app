import '../entities/user.dart';
import '../repositories/user_repository.dart';

class LoginUserUseCase {
  final UserRepository repository;

  LoginUserUseCase(this.repository);

  Future<User?> call(String email, String password) {
    return repository.loginUser(email, password);
  }
}

class RegisterUserUseCase {
  final UserRepository repository;

  RegisterUserUseCase(this.repository);

  Future<User> call(User user) {
    return repository.registerUser(user);
  }
}