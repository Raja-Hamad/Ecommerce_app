import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_sizes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.delete_outline_rounded,
    this.confirmLabel = 'Remove',
    this.cancelLabel = 'Cancel',
    this.isDestructive = true,
  });

  final String title;
  final String message;
  final IconData icon;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;

  static Future<bool> show({
    required String title,
    required String message,
    IconData icon = Icons.delete_outline_rounded,
    String confirmLabel = 'Remove',
    String cancelLabel = 'Cancel',
    bool isDestructive = true,
  }) async {
    final result = await Get.dialog<bool>(
      ConfirmDialog(
        title: title,
        message: message,
        icon: icon,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
      barrierDismissible: true,
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = isDestructive ? AppColors.error : AppColors.primary;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSizes.xxl),
      child: Container(
        padding: const EdgeInsets.fromLTRB(AppSizes.xl, AppSizes.xxl, AppSizes.xl, AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: accentColor, size: 28),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(title, style: AppTextStyles.h3, textAlign: TextAlign.center),
            const SizedBox(height: AppSizes.sm),
            Text(
              message,
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(result: false),
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(46)),
                    child: Text(cancelLabel, style: AppTextStyles.label.copyWith(color: AppColors.textPrimary)),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(result: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      minimumSize: const Size.fromHeight(46),
                      elevation: 0,
                    ),
                    child: Text(confirmLabel, style: AppTextStyles.button),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
