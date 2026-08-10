import 'package:ecommerce/modules/admin/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../domain/entities/category.dart';
import '../controllers/admin_categories_controller.dart';

class AdminCategoriesView extends GetView<AdminCategoriesController> {
  const AdminCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text('Categories', style: AppTextStyles.h3),
        actions: [
          IconButton(
            onPressed: controller.fetch,
            icon: const Icon(Icons.refresh_rounded),
            color: AppColors.textSecondary,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Get.toNamed(AppRoutes.adminCreateCategory);
          if (created != null) controller.fetch();
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Category',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.categories.isEmpty) {
          return const EmptyState(
            icon: Icons.category_outlined,
            title: 'No categories yet',
            message: 'Tap "Add Category" to create your first one',
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetch,
          color: AppColors.primary,
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.lg,
              AppSizes.lg,
              AppSizes.lg,
              AppSizes.xxl * 2,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSizes.md,
              crossAxisSpacing: AppSizes.md,
              childAspectRatio: 0.75, // ✅ Changed from 0.85 to 0.75
            ),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) =>
                _CategoryCard(category: controller.categories[index]),
          ),
        );
      }),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final Category category;

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await ConfirmationDialog.show(
     context: context,
      title: 'Delete Category',
      message: 'Are you sure you want to delete "${category.name}"? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDangerous: true,
    );

    if (confirmed == true) {
      try {
        await Get.find<AdminCategoriesController>().deleteCategory(category);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Category deleted successfully'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete category. Please try again.'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleEdit(BuildContext context) async {
    final updated = await Get.toNamed(
      AppRoutes.adminEditCategory,
      arguments: category,
    );
    if (updated != null) {
      Get.find<AdminCategoriesController>().fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        onTap: () => _handleEdit(context),
        child: Container(
          decoration: AppDecorations.card(
            radius: AppSizes.radiusLg,
            color: Colors.transparent,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppNetworkImage(
                      url: category.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    // ✅ Action buttons overlay on image
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          // ✅ Edit Button
                          _buildActionButton(
                            icon: Icons.edit_rounded,
                            color: AppColors.primary,
                            onTap: () => _handleEdit(context),
                            tooltip: 'Edit Category',
                          ),
                          const SizedBox(width: 6),
                          // ✅ Delete Button - WITH GestureDetector to stop propagation
                          _buildActionButton(
                            icon: Icons.delete_rounded,
                            color: AppColors.error,
                            onTap: () => _handleDelete(context),
                            tooltip: 'Delete Category',
                          ),
                        ],
                      ),
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.05),
                              Colors.black.withValues(alpha: 0.15),
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category.name,
                      style: AppTextStyles.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (category.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        category.description,
                        style: AppTextStyles.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ FIXED: Action button with GestureDetector to stop propagation
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // ✅ Ensures tap doesn't propagate
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.85),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Tooltip(
              message: tooltip,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}