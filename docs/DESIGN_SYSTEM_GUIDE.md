# 📐 دليل نظام التصميم - Mbuy Design System

> هذا الدليل يوضح جميع ثوابت التصميم المتاحة في التطبيق وكيفية استخدامها بشكل صحيح.

## 📁 الملفات الرئيسية

| الملف | الوصف |
|-------|-------|
| `lib/core/constants/app_dimensions.dart` | المسافات والأبعاد والأحجام |
| `lib/core/theme/app_theme.dart` | الألوان والتدرجات وأنماط النص |
| `lib/shared/widgets/base_screen.dart` | غلاف موحد للشاشات |

---

## 📏 المسافات (Spacing)

نظام الشبكة 8 نقاط (8pt Grid System) المعتمد من Material Design.

### الثوابت الأساسية

| الثابت | القيمة | الاستخدام |
|--------|--------|----------|
| `AppDimensions.spacing2` | 2.0 | فراغات صغيرة جداً |
| `AppDimensions.spacing4` | 4.0 | فراغات صغيرة |
| `AppDimensions.spacing6` | 6.0 | فراغات صغيرة |
| `AppDimensions.spacing8` | 8.0 | فراغات أساسية |
| `AppDimensions.spacing10` | 10.0 | فراغات متوسطة صغيرة |
| `AppDimensions.spacing12` | 12.0 | فراغات متوسطة |
| `AppDimensions.spacing14` | 14.0 | فراغات متوسطة |
| `AppDimensions.spacing16` | 16.0 | فراغات قياسية |
| `AppDimensions.spacing20` | 20.0 | فراغات كبيرة |
| `AppDimensions.spacing24` | 24.0 | فراغات كبيرة |
| `AppDimensions.spacing32` | 32.0 | فراغات كبيرة جداً |
| `AppDimensions.spacing40` | 40.0 | فراغات ضخمة |
| `AppDimensions.spacing48` | 48.0 | فراغات ضخمة |
| `AppDimensions.spacing56` | 56.0 | فراغات ضخمة |
| `AppDimensions.spacing64` | 64.0 | فراغات ضخمة |

### مثال الاستخدام

```dart
// ❌ خطأ - قيمة مكتوبة يدوياً
SizedBox(height: 16)

// ✅ صحيح - استخدام الثابت
SizedBox(height: AppDimensions.spacing16)
```

---

## 📦 الحشو (Padding)

### حشو من جميع الجهات

| الثابت | القيمة | الاستخدام |
|--------|--------|----------|
| `AppDimensions.paddingXS` | 8px | عناصر مضغوطة صغيرة |
| `AppDimensions.paddingS` | 12px | البطاقات وعناصر القائمة |
| `AppDimensions.paddingM` | 16px | حشو الشاشات والأقسام القياسي |
| `AppDimensions.paddingL` | 20px | أقسام بارزة |
| `AppDimensions.paddingXL` | 24px | أقسام كبيرة ونوافذ الحوار |
| `AppDimensions.paddingXXL` | 32px | أقسام البطل والحالات الفارغة |

### حشو أفقي فقط

| الثابت | القيمة |
|--------|--------|
| `AppDimensions.paddingHorizontalXS` | 8px أفقي |
| `AppDimensions.paddingHorizontalS` | 12px أفقي |
| `AppDimensions.paddingHorizontalM` | 16px أفقي |
| `AppDimensions.paddingHorizontalL` | 20px أفقي |
| `AppDimensions.paddingHorizontalXL` | 24px أفقي |

### حشو عمودي فقط

| الثابت | القيمة |
|--------|--------|
| `AppDimensions.paddingVerticalXS` | 8px عمودي |
| `AppDimensions.paddingVerticalS` | 12px عمودي |
| `AppDimensions.paddingVerticalM` | 16px عمودي |
| `AppDimensions.paddingVerticalL` | 20px عمودي |
| `AppDimensions.paddingVerticalXL` | 24px عمودي |

### مثال الاستخدام

```dart
// ❌ خطأ
padding: const EdgeInsets.all(16)

// ✅ صحيح
padding: AppDimensions.paddingM

// ❌ خطأ
padding: const EdgeInsets.symmetric(horizontal: 16)

// ✅ صحيح
padding: AppDimensions.paddingHorizontalM
```

---

## 🔲 نصف قطر الحدود (Border Radius)

### القيم الرقمية

