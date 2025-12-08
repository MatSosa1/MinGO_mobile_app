class User {
  final String name;
  final String email; 
  final DateTime birthDate;
  final String role;

  const User({
    required this.name,
    required this.email,
    required this.birthDate,
    required this.role,
  });
}