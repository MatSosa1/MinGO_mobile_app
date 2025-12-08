import '../entities/sign_synonym.dart';

abstract class SignSynonymRepository {
  Future<SignSynonym> createSignSynonym(SignSynonym synonym);
  Future<List<SignSynonym>> getSignSynonymsBySignId(int signId);
  Future<SignSynonym?> getSignSynonymById(int signId, int synonymId);
  Future<SignSynonym> updateSignSynonym(SignSynonym synonym);
  Future<void> deleteSignSynonym(int signId, int synonymId);
}
