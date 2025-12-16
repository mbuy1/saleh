# 📚 دليل نظام الأيقونات الموحد

## 🎯 الهدف
توحيد جميع الأيقونات في التطبيق باستخدام SVG بدلاً من Material Icons.

## 📁 هيكل الملفات
```
lib/
├── core/
│   └── constants/
│       └── app_icons.dart     # مسارات جميع الأيقونات
└── shared/
    └── widgets/
        └── app_icon.dart      # ويدجت عرض الأيقونات

assets/
└── icons/
    ├── home.svg
    ├── settings.svg
    └── ... (60+ أيقونة)
```

## 🚀 طريقة الاستخدام

### 1. استيراد الملفات
```dart
import 'package:your_app/shared/widgets/exports.dart';
// أو
import 'package:your_app/core/constants/app_icons.dart';
import 'package:your_app/shared/widgets/app_icon.dart';
```

### 2. عرض أيقونة بسيطة
```dart
// قبل (Material Icons)
Icon(Icons.home)

// بعد (SVG)
AppIcon(AppIcons.home)
```

### 3. أيقونة بحجم مخصص
```dart
AppIcon(
  AppIcons.settings,
  size: 32,
)
```

### 4. أيقونة بلون مخصص
```dart
AppIcon(
  AppIcons.star,
  color: Colors.amber,
)
```

### 5. أيقونة في شريط التنقل
```dart
AppIcon.nav(
  AppIcons.home,
  isSelected: true,
  selectedColor: AppTheme.primaryColor,
  unselectedColor: Colors.grey,
)
```

### 6. أيقونة كزر
```dart
AppIcon.button(
  AppIcons.add,
  onTap: () => print('تم الضغط'),
  size: 24,
  color: Colors.white,
  backgroundColor: AppTheme.primaryColor,
)
```

## 📋 قائمة الأيقونات المتاحة

### التنقل والقوائم
- `AppIcons.home` - الرئيسية
- `AppIcons.grid` - الشبكة
- `AppIcons.menu` - القائمة
- `AppIcons.settings` - الإعدادات
- `AppIcons.moreVert` - المزيد (عمودي)
- `AppIcons.moreHoriz` - المزيد (أفقي)

### الأسهم والاتجاهات
- `AppIcons.arrowBack` - سهم للخلف
- `AppIcons.arrowForward` - سهم للأمام
- `AppIcons.chevronDown` - سهم لأسفل
- `AppIcons.chevronUp` - سهم لأعلى
- `AppIcons.chevronLeft` - سهم لليسار
- `AppIcons.chevronRight` - سهم لليمين

### الإجراءات الأساسية
- `AppIcons.add` - إضافة
- `AppIcons.close` - إغلاق
- `AppIcons.edit` - تعديل
- `AppIcons.delete` - حذف
- `AppIcons.search` - بحث
- `AppIcons.filter` - فلترة
- `AppIcons.sort` - ترتيب
- `AppIcons.refresh` - تحديث
- `AppIcons.share` - مشاركة
- `AppIcons.copy` - نسخ
- `AppIcons.download` - تنزيل
- `AppIcons.upload` - رفع
- `AppIcons.link` - رابط

### المستخدم والمصادقة
- `AppIcons.person` - شخص
- `AppIcons.email` - بريد
- `AppIcons.lock` - قفل
- `AppIcons.visibility` - إظهار
- `AppIcons.visibilityOff` - إخفاء
- `AppIcons.login` - دخول
- `AppIcons.logout` - خروج

### التجارة والمتجر
- `AppIcons.store` - متجر
- `AppIcons.shoppingBag` - حقيبة تسوق
- `AppIcons.cart` - عربة
- `AppIcons.inventory` - مخزون
- `AppIcons.tag` - وسم
- `AppIcons.discount` - خصم
- `AppIcons.orders` - طلبات
- `AppIcons.product` - منتج

### المال والإحصائيات
- `AppIcons.chart` - رسم بياني
- `AppIcons.money` - مال
- `AppIcons.wallet` - محفظة
- `AppIcons.trendingUp` - صعود
- `AppIcons.trendingDown` - هبوط
- `AppIcons.dollar` - دولار
- `AppIcons.pieChart` - دائري
- `AppIcons.analytics` - تحليلات

### التنبيهات والحالات
- `AppIcons.notifications` - إشعارات
- `AppIcons.check` - تحقق
- `AppIcons.checkCircle` - تحقق دائري
- `AppIcons.error` - خطأ
- `AppIcons.warning` - تحذير
- `AppIcons.info` - معلومات
- `AppIcons.help` - مساعدة

### إضافية
- `AppIcons.flash` - برق
- `AppIcons.gift` - هدية
- `AppIcons.bulb` - مصباح
- `AppIcons.tools` - أدوات
- `AppIcons.sparkle` - لمعان
- `AppIcons.loyalty` - ولاء
- `AppIcons.chat` - محادثة
- `AppIcons.shipping` - شحن

## 🔄 خطة الترحيل

### المرحلة 1 ✅ (مكتمل)
- [x] إنشاء مجلد assets/icons
- [x] إضافة حزمة flutter_svg
- [x] إنشاء ملفات SVG للأيقونات الأساسية
- [x] إنشاء app_icons.dart
- [x] إنشاء app_icon.dart
- [x] تحديث dashboard_shell.dart (Bottom Nav)
- [x] تحديث marketing_screen.dart

### المرحلة 2 (قيد العمل)
- [ ] تحديث home_tab.dart
- [ ] تحديث shared_widgets.dart
- [ ] تحديث base_screen.dart
- [ ] تحديث error_boundary.dart

### المرحلة 3 (مستقبلي)
- [ ] تحديث جميع الشاشات المتبقية
- [ ] إزالة cupertino_icons من pubspec.yaml
- [ ] توثيق أي أيقونات إضافية مطلوبة

## ⚠️ ملاحظات مهمة

1. **الألوان**: استخدم دائماً ألوان من Theme
   ```dart
   color: Theme.of(context).iconTheme.color
   // أو
   color: AppTheme.primaryColor
   ```

2. **الأحجام**: استخدم AppIconSize
   ```dart
   size: AppIconSize.medium  // 24
   size: AppIconSize.large   // 28
   ```

3. **الوصولية**: أضف semanticLabel عند الحاجة
   ```dart
   AppIcon(
     AppIcons.settings,
     semanticLabel: 'الإعدادات',
   )
   ```

## 🎨 إضافة أيقونة جديدة

1. أضف ملف SVG في `assets/icons/`
2. أضف المسار في `app_icons.dart`:
   ```dart
   static const String newIcon = '\${_basePath}new_icon.svg';
   ```
3. استخدم الأيقونة:
   ```dart
   AppIcon(AppIcons.newIcon)
   ```

---
آخر تحديث: ديسمبر 2025
