class RecentUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String profileImage;
  final String status;

  const RecentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.profileImage,
    this.status = 'active',
  });

  bool get isActive => status.toLowerCase() == 'active';

  factory RecentUser.fromJson(Map<String, dynamic> json) {
    return RecentUser(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      profileImage: json['profileImage'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
    );
  }
}
