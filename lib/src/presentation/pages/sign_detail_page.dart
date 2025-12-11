import 'package:flutter/material.dart';
import '../../domain/entities/sign.dart';
import '../widgets/quick_video_dialog.dart';

class SignDetailPage extends StatelessWidget {
  final Sign sign;

  const SignDetailPage({super.key, required this.sign});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sign.signTitle),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (sign.signImageUrl != null)
              Hero(
                tag: sign.id ?? sign.signTitle,
                child: InteractiveViewer(
                  child: Image.network(
                    sign.signImageUrl!,
                    height: 300,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Container(
                        height: 300, 
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 80, color: Colors.grey)),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sign.signTitle,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0A4D8C)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      sign.signSection.name,
                      style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  const Text(
                    "Descripción",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    sign.description.isNotEmpty 
                        ? sign.description 
                        : "No hay una descripción detallada disponible para esta seña.",
                    style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                  ),
                  
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => QuickVideoDialog(videoUrl: sign.signVideoUrl),
                        );
                      },
                      icon: const Icon(Icons.play_circle_fill, size: 28),
                      label: const Text("Ver Video", style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF0099FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}