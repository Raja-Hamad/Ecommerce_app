import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../domain/entities/admin_dashboard_stats.dart';
import '../../../domain/entities/monthly_sales.dart';
import '../../../domain/entities/recent_order.dart';
import '../../../domain/entities/top_selling_product.dart';
import '../../../core/widgets/app_network_image.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Obx(() {
        final stats = controller.stats.value;
        if (controller.isLoading.value && stats == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.fetch,
          color: AppColors.primary,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _DashboardHeader(name: auth.user.value?.name ?? 'Admin', stats: stats),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.xl, AppSizes.lg, AppSizes.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle(icon: Icons.dashboard_customize_rounded, title: 'Overview'),
                    const SizedBox(height: AppSizes.md),
                    GridView.count(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSizes.md,
                      crossAxisSpacing: AppSizes.md,
                      childAspectRatio: 1.35,
                      children: [
                        _StatCard(
                          icon: Icons.people_alt_rounded,
                          color: const Color(0xFF3B82F6),
                          value: '${stats?.totalUsers ?? 0}',
                          label: 'Total Users',
                        ),
                        _StatCard(
                          icon: Icons.inventory_2_rounded,
                          color: const Color(0xFF8B5CF6),
                          value: '${stats?.totalProducts ?? 0}',
                          label: 'Total Products',
                        ),
                        _StatCard(
                          icon: Icons.receipt_long_rounded,
                          color: const Color(0xFFE8A33D),
                          value: '${stats?.totalOrders ?? 0}',
                          label: 'Total Orders',
                        ),
                        _StatCard(
                          icon: Icons.local_offer_rounded,
                          color: AppColors.primary,
                          value: '${stats?.totalCoupons ?? 0}',
                          label: 'Total Coupons',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.xl),
                    const _SectionTitle(icon: Icons.show_chart_rounded, title: 'Monthly Sales'),
                    const SizedBox(height: AppSizes.md),
                    _MonthlySalesChart(data: controller.monthlySales),
                    const SizedBox(height: AppSizes.xl),
                    const _SectionTitle(icon: Icons.pie_chart_rounded, title: 'Orders Status'),
                    const SizedBox(height: AppSizes.md),
                    _OrdersStatusCard(stats: stats),
                    const SizedBox(height: AppSizes.xl),
                    const _SectionTitle(icon: Icons.history_rounded, title: 'Recent Orders'),
                    const SizedBox(height: AppSizes.md),
                    _RecentOrdersCard(orders: controller.recentOrders),
                    const SizedBox(height: AppSizes.xl),
                    const _SectionTitle(icon: Icons.local_fire_department_rounded, title: 'Top Selling Products'),
                    const SizedBox(height: AppSizes.md),
                    _TopSellingProductsList(products: controller.topSellingProducts),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(7)),
          child: Icon(icon, size: 14, color: AppColors.primary),
        ),
        const SizedBox(width: AppSizes.sm),
        Text(title, style: AppTextStyles.h3),
      ],
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.name, required this.stats});

  final String name;
  final AdminDashboardStats? stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.xl, AppSizes.lg, AppSizes.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppSizes.radiusXl)),
        boxShadow: [BoxShadow(color: AppColors.primaryDark.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 10))],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                  ),
                  child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('WELCOME BACK', style: AppTextStyles.labelSmall.copyWith(color: Colors.white60, letterSpacing: 1.0)),
                      Text(name, style: AppTextStyles.h3.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                  child: IconButton(
                    onPressed: () async {
                      final confirmed = await ConfirmDialog.show(
                        title: 'Logout?',
                        message: 'Are you sure you want to logout of your admin account?',
                        icon: Icons.logout_rounded,
                        confirmLabel: 'Logout',
                      );
                      if (confirmed) {
                        final auth = Get.find<AuthController>();
                        await auth.logout();
                        Get.offAllNamed(AppRoutes.login);
                      }
                    },
                    icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xl),
            Text('TOTAL REVENUE', style: AppTextStyles.labelSmall.copyWith(color: Colors.white60, letterSpacing: 1.0)),
            const SizedBox(height: 4),
            Text(Formatters.currency(stats?.totalRevenue ?? 0), style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSizes.lg),
            Row(
              children: [
                Expanded(child: _HeaderMiniStat(icon: Icons.receipt_long_rounded, value: '${stats?.totalOrders ?? 0}', label: 'Orders')),
                Container(width: 1, height: 34, color: Colors.white.withValues(alpha: 0.18)),
                Expanded(child: _HeaderMiniStat(icon: Icons.people_alt_rounded, value: '${stats?.totalUsers ?? 0}', label: 'Users')),
                Container(width: 1, height: 34, color: Colors.white.withValues(alpha: 0.18)),
                Expanded(child: _HeaderMiniStat(icon: Icons.inventory_2_rounded, value: '${stats?.totalProducts ?? 0}', label: 'Products')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderMiniStat extends StatelessWidget {
  const _HeaderMiniStat({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: AppTextStyles.label.copyWith(color: Colors.white, fontSize: 15)),
            Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white60, fontSize: 10)),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.color, required this.value, required this.label});

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withValues(alpha: 0.08), AppColors.surface], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.18)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppSizes.radiusSm), boxShadow: [BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const Spacer(),
          Text(value, style: AppTextStyles.h1.copyWith(fontSize: 16)),
          const SizedBox(height: 2),
          Text(label.toUpperCase(), style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5,
          fontSize: 10)),
        ],
      ),
    );
  }
}

