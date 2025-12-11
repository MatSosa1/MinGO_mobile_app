import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mingo/src/presentation/pages/login_page.dart';
import 'package:mingo/src/presentation/pages/register_page.dart';
import 'package:mingo/src/presentation/pages/knowledge_form_page.dart';
import 'package:mingo/src/presentation/pages/categorized_phrases_page.dart';
import 'package:mingo/src/presentation/pages/import_content_page.dart';
import 'package:mingo/src/presentation/providers/auth_provider.dart';
import 'package:mingo/src/domain/usecases/auth_usecases.dart';
import 'package:mingo/src/domain/usecases/user_usecases.dart';
import 'package:mingo/src/data/datasources/user_datasource.dart';
import 'package:mingo/src/data/repositories/user_repository_impl.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    final apiDatasource = APIDatasource();
    final userRepository = UserRepositoryImpl(datasource: apiDatasource);

    // Casos de uso
    final loginUseCase = LoginUserUseCase(userRepository);
    final registerUseCase = RegisterUserUseCase(userRepository);
    final knowledgeUseCase = SetKnowledgeUseCase(userRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
          ),
        ),
        // Puedes agregar más providers aquí si luego conectas frases o multimedia
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
      initialRoute: '/knowledge_form',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/knowledge_form': (_) => const KnowledgeFormPage(),
        '/categorized_phrases': (_) => const CategorizedPhrasesPage(),
        '/import_content': (_) => const ImportContentPage(),
      },
    );
  }
}