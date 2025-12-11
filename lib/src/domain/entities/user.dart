class User {
  final int? id;
  final String name;
  final String email; 
  final DateTime birthDate;
  final String knowledgeLevel;
  final bool firstTimeLogin;
  final int role;

  const User({
    this.id,
    required this.name,
    required this.email,
    required this.birthDate,
    required this.knowledgeLevel,
    required this.firstTimeLogin,
    required this.role,
  });
}