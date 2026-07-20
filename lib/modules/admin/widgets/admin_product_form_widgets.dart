import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/category.dart';

class AdminFormSectionLabel extends StatelessWidget {
  const AdminFormSectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint, letterSpacing: 0.8));
  }
}

class AdminCategoryPicker extends StatelessWidget {
  const AdminCategoryPicker({super.key, required this.categories, required this.selected, required this.onSelect});

  final List<Category> categories;
  final Category? selected;
  final ValueChanged<Category?> onSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        onTap: () {
          Get.bottomSheet(
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                      child: Text('Select Category', style: AppTextStyles.h3),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (final category in categories)
                            ListTile(
                              title: Text(category.name, style: AppTextStyles.body),
                              trailing: category.id == selected?.id ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                              onTap: () {
                                Get.back();
                                onSelect(category);
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: AppColors.surface,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl))),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.md),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSizes.radiusMd), border: Border.all(color: AppColors.border)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selected?.name ?? 'Select a category',
                  style: AppTextStyles.body.copyWith(color: selected == null ? AppColors.textHint : AppColors.textPrimary),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminTagInput extends StatelessWidget {
  const AdminTagInput({super.key, required this.controller, required this.hint, required this.onAdd});

  final TextEditingController controller;
  final String hint;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: AppTextStyles.body,
            onSubmitted: (_) => onAdd(),
            decoration: InputDecoration(hintText: hint),
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            onTap: onAdd,
            child: const Padding(
              padding: EdgeInsets.all(AppSizes.md),
              child: Icon(Icons.add_rounded, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class AdminTagList extends StatelessWidget {
  const AdminTagList({super.key, required this.tags, required this.onRemove});

  final List<String> tags;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return Text('None added yet', style: AppTextStyles.caption);
    }
    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      children: tags
          .map((tag) => Chip(
                label: Text(tag, style: AppTextStyles.bodySmall),
                deleteIcon: const Icon(Icons.close_rounded, size: 16),
                onDeleted: () => onRemove(tag),
                backgroundColor: AppColors.primaryLight,
                side: BorderSide.none,
              ))
          .toList(),
    );
  }
}
