import 'package:get/get.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/controllers/wishlist_controller.dart';
import '../../../core/routes/app_routes.dart';
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

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments as String;
    fetch(id);
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
}
