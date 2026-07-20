import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/product.dart';
import '../controllers/admin_products_controller.dart';

class AdminProductsView extends GetView<AdminProductsController> {
  const AdminProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        controller.loadMore();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: Text('Products', style: AppTextStyles.h3)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Get.toNamed(AppRoutes.adminCreateProduct);
          if (created != null) controller.fetch(reset: true);
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.md, AppSizes.lg, AppSizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSizes.radiusPill), boxShadow: AppDecorations.softShadow),
                  child: TextField(
                    controller: controller.searchCtrl,
                    onChanged: controller.onSearchChanged,
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      hintText: 'Search product by name...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusPill), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => _FilterPill(
                            label: controller.selectedCategory.value?.name ?? 'Category',
                            active: controller.selectedCategory.value != null,
                            onTap: () => _showCategorySheet(context),
                          )),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Obx(() => _FilterPill(
                            label: AdminProductsController.statusOptions
                                .firstWhere((e) => e.$1 == controller.selectedStatus.value)
                                .$2,
                            active: controller.selectedStatus.value != null,
                            onTap: () => _showStatusSheet(context),
                          )),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Obx(() => _FilterPill(
                            label: AdminProductsController.sortOptions.firstWhere((e) => e.$1 == controller.selectedSort.value).$2,
                            active: controller.selectedSort.value != null,
                            onTap: () => _showSortSheet(context),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.products.isEmpty) {
                return const EmptyState(icon: Icons.inventory_2_outlined, title: 'No products found', message: 'Try adjusting your search or filters');
              }
              return RefreshIndicator(
                onRefresh: () => controller.fetch(reset: true),
                color: AppColors.primary,
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.xxl),
                  itemCount: controller.products.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSizes.md),
                  itemBuilder: (context, index) {
                    if (index == controller.products.length) {
                      return Obx(() => controller.isLoadingMore.value
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: AppSizes.lg),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox.shrink());
                    }
                    return _AdminProductCard(product: controller.products[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showCategorySheet(BuildContext context) {
    Get.bottomSheet(
      _OptionsSheet<Category?>(
        title: 'Filter by Category',
        options: [(null, 'All Categories'), ...controller.categories.map((c) => (c, c.name))],
        selected: controller.selectedCategory.value,
        onSelect: controller.setCategory,
      ),
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl))),
    );
  }

  void _showStatusSheet(BuildContext context) {
    Get.bottomSheet(
      _OptionsSheet<String?>(
        title: 'Filter by Status',
        options: AdminProductsController.statusOptions,
        selected: controller.selectedStatus.value,
        onSelect: controller.setStatus,
      ),
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl))),
    );
  }

  void _showSortSheet(BuildContext context) {
    Get.bottomSheet(
      _OptionsSheet<String?>(
        title: 'Sort By',
        options: AdminProductsController.sortOptions,
        selected: controller.selectedSort.value,
        onSelect: controller.setSort,
      ),
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl))),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label, required this.active, required this.onTap});

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

class _OptionsSheet<T> extends StatelessWidget {
  const _OptionsSheet({required this.title, required this.options, required this.selected, required this.onSelect});

  final String title;
  final List<(T, String)> options;
  final T selected;
  final ValueChanged<T> onSelect;

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

class _AdminProductCard extends StatelessWidget {
  const _AdminProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final inStock = product.stock > 0;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: InkWell(
        onTap: () async {
          final result = await Get.toNamed(AppRoutes.adminProductDetails, arguments: product.id);
          if (result != null) Get.find<AdminProductsController>().fetch(reset: true);
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: AppDecorations.card(radius: AppSizes.radiusLg, color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: AppNetworkImage(url: product.firstImageUrl),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: AppTextStyles.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(Formatters.currency(product.displayPrice), style: AppTextStyles.label.copyWith(color: AppColors.primary)),
                        if (product.hasDiscount) ...[
                          const SizedBox(width: 6),
                          Text(Formatters.currency(product.price), style: AppTextStyles.priceStrike),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Stock: ${product.stock}', style: AppTextStyles.caption),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: (inStock ? AppColors.success : AppColors.error).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Text(
                  inStock ? 'Active' : 'Out of Stock',
                  style: AppTextStyles.labelSmall.copyWith(color: inStock ? AppColors.success : AppColors.error),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final updated = await Get.toNamed(AppRoutes.adminEditProduct, arguments: product);
                    if (updated != null) Get.find<AdminProductsController>().fetch(reset: true);
                  },
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: AppSizes.sm)),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final confirmed = await ConfirmDialog.show(
                      title: 'Delete Product?',
                      message: 'Are you sure you want to delete "${product.name}"? This cannot be undone.',
                      confirmLabel: 'Delete',
                    );
                    if (confirmed) Get.find<AdminProductsController>().deleteProduct(product);
                  },
                  icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                  label: const Text('Delete', style: TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                    side: const BorderSide(color: AppColors.error),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
        ),
      ),
    );
  }
}
