-- سكربت تشخيص شامل لمشكلة إضافة المنتج
-- نفّذ كل query على حدة في Supabase SQL Editor

-- ============================================================================
-- 1. التحقق من store_id للتاجر الحالي
-- ============================================================================
-- استبدل 'YOUR_EMAIL_HERE' ببريد التاجر الإلكتروني
SELECT 
  up.id AS profile_id,
  up.email,
  up.role,
  up.store_id,
  s.id AS store_id_from_stores,
  s.name AS store_name,
  s.is_active AS store_is_active,
  s.status AS store_status,
  CASE 
    WHEN up.store_id IS NULL THEN '❌ PROBLEM: store_id is NULL'
    WHEN up.store_id != s.id THEN '⚠️ WARNING: store_id mismatch'
    WHEN s.is_active = false THEN '⚠️ WARNING: store is not active'
    WHEN s.status != 'active' THEN '⚠️ WARNING: store status is not active'
    ELSE '✅ OK'
  END AS diagnosis
FROM public.user_profiles up
LEFT JOIN public.stores s ON s.owner_id = up.id
WHERE up.email = 'YOUR_EMAIL_HERE';  -- 👈 ضع البريد الإلكتروني للتاجر هنا

-- ============================================================================
-- 2. إصلاح store_id إذا كان فارغاً
-- ============================================================================
-- هذا الكود يصلح store_id للتاجر المحدد
UPDATE public.user_profiles up
SET store_id = s.id, updated_at = NOW()
FROM public.stores s
WHERE s.owner_id = up.id
  AND up.store_id IS NULL
  AND up.email = 'YOUR_EMAIL_HERE';  -- 👈 ضع البريد الإلكتروني للتاجر هنا

-- ============================================================================
-- 3. التحقق من Categories المتاحة
-- ============================================================================
SELECT 
  id,
  name_ar AS "الاسم بالعربي",
  name_en AS "الاسم بالإنجليزي",
  is_active AS "نشط؟",
  created_at
FROM public.categories
WHERE is_active = true
ORDER BY name_ar;

-- ============================================================================
-- 4. إذا لم توجد categories، أنشئ واحدة تجريبية:
-- ============================================================================
INSERT INTO public.categories (name_ar, name_en, description, is_active)
VALUES 
  ('إلكترونيات', 'Electronics', 'الأجهزة الإلكترونية', true),
  ('ملابس', 'Clothing', 'الملابس والأزياء', true),
  ('أطعمة', 'Food', 'المواد الغذائية', true)
ON CONFLICT (name_en) DO NOTHING;

-- ============================================================================
-- 5. التحقق من المتجر
-- ============================================================================
-- استبدل 'YOUR_EMAIL_HERE' ببريد التاجر
SELECT 
  s.*
FROM public.stores s
JOIN public.user_profiles up ON s.owner_id = up.id
WHERE up.email = 'YOUR_EMAIL_HERE';

-- ============================================================================
-- 6. اختبار إدخال منتج يدوياً
-- ============================================================================
-- هذا يختبر إذا كان الإدخال يعمل من قاعدة البيانات مباشرة
-- استبدل القيم:
-- - STORE_ID_HERE: قيمة store_id من Query #1
-- - CATEGORY_ID_HERE: قيمة id من Query #3

/*
INSERT INTO public.products (
  store_id,
  category_id,
  name,
  description,
  price,
  stock,
  is_active
) VALUES (
  'STORE_ID_HERE',      -- 👈 ضع store_id هنا
  'CATEGORY_ID_HERE',   -- 👈 ضع category_id هنا
  'منتج تجريبي',
  'هذا منتج تجريبي للاختبار',
  100.00,
  10,
  true
);
*/

-- ============================================================================
-- 7. التحقق من Constraints على جدول products
-- ============================================================================
SELECT
  con.conname AS constraint_name,
  con.contype AS constraint_type,
  CASE con.contype
    WHEN 'c' THEN 'CHECK'
    WHEN 'f' THEN 'FOREIGN KEY'
    WHEN 'p' THEN 'PRIMARY KEY'
    WHEN 'u' THEN 'UNIQUE'
    WHEN 'n' THEN 'NOT NULL'
    ELSE con.contype::text
  END AS constraint_type_desc,
  pg_get_constraintdef(con.oid) AS constraint_definition
FROM pg_constraint con
JOIN pg_class rel ON rel.oid = con.conrelid
WHERE rel.relname = 'products'
  AND rel.relnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public');

-- ============================================================================
-- 8. التحقق من RLS Policies على products
-- ============================================================================
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE tablename = 'products';

-- ============================================================================
-- 9. تعطيل RLS مؤقتاً للاختبار (احذر! هذا للاختبار فقط)
-- ============================================================================
-- ⚠️ هذا يعطل RLS - استخدمه فقط للاختبار ثم أعد تفعيله
/*
ALTER TABLE public.products DISABLE ROW LEVEL SECURITY;

-- بعد الاختبار، أعد تفعيل RLS:
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
*/

-- ============================================================================
-- 10. عرض آخر 5 محاولات إدخال في products (من logs)
-- ============================================================================
-- هذا يعرض المنتجات الأخيرة لمعرفة إذا كان الإدخال نجح من قبل
SELECT 
  p.*,
  s.name AS store_name,
  c.name_ar AS category_name
FROM public.products p
LEFT JOIN public.stores s ON p.store_id = s.id
LEFT JOIN public.categories c ON p.category_id = c.id
ORDER BY p.created_at DESC
LIMIT 5;
