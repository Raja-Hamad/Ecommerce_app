import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  final PageController _controller = PageController();

  final List<_Banner> _banners = const [
    _Banner(title: 'Summer Sale', subtitle: 'Up to 50% off storewide', icon: Icons.local_fire_department_rounded, colors: [AppColors.primary, AppColors.primaryDark]),
    _Banner(title: 'New Arrivals', subtitle: 'Fresh styles, every week', icon: Icons.auto_awesome_rounded, colors: [Color(0xFF2A6E62), Color(0xFF123D35)]),
    _Banner(title: 'Free Delivery', subtitle: 'On all orders above \$50', icon: Icons.local_shipping_rounded, colors: [Color(0xFF1E5B4F), Color(0xFF0D3129)]),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                padding: const EdgeInsets.all(AppSizes.xl),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: banner.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                  boxShadow: [
                    BoxShadow(color: banner.colors.first.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -18,
                      bottom: -18,
                      child: Icon(banner.icon, color: Colors.white.withValues(alpha: 0.14), size: 120),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(banner.title, style: AppTextStyles.h2.copyWith(color: Colors.white)),
                        const SizedBox(height: AppSizes.xs),
                        Text(banner.subtitle, style: AppTextStyles.body.copyWith(color: Colors.white70)),
                        const SizedBox(height: AppSizes.md),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSizes.radiusPill)),
                          child: Text('Shop Now', style: AppTextStyles.labelSmall.copyWith(color: banner.colors.first)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        SmoothPageIndicator(
          controller: _controller,
          count: _banners.length,
          effect: const WormEffect(dotHeight: 6, dotWidth: 6, activeDotColor: AppColors.primary, dotColor: AppColors.border),
        ),
      ],
    );
  }
}

class _Banner {
  const _Banner({required this.title, required this.subtitle, required this.icon, required this.colors});
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
}
