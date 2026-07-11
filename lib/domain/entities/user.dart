class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
    this.profileImage = '',
    this.profileImagePublicId = '',
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String profileImage;
  final String profileImagePublicId;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      profileImage: json['profileImage'] as String? ?? '',
      profileImagePublicId: json['profileImagePublicId'] as String? ?? '',
    );
  }

  AppUser copyWith({String? name, String? email, String? profileImage}) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role,
      profileImage: profileImage ?? this.profileImage,
      profileImagePublicId: profileImagePublicId,
    );
  }
}
