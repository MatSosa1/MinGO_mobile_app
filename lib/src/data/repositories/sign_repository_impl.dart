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
      signVideoUrl: sign.signVideoUrl,
      signImageUrl: sign.signImageUrl,
      signSection: sign.signSection,
      tagId: sign.tagId,
    );
    final created = await dataSource.createSign(model);
    return Sign(
      id: created.id,
      signTitle: created.signTitle,
      signVideoUrl: created.signVideoUrl,
      signImageUrl: created.signImageUrl,
      signSection: created.signSection,
      tagId: created.tagId,
    );
  }

  @override
  Future<List<Sign>> getAllSigns() async {
    final models = await dataSource.getAllSigns();
    return models
        .map((m) => Sign(
              id: m.id,
              signTitle: m.signTitle,
              signVideoUrl: m.signVideoUrl,
              signImageUrl: m.signImageUrl,
              signSection: m.signSection,
              tagId: m.tagId,
            ))
        .toList();
  }

  @override
  Future<Sign?> getSignById(int id) async {
    final model = await dataSource.getSignById(id);
    if (model == null) return null;
    return Sign(
      id: model.id,
      signTitle: model.signTitle,
      signVideoUrl: model.signVideoUrl,
      signImageUrl: model.signImageUrl,
      signSection: model.signSection,
      tagId: model.tagId,
    );
  }
}
