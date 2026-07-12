import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/address_controller.dart';

class AddressView extends GetView<AddressController> {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Address', style: AppTextStyles.h3)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.addresses.isEmpty) {
          return EmptyState(
            icon: Icons.location_on_outlined,
            title: 'No addresses yet',
            message: 'Add a delivery address to continue',
            actionLabel: 'Add Address',
            onAction: () async {
              final added = await Get.toNamed(AppRoutes.addAddress);
              if (added == true) controller.fetch();
            },
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSizes.lg),
          itemCount: controller.addresses.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSizes.md),
          itemBuilder: (context, index) {
            final address = controller.addresses[index];
            return Obx(() {
              final isSelected = controller.selected.value?.id == address.id;
              return GestureDetector(
                onTap: () => controller.select(address),
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 1.5 : 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, color: isSelected ? AppColors.primary : AppColors.textHint),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(address.label.isNotEmpty ? address.label : address.fullName, style: AppTextStyles.h4),
                                if (address.isDefault) ...[
                                  const SizedBox(width: AppSizes.sm),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                                    child: Text('Default', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (address.label.isNotEmpty) Text(address.fullName, style: AppTextStyles.bodySmall),
                            Text(address.fullAddress, style: AppTextStyles.caption),
                            Text(address.phone, style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                        onPressed: () async {
                          final updated = await Get.toNamed(AppRoutes.addAddress, arguments: address);
                          if (updated == true) controller.fetch();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.primary, size: 20),
                        onPressed: () async {
                          final confirmed = await ConfirmDialog.show(
                            title: 'Remove address?',
                            message: '"${address.label.isNotEmpty ? address.label : address.fullName}" will be removed from your addresses.',
                            isDestructive: false,
                          );
                          if (confirmed) controller.deleteAddress(address);
                        },
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton(
                label: 'Add New Address',
                outlined: true,
                icon: Icons.add_rounded,
                onPressed: () async {
                  final added = await Get.toNamed(AppRoutes.addAddress);
                  if (added == true) controller.fetch();
                },
              ),
              const SizedBox(height: AppSizes.sm),
              PrimaryButton(label: 'Deliver Here', onPressed: controller.confirmSelection),
            ],
          ),
        ),
      ),
    );
  }
}
