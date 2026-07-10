import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _base => GoogleFonts.plusJakartaSans(color: AppColors.textPrimary);

  static TextStyle h1 = _base.copyWith(fontSize: 28, fontWeight: FontWeight.w700, height: 1.2);
  static TextStyle h2 = _base.copyWith(fontSize: 22, fontWeight: FontWeight.w700, height: 1.2);
  static TextStyle h3 = _base.copyWith(fontSize: 18, fontWeight: FontWeight.w700, height: 1.25);
  static TextStyle h4 = _base.copyWith(fontSize: 15, fontWeight: FontWeight.w600, height: 1.3);

  static TextStyle bodyLarge = _base.copyWith(fontSize: 15, fontWeight: FontWeight.w500);
  static TextStyle body = _base.copyWith(fontSize: 14, fontWeight: FontWeight.w400);
  static TextStyle bodySmall = _base.copyWith(fontSize: 13, fontWeight: FontWeight.w400);

  static TextStyle label = _base.copyWith(fontSize: 13, fontWeight: FontWeight.w600);
  static TextStyle labelSmall = _base.copyWith(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.3);

  static TextStyle caption = _base.copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary);

  static TextStyle button = _base.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white);

  static TextStyle price = _base.copyWith(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary);
  static TextStyle priceStrike = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    decoration: TextDecoration.lineThrough,
  );
}
