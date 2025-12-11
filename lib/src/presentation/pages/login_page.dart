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
  bool _obscureText = true;

  // Colores
  final Color _bgColor = const Color(0xFFE6F3FF);
  final Color _primaryColor = const Color(0xFF0099FF);

  void _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(_emailCtrl.text.trim(), _passwordCtrl.text);

    if (!mounted) return;

    if (success) {
      final user = authProvider.currentUser;
      
      // Lógica de Redirección (RF002)
      if (user?.role == 2) {
         // Docente -> Importar Contenido (o Dashboard Docente)
         Navigator.pushReplacementNamed(context, '/import_content');
      } else {
         // Padre -> Test si es Principiante (asumiendo primera vez) o Home
         // Nota: En un caso real usaríamos un flag 'isFirstTime' del backend [cite: 2355]
         bool isFirstLogin = user?.knowledgeLevel == 'Principiante'; 

         if (isFirstLogin) {
            Navigator.pushReplacementNamed(context, '/knowledge_form');
         } else {
            // RF007/RF015: Home del Padre (Dashboard)
            Navigator.pushReplacementNamed(context, '/home'); 
         }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Credenciales incorrectas'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: _bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'MinGO',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0A4D8C)),
              ),
              const SizedBox(height: 8),
              const Text('Iniciar Sesión', style: TextStyle(fontSize: 18, color: Colors.black54)),
              const SizedBox(height: 30),

              // Avatar (UI-02)
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Color(0xFF0099FF)),
              ),
              const SizedBox(height: 24),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Correo Electrónico',
                            prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                          ),
                          validator: (v) => (v?.isEmpty ?? true) ? 'Obligatorio' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscureText = !_obscureText),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                          ),
                          validator: (v) => (v?.isEmpty ?? true) ? 'Obligatorio' : null,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: isLoading 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Iniciar Sesión', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text('¿No tienes cuenta? Regístrate', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}