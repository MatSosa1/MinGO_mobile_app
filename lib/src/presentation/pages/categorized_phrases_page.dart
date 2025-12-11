import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F3FF),
      appBar: AppBar(
        title: const Text("MinGO", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A4D8C))),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "¡Bienvenido/a!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0A4D8C)),
            ),
            const SizedBox(height: 8),
            const Text(
              "Explora las funcionalidades de MinGO y ayuda a tu hijo a aprender.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/link_class'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0099FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text("Enlazar a una clase", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 25),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text("Tu Clase Actual", style: TextStyle(fontWeight: FontWeight.bold)),
                    const Divider(),
                    _infoRow("Nivel:", "Principiante"),
                    _infoRow("Categoría:", "Saludos y Despedidas"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            _navCard(
              context,
              icon: Icons.chat_bubble_outline,
              title: "Frases Comunes",
              subtitle: "Aprende frases esenciales para el día a día.",
              onTap: () {
                // Navegar a la lista real usando el Factory
                Navigator.pushNamed(context, '/categorized_phrases_list');
              },
            ),
            const SizedBox(height: 15),

            _navCard(
              context,
              icon: Icons.bar_chart,
              title: "Ver Reportes",
              subtitle: "Revisa el progreso de tu aprendizaje.",
              onTap: () {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF0099FF),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Clases'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A4D8C))),
        ],
      ),
    );
  }

  Widget _navCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFE6F3FF), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: const Color(0xFF0099FF)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}