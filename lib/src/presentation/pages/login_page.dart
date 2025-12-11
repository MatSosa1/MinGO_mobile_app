import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mingo/src/presentation/providers/auth_provider.dart';

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

  void _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // RF002: Validación de credenciales
    final success = await authProvider.login(
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
    );

    if (!mounted) return;

    if (success) {
      final user = authProvider.currentUser;
      
      // --- LÓGICA DE REDIRECCIÓN CORREGIDA ---
      
      // CASO 1: DOCENTE (Rol ID 2)
      // El docente NO realiza prueba de conocimiento y va directo a importar contenido.
      if (user?.role == 2) {
         Navigator.pushReplacementNamed(context, '/import_content');
      } 
      
      // CASO 2: PADRE/ESTUDIANTE (Rol ID 1)
      else {
         // Si es nivel 'Principiante', asumimos que es primera vez y debe hacer el test.
         // (O si tuvieras un flag hasTakenTest en la BD, lo usarías aquí).
         bool isFirstLogin = user?.knowledgeLevel == 'Principiante';

         if (isFirstLogin) {
            // RF003: Redirigir a Prueba de Conocimiento
            Navigator.pushReplacementNamed(context, '/knowledge_form');
         } else {
            // RF007/RF005: Redirigir al Home (Frases Comunes o última vista)
            Navigator.pushReplacementNamed(context, '/categorized_phrases'); 
         }
      }
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Credenciales incorrectas'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ... (Resto del diseño visual idéntico al anterior)
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
    final isLoading = context.watch<AuthProvider>().isLoading;

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
                            color: Color(0xFF0A4D8C) 
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Iniciar Sesión',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        const SizedBox(height: 24),

                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: _decor('Correo electrónico', hint: 'ejemplo@correo.com'),
                          validator: (v) {
                            if (v?.trim().isEmpty ?? true) return 'El correo es obligatorio';
                            if (!v!.contains('@')) return 'Ingrese un correo válido';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: _decor('Contraseña', hint: 'Ingrese su contraseña'),
                          validator: (v) {
                            if (v?.isEmpty ?? true) return 'La contraseña es obligatoria';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A4D8C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24, 
                                    height: 24, 
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                  )
                                : const Text('Iniciar Sesión'),
                          ),
                        ),

                        const SizedBox(height: 16),
                        
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/register'),
                          child: const Text(
                            '¿No tienes cuenta? Registrarse',
                            style: TextStyle(color: Color(0xFF0A4D8C), fontWeight: FontWeight.bold),
                          ),
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