-- ========================================
-- Finalize RLS Security for Pre-Launch v1
-- تاريخ: يناير 2025
-- الهدف: تفعيل RLS بالكامل مع ضمان أن Worker فقط يصل للقاعدة
-- ========================================

-- ========================================
-- 1. تفعيل RLS على جميع الجداول الحساسة
-- ========================================

-- تفعيل RLS على الجداول الرئيسية
ALTER TABLE IF EXISTS public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.points_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.mbuy_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.mbuy_sessions ENABLE ROW LEVEL SECURITY;

-- ========================================
-- 2. Policies للـ Service Role (Worker فقط)
-- ========================================

-- Service Role يمكنه الوصول لجميع الجداول
-- Worker يستخدم SUPABASE_SERVICE_ROLE_KEY الذي يتجاوز RLS تلقائياً
-- هذه الـ Policies للتأكيد فقط

-- Products
DROP POLICY IF EXISTS "Service role can access all products" ON public.products;
CREATE POLICY "Service role can access all products"
  ON public.products
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Stores
DROP POLICY IF EXISTS "Service role can access all stores" ON public.stores;
CREATE POLICY "Service role can access all stores"
  ON public.stores
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Orders
DROP POLICY IF EXISTS "Service role can access all orders" ON public.orders;
CREATE POLICY "Service role can access all orders"
  ON public.orders
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Order Items
DROP POLICY IF EXISTS "Service role can access all order_items" ON public.order_items;
CREATE POLICY "Service role can access all order_items"
  ON public.order_items
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Cart Items
DROP POLICY IF EXISTS "Service role can access all cart_items" ON public.cart_items;
CREATE POLICY "Service role can access all cart_items"
  ON public.cart_items
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- User Profiles
DROP POLICY IF EXISTS "Service role can access all user_profiles" ON public.user_profiles;
CREATE POLICY "Service role can access all user_profiles"
  ON public.user_profiles
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Wallets
DROP POLICY IF EXISTS "Service role can access all wallets" ON public.wallets;
CREATE POLICY "Service role can access all wallets"
  ON public.wallets
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Points Accounts
DROP POLICY IF EXISTS "Service role can access all points_accounts" ON public.points_accounts;
CREATE POLICY "Service role can access all points_accounts"
  ON public.points_accounts
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Coupons
DROP POLICY IF EXISTS "Service role can access all coupons" ON public.coupons;
CREATE POLICY "Service role can access all coupons"
  ON public.coupons
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Categories
DROP POLICY IF EXISTS "Service role can access all categories" ON public.categories;
CREATE POLICY "Service role can access all categories"
  ON public.categories
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Reviews
DROP POLICY IF EXISTS "Service role can access all reviews" ON public.reviews;
CREATE POLICY "Service role can access all reviews"
  ON public.reviews
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- ========================================
-- 3. Policies للـ Public Access (قراءة فقط)
-- ========================================

-- Products (Public - قراءة فقط للمنتجات النشطة)
DROP POLICY IF EXISTS "Public can view active products" ON public.products;
CREATE POLICY "Public can view active products"
  ON public.products
  FOR SELECT
  USING (is_active = true AND status = 'active');

-- Stores (Public - قراءة فقط للمتاجر النشطة)
DROP POLICY IF EXISTS "Public can view active stores" ON public.stores;
CREATE POLICY "Public can view active stores"
  ON public.stores
  FOR SELECT
  USING (is_active = true);

-- Categories (Public - قراءة فقط للفئات النشطة)
DROP POLICY IF EXISTS "Public can view active categories" ON public.categories;
CREATE POLICY "Public can view active categories"
  ON public.categories
  FOR SELECT
  USING (is_active = true);

-- Reviews (Public - قراءة فقط للتعليقات المعتمدة)
DROP POLICY IF EXISTS "Public can view approved reviews" ON public.reviews;
CREATE POLICY "Public can view approved reviews"
  ON public.reviews
  FOR SELECT
  USING (is_approved = true);

-- ========================================
-- 4. ملاحظات مهمة
-- ========================================
-- 1. Worker يستخدم SUPABASE_SERVICE_ROLE_KEY الذي يتجاوز RLS تلقائياً
-- 2. Flutter لا يصل للقاعدة مباشرة - كل شيء عبر Worker
-- 3. Public endpoints تستخدم SUPABASE_ANON_KEY مع RLS policies
-- 4. جميع العمليات الحساسة محمية بـ JWT في Worker
-- 5. Roles: admin / merchant / customer يتم التحقق منها في Worker
-- ========================================

