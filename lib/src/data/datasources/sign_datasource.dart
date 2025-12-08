import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mingo/src/domain/repositories/sign_datasource_repository.dart';
import '../models/sign_model.dart';

class SignDataSourceImpl implements SignDataSource {
  final String baseUrl = 'http://10.0.2.2:3000/signs'; 

  @override
  Future<SignModel> createSign(SignModel sign) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(sign.toJson()),
    );

    if (response.statusCode == 201) {
      return SignModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error creating sign: ${response.statusCode}');
    }
  }

  @override
  Future<List<SignModel>> getAllSigns() async {
    final response = await http.get(Uri.parse('$baseUrl/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SignModel.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching signs: ${response.statusCode}');
    }
  }

  @override
  Future<SignModel?> getSignById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return SignModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error fetching sign: ${response.statusCode}');
    }
  }
}
