import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ✅ Importa la librería oficial

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();

  String? _role;
  DateTime? _dob;

  final _roles = const [
    'Usuario',
    'Administrador',
    'Moderador',
    'Invitado',
  ];

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
    final initial = _dob ?? DateTime(now.year - 18, now.month, now.day);
    final first = DateTime(1900);
    final last = now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      locale: const Locale('es'),
      helpText: 'Fecha de nacimiento',
    );

    if (picked != null) {
      setState(() {
        _dob = picked;
        // ✅ Usa intl.DateFormat para formatear correctamente
        _dobCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final payload = {
      'nombre': _nameCtrl.text.trim(),
      'correo': _emailCtrl.text.trim(),
      'password': _passwordCtrl.text,
      'fechaNacimiento': _dob?.toIso8601String(),
      'rol': _role,
    };

    // Reemplaza con tu lógica de envío a backend (HTTP, Firebase, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registrado: $payload')),
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
                          'Registrarse',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Nombre
                        TextFormField(
                          controller: _nameCtrl,
                          textInputAction: TextInputAction.next,
                          decoration: _decor('Nombre', hint: 'Ingrese su nombre'),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'El nombre es obligatorio';
                            }
                            if (v.trim().length < 2) {
                              return 'Ingrese un nombre válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

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
                          textInputAction: TextInputAction.next,
                          decoration: _decor('Contraseña', hint: 'Ingrese su contraseña'),
                          validator: (v) {
                            final value = v ?? '';
                            if (value.isEmpty) return 'La contraseña es obligatoria';
                            if (value.length < 8) return 'Mínimo 8 caracteres';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Fecha de Nacimiento
                        GestureDetector(
                          onTap: _pickDate,
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _dobCtrl,
                              decoration: _decor(
                                'Fecha de nacimiento',
                                hint: 'dd / mm / aaaa',
                                suffixIcon: const Icon(Icons.calendar_today),
                              ),
                              validator: (_) {
                                if (_dob == null) return 'Seleccione su fecha de nacimiento';
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Rol
                        DropdownButtonFormField<String>(
                          initialValue: _role,
                          items: _roles
                              .map((r) => DropdownMenuItem<String>(
                                    value: r,
                                    child: Text(r),
                                  ))
                              .toList(),
                          decoration: _decor('Rol', hint: 'Seleccione su rol'),
                          onChanged: (v) => setState(() => _role = v),
                          validator: (v) => v == null ? 'Seleccione un rol' : null,
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
                            child: const Text('Registrarse'),
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