# 🎨 هوية Mbuy البصرية - دليل التصميم

## 📋 نظرة عامة

تم تحديث تصميم واجهات UI/UX لتطبيق "Saleh / Mbuy" ليتطابق مع الهوية البصرية للشعار الجديد:

- **خلفية داكنة (Navy):** `#05081A`
- **جراديانت دائري:** من الأزرق `#00D2FF` إلى الموف `#FF00FF`
- **سلة مبتسمة (Smile Cart):** داخل الدائرة

---

## 📁 الملفات المعدّلة والجديدة

### 1. الثيم العام (Theme)

**الملف:** `lib/core/theme/app_theme.dart`

- يحتوي على جميع الألوان في مكان واحد (`MbuyColors`)
- `ThemeData` مخصص للهوية البصرية
- دعم RTL للعربية

**كيفية تغيير الألوان:**
```dart
// في MbuyColors داخل app_theme.dart:
static const Color primaryBlue = Color(0xFF00D2FF);    // الأزرق
static const Color primaryPurple = Color(0xFFFF00FF);  // الموف
static const Color darkNavy = Color(0xFF05081A);       // الخلفية
```

---

### 2. Widgets المخصصة

#### أ. الشعار الدائري (`MbuyLogo`)

**الملف:** `lib/shared/widgets/mbuy_logo.dart`

**الاستخدام:**
```dart
// نسخة كبيرة (للشاشات الكبيرة)
MbuyLogo.large()

// نسخة صغيرة (للاستخدام في AppBar)
MbuyLogo.small()

// حجم مخصص
MbuyLogo(size: 80)
```

**الميزات:**
- دائرة بحد جراديانت (من الأزرق إلى الموف)
- سلة مبتسمة داخل الدائرة (Icon مؤقت - يمكن استبداله بصورة)
- خلفية اختيارية (`showBackground`)

---

#### ب. Loader المخصص (`MbuyLoader`)

**الملف:** `lib/shared/widgets/mbuy_loader.dart`

**الاستخدام:**
```dart
// Loader قياسي
MbuyLoader()

// حجم مخصص
MbuyLoader(size: 80)
```

**الميزات:**
- دائرة جراديانت دوارة (الحد الخارجي)
- سلة مبتسمة ثابتة في المنتصف
- استخدامه بدلاً من `CircularProgressIndicator`

**أمثلة الاستخدام:**
```dart
if (_isLoading) {
  return const Center(child: MbuyLoader());
}
```

---

#### ج. الأزرار المخصصة

**الملف:** `lib/shared/widgets/mbuy_buttons.dart`

**1. MbuyPrimaryButton (زر أساسي مع جراديانت):**
```dart
MbuyPrimaryButton(
  text: 'إرسال',
  icon: Icons.send,
  onPressed: () {},
  isLoading: false,
)
```

**2. MbuySecondaryButton (زر ثانوي مع حدود):**
```dart
MbuySecondaryButton(
  text: 'إلغاء',
  icon: Icons.cancel,
  onPressed: () {},
)
```

**3. MbuyGhostButton (زر Ghost مع حافة جراديانت):**
```dart
MbuyGhostButton(
  text: 'مزيد من المعلومات',
  onPressed: () {},
)
```

---

#### د. حلقة الستوري (`StoryRing`)

**الملف:** `lib/shared/widgets/story_ring.dart`

**الاستخدام:**
```dart
StoryRing(
  hasStory: true,  // true إذا كان هناك ستوري
  ringWidth: 3.0,
  child: CircleAvatar(
    radius: 30,
    child: Icon(Icons.store),
  ),
)
```

**الميزات:**
- حلقة جراديانت حول Avatar (مثل Instagram)
- يظهر فقط إذا `hasStory = true`
- استخدامها حول صورة المتجر في `StoresScreen`

---

#### هـ. شاشة الترحيب (`WelcomeScreen`)

**الملف:** `lib/shared/widgets/welcome_screen.dart`

**الاستخدام:**
```dart
WelcomeScreen(
  onComplete: () {
    // الانتقال إلى التطبيق الرئيسي
  },
)
```

**الميزات:**
- خلفية كحلية داكنة
- الشعار الدائري الكبير في المنتصف
- نص ترحيبي: "مرحباً بك في Mbuy"

---

### 3. الشاشات المحدّثة

#### أ. ExploreScreen

**الملف:** `lib/features/customer/presentation/screens/explore_screen.dart`

**التحديثات:**
- Header جديد يحتوي على الشعار الدائري الصغير في الأعلى
- Tabs (Placeholder الآن): استكشف / الأصدقاء / الترند
- تصميم داكن أنيق مع Cards
- استخدام `MbuyLoader` للـ loading
- استخدام `MbuyPrimaryButton` و `MbuySecondaryButton`

---

#### ب. StoresScreen

**الملف:** `lib/features/customer/presentation/screens/stores_screen.dart`

**التحديثات:**
- حلقة الستوري (`StoryRing`) حول Avatar المتجر
- تصميم داكن متناسق
- Badges للمتاجر المدعومة مع جراديانت
- استخدام `MbuyLoader` للـ loading

**ملاحظة:** 
- `hasStory` حالياً placeholder (يجب إضافته من قاعدة البيانات لاحقاً)

---

#### ج. MerchantDashboardScreen

