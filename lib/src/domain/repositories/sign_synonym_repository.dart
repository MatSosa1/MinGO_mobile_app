import '../entities/sign_synonym.dart';

abstract class SignSynonymRepository {
  Future<SignSynonym> createSignSynonym(SignSynonym synonym);
  Future<List<SignSynonym>> getAllSignSynonyms();
  Future<List<SignSynonym>> getSignSynonymsBySignId(int signId);
}
