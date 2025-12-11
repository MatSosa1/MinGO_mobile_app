import 'package:mingo/src/data/models/sign_model.dart';

abstract class SignDataSource {
  Future<SignModel> createSign(SignModel sign);
  Future<List<SignModel>> getAllSigns();
  Future<SignModel?> getSignById(int id);
  Future<List<SignModel>> getSignsByKnowledgeLevel(String knowledgeLevel);
}
