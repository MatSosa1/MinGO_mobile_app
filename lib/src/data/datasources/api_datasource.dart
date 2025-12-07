import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mingo/src/data/models/user_model.dart';
import 'package:mingo/src/domain/repositories/datasource_repository.dart';

class APIDatasource extends DatasourceRepository {
  final String baseUrl = 'http://localhost:3000';

  @override
  Future<UserModel> createUser(UserModel model) async {
    final url = Uri.parse('$baseUrl/users');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_name': model.name,
        'user_password': model.password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Error al crear usuario: ${response.body}');
    }
  }

  @override
  Future<UserModel?> getUserByUsername(String username, String password) async {
    final url = Uri.parse('$baseUrl/users/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return UserModel.fromJson(data['user']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw Exception('Error en login: ${response.body}');
    }
  }
}
