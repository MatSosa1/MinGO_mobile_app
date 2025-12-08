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
  Future<List<SignSynonym>> getAllSignSynonyms() async {
    final models = await dataSource.getAllSignSynonyms();
    return models
        .map((m) => SignSynonym(id: m.id, synonymWord: m.synonymWord, signId: m.signId))
        .toList();
  }

  @override
  Future<List<SignSynonym>> getSignSynonymsBySignId(int signId) async {
    final models = await dataSource.getSignSynonymsBySignId(signId);
    return models
        .map((m) => SignSynonym(id: m.id, synonymWord: m.synonymWord, signId: m.signId))
        .toList();
  }
}
