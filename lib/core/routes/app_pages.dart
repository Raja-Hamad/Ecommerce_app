import 'package:get/get.dart';
import '../../modules/address/bindings/address_binding.dart';
import '../../modules/address/views/add_address_view.dart';
import '../../modules/address/views/address_view.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/register_view.dart';
import '../../modules/cart/views/cart_view.dart';
import '../../modules/cart/bindings/cart_binding.dart';
import '../../modules/categories/views/categories_view.dart';
import '../../modules/categories/bindings/categories_binding.dart';
import '../../modules/checkout/bindings/checkout_binding.dart';
import '../../modules/checkout/views/checkout_view.dart';
import '../../modules/coupon/bindings/coupon_binding.dart';
import '../../modules/coupon/views/coupon_view.dart';
import '../../modules/orders/bindings/order_details_binding.dart';
import '../../modules/orders/bindings/orders_binding.dart';
import '../../modules/orders/views/order_details_view.dart';
import '../../modules/orders/views/orders_view.dart';
import '../../modules/payment/bindings/payment_binding.dart';
import '../../modules/payment/views/payment_success_view.dart';
import '../../modules/payment/views/payment_view.dart';
import '../../modules/product_details/bindings/product_details_binding.dart';
import '../../modules/product_details/views/product_details_view.dart';
import '../../modules/product_listing/bindings/product_listing_binding.dart';
import '../../modules/product_listing/views/product_listing_view.dart';
import '../../modules/profile/bindings/profile_binding.dart';
import '../../modules/profile/views/profile_view.dart';
import '../../modules/root/bindings/root_binding.dart';
import '../../modules/root/views/root_view.dart';
import '../../modules/splash/controllers/splash_controller.dart';
import '../../modules/splash/views/splash_view.dart';
import '../../modules/wishlist/bindings/wishlist_binding.dart';
import '../../modules/wishlist/views/wishlist_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashView(), binding: BindingsBuilder(() { Get.put(SplashController()); })),
    GetPage(name: AppRoutes.login, page: () => const LoginView(), binding: AuthBinding()),
    GetPage(name: AppRoutes.register, page: () => const RegisterView(), binding: AuthBinding()),
    GetPage(name: AppRoutes.root, page: () => const RootView(), binding: RootBinding()),
    GetPage(name: AppRoutes.categories, page: () => const CategoriesView(), binding: CategoriesBinding()),
    GetPage(name: AppRoutes.productListing, page: () => const ProductListingView(), binding: ProductListingBinding()),
    GetPage(name: AppRoutes.productDetails, page: () => const ProductDetailsView(), binding: ProductDetailsBinding()),
    GetPage(name: AppRoutes.cart, page: () => const CartView(), binding: CartBinding()),
    GetPage(name: AppRoutes.wishlist, page: () => const WishlistView(), binding: WishlistBinding()),
    GetPage(name: AppRoutes.address, page: () => const AddressView(), binding: AddressBinding()),
    GetPage(name: AppRoutes.addAddress, page: () => const AddAddressView(), binding: AddAddressBinding()),
    GetPage(name: AppRoutes.checkout, page: () => const CheckoutView(), binding: CheckoutBinding()),
    GetPage(name: AppRoutes.coupon, page: () => const CouponView(), binding: CouponBinding()),
    GetPage(name: AppRoutes.payment, page: () => const PaymentView(), binding: PaymentBinding()),
    GetPage(name: AppRoutes.paymentSuccess, page: () => const PaymentSuccessView(), binding: PaymentSuccessBinding()),
    GetPage(name: AppRoutes.orders, page: () => const OrdersView(), binding: OrdersBinding()),
    GetPage(name: AppRoutes.orderDetails, page: () => const OrderDetailsView(), binding: OrderDetailsBinding()),
    GetPage(name: AppRoutes.profile, page: () => const ProfileView(), binding: ProfileBinding()),
  ];
}