class _OrdersStatusCard extends StatelessWidget {
  const _OrdersStatusCard({required this.stats});

  final AdminDashboardStats? stats;

  @override
  Widget build(BuildContext context) {
    final pending = stats?.pendingOrders ?? 0;
    final completed = stats?.completedOrders ?? 0;
    final total = pending + completed;
    final hasData = total > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            height: 110,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: hasData ? 3 : 0,
                    centerSpaceRadius: 34,
                    startDegreeOffset: -90,
                    sections: hasData
                        ? [
                            if (pending > 0)
                              PieChartSectionData(value: pending.toDouble(), color: AppColors.accent, radius: 20, showTitle: false),
                            if (completed > 0)
                              PieChartSectionData(value: completed.toDouble(), color: AppColors.success, radius: 20, showTitle: false),
                          ]
                        : [PieChartSectionData(value: 1, color: AppColors.border, radius: 20, showTitle: false)],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$total', style: AppTextStyles.h2),
                    Text('Orders', style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OrderStatusLegend(
                  color: AppColors.accent,
                  icon: Icons.hourglass_top_rounded,
                  label: 'Pending',
                  count: pending,
                  percent: hasData ? pending / total : 0,
                ),
                const SizedBox(height: AppSizes.md),
                _OrderStatusLegend(
                  color: AppColors.success,
                  icon: Icons.check_circle_rounded,
                  label: 'Completed',
                  count: completed,
                  percent: hasData ? completed / total : 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentOrdersCard extends StatelessWidget {
  const _RecentOrdersCard({required this.orders});

  final List<RecentOrder> orders;

  static (Color, String) _orderStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return (AppColors.warning, 'Pending');
      case 'confirmed':
        return (AppColors.primary, 'Confirmed');
      case 'shipped':
        return (AppColors.primary, 'Shipped');
      case 'delivered':
        return (AppColors.success, 'Delivered');
      case 'cancelled':
        return (AppColors.error, 'Cancelled');
      default:
        return (AppColors.textSecondary, status);
    }
  }

  static (Color, IconData) _paymentStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return (AppColors.success, Icons.check_circle_rounded);
      case 'failed':
        return (AppColors.error, Icons.error_rounded);
      default:
        return (AppColors.warning, Icons.schedule_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardDecoration = BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      border: Border.all(color: AppColors.border),
      boxShadow: [BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 6))],
    );

    if (orders.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.xl),
        decoration: cardDecoration,
        child: Column(
          children: [
            const Icon(Icons.receipt_long_rounded, color: AppColors.textHint, size: 32),
            const SizedBox(height: AppSizes.sm),
            Text('No recent orders', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      decoration: cardDecoration,
      child: Column(
        children: [
          for (int i = 0; i < orders.length; i++) ...[
            _RecentOrderTile(order: orders[i]),
            if (i != orders.length - 1) const Divider(height: 1, indent: AppSizes.lg, endIndent: AppSizes.lg, color: AppColors.border),
          ],
        ],
      ),
    );
  }
}

class _RecentOrderTile extends StatelessWidget {
  const _RecentOrderTile({required this.order});

