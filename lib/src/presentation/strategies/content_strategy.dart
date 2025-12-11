import '../../domain/entities/sign.dart';
import '../../domain/repositories/sign_repository.dart';

abstract class ContentStrategy {
  String get title;
  Future<List<Sign>> fetchContent();
}

class SectionContentStrategy implements ContentStrategy {
  final SignRepository repository;
  final SignSection section;

  SectionContentStrategy(this.repository, this.section);

  @override
  String get title => section.name;

  @override
  Future<List<Sign>> fetchContent() async {
    return await repository.getSignsByKnowledgeLevel(section.name);
  }
}