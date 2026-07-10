class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.avatarUrl = '',
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;

  AppUser copyWith({String? name, String? email, String? phone, String? avatarUrl}) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
