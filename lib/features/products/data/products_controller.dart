import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/product.dart';
import 'products_repository.dart';

/// Products State
/// حالة المنتجات في التطبيق
class ProductsState {
  final List<Product> products;
  final bool isLoading;
  final String? errorMessage;

  ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Products Controller
/// يدير حالة المنتجات ويتعامل مع العمليات
class ProductsController extends StateNotifier<ProductsState> {
  final ProductsRepository _repository;

  ProductsController(this._repository) : super(ProductsState()) {
    // جلب المنتجات عند إنشاء Controller
    loadProducts();
  }

  /// جلب قائمة المنتجات
  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final products = await _repository.getMerchantProducts();
      state = state.copyWith(products: products, isLoading: false);
    } catch (e) {
      // تحويل Exception إلى رسالة نظيفة للمستخدم
      String errorMessage = 'حدث خطأ في تحميل المنتجات';

      if (e.toString().contains('لا يوجد رمز وصول')) {
        errorMessage = 'يجب تسجيل الدخول أولاً';
      }

      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
    }
  }

  /// إضافة منتج جديد
  Future<bool> addProduct({
    required String name,
    required double price,
    required int stock,
    String? description,
    String? imageUrl,
    String? categoryId,
    List<Map<String, dynamic>>? media,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final newProduct = await _repository.createProduct(
        name: name,
        price: price,
        stock: stock,
        description: description,
        imageUrl: imageUrl,
        categoryId: categoryId,
        media: media,
      );

      // إضافة المنتج الجديد للقائمة
      state = state.copyWith(
        products: [...state.products, newProduct],
        isLoading: false,
      );

      return true;
    } catch (e) {
      // تحويل Exception إلى رسالة نظيفة
      String errorMessage = 'فشل إضافة المنتج';

      final errorStr = e.toString();
      if (errorStr.contains('لا يوجد رمز وصول')) {
        errorMessage = 'يجب تسجيل الدخول أولاً';
      } else if (errorStr.contains('Store not found') ||
          errorStr.contains('NO_ACTIVE_STORE') ||
          errorStr.contains('لا يوجد متجر نشط')) {
        errorMessage = 'يجب إنشاء متجر أولاً';
      } else if (errorStr.contains('NOT_MERCHANT')) {
        errorMessage = 'يجب أن تكون تاجراً لإضافة منتجات';
      } else if (errorStr.contains('NO_USER_PROFILE')) {
        errorMessage = 'حسابك غير مكتمل، يرجى التواصل مع الدعم';
      } else if (errorStr.contains('Internal server error')) {
        errorMessage = 'خطأ في الخادم، يرجى المحاولة لاحقاً';
      } else if (errorStr.contains('Exception:')) {
        // إزالة "Exception: " من الرسالة
        errorMessage = errorStr.replaceFirst('Exception:', '').trim();
      }

      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return false;
    }
  }

  /// تحديث منتج موجود
  Future<bool> updateProduct({
    required String productId,
    String? name,
    double? price,
    int? stock,
    String? description,
    String? imageUrl,
    String? categoryId,
    bool? isActive,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final updatedProduct = await _repository.updateProduct(
        productId: productId,
        name: name,
        price: price,
        stock: stock,
        description: description,
        imageUrl: imageUrl,
        categoryId: categoryId,
        isActive: isActive,
      );

      // تحديث المنتج في القائمة
      final updatedList = state.products.map((product) {
        return product.id == productId ? updatedProduct : product;
      }).toList();

      state = state.copyWith(products: updatedList, isLoading: false);

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// حذف منتج
  Future<bool> deleteProduct(String productId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _repository.deleteProduct(productId);

      // حذف المنتج من القائمة
      final updatedList = state.products
          .where((product) => product.id != productId)
          .toList();

      state = state.copyWith(products: updatedList, isLoading: false);

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// مسح رسالة الخطأ
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Riverpod Provider for ProductsController
final productsControllerProvider =
    StateNotifierProvider<ProductsController, ProductsState>((ref) {
      final repository = ref.watch(productsRepositoryProvider);
      return ProductsController(repository);
    });

/// Provider للوصول السريع لقائمة المنتجات
final productsListProvider = Provider<List<Product>>((ref) {
  return ref.watch(productsControllerProvider).products;
});

/// Provider للتحقق من حالة التحميل
final productsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(productsControllerProvider).isLoading;
});
