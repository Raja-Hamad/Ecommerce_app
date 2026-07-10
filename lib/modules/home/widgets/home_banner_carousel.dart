import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  final PageController _controller = PageController();

  final List<_Banner> _banners = const [
    _Banner(title: 'Summer Sale', subtitle: 'Up to 50% off', color: AppColors.primary),
    _Banner(title: 'New Arrivals', subtitle: 'Fresh styles weekly', color: AppColors.primaryDark),
    _Banner(title: 'Free Delivery', subtitle: 'On orders above \$50', color: Color(0xFF2A6E62)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: banner.color,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(banner.title, style: AppTextStyles.h2.copyWith(color: Colors.white)),
                          const SizedBox(height: AppSizes.xs),
                          Text(banner.subtitle, style: AppTextStyles.body.copyWith(color: Colors.white70)),
                        ],
                      ),
                    ),
                    Icon(Icons.local_offer_rounded, color: Colors.white.withValues(alpha: 0.25), size: 64),
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
  const _Banner({required this.title, required this.subtitle, required this.color});
  final String title;
  final String subtitle;
  final Color color;
}
