-- ========================================
-- فحص RLS Policies على جدول products
-- ========================================

-- 1️⃣ عرض جميع الـ policies على products
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual AS "USING expression",
  with_check AS "WITH CHECK expression"
FROM pg_policies
WHERE tablename = 'products'
ORDER BY cmd, policyname;

-- 2️⃣ التحقق من RLS enabled على products
SELECT 
  schemaname,
  tablename,
  rowsecurity AS "RLS Enabled"
FROM pg_tables
WHERE tablename = 'products';

-- 3️⃣ فحص الأعمدة في جدول products
SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_name = 'products'
  AND column_name IN ('id', 'store_id', 'name', 'price', 'stock')
ORDER BY ordinal_position;

-- 4️⃣ محاولة INSERT بدون RLS (كـ service_role)
-- هذا سيعمل فقط إذا كنت تستخدم SERVICE_ROLE_KEY
/*
INSERT INTO products (store_id, name, description, price, stock, category_id)
VALUES (
  'dc765202-e121-4bc8-9911-2c55e7254005'::UUID,
  'اختبار RLS',
  'منتج تجريبي',
  10.00,
  5,
  '9373e2a6-3782-4001-8883-6687998a65c0'::UUID
)
RETURNING *;
*/
