import '../entities/tag.dart';
import '../repositories/tag_repository.dart';

class CreateTagUseCase {
  final TagRepository repository;

  CreateTagUseCase(this.repository);

  Future<Tag> call(Tag tag) async {
    return await repository.createTag(tag);
  }
}

class GetAllTagsUseCase {
  final TagRepository repository;

  GetAllTagsUseCase(this.repository);

  Future<List<Tag>> call() async {
    return await repository.getAllTags();
  }
}

class GetTagByIdUseCase {
  final TagRepository repository;

  GetTagByIdUseCase(this.repository);

  Future<Tag?> call(int id) async {
    return await repository.getTagById(id);
  }
}
