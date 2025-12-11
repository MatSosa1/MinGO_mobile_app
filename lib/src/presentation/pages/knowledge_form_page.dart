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

  // Respuestas
  final Map<int, dynamic> _answers = {};

  // Preguntas según Anexo 4.18
  final List<Map<String, dynamic>> _questions = [
    {
      "id": 1,
      "q": "¿Conoce alguna seña básica de saludo (ej. 'Hola')?",
      "options": ["Sí", "Algo", "No"],
      "scores": [5, 3, 0],
    },
    {
      "id": 2,
      "q": "¿Ha usado imágenes o gestos para comunicarse con su hijo(a)?",
      "options": ["Frecuentemente", "A veces", "Nunca"],
      "scores": [5, 3, 0],
    },
    {
      "id": 3,
      "q": "¿Conoce qué es la lengua de señas ecuatoriana (LSEC)?",
      "options": ["Sí", "He escuchado, pero no la uso", "No"],
      "scores": [5, 3, 0],
    },
    {
      "id": 4,
      "q": "¿Ha intentado enseñar alguna seña a su hijo(a) anteriormente?",
      "options": ["Sí", "Lo intento, pero no sé cómo", "No"],
      "scores": [5, 3, 0],
    },
    {
      "id": 5,
      "q": "¿Ha consultado libros, videos, o tutoriales sobre señas?",
      "options": ["Sí", "Solo videos / Solo libros", "No"],
      "scores": [5, 3, 0],
    },
    {
      "id": 6,
      "q": "¿Alguien más en su entorno conoce acerca de la lengua de señas?",
      "options": ["Sí, varios", "Solo una persona", "Nadie / No lo sé"],
      "scores": [5, 3, 0],
    },
    {
      "id": 7,
      "q": "¿Considera que tiene dificultades para comprender gestos?",
      "options": ["No", "A veces", "Sí / No lo he intentado"],
      "scores": [5, 3, 0],
    },
    {
      "id": 8,
      "q": "¿Ha participado antes en cursos o talleres sobre LSEC?",
      "options": ["Sí", "De manera informal", "No"],
      "scores": [5, 3, 0],
    },
    {
      "id": 9,
      "q": "¿Tiene acceso a un dispositivo con cámara y audio funcional?",
      "options": ["Sí", "Parcial", "No"],
      "scores": [5, 3, 0],
    },
  ];

  int _calculateScore() {
    int total = 0;
    for (var q in _questions) {
      if (q['type'] == 'number') continue;
      final answer = _answers[q['id']];
      if (answer != null) {
        final index = (q['options'] as List).indexOf(answer);
        if (index != -1) {
          total += (q['scores'] as List)[index] as int;
        }
      }
    }
    return total;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final score = _calculateScore();

      String level = 'Principiante';
      if (score >= 31) {
        level = 'Avanzado';
      } else if (score >= 16) {
        level = 'Intermedio';
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.updateKnowledgeLevel(level);

      if (success && mounted) {
        _showResultDialog(score, level);
      }
    }
  }

  void _showResultDialog(int score, String level) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 60, color: Color(0xFF0099FF)),
            const SizedBox(height: 10),
            const Text(
              "¡Perfecto!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0099FF),
              ),
            ),
            const SizedBox(height: 10),
            Text("Puntaje Obtenido: $score/45"),
            const SizedBox(height: 5),
            Text(
              "Nivel Inicial: $level",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 15),
            const Text(
              "Hemos personalizado tu experiencia según tus respuestas.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacementNamed(
                    context,
                    '/home',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0099FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Continuar"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F3FF),
      appBar: AppBar(
        title: const Text("Prueba de Conocimiento"),
        backgroundColor: const Color(0xFF0A4D8C),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Cuestionario de Conocimiento",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ..._questions.map((q) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${q['id']}. ${q['q']}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        if (q.containsKey('options'))
                          ...((q['options'] as List).map(
                            (opt) => RadioListTile(
                              title: Text(opt),
                              value: opt,
                              groupValue: _answers[q['id']],
                              activeColor: const Color(0xFF0099FF),
                              contentPadding: EdgeInsets.zero,
                              onChanged: (val) =>
                                  setState(() => _answers[q['id']] = val),
                            ),
                          ))
                        else
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Ingresar edad (años)",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                            onSaved: (val) => _answers[q['id']] = val,
                            validator: (v) =>
                                (v?.isEmpty ?? true) ? "Requerido" : null,
                          ),
                        const Divider(height: 30),
                      ],
                    );
                  }),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0099FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Enviar Prueba",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
