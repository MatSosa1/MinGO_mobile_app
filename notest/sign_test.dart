// import 'package:mingo/src/data/datasources/sign_datasource.dart';
// import 'package:mingo/src/data/models/sign_model.dart';
// import 'package:mingo/src/domain/entities/sign.dart';
// import 'package:mingo/src/domain/repositories/sign_datasource_repository.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   group('Datasource', () {
//     late SignDataSource dataSource;

//     setUp(() {
//       dataSource = SignDataSourceImpl();
//     });

//     test('getAllSigns should return a list of signs when the response is successful', () async {
//       final result = await dataSource.getAllSigns();

//       expect(result, isNotEmpty);
//       expect(result[0].id, isA<int>());
//       expect(result[0].signTitle, isA<String>());
//       expect(result[0].signSection, isA<SignSection>());
//     });

//     test('createSign should create a sign and returns it', () async {
//       SignModel model = SignModel(
//         signTitle: 'Titulotest',
//         signVideoUrl: 'video.url',
//         signSection: SignSection.FrasesComunes,
//         tagId: 1
//       );

//       final result = await dataSource.createSign(model);

//       expect(result.id, isA<int>());
//       expect(result.signTitle, isA<String>());
//       expect(result.signSection, isA<SignSection>());
//     });

//     test('getSignById should return null when doesnt get the id', () async {
//       final result = await dataSource.getSignById(1);  // No existe 1

//       expect(result, isNull);
//     });

//     test('getSignById should return the sign by the id passed', () async {
//       final result = await dataSource.getSignById(2);  // No existe 1

//       expect(result, isA<SignModel>());
//       expect(result!.id, 2);
//       expect(result.signTitle, 'Hola');
//     });

//     test('getSignsbyKnowledgeLevel', () async {
//       final principiante = await dataSource.getSignsByKnowledgeLevel('Principiante');
//       final intermedio = await dataSource.getSignsByKnowledgeLevel('Intermedio');
//       final avanzado = await dataSource.getSignsByKnowledgeLevel('Avanzado');
//       final comunes = await dataSource.getSignsByKnowledgeLevel('Frases Comunes');

//       expect(principiante, isA<List>());
//       expect(intermedio, isA<List>());
//       expect(avanzado, isA<List>());
//       expect(comunes, isA<List>());
//     });
//   });
// }
