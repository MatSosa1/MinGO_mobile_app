import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mingo/src/presentation/providers/auth_provider.dart';

class KnowledgeFormPage extends StatefulWidget {
  const KnowledgeFormPage({super.key});

  @override
  State<KnowledgeFormPage> createState() => _KnowledgeFormPageState();
}

class _KnowledgeFormPageState extends State<KnowledgeFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Variables de estado para las 10 preguntas
  String? q1; // Conocimiento general
  String? q2; // Alfabeto
  String? q3; // Frecuencia de uso
  String? q4; // Cultura sorda
  String? q5; // Recursos visuales
  String? q6; // Vocabulario básico
  String? q7; // Interacción
  String? q8; // Dificultades (Inverso)
  String? q9; // Experiencia previa
  String? q10; // Accesibilidad

  int _getScore(String? answer, Map<String, int> values) {
    if (answer == null) return 0;
    return values[answer] ?? 0;
  }

  int _calculateTotalScore() {
    int score = 0;
    // P1: ¿Conoce algo de lengua de señas?
    score += _getScore(q1, {"Sí": 5, "Algo": 3, "No": 0});
    // P2: ¿Conoce el alfabeto dactilológico?
    score += _getScore(q2, {"Sí, completo": 5, "Algunas letras": 3, "No": 0});
    // P3: ¿Con qué frecuencia practica o ve señas?
    score += _getScore(q3, {"Frecuentemente": 5, "A veces": 3, "Nunca": 0});
    // P4: ¿Ha escuchado sobre la cultura sorda?
    score += _getScore(q4, {"Sí": 5, "He escuchado": 3, "No": 0});
    // P5: ¿Usa videos o libros para aprender?
    score += _getScore(q5, {"Sí": 5, "Solo uno": 3, "No": 0});
    // P6: ¿Reconoce saludos básicos?
    score += _getScore(q6, {"Sí, todos": 5, "Algunos": 3, "No": 0});
    // P7: ¿Ha interactuado con personas sordas?
    score += _getScore(q7, {"Sí, varios": 5, "Solo una": 3, "Nadie": 0});
    // P8: ¿Tiene dificultades para comprender gestos? (Inverso: No tener dificultades da más puntos)
    score += _getScore(q8, {"No": 5, "A veces": 3, "Sí": 0}); 
    // P9: ¿Ha participado en cursos previos?
    score += _getScore(q9, {"Sí": 5, "Informal": 3, "No": 0});
    // P10: ¿Tiene acceso a cámara/audio?
    score += _getScore(q10, {"Sí": 5, "Parcial": 3, "No": 0});
    
    return score;
  }

  void _submitResults() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      if ([q1, q2, q3, q4, q5, q6, q7, q8, q9, q10].contains(null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor responda todas las preguntas")),
        );
        return;
      }

      final score = _calculateTotalScore();
      String assignedLevel = 'Principiante';

      if (score >= 31) {
        assignedLevel = 'Avanzado';
      } else if (score >= 16) {
        assignedLevel = 'Intermedio';
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.updateKnowledgeLevel(assignedLevel);

      if (!mounted) return;

      if (success) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text("¡Evaluación Completada!"),
            content: Text("Tu puntaje fue: $score\nTu nivel asignado es: $assignedLevel"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacementNamed(context, '/categorized_phrases');
                },
                child: const Text("Continuar"),
              )
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al guardar el nivel. Intente nuevamente.")),
        );
      }
    }
  }

  Widget _buildQuestion(String title, List<String> options, String? groupValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0A4D8C))),
        const SizedBox(height: 8),
        ...options.map((option) => RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: groupValue,
          contentPadding: EdgeInsets.zero,
          activeColor: const Color(0xFF0099FF),
          onChanged: onChanged,
        )),
        const Divider(height: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Prueba de Conocimiento"),
        backgroundColor: const Color(0xFF0A4D8C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Responde las siguientes preguntas para personalizar tu experiencia en MinGO.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 24),

              // Pregunta 1
              _buildQuestion("1. ¿Conoce algo de lengua de señas?", ["Sí", "Algo", "No"], q1, (v) => setState(() => q1 = v)),

              // Pregunta 2
              _buildQuestion("2. ¿Conoce el alfabeto dactilológico?", ["Sí, completo", "Algunas letras", "No"], q2, (v) => setState(() => q2 = v)),

              // Pregunta 3
              _buildQuestion("3. ¿Con qué frecuencia practica?", ["Frecuentemente", "A veces", "Nunca"], q3, (v) => setState(() => q3 = v)),

              // Pregunta 4
              _buildQuestion("4. ¿Ha escuchado sobre la cultura sorda?", ["Sí", "He escuchado", "No"], q4, (v) => setState(() => q4 = v)),

              // Pregunta 5
              _buildQuestion("5. ¿Usa recursos visuales (videos/libros)?", ["Sí", "Solo uno", "No"], q5, (v) => setState(() => q5 = v)),

              // Pregunta 6
              _buildQuestion("6. ¿Reconoce saludos básicos en LSEC?", ["Sí, todos", "Algunos", "No"], q6, (v) => setState(() => q6 = v)),

              // Pregunta 7
              _buildQuestion("7. ¿Ha interactuado con personas sordas?", ["Sí, varios", "Solo una", "Nadie"], q7, (v) => setState(() => q7 = v)),

              // Pregunta 8
              _buildQuestion("8. ¿Tiene dificultades para comprender gestos?", ["No", "A veces", "Sí"], q8, (v) => setState(() => q8 = v)),

              // Pregunta 9
              _buildQuestion("9. ¿Experiencia educativa previa en señas?", ["Sí", "Informal", "No"], q9, (v) => setState(() => q9 = v)),

              // Pregunta 10
              _buildQuestion("10. ¿Accesibilidad tecnológica (Cámara/Audio)?", ["Sí", "Parcial", "No"], q10, (v) => setState(() => q10 = v)),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitResults,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0099FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Calcular Nivel y Continuar", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}