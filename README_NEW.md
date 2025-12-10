# MBUY Merchant - Clean Architecture ✨

## 📋 نظرة عامة

تم إعادة بناء المشروع بالكامل من الصفر باستخدام Clean Architecture ويعتمد **فقط** على Cloudflare Worker كـ Backend API. 

**لا يوجد أي تكامل مباشر مع Supabase في كود Flutter** - جميع العمليات تتم عبر Worker.

## 🏗️ الهيكل الجديد

```
lib/
├── main.dart                          # نقطة الدخول
├── core/                              # البنية التحتية الأساسية
│   ├── app_config.dart               # إعدادات التطبيق والـ Constants
│   ├── services/
│   │   └── api_service.dart          # HTTP Client للتواصل مع Worker
│   ├── router/
│   │   └── app_router.dart           # التنقل (go_router)
│   └── theme/
│       └── app_theme.dart            # الثيم والألوان
│
├── features/                          # الميزات (Feature-based)
│   ├── auth/                         # المصادقة
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   └── presentation/
│   │       └── screens/
│   │           └── login_screen.dart
│   │
│   ├── dashboard/                    # لوحة التحكم
│   │   └── presentation/
│   │       └── screens/
│   │           └── dashboard_screen.dart
│   │
│   ├── merchant/                     # ميزات التاجر
│   │   ├── data/
│   │   │   └── merchant_repository.dart
│   │   └── presentation/
│   │       └── screens/
│   │           ├── merchant_home_screen.dart
│   │           ├── merchant_products_screen.dart
│   │           └── merchant_orders_screen.dart
│   │
│   └── common/                       # مكونات مشتركة
│       └── widgets/
│           ├── primary_button.dart
│           └── loading_indicator.dart
```

## 🔧 التقنيات المستخدمة

### State Management
- **Riverpod** - لإدارة الحالة بشكل reactive

### Navigation
- **go_router** - للتنقل التصريحي Declarative

### HTTP Client
- **http** - لجميع طلبات API إلى Worker

### Storage
- **flutter_secure_storage** - لتخزين التوكنات بشكل آمن
- **shared_preferences** - لإعدادات التطبيق

### UI
- **google_fonts** - خط Cairo للعربية
- **cached_network_image** - عرض الصور بكفاءة

## 📦 التبعيات (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # HTTP Client
  http: ^1.2.0
  
  # State Management
  flutter_riverpod: ^2.4.10
  riverpod_annotation: ^2.3.3
  
  # Navigation
  go_router: ^14.0.2
  
  # Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.2
  
  # Firebase (Analytics & Messaging only)
  firebase_core: ^4.2.1
  firebase_analytics: ^12.0.4
  firebase_messaging: ^16.0.4
  
  # UI
  google_fonts: ^6.1.0
  cached_network_image: ^3.3.1
  image_picker: ^1.0.7
  
  # Utilities
  intl: ^0.19.0
  uuid: ^4.3.3
```

## 🔌 التكامل مع Cloudflare Worker

### 1. تعديل رابط Worker

في `lib/core/app_config.dart`:

```dart
static const String apiBaseUrl = 'https://YOUR_WORKER_URL.workers.dev';
```

حالياً مضبوط على:
```dart
static const String apiBaseUrl = 'https://misty-mode-b68b.baharista1.workers.dev';
```

### 2. كيفية عمل API Service

```dart
// مثال على استخدام ApiService
final apiService = ApiService();

// GET Request
final response = await apiService.get('/secure/merchant/store');

// POST Request
final response = await apiService.post(
  '/auth/login',
  body: {
    'email': 'user@example.com',
    'password': 'password123',
  },
);
```

### 3. المصادقة التلقائية

- يتم إضافة `Authorization: Bearer {token}` تلقائياً لجميع الطلبات
- Auto-refresh للتوكن عند انتهاء الصلاحية (401)
- Retry logic للطلبات الفاشلة

## 🚀 التشغيل

```bash
# 1. تثبيت التبعيات
flutter pub get

# 2. التحقق من عدم وجود أخطاء
flutter analyze

# 3. تشغيل التطبيق
flutter run
```

## 🧪 للتجربة

### بيانات تسجيل الدخول التجريبية:

```
البريد الإلكتروني: baharista1@gmail.com
كلمة المرور: أي كلمة مرور (6 أحرف أو أكثر)
```

## ✅ ما تم إزالته

- ✅ `supabase_flutter` - لم يعد موجود
- ✅ `provider` - استبدل بـ Riverpod
- ✅ `flutter_dotenv` - غير مطلوب
- ✅ `flutter_localizations` - غير مطلوب حالياً
- ✅ `flutter_map` / `latlong2` - غير مطلوب حالياً
- ✅ `fl_chart` - غير مطلوب حالياً
- ✅ `carousel_slider` - غير مطلوب حالياً

## 📝 ملاحظات مهمة

### 1. المجلد القديم
- تم نسخ المجلد القديم `lib` إلى `lib_backup`
- يمكن حذف `lib_backup` بعد التأكد من عمل كل شيء

### 2. Firebase
- تم الإبقاء على Firebase فقط لـ:
  - **Analytics** - تتبع الأحداث
  - **Messaging** - إشعارات Push
- لا يوجد استخدام لـ Firebase Auth

### 3. الملفات المحفوظة
- **android/** - لم يتم المساس به
- **ios/** - لم يتم المساس به
- **web/** - لم يتم المساس به

## 🔮 الخطوات التالية

### 1. ربط الشاشات بـ Worker APIs

في `AuthRepository`:
```dart
// تأكد من أن Worker يدعم هذه الـ Endpoints:
POST /auth/login
POST /auth/refresh
POST /auth/logout
GET  /auth/me
```

في `MerchantRepository`:
```dart
// تأكد من أن Worker يدعم:
GET  /secure/merchant/store
POST /secure/merchant/store
GET  /secure/merchant/products
POST /secure/merchant/products
GET  /secure/merchant/orders
```

### 2. إضافة ميزات جديدة

```bash
# مثال: إضافة ميزة "إضافة منتج"
lib/features/merchant/presentation/screens/add_product_screen.dart
```

### 3. State Management مع Riverpod

```dart
// إنشاء Provider
final storeProvider = FutureProvider<Store?>((ref) async {
  final merchantRepo = MerchantRepository();
  return await merchantRepo.getStore();
});

// استخدام Provider في Widget
@override
Widget build(BuildContext context, WidgetRef ref) {
  final storeAsync = ref.watch(storeProvider);
  
  return storeAsync.when(
    data: (store) => Text(store?.name ?? 'لا يوجد متجر'),
    loading: () => CircularProgressIndicator(),
    error: (err, stack) => Text('خطأ: $err'),
  );
}
```

## 📞 الدعم

في حال وجود أي مشاكل:
1. تحقق من logs في Flutter: `flutter run --verbose`
2. تحقق من Worker logs في Cloudflare Dashboard
3. تأكد أن رابط Worker صحيح في `app_config.dart`

---

**✨ مشروع نظيف - معمارية واضحة - سهل الصيانة ✨**
