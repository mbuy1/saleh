/// بيانات وهمية للتطبيق
///
/// ملاحظة: يتم استخدام هذه البيانات كبيانات احتياطية عندما لا تكون Supabase متاحة
/// للوصول للبيانات الحية، استخدم Repositories:
/// - ProductRepository
/// - StoreRepository
/// - CategoryRepository
/// - ExploreRepository
library;

import 'models.dart';

class DummyData {
  // البيانات الوهمية - Categories
  static List<Category> get mainCategories => [
    const Category(id: '1', name: 'إلكترونيات', icon: '📱', order: 1),
    const Category(id: '2', name: 'أزياء', icon: '👗', order: 2),
    const Category(id: '3', name: 'منزل ومطبخ', icon: '🏠', order: 3),
    const Category(id: '4', name: 'رياضة', icon: '⚽', order: 4),
    const Category(id: '5', name: 'كتب', icon: '📚', order: 5),
  ];

  static List<Category> get allCategories => [
    ...mainCategories,
    const Category(
      id: '11',
      name: 'هواتف',
      icon: '📱',
      parentId: '1',
      order: 1,
    ),
    const Category(
      id: '12',
      name: 'لابتوب',
      icon: '💻',
      parentId: '1',
      order: 2,
    ),
    const Category(
      id: '21',
      name: 'رجالي',
      icon: '👔',
      parentId: '2',
      order: 1,
    ),
    const Category(
      id: '22',
      name: 'نسائي',
      icon: '👗',
      parentId: '2',
      order: 2,
    ),
  ];

  // البيانات الوهمية - Stores
  static List<Store> get stores => [
    const Store(
      id: '1',
      name: 'متجر الإلكترونيات',
      description: 'أحدث الأجهزة الإلكترونية',
      rating: 4.5,
      followersCount: 1500,
      isVerified: true,
      isBoosted: true,
      latitude: 24.7136,
      longitude: 46.6753,
      city: 'الرياض',
    ),
    const Store(
      id: '2',
      name: 'متجر الأزياء',
      description: 'أفضل الملابس العصرية',
      rating: 4.8,
      followersCount: 2300,
      isVerified: true,
      isBoosted: false,
      latitude: 24.7240,
      longitude: 46.6850,
      city: 'الرياض',
    ),
  ];

  // البيانات الوهمية - Products
  static List<Product> get products => [
    const Product(
      id: '1',
      name: 'آيفون 15 برو',
      description: 'أحدث هاتف من آبل',
      price: 4999.00,
      categoryId: '11',
      storeId: '1',
      rating: 4.7,
      reviewCount: 150,
      stockCount: 25,
    ),
    const Product(
      id: '2',
      name: 'سامسونج S24',
      description: 'أحدث هاتف من سامسونج',
      price: 3999.00,
      categoryId: '11',
      storeId: '1',
      rating: 4.6,
      reviewCount: 120,
      stockCount: 30,
    ),
  ];

  // البيانات الوهمية - Explore Videos
  static List<VideoItem> get exploreVideos => [
    const VideoItem(
      id: '1',
      title: 'مراجعة آيفون 15 برو',
      userName: 'محمد التقني',
      userAvatar: '👨‍💻',
      likes: 1500,
      dislikes: 20,
      comments: 250,
      caption: 'مراجعة شاملة لأحدث هاتف من آبل',
      productId: '1',
      productPrice: 4999.00,
    ),
    const VideoItem(
      id: '2',
      title: 'مقارنة سامسونج S24 مع آيفون',
      userName: 'سارة التقنية',
      userAvatar: '👩‍💻',
      likes: 2000,
      dislikes: 15,
      comments: 300,
      caption: 'مقارنة تفصيلية بين الهاتفين',
      productId: '2',
      productPrice: 3999.00,
    ),
  ];

  // Helper methods
  static dynamic getCategoryIcon(String categoryId) {
    try {
      return allCategories.firstWhere((c) => c.id == categoryId).icon;
    } catch (e) {
      return '📦';
    }
  }

  static List<Category> getCategoriesByParent(String? parentId) {
    if (parentId == null) return mainCategories;
    return allCategories.where((c) => c.parentId == parentId).toList();
  }

  static List<Product> getProductsByCategory(String categoryId) {
    return products.where((p) => p.categoryId == categoryId).toList();
  }

  static List<Product> getProductsByStore(String storeId) {
    return products.where((p) => p.storeId == storeId).toList();
  }

  static Product? getProductById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  static Store? getStoreById(String id) {
    try {
      return stores.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}
