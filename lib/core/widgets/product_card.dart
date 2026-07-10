import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../../domain/entities/product.dart';
import 'app_network_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.isWishlisted = false,
    this.onWishlistTap,
  });

  final Product product;
  final VoidCallback onTap;
  final bool isWishlisted;
  final VoidCallback? onWishlistTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppNetworkImage(url: product.images.first),
                  if (product.hasDiscount)
                    Positioned(
                      top: AppSizes.sm,
                      left: AppSizes.sm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                        child: Text('-${product.discountPercent}%', style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                      ),
                    ),
                  Positioned(
                    top: AppSizes.xs,
                    right: AppSizes.xs,
                    child: GestureDetector(
                      onTap: onWishlistTap,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 16,
                          color: isWishlisted ? AppColors.error : AppColors.textSecondary,
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
                children: [
                  Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.star),
                      const SizedBox(width: 2),
                      Text(product.rating.toStringAsFixed(1), style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(Formatters.currency(product.displayPrice), style: AppTextStyles.price.copyWith(fontSize: 14)),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            Formatters.currency(product.price),
                            style: AppTextStyles.priceStrike,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
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
