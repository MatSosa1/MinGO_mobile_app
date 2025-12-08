import '../entities/sign_synonym.dart';
import '../repositories/sign_synonym_repository.dart';

class CreateSignSynonymUseCase {
  final SignSynonymRepository repository;

  CreateSignSynonymUseCase(this.repository);

  Future<SignSynonym> call(SignSynonym synonym) async {
    return await repository.createSignSynonym(synonym);
  }
}

class GetAllSignSynonymsUseCase {
  final SignSynonymRepository repository;

  GetAllSignSynonymsUseCase(this.repository);

  Future<List<SignSynonym>> call() async {
    return await repository.getAllSignSynonyms();
  }
}

class GetSignSynonymsBySignIdUseCase {
  final SignSynonymRepository repository;

  GetSignSynonymsBySignIdUseCase(this.repository);

  Future<List<SignSynonym>> call(int signId) async {
    return await repository.getSignSynonymsBySignId(signId);
  }
}
