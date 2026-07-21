import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/order.dart';

(Color, String) orderStatusConfig(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return (AppColors.warning, 'Pending');
    case OrderStatus.confirmed:
      return (AppColors.primary, 'Confirmed');
    case OrderStatus.shipped:
      return (AppColors.primary, 'Shipped');
    case OrderStatus.delivered:
      return (AppColors.success, 'Delivered');
    case OrderStatus.cancelled:
      return (AppColors.error, 'Cancelled');
  }
}

(Color, String) paymentStatusConfig(PaymentStatus status) {
  switch (status) {
    case PaymentStatus.paid:
      return (AppColors.success, 'Paid');
    case PaymentStatus.failed:
      return (AppColors.error, 'Failed');
    case PaymentStatus.pending:
      return (AppColors.warning, 'Payment Pending');
  }
}
