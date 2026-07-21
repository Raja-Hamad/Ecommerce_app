import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../domain/entities/order.dart';
import '../controllers/admin_orders_controller.dart';
import '../utils/order_status_helpers.dart';
import '../widgets/admin_filter_widgets.dart';

class AdminOrdersView extends GetView<AdminOrdersController> {
  const AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMore();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: Text('Orders', style: AppTextStyles.h3)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.lg,
              AppSizes.md,
              AppSizes.lg,
              AppSizes.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                    boxShadow: AppDecorations.softShadow,
                  ),
                  child: TextField(
                    controller: controller.searchCtrl,
                    onChanged: controller.onSearchChanged,
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      hintText: 'Search by name, email or order ID...',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textHint,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusPill,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Obx(
                        () => AdminFilterPill(
                          label: AdminOrdersController.statusOptions
                              .firstWhere(
                                (e) => e.$1 == controller.selectedStatus.value,
                              )
                              .$2,
                          active: controller.selectedStatus.value != null,
                          onTap: () => AdminOptionsSheet.show<String?>(
                            context,
                            title: 'Filter by Order Status',
                            options: AdminOrdersController.statusOptions,
                            selected: controller.selectedStatus.value,
                            onSelect: controller.setStatus,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Obx(
                        () => AdminFilterPill(
                          label: AdminOrdersController.paymentStatusOptions
                              .firstWhere(
                                (e) =>
                                    e.$1 ==
                                    controller.selectedPaymentStatus.value,
                              )
                              .$2,
                          active:
                              controller.selectedPaymentStatus.value != null,
                          onTap: () => AdminOptionsSheet.show<String?>(
                            context,
                            title: 'Filter by Payment Status',
                            options: AdminOrdersController.paymentStatusOptions,
                            selected: controller.selectedPaymentStatus.value,
                            onSelect: controller.setPaymentStatus,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Obx(
                        () => AdminFilterPill(
                          label: AdminOrdersController.paymentMethodOptions
                              .firstWhere(
                                (e) =>
                                    e.$1 ==
                                    controller.selectedPaymentMethod.value,
                              )
                              .$2,
                          active:
                              controller.selectedPaymentMethod.value != null,
                          onTap: () => AdminOptionsSheet.show<String?>(
                            context,
                            title: 'Filter by Payment Method',
                            options: AdminOrdersController.paymentMethodOptions,
                            selected: controller.selectedPaymentMethod.value,
                            onSelect: controller.setPaymentMethod,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Obx(
                        () => AdminFilterPill(
                          label: AdminOrdersController.sortOptions
                              .firstWhere(
                                (e) => e.$1 == controller.selectedSort.value,
                              )
                              .$2,
                          active: controller.selectedSort.value != null,
                          onTap: () => AdminOptionsSheet.show<String?>(
                            context,
                            title: 'Sort By',
                            options: AdminOrdersController.sortOptions,
                            selected: controller.selectedSort.value,
                            onSelect: controller.setSort,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.orders.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.orders.isEmpty) {
                return const EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'No orders found',
                  message: 'Try adjusting your search or filters',
                );
              }
              return RefreshIndicator(
                onRefresh: () => controller.fetch(reset: true),
                color: AppColors.primary,
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.lg,
                    AppSizes.sm,
                    AppSizes.lg,
                    AppSizes.xxl,
                  ),
                  itemCount: controller.orders.length + 1,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSizes.md),
                  itemBuilder: (context, index) {
                    if (index == controller.orders.length) {
                      return Obx(
                        () => controller.isLoadingMore.value
                            ? const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSizes.lg,
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox.shrink(),
                      );
                    }
                    return _AdminOrderCard(order: controller.orders[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _AdminOrderCard extends StatelessWidget {
  const _AdminOrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusLabel) = orderStatusConfig(order.status);
    final (paymentColor, paymentLabel) = paymentStatusConfig(
      order.paymentStatus,
    );
    final initial = (order.customerName?.isNotEmpty ?? false)
        ? order.customerName![0].toUpperCase()
        : '?';

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.adminOrderDetails, arguments: order.id),
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
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName ?? 'Unknown',
                      style: AppTextStyles.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (order.customerEmail != null)
                      Text(
                        order.customerEmail!,
                        style: AppTextStyles.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Text(
                Formatters.currency(order.finalAmount),
                style: AppTextStyles.label.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                '${order.itemCount} item${order.itemCount == 1 ? '' : 's'}',
                style: AppTextStyles.caption,
              ),
              const SizedBox(width: AppSizes.md),
              Icon(
                order.paymentMethod == PaymentMethod.stripe
                    ? Icons.credit_card_rounded
                    : Icons.local_shipping_outlined,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                order.paymentMethod == PaymentMethod.stripe ? 'Stripe' : 'COD',
                style: AppTextStyles.caption,
              ),
              const Spacer(),
              Text(
                Formatters.dateTime(order.createdAt),
                style: AppTextStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Text(
                  statusLabel,
                  style: AppTextStyles.labelSmall.copyWith(color: statusColor),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: paymentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Text(
                  paymentLabel,
                  style: AppTextStyles.labelSmall.copyWith(color: paymentColor),
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
