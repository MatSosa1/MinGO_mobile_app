import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final payload = {
      'correo': _emailCtrl.text.trim(),
      'password': _passwordCtrl.text,
    };

    // Reemplaza con tu lógica de autenticación (HTTP, Firebase, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Inicio de sesión: $payload')),
    );
  }

  InputDecoration _decor(String label, {String? hint, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F3FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'MinGO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A4D8C),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Iniciar Sesión',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Correo
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: _decor('Correo electrónico', hint: 'Ingrese su correo electrónico'),
                          validator: (v) {
                            final value = v?.trim() ?? '';
                            final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                            if (value.isEmpty) return 'El correo es obligatorio';
                            if (!emailRegex.hasMatch(value)) return 'Ingrese un correo válido';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Contraseña
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: _decor('Contraseña', hint: 'Ingrese su contraseña'),
                          validator: (v) {
                            final value = v ?? '';
                            if (value.isEmpty) return 'La contraseña es obligatoria';
                            if (value.length < 8) return 'Mínimo 8 caracteres';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Botón
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A4D8C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Iniciar Sesión'),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Enlace a registro
                        TextButton(
                          onPressed: () {
                            // Navega a la pantalla de registro
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text('¿No tienes cuenta? Registrarse'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}