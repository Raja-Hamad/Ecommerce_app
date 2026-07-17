import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../domain/entities/category.dart';
import '../controllers/admin_edit_product_controller.dart';

class AdminEditProductView extends GetView<AdminEditProductController> {
  const AdminEditProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: Text('Edit Product', style: AppTextStyles.h3)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionLabel('Basic Info'),
              const SizedBox(height: AppSizes.md),
              CustomTextField(label: 'Name', controller: controller.nameCtrl, validator: (v) => Validators.notEmpty(v, field: 'Name')),
              const SizedBox(height: AppSizes.lg),
              CustomTextField(
                label: 'Description',
                controller: controller.descriptionCtrl,
                maxLines: 4,
                validator: (v) => Validators.notEmpty(v, field: 'Description'),
              ),
              const SizedBox(height: AppSizes.lg),
              CustomTextField(label: 'Brand', controller: controller.brandCtrl),
              const SizedBox(height: AppSizes.xl),
              _SectionLabel('Pricing & Stock'),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Price',
                      controller: controller.priceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Price is required';
                        if (double.tryParse(v.trim()) == null) return 'Enter a valid price';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: CustomTextField(
                      label: 'Discount Price',
                      hint: 'Optional',
                      controller: controller.discountPriceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return null;
                        return double.tryParse(v.trim()) == null ? 'Enter a valid price' : null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              CustomTextField(
                label: 'Stock',
                controller: controller.stockCtrl,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Stock is required';
                  if (int.tryParse(v.trim()) == null) return 'Enter a valid whole number';
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.xl),
              _SectionLabel('Category'),
              const SizedBox(height: AppSizes.md),
              Obx(() {
                if (controller.isLoadingCategories.value) {
                  return const Center(child: Padding(padding: EdgeInsets.all(AppSizes.md), child: CircularProgressIndicator()));
                }
                return _CategoryPicker(
                  categories: controller.categories,
                  selected: controller.selectedCategory.value,
                  onSelect: controller.setCategory,
                );
              }),
              const SizedBox(height: AppSizes.xl),
              Obx(() => Container(
                    decoration: AppDecorations.card(radius: AppSizes.radiusLg),
                    child: SwitchListTile(
                      value: controller.isFeatured.value,
                      onChanged: controller.toggleFeatured,
                      activeThumbColor: AppColors.primary,
                      title: Text('Featured Product', style: AppTextStyles.bodyLarge),
                      subtitle: Text('Show this product in featured sections', style: AppTextStyles.caption),
                    ),
                  )),
              const SizedBox(height: AppSizes.xl),
              _SectionLabel('Sizes'),
              const SizedBox(height: AppSizes.md),
              _TagInput(
                controller: controller.sizeInputCtrl,
                hint: 'e.g. S, M, L, XL',
                onAdd: controller.addSize,
              ),
              const SizedBox(height: AppSizes.sm),
              Obx(() => _TagList(tags: controller.sizes.toList(), onRemove: controller.removeSize)),
              const SizedBox(height: AppSizes.xl),
              _SectionLabel('Colors'),
              const SizedBox(height: AppSizes.md),
              _TagInput(
                controller: controller.colorInputCtrl,
                hint: 'e.g. Black, Blue',
                onAdd: controller.addColor,
              ),
              const SizedBox(height: AppSizes.sm),
              Obx(() => _TagList(tags: controller.colors.toList(), onRemove: controller.removeColor)),
              const SizedBox(height: AppSizes.xxl),
              Obx(() => PrimaryButton(
                    label: 'Save Changes',
                    isLoading: controller.isSaving.value,
                    onPressed: controller.save,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint, letterSpacing: 0.8));
  }
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({required this.categories, required this.selected, required this.onSelect});

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

class _TagInput extends StatelessWidget {
  const _TagInput({required this.controller, required this.hint, required this.onAdd});

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

class _TagList extends StatelessWidget {
  const _TagList({required this.tags, required this.onRemove});

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
