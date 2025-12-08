import 'package:mingo/src/data/models/tag_model.dart';

abstract class TagDataSource {
  Future<TagModel> createTag(TagModel tag);
  Future<List<TagModel>> getAllTags();
  Future<TagModel?> getTagById(int id);
}
