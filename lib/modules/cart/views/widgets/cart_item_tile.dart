import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/quantity_stepper.dart';
import '../../../../domain/entities/cart_item.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            height: 84,
            child: AppNetworkImage(url: item.product.images.first, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(item.product.name, style: AppTextStyles.h4, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    GestureDetector(onTap: onRemove, child: const Icon(Icons.close_rounded, size: 18, color: AppColors.textHint)),
                  ],
                ),
                if (item.size != null || item.color != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    [if (item.size != null) 'Size: ${item.size}', if (item.color != null) 'Color: ${item.color}'].join(' · '),
                    style: AppTextStyles.caption,
                  ),
                ],
                const SizedBox(height: AppSizes.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Formatters.currency(item.product.displayPrice), style: AppTextStyles.price.copyWith(fontSize: 15)),
                    QuantityStepper(quantity: item.quantity, onIncrement: onIncrement, onDecrement: onDecrement, compact: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
