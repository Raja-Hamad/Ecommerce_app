import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/admin_edit_product_controller.dart';
import '../widgets/admin_product_form_widgets.dart';

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
              const AdminFormSectionLabel('Basic Info'),
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
              const AdminFormSectionLabel('Pricing & Stock'),
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
              const AdminFormSectionLabel('Category'),
              const SizedBox(height: AppSizes.md),
              Obx(() {
                if (controller.isLoadingCategories.value) {
                  return const Center(child: Padding(padding: EdgeInsets.all(AppSizes.md), child: CircularProgressIndicator()));
                }
                return AdminCategoryPicker(
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
              const AdminFormSectionLabel('Sizes'),
              const SizedBox(height: AppSizes.md),
              AdminTagInput(
                controller: controller.sizeInputCtrl,
                hint: 'e.g. S, M, L, XL',
                onAdd: controller.addSize,
              ),
              const SizedBox(height: AppSizes.sm),
              Obx(() => AdminTagList(tags: controller.sizes.toList(), onRemove: controller.removeSize)),
              const SizedBox(height: AppSizes.xl),
              const AdminFormSectionLabel('Colors'),
              const SizedBox(height: AppSizes.md),
              AdminTagInput(
                controller: controller.colorInputCtrl,
                hint: 'e.g. Black, Blue',
                onAdd: controller.addColor,
              ),
              const SizedBox(height: AppSizes.sm),
              Obx(() => AdminTagList(tags: controller.colors.toList(), onRemove: controller.removeColor)),
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
