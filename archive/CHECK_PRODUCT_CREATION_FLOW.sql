-- ========================================
-- فحص شامل: JWT → Profile → Store → Products
-- ========================================
-- استخدم هذا الـ SQL في Supabase SQL Editor للتحقق من التدفق الكامل

-- ============================================
-- الخطوة 1: استبدل JWT_SUB_HERE بقيمة JWT.sub الفعلية
-- ============================================
-- للحصول على JWT.sub:
-- 1. افتح https://jwt.io
-- 2. الصق JWT token
-- 3. انظر إلى "sub" في payload

DO $$
DECLARE
  jwt_sub UUID := '00000000-0000-0000-0000-000000000000'::UUID;  -- ⚠️ استبدل هذا بـ JWT.sub الفعلي!
  profile_record RECORD;
  store_record RECORD;
BEGIN
  RAISE NOTICE '========================================';
  RAISE NOTICE 'فحص التدفق: JWT → Profile → Store';
  RAISE NOTICE '========================================';
  RAISE NOTICE '';
  
  -- ============================================
  -- فحص 1: هل يوجد user_profile؟
  -- ============================================
  RAISE NOTICE '1️⃣ البحث عن user_profile...';
  
  SELECT * INTO profile_record
  FROM user_profiles
  WHERE mbuy_user_id = jwt_sub;
  
  IF NOT FOUND THEN
    RAISE NOTICE '❌ لا يوجد user_profile بـ mbuy_user_id = %', jwt_sub;
    RAISE NOTICE '';
    RAISE NOTICE '💡 الحل: أنشئ profile:';
    RAISE NOTICE 'INSERT INTO user_profiles (mbuy_user_id, role, email)';
    RAISE NOTICE 'VALUES (''%'', ''merchant'', ''merchant@example.com'');', jwt_sub;
    RETURN;
  END IF;
  
  RAISE NOTICE '✅ وجد user_profile:';
  RAISE NOTICE '   - Profile ID: %', profile_record.id;
  RAISE NOTICE '   - Role: %', profile_record.role;
  RAISE NOTICE '   - Email: %', profile_record.email;
  RAISE NOTICE '';
  
  -- ============================================
  -- فحص 2: هل يوجد متجر؟
  -- ============================================
  RAISE NOTICE '2️⃣ البحث عن متجر...';
  
  SELECT * INTO store_record
  FROM stores
  WHERE owner_id = profile_record.id;
  
  IF NOT FOUND THEN
    RAISE NOTICE '❌ لا يوجد متجر بـ owner_id = %', profile_record.id;
    RAISE NOTICE '';
    RAISE NOTICE '💡 الحل: أنشئ متجر:';
    RAISE NOTICE 'INSERT INTO stores (owner_id, name, description, status)';
    RAISE NOTICE 'VALUES (''%'', ''متجر تجريبي'', ''وصف المتجر'', ''active'');', profile_record.id;
    RETURN;
  END IF;
  
  RAISE NOTICE '✅ وجد متجر:';
  RAISE NOTICE '   - Store ID: %', store_record.id;
  RAISE NOTICE '   - Store Name: %', store_record.name;
  RAISE NOTICE '   - Status: %', store_record.status;
  RAISE NOTICE '';
  
  -- ============================================
  -- فحص 3: هل المتجر نشط؟
  -- ============================================
  IF store_record.status != 'active' THEN
    RAISE NOTICE '⚠️ المتجر غير نشط! (حالة: %)', store_record.status;
    RAISE NOTICE '';
    RAISE NOTICE '💡 الحل: فعّل المتجر:';
    RAISE NOTICE 'UPDATE stores SET status = ''active'' WHERE id = ''%'';', store_record.id;
    RETURN;
  END IF;
  
  -- ============================================
  -- فحص 4: عرض منتجات المتجر
  -- ============================================
  RAISE NOTICE '3️⃣ فحص منتجات المتجر...';
  RAISE NOTICE '';
  
  IF EXISTS (SELECT 1 FROM products WHERE store_id = store_record.id) THEN
    RAISE NOTICE '✅ يوجد % منتج في المتجر', (SELECT COUNT(*) FROM products WHERE store_id = store_record.id);
  ELSE
    RAISE NOTICE 'ℹ️ لا توجد منتجات في المتجر حالياً';
  END IF;
  
  RAISE NOTICE '';
  RAISE NOTICE '========================================';
  RAISE NOTICE '🎉 التدفق صحيح! يمكن إنشاء منتجات بنجاح';
  RAISE NOTICE '========================================';
  
END $$;

-- ============================================
-- عرض ملخص: JWT → Profile → Store → Products
-- ============================================
SELECT 
  'JWT → Profile → Store → Products' AS "Flow Check",
  COUNT(DISTINCT up.id) AS "Profiles Count",
  COUNT(DISTINCT s.id) AS "Stores Count",
  COUNT(DISTINCT p.id) AS "Products Count"
FROM user_profiles up
LEFT JOIN stores s ON s.owner_id = up.id
LEFT JOIN products p ON p.store_id = s.id
WHERE up.mbuy_user_id = '00000000-0000-0000-0000-000000000000'::UUID;  -- ⚠️ استبدل هذا بـ JWT.sub الفعلي!

-- ============================================
-- عرض تفصيلي: جميع المنتجات مع معلومات المتجر
-- ============================================
SELECT 
  p.id AS "Product ID",
  p.name AS "Product Name",
  p.price AS "Price",
  p.stock AS "Stock",
  p.store_id AS "Store ID",
  s.name AS "Store Name",
  s.owner_id AS "Owner Profile ID",
  up.mbuy_user_id AS "Owner JWT sub",
  up.role AS "Owner Role",
  p.created_at AS "Created At"
FROM products p
INNER JOIN stores s ON p.store_id = s.id
INNER JOIN user_profiles up ON s.owner_id = up.id
WHERE up.mbuy_user_id = '00000000-0000-0000-0000-000000000000'::UUID  -- ⚠️ استبدل هذا بـ JWT.sub الفعلي!
ORDER BY p.created_at DESC
LIMIT 10;

-- ============================================
-- إنشاء متجر جديد (إذا لزم الأمر)
-- ============================================
-- أولاً، احصل على profile_id:
-- SELECT id FROM user_profiles WHERE mbuy_user_id = 'JWT_SUB_HERE';

-- ثم أنشئ المتجر:
/*
INSERT INTO stores (owner_id, name, description, status)
VALUES (
  'PROFILE_ID_HERE'::UUID,
  'متجر تجريبي',
  'وصف المتجر',
  'active'
)
RETURNING *;
*/

-- ============================================
-- تفعيل متجر غير نشط
-- ============================================
/*
UPDATE stores 
SET status = 'active'
WHERE owner_id = 'PROFILE_ID_HERE'::UUID;
*/

-- ============================================
-- فحص RLS Policies على stores
-- ============================================
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  cmd,
  qual
FROM pg_policies
WHERE tablename = 'stores'
ORDER BY policyname;

-- ============================================
-- فحص RLS Policies على products
-- ============================================
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  cmd,
  qual
FROM pg_policies
WHERE tablename = 'products'
ORDER BY policyname;

-- ============================================
-- عرض جميع التجار ومتاجرهم
-- ============================================
SELECT 
  up.id AS "Profile ID",
  up.mbuy_user_id AS "JWT sub",
  up.email AS "Email",
  up.role AS "Role",
  s.id AS "Store ID",
  s.name AS "Store Name",
  s.status AS "Store Status",
  COUNT(p.id) AS "Products Count"
FROM user_profiles up
LEFT JOIN stores s ON s.owner_id = up.id
LEFT JOIN products p ON p.store_id = s.id
WHERE up.role = 'merchant'
GROUP BY up.id, up.mbuy_user_id, up.email, up.role, s.id, s.name, s.status
ORDER BY up.created_at DESC;

-- ============================================
-- إحصائيات عامة
-- ============================================
SELECT 
  'Total Merchants' AS "Metric",
  COUNT(*) AS "Count"
FROM user_profiles
WHERE role = 'merchant'

UNION ALL

SELECT 
  'Total Stores' AS "Metric",
  COUNT(*) AS "Count"
FROM stores

UNION ALL

SELECT 
  'Active Stores' AS "Metric",
  COUNT(*) AS "Count"
FROM stores
WHERE status = 'active'

UNION ALL

SELECT 
  'Total Products' AS "Metric",
  COUNT(*) AS "Count"
FROM products

UNION ALL

SELECT 
  'Products with valid store_id' AS "Metric",
  COUNT(*) AS "Count"
FROM products
WHERE store_id IS NOT NULL;
