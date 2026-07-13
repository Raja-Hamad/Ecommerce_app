import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/controllers/wishlist_controller.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../domain/entities/product.dart';

class ProductDetailsController extends GetxController {
  final _repo = ProductRepositoryImpl();

  final Rxn<Product> product = Rxn<Product>();
  final RxBool isLoading = true.obs;
  final RxInt selectedImage = 0.obs;
  final RxString selectedSize = ''.obs;
  final RxString selectedColor = ''.obs;
  final RxInt quantity = 1.obs;

  final RxDouble reviewRating = 0.0.obs;
  final reviewCommentCtrl = TextEditingController();
  final RxBool isSubmittingReview = false.obs;

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments as String;
    fetch(id);
  }

  @override
  void onClose() {
    reviewCommentCtrl.dispose();
    super.onClose();
  }

  Future<void> fetch(String id) async {
    isLoading.value = true;
    try {
      final p = await _repo.getProductById(id);
      product.value = p;
      if (p.sizes.isNotEmpty) selectedSize.value = p.sizes.first;
      if (p.colors.isNotEmpty) selectedColor.value = p.colors.first;
    } finally {
      isLoading.value = false;
    }
  }

  void incrementQuantity() => quantity.value++;

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  bool get isWishlisted => Get.find<WishlistController>().isInWishlist(product.value?.id ?? '');

  void toggleWishlist() {
    if (product.value == null) return;
    Get.find<WishlistController>().toggle(product.value!);
  }

  Future<void> addToCart() async {
    if (product.value == null) return;
    await Get.find<CartController>().addToCart(
      product.value!,
      quantity: quantity.value,
      size: selectedSize.value.isEmpty ? null : selectedSize.value,
      color: selectedColor.value.isEmpty ? null : selectedColor.value,
    );
  }

  Future<void> buyNow() async {
    await addToCart();
    Get.toNamed(AppRoutes.cart);
  }

  Future<void> submitReview() async {
    if (product.value == null) return;
    if (reviewRating.value <= 0) {
      AppSnackbar.error('Please select a star rating');
      return;
    }
    if (reviewCommentCtrl.text.trim().isEmpty) {
      AppSnackbar.error('Please write a short comment');
      return;
    }
    isSubmittingReview.value = true;
    try {
      await _repo.addReview(
        product.value!.id,
        rating: reviewRating.value,
        comment: reviewCommentCtrl.text.trim(),
      );
      reviewRating.value = 0;
      reviewCommentCtrl.clear();
      await fetch(product.value!.id);
      AppSnackbar.success('Review submitted');
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Could not submit review. Please try again.');
    } finally {
      isSubmittingReview.value = false;
    }
  }
}
