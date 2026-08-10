import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/admin_create_category_controller.dart';

class AdminCreateCategoryView extends GetView<AdminCreateCategoryController> {
  const AdminCreateCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: Text('Add Category', style: AppTextStyles.h3)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Obx(() {
                  final image = controller.image.value;
                  return GestureDetector(
                    onTap: controller.pickImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                        border: Border.all(color: AppColors.primary, style: BorderStyle.solid),
                        image: image != null ? DecorationImage(image: FileImage(image), fit: BoxFit.cover) : null,
                      ),
                      child: image == null
                          ? const Icon(Icons.add_photo_alternate_rounded, color: AppColors.primary, size: 32)
                          : Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: const EdgeInsets.all(6),
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                child: const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                              ),
                            ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSizes.xl),
              CustomTextField(label: 'Name', controller: controller.nameCtrl, validator: (v) => Validators.notEmpty(v, field: 'Name')),
              const SizedBox(height: AppSizes.lg),
              CustomTextField(
                label: 'Description',
                controller: controller.descriptionCtrl,
                maxLines: 3,
                validator: (v) => Validators.notEmpty(v, field: 'Description'),
              ),
              const SizedBox(height: AppSizes.xxl),
              Obx(() => PrimaryButton(
                    label: 'Create Category',
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
