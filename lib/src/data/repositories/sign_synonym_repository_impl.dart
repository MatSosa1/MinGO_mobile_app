import '../../domain/entities/sign_synonym.dart';
import '../../domain/repositories/sign_synonym_datasource_repository.dart';
import '../../domain/repositories/sign_synonym_repository.dart';
import '../models/sign_synonym_model.dart';

class SignSynonymRepositoryImpl implements SignSynonymRepository {
  final SignSynonymDataSource dataSource;

  SignSynonymRepositoryImpl({required this.dataSource});

  @override
  Future<SignSynonym> createSignSynonym(SignSynonym synonym) async {
    final model = SignSynonymModel(
      synonymWord: synonym.synonymWord,
      signId: synonym.signId,
    );
    final created = await dataSource.createSignSynonym(model);
    return SignSynonym(
      id: created.id,
      synonymWord: created.synonymWord,
      signId: created.signId,
    );
  }

  @override
  Future<List<SignSynonym>> getSignSynonymsBySignId(int signId) async {
    final models = await dataSource.getSignSynonymsBySignId(signId);
    return models
        .map((m) => SignSynonym(id: m.id, synonymWord: m.synonymWord, signId: m.signId))
        .toList();
  }

  @override
  Future<SignSynonym?> getSignSynonymById(int signId, int synonymId) async {
    final models = await dataSource.getSignSynonymsBySignId(signId);
    try {
      final model = models.firstWhere((m) => m.id == synonymId);
      return SignSynonym(id: model.id, synonymWord: model.synonymWord, signId: model.signId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SignSynonym> updateSignSynonym(SignSynonym synonym) async {
    final model = SignSynonymModel(
      id: synonym.id,
      synonymWord: synonym.synonymWord,
      signId: synonym.signId,
    );
    final updated = await dataSource.updateSignSynonym(model);
    return SignSynonym(
      id: updated.id,
      synonymWord: updated.synonymWord,
      signId: updated.signId,
    );
  }

  @override
  Future<void> deleteSignSynonym(int signId, int synonymId) async {
    await dataSource.deleteSignSynonym(signId, synonymId);
  }
}