**الملف:** `lib/features/merchant/presentation/screens/merchant_dashboard_screen.dart`

**التحديثات:**
- Cards للمحفظة والنقاط في الأعلى
- تصميم داكن متناسق
- أماكن جاهزة للمحفظة والنقاط (UI فقط - TODO للربط)

**Cards المضافة:**
1. **Card "محفظتي":**
   - أيقونة محفظة مع جراديانت
   - رصيد (Placeholder: 0.00 ر.س)
   - TODO: ربطه بـ `WalletService`

2. **Card "نقاطي":**
   - أيقونة نقاط مع جراديانت
   - رصيد (Placeholder: 0 نقطة)
   - TODO: ربطه بـ `MerchantPointsService`

---

#### د. CustomerShell

**الملف:** `lib/features/customer/presentation/screens/customer_shell.dart`

**التحديثات:**
- أيقونة Explore المخصصة في `BottomNavigationBar`
- عندما يكون مختاراً: دائرة جراديانت
- عندما يكون غير مختار: دائرة outline عادية

---

#### هـ. main.dart

**الملف:** `lib/main.dart`

**التحديثات:**
- استخدام `AppTheme.darkTheme`
- تفعيل RTL للعربية
- إضافة `flutter_localizations`

---

## 🎨 الألوان المستخدمة

جميع الألوان موجودة في `lib/core/theme/app_theme.dart` داخل `MbuyColors`:

```dart
// الخلفية
static const Color darkNavy = Color(0xFF05081A);           // الخلفية الأساسية
static const Color surfaceDark = Color(0xFF0A0E1F);        // خلفية Cards
static const Color surfaceMedium = Color(0xFF121528);      // خلفية Cards ثانوية

// الألوان الأساسية
static const Color primaryBlue = Color(0xFF00D2FF);        // الأزرق
static const Color primaryPurple = Color(0xFFFF00FF);      // الموف

// النصوص
static const Color textPrimary = Color(0xFFFFFFFF);        // النص الأساسي
static const Color textSecondary = Color(0xFFB0B5C3);      // النص الثانوي

// الجراديانت
static const LinearGradient primaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [primaryBlue, primaryPurple],
);

static const SweepGradient circularGradient = SweepGradient(
  colors: [primaryBlue, primaryPurple, primaryBlue],
  stops: [0.0, 0.5, 1.0],
);
```

---

## 📝 TODO للمستقبل

### 1. استبدال Icon السلة بصورة حقيقية
- الحالي: Icon مؤقت (`Icons.shopping_cart`)
- المطلوب: استخدام `assets/images/mbuy_logo.png`
- الملفات: `mbuy_logo.dart`, `mbuy_loader.dart`

**التعديل:**
```dart
// بدلاً من:
child: const Icon(Icons.shopping_cart, ...)

// استخدم:
child: Image.asset(
  'assets/images/mbuy_logo.png',
  fit: BoxFit.contain,
)
```

**لا تنس إضافة الصورة في `pubspec.yaml`:**
```yaml
assets:
  - .env
  - images/mbuy_logo.png
```

---

### 2. إضافة حقل `has_story` في جدول `stores`
- حالياً `hasStory` هو placeholder
- يجب إضافته في قاعدة البيانات
- ثم تحديث `StoresScreen` لجلب القيمة الحقيقية

---

### 3. ربط Cards المحفظة والنقاط بالخدمات
- **المحفظة:** ربط بـ `WalletService.getWalletForCurrentUser()`
- **النقاط:** ربط بـ `MerchantPointsService.getMerchantPointsBalance()`

---

### 4. شاشة الترحيب
- حالياً تم إنشاؤها لكن غير مستخدمة
- يمكن إضافتها كـ Splash Screen قبل `RootWidget`

---

## 🚀 كيفية الاستخدام

### استدعاء الشعار:
```dart
// كبير (Splash/Welcome)
MbuyLogo.large()

// صغير (AppBar)
MbuyLogo.small()
```

### استدعاء Loader:
```dart
// قياسي
MbuyLoader()

// حجم مخصص
MbuyLoader(size: 100)
```

### استدعاء حلقة الستوري:
```dart
StoryRing(
  hasStory: true,
  child: CircleAvatar(...),
)
```

---

## ✅ التحقق من التطبيق

تم فحص الكود باستخدام `flutter analyze`:
- ✅ لا توجد أخطاء
- ✅ لا توجد تحذيرات
- ✅ الكود نظيف 100%

---

## 📌 ملاحظات مهمة

1. **لا تغيير في المنطق:** جميع التعديلات UI/UX فقط، لم يتم تغيير أي منطق متعلق بـ Supabase أو Auth
2. **RTL مفعّل:** التطبيق يدعم العربية بالكامل
3. **الألوان قابلة للتخصيص:** جميع الألوان في `MbuyColors` - يمكن تغييرها من مكان واحد
4. **الجراديانت ديناميكي:** يتم حساب الجراديانت تلقائياً من الألوان الأساسية

---

## 🎯 الهدف النهائي

أن يشعر أي مستخدم يرى الدائرة والسلة المبتسمة داخل التطبيق بأن هذه هي هوية Mbuy، وأن التطبيق متناسق تماماً مع شعار الأيقونة.

---

**تاريخ التحديث:** 2024
**الإصدار:** 1.0.0

