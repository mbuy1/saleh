# Shared Widgets

مجلد الـ Widgets المشتركة القابلة لإعادة الاستخدام في جميع شاشات التطبيق.

## 📁 الهيكل

```
shared_widgets/
├── appbars/              # أشرطة التطبيق العلوية
│   └── shared_appbar.dart
├── navigation/           # أشرطة التنقل
│   └── shared_bottom_nav.dart
├── cards/               # بطاقات العرض
│   └── product_card.dart
├── buttons/             # الأزرار
│   └── primary_button.dart
├── media/               # عناصر الوسائط
│   └── image_text_widget.dart
└── shared_widgets.dart  # ملف تصدير شامل
```

## 🚀 الاستخدام

### الطريقة السهلة (مستحسنة):
```dart
import 'package:saleh/shared_widgets/shared_widgets.dart';

// الآن يمكنك استخدام جميع الـ Widgets
SharedAppBar(title: 'عنوان الصفحة')
PrimaryButton(text: 'زر', onPressed: () {})
ProductCard(...)
```

### الطريقة المفصلة:
```dart
import 'package:saleh/shared_widgets/appbars/shared_appbar.dart';
import 'package:saleh/shared_widgets/buttons/primary_button.dart';
```

## 📦 الـ Widgets المتاحة

### 1. AppBars (أشرطة التطبيق)
- **SharedAppBar**: AppBar قابل للتخصيص
- **HomeAppBar**: AppBar خاص بالصفحة الرئيسية مع شعار mBuy

### 2. Navigation (التنقل)
- **SharedBottomNav**: شريط تنقل سفلي للشاشات الخمس الرئيسية (HomeScreen, ExploreScreen, StoresScreen, CartScreen, MapScreen)
- **SharedBottomNavController**: Controller لإدارة التنقل

### 3. Cards (البطاقات)
- **ProductCard**: بطاقة منتج عمودية
- **ProductCardCompact**: بطاقة منتج أفقية مضغوطة

### 4. Buttons (الأزرار)
- **PrimaryButton**: زر رئيسي بأنماط متعددة
- **SmallButton**: زر صغير للإجراءات السريعة
- **IconCircleButton**: زر أيقونة دائري
- **CustomFAB**: Floating Action Button مخصص

### 5. Media (الوسائط)
- **ImageTextWidget**: عرض صورة مع نص
- **CategoryCard**: بطاقة فئة
- **PromotionalBanner**: بانر ترويجي

## 💡 أمثلة سريعة

### AppBar
```dart
SharedAppBar(
  title: 'عنوان الصفحة',
  actions: [
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () {},
    ),
  ],
)
```

### BottomNavigationBar
```dart
SharedBottomNav(
  currentIndex: 0,
  onTap: (index) {
    // التنقل للشاشة المطلوبة
  },
  cartItemCount: 3, // عدد عناصر السلة
)
```

### Product Card
```dart
ProductCard(
  productId: '123',
  productName: 'اسم المنتج',
  price: 99.99,
  imageUrl: 'https://...',
  rating: 4.5,
  reviewCount: 120,
  stock: 50,
  onTap: () {
    // فتح صفحة المنتج
  },
  onAddToCart: () {
    // إضافة للسلة
  },
)
```

### Primary Button
```dart
PrimaryButton(
  text: 'إضافة إلى السلة',
  icon: Icons.shopping_cart,
  onPressed: () {},
  buttonStyle: ButtonStyle.primary,
  isLoading: false,
)
```

### Image + Text
```dart
ImageTextWidget(
  imageUrl: 'https://...',
  title: 'عنوان',
  subtitle: 'وصف',
  textPosition: ImageTextPosition.bottom,
  onTap: () {},
)
```

## 🎨 التخصيص

جميع الـ Widgets تستخدم ألوان من `MbuyColors` في `app_theme.dart`، مما يضمن التناسق البصري في جميع أنحاء التطبيق.

## ✅ مزايا استخدام هذه الـ Widgets

1. **توحيد التصميم**: نفس الشكل والمظهر في كل مكان
2. **سهولة الصيانة**: تعديل في مكان واحد يؤثر على كل التطبيق
3. **توفير الوقت**: لا حاجة لإعادة كتابة نفس الكود
4. **قابلية التوسع**: سهل إضافة ميزات جديدة
5. **كود نظيف**: ملفات أصغر وأوضح

## 📝 ملاحظات

- هذا المجلد **إضافي فقط** ولا يؤثر على الملفات الموجودة مسبقاً
- يمكن استخدام هذه الـ Widgets بجانب الـ Widgets القديمة
- يُنصح بالانتقال تدريجياً لاستخدام هذه الـ Widgets المشتركة
