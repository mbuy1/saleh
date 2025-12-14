# 🔍 دليل استكشاف خطأ "Failed to create product"

## الخطوات المطلوبة بالترتيب:

### 1️⃣ التحقق من store_id في قاعدة البيانات

**افتح Supabase SQL Editor** وشغّل هذا الكود (استبدل YOUR_EMAIL بالبريد الإلكتروني للتاجر):

```sql
SELECT 
  up.id AS profile_id,
  up.email,
  up.store_id,
  s.id AS store_id_from_stores,
  s.name AS store_name,
  CASE 
    WHEN up.store_id IS NULL THEN '❌ المشكلة: store_id فارغ'
    WHEN up.store_id != s.id THEN '⚠️ تحذير: store_id غير متطابق'
    ELSE '✅ صحيح'
  END AS status
FROM public.user_profiles up
LEFT JOIN public.stores s ON s.owner_id = up.id
WHERE up.email = 'YOUR_EMAIL';  -- 👈 ضع البريد الإلكتروني هنا
```

**إذا كان store_id فارغاً (NULL)، شغّل هذا:**

```sql
UPDATE public.user_profiles up
SET store_id = s.id, updated_at = NOW()
FROM public.stores s
WHERE s.owner_id = up.id
  AND up.store_id IS NULL
  AND up.email = 'YOUR_EMAIL';  -- 👈 ضع البريد الإلكتروني هنا
```

---

### 2️⃣ التحقق من Categories

**تأكد أن هناك categories متاحة:**

```sql
SELECT id, name_ar, name_en, is_active
FROM public.categories
WHERE is_active = true;
```

**إذا لم توجد categories، أنشئها:**

```sql
INSERT INTO public.categories (name_ar, name_en, description, is_active)
VALUES 
  ('إلكترونيات', 'Electronics', 'الأجهزة الإلكترونية', true),
  ('ملابس', 'Clothing', 'الملابس والأزياء', true),
  ('أطعمة', 'Food', 'المواد الغذائية', true),
  ('متنوعة', 'General', 'منتجات متنوعة', true)
ON CONFLICT DO NOTHING;
```

---

### 3️⃣ فحص Cloudflare Logs

**افتح Cloudflare Dashboard:**
1. اذهب إلى: https://dash.cloudflare.com
2. Workers & Pages → misty-mode-b68b
3. اضغط على "Logs" (Real-time)
4. أضف منتج من التطبيق
5. راقب الـ logs

**ابحث عن هذه الرسائل:**

✅ **إذا رأيت:**
```
🆕 CREATE PRODUCT - NEW IMPLEMENTATION
📌 Step 3: Fetching store_id from user_profiles
  store_id: abc123-...
✅ store_id found
```
معناها store_id موجود ✅

❌ **إذا رأيت:**
```
❌ No store_id found for this merchant
```
معناها المشكلة في store_id → ارجع للخطوة 1️⃣

❌ **إذا رأيت:**
```
❌ INSERT FAILED
  Status: 400/500
  Error: ...
```
انسخ رسالة الخطأ كاملة وأرسلها لي

---

### 4️⃣ اختبار يدوي من قاعدة البيانات

**جرب إضافة منتج مباشرة من SQL:**

```sql
-- أولاً، احصل على store_id و category_id:
SELECT 
  up.store_id,
  (SELECT id FROM categories WHERE is_active = true LIMIT 1) AS category_id
FROM user_profiles up
WHERE up.email = 'YOUR_EMAIL';

-- ثم استخدم القيم في هذا الكود:
INSERT INTO public.products (
  store_id,
  category_id,
  name,
  description,
  price,
  stock,
  is_active
) VALUES (
  'STORE_ID_FROM_ABOVE',     -- 👈 ضع store_id
  'CATEGORY_ID_FROM_ABOVE',  -- 👈 ضع category_id
  'منتج تجريبي',
  'اختبار يدوي',
  50.00,
  5,
  true
);
```

**إذا نجح الإدخال:**
- ✅ معناها قاعدة البيانات تعمل
- ❌ المشكلة في Worker أو Flutter

**إذا فشل الإدخال:**
- ❌ انسخ رسالة الخطأ
- قد تكون المشكلة في RLS أو Constraints

---

### 5️⃣ فحص Flutter Logs

**في VS Code Terminal (حيث يعمل flutter run):**

ابحث عن:
```
[ProductsRepository] Creating product: ...
```

**إذا رأيت خطأ مثل:**
```
Exception: Failed to create product
```

ابحث عن السطر الذي قبله - قد يحتوي على تفاصيل أكثر.

---

## 🎯 الحلول السريعة:

### الحل 1: إصلاح store_id (الأكثر شيوعاً)
```sql
-- شغّل هذا في Supabase SQL Editor
UPDATE public.user_profiles up
SET store_id = s.id, updated_at = NOW()
FROM public.stores s
WHERE s.owner_id = up.id
  AND up.store_id IS NULL;
```

### الحل 2: إنشاء Categories
```sql
INSERT INTO public.categories (name_ar, name_en, is_active)
VALUES ('متنوعة', 'General', true)
ON CONFLICT DO NOTHING;
```

### الحل 3: إعادة تشغيل التطبيق
```bash
# أوقف flutter run (Ctrl+C)
# ثم شغّله مرة أخرى
cd C:\muath\saleh
flutter run
```

---

## 📋 المعلومات المطلوبة للمساعدة:

إذا لم تحل المشكلة، أرسل لي:

1. **نتيجة Query #1** (التحقق من store_id)
2. **Cloudflare Logs** (انسخ الرسائل من 🆕 CREATE PRODUCT حتى النهاية)
3. **Flutter Error** (رسالة الخطأ الكاملة من VS Code Terminal)
4. **Supabase Error** (إذا جربت الإدخال اليدوي في الخطوة 4️⃣)

---

## ✅ الملفات المساعدة:

تم إنشاء ملفين للمساعدة:

1. **CHECK_MERCHANT_STORE_ID.sql** - للتحقق السريع من store_id
2. **DIAGNOSE_PRODUCT_CREATE_ERROR.sql** - للتشخيص الشامل

شغّل الملف الأول أولاً للتحقق السريع.
