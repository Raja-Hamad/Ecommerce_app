import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({super.key, required this.quantity, required this.onIncrement, required this.onDecrement, this.compact = false});

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 26.0 : 32.0;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.scaffold,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(icon: Icons.remove, size: size, onTap: onDecrement),
          SizedBox(
            width: 32,
            child: Text('$quantity', textAlign: TextAlign.center, style: AppTextStyles.label),
          ),
          _StepButton(icon: Icons.add, size: size, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.size, required this.onTap});

  final IconData icon;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: SizedBox(width: size, height: size, child: Icon(icon, size: 16, color: AppColors.primary)),
    );
  }
}
