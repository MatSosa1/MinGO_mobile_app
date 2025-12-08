import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/repositories/tag_datasource_repository.dart';
import '../models/tag_model.dart';

class TagDataSourceImpl implements TagDataSource {
  final String baseUrl;

  TagDataSourceImpl({required this.baseUrl});

  @override
  Future<TagModel> createTag(TagModel tag) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tags'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tag.toJson()),
    );

    if (response.statusCode == 201) {
      return TagModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error creating tag: ${response.statusCode}');
    }
  }

  @override
  Future<List<TagModel>> getAllTags() async {
    final response = await http.get(Uri.parse('$baseUrl/tags'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TagModel.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching tags: ${response.statusCode}');
    }
  }

  @override
  Future<TagModel?> getTagById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/tags/$id'));

    if (response.statusCode == 200) {
      return TagModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error fetching tag: ${response.statusCode}');
    }
  }
}
