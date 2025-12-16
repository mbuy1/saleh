# 🔮 دليل البطاقة الزجاجية (Glass Card)

## نظرة عامة

البطاقة الزجاجية هي مكون تصميم موحد يوفر تأثير **Glassmorphism** الحديث مع:
- خلفية شفافة مع تأثير ضبابية (Blur)
- حدود خفيفة لامعة
- أيقونات ثلاثية الأبعاد (3D)
- ظلال ناعمة

---

## 📦 الاستيراد

```dart
import 'package:saleh/shared/widgets/exports.dart';
// أو مباشرة
import 'package:saleh/shared/widgets/glass_card.dart';
```

---

## 🎯 أنواع البطاقات

### 1. البطاقة الزجاجية الأساسية

```dart
GlassCard(
  child: Text('المحتوى'),
  padding: AppDimensions.paddingM,
  borderRadius: GlassCardStyle.radiusMedium,
  blurAmount: GlassCardStyle.blurMedium,
  onTap: () => print('تم الضغط'),
)
```

### 2. البطاقة مع أيقونة 3D

```dart
GlassCard.withIcon(
  icon: Icons.star,
  iconBackgroundColor: Colors.amber,
  iconSize: 28,
  child: Column(
    children: [
      Text('العنوان'),
      Text('الوصف'),
    ],
  ),
  onTap: () => print('تم الضغط'),
)
```

### 3. بطاقة الإحصائيات

```dart
GlassStatCard(
  title: 'المبيعات',
  value: '1,234',
  icon: Icons.shopping_cart,
  iconColor: Colors.blue,
  onTap: () {},
)
```

### 4. بطاقة السعر

```dart
GlassPriceCard(
  price: '189',
  oldPrice: '239',
  label: 'خصم 20%',
  subtitle: 'شهرياً',
  accentColor: Colors.cyan,
)
```

---

## 🎨 ثوابت التصميم (GlassCardStyle)

### الألوان

| الثابت | الوصف | القيمة |
|--------|-------|--------|
| `backgroundColor` | لون الخلفية الأساسي | `white.withOpacity(0.12)` |
| `backgroundColorDark` | لون الخلفية الداكن | `black.withOpacity(0.25)` |
| `borderColor` | لون الحدود | `white.withOpacity(0.2)` |
| `innerGlowColor` | لون التوهج الداخلي | `white.withOpacity(0.05)` |

### الضبابية (Blur)

| الثابت | الوصف | القيمة |
|--------|-------|--------|
| `blurLight` | ضبابية خفيفة | `10.0` |
| `blurMedium` | ضبابية متوسطة | `15.0` |
| `blurHeavy` | ضبابية قوية | `25.0` |

### نصف قطر الحواف

| الثابت | الوصف | القيمة |
|--------|-------|--------|
| `radiusSmall` | صغير | `12.0` |
| `radiusMedium` | متوسط | `16.0` |
| `radiusLarge` | كبير | `20.0` |
| `radiusXLarge` | كبير جداً | `24.0` |

### الظلال

| الثابت | الوصف |
|--------|-------|
| `shadowLight` | ظل خفيف للبطاقات العادية |
| `shadowMedium` | ظل متوسط للبطاقات المرتفعة |
| `icon3DShadow` | ظل خاص للأيقونات ثلاثية الأبعاد |

### التدرجات

| الثابت | الوصف |
|--------|-------|
| `glassGradient` | تدرج الزجاج الأساسي |
| `glassGradientDark` | تدرج الزجاج للوضع الداكن |
| `icon3DGradient(color)` | تدرج الأيقونة ثلاثية الأبعاد |

---

## 🔧 الأيقونة ثلاثية الأبعاد (Icon3D)

```dart
Icon3D(
  icon: Icons.star,
  color: Colors.white,           // لون الأيقونة
  backgroundColor: Colors.blue,   // لون الخلفية
  size: 28,                       // حجم الأيقونة
  containerSize: 56,              // حجم الحاوية
)
```

---

## 📋 خصائص GlassCard

| الخاصية | النوع | الافتراضي | الوصف |
|---------|-------|-----------|-------|
| `child` | `Widget` | **مطلوب** | المحتوى الداخلي |
| `padding` | `EdgeInsetsGeometry?` | `paddingM` | الحشو الداخلي |
| `margin` | `EdgeInsetsGeometry?` | `null` | الهامش الخارجي |
| `borderRadius` | `double` | `16.0` | نصف قطر الحواف |
| `blurAmount` | `double` | `15.0` | قوة الضبابية |
| `backgroundColor` | `Color?` | `null` | لون الخلفية المخصص |
| `borderColor` | `Color?` | `null` | لون الحدود المخصص |
| `borderWidth` | `double` | `1.0` | عرض الحدود |
| `shadows` | `List<BoxShadow>?` | `shadowLight` | الظلال |
| `height` | `double?` | `null` | ارتفاع محدد |
| `width` | `double?` | `null` | عرض محدد |
| `onTap` | `VoidCallback?` | `null` | دالة عند الضغط |

---

## 🖼️ مثال كامل

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // خلفية داكنة لإظهار تأثير الزجاج
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1a1a2e), Color(0xFF0f3460)],
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: AppDimensions.paddingM,
          children: [
            GlassCard.withIcon(
              icon: Icons.shopping_cart,
              iconBackgroundColor: Colors.blue,
              child: Text('المبيعات', style: TextStyle(color: Colors.white)),
            ),
            GlassCard.withIcon(
              icon: Icons.people,
              iconBackgroundColor: Colors.green,
              child: Text('العملاء', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## ⚠️ ملاحظات مهمة

1. **الخلفية**: تأثير الزجاج يظهر بشكل أفضل على خلفيات داكنة متدرجة
2. **الأداء**: استخدم `blurLight` للقوائم الطويلة لتحسين الأداء
3. **التناسق**: استخدم نفس قيم `borderRadius` و `blurAmount` للبطاقات المتجاورة
4. **النص**: استخدم ألوان فاتحة (أبيض) للنصوص داخل البطاقات

---

## 🔄 التحديث العام

لتغيير مظهر جميع البطاقات الزجاجية في التطبيق، عدّل ثوابت `GlassCardStyle`:

```dart
// في ملف glass_card.dart
static Color backgroundColor = Colors.white.withOpacity(0.15); // زيادة الشفافية
static const double blurMedium = 20.0; // زيادة الضبابية
```

---

**آخر تحديث:** ديسمبر 2025
