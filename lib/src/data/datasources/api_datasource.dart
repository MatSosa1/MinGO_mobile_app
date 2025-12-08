import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

abstract class DatasourceRepository {
  Future<UserModel?> login(String email, String password);
  Future<UserModel> createUser(UserModel model);
}

class APIDatasource extends DatasourceRepository {
  final String baseUrl = 'http://10.0.2.2:3000'; 

  @override
  Future<UserModel> createUser(UserModel model) async {
    final url = Uri.parse('$baseUrl/users/register');

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
  Future<UserModel?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/users/login');

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
}