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
  
  // Repositorios
  late final SignRepositoryImpl _signRepository;
  late final TagRepositoryImpl _tagRepository;

  bool _isLoading = false;
  List<Tag> _tags = [];
  
  // Datos del formulario
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
    // Simulación de carga de tags/categorías
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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      // Conversión de palabras clave
      List<String> synonyms = _keywords?.split(',').map((e) => e.trim()).toList() ?? [];

      final newSign = SignModel(
        signTitle: _title!,
        description: _description!,
        signVideoUrl: _videoUrl ?? "http://video.placeholder", // Valor por defecto si es simulación
        signImageUrl: _imageUrl,
        signSection: _section!,
        tagId: _selectedTagId!,
        synonyms: synonyms,
      );

      try {
        await _signRepository.createSign(newSign);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Contenido importado exitosamente")));
        setState(() => _isLoading = false);
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
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
              const Text("Archivos Multimedia", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              
              // Botones de Carga (UI-08)
              Row(
                children: [
                  Expanded(
                    child: _uploadButton(Icons.videocam, "Subir Video", () {
                      // Lógica de carga de video
                      _videoUrl = "video_cargado.mp4"; 
                    }),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _uploadButton(Icons.image, "Subir Imagen", () {}),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),

              const Text("Detalles del Contenido", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),

              // Título
              _buildField("Título del Contenido", "Ej. Saludo", (v) => _title = v),
              const SizedBox(height: 15),

              // Categoría (Tag)
              DropdownButtonFormField<int>(
                decoration: _inputDecor("Categoría de la Seña"),
                items: _tags.map((t) => DropdownMenuItem(value: t.id, child: Text(t.tagName))).toList(),
                onChanged: (v) => setState(() => _selectedTagId = v),
                validator: (v) => v == null ? "Requerido" : null,
              ),
              const SizedBox(height: 15),

              // Sección/Nivel
              DropdownButtonFormField<SignSection>(
                decoration: _inputDecor("Nivel Educativo / Sección"),
                items: SignSection.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                onChanged: (v) => setState(() => _section = v),
                validator: (v) => v == null ? "Requerido" : null,
              ),
              const SizedBox(height: 15),

              // Frase Asociada (Condicional según RF004)
              _buildField(
                _section == SignSection.FrasesComunes ? "Frase Exacta" : "Oración de Ejemplo",
                "Ingresa el texto asociado...",
                (v) => _description = v,
                maxLines: 2
              ),
              const SizedBox(height: 15),

              // Palabras Clave
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
                    : const Text("Importar Contenido", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _uploadButton(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: const Color(0xFF0099FF)),
      label: Text(label, style: const TextStyle(color: Color(0xFF0099FF))),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 1,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildField(String label, String hint, Function(String?) onSaved, {int maxLines = 1}) {
    return TextFormField(
      decoration: _inputDecor(label, hint: hint),
      maxLines: maxLines,
      onSaved: onSaved,
      validator: (v) => (v?.isEmpty ?? true) ? "Requerido" : null,
    );
  }

  InputDecoration _inputDecor(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}