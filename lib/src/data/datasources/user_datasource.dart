import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mingo/src/data/models/user_model.dart';
import 'package:mingo/src/domain/repositories/datasource_repository.dart';

class APIDatasource extends DatasourceRepository {
  final String baseUrl = 'http://10.0.2.2:3000/users'; 

  @override
  Future<UserModel> createUser(UserModel model) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Error al registrar usuario: ${response.body}');
    }
  }

  @override
  Future<UserModel?> getUserByUsername(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data['user'] ?? data); 
    } else if (response.statusCode == 401 || response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error en login: ${response.body}');
    }
  }

  @override
  Future<UserModel?> setKnowledgeLevel(String knowledgeLevel, int userId) async {
    final url = Uri.parse('$baseUrl/knowledge');

    final res = await http.patch(
      url,
      body: jsonEncode({
        'userId': userId,
        'knowledgeLevel': knowledgeLevel,
      })
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return UserModel.fromJson(data['user'] ?? data); 
    } else if (res.statusCode == 401) {
      return null;
    } else {
      throw Exception('Error al asignar Nivel de Conocimiento: ${res.body}');
    }
  }


}