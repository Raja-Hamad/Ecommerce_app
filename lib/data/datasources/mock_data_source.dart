import '../../domain/entities/address.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/coupon.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/user.dart';

class MockDataSource {
  MockDataSource._internal();
  static final MockDataSource instance = MockDataSource._internal();

  final Duration latency = const Duration(milliseconds: 500);

  AppUser? loggedInUser;

  final List<Category> categories = const [
    Category(id: 'c1', name: 'Men', imageUrl: 'https://images.unsplash.com/photo-1490114538077-0a7f8cb49891?w=300', productCount: 24),
    Category(id: 'c2', name: 'Women', imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=300', productCount: 32),
    Category(id: 'c3', name: 'Footwear', imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=300', productCount: 18),
    Category(id: 'c4', name: 'Bags', imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=300', productCount: 12),
    Category(id: 'c5', name: 'Accessories', imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300', productCount: 20),
    Category(id: 'c6', name: 'Electronics', imageUrl: 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=300', productCount: 15),
  ];

  final List<Product> products = [
    Product(
      id: 'p1',
      name: 'Classic Denim Jacket',
      description: 'A timeless denim jacket crafted from premium cotton blend. Features a relaxed fit, button closure, and multiple pockets for everyday versatility.',
      price: 89.99,
      discountPrice: 64.99,
      images: const [
        'https://images.unsplash.com/photo-1601333144130-8cbb312386b6?w=600',
        'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=600',
      ],
      categoryId: 'c1',
      rating: 4.5,
      reviewCount: 128,
      stock: 24,
      brand: 'Urban Edge',
      sizes: const ['S', 'M', 'L', 'XL'],
      colors: const ['Blue', 'Black'],
      isFeatured: true,
    ),
    Product(
      id: 'p2',
      name: 'Floral Summer Dress',
      description: 'Lightweight and breezy, this floral dress is perfect for warm days. Made from soft viscose fabric with a flattering A-line silhouette.',
      price: 59.99,
      images: const [
        'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=600',
        'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=600',
      ],
      categoryId: 'c2',
      rating: 4.7,
      reviewCount: 96,
      stock: 15,
      brand: 'Bloom & Co',
      sizes: const ['XS', 'S', 'M', 'L'],
      colors: const ['Red', 'White'],
      isFeatured: true,
    ),
    Product(
      id: 'p3',
      name: 'Running Sneakers Pro',
      description: 'Engineered for performance with responsive cushioning and breathable mesh upper. Ideal for daily runs and gym sessions.',
      price: 129.99,
      discountPrice: 99.99,
      images: const [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=600',
      ],
      categoryId: 'c3',
      rating: 4.8,
      reviewCount: 214,
      stock: 40,
      brand: 'Stride',
      sizes: const ['7', '8', '9', '10', '11'],
      colors: const ['White', 'Grey'],
      isFeatured: true,
    ),
    Product(
      id: 'p4',
      name: 'Leather Tote Bag',
      description: 'Handcrafted from genuine leather, this spacious tote combines elegance with functionality for everyday use.',
      price: 149.99,
      images: const [
        'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=600',
        'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=600',
      ],
      categoryId: 'c4',
      rating: 4.6,
      reviewCount: 73,
      stock: 10,
      brand: 'Maison Leather',
      colors: const ['Brown', 'Black'],
    ),
    Product(
      id: 'p5',
      name: 'Aviator Sunglasses',
      description: 'Classic aviator design with UV400 protection lenses and a durable metal frame.',
      price: 39.99,
      discountPrice: 24.99,
      images: const [
        'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=600',
      ],
      categoryId: 'c5',
      rating: 4.3,
      reviewCount: 58,
      stock: 60,
      brand: 'SunVibe',
      colors: const ['Gold', 'Silver'],
      isFeatured: true,
    ),
    Product(
      id: 'p6',
      name: 'Wireless Noise-Cancelling Headphones',
      description: 'Immersive sound with active noise cancellation, 30-hour battery life, and plush over-ear cushions.',
      price: 199.99,
      discountPrice: 159.99,
      images: const [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
        'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=600',
      ],
      categoryId: 'c6',
      rating: 4.9,
      reviewCount: 342,
      stock: 18,
      brand: 'SoundCore',
      colors: const ['Black', 'White'],
      isFeatured: true,
    ),
    Product(
      id: 'p7',
      name: 'Slim Fit Chino Pants',
      description: 'Comfortable stretch chinos with a modern slim fit, perfect for both office and casual wear.',
      price: 54.99,
      images: const [
        'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=600',
      ],
      categoryId: 'c1',
      rating: 4.4,
      reviewCount: 87,
      stock: 32,
      brand: 'Urban Edge',
      sizes: const ['30', '32', '34', '36'],
      colors: const ['Khaki', 'Navy'],
    ),
    Product(
      id: 'p8',
      name: 'Chunky Knit Sweater',
      description: 'Cozy oversized sweater made from soft chunky knit yarn, perfect for the cold season.',
      price: 74.99,
      discountPrice: 54.99,
      images: const [
        'https://images.unsplash.com/photo-1576871337622-98d48d1cf531?w=600',
      ],
      categoryId: 'c2',
      rating: 4.6,
      reviewCount: 65,
      stock: 22,
      brand: 'Bloom & Co',
      sizes: const ['S', 'M', 'L'],
      colors: const ['Cream', 'Grey'],
    ),
    Product(
      id: 'p9',
      name: 'Classic Canvas High-Tops',
      description: 'Retro-inspired canvas sneakers with a durable rubber sole and timeless silhouette.',
      price: 64.99,
      images: const [
        'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=600',
      ],
      categoryId: 'c3',
      rating: 4.2,
      reviewCount: 145,
      stock: 50,
      brand: 'Stride',
      sizes: const ['6', '7', '8', '9', '10'],
      colors: const ['White', 'Black', 'Red'],
    ),
    Product(
      id: 'p10',
      name: 'Smart Fitness Watch',
      description: 'Track your workouts, heart rate, and sleep with this sleek smart watch featuring a vibrant AMOLED display.',
      price: 179.99,
      discountPrice: 139.99,
      images: const [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600',
        'https://images.unsplash.com/photo-1544117519-31a4b719223d?w=600',
      ],
      categoryId: 'c6',
      rating: 4.7,
      reviewCount: 289,
      stock: 27,
      brand: 'PulseTech',
      colors: const ['Black', 'Rose Gold'],
      isFeatured: true,
    ),
    Product(
      id: 'p11',
      name: 'Minimalist Crossbody Bag',
      description: 'Compact and stylish crossbody bag with adjustable strap, ideal for essentials on the go.',
      price: 44.99,
      images: const [
        'https://images.unsplash.com/photo-1591561954557-26941169b49e?w=600',
      ],
      categoryId: 'c4',
      rating: 4.4,
      reviewCount: 39,
      stock: 33,
      brand: 'Maison Leather',
      colors: const ['Tan', 'Black'],
    ),
    Product(
      id: 'p12',
      name: 'Silk Blend Scarf',
      description: 'Luxuriously soft scarf with an elegant printed pattern, perfect for adding flair to any outfit.',
      price: 29.99,
      images: const [
        'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=600',
      ],
      categoryId: 'c5',
      rating: 4.5,
      reviewCount: 21,
      stock: 45,
      brand: 'SunVibe',
      colors: const ['Multi'],
    ),
  ];

  final List<Coupon> coupons = [
    Coupon(id: 'cp1', code: 'WELCOME10', description: 'Get 10% off on your first order', discountPercent: 10, minOrderValue: 0, expiryDate: DateTime.now().add(const Duration(days: 30))),
    Coupon(id: 'cp2', code: 'SAVE20', description: '20% off on orders above \$100', discountPercent: 20, minOrderValue: 100, expiryDate: DateTime.now().add(const Duration(days: 15))),
    Coupon(id: 'cp3', code: 'MEGA30', description: '30% off on orders above \$200', discountPercent: 30, minOrderValue: 200, expiryDate: DateTime.now().add(const Duration(days: 7))),
  ];

  final List<CartEntry> cart = [];

  final List<String> wishlistIds = [];

  final List<Address> addresses = [
    Address(id: 'a1', label: 'Home', fullName: 'Hamad Raja', phone: '+1 555 123 4567', addressLine: '221B Baker Street', city: 'New York', state: 'NY', zipCode: '10001', isDefault: true),
    Address(id: 'a2', label: 'Office', fullName: 'Hamad Raja', phone: '+1 555 987 6543', addressLine: '48 Wall Street, Suite 12', city: 'New York', state: 'NY', zipCode: '10005'),
  ];

  final List<Order> orders = [];
}

class CartEntry {
  CartEntry({required this.productId, this.quantity = 1, this.size, this.color});
  final String productId;
  int quantity;
  final String? size;
  final String? color;
}
