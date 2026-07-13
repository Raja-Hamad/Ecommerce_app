class Review {
  const Review({required this.id, required this.userId, required this.rating, required this.comment});

  final String id;
  final String userId;
  final double rating;
  final String comment;

  factory Review.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return Review(
      id: (json['_id'] ?? '').toString(),
      userId: user is Map<String, dynamic> ? (user['_id'] ?? '').toString() : (user ?? '').toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      comment: json['comment'] as String? ?? '',
    );
  }
}
