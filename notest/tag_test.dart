import 'package:flutter_test/flutter_test.dart';
import 'package:mingo/src/data/datasources/tag_datasource.dart';
import 'package:mingo/src/data/models/tag_model.dart';
import 'package:mingo/src/domain/repositories/tag_datasource_repository.dart';

void main() {
  group('Datasource', () {
    late TagDataSource dataSource;

    setUp(() {
      dataSource = TagDataSourceImpl();
    });

    // test('createTag', () async {
    //   TagModel t = TagModel(tagName: 'Tag1');

    //   final result = await dataSource.createTag(t);

    //   expect(result.tagName, t.tagName);
    // });

    // test('getAllTags', () async {
    //   final result = await dataSource.getAllTags();

    //   expect(result, isA<List>());
    //   expect(result[0].id, 1);
    // });

    // test('getTagById', () async {
    //   final result = await dataSource.getTagById(1);

    //   expect(result!.id, 1);
    //   expect(result.tagName, 'Tag1');
    // });
  });
}