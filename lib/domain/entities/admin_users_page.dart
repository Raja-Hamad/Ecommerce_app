import 'recent_user.dart';

class AdminUsersPage {
  final int currentPage;
  final int totalPages;
  final int totalUsers;
  final List<RecentUser> users;

  const AdminUsersPage({
    required this.currentPage,
    required this.totalPages,
    required this.totalUsers,
    required this.users,
  });

  bool get hasMore => currentPage < totalPages;

  factory AdminUsersPage.fromJson(Map<String, dynamic> json) {
    final list = json['users'] as List<dynamic>? ?? [];
    return AdminUsersPage(
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      totalUsers: (json['totalUsers'] as num?)?.toInt() ?? 0,
      users: list.map((e) => RecentUser.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
