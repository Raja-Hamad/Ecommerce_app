import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../domain/entities/recent_user.dart';
import '../controllers/admin_users_controller.dart';
import '../widgets/admin_filter_widgets.dart';

class AdminUsersView extends GetView<AdminUsersController> {
  const AdminUsersView({super.key});

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
      appBar: AppBar(title: Text('Users', style: AppTextStyles.h3)),
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
                      hintText: 'Search by name or email...',
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
                      child: Obx(() => AdminFilterPill(
                            label: AdminUsersController.statusOptions.firstWhere((e) => e.$1 == controller.selectedStatus.value).$2,
                            active: controller.selectedStatus.value != null,
                            onTap: () => AdminOptionsSheet.show<String?>(
                              context,
                              title: 'Filter by Status',
                              options: AdminUsersController.statusOptions,
                              selected: controller.selectedStatus.value,
                              onSelect: controller.setStatus,
                            ),
                          )),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Obx(() => AdminFilterPill(
                            label: AdminUsersController.sortOptions.firstWhere((e) => e.$1 == controller.selectedSort.value).$2,
                            active: controller.selectedSort.value != null,
                            onTap: () => AdminOptionsSheet.show<String?>(
                              context,
                              title: 'Sort By',
                              options: AdminUsersController.sortOptions,
                              selected: controller.selectedSort.value,
                              onSelect: controller.setSort,
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.users.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.users.isEmpty) {
                return const EmptyState(icon: Icons.people_outline_rounded, title: 'No users found', message: 'Try adjusting your search or filters');
              }
              return RefreshIndicator(
                onRefresh: () => controller.fetch(reset: true),
                color: AppColors.primary,
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.xxl),
                  itemCount: controller.users.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSizes.md),
                  itemBuilder: (context, index) {
                    if (index == controller.users.length) {
                      return Obx(() => controller.isLoadingMore.value
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: AppSizes.lg),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox.shrink());
                    }
                    return _AdminUserCard(user: controller.users[index]);
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

class _AdminUserCard extends StatelessWidget {
  const _AdminUserCard({required this.user});

  final RecentUser user;

  @override
  Widget build(BuildContext context) {
    final isAdmin = user.role.toLowerCase() == 'admin';
    final isActive = user.isActive;
    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: AppDecorations.card(radius: AppSizes.radiusLg),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isAdmin ? AppColors.accent : AppColors.border, width: 2),
            ),
            child: ClipOval(
              child: Container(
                color: AppColors.primaryLight,
                child: user.profileImage.isNotEmpty
                    ? AppNetworkImage(url: user.profileImage)
                    : Center(child: Text(initial, style: AppTextStyles.label.copyWith(color: AppColors.primary))),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(user.name, style: AppTextStyles.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    if (isAdmin) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                        child: Text('Admin', style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontSize: 10)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(user.email, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 4),
            decoration: BoxDecoration(
              color: (isActive ? AppColors.success : AppColors.error).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Text(
              isActive ? 'Active' : 'Blocked',
              style: AppTextStyles.labelSmall.copyWith(color: isActive ? AppColors.success : AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
