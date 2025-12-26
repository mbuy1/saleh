# دليل المطور الشامل - MBUY Merchant Application

> آخر تحديث: 26 ديسمبر 2025

---

## جدول المحتويات

1. [نظرة عامة](#1-نظرة-عامة)
2. [البنية المعمارية](#2-البنية-المعمارية)
3. [التقنيات والمكتبات](#3-التقنيات-والمكتبات)
4. [إعدادات التكوين](#4-إعدادات-التكوين)
5. [نظام المصادقة](#5-نظام-المصادقة)
6. [طبقة API](#6-طبقة-api)
7. [النماذج الرئيسية](#7-النماذج-الرئيسية)
8. [State Management](#8-state-management)
9. [نظام التوجيه](#9-نظام-التوجيه)
10. [نظام الألوان والمظهر](#10-نظام-الألوان-والمظهر)
11. [الـ Widgets المشتركة](#11-الـ-widgets-المشتركة)
12. [التخزين المحلي](#12-التخزين-المحلي)
13. [معالجة الأخطاء](#13-معالجة-الأخطاء)
14. [أفضل الممارسات](#14-أفضل-الممارسات)
15. [دليل إضافة Feature جديدة](#15-دليل-إضافة-feature-جديدة)

---

## 1. نظرة عامة

### المعلومات الأساسية

| المعلومة | القيمة |
|----------|--------|
| **اسم التطبيق** | MBUY Merchant Application |
| **الإصدار** | 1.0.0 |
| **نوع المشروع** | تطبيق إدارة متاجر للتجار |
| **Dart SDK** | 3.10.0+ |
| **Flutter SDK** | 3.27.0+ |
| **المنصات** | iOS, Android |

### الغرض الرئيسي

تطبيق محمول متخصص لإدارة متاجر التجار الإلكترونية:
- إدارة المنتجات والمخزون
- متابعة الطلبات والمبيعات
- إدارة المحفظة ونقاط الولاء
- تحليلات وتقارير متقدمة
- أدوات تسويق ذكية
- استوديو إنشاء المحتوى بالذكاء الاصطناعي

---

## 2. البنية المعمارية

### هيكل المشروع

```
lib/
├── main.dart                    # نقطة البداية
├── apps/                        # التطبيقات
│   └── merchant/               # تطبيق التاجر
│       ├── merchant_app.dart   # نقطة دخول التطبيق
│       └── features/           # ميزات خاصة بالتاجر
│
├── core/                        # النواة الأساسية
│   ├── config/                 # إعدادات التكوين
│   │   └── api_config.dart
│   ├── constants/              # الثوابت
│   │   ├── app_dimensions.dart
│   │   └── app_icons.dart
│   ├── controllers/            # المتحكمات الرئيسية
│   │   └── root_controller.dart
│   ├── errors/                 # معالجة الأخطاء
│   │   └── api_error_handler.dart
│   ├── l10n/                   # الترجمة والنصوص
│   │   └── app_strings.dart
│   ├── providers/              # Riverpod Providers
│   │   └── theme_provider.dart
│   ├── router/                 # نظام التوجيه
│   │   ├── app_router.dart
│   │   └── routes/
│   │       ├── auth_routes.dart
│   │       ├── settings_routes.dart
│   │       └── dashboard_routes.dart
│   ├── services/               # الخدمات
│   │   ├── api_service.dart
│   │   ├── auth_token_storage.dart
│   │   └── user_preferences_service.dart
│   └── theme/                  # المظهر والألوان
│       └── app_theme.dart
│
├── features/                    # الميزات (Clean Architecture)
│   ├── auth/                   # المصادقة
│   │   ├── data/
│   │   │   ├── auth_controller.dart
│   │   │   └── auth_repository.dart
│   │   └── presentation/screens/
│   │
│   ├── dashboard/              # لوحة التحكم
│   │   └── presentation/screens/
│   │       ├── dashboard_shell.dart
│   │       ├── home_tab.dart
│   │       ├── orders_tab.dart
│   │       └── products_tab.dart
│   │
│   ├── merchant/               # بيانات التاجر والمتجر
│   │   ├── data/
│   │   │   ├── merchant_store_provider.dart
│   │   │   └── merchant_repository.dart
│   │   ├── domain/models/
│   │   │   └── store.dart
│   │   └── presentation/screens/
│   │
│   ├── products/               # إدارة المنتجات
│   │   ├── data/
│   │   │   ├── products_controller.dart
│   │   │   └── products_repository.dart
│   │   ├── domain/models/
│   │   │   └── product.dart
│   │   └── presentation/
│   │
│   ├── finance/                # المحفظة والمالية
│   ├── marketing/              # الأدوات التسويقية
│   ├── studio/                 # استوديو المحتوى
│   ├── settings/               # الإعدادات
│   └── ...                     # ميزات أخرى
│
└── shared/                      # العناصر المشتركة
    ├── app_shell.dart          # الـ Shell الرئيسي
    ├── screens/                # شاشات مشتركة
    │   └── login_screen.dart
    └── widgets/                # Widgets مشتركة
        ├── mbuy_button.dart
        ├── mbuy_card.dart
        ├── skeleton_loading.dart
        └── ...
```

### نمط Clean Architecture

كل Feature تتبع هذا النمط:

```
feature/
├── domain/              # طبقة المنطق البحت
│   └── models/         # النماذج
├── data/               # طبقة البيانات
│   ├── repository.dart # التعامل مع API
│   └── controller.dart # إدارة الحالة
└── presentation/       # طبقة العرض
    ├── screens/        # الشاشات
    └── widgets/        # مكونات فرعية
```

---

## 3. التقنيات والمكتبات

### State Management
```yaml
flutter_riverpod: ^2.6.1      # إدارة الحالة
riverpod_annotation: ^2.6.1   # Annotations للتوليد
```

### Navigation
```yaml
go_router: ^14.8.1            # التوجيه المتقدم
```

### Network & API
```yaml
http: ^1.2.0                  # HTTP requests
```

### Storage
```yaml
flutter_secure_storage: ^9.2.3  # تخزين آمن
shared_preferences: ^2.3.2      # تفضيلات المستخدم
```

### UI/UX
```yaml
google_fonts: ^6.2.1          # خطوط Google
cached_network_image: ^3.4.1  # تخزين الصور
flutter_svg: ^2.0.16          # رسومات SVG
fl_chart: ^0.70.0             # الرسوم البيانية
```

### Firebase
```yaml
firebase_core                 # Firebase الأساسي
firebase_messaging            # Push Notifications
firebase_analytics            # التحليلات
```

---

## 4. إعدادات التكوين

### `lib/core/config/api_config.dart`

```dart
class ApiConfig {
  // الخادم الرئيسي (Cloudflare Worker)
  static const String baseUrl = 'https://misty-mode-b68b.baharista1.workers.dev';

  // Supabase (للمصادقة)
  static const String supabaseUrl = 'https://sirqidofuvphqcxqchyc.supabase.co';

  // مهلات الانتظار
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration longRequestTimeout = Duration(minutes: 2);
}
```

### `lib/core/app_config.dart`

```dart
class AppConfig {
  static const String apiBaseUrl = ApiConfig.baseUrl;
  static const String appName = 'MBUY Merchant';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userRoleKey = 'user_role';
}
```

---

## 5. نظام المصادقة

### تدفق المصادقة

```
┌─────────────────┐
│   Login Screen  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     ┌──────────────────────┐
│  AuthRepository │────▶│ POST /auth/login     │
└────────┬────────┘     └──────────────────────┘
         │
         ▼
┌─────────────────┐
│ Save Tokens     │ (SecureStorage)
│ - access_token  │
│ - refresh_token │
│ - user_id       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Dashboard     │
└─────────────────┘
```

### AuthRepository (`lib/features/auth/data/auth_repository.dart`)

```dart
class AuthRepository {
  // تسجيل الدخول
  Future<AuthResult> signIn(String email, String password);

  // إنشاء حساب
  Future<AuthResult> signUp(String email, String password, String name);

  // تسجيل الخروج
  Future<void> signOut();

  // التحقق من الجلسة
  Future<bool> hasValidSession();

  // تجديد التوكن
  Future<bool> refreshToken();
}
```

### AuthController (`lib/features/auth/data/auth_controller.dart`)

```dart
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? userEmail;
  final String? userId;
  final String? userRole;
  final String? errorMessage;
}

class AuthController extends Notifier<AuthState> {
  Future<bool> login(String email, String password);
  Future<void> logout();
  Future<void> checkSavedSession();
}

// Provider
final authControllerProvider = NotifierProvider<AuthController, AuthState>(...);
```

---

## 6. طبقة API

### ApiService (`lib/core/services/api_service.dart`)

```dart
class ApiService {
  // الطلبات الأساسية
  Future<http.Response> get(String path, {Map<String, String>? headers});
  Future<http.Response> post(String path, {dynamic body});
  Future<http.Response> put(String path, {dynamic body});
  Future<http.Response> patch(String path, {dynamic body});
  Future<http.Response> delete(String path);

  // أدوات مساعدة
  bool isSuccessful(http.Response response);  // 200-299
  Map<String, dynamic> parseResponse(http.Response response);
}
```

### الميزات الرئيسية

1. **Authorization Header تلقائي**: يضيف Bearer token من SecureStorage
2. **تجديد التوكن التلقائي**: يعالج 401 بتجديد التوكن
3. **إعادة المحاولة**: 3 محاولات عند فشل الاتصال
4. **Timeout قابل للتخصيص**: 30 ثانية افتراضي

### مثال الاستخدام

```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiService = ref.read(apiServiceProvider);

    Future<void> fetchData() async {
      try {
        final response = await apiService.get('/secure/merchant/products');

        if (apiService.isSuccessful(response)) {
          final data = apiService.parseResponse(response);
          // استخدم البيانات
        }
      } catch (e) {
        // معالجة الخطأ
      }
    }
  }
}
```

### Endpoints الرئيسية

| Endpoint | Method | الوصف |
|----------|--------|-------|
| `/auth/supabase/login` | POST | تسجيل الدخول |
| `/auth/supabase/register` | POST | إنشاء حساب |
| `/auth/supabase/refresh` | POST | تجديد التوكن |
| `/secure/merchant/store` | GET | بيانات المتجر |
| `/secure/merchant/products` | GET/POST | المنتجات |
| `/secure/merchant/orders` | GET | الطلبات |

---

## 7. النماذج الرئيسية

### Store (`lib/features/merchant/domain/models/store.dart`)

```dart
class Store {
  final String id;
  final String name;
  final String? description;
  final String? city;
  final String? logoUrl;
  final int followersCount;
  final Map<String, dynamic>? settings;
  final DateTime? createdAt;

  factory Store.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
  Store copyWith({...});
}
```

### Product (`lib/features/products/domain/models/product.dart`)

```dart
class Product {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String? imageUrl;
  final String? categoryId;
  final String storeId;
  final bool isActive;
  final String? description;
  final List<ProductMedia> media;

  // Getters مفيدة
  String? get mainImageUrl;
  List<String> get imageUrls;
  String? get videoUrl;

  factory Product.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

class ProductMedia {
  final String id;
  final String mediaType;  // 'image' | 'video'
  final String url;
  final bool isMain;
  final int sortOrder;
}
```

---

## 8. State Management

### نمط Riverpod 3.x

#### Notifier Pattern

```dart
// تعريف State
class MyState {
  final bool isLoading;
  final List<Item> items;
  final String? error;

  MyState({
    this.isLoading = false,
    this.items = const [],
    this.error,
  });

  MyState copyWith({...});
}

// تعريف Controller
class MyController extends Notifier<MyState> {
  @override
  MyState build() {
    return MyState();
  }

  Future<void> loadItems() async {
    state = state.copyWith(isLoading: true);
    try {
      final items = await repository.getItems();
      state = state.copyWith(isLoading: false, items: items);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// تعريف Provider
final myControllerProvider = NotifierProvider<MyController, MyState>(
  MyController.new,
);
```

#### AsyncNotifier Pattern

```dart
class MerchantStoreController extends AsyncNotifier<Store?> {
  @override
  Future<Store?> build() async {
    return await _loadStore();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadStore());
  }
}

final merchantStoreControllerProvider =
    AsyncNotifierProvider<MerchantStoreController, Store?>(
      MerchantStoreController.new,
    );
```

### استخدام Providers

```dart
// قراءة الحالة (reactive)
final state = ref.watch(myControllerProvider);

// قراءة الحالة (one-time)
final state = ref.read(myControllerProvider);

// استدعاء method
ref.read(myControllerProvider.notifier).loadItems();

// استخدام AsyncValue
storeAsync.when(
  loading: () => CircularProgressIndicator(),
  error: (e, st) => Text('Error: $e'),
  data: (store) => Text(store?.name ?? 'No store'),
);
```

### Providers الرئيسية

| Provider | النوع | الوصف |
|----------|-------|-------|
| `apiServiceProvider` | Provider | خدمة HTTP |
| `authControllerProvider` | NotifierProvider | حالة المصادقة |
| `merchantStoreControllerProvider` | AsyncNotifierProvider | بيانات المتجر |
| `productsControllerProvider` | NotifierProvider | المنتجات |
| `themeProvider` | StateNotifierProvider | الثيم |
| `preferencesStateProvider` | NotifierProvider | التفضيلات |

---

## 9. نظام التوجيه

### هيكل الملفات

```
lib/core/router/
├── app_router.dart           # Router الرئيسي
├── page_transitions.dart     # انتقالات مخصصة
└── routes/
    ├── auth_routes.dart      # مسارات المصادقة
    ├── settings_routes.dart  # مسارات الإعدادات
    └── dashboard_routes.dart # مسارات لوحة التحكم
```

### AppRouter (`lib/core/router/app_router.dart`)

```dart
class AppRouter {
  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/login',

      // حماية المسارات
      redirect: (context, state) {
        final authState = ref.read(authControllerProvider);
        final isAuthenticated = authState.isAuthenticated;
        final isLoggingIn = state.matchedLocation == '/login';

        if (!isAuthenticated && !isLoggingIn) {
          return '/login';
        }
        if (isAuthenticated && isLoggingIn) {
          return '/dashboard';
        }
        return null;
      },

      routes: [
        ...authRoutes,        // Auth Routes
        ...settingsRoutes,    // Settings Routes
        dashboardShellRoute,  // Dashboard Shell
      ],
    );
  }
}
```

### المسارات الرئيسية

| المسار | الشاشة | الوصف |
|--------|--------|-------|
| `/login` | LoginScreen | تسجيل الدخول |
| `/register` | RegisterScreen | إنشاء حساب |
| `/forgot-password` | ForgotPasswordScreen | استرجاع كلمة المرور |
| `/dashboard` | HomeTab | الصفحة الرئيسية |
| `/dashboard/orders` | OrdersTab | الطلبات |
| `/dashboard/products` | ProductsTab | المنتجات |
| `/dashboard/studio` | StudioMainPage | استوديو المحتوى |
| `/settings` | AccountSettingsScreen | الإعدادات |

### التنقل

```dart
// الانتقال لصفحة جديدة
context.push('/dashboard/products');

// استبدال الصفحة الحالية
context.go('/dashboard');

// الرجوع
context.pop();

// مع parameters
context.push('/dashboard/products/${product.id}');

// مع extra data
context.push('/dashboard/studio/editor', extra: {'projectId': '123'});
```

---

## 10. نظام الألوان والمظهر

### الألوان الأساسية

```dart
// lib/core/theme/app_theme.dart

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF00B4B4);      // تركواز
  static const Color primaryDark = Color(0xFF215950);       // أخضر غامق
  static const Color accentColor = Color(0xFFFF6B35);       // برتقالي

  // Status Colors
  static const Color successColor = Color(0xFF10B981);      // أخضر
  static const Color errorColor = Color(0xFFEF4444);        // أحمر
  static const Color warningColor = Color(0xFFF59E0B);      // أصفر

  // Light Mode
  static const Color backgroundColorLight = Color(0xFFF1F5F9);
  static const Color surfaceColorLight = Color(0xFFFFFFFF);
  static const Color textPrimaryColorLight = Color(0xFF1E293B);

  // Dark Mode
  static const Color backgroundColorDark = Color(0xFF0F172A);
  static const Color surfaceColorDark = Color(0xFF1E293B);
  static const Color textPrimaryColorDark = Color(0xFFF1F5F9);
}
```

### Helper Methods

```dart
// الحصول على اللون حسب الوضع
static Color background(bool isDark) =>
    isDark ? backgroundColorDark : backgroundColorLight;

static Color textPrimary(bool isDark) =>
    isDark ? textPrimaryColorDark : textPrimaryColorLight;

static Color card(bool isDark) =>
    isDark ? surfaceColorDark : surfaceColorLight;

static Color border(bool isDark) =>
    isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1);
```

### استخدام الألوان

```dart
@override
Widget build(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    color: AppTheme.background(isDark),
    child: Text(
      'مرحباً',
      style: TextStyle(color: AppTheme.textPrimary(isDark)),
    ),
  );
}
```

---

## 11. الـ Widgets المشتركة

### MbuyButton

```dart
MbuyButton(
  label: 'حفظ',
  onPressed: () => save(),
  type: MbuyButtonType.primary,  // primary, secondary, outline, text
  isLoading: isLoading,
  icon: Icons.save,
);
```

### MbuyCard

```dart
MbuyCard(
  child: Text('المحتوى'),
  onTap: () => openDetails(),
  padding: EdgeInsets.all(16),
);
```

### Skeleton Loading

```dart
// استخدام ShimmerControllerProvider للمشاركة
ShimmerControllerProvider(
  child: Column(
    children: [
      SkeletonBox(height: 100),
      SkeletonText(lines: 3),
      SkeletonCircle(size: 48),
    ],
  ),
);

// أو مباشرة
const SkeletonHomeDashboard();
const SkeletonOrdersList(count: 5);
const SkeletonProductsGrid(count: 6);
```

### MbuyEmptyState

```dart
MbuyEmptyState(
  icon: Icons.inbox,
  title: 'لا توجد طلبات',
  message: 'ستظهر هنا عند وصول طلبات جديدة',
  actionLabel: 'إضافة منتج',
  onAction: () => context.push('/dashboard/products/add'),
);
```

---

## 12. التخزين المحلي

### SecureStorage (للبيانات الحساسة)

```dart
final storage = ref.read(secureStorageProvider);

// حفظ
await storage.write(key: 'access_token', value: token);

// قراءة
final token = await storage.read(key: 'access_token');

// حذف
await storage.delete(key: 'access_token');

// حذف الكل
await storage.deleteAll();
```

### Keys المحفوظة

| Key | النوع | الوصف |
|-----|-------|-------|
| `access_token` | String | رمز الوصول |
| `refresh_token` | String | رمز التجديد |
| `user_id` | String | معرف المستخدم |
| `user_role` | String | دور المستخدم (merchant) |
| `user_email` | String | البريد الإلكتروني |

### SharedPreferences (للتفضيلات)

```dart
final prefs = await SharedPreferences.getInstance();

// حفظ
await prefs.setString('theme_mode', 'dark');
await prefs.setBool('notifications', true);

// قراءة
final theme = prefs.getString('theme_mode') ?? 'system';
final notifications = prefs.getBool('notifications') ?? true;
```

---

## 13. معالجة الأخطاء

### ApiErrorHandler

```dart
class ApiErrorHandler {
  static void handleError(BuildContext context, dynamic error) {
    String message;

    if (error is SocketException) {
      message = 'لا يوجد اتصال بالإنترنت';
    } else if (error is TimeoutException) {
      message = 'انتهت مهلة الطلب';
    } else if (error is HttpException) {
      message = 'خطأ في الخادم';
    } else {
      message = 'حدث خطأ غير متوقع';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static String extractErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['message'] ?? body['error'] ?? 'خطأ غير معروف';
    } catch (_) {
      return 'خطأ في معالجة الاستجابة';
    }
  }
}
```

### معالجة الأخطاء في Repository

```dart
Future<List<Product>> getProducts() async {
  try {
    final response = await apiService.get('/secure/merchant/products');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['products'] as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } else if (response.statusCode == 404) {
      return [];  // قائمة فارغة
    } else {
      throw Exception(ApiErrorHandler.extractErrorMessage(response));
    }
  } catch (e) {
    rethrow;
  }
}
```

---

## 14. أفضل الممارسات

### 1. استخدام Riverpod

```dart
// ✅ صحيح: استخدم ConsumerWidget
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    return Text(state.toString());
  }
}

// ✅ صحيح: استخدم ref.watch للـ reactive
final store = ref.watch(merchantStoreProvider);

// ✅ صحيح: استخدم ref.read للعمليات
ref.read(authControllerProvider.notifier).logout();

// ❌ خطأ: لا تستخدم ref.watch داخل callbacks
onPressed: () {
  final state = ref.watch(myProvider); // ❌
}
```

### 2. التعامل مع AsyncValue

```dart
// ✅ صحيح: استخدم when للحالات الثلاث
storeAsync.when(
  loading: () => const CircularProgressIndicator(),
  error: (e, st) => ErrorWidget(e),
  data: (store) => StoreContent(store),
);

// ✅ صحيح: للحصول على القيمة بأمان
final store = storeAsync.hasValue ? storeAsync.value : null;
```

### 3. Clean Architecture

```dart
// ✅ صحيح: فصل الطبقات
// domain/ - النماذج فقط
// data/ - Repository + Controller
// presentation/ - Screens + Widgets

// ❌ خطأ: API calls في الـ Widget مباشرة
```

### 4. النصوص والترجمة

```dart
// ✅ صحيح: استخدم AppStrings
Text(AppStrings.login)

// ❌ خطأ: نصوص مباشرة
Text('تسجيل الدخول')
```

### 5. الألوان

```dart
// ✅ صحيح: استخدم AppTheme
color: AppTheme.primaryColor

// ❌ خطأ: ألوان hardcoded
color: Color(0xFF00B4B4)
```

### 6. الأداء

```dart
// ✅ صحيح: حساب isDark مرة واحدة في build
final isDark = Theme.of(context).brightness == Brightness.dark;
// ثم مرره كـ parameter

// ❌ خطأ: استدعاء Theme.of عدة مرات
```

---

## 15. دليل إضافة Feature جديدة

### الخطوة 1: إنشاء هيكل المجلدات

```bash
lib/features/my_feature/
├── domain/
│   └── models/
│       └── my_model.dart
├── data/
│   ├── my_repository.dart
│   └── my_controller.dart
└── presentation/
    ├── screens/
    │   └── my_screen.dart
    └── widgets/
        └── my_widget.dart
```

### الخطوة 2: إنشاء النموذج

```dart
// lib/features/my_feature/domain/models/my_model.dart

class MyModel {
  final String id;
  final String name;

  MyModel({required this.id, required this.name});

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
```

### الخطوة 3: إنشاء Repository

```dart
// lib/features/my_feature/data/my_repository.dart

class MyRepository {
  final ApiService _apiService;

  MyRepository(this._apiService);

  Future<List<MyModel>> getItems() async {
    final response = await _apiService.get('/secure/merchant/my-items');

    if (_apiService.isSuccessful(response)) {
      final data = _apiService.parseResponse(response);
      return (data['items'] as List)
          .map((json) => MyModel.fromJson(json))
          .toList();
    }
    return [];
  }
}

final myRepositoryProvider = Provider((ref) {
  return MyRepository(ref.read(apiServiceProvider));
});
```

### الخطوة 4: إنشاء Controller

```dart
// lib/features/my_feature/data/my_controller.dart

class MyState {
  final List<MyModel> items;
  final bool isLoading;
  final String? error;

  MyState({this.items = const [], this.isLoading = false, this.error});

  MyState copyWith({...});
}

class MyController extends Notifier<MyState> {
  late MyRepository _repository;

  @override
  MyState build() {
    _repository = ref.watch(myRepositoryProvider);
    _loadItems();
    return MyState(isLoading: true);
  }

  Future<void> _loadItems() async {
    try {
      final items = await _repository.getItems();
      state = MyState(items: items);
    } catch (e) {
      state = MyState(error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _loadItems();
  }
}

final myControllerProvider = NotifierProvider<MyController, MyState>(
  MyController.new,
);
```

### الخطوة 5: إنشاء الشاشة

```dart
// lib/features/my_feature/presentation/screens/my_screen.dart

class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text(state.error!));
    }

    return Scaffold(
      backgroundColor: AppTheme.background(isDark),
      appBar: AppBar(title: const Text('عنوان')),
      body: ListView.builder(
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final item = state.items[index];
          return ListTile(title: Text(item.name));
        },
      ),
    );
  }
}
```

### الخطوة 6: إضافة Route

```dart
// في lib/core/router/routes/dashboard_routes.dart

GoRoute(
  path: 'my-feature',
  name: 'my-feature',
  builder: (context, state) => const MyScreen(),
),
```

---

## الملفات المرجعية السريعة

| الغرض | الملف |
|-------|-------|
| نقطة البداية | `lib/main.dart` |
| الـ Shell الرئيسي | `lib/shared/app_shell.dart` |
| إعدادات API | `lib/core/config/api_config.dart` |
| خدمة API | `lib/core/services/api_service.dart` |
| المصادقة | `lib/features/auth/data/auth_repository.dart` |
| التوجيه | `lib/core/router/app_router.dart` |
| المظهر | `lib/core/theme/app_theme.dart` |
| النصوص | `lib/core/l10n/app_strings.dart` |
| الأبعاد | `lib/core/constants/app_dimensions.dart` |

---

## الأوامر المفيدة

```bash
# تشغيل التطبيق
flutter run

# بناء APK
flutter build apk --release

# تحليل الكود
flutter analyze

# توليد الكود (freezed, json_serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# تنظيف المشروع
flutter clean && flutter pub get
```

---

> **ملاحظة**: هذا الدليل يتم تحديثه مع كل تغيير جوهري في المشروع. تأكد من مراجعة آخر نسخة قبل البدء بالتطوير.
