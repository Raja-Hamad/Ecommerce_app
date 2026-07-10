import 'package:get/get.dart';
import '../../data/repositories/wishlist_repository_impl.dart';
import '../../domain/entities/product.dart';

class WishlistController extends GetxController {
  final _repo = WishlistRepositoryImpl();

  final RxList<Product> items = <Product>[].obs;
  final RxBool isLoading = false.obs;

  bool isInWishlist(String productId) => items.any((p) => p.id == productId);

  Future<void> fetchWishlist() async {
    isLoading.value = true;
    try {
      items.value = await _repo.getWishlist();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggle(Product product) async {
    await _repo.toggleWishlist(product);
    await fetchWishlist();
  }
}
