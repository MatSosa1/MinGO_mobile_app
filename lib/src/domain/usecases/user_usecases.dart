import 'package:mingo/src/domain/entities/user.dart';
import 'package:mingo/src/domain/repositories/user_repository.dart';

class SetKnowledgeUseCase {
  final UserRepository repository;

  SetKnowledgeUseCase(this.repository);

  Future<User?> call(User user, int score) async {
    return repository.setKnowledgeLevel(user, score);
  }
}
