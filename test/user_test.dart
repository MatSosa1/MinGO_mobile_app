import 'package:flutter_test/flutter_test.dart';
import 'package:mingo/src/data/datasources/user_datasource.dart';
import 'package:mingo/src/data/models/user_model.dart';
import 'package:mingo/src/domain/repositories/user_datasource_repository.dart';

void main() {
  group('Datasource', () {
    late UserDatasource dataSource;

    setUp(() {
      dataSource = UserDatasourceImpl();
    });

    // test('getUserByEmail', () async {
    //   final resultTrue = await dataSource.getUserByEmail('padre123@hola.com', 'padre123');
    //   final resultNull = await dataSource.getUserByEmail('docente123@hola.com', 'padre123');

    //   expect(resultTrue!.name, 'Padre1');
    //   expect(resultNull, isNull);
    // });

    // test('createUser', () async {
    //   final UserModel model = UserModel(
    //     name: 'Usuario1',
    //     email: 'usuario1@email.com',
    //     password: 'usuario123',
    //     birthDate: DateTime.now(),
    //     knowledgeLevel: 'Principiante',
    //     role: 1
    //   );

    //   final result = await dataSource.createUser(model);

    //   expect(result.id, 3);
    //   expect(result.name, model.name);
    // });

    // test('setKnowledgeLevel', () async {
    //   final result = await dataSource.setKnowledgeLevel('Intermedio', 3);

    //   expect(result!.id, 3);
    //   expect(result.knowledgeLevel, 'Intermedio');
    // });
  });
}