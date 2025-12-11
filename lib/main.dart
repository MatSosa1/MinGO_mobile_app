import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // IMPORTANTE
import 'package:mingo/src/presentation/pages/categorized_phrases_page.dart';
import 'package:provider/provider.dart';

// Imports de Capas de Datos y Dominio
import 'package:mingo/src/data/datasources/sign_datasource.dart';
import 'package:mingo/src/data/datasources/user_datasource.dart';
import 'package:mingo/src/data/repositories/sign_repository_impl.dart';
import 'package:mingo/src/data/repositories/user_repository_impl.dart';
import 'package:mingo/src/domain/entities/sign.dart';
import 'package:mingo/src/domain/usecases/auth_usecases.dart';

// Imports de Presentación
import 'package:mingo/src/presentation/factories/content_page_factory.dart';
import 'package:mingo/src/presentation/pages/import_content_page.dart';
import 'package:mingo/src/presentation/pages/knowledge_form_page.dart';
import 'package:mingo/src/presentation/pages/login_page.dart';
import 'package:mingo/src/presentation/pages/register_page.dart';
import 'package:mingo/src/presentation/providers/auth_provider.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Inicialización de Datasources
    final userDatasource = UserDatasourceImpl();
    final signDatasource = SignDataSourceImpl();

    // 2. Inicialización de Repositorios
    final userRepository = UserRepositoryImpl(datasource: userDatasource);
    final signRepository = SignRepositoryImpl(dataSource: signDatasource);

    // 3. Inicialización de Casos de Uso
    final loginUseCase = LoginUserUseCase(userRepository);
    final registerUseCase = RegisterUserUseCase(userRepository);

    // 4. Inicialización de Factories (Patrón Factory)
    final contentFactory = ContentPageFactory(signRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
          ),
        ),
        Provider<ContentPageFactory>.value(value: contentFactory),
      ],
      child: MyApp(contentFactory: contentFactory),
    );
  }
}

class MyApp extends StatelessWidget {
  final ContentPageFactory contentFactory;

  const MyApp({super.key, required this.contentFactory});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MinGO',
      
      // --- CONFIGURACIÓN DE LOCALIZACIÓN ---
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'), // Español
        Locale('en'), // Inglés (opcional)
      ],
      // -------------------------------------
      initialRoute: '/login', 
      
      routes: {
        // --- AUTENTICACIÓN ---
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        
        '/knowledge_form': (_) => const KnowledgeFormPage(),
        
        // --- NAVEGACIÓN PRINCIPAL (NUEVO DASHBOARD) ---
        '/home': (_) => const HomePage(),
        
        // --- CONTENIDO EDUCATIVO (LISTAS) ---
        '/categorized_phrases_list': (_) => contentFactory.createPage(SignSection.FrasesComunes),

        '/level_beginner': (_) => contentFactory.createPage(SignSection.Principiante),
        '/level_intermediate': (_) => contentFactory.createPage(SignSection.Intermedio),
        '/level_advanced': (_) => contentFactory.createPage(SignSection.Avanzado),

        // --- FUNCIONES DE DOCENTE ---
        '/import_content': (_) => const ImportContentPage(),
        
        // --- RUTAS PENDIENTES / PLACEHOLDERS ---
        // Estas rutas son necesarias para que los botones del Dashboard no den error.
        // Puedes implementar las pantallas reales luego.
      
        '/link_class': (_) => Scaffold(
          appBar: AppBar(title: const Text("Enlazar Clase")),
          body: const Center(child: Text("Pantalla de Enlazar Clase (Pendiente)")),
        ),
      },
    );
  }
}