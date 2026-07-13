import 'package:get/get.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import '../network/app_exception.dart';
import '../utils/app_snackbar.dart';

class CartController extends GetxController {
  final _repo = CartRepositoryImpl();

  final RxList<CartItem> items = <CartItem>[].obs;
  final RxBool isLoading = false.obs;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);

  bool isInCart(String productId) => items.any((i) => i.product.id == productId);

  Future<void> fetchCart() async {
    isLoading.value = true;
    try {
      items.value = await _repo.getCartItems();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(Product product, {int quantity = 1, String? size, String? color}) async {
    try {
      await _repo.addToCart(product, quantity: quantity, size: size, color: color);
      await fetchCart();
      AppSnackbar.success('${product.name} added to cart');
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Could not add to cart. Please try again.');
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity < 1) return;
    try {
      await _repo.updateQuantity(productId, quantity);
      await fetchCart();
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Could not update quantity. Please try again.');
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      await _repo.removeFromCart(productId);
      await fetchCart();
      AppSnackbar.success('Item removed from cart');
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Could not remove item. Please try again.');
    }
  }

  Future<void> clearCart() async {
    await _repo.clearCart();
    items.clear();
  }
}
