import 'package:get/get.dart';
import '../../data/repositories/wishlist_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../network/app_exception.dart';
import '../utils/app_snackbar.dart';

class WishlistController extends GetxController {
  final _repo = WishlistRepositoryImpl();

  final RxList<Product> items = <Product>[].obs;
  final RxBool isLoading = false.obs;

  bool isInWishlist(String productId) => items.any((p) => p.id == productId);

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    isLoading.value = true;
    try {
      items.value = await _repo.getWishlist();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggle(Product product) async {
    final wasWishlisted = isInWishlist(product.id);
    try {
      await _repo.toggleWishlist(product);
      await fetchWishlist();
      AppSnackbar.success(wasWishlisted ? 'Removed from wishlist' : 'Added to wishlist');
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Could not update wishlist. Please try again.');
    }
  }
}