| الثابت | القيمة | الاستخدام |
|--------|--------|----------|
| `AppDimensions.radiusXS` | 4.0 | زوايا دقيقة |
| `AppDimensions.radiusS` | 8.0 | زوايا صغيرة |
| `AppDimensions.radiusM` | 12.0 | زوايا متوسطة |
| `AppDimensions.radiusL` | 16.0 | زوايا كبيرة |
| `AppDimensions.radiusXL` | 20.0 | زوايا كبيرة جداً |
| `AppDimensions.radiusXXL` | 24.0 | زوايا ضخمة |
| `AppDimensions.radiusCircle` | 100.0 | دائرة كاملة |

### كائنات BorderRadius الجاهزة

| الثابت | القيمة |
|--------|--------|
| `AppDimensions.borderRadiusXS` | BorderRadius.circular(4) |
| `AppDimensions.borderRadiusS` | BorderRadius.circular(8) |
| `AppDimensions.borderRadiusM` | BorderRadius.circular(12) |
| `AppDimensions.borderRadiusL` | BorderRadius.circular(16) |
| `AppDimensions.borderRadiusXL` | BorderRadius.circular(20) |
| `AppDimensions.borderRadiusXXL` | BorderRadius.circular(24) |

### مثال الاستخدام

```dart
// ❌ خطأ
borderRadius: BorderRadius.circular(12)

// ✅ صحيح
borderRadius: AppDimensions.borderRadiusM
```

---

## 🔣 أحجام الأيقونات (Icon Sizes)

| الثابت | القيمة | الاستخدام |
|--------|--------|----------|
| `AppDimensions.iconXS` | 16.0 | أيقونات صغيرة جداً |
| `AppDimensions.iconS` | 20.0 | أيقونات صغيرة |
| `AppDimensions.iconM` | 24.0 | حجم الأيقونة الافتراضي (Material) |
| `AppDimensions.iconL` | 28.0 | أيقونات كبيرة |
| `AppDimensions.iconXL` | 32.0 | أيقونات كبيرة جداً |
| `AppDimensions.iconXXL` | 40.0 | أيقونات ضخمة |
| `AppDimensions.iconHero` | 48.0 | أيقونات البطل |
| `AppDimensions.iconDisplay` | 64.0 | أيقونات العرض |

### مثال الاستخدام

```dart
// ❌ خطأ
Icon(Icons.home, size: 24)

// ✅ صحيح
Icon(Icons.home, size: AppDimensions.iconM)
```

---

## 🔤 أحجام الخطوط (Font Sizes)

| الثابت | القيمة | الاستخدام |
|--------|--------|----------|
| `AppDimensions.fontCaption` | 11.0 | نص توضيحي صغير |
| `AppDimensions.fontLabel` | 12.0 | التسميات |
| `AppDimensions.fontBody2` | 13.0 | نص الجسم الثانوي |
| `AppDimensions.fontBody` | 14.0 | نص الجسم الرئيسي |
| `AppDimensions.fontSubtitle` | 15.0 | العناوين الفرعية |
| `AppDimensions.fontTitle` | 16.0 | العناوين |
| `AppDimensions.fontHeadline` | 18.0 | العناوين الرئيسية |
| `AppDimensions.fontDisplay3` | 20.0 | عرض صغير |
| `AppDimensions.fontDisplay2` | 24.0 | عرض متوسط |
| `AppDimensions.fontDisplay1` | 28.0 | عرض كبير |
| `AppDimensions.fontHero` | 32.0 | نص البطل |

### العناوين الهرمية

| الثابت | القيمة |
|--------|--------|
| `AppDimensions.fontH1` | 32.0 |
| `AppDimensions.fontH2` | 24.0 |
| `AppDimensions.fontH3` | 20.0 |
| `AppDimensions.fontH4` | 18.0 |

### مثال الاستخدام

```dart
// ❌ خطأ
TextStyle(fontSize: 16)

// ✅ صحيح
TextStyle(fontSize: AppDimensions.fontTitle)
```

---

## 🎛️ ارتفاعات الأزرار (Button Heights)

| الثابت | القيمة | الاستخدام |
|--------|--------|----------|
| `AppDimensions.buttonHeightS` | 36.0 | أزرار صغيرة |
| `AppDimensions.buttonHeightM` | 44.0 | أزرار متوسطة |
| `AppDimensions.buttonHeightL` | 48.0 | الحد الأدنى الموصى به للوصول |
| `AppDimensions.buttonHeightXL` | 56.0 | أزرار كبيرة |

---

## 📝 ارتفاعات حقول الإدخال (Input Heights)

