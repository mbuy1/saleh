# 🔧 استكشاف الأخطاء وإصلاحها - التطبيق لا يعمل على الهاتف

## المشاكل الشائعة والحلول

### 1. مشاكل الصلاحيات (Permissions)

#### Android - image_picker يحتاج صلاحيات:

أضف الصلاحيات التالية إلى `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- الصلاحيات المطلوبة -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    
    <!-- للـ Android 13+ -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    
    <application
        ...>
    </application>
</manifest>
```

### 2. مشاكل تهيئة Firebase

إذا كان Firebase غير مهيأ بشكل صحيح:
- تأكد من وجود `google-services.json` في `android/app/`
- تأكد من وجود `GoogleService-Info.plist` في `ios/Runner/`
- تأكد من تطبيق Google Services plugin في `build.gradle.kts`

**الحل:** الكود الحالي يتعامل مع فشل Firebase بشكل آمن (try-catch)، لكن تأكد من الملفات موجودة.

### 3. مشاكل تهيئة Cloudflare

إذا كانت متغيرات Cloudflare مفقودة:
- التطبيق سيستمر في العمل (try-catch)
- لكن رفع الصور لن يعمل

**الحل:** تأكد من وجود المتغيرات في `.env`:
```env
CLOUDFLARE_ACCOUNT_ID=...
CLOUDFLARE_IMAGES_TOKEN=...
CLOUDFLARE_IMAGES_BASE_URL=...
```

### 4. مشاكل في تهيئة Supabase

إذا فشل تحميل `.env`:
- التطبيق سيتوقف مع خطأ واضح

**الحل:** تأكد من:
- وجود ملف `.env` في جذر المشروع
- وجود `SUPABASE_URL` و `SUPABASE_ANON_KEY`
- إضافة `.env` إلى `pubspec.yaml` في قسم `assets`

### 5. مشاكل في Android Build

#### خطأ: "Google Services plugin not applied"
**الحل:** تأكد من:
- `android/build.gradle.kts` يحتوي على `classpath("com.google.gms:google-services:4.4.2")`
- `android/app/build.gradle.kts` يحتوي على `id("com.google.gms.google-services")`

#### خطأ: "minSdkVersion too low"
**الحل:** تأكد من `minSdk` مناسب (عادة 21+)

### 6. مشاكل في Runtime

#### التطبيق يتوقف عند الفتح:
1. تحقق من Logcat:
   ```bash
   flutter run --verbose
   ```
2. ابحث عن أخطاء مثل:
   - `Exception: SUPABASE_URL غير موجود`
   - `Exception: CLOUDFLARE_ACCOUNT_ID غير موجود`
   - `PlatformException` (للصلاحيات)

#### التطبيق يفتح لكن لا يعمل:
1. تحقق من Console logs
2. تأكد من اتصال الإنترنت
3. تأكد من صحة Supabase credentials

### 7. خطوات التشخيص

#### 1. تشغيل مع verbose:
```bash
flutter run --verbose
```

#### 2. فحص Logcat (Android):
```bash
adb logcat | grep -i flutter
```

#### 3. فحص الأخطاء في Console:
- ابحث عن `Exception` أو `Error`
- ابحث عن `Failed to load`

#### 4. اختبار بدون Cloudflare:
- احذف أو علّق تهيئة Cloudflare في `main.dart` مؤقتاً
- شغّل التطبيق لمعرفة إذا كانت المشكلة من Cloudflare

#### 5. اختبار بدون Firebase:
- احذف أو علّق تهيئة Firebase في `main.dart` مؤقتاً
- شغّل التطبيق لمعرفة إذا كانت المشكلة من Firebase

### 8. التحقق من الملفات المطلوبة

تأكد من وجود:
- ✅ `.env` في جذر المشروع
- ✅ `android/app/google-services.json`
- ✅ `ios/Runner/GoogleService-Info.plist` (إذا كنت تستخدم iOS)
- ✅ `pubspec.yaml` يحتوي على `.env` في `assets`

### 9. إعادة البناء الكامل

إذا استمرت المشاكل:

```bash
# تنظيف البناء
flutter clean

# حذف dependencies وإعادة التثبيت
rm -rf pubspec.lock
flutter pub get

# إعادة البناء
flutter build apk --debug
```

### 10. التحقق من الأجهزة المتصلة

```bash
# عرض الأجهزة المتصلة
flutter devices

# إذا لم يظهر الجهاز:
# - تأكد من تفعيل USB Debugging
# - تأكد من قبول الكمبيوتر في الهاتف
```

---

## 🆘 إذا استمرت المشكلة

1. **انسخ رسالة الخطأ الكاملة** من Console
2. **تحقق من Logcat** للأخطاء التفصيلية
3. **اختبر على emulator** أولاً للتأكد من أن المشكلة ليست في الجهاز
4. **اختبر بدون Cloudflare/Firebase** لعزل المشكلة

---

## ✅ قائمة التحقق السريعة

- [ ] الصلاحيات موجودة في AndroidManifest.xml
- [ ] ملف `.env` موجود ويحتوي على جميع المتغيرات
- [ ] `google-services.json` موجود
- [ ] `pubspec.yaml` يحتوي على `.env` في assets
- [ ] تم تشغيل `flutter pub get`
- [ ] الجهاز متصل و USB Debugging مفعّل
- [ ] التطبيق يبني بدون أخطاء (`flutter build apk`)

