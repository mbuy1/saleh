# تقرير إصلاح خطأ UUID (22P02) في Flutter

## التاريخ: يناير 2025

## المشكلة
كان الكود يرسل أرقام ثابتة ('1', '2', '3'...) كـ `category_id` إلى استعلامات Supabase، بينما العمود من نوع `uuid`، مما يسبب خطأ `22P02: invalid input syntax for type uuid`.

---

## الملفات المعدلة

### 1. `saleh/lib/features/customer/presentation/screens/categories_screen.dart`
**التعديل**: 
- السطر 141: إضافة `.toString()` للتأكد من أن `category['id']` يتم تحويله إلى String
```dart
// قبل:
categoryId: category['id'],

// بعد:
categoryId: category['id']?.toString() ?? '',
```

---

### 2. `saleh/lib/features/customer/presentation/screens/home_screen_shein.dart`
**التعديلات**:
- **السطور 73-101**: إزالة Fallback الذي يستخدم أرقام ثابتة ('1', '2', '3'...)
- **السطر 105-142**: إضافة استخدام `categoryId` من الفئة المحددة في `_loadFeaturedProducts()`
- **السطور 263-294**: إصلاح `_buildLooksSection()` لاستخدام الفئات الحقيقية من `_productCategories` بدلاً من الأرقام الثابتة
- **السطور 365-458**: إصلاح `_buildCategoryIconsGrid()` لاستخدام الفئات الحقيقية بدلاً من الأرقام الثابتة
- **السطور 493-562**: إصلاح `_buildPromotionalBanners()` لاستخدام الفئات الحقيقية بدلاً من الأرقام الثابتة

**التغييرات الرئيسية**:
```dart
// قبل:
categoryId: look['id']!,  // '1', '2', '3'...

// بعد:
final categoryId = look['id'] as String?;
if (categoryId != null && categoryId.isNotEmpty) {
  // استخدام UUID الحقيقي
}
```

---

### 3. `saleh/lib/features/customer/presentation/screens/stores_screen_shein.dart`
**التعديلات**:
- **السطور 263-294**: إصلاح `_buildLooksSection()` لإزالة الأرقام الثابتة
- **السطور 348-425**: إصلاح `_buildCategoryIconsGrid()` لإزالة الأرقام الثابتة
- **السطور 427-470**: إصلاح `_buildPromotionalBanners()` لإزالة الأرقام الثابتة
- **السطر 324**: إضافة التحقق من صحة UUID قبل الاستخدام

**التغييرات الرئيسية**:
```dart
// قبل:
final id = look['id'] ?? '0';  // يستخدم '0' كـ fallback

// بعد:
final id = look['id']?.toString();
if (id == null || id.isEmpty || id == '0') {
  return const SizedBox.shrink();  // لا نعرض البطاقة
}
```

---

### 4. `saleh/lib/features/customer/data/models/category_model.dart`
**التعديل**: 
- السطور 21-31: إصلاح `fromJson()` للتأكد من تحويل `id` إلى String حتى لو وصل كـ int أو num
```dart
// قبل:
id: json['id'] as String,

// بعد:
id: json['id']?.toString() ?? '',
```

---

### 5. `saleh/lib/features/customer/data/models/product_model.dart`
**التعديل**: 
- السطور 37-59: إصلاح `fromJson()` للتأكد من تحويل جميع IDs إلى String
```dart
// قبل:
id: json['id'] as String,
categoryId: json['category_id'] as String?,

// بعد:
id: json['id']?.toString() ?? '',
categoryId: json['category_id']?.toString(),
```

---

## التحقق من Worker

### `mbuy-worker/src/index.ts`
**الحالة**: ✅ **صحيح**
- السطر 101: `const categoryId = url.searchParams.get('category_id');` - يستخدم String مباشرة
- السطر 110: `query += `&category_id=eq.${categoryId}`;` - لا يحول إلى رقم

### `mbuy-worker/src/middleware/validation.ts`
**الحالة**: ✅ **صحيح**
- السطور 133-134: يتحقق من أن الحقول التي تنتهي بـ `_id` تبقى كـ String
- السطور 139-141: يتحقق من أن القيم التي تحتوي على `-` (UUIDs) تبقى كـ String

---

## الملخص

### المشاكل التي تم إصلاحها:
1. ✅ إزالة استخدام الأرقام الثابتة ('1', '2', '3'...) كـ `category_id`
2. ✅ إصلاح الموديلات للتأكد من تحويل IDs إلى String
3. ✅ إصلاح جميع الشاشات التي تستخدم `CategoryProductsScreen` و `CategoryProductsScreenShein`
4. ✅ إضافة التحقق من صحة UUID قبل الاستخدام
5. ✅ التأكد من أن Worker لا يحول IDs إلى أرقام

### الملفات المعدلة:
1. `saleh/lib/features/customer/presentation/screens/categories_screen.dart`
2. `saleh/lib/features/customer/presentation/screens/home_screen_shein.dart`
3. `saleh/lib/features/customer/presentation/screens/stores_screen_shein.dart`
4. `saleh/lib/features/customer/data/models/category_model.dart`
5. `saleh/lib/features/customer/data/models/product_model.dart`

### الملفات التي تم التحقق منها (لا تحتاج تعديل):
- `mbuy-worker/src/index.ts` - ✅ صحيح
- `mbuy-worker/src/middleware/validation.ts` - ✅ صحيح

---

## الخطوات التالية للاختبار

1. شغّل التطبيق (Flutter)
2. جرّب:
   - فتح شاشة الفئات واختيار فئة
   - فتح شاشة المنتجات حسب الفئة
   - التأكد من عدم ظهور خطأ `22P02`
3. تحقق من أن:
   - جميع الفئات تستخدم UUIDs من قاعدة البيانات
   - لا توجد أرقام ثابتة ('1', '2', '3'...) تُرسل كـ `category_id`

---

**تاريخ الإصلاح**: يناير 2025  
**الحالة**: ✅ تم الإصلاح

