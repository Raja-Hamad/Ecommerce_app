class MonthlySales {
  final int year;
  final String month;
  final double sales;

  const MonthlySales({required this.year, required this.month, required this.sales});

  factory MonthlySales.fromJson(Map<String, dynamic> json) {
    return MonthlySales(
      year: (json['year'] as num?)?.toInt() ?? 0,
      month: json['month'] as String? ?? '',
      sales: (json['sales'] as num?)?.toDouble() ?? 0,
    );
  }
}
