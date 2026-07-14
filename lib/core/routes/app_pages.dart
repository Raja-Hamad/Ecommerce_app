import 'package:get/get.dart';
import '../../modules/admin/views/admin_dashboard_view.dart';
import '../../modules/user/address/bindings/address_binding.dart';
import '../../modules/user/address/views/add_address_view.dart';
import '../../modules/user/address/views/address_view.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/register_view.dart';
import '../../modules/user/cart/views/cart_view.dart';
import '../../modules/user/cart/bindings/cart_binding.dart';
import '../../modules/user/categories/views/categories_view.dart';
import '../../modules/user/categories/bindings/categories_binding.dart';
import '../../modules/user/checkout/bindings/checkout_binding.dart';
import '../../modules/user/checkout/views/checkout_view.dart';
import '../../modules/user/coupon/bindings/coupon_binding.dart';
import '../../modules/user/coupon/views/coupon_view.dart';
import '../../modules/user/orders/bindings/order_details_binding.dart';
import '../../modules/user/orders/bindings/orders_binding.dart';
import '../../modules/user/orders/views/order_details_view.dart';
import '../../modules/user/orders/views/orders_view.dart';
import '../../modules/user/payment/bindings/payment_binding.dart';
import '../../modules/user/payment/views/payment_success_view.dart';
import '../../modules/user/payment/views/payment_view.dart';
import '../../modules/user/product_details/bindings/product_details_binding.dart';
import '../../modules/user/product_details/views/product_details_view.dart';
import '../../modules/user/product_listing/bindings/product_listing_binding.dart';
import '../../modules/user/product_listing/views/product_listing_view.dart';
import '../../modules/user/profile/bindings/profile_binding.dart';
import '../../modules/user/profile/views/change_password_view.dart';
import '../../modules/user/profile/views/profile_view.dart';
import '../../modules/root/bindings/root_binding.dart';
import '../../modules/root/views/root_view.dart';
import '../../modules/splash/controllers/splash_controller.dart';
import '../../modules/splash/views/splash_view.dart';
import '../../modules/user/wishlist/bindings/wishlist_binding.dart';
import '../../modules/user/wishlist/views/wishlist_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashView(), binding: BindingsBuilder(() { Get.put(SplashController()); })),
    GetPage(name: AppRoutes.login, page: () => const LoginView(), binding: AuthBinding()),
    GetPage(name: AppRoutes.register, page: () => const RegisterView(), binding: AuthBinding()),
    GetPage(name: AppRoutes.root, page: () => const RootView(), binding: RootBinding()),
    GetPage(name: AppRoutes.adminDashboard, page: () => const AdminDashboardView()),
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
    GetPage(name: AppRoutes.changePassword, page: () => const ChangePasswordView(), binding: ChangePasswordBinding()),
  ];
}
