enum SignSection {
  Principiante('Principiante'),
  Intermedio('Intermedio'),
  Avanzado('Avanzado'),
  FrasesComunes('Frases Comunes');

  final String name;
  const SignSection(this.name);
}

class Sign {
  final int? id;
  final String signTitle;
  final String description;
  final String signVideoUrl;
  final String? signImageUrl;
  final SignSection signSection;
  final int tagId;
  final List<String>? synonyms;

  Sign({
    this.id,
    required this.signTitle,
    required this.description,
    required this.signVideoUrl,
    this.signImageUrl,
    required this.signSection,
    required this.tagId,
    this.synonyms,
  });
}