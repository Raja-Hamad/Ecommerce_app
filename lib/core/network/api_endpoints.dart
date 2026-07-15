class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://192.168.1.33:3000/';

  // Auth
  static const String register = 'users/register';
  static const String login = 'users/login';
  static const String profile = 'users/profile';
  static const String changePassword = 'users/change-password';
  static const String forgotPassword = 'users/forgot-password';
  static String resetPassword(String token) => 'users/reset-password/$token';

  // Products
  static const String products = 'products';
  static const String categories = 'products/categories';
  static String productById(String id) => 'products/$id';
  static String addReview(String productId) => 'products/$productId/reviews';

  // Wishlist
  static const String wishlist = 'products/wishlist';
  static String addToWishlist(String productId) => 'products/$productId/wishlist';
  static String removeFromWishlist(String productId) => 'products/wishlist/$productId';

  // Cart
  static const String addToCart = 'products/cart/add';
  static const String getCart = 'products/cart/get';
  static const String updateCartQuantity = 'products/cart/update';
  static String removeCartItem(String productId) => 'products/cart/item/$productId';

  // Addresses
  static const String addresses = 'addresses';
  static String deleteAddress(String addressId) => 'addresses/$addressId/delete';
  static String updateAddress(String addressId) => 'addresses/$addressId/update';

  // Coupons
  static const String coupons = 'coupons';

  // Orders
  static const String placeOrder = 'products/order/place';
  static const String myOrders = 'products/order/my-orders';
  static String cancelOrder(String orderId) => 'products/order/$orderId/cancel';
  static String orderDetails(String orderId) => 'products/order/$orderId';

  // Payments
  static const String createPaymentIntent = 'payments/create-payment-intent';
}
