import 'package:flutter/material.dart';
import 'package:mingo/src/presentation/pages/login_page.dart';
import 'package:mingo/src/presentation/pages/register_page.dart';
import 'package:provider/provider.dart';
import 'src/data/datasources/api_datasource.dart';
import 'src/data/repositories/user_repository_impl.dart';
import 'src/domain/usecases/auth_usecases.dart';
import 'src/presentation/providers/auth_provider.dart';


void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    final apiDatasource = APIDatasource();
    final userRepository = UserRepositoryImpl(datasource: apiDatasource);
    final loginUseCase = LoginUserUseCase(userRepository);
    final registerUseCase = RegisterUserUseCase(userRepository);
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: loginUseCase, 
            registerUseCase: registerUseCase
          ),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MinGO',
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
      },
    );
  }
}