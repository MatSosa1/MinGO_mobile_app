import 'package:mingo/src/data/models/sign_model.dart';
import 'package:mingo/src/domain/entities/sign.dart';
import 'package:mingo/src/domain/repositories/sign_datasource_repository.dart';
import 'package:mingo/src/domain/repositories/sign_repository.dart';

class SignRepositoryImpl implements SignRepository {
  final SignDataSource dataSource;

  SignRepositoryImpl({required this.dataSource});

  @override
  Future<Sign> createSign(Sign sign) async {
    final model = SignModel(
      signTitle: sign.signTitle,
      description: sign.description, 
      signVideoUrl: sign.signVideoUrl,
      signImageUrl: sign.signImageUrl,
      signSection: sign.signSection,
      tagId: sign.tagId,
      synonyms: sign.synonyms, 
    );

    final created = await dataSource.createSign(model);

    return _mapModelToEntity(created);
  }

  @override
  Future<List<Sign>> getAllSigns() async {
    final models = await dataSource.getAllSigns();
    return models.map((m) => _mapModelToEntity(m)).toList();
  }

  @override
  Future<Sign?> getSignById(int id) async {
    final model = await dataSource.getSignById(id);
    if (model == null) return null;
    return _mapModelToEntity(model);
  }

  @override
  Future<List<Sign>> getSignsByKnowledgeLevel(String knowledgeLevel) async {
    final models = await dataSource.getSignsByKnowledgeLevel(knowledgeLevel);
    return models.map((m) => _mapModelToEntity(m)).toList();
  }

  Sign _mapModelToEntity(SignModel m) {
    return Sign(
      id: m.id,
      signTitle: m.signTitle,
      description: m.description, 
      signVideoUrl: m.signVideoUrl,
      signImageUrl: m.signImageUrl,
      signSection: m.signSection,
      tagId: m.tagId,
      synonyms: m.synonyms,
    );
  }
}