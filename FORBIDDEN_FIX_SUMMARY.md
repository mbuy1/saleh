# 🔧 إصلاح خطأ "ليس لديك صلاحية للوصول" (FORBIDDEN)

## 🔍 المشكلة

عند إضافة منتج، يظهر خطأ: **"ليس لديك صلاحية للوصول" (403 FORBIDDEN)**

### السبب:
- Edge Function `product_create` يستخدم `SUPABASE_SERVICE_ROLE_KEY`
- `SERVICE_ROLE_KEY` يجب أن يتجاوز RLS تلقائياً
- لكن RLS Policy للـ INSERT في `products` لا تزال تتحقق

---

## ✅ الحل

### 1. Migration Script جديد
**الملف:** `mbuy-backend/migrations/20250106000004_fix_rls_for_service_role.sql`

**التغييرات:**
- ✅ تحديث RLS Policy للـ INSERT في `products`
- ✅ تحديث RLS Policy للـ UPDATE في `products`
- ✅ تحديث RLS Policy للـ DELETE في `products`

**الملاحظة المهمة:**
- `SERVICE_ROLE_KEY` يتجاوز RLS تلقائياً في Supabase
- لكن RLS Policy لا تزال تتحقق في بعض الحالات
- الحل: التأكد من أن Edge Function يستخدم `SERVICE_ROLE_KEY` بشكل صحيح

---

## 🔍 التحقق من Edge Function

### Edge Function يستخدم:
```typescript
const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: { autoRefreshToken: false, persistSession: false },
});
```

حيث `supabaseServiceKey` = `SUPABASE_SERVICE_ROLE_KEY`

**هذا صحيح ✅** - يجب أن يتجاوز RLS تلقائياً

---

## 🎯 الخطوات المطلوبة

### 1. تشغيل Migration
في Supabase SQL Editor:
```sql
-- نسخ محتوى الملف:
-- mbuy-backend/migrations/20250106000004_fix_rls_for_service_role.sql
-- والصق وتشغيل
```

### 2. التحقق من Edge Function
- ✅ التأكد من أن `SUPABASE_SERVICE_ROLE_KEY` موجود في Environment Variables
- ✅ التأكد من أن Edge Function يستخدم `SERVICE_ROLE_KEY` بشكل صحيح

### 3. اختبار إضافة منتج
- ✅ فتح تطبيق Flutter
- ✅ تسجيل الدخول كتاجر
- ✅ إضافة منتج جديد
- ✅ التحقق من عدم وجود خطأ FORBIDDEN

---

## 📊 RLS Policy المحدثة

### INSERT Policy:
```sql
CREATE POLICY "Merchants insert their own products"
ON public.products 
FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 
        FROM public.stores 
        INNER JOIN public.user_profiles 
          ON user_profiles.id = stores.owner_id
        WHERE stores.id = products.store_id 
        AND user_profiles.user_id = auth.uid()
        AND user_profiles.role = 'merchant'
    )
);
```

**ملاحظة:** 
- `SERVICE_ROLE_KEY` يتجاوز RLS تلقائياً
- هذه السياسة للتحقق الإضافي عند استخدام JWT عادي

---

## 🔍 إذا استمرت المشكلة

### 1. التحقق من Environment Variables
```bash
# في Supabase Dashboard:
# Settings → Edge Functions → Environment Variables
# التأكد من وجود:
# - SUPABASE_SERVICE_ROLE_KEY
```

### 2. التحقق من Logs
```typescript
// في Edge Function logs:
// البحث عن:
// - "Insert error"
// - "createError"
// - "FORBIDDEN"
```

### 3. التحقق من RLS
```sql
-- في Supabase SQL Editor:
SELECT * FROM pg_policies 
WHERE tablename = 'products' 
AND policyname LIKE '%Merchants%';
```

---

## ✅ النتيجة المتوقعة

بعد تشغيل Migration:
- ✅ Edge Function يستخدم `SERVICE_ROLE_KEY` ويتجاوز RLS
- ✅ إضافة المنتج تعمل بدون خطأ FORBIDDEN
- ✅ المنتج يُضاف بنجاح في قاعدة البيانات

---

## 📝 الملفات

1. **Migration Script:** `mbuy-backend/migrations/20250106000004_fix_rls_for_service_role.sql`
2. **Edge Function:** `mbuy-backend/functions/product_create/index.ts` (لا يحتاج تعديل)
3. **Worker:** `mbuy-worker/src/index.ts` (لا يحتاج تعديل)

---

**جاهز للاستخدام!** 🚀

