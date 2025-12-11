import 'package:flutter/material.dart';

class ImportContentPage extends StatefulWidget {
  const ImportContentPage({super.key});

  @override
  State<ImportContentPage> createState() => _ImportContentPageState();
}

class _ImportContentPageState extends State<ImportContentPage> {
  final _formKey = GlobalKey<FormState>();

  String? phrase;
  String? title;
  String? ageCategory;
  String? educationLevel;
  String? associatedPhrases;
  String? keywords;

  final ageOptions = ["Niños", "Adolescentes", "Adultos"];
  final educationOptions = ["Inicial", "Primaria", "Secundaria", "Superior"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("8. Importar contenido"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Archivos Multimedia
              const Text("Archivos Multimedia", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.video_library),
                    label: const Text("Subir Video"),
                    onPressed: () {
                      // Acción simulada
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text("Subir Imagen"),
                    onPressed: () {
                      // Acción simulada
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              /// Frase Asociada
              const Text("Frase Asociada", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(hintText: "Ingresa la frase asociada a la seña"),
                onChanged: (v) => phrase = v,
              ),
              const SizedBox(height: 24),

              /// Detalles del Contenido
              const Text("Detalles del Contenido", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              /// Título
              const Text("Título del Contenido", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(hintText: "Ej. Saludo de Buenos Días"),
                onChanged: (v) => title = v,
              ),
              const SizedBox(height: 20),

              /// Categoría de Edad
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Categoría de Edad"),
                items: ageOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => ageCategory = v,
              ),
              const SizedBox(height: 20),

              /// Nivel Educativo
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Nivel Educativo"),
                items: educationOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => educationLevel = v,
              ),
              const SizedBox(height: 20),

              /// Frases Asociadas
              const Text("Frases Asociadas a la Seña", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(hintText: "Ingresa frases adicionales separadas por comas"),
                onChanged: (v) => associatedPhrases = v,
              ),
              const SizedBox(height: 20),

              /// Palabras Clave
              const Text("Palabras Clave (Sinónimos/Términos Relacionados)", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(hintText: "Ingresa palabras clave separadas por comas"),
                onChanged: (v) => keywords = v,
              ),
              const SizedBox(height: 30),

              /// Botón Importar
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Importar Contenido"),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Formulario validado. Listo para importar.")),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      /// Barra inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Clases activo
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Clases'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reportes'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
        onTap: (index) {
          // Navegación entre secciones
        },
      ),
    );
  }
}