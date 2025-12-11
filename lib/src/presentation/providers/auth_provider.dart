import 'package:flutter/material.dart';
import 'package:mingo/src/data/models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/auth_usecases.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUserUseCase _loginUseCase;
  final RegisterUserUseCase _registerUseCase;

  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  AuthProvider({
    required LoginUserUseCase loginUseCase,
    required RegisterUserUseCase registerUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = await _loginUseCase(email, password);
      if (user != null) {
        _currentUser = user;
        _setLoading(false);
        return true;
      } else {
        _errorMessage = "Credenciales incorrectas. Verifique su correo y contraseña.";
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = "Error de conexión: $e";
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(User user) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _registerUseCase(user);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = "Error al registrar: $e";
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

Future<bool> updateKnowledgeLevel(String level) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 1)); 
      _currentUser = UserModel(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        birthDate: _currentUser!.birthDate,
        role: _currentUser!.role,
        password: null,
        knowledgeLevel: level,
      );
      
      notifyListeners();
      _setLoading(false);
      return true;

    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }
}