import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/repositories/sign_synonym_datasource_repository.dart';
import '../models/sign_synonym_model.dart';

class SignSynonymDataSourceImpl implements SignSynonymDataSource {
  final String baseUrl;
  final http.Client _client = http.Client();

  SignSynonymDataSourceImpl({required this.baseUrl});

  @override
  Future<SignSynonymModel> createSignSynonym(SignSynonymModel synonym) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/sign-synonyms'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(synonym.toJson()),
    );

    if (response.statusCode == 201) {
      return SignSynonymModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error creating sign synonym: ${response.statusCode}');
    }
  }

  @override
  Future<List<SignSynonymModel>> getAllSignSynonyms() async {
    final response = await _client.get(Uri.parse('$baseUrl/sign-synonyms'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SignSynonymModel.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching sign synonyms: ${response.statusCode}');
    }
  }

  @override
  Future<List<SignSynonymModel>> getSignSynonymsBySignId(int signId) async {
    final response = await _client.get(Uri.parse('$baseUrl/sign-synonyms/sign/$signId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SignSynonymModel.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching sign synonyms by sign id: ${response.statusCode}');
    }
  }
}
