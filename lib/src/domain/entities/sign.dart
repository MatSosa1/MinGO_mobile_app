enum SignSection {
  Principiante('Principiante'),
  Intermedio('Intermedio'),
  Avanzado('Avanzado'),
  FrasesComunes('Frases Comunes');

  final String name;

  const SignSection(this.name);
}

class Sign {
  final int? id; // Opcional, por si viene de DB
  final String signTitle;
  final String signVideoUrl;
  final String? signImageUrl;
  final SignSection signSection;
  final int tagId;

  Sign({
    this.id,
    required this.signTitle,
    required this.signVideoUrl,
    this.signImageUrl,
    required this.signSection,
    required this.tagId,
  });
}
