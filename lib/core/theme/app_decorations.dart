import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  AppDecorations._();

  static BoxDecoration card({Color? color, double radius = 16, bool tinted = false}) {
    return BoxDecoration(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: (tinted ? AppColors.primary : AppColors.textPrimary).withValues(alpha: tinted ? 0.10 : 0.05),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  static List<BoxShadow> get softShadow => [
        BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 6)),
      ];
}
