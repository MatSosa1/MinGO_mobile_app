import 'package:flutter/material.dart';
import 'package:mingo/src/presentation/widgets/quick_video_dialog.dart';
import '../../domain/entities/sign.dart';
import '../strategies/content_strategy.dart';
import 'sign_detail_page.dart';

class DynamicContentPage extends StatelessWidget {
  final ContentStrategy strategy;

  const DynamicContentPage({super.key, required this.strategy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strategy.title),
        backgroundColor: Colors.blue.shade700,
      ),
      body: FutureBuilder<List<Sign>>(
        future: strategy.fetchContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final signs = snapshot.data ?? [];
          if (signs.isEmpty) {
            return const Center(child: Text("No hay contenido disponible."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: signs.length,
            itemBuilder: (context, index) {
              final sign = signs[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                elevation: 3,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignDetailPage(sign: sign),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (sign.signImageUrl != null &&
                          sign.signImageUrl!.isNotEmpty)
                        Hero(
                          tag:
                              sign.id ??
                              sign.signTitle,
                          child: Image.network(
                            sign.signImageUrl!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              height: 180,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 50),
                            ),
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.play_circle_fill,
                                color: Colors.blue,
                                size: 32,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return QuickVideoDialog(
                                      videoUrl: sign.signVideoUrl,
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sign.signTitle,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    sign.signSection.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Clases'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reportes',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        onTap: (index) {

        },
      ),
    );
  }
}
