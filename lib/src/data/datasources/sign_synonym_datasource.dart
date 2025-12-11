import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/repositories/sign_synonym_datasource_repository.dart';
import '../models/sign_synonym_model.dart';

class SignSynonymDataSourceImpl implements SignSynonymDataSource {
  final String baseUrl = 'http://localhost:3000/signs';

  @override
  Future<SignSynonymModel> createSignSynonym(SignSynonymModel synonym) async {
    final response = await http.post(
      Uri.parse('$baseUrl/${synonym.signId}/synonyms'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'synonym_word': synonym.synonymWord}),
    );

    if (response.statusCode == 201) {
      return SignSynonymModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error creating sign synonym: ${response.statusCode}');
    }
  }

  @override
  Future<List<SignSynonymModel>> getSignSynonymsBySignId(int signId) async {
    final response = await http.get(Uri.parse('$baseUrl/$signId/synonyms'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SignSynonymModel.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching sign synonyms for sign $signId: ${response.statusCode}');
    }
  }

  @override
  Future<SignSynonymModel> updateSignSynonym(SignSynonymModel synonym) async {
    if (synonym.id == null) throw Exception('Synonym ID is required for update');

    final response = await http.put(
      Uri.parse('$baseUrl/${synonym.signId}/synonyms/${synonym.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'synonym_word': synonym.synonymWord}),
    );

    if (response.statusCode == 200) {
      return SignSynonymModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error updating sign synonym: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteSignSynonym(int signId, int synonymId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$signId/synonyms/$synonymId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error deleting sign synonym: ${response.statusCode}');
    }
  }
}
