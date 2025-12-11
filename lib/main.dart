import 'package:flutter/material.dart';
import 'package:mingo/src/domain/usecases/user_usecases.dart';
import 'package:mingo/src/presentation/pages/knowledge_form_page.dart';
import 'package:mingo/src/presentation/pages/login_page.dart';
import 'package:mingo/src/presentation/pages/register_page.dart';
import 'package:provider/provider.dart';
import 'src/data/datasources/user_datasource.dart';
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
    final apiDatasource = UserDatasourceImpl();
    final userRepository = UserRepositoryImpl(datasource: apiDatasource);
    final loginUseCase = LoginUserUseCase(userRepository);
    final registerUseCase = RegisterUserUseCase(userRepository);

    final knowledgeUseCase = SetKnowledgeUseCase(userRepository);
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: loginUseCase, 
            registerUseCase: registerUseCase
          ),
        ),
      ],
      child: MyApp(),
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
      initialRoute: '/knowledge_form',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/knowledge_form': (_) => KnowledgeFormPage(),
      },
    );
  }
}