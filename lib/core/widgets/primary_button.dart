import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: outlined ? AppColors.primary : Colors.white,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppSizes.iconMd, color: outlined ? AppColors.primary : Colors.white),
                const SizedBox(width: AppSizes.sm),
              ],
              Text(label, style: outlined ? AppTextStyles.label.copyWith(color: AppColors.primary) : AppTextStyles.button),
            ],
          );

    if (outlined) {
      return OutlinedButton(onPressed: isLoading ? null : onPressed, child: child);
    }
    return ElevatedButton(onPressed: isLoading ? null : onPressed, child: child);
  }
}
