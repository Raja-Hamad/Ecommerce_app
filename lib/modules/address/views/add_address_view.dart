import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/address_controller.dart';

class AddAddressView extends GetView<AddAddressController> {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Address', style: AppTextStyles.h3)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(label: 'Label', hint: 'Home, Office...', controller: controller.labelCtrl, validator: (v) => Validators.notEmpty(v, field: 'Label')),
              const SizedBox(height: AppSizes.lg),
              CustomTextField(label: 'Full Name', hint: 'John Doe', controller: controller.nameCtrl, validator: (v) => Validators.notEmpty(v, field: 'Name')),
              const SizedBox(height: AppSizes.lg),
              CustomTextField(label: 'Phone', hint: '+1 555 123 4567', controller: controller.phoneCtrl, keyboardType: TextInputType.phone, validator: Validators.phone),
              const SizedBox(height: AppSizes.lg),
              CustomTextField(label: 'Address', hint: 'Street address', controller: controller.addressCtrl, maxLines: 2, validator: (v) => Validators.notEmpty(v, field: 'Address')),
              const SizedBox(height: AppSizes.lg),
              Row(
                children: [
                  Expanded(child: CustomTextField(label: 'City', hint: 'City', controller: controller.cityCtrl, validator: (v) => Validators.notEmpty(v, field: 'City'))),
                  const SizedBox(width: AppSizes.md),
                  Expanded(child: CustomTextField(label: 'State', hint: 'State', controller: controller.stateCtrl, validator: (v) => Validators.notEmpty(v, field: 'State'))),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              CustomTextField(label: 'Zip Code', hint: '10001', controller: controller.zipCtrl, keyboardType: TextInputType.number, validator: (v) => Validators.notEmpty(v, field: 'Zip code')),
              const SizedBox(height: AppSizes.lg),
              Obx(() => CheckboxListTile(
                    value: controller.isDefault.value,
                    onChanged: (v) => controller.isDefault.value = v ?? false,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Set as default address'),
                  )),
              const SizedBox(height: AppSizes.lg),
              Obx(() => PrimaryButton(label: 'Save Address', isLoading: controller.isSaving.value, onPressed: controller.save)),
            ],
          ),
        ),
      ),
    );
  }
}
