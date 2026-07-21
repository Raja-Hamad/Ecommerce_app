import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AdminFilterPill extends StatelessWidget {
  const AdminFilterPill({super.key, required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.primaryLight : AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusPill),
            border: Border.all(color: active ? AppColors.primary : AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(color: active ? AppColors.primary : AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 2),
              Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: active ? AppColors.primary : AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminOptionsSheet<T> extends StatelessWidget {
  const AdminOptionsSheet({super.key, required this.title, required this.options, required this.selected, required this.onSelect});

  final String title;
  final List<(T, String)> options;
  final T selected;
  final ValueChanged<T> onSelect;

  static void show<T>(BuildContext context, {required String title, required List<(T, String)> options, required T selected, required ValueChanged<T> onSelect}) {
    Get.bottomSheet(
      AdminOptionsSheet<T>(title: title, options: options, selected: selected, onSelect: onSelect),
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
              child: Text(title, style: AppTextStyles.h3),
            ),
            const SizedBox(height: AppSizes.sm),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final option in options)
                    ListTile(
                      title: Text(option.$2, style: AppTextStyles.body),
                      trailing: option.$1 == selected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                      onTap: () {
                        Get.back();
                        onSelect(option.$1);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
