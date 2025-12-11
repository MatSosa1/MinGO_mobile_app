import 'package:flutter/material.dart';

class CategorizedPhrasesPage extends StatelessWidget {
  const CategorizedPhrasesPage({super.key});

  final List<Map<String, String>> phrases = const [
    {
      "imageUrl": "https://images.unsplash.com/photo-1604014237744-0e7c5f3f3c3e", 
      "text": "Hola",
      "description": "Señal para saludar a alguien.",
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1589571894960-20bbe2828d0d", 
      "text": "Adiós",
      "description": "Señal para despedirse de alguien.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("5. Categorizar frases comunes"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: phrases.length,
        itemBuilder: (context, index) {
          final phrase = phrases[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Imagen decorativa
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  child: Image.network(
                    phrase["imageUrl"]!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                /// Contenido textual
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      /// Botón de reproducción (simulado)
                      IconButton(
                        icon: const Icon(Icons.play_circle_fill, color: Colors.blue, size: 32),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Reproduciendo '${phrase["text"]}'")),
                          );
                        },
                      ),
                      const SizedBox(width: 12),

                      /// Frase y descripción
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              phrase["text"]!,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              phrase["description"]!,
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        onTap: (index) {
          // Navegación entre secciones
        },
      ),
    );
  }
}