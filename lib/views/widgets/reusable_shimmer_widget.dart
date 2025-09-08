import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReusableShimmerWidget extends StatefulWidget {
  const ReusableShimmerWidget({super.key});

  @override
  State<ReusableShimmerWidget> createState() => _ReusableShimmerWidgetState();
}

class _ReusableShimmerWidgetState extends State<ReusableShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return   Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 20, width: 150, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Container(height: 14, width: 100, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Container(
              height: 14,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}