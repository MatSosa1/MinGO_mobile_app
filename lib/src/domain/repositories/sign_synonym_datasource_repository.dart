import '../../data/models/sign_synonym_model.dart';

abstract class SignSynonymDataSource {
  Future<SignSynonymModel> createSignSynonym(SignSynonymModel synonym);
  Future<List<SignSynonymModel>> getSignSynonymsBySignId(int signId);
  Future<SignSynonymModel> updateSignSynonym(SignSynonymModel synonym);
  Future<void> deleteSignSynonym(int signId, int synonymId);
}
