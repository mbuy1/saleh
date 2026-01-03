/// Cart Models - نماذج السلة
///
/// Represents cart and cart items in the MBUY platform
library;

import 'product.dart';

/// Cart Item Model
class CartItem {
  final String id;
  final String cartId;
  final String productId;
  final int quantity;
  final double price;
  final double? originalPrice;
  final Product? product;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.price,
    this.originalPrice,
    this.product,
    this.createdAt,
    this.updatedAt,
  });

  /// Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    Product? prod;
    if (json['products'] != null) {
      prod = Product.fromJson(json['products']);
    } else if (json['product'] != null) {
      prod = Product.fromJson(json['product']);
    }

    return CartItem(
      id: json['id']?.toString() ?? '',
      cartId: json['cart_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? prod?.price ?? 0).toDouble(),
      originalPrice: json['original_price']?.toDouble(),
      product: prod,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Convert CartItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'original_price': originalPrice,
    };
  }

  /// Calculate subtotal for this item
  double get subtotal => price * quantity;

  /// Get product name
  String get productName => product?.name ?? 'Unknown Product';

  /// Get product image
  String? get productImage => product?.displayImage;

  /// Get store info
  String? get storeName => product?.storeName;
  String get storeId => product?.storeId ?? '';

  /// Copy with modifications
  CartItem copyWith({
    String? id,
    String? cartId,
    String? productId,
    int? quantity,
    double? price,
    double? originalPrice,
    Product? product,
  }) {
    return CartItem(
      id: id ?? this.id,
      cartId: cartId ?? this.cartId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      product: product ?? this.product,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Cart Model
class Cart {
  final String id;
  final String userId;
  final List<CartItem> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Cart({
    required this.id,
    required this.userId,
    this.items = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// Create Cart from JSON
  factory Cart.fromJson(Map<String, dynamic> json) {
    List<CartItem> cartItems = [];
    if (json['items'] != null && json['items'] is List) {
      cartItems = (json['items'] as List)
          .map((e) => CartItem.fromJson(e))
          .toList();
    }

    return Cart(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      items: cartItems,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Convert Cart to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  /// Calculate total items count
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Calculate subtotal
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.subtotal);

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Get items grouped by store
  Map<String, List<CartItem>> get itemsByStore {
    final Map<String, List<CartItem>> grouped = {};
    for (final item in items) {
      final storeId = item.storeId;
      if (!grouped.containsKey(storeId)) {
        grouped[storeId] = [];
      }
      grouped[storeId]!.add(item);
    }
    return grouped;
  }

  /// Get unique store count
  int get storeCount => itemsByStore.keys.length;

  /// Copy with modifications
  Cart copyWith({String? id, String? userId, List<CartItem>? items}) {
    return Cart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cart && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Store Group for cart display
class CartStoreGroup {
  final String storeId;
  final String storeName;
  final String? storeLogo;
  final List<CartItem> items;

  CartStoreGroup({
    required this.storeId,
    required this.storeName,
    this.storeLogo,
    required this.items,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.subtotal);
  int get itemsCount => items.fold(0, (sum, item) => sum + item.quantity);
}
