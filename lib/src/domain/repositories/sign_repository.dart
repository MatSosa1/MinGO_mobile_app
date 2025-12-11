import '../entities/sign.dart';

abstract class SignRepository {
  Future<Sign> createSign(Sign sign);
  Future<List<Sign>> getAllSigns();
  Future<Sign?> getSignById(int id);
  Future<List<Sign>> getSignsByKnowledgeLevel(String knowledgeLevel);
}
