class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://192.168.1.31:3000/';

  // Auth
  static const String register = 'users/register';
  static const String login = 'users/login';
  static const String profile = 'users/profile';

  // Products
  static const String products = 'products';
  static const String categories = 'products/categories';
  static String productById(String id) => 'products/$id';

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

  // Payments
  static const String createPaymentIntent = 'payments/create-payment-intent';
}