| الثابت | القيمة |
|--------|--------|
| `AppDimensions.inputHeightS` | 40.0 |
| `AppDimensions.inputHeightM` | 48.0 |
| `AppDimensions.inputHeightL` | 56.0 |

---

## 🃏 البطاقات (Cards)

### الظل (Elevation)

| الثابت | القيمة | الاستخدام |
|--------|--------|----------|
| `AppDimensions.cardElevationLow` | 1.0 | ظل خفيف |
| `AppDimensions.cardElevationMedium` | 2.0 | ظل متوسط |
| `AppDimensions.cardElevationHigh` | 4.0 | ظل قوي |

---

## 👤 أحجام الصور الرمزية (Avatar Sizes)

| الثابت | القيمة | الاستخدام |
|--------|--------|----------|
| `AppDimensions.avatarXS` | 24.0 | صغير جداً |
| `AppDimensions.avatarS` | 32.0 | صغير |
| `AppDimensions.avatarM` | 40.0 | متوسط |
| `AppDimensions.avatarL` | 48.0 | كبير |
| `AppDimensions.avatarXL` | 56.0 | كبير جداً |
| `AppDimensions.avatarXXL` | 72.0 | ضخم |
| `AppDimensions.avatarProfile` | 96.0 | صورة الملف الشخصي |

---

## 🖼️ أحجام الصور المصغرة (Thumbnail Sizes)

| الثابت | القيمة |
|--------|--------|
| `AppDimensions.thumbnailS` | 48.0 |
| `AppDimensions.thumbnailM` | 64.0 |
| `AppDimensions.thumbnailL` | 80.0 |
| `AppDimensions.thumbnailXL` | 100.0 |

---

## 📱 الشبكة (Grid)

| الثابت | القيمة | الاستخدام |
|--------|--------|----------|
| `AppDimensions.gridCrossAxisCount2` | 2 | شبكة عمودين |
| `AppDimensions.gridCrossAxisCount3` | 3 | شبكة 3 أعمدة |
| `AppDimensions.gridSpacing` | 12.0 | المسافة بين عناصر الشبكة |
| `AppDimensions.gridChildAspectRatioProduct` | 0.65 | نسبة بطاقات المنتجات |
| `AppDimensions.gridChildAspectRatioSquare` | 1.0 | نسبة مربعة |
| `AppDimensions.gridChildAspectRatioWide` | 1.5 | نسبة عريضة |

---

## 📏 ارتفاعات عناصر القائمة (List Item Heights)

| الثابت | القيمة |
|--------|--------|
| `AppDimensions.listItemHeightS` | 48.0 |
| `AppDimensions.listItemHeightM` | 56.0 |
| `AppDimensions.listItemHeightL` | 72.0 |
| `AppDimensions.listItemHeightXL` | 88.0 |

---

## 📐 أبعاد التنقل (Navigation)

| الثابت | القيمة | الاستخدام |
|--------|--------|----------|
| `AppDimensions.appBarHeight` | 56.0 | ارتفاع شريط التطبيق |
| `AppDimensions.appBarHeightLarge` | 64.0 | ارتفاع شريط التطبيق الكبير |
| `AppDimensions.bottomNavHeight` | 80.0 | ارتفاع شريط التنقل السفلي |
| `AppDimensions.tabBarHeight` | 48.0 | ارتفاع شريط التبويب |

---

## 📏 نقاط التوقف (Breakpoints)

| الثابت | القيمة | الاستخدام |
|--------|--------|----------|
| `AppDimensions.breakpointMobile` | 600.0 | نقطة توقف الجوال |
| `AppDimensions.breakpointTablet` | 900.0 | نقطة توقف التابلت |
| `AppDimensions.breakpointDesktop` | 1200.0 | نقطة توقف سطح المكتب |

---

## 🔧 الدوال المساعدة (Helper Methods)

### الحشو المتجاوب

```dart
// يُرجع حشو مناسب حسب عرض الشاشة
EdgeInsets padding = AppDimensions.responsivePadding(context);
```

### عدد أعمدة الشبكة المتجاوب

```dart
// يُرجع عدد الأعمدة المناسب حسب عرض الشاشة
int columns = AppDimensions.responsiveGridCount(context);
```

### فحص نوع الجهاز

```dart
if (AppDimensions.isMobile(context)) {
  // كود للجوال
}

if (AppDimensions.isTablet(context)) {
  // كود للتابلت
}

if (AppDimensions.isDesktop(context)) {
  // كود لسطح المكتب
}
```

---

## ⏱️ مدد الحركة (Animation Durations)