  final RecentOrder order;

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusLabel) = _RecentOrdersCard._orderStatusConfig(order.orderStatus);
    final (paymentColor, paymentIcon) = _RecentOrdersCard._paymentStatusConfig(order.paymentStatus);
    final initial = order.customerName.isNotEmpty ? order.customerName[0].toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.sm),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
            child: Center(child: Text(initial, style: AppTextStyles.label.copyWith(color: AppColors.primary))),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.customerName, style: AppTextStyles.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(paymentIcon, size: 12, color: paymentColor),
                    const SizedBox(width: 4),
                    Text(Formatters.dateTime(order.createdAt), style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Formatters.currency(order.totalAmount), style: AppTextStyles.label),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 3),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                child: Text(statusLabel, style: AppTextStyles.labelSmall.copyWith(color: statusColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthlySalesChart extends StatelessWidget {
  const _MonthlySalesChart({required this.data});

  final List<MonthlySales> data;

  static String _compact(double value) {
    if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
    return '\$${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final cardDecoration = BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      border: Border.all(color: AppColors.border),
      boxShadow: [BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 6))],
    );

    if (data.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.xl),
        decoration: cardDecoration,
        child: Column(
          children: [
            const Icon(Icons.bar_chart_rounded, color: AppColors.textHint, size: 32),
            const SizedBox(height: AppSizes.sm),
            Text('No sales data yet', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    final total = data.fold<double>(0, (sum, e) => sum + e.sales);
    final maxSales = data.map((e) => e.sales).reduce((a, b) => a > b ? a : b);
    final maxY = maxSales <= 0 ? 100.0 : maxSales * 1.3;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.lg, AppSizes.lg, AppSizes.sm),
      decoration: cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: AppSizes.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TOTAL · ${data.length} MO.', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
                  Text(Formatters.currency(total), style: AppTextStyles.h3),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(top: AppSizes.lg),
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  minY: 0,
                  alignment: BarChartAlignment.spaceAround,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 4,
                    getDrawingHorizontalLine: (value) => FlLine(color: AppColors.border, strokeWidth: 1, dashArray: [4, 4]),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        interval: maxY / 4,
                        getTitlesWidget: (value, meta) => Text(_compact(value), style: AppTextStyles.caption.copyWith(fontSize: 10)),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= data.length) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: AppSizes.sm),
                            child: Text(data[index].month, style: AppTextStyles.caption),
                          );
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => AppColors.primaryDark,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final entry = data[group.x];
                        return BarTooltipItem(
                          '${entry.month} ${entry.year}\n',
                          AppTextStyles.caption.copyWith(color: Colors.white70),
                          children: [
                            TextSpan(text: Formatters.currency(entry.sales), style: AppTextStyles.label.copyWith(color: Colors.white)),
                          ],
                        );
                      },
                    ),
                  ),
                  barGroups: [
                    for (int i = 0; i < data.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: data[i].sales,
                            width: 22,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusSm)),
                            gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopSellingProductsList extends StatelessWidget {
  const _TopSellingProductsList({required this.products});

  final List<TopSellingProduct> products;

  static const _rankColors = [Color(0xFFE8A33D), Color(0xFF9CA3AF), Color(0xFFB87333)];

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            const Icon(Icons.inventory_2_outlined, color: AppColors.textHint, size: 32),
            const SizedBox(height: AppSizes.sm),
            Text('No sales data yet', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return SizedBox(
      height: 224,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSizes.md),
        itemBuilder: (context, index) {
          final product = products[index];
          final rankColor = index < _rankColors.length ? _rankColors[index] : AppColors.textHint;
          return Container(
            width: 148,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: AppColors.border),
              boxShadow: [BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 6))],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.2,
                      child: AppNetworkImage(url: product.firstImageUrl),
                    ),
                    Positioned(
                      top: AppSizes.sm,
                      left: AppSizes.sm,
                      child: Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: rankColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: rankColor.withValues(alpha: 0.5), blurRadius: 6)]),
                        child: Text('${index + 1}', style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                      ),
                    ),
                    Positioned(
                      top: AppSizes.sm,
                      right: AppSizes.sm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.primaryDark.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 11),
                            const SizedBox(width: 2),
                            Text('${product.totalSold}', style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppTextStyles.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(Formatters.currency(product.price), style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OrderStatusLegend extends StatelessWidget {
  const _OrderStatusLegend({required this.color, required this.icon, required this.label, required this.count, required this.percent});

  final Color color;
  final IconData icon;
  final String label;
  final int count;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('$count', style: AppTextStyles.h4),
                  const SizedBox(width: 6),
                  Text(label, style: AppTextStyles.caption),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 5,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
