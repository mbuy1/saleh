-- ========================================
-- التحقق السريع من حالة المتجر
-- ========================================
-- استخدم هذا في Supabase SQL Editor

-- 1️⃣ عرض جميع المتاجر مع حالتها
SELECT 
  id AS "Store ID",
  owner_id AS "Owner Profile ID",
  name AS "Store Name",
  status AS "Status",
  created_at AS "Created At"
FROM stores
ORDER BY created_at DESC;

-- 2️⃣ عرض التجار ومتاجرهم
SELECT 
  up.id AS "Profile ID",
  up.mbuy_user_id AS "mbuy_user_id (JWT.sub)",
  up.email AS "Email",
  up.role AS "Role",
  s.id AS "Store ID",
  s.name AS "Store Name",
  s.status AS "Status"
FROM user_profiles up
LEFT JOIN stores s ON s.owner_id = up.id
WHERE up.role = 'merchant'
ORDER BY up.created_at DESC;

-- 3️⃣ إحصائيات سريعة
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
  'Inactive Stores' AS "Metric",
  COUNT(*) AS "Count"
FROM stores
WHERE status != 'active';

-- 4️⃣ إذا كان هناك متجر بحالة غير 'active'، فعّله:
/*
UPDATE stores 
SET status = 'active'
WHERE id = 'STORE_ID_HERE';
*/

-- 5️⃣ إنشاء متجر جديد لتاجر (إذا لزم)
/*
-- أولاً، احصل على profile_id للتاجر
SELECT id, email FROM user_profiles WHERE role = 'merchant';

-- ثم أنشئ المتجر
INSERT INTO stores (owner_id, name, description, status)
VALUES (
  'PROFILE_ID_HERE'::UUID,
  'متجر تجريبي',
  'وصف المتجر',
  'active'
)
RETURNING *;
*/
