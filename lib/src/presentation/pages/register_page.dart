import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mingo/src/data/models/user_model.dart';
import 'package:mingo/src/presentation/providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();

  String? _role;
  DateTime? _dob;
  bool _obscureText = true;

  final _roles = const ['Padre', 'Docente'];

  // Colores del Diseño (UI-01)
  final Color _bgColor = const Color(0xFFE6F3FF); // Azul Claro
  final Color _primaryColor = const Color(0xFF0099FF); // Azul MinGO

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final first = DateTime(1900);
    final last = DateTime(now.year - 18, now.month, now.day); // Mayor de edad sugerido

    final picked = await showDatePicker(
      context: context,
      initialDate: last,
      firstDate: first,
      lastDate: now,
      locale: const Locale('es'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: _primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    
    // Mapeo de Roles según SRS
    final int roleId = (_role == 'Padre') ? 1 : 2;

    final newUser = UserModel(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      birthDate: _dob!,
      role: roleId,
      knowledgeLevel: 'Principiante', // Se define luego en el Test (RF003)
      id: null,
    );

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.register(newUser);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso. Inicie sesión.')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Error en el registro'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  InputDecoration _inputDecor(String label, {IconData? icon, IconButton? suffix}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'MinGO',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0A4D8C),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Registrarse',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              
              // Tarjeta Blanca (UI-01)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Nombre
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: _inputDecor('Nombre', icon: Icons.person_outline),
                          validator: (v) => (v?.isEmpty ?? true) ? 'Obligatorio' : null,
                        ),
                        const SizedBox(height: 16),

                        // Correo
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecor('Correo Electrónico', icon: Icons.email_outlined),
                          validator: (v) => (!v!.contains('@')) ? 'Correo inválido' : null,
                        ),
                        const SizedBox(height: 16),

                        // Contraseña
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: _obscureText,
                          decoration: _inputDecor(
                            'Contraseña',
                            icon: Icons.lock_outline,
                            suffix: IconButton(
                              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscureText = !_obscureText),
                            ),
                          ),
                          validator: (v) => (v!.length < 8) ? 'Mínimo 8 caracteres' : null,
                        ),
                        const SizedBox(height: 16),

                        // Fecha Nacimiento
                        GestureDetector(
                          onTap: _pickDate,
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _dobCtrl,
                              decoration: _inputDecor('Fecha de Nacimiento', icon: Icons.calendar_today),
                              validator: (_) => _dob == null ? 'Obligatorio' : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Rol
                        DropdownButtonFormField<String>(
                          value: _role,
                          items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                          onChanged: (v) => setState(() => _role = v),
                          decoration: _inputDecor('Rol', icon: Icons.badge_outlined),
                          validator: (v) => v == null ? 'Seleccione un rol' : null,
                        ),
                        const SizedBox(height: 24),

                        // Botón Registrarse
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Registrarse', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('¿Ya tienes cuenta? Inicia Sesión', style: TextStyle(color: _primaryColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}