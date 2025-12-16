-- التحقق من حالة store_id للتاجر
-- نفّذ هذا السكربت في Supabase SQL Editor

-- 1. عرض جميع التجار ومتاجرهم
SELECT 
  up.id AS profile_id,
  up.email,
  up.role,
  up.store_id AS "store_id في user_profiles",
  s.id AS "store_id في stores",
  s.name AS "اسم المتجر",
  s.is_active AS "المتجر نشط",
  CASE 
    WHEN up.store_id = s.id THEN '✅ متزامن صحيح'
    WHEN up.store_id IS NULL AND s.id IS NOT NULL THEN '❌ store_id فارغ'
    WHEN up.store_id IS NOT NULL AND s.id IS NULL THEN '⚠️ store_id موجود لكن المتجر محذوف'
    ELSE '⚠️ لا يوجد متجر'
  END AS "الحالة"
FROM public.user_profiles up
LEFT JOIN public.stores s ON s.owner_id = up.id
WHERE up.role = 'merchant'
ORDER BY up.email;

-- 2. إذا كان store_id فارغ، قم بالمزامنة:
UPDATE public.user_profiles up
SET store_id = s.id, updated_at = NOW()
FROM public.stores s
WHERE s.owner_id = up.id
  AND up.store_id IS NULL
  AND up.role = 'merchant';

-- 3. التحقق من النتيجة
SELECT 
  COUNT(*) FILTER (WHERE store_id IS NOT NULL) AS "تجار لديهم store_id",
  COUNT(*) FILTER (WHERE store_id IS NULL) AS "تجار بدون store_id",
  COUNT(*) AS "إجمالي التجار"
FROM public.user_profiles
WHERE role = 'merchant';
