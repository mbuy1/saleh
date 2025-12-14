-- ========================================
-- إصلاح RLS Policy لجدول products
-- ========================================
-- هذا السكريبت ينشئ Policies تسمح للتجار بإدارة منتجاتهم

-- 1️⃣ حذف أي policies قديمة (إذا وجدت)
DROP POLICY IF EXISTS "merchants_insert_own_products" ON products;
DROP POLICY IF EXISTS "merchants_select_own_products" ON products;
DROP POLICY IF EXISTS "merchants_update_own_products" ON products;
DROP POLICY IF EXISTS "merchants_delete_own_products" ON products;
DROP POLICY IF EXISTS "public_select_active_products" ON products;

-- 2️⃣ Policy: السماح للتجار بإدراج منتجات في متاجرهم
CREATE POLICY "merchants_insert_own_products"
ON products
FOR INSERT
TO authenticated
WITH CHECK (
  store_id IN (
    SELECT s.id 
    FROM stores s
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);

-- 3️⃣ Policy: السماح للتجار بعرض منتجاتهم
CREATE POLICY "merchants_select_own_products"
ON products
FOR SELECT
TO authenticated
USING (
  store_id IN (
    SELECT s.id 
    FROM stores s
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);

-- 4️⃣ Policy: السماح للتجار بتعديل منتجاتهم
CREATE POLICY "merchants_update_own_products"
ON products
FOR UPDATE
TO authenticated
USING (
  store_id IN (
    SELECT s.id 
    FROM stores s
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
)
WITH CHECK (
  store_id IN (
    SELECT s.id 
    FROM stores s
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);

-- 5️⃣ Policy: السماح للتجار بحذف منتجاتهم
CREATE POLICY "merchants_delete_own_products"
ON products
FOR DELETE
TO authenticated
USING (
  store_id IN (
    SELECT s.id 
    FROM stores s
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);

-- 6️⃣ Policy: السماح للجميع (anon + authenticated) بعرض المنتجات النشطة
CREATE POLICY "public_select_active_products"
ON products
FOR SELECT
TO anon, authenticated
USING (status = 'active' OR is_active = true);

-- ========================================
-- التحقق من النجاح
-- ========================================
SELECT 
  policyname,
  cmd,
  roles,
  permissive
FROM pg_policies
WHERE tablename = 'products'
ORDER BY cmd, policyname;
