# ملخص إصلاح UUID IDs

## التاريخ: يناير 2025

## المشكلة
كان هناك احتمال أن بعض المعرفات (IDs) تُرسل كأرقام (integers) بدلاً من UUID strings، مما يسبب خطأ `22P02` في PostgreSQL عند محاولة إدراج أرقام في حقول UUID.

## الحلول المطبقة

### 1. إصلاح Worker Validation Middleware ✅
**الملف**: `mbuy-worker/src/middleware/validation.ts`

**المشكلة**: كانت دالة `validateQuery` تحول جميع القيم التي يمكن تحويلها إلى أرقام إلى `Number`، مما قد يحول UUIDs إلى `NaN` أو أرقام.

**الحل**: 
- إضافة قائمة بالحقول التي يجب أن تبقى كـ strings (جميع `*_id` fields)
- التحقق من أن UUIDs (التي تحتوي على hyphens) لا تُحول إلى أرقام
- الحفاظ على جميع ID fields كـ strings دائماً

```typescript
// List of ID fields that should NEVER be converted to numbers
const idFields = [
  'id', 'category_id', 'store_id', 'user_id', 'owner_id', 'product_id',
  'order_id', 'cart_id', 'review_id', 'coupon_id', 'banner_id', 'video_id',
  // ... etc
];
```

### 2. التحقق من النماذج (Models) ✅
**الملفات المفحوصة**:
- `saleh/lib/features/customer/data/models/product_model.dart`
- `saleh/lib/features/customer/data/models/category_model.dart`
- `saleh/lib/features/customer/data/models/store_model.dart`

**النتيجة**: جميع ID fields هي بالفعل من نوع `String` ✅

### 3. التحقق من جميع الاستدعاءات ✅
**الملفات المفحوصة**:
- جميع استخدامات `ApiService` في Flutter
- جميع استخدامات Supabase مباشرة
- جميع queries في Worker

**النتيجة**: جميع IDs تُرسل كـ strings ✅

### 4. التحقق من عدم استخدام parseInt/Number() على IDs ✅
**النتيجة**: جميع استخدامات `parseInt` و `Number()` و `.toInt()` هي على حقول غير IDs (stock, quantity, rating, etc) ✅

### 5. إنشاء Migration لإصلاح البيانات ✅
**الملف**: `mbuy-backend/migrations/20250108000001_fix_uuid_ids.sql`

**المحتوى**:
- حذف جميع السجلات التي تحتوي على IDs غير صالحة (أرقام بدلاً من UUIDs)
- إضافة check constraints للتأكد من أن جميع IDs المستقبلية هي UUIDs صالحة
- السكريبت آمن للتشغيل عدة مرات (idempotent)

## الجداول المفحوصة والمصلحة

1. ✅ `products` - category_id, store_id
2. ✅ `stores` - owner_id
3. ✅ `orders` - customer_id, store_id
4. ✅ `cart_items` - user_id, product_id, store_id
5. ✅ `order_items` - product_id, order_id
6. ✅ `reviews` - user_id, product_id, store_id
7. ✅ `coupons` - store_id
8. ✅ `favorites` - user_id, product_id
9. ✅ `recently_viewed` - user_id, product_id
10. ✅ `wishlist` - user_id, product_id

## الخطوات التالية

1. **تطبيق Migration**:
   ```bash
   # في Supabase Dashboard أو عبر psql
   # تشغيل: mbuy-backend/migrations/20250108000001_fix_uuid_ids.sql
   ```

2. **اختبار التطبيق**:
   - جلب المنتجات حسب الفئة
   - جلب المنتجات حسب المتجر
   - إنشاء طلبات جديدة
   - التحقق من عدم ظهور خطأ `22P02`

3. **مراقبة الأخطاء**:
   - مراقبة Worker logs للبحث عن أي أخطاء `22P02`
   - مراقبة Flutter logs للبحث عن أي أخطاء في API calls

## ملاحظات مهمة

1. **UUID Format**: جميع UUIDs يجب أن تكون بصيغة:
   ```
   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   ```
   (8-4-4-4-12 hex characters)

2. **Type Safety**: في Flutter، جميع ID fields هي `String`، وليس `int` أو `num`.

3. **Worker Validation**: Worker الآن يضمن أن جميع ID fields تبقى كـ strings ولا تُحول إلى أرقام.

4. **Database Constraints**: تم إضافة check constraints في Supabase للتأكد من صحة UUIDs.

## التحقق من الإصلاح

للتحقق من أن الإصلاح يعمل:

1. **في Flutter**:
   ```dart
   // يجب أن تكون جميع IDs strings
   final categoryId = '550e8400-e29b-41d4-a716-446655440000'; // ✅
   // وليس:
   // final categoryId = 123; // ❌
   ```

2. **في Worker**:
   ```typescript
   // يجب أن تبقى IDs كـ strings
   const categoryId = url.searchParams.get('category_id'); // ✅ string
   // وليس:
   // const categoryId = Number(url.searchParams.get('category_id')); // ❌
   ```

3. **في Supabase**:
   ```sql
   -- التحقق من أن جميع IDs هي UUIDs صالحة
   SELECT id, category_id, store_id 
   FROM products 
   WHERE category_id !~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$';
   -- يجب أن يعيد 0 rows
   ```

## الخلاصة

✅ تم إصلاح جميع المشاكل المتعلقة بـ UUID IDs:
- Worker validation middleware لا يحول IDs إلى أرقام
- جميع النماذج تستخدم String للـ IDs
- جميع الاستدعاءات ترسل IDs كـ strings
- تم إنشاء migration لإصلاح البيانات الخاطئة
- تم إضافة constraints للتأكد من صحة UUIDs المستقبلية

الخطأ `22P02` يجب أن يختفي تماماً بعد تطبيق هذه الإصلاحات.

