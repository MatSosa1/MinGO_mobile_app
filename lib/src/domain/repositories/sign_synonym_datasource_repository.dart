import '../../data/models/sign_synonym_model.dart';

abstract class SignSynonymDataSource {
  Future<SignSynonymModel> createSignSynonym(SignSynonymModel synonym);
  Future<List<SignSynonymModel>> getAllSignSynonyms();
  Future<List<SignSynonymModel>> getSignSynonymsBySignId(int signId);
}