| الثابت | القيمة | الاستخدام |
|--------|--------|----------|
| `AppDimensions.animationFast` | 150ms | حركات سريعة |
| `AppDimensions.animationNormal` | 300ms | حركات عادية |
| `AppDimensions.animationSlow` | 500ms | حركات بطيئة |

---

## 🎨 الألوان (Colors) - من AppTheme

### الألوان الرئيسية

| الثابت | اللون | الاستخدام |
|--------|-------|----------|
| `AppTheme.primaryColor` | أزرق داكن | اللون الرئيسي |
| `AppTheme.accentColor` | أخضر | لون التمييز |
| `AppTheme.backgroundColor` | رمادي فاتح | خلفية الشاشات |
| `AppTheme.cardColor` | أبيض | خلفية البطاقات |
| `AppTheme.borderColor` | رمادي | حدود العناصر |

### ألوان النص

| الثابت | الاستخدام |
|--------|----------|
| `AppTheme.darkSlate` | نص داكن للعناوين |
| `AppTheme.mutedSlate` | نص خافت للتفاصيل |

### التدرجات

| الثابت | الاستخدام |
|--------|----------|
| `AppTheme.primaryGradient` | تدرج رئيسي |
| `AppTheme.cardGradient` | تدرج البطاقات |

---

## 🛡️ SafeArea - المنطقة الآمنة

### استخدام BaseScreen

```dart
return BaseScreen(
  title: 'عنوان الشاشة',
  useSafeArea: true,      // تفعيل المنطقة الآمنة
  safeAreaTop: true,      // حماية من الأعلى
  safeAreaBottom: true,   // حماية من الأسفل
  body: YourWidget(),
);
```

### استخدام SafeArea مباشرة

```dart
return SafeArea(
  top: true,
  bottom: true,
  child: YourWidget(),
);
```

### حساب المسافة السفلية يدوياً

```dart
final bottomPadding = MediaQuery.of(context).padding.bottom;
```

---

## 📋 قواعد الاستخدام

### ✅ افعل

1. استخدم ثوابت `AppDimensions` دائماً بدلاً من الأرقام
2. استخدم `SafeArea` في كل الشاشات
3. استخدم `BaseScreen` للشاشات الفرعية
4. استورد الثوابت من `exports.dart`

### ❌ لا تفعل

1. لا تكتب قيم رقمية مباشرة مثل `16.0`
2. لا تنسى `SafeArea` خاصة في الأسفل
3. لا تكرر تعريف الثوابت في ملفات مختلفة
4. لا تستخدم `const EdgeInsets.all(16)` - استخدم `AppDimensions.paddingM`

---

## 📝 جدول التحويل السريع

| الكود القديم | الكود الجديد |
|-------------|--------------|
| `EdgeInsets.all(8)` | `AppDimensions.paddingXS` |
| `EdgeInsets.all(12)` | `AppDimensions.paddingS` |
| `EdgeInsets.all(16)` | `AppDimensions.paddingM` |
| `EdgeInsets.all(20)` | `AppDimensions.paddingL` |
| `EdgeInsets.all(24)` | `AppDimensions.paddingXL` |
| `EdgeInsets.all(32)` | `AppDimensions.paddingXXL` |
| `BorderRadius.circular(8)` | `AppDimensions.borderRadiusS` |
| `BorderRadius.circular(12)` | `AppDimensions.borderRadiusM` |
| `BorderRadius.circular(16)` | `AppDimensions.borderRadiusL` |
| `BorderRadius.circular(20)` | `AppDimensions.borderRadiusXL` |
| `SizedBox(height: 16)` | `SizedBox(height: AppDimensions.spacing16)` |
| `SizedBox(width: 12)` | `SizedBox(width: AppDimensions.spacing12)` |
| `Icon(icon, size: 24)` | `Icon(icon, size: AppDimensions.iconM)` |
| `fontSize: 16` | `fontSize: AppDimensions.fontTitle` |

---

## 📅 سجل التحديثات

| التاريخ | التغيير |
|--------|---------|
| 16 ديسمبر 2025 | إنشاء الدليل |
| 16 ديسمبر 2025 | إضافة ثوابت الحشو الموحدة |
| 16 ديسمبر 2025 | تحديث BaseScreen مع خيارات SafeArea |

---

> 💡 **نصيحة**: استخدم البحث والاستبدال في VS Code للعثور على القيم المكتوبة يدوياً واستبدالها بالثوابت.
>
> مثال البحث: `EdgeInsets\.all\(16\)` (مع تفعيل Regex)
