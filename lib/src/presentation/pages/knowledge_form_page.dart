import 'package:flutter/material.dart';

class KnowledgeFormPage extends StatefulWidget {
  const KnowledgeFormPage({super.key});

  @override
  State<StatefulWidget> createState() => _KnowledgeFormPageState();
}

class _KnowledgeFormPageState extends State<KnowledgeFormPage> {
  final _formKey = GlobalKey<FormState>();

  String? q1;
  int? q2;
  String? q3;
  String? q4;
  String? q5;
  String? q6;
  String? q7;
  String? q8;
  String? q9;
  String? q10;

  final Map<int, Map<String, int>> scoreTable = {
    1: { "Sí": 5, "Algo": 3, "No": 0 },
    3: { "Frecuentemente": 5, "A veces": 3, "Nunca": 0 },
    4: { "Sí": 5, "He escuchado pero no la uso": 3, "No": 0 },
    5: { "Sí": 5, "Solo videos": 3, "Solo libros": 3, "No": 0 },
    6: { "Sí": 5, "Lo intento pero no sé cómo": 3, "No": 0 },
    7: { "Sí, varios": 5, "Solo una persona": 3, "No lo sé": 1, "Nadie": 0 },
    8: { "No": 5, "A veces": 3, "Sí": 0, "No lo he intentado": 1 },
    9: { "Sí": 5, "De manera informal": 3, "No": 0 },
    10: { "Sí": 5, "Parcial (solo cámara o solo audio)": 3, "No": 0 },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Formulario de Conocimiento")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 1. Conocimiento básico de señas
              _buildRadioGroup(
                label: "1. ¿Conoce alguna seña básica de saludo?",
                value: q1,
                items: ["Sí", "No", "Algo"],
                onChanged: (v) => setState(() => q1 = v),
              ),

              /// 2. Edad del hijo/hija
              Text("2. ¿Qué edad tiene su hijo o hija con discapacidad auditiva?",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Ingrese edad (1 a 12 años)"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Ingrese una edad";
                  final n = int.tryParse(value);
                  if (n == null || n < 1 || n > 12) {
                    return "Edad debe estar entre 1 y 12";
                  }
                  return null;
                },
                onChanged: (v) => q2 = int.tryParse(v),
              ),
              SizedBox(height: 20),

              /// 3. Estrategias de comunicación
              _buildRadioGroup(
                label: "3. ¿Ha usado imágenes o gestos para comunicarse con su hijo(a)?",
                value: q3,
                items: ["Frecuentemente", "A veces", "Nunca"],
                onChanged: (v) => setState(() => q3 = v),
              ),

              /// 4. Lenguaje inclusivo
              _buildRadioGroup(
                label: "4. ¿Conoce qué es la lengua de señas ecuatoriana (LSEC)?",
                value: q4,
                items: ["Sí", "No", "He escuchado pero no la uso"],
                onChanged: (v) => setState(() => q4 = v),
              ),

              /// 5. Práctica previa
              _buildRadioGroup(
                label: "5. ¿Ha intentado enseñar alguna seña a su hijo(a) anteriormente?",
                value: q5,
                items: ["Sí", "No", "Lo intento pero no sé cómo"],
                onChanged: (v) => setState(() => q5 = v),
              ),

              /// 6. Recursos utilizados
              _buildRadioGroup(
                label: "6. ¿Ha consultado libros, videos, o tutoriales sobre señas?",
                value: q6,
                items: ["Sí", "No", "Solo videos", "Solo libros"],
                onChanged: (v) => setState(() => q6 = v),
              ),

              /// 7. Recursos en el entorno
              _buildRadioGroup(
                label: "7. ¿Alguien más en su entorno conoce acerca de la lengua de señas?",
                value: q7,
                items: ["Sí, varios", "Solo una persona", "Nadie", "No lo sé"],
                onChanged: (v) => setState(() => q7 = v),
              ),

              /// 8. Dificultades actuales
              _buildRadioGroup(
                label: "8. ¿Considera que tiene dificultades para comprender gestos?",
                value: q8,
                items: ["Sí", "No", "A veces", "No lo he intentado"],
                onChanged: (v) => setState(() => q8 = v),
              ),

              /// 9. Experiencia educativa previa
              _buildRadioGroup(
                label: "9. ¿Ha participado antes en cursos o talleres sobre LSEC?",
                value: q9,
                items: ["Sí", "No", "De manera informal"],
                onChanged: (v) => setState(() => q9 = v),
              ),

              /// 10. Accesibilidad tecnológica
              _buildRadioGroup(
                label: "10. ¿Tiene acceso a un dispositivo con cámara y audio funcional?",
                value: q10,
                items: ["Sí", "No", "Parcial (solo cámara o solo audio)"],
                onChanged: (v) => setState(() => q10 = v),
              ),

              SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (!_allQuestionsAnswered()) {
                        _showError(context);
                        return;
                      }

                      _showResults(context);
                    }
                  },
                  child: Text("Enviar"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioGroup({
  required String label,
  required String? value,
  required List<String> items,
  required Function(String?) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),

        Column(
          children: items.map((item) {
            return RadioListTile<String>(
              title: Text(item),
              value: item,
              groupValue: value,
              onChanged: onChanged,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        ),
      ],
    ),
  );
}

  /// Mostrar resultados
  void _showResults(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Respuestas registradas"),
        content: SingleChildScrollView(
          child: Text(_getTotalScore().toString()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cerrar"))
        ],
      ),
    );
  }

  int _getTotalScore() {
    int total = 0;

    void addScore(int pregunta, String? respuesta) {
      if (respuesta != null && scoreTable[pregunta]!.containsKey(respuesta)) {
        int score = scoreTable[pregunta]![respuesta]!;

        print('${scoreTable[pregunta]!}: $score');

        total += score;
      }
    }

    addScore(1, q1);
    addScore(3, q3);
    addScore(4, q4);
    addScore(5, q5);
    addScore(6, q6);
    addScore(7, q7);
    addScore(8, q8);
    addScore(9, q9);
    addScore(10, q10);

    return total;
  }

  bool _allQuestionsAnswered() {
    return  q1 != null &&
            q2 != null &&
            q3 != null &&
            q4 != null &&
            q5 != null &&
            q6 != null &&
            q7 != null &&
            q8 != null &&
            q9 != null &&
            q10 != null;
  }
}

  void _showError(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Campos incompletos"),
        content: Text("Por favor responda todas las preguntas antes de continuar."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Aceptar"),
          ),
        ],
      ),
    );
  }
