import '../entities/tag.dart';

abstract class TagRepository {
  Future<Tag> createTag(Tag tag);
  Future<List<Tag>> getAllTags();
  Future<Tag?> getTagById(int id);
}
