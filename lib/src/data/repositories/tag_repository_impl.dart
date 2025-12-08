import '../../domain/entities/tag.dart';
import '../../domain/repositories/tag_datasource_repository.dart';
import '../../domain/repositories/tag_repository.dart';
import '../models/tag_model.dart';

class TagRepositoryImpl implements TagRepository {
  final TagDataSource dataSource;

  TagRepositoryImpl({required this.dataSource});

  @override
  Future<Tag> createTag(Tag tag) async {
    final model = TagModel(tagName: tag.tagName);
    final created = await dataSource.createTag(model);
    return Tag(id: created.id, tagName: created.tagName);
  }

  @override
  Future<List<Tag>> getAllTags() async {
    final models = await dataSource.getAllTags();
    return models.map((m) => Tag(id: m.id, tagName: m.tagName)).toList();
  }

  @override
  Future<Tag?> getTagById(int id) async {
    final model = await dataSource.getTagById(id);
    if (model == null) return null;
    return Tag(id: model.id, tagName: model.tagName);
  }
}
