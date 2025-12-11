import 'package:flutter/material.dart';
import 'package:mingo/src/data/datasources/sign_datasource.dart';
import 'package:mingo/src/data/datasources/tag_datasource.dart';
import 'package:mingo/src/data/models/sign_model.dart';
import 'package:mingo/src/data/repositories/sign_repository_impl.dart';
import 'package:mingo/src/data/repositories/tag_repository_impl.dart';
import 'package:mingo/src/domain/entities/sign.dart';
import 'package:mingo/src/domain/entities/tag.dart';

class ImportContentPage extends StatefulWidget {
  const ImportContentPage({super.key});

  @override
  State<ImportContentPage> createState() => _ImportContentPageState();
}

class _ImportContentPageState extends State<ImportContentPage> {
  final _formKey = GlobalKey<FormState>();

  late final SignRepositoryImpl _signRepository;
  late final TagRepositoryImpl _tagRepository;

  bool _isLoading = false;
  List<Tag> _tags = [];

  String? _title;
  String? _description; 
  String? _videoUrl;
  String? _imageUrl; 
  SignSection? _section;
  int? _selectedTagId;
  String? _keywords;

  @override
  void initState() {
    super.initState();
    _signRepository = SignRepositoryImpl(dataSource: SignDataSourceImpl());
    _tagRepository = TagRepositoryImpl(dataSource: TagDataSourceImpl());
    _loadTags();
  }

  Future<void> _loadTags() async {
    setState(() => _isLoading = true);
    try {
      final tags = await _tagRepository.getAllTags();
      setState(() {
        _tags = tags;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    List<String> synonyms = _keywords
            ?.split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty) 
            .toList() ?? [];

    // Crear modelo
    final newSign = SignModel(
      signTitle: _title!,
      description: _description!,
      signVideoUrl: _videoUrl!,
      signImageUrl: _imageUrl,
      signSection: _section!,
      tagId: _selectedTagId!,
      synonyms: synonyms,
    );

    try {
      await _signRepository.createSign(newSign);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Contenido guardado correctamente"),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigator.pop(context);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ocurrió un error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F3FF),
      appBar: AppBar(
        title: const Text("Importar Contenido"),
        backgroundColor: const Color(0xFF0A4D8C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Enlaces Multimedia", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _buildField(
                "URL del Video", 
                "Ej. https://video-url.com/video.mp4", 
                (v) => _videoUrl = v,
                icon: Icons.videocam_outlined
              ),
              const SizedBox(height: 15),

              _buildField(
                "URL de la Imagen (Opcional)", 
                "Ej. https://image-url.com/imagen.png", 
                (v) => _imageUrl = v,
                icon: Icons.image_outlined,
                required: false
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),

              const Text("Detalles del Contenido", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),

              _buildField("Título del Contenido", "Ej. Saludo", (v) => _title = v),
              const SizedBox(height: 15),

              DropdownButtonFormField<int>(
                decoration: _inputDecor("Categoría de la Seña"),
                items: _tags.map((t) => DropdownMenuItem(value: t.id, child: Text(t.tagName))).toList(),
                onChanged: (v) => setState(() => _selectedTagId = v),
                validator: (v) => v == null ? "Requerido" : null,
              ),
              const SizedBox(height: 15),

              DropdownButtonFormField<SignSection>(
                decoration: _inputDecor("Nivel Educativo / Sección"),
                items: SignSection.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                onChanged: (v) => setState(() => _section = v),
                validator: (v) => v == null ? "Requerido" : null,
              ),
              const SizedBox(height: 15),

              _buildField(
                _section == SignSection.FrasesComunes ? "Frase Exacta" : "Oración de Ejemplo",
                "Ingresa el texto asociado...",
                (v) => _description = v,
                maxLines: 2
              ),
              const SizedBox(height: 15),

              _buildField("Palabras Clave (Separadas por coma)", "Ej. Casa, Hogar", (v) => _keywords = v),

              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0099FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Importar Contenido", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label, 
    String hint, 
    Function(String?) onSaved, 
    {int maxLines = 1, IconData? icon, bool required = true}
  ) {
    return TextFormField(
      decoration: _inputDecor(label, hint: hint, icon: icon),
      maxLines: maxLines,
      onSaved: onSaved,
      validator: (v) {
        if (!required) return null;
        return (v?.isEmpty ?? true) ? "Requerido" : null;
      },
    );
  }

  InputDecoration _inputDecor(String label, {String? hint, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}