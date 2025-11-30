# 🔥 إعداد Firebase - Saleh App

## ✅ ما تم إنجازه

### 1. إضافة Dependencies
- ✅ `firebase_analytics: ^11.0.0`
- ✅ `firebase_messaging: ^15.0.0`
- ✅ `firebase_core: ^3.0.0` (كان موجوداً مسبقاً)

### 2. تهيئة Firebase
- ✅ تهيئة Firebase في `main.dart`
- ✅ إعداد FCM (Firebase Cloud Messaging)
- ✅ معالجة الأخطاء بشكل آمن (لا يتوقف التطبيق إذا فشل Firebase)

### 3. إنشاء FirebaseService
**الملف:** `lib/core/firebase_service.dart`

**الوظائف:**
- ✅ `logScreenView()` - تتبع عرض الشاشات
- ✅ `logEvent()` - تتبع الأحداث العامة
- ✅ `logViewProduct()` - تتبع عرض منتج
- ✅ `logAddToCart()` - تتبع إضافة منتج للسلة
- ✅ `logRemoveFromCart()` - تتبع حذف منتج من السلة
- ✅ `logViewStore()` - تتبع عرض متجر
- ✅ `logPlaceOrder()` - تتبع إتمام طلب
- ✅ `logSearch()` - تتبع البحث
- ✅ `logFilter()` - تتبع استخدام الفلاتر
- ✅ `setupFCM()` - إعداد FCM وحفظ device tokens

### 4. تتبع الأحداث في الشاشات
- ✅ `RootWidget` - تتبع شاشات Auth, Customer Shell, Merchant Dashboard
- ✅ `HomeScreen` - تتبع عرض الشاشة + إضافة للسلة
- ✅ `CartScreen` - تتبع عرض الشاشة + حذف من السلة + إتمام الطلب
- ✅ `ExploreScreen` - تتبع عرض الشاشة
- ✅ `StoresScreen` - تتبع عرض الشاشة + عرض متجر

### 5. تحديث Android Build
- ✅ إضافة Google Services plugin في `android/app/build.gradle.kts`
- ✅ إضافة classpath في `android/build.gradle.kts`

### 6. ملفات Firebase
- ✅ `android/app/google-services.json` موجود
- ✅ `ios/Runner/googleservice-info.plist` موجود

---

## 📊 الأحداث المتتبعة

### الشاشات (Screen Views):
- `auth_screen`
- `customer_shell`
- `merchant_dashboard`
- `home_screen`
- `cart_screen`
- `explore_screen`
- `stores_screen`

### الأحداث (Events):
- `view_product` - عرض منتج
- `add_to_cart` - إضافة منتج للسلة
- `remove_from_cart` - حذف منتج من السلة
- `view_store` - عرض متجر
- `place_order` - إتمام طلب
- `search` - البحث
- `filter` - استخدام فلتر

---

## ⚠️ TODO (لاحقاً)

### 1. حفظ Device Tokens في Supabase
**الملف:** `lib/core/firebase_service.dart` - دالة `_saveDeviceToken()`

**المطلوب:**
- إنشاء جدول `device_tokens` في Supabase:
  ```sql
  CREATE TABLE device_tokens (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    token text NOT NULL,
    platform text NOT NULL, -- 'android' أو 'ios'
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(user_id, token)
  );
  ```
- إلغاء التعليق في `_saveDeviceToken()` وإضافة:
  ```dart
  await supabaseClient.from('device_tokens').upsert({
    'user_id': user.id,
    'token': token,
    'platform': Platform.isAndroid ? 'android' : 'ios',
    'updated_at': DateTime.now().toIso8601String(),
  });
  ```

### 2. معالجة الإشعارات في المقدمة (Foreground)
**الملف:** `lib/core/firebase_service.dart` - دالة `_handleForegroundMessage()`

**المطلوب:**
- إضافة `flutter_local_notifications` package
- عرض إشعار محلي عند استلام إشعار في المقدمة

### 3. التنقل عند الضغط على الإشعار
**الملف:** `lib/core/firebase_service.dart` - دالة `_handleMessageOpened()`

**المطلوب:**
- استخدام Navigator أو Router للتنقل إلى الشاشة المناسبة حسب `data` في الإشعار

### 4. إعداد iOS (Podfile)
**الملف:** `ios/Podfile`

**المطلوب:**
- التأكد من إضافة Firebase pods (عادة يتم تلقائياً عند `flutter pub get`)

---

## 🚀 كيفية الاستخدام

### تتبع عرض شاشة:
```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  FirebaseService.logScreenView('screen_name');
});
```

### تتبع حدث:
```dart
FirebaseService.logEvent(
  name: 'event_name',
  parameters: {
    'key1': 'value1',
    'key2': 123,
  },
);
```

### تتبع إضافة منتج للسلة:
```dart
FirebaseService.logAddToCart(
  productId: 'product_id',
  productName: 'Product Name',
  price: 99.99,
  quantity: 1,
);
```

---

## 📝 ملاحظات

1. **معالجة الأخطاء:** جميع دوال FirebaseService تستخدم try-catch لتجاهل الأخطاء، حتى لا يتوقف التطبيق إذا فشل Firebase.

2. **Device Tokens:** حالياً يتم جلب token لكن لا يتم حفظه في Supabase (TODO). يجب إضافة جدول `device_tokens` أولاً.

3. **الإشعارات:** FCM جاهز لكن يحتاج إلى:
   - إعداد backend لإرسال الإشعارات
   - معالجة الإشعارات في المقدمة (Foreground)
   - التنقل عند الضغط على الإشعار

4. **Android Build:** تم تحديث build.gradle.kts. قد تحتاج إلى:
   ```bash
   cd android
   ./gradlew clean
   ```

---

## ✅ الحالة الحالية

- ✅ Firebase Analytics: **مفعّل**
- ✅ Firebase Cloud Messaging: **مفعّل (جاهز)**
- ✅ تتبع الأحداث: **مفعّل في الشاشات الرئيسية**
- ⚠️ حفظ Device Tokens: **TODO**
- ⚠️ معالجة الإشعارات: **TODO**

---

**آخر تحديث:** 2024

