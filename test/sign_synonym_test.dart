import 'package:flutter_test/flutter_test.dart';
import 'package:mingo/src/data/datasources/sign_synonym_datasource.dart';
import 'package:mingo/src/data/models/sign_synonym_model.dart';
import 'package:mingo/src/domain/repositories/sign_synonym_datasource_repository.dart';

void main() {
  group('Datasource', () {
    late SignSynonymDataSource dataSource;

    setUp(() {
      dataSource = SignSynonymDataSourceImpl();
    });

    test('creatSignSynonym', () async {
      SignSynonymModel model = SignSynonymModel(synonymWord: 'Carro', signId: 1);

      final result = await dataSource.createSignSynonym(model);

      expect(result.id, model.id);
    });
  });
}