-- ========================================
-- RLS Policies الكاملة لجميع الجداول
-- ========================================
-- هذا السكريبت ينشئ RLS Policies لجميع الجداول في قاعدة البيانات
-- لتتوافق مع نظام Custom JWT (mbuy_users)
-- 
-- ملاحظة هامة:
-- نظام RLS هنا للحماية الإضافية فقط
-- Worker يستخدم SERVICE_ROLE_KEY ويتحقق من الصلاحيات يدوياً

-- ========================================
-- 1. تفعيل RLS على جميع الجداول
-- ========================================

-- تفعيل RLS على الجداول الموجودة فعلياً
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- ========================================
-- 2. حذف جميع Policies القديمة
-- ========================================

-- user_profiles
DROP POLICY IF EXISTS "users_view_own_profile" ON user_profiles;
DROP POLICY IF EXISTS "users_update_own_profile" ON user_profiles;
DROP POLICY IF EXISTS "public_view_profiles" ON user_profiles;

-- stores
DROP POLICY IF EXISTS "merchants_crud_own_store" ON stores;
DROP POLICY IF EXISTS "merchants_insert_store" ON stores;
DROP POLICY IF EXISTS "merchants_view_own_store" ON stores;
DROP POLICY IF EXISTS "merchants_update_own_store" ON stores;
DROP POLICY IF EXISTS "merchants_delete_own_store" ON stores;
DROP POLICY IF EXISTS "public_view_active_stores" ON stores;

-- products
DROP POLICY IF EXISTS "merchants_insert_own_products" ON products;
DROP POLICY IF EXISTS "merchants_select_own_products" ON products;
DROP POLICY IF EXISTS "merchants_update_own_products" ON products;
DROP POLICY IF EXISTS "merchants_delete_own_products" ON products;
DROP POLICY IF EXISTS "public_select_active_products" ON products;

-- product_media
DROP POLICY IF EXISTS "merchants_manage_product_media" ON product_media;
DROP POLICY IF EXISTS "public_view_product_media" ON product_media;

-- categories
DROP POLICY IF EXISTS "public_view_categories" ON categories;
DROP POLICY IF EXISTS "admin_manage_categories" ON categories;

-- orders
DROP POLICY IF EXISTS "users_view_own_orders" ON orders;
DROP POLICY IF EXISTS "merchants_view_store_orders" ON orders;
DROP POLICY IF EXISTS "users_create_orders" ON orders;
DROP POLICY IF EXISTS "users_update_own_orders" ON orders;

-- order_items
DROP POLICY IF EXISTS "users_view_own_order_items" ON order_items;
DROP POLICY IF EXISTS "merchants_view_store_order_items" ON order_items;

-- reviews
DROP POLICY IF EXISTS "users_create_reviews" ON reviews;
DROP POLICY IF EXISTS "users_update_own_reviews" ON reviews;
DROP POLICY IF EXISTS "users_delete_own_reviews" ON reviews;
DROP POLICY IF EXISTS "public_view_reviews" ON reviews;

-- wallets
DROP POLICY IF EXISTS "users_view_own_wallet" ON wallets;

-- transactions
DROP POLICY IF EXISTS "users_view_own_transactions" ON transactions;

-- notifications
DROP POLICY IF EXISTS "users_view_own_notifications" ON notifications;
DROP POLICY IF EXISTS "users_update_own_notifications" ON notifications;

-- ========================================
-- 3. user_profiles - Policies
-- ========================================

-- المستخدمون يمكنهم قراءة بروفايلهم فقط
CREATE POLICY "users_view_own_profile"
ON user_profiles
FOR SELECT
TO authenticated
USING (mbuy_user_id = auth.uid());

-- المستخدمون يمكنهم تعديل بروفايلهم فقط
CREATE POLICY "users_update_own_profile"
ON user_profiles
FOR UPDATE
TO authenticated
USING (mbuy_user_id = auth.uid())
WITH CHECK (mbuy_user_id = auth.uid());

-- الجميع يمكنهم رؤية بروفايلات التجار (للمتاجر العامة)
CREATE POLICY "public_view_merchant_profiles"
ON user_profiles
FOR SELECT
TO anon, authenticated
USING (role = 'merchant');

-- ========================================
-- 4. stores - Policies
-- ========================================

-- التجار يمكنهم إنشاء متاجر
CREATE POLICY "merchants_insert_store"
ON stores
FOR INSERT
TO authenticated
WITH CHECK (
  owner_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid() 
    AND role IN ('merchant', 'admin')
  )
);

-- التجار يمكنهم قراءة متاجرهم
CREATE POLICY "merchants_view_own_store"
ON stores
FOR SELECT
TO authenticated
USING (
  owner_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- التجار يمكنهم تعديل متاجرهم
CREATE POLICY "merchants_update_own_store"
ON stores
FOR UPDATE
TO authenticated
USING (
  owner_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
)
WITH CHECK (
  owner_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- التجار يمكنهم حذف متاجرهم
CREATE POLICY "merchants_delete_own_store"
ON stores
FOR DELETE
TO authenticated
USING (
  owner_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- الجميع يمكنهم رؤية المتاجر النشطة
CREATE POLICY "public_view_active_stores"
ON stores
FOR SELECT
TO anon, authenticated
USING (status = 'active');

-- ========================================
-- 5. products - Policies
-- ========================================

-- التجار يمكنهم إضافة منتجات في متاجرهم
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

-- التجار يمكنهم قراءة منتجاتهم
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

-- التجار يمكنهم تعديل منتجاتهم
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

-- التجار يمكنهم حذف منتجاتهم
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

-- الجميع يمكنهم رؤية المنتجات النشطة
CREATE POLICY "public_select_active_products"
ON products
FOR SELECT
TO anon, authenticated
USING (status = 'active' OR is_active = true);

-- ========================================
-- 6. product_media - Policies
-- ========================================

-- التجار يمكنهم إدارة وسائط منتجاتهم
CREATE POLICY "merchants_manage_product_media"
ON product_media
FOR ALL
TO authenticated
USING (
  product_id IN (
    SELECT p.id 
    FROM products p
    INNER JOIN stores s ON p.store_id = s.id
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
)
WITH CHECK (
  product_id IN (
    SELECT p.id 
    FROM products p
    INNER JOIN stores s ON p.store_id = s.id
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);

-- الجميع يمكنهم رؤية وسائط المنتجات النشطة
CREATE POLICY "public_view_product_media"
ON product_media
FOR SELECT
TO anon, authenticated
USING (
  product_id IN (
    SELECT id FROM products 
    WHERE status = 'active' OR is_active = true
  )
);

-- ========================================
-- 7. categories - Policies
-- ========================================

-- الجميع يمكنهم قراءة التصنيفات
CREATE POLICY "public_view_categories"
ON categories
FOR SELECT
TO anon, authenticated
USING (true);

-- فقط Admin يمكنه إدارة التصنيفات (عبر Worker فقط)
-- لا نحتاج policy للـ INSERT/UPDATE/DELETE لأن Worker يستخدم SERVICE_ROLE

-- ========================================
-- 8. orders - Policies
-- ========================================

-- المستخدمون يمكنهم إنشاء طلبات
CREATE POLICY "users_create_orders"
ON orders
FOR INSERT
TO authenticated
WITH CHECK (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- المستخدمون يمكنهم قراءة طلباتهم
CREATE POLICY "users_view_own_orders"
ON orders
FOR SELECT
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- التجار يمكنهم قراءة طلبات متاجرهم
CREATE POLICY "merchants_view_store_orders"
ON orders
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

-- المستخدمون يمكنهم تعديل طلباتهم (للإلغاء مثلاً)
CREATE POLICY "users_update_own_orders"
ON orders
FOR UPDATE
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
)
WITH CHECK (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- ========================================
-- 9. order_items - Policies
-- ========================================

-- المستخدمون يمكنهم قراءة عناصر طلباتهم
CREATE POLICY "users_view_own_order_items"
ON order_items
FOR SELECT
TO authenticated
USING (
  order_id IN (
    SELECT o.id 
    FROM orders o
    INNER JOIN user_profiles up ON o.user_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);

-- التجار يمكنهم قراءة عناصر طلبات متاجرهم
CREATE POLICY "merchants_view_store_order_items"
ON order_items
FOR SELECT
TO authenticated
USING (
  order_id IN (
    SELECT o.id 
    FROM orders o
    INNER JOIN stores s ON o.store_id = s.id
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);

-- ========================================
-- 10. reviews - Policies
-- ========================================

-- المستخدمون يمكنهم إنشاء تقييمات
CREATE POLICY "users_create_reviews"
ON reviews
FOR INSERT
TO authenticated
WITH CHECK (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- المستخدمون يمكنهم تعديل تقييماتهم
CREATE POLICY "users_update_own_reviews"
ON reviews
FOR UPDATE
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
)
WITH CHECK (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- المستخدمون يمكنهم حذف تقييماتهم
CREATE POLICY "users_delete_own_reviews"
ON reviews
FOR DELETE
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- الجميع يمكنهم قراءة التقييمات
CREATE POLICY "public_view_reviews"
ON reviews
FOR SELECT
TO anon, authenticated
USING (true);

-- ========================================
-- 11. wallets - Policies
-- ========================================

-- المستخدمون يمكنهم قراءة محفظتهم فقط
CREATE POLICY "users_view_own_wallet"
ON wallets
FOR SELECT
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- ========================================
-- 12. transactions - Policies
-- ========================================

-- المستخدمون يمكنهم قراءة معاملاتهم فقط
CREATE POLICY "users_view_own_transactions"
ON transactions
FOR SELECT
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- ========================================
-- 13. notifications - Policies
-- ========================================

-- المستخدمون يمكنهم قراءة إشعاراتهم فقط
CREATE POLICY "users_view_own_notifications"
ON notifications
FOR SELECT
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- المستخدمون يمكنهم تعديل إشعاراتهم (تحديث حالة القراءة)
CREATE POLICY "users_update_own_notifications"
ON notifications
FOR UPDATE
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
)
WITH CHECK (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- ========================================
-- 14. التحقق من النجاح
-- ========================================

-- عرض جميع الـ Policies
SELECT 
  tablename,
  policyname,
  cmd,
  roles,
  permissive
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, cmd, policyname;

-- عرض الجداول التي عليها RLS
SELECT 
  tablename,
  rowsecurity AS "RLS Enabled"
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN (
    'user_profiles', 'stores', 'products', 'product_media', 
    'categories', 'orders', 'order_items',
    'reviews', 'wallets', 'transactions', 'notifications'
  )
ORDER BY tablename;

-- ========================================
-- 15. ملاحظات هامة
-- ========================================

/*
⚠️ ملاحظات مهمة:

1. Worker يستخدم SERVICE_ROLE_KEY:
   - هذه Policies للحماية الإضافية فقط
   - Worker يتجاوز RLS تلقائياً
   - Worker يتحقق من الصلاحيات يدوياً في الكود

2. Custom JWT System:
   - نستخدم auth.uid() للحصول على mbuy_user_id
   - يجب أن يكون JWT متوافق مع Supabase Auth
   - أو استخدام SERVICE_ROLE مع التحقق اليدوي

3. للأمان الكامل:
   - استخدم ANON_KEY بدلاً من SERVICE_ROLE
   - حوّل mbuy_users JWT إلى Supabase-compatible JWT
   - دع RLS يتحقق من الصلاحيات تلقائياً

4. الجداول غير المشمولة:
   - mbuy_users (جدول مخصص للـ Auth)
   - أي جداول admin فقط
   - جداول system/metadata

5. للاختبار:
   - استخدم SQL Editor مع User Role
   - جرب SELECT/INSERT/UPDATE/DELETE
   - تأكد من أن RLS يعمل بشكل صحيح
*/
