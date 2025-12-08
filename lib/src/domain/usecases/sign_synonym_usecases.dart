import '../entities/sign_synonym.dart';
import '../repositories/sign_synonym_repository.dart';

class CreateSignSynonymUseCase {
  final SignSynonymRepository repository;

  CreateSignSynonymUseCase(this.repository);

  Future<SignSynonym> call(SignSynonym synonym) async {
    return await repository.createSignSynonym(synonym);
  }
}

class GetSignSynonymsBySignIdUseCase {
  final SignSynonymRepository repository;

  GetSignSynonymsBySignIdUseCase(this.repository);

  Future<List<SignSynonym>> call(int signId) async {
    return await repository.getSignSynonymsBySignId(signId);
  }
}

class GetSignSynonymByIdUseCase {
  final SignSynonymRepository repository;

  GetSignSynonymByIdUseCase(this.repository);

  Future<SignSynonym?> call(int signId, int synonymId) async {
    return await repository.getSignSynonymById(signId, synonymId);
  }
}

class UpdateSignSynonymUseCase {
  final SignSynonymRepository repository;

  UpdateSignSynonymUseCase(this.repository);

  Future<SignSynonym> call(SignSynonym synonym) async {
    return await repository.updateSignSynonym(synonym);
  }
}

class DeleteSignSynonymUseCase {
  final SignSynonymRepository repository;

  DeleteSignSynonymUseCase(this.repository);

  Future<void> call(int signId, int synonymId) async {
    await repository.deleteSignSynonym(signId, synonymId);
  }
}
