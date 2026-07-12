class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://192.168.1.5:3000/';

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
  static String removeCartItem(String productId) => 'products/cart/item/$productId';
}
