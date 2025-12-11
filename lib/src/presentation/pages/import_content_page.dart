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
  
  // Campos del Formulario
  String? _title;       
  String? _description; // Guardará la "Frase Exacta" u "Oración de Ejemplo"
  String? _videoUrl;    
  String? _imageUrl;    
  SignSection? _section; 
  int? _selectedTagId;
  String? _synonymsText; // Para capturar los sinónimos como texto (coma separado)

  final List<SignSection> _sections = SignSection.values;

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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      // Procesar sinónimos (separados por coma)
      List<String> synonymsList = [];
      if (_synonymsText != null && _synonymsText!.isNotEmpty) {
        synonymsList = _synonymsText!.split(',').map((e) => e.trim()).toList();
      }

      final newSign = SignModel(
        signTitle: _title!,
        description: _description!, // Campo obligatorio nuevo
        signVideoUrl: _videoUrl!,
        signImageUrl: _imageUrl,
        signSection: _section!,
        tagId: _selectedTagId!,
        synonyms: synonymsList, // Enviamos lista al backend
      );

      try {
        await _signRepository.createSign(newSign);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Contenido validado y registrado exitosamente")),
        );
        Navigator.pop(context);
      } catch (e) {
        setState(() => _isLoading = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  InputDecoration _decor(String label, {String? hint, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: Colors.blue.shade700) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    // LÓGICA CONDICIONAL DE UI SEGÚN REQUISITO
    String descLabel = "Oración de Ejemplo";
    String descHint = "Ej. Adoro esa silla roja";
    
    if (_section == SignSection.FrasesComunes) {
      descLabel = "Frase Exacta";
      descHint = "Ej. ¿Cómo te sientes?";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Importar Contenido"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: _isLoading && _tags.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Metadatos del Contenido", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    // 1. TÍTULO (Siempre visible)
                    TextFormField(
                      decoration: _decor("Título de la Seña", hint: "Ej. Silla, Saludo", icon: Icons.title),
                      validator: (v) => (v == null || v.isEmpty) ? "Obligatorio" : null,
                      onSaved: (v) => _title = v,
                    ),
                    const SizedBox(height: 16),

                    // 2. SECCIÓN (Define el comportamiento del siguiente campo)
                    DropdownButtonFormField<SignSection>(
                      decoration: _decor("Sección de destino", icon: Icons.category),
                      items: _sections.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                      onChanged: (v) => setState(() => _section = v),
                      validator: (v) => v == null ? "Seleccione una sección" : null,
                    ),
                    const SizedBox(height: 16),

                    // 3. CAMPO CONDICIONAL (Frase vs Oración)
                    // Solo se muestra si ya se seleccionó una sección para dar contexto
                    if (_section != null) ...[
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: TextFormField(
                          key: ValueKey(_section), // Fuerza redibujado al cambiar sección
                          decoration: _decor(descLabel, hint: descHint, icon: Icons.description),
                          maxLines: 2,
                          validator: (v) => (v == null || v.isEmpty) ? "Este campo es obligatorio para la sección seleccionada" : null,
                          onSaved: (v) => _description = v,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 4. CATEGORÍA (Tag)
                    DropdownButtonFormField<int>(
                      decoration: _decor("Categoría (Tag)", icon: Icons.label),
                      items: _tags.map((t) => DropdownMenuItem(value: t.id, child: Text(t.tagName))).toList(),
                      onChanged: (v) => setState(() => _selectedTagId = v),
                      validator: (v) => v == null ? "Seleccione una categoría" : null,
                    ),
                    const SizedBox(height: 16),

                    // 5. SINÓNIMOS (Opcional)
                    TextFormField(
                      decoration: _decor("Palabras clave / Sinónimos (Opcional)", hint: "Separados por coma (Ej. Asiento, Butaca)", icon: Icons.abc),
                      onSaved: (v) => _synonymsText = v,
                    ),
                    const SizedBox(height: 24),

                    const Text("Multimedia", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    // 6. VIDEO (Obligatorio)
                    TextFormField(
                      decoration: _decor("URL del Video", hint: "https://...", icon: Icons.video_library),
                      validator: (v) => (v == null || v.isEmpty) ? "El video es obligatorio" : null,
                      onSaved: (v) => _videoUrl = v,
                    ),
                    const SizedBox(height: 16),

                    // 7. IMAGEN (Opcional)
                    TextFormField(
                      decoration: _decor("URL de Imagen (Opcional)", hint: "https://...", icon: Icons.image),
                      onSaved: (v) => _imageUrl = (v != null && v.isNotEmpty) ? v : null,
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: _isLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white)) 
                          : const Icon(Icons.save),
                        label: Text(_isLoading ? "Validando..." : "Guardar Contenido"),
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}