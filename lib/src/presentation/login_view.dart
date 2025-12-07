import 'package:flutter/material.dart';
import 'package:mingo/src/data/datasources/api_datasource.dart';
import 'package:mingo/src/data/repositories/user_repository_impl.dart';
import 'package:mingo/src/domain/entities/user.dart';
import 'package:mingo/src/domain/repositories/user_repository.dart';

class LoginView extends StatefulWidget {
  final UserRepository _repo = UserRepositoryImpl(datasource: APIDatasource());

  LoginView({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          spacing: 8,
          children: [
            TextField(
              controller: usernameCtrl,
              decoration: InputDecoration(
                label: Text('Usuario')
              ),
            ),
            TextField(
              controller: passwordCtrl,
              decoration: InputDecoration(
                label: Text('Contraseña')
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                User? user = await widget._repo.loginUser(usernameCtrl.text, passwordCtrl.text);

                if (user != null) {
                  // Redireccionamiento a nueva página
                  print(user.name);
                }
              },
              child: Text('Login')
            ),
          ],
        ),
      )
    );
  }
}
