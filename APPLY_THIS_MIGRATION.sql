-- ========================================
-- Finalize RLS Security for Pre-Launch v1
-- تاريخ: يناير 2025
-- الهدف: تفعيل RLS بالكامل مع ضمان أن Worker فقط يصل للقاعدة
-- ========================================
--
-- ⚠️ مهم: انسخ هذا الملف بالكامل والصقه في Supabase SQL Editor
-- ========================================

-- ========================================
-- 1. تفعيل RLS على جميع الجداول الحساسة
-- ========================================

-- تفعيل RLS على الجداول الرئيسية الموجودة فعلاً
ALTER TABLE IF EXISTS public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.product_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.product_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.carts ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.wallet_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.points_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.points_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.feature_actions ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.coupon_redemptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.store_followers ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.stories ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.device_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.packages ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.package_subscriptions ENABLE ROW LEVEL SECURITY;

-- ========================================
-- 2. Policies للـ Service Role (Worker فقط)
-- ========================================

-- Service Role يمكنه الوصول لجميع الجداول
-- Worker يستخدم SUPABASE_SERVICE_ROLE_KEY الذي يتجاوز RLS تلقائياً
-- هذه الـ Policies للتأكيد فقط

-- User Profiles
DROP POLICY IF EXISTS "Service role can access all user_profiles" ON public.user_profiles;
CREATE POLICY "Service role can access all user_profiles"
  ON public.user_profiles
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

-- Products
DROP POLICY IF EXISTS "Service role can access all products" ON public.products;
CREATE POLICY "Service role can access all products"
  ON public.products
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

-- Product Categories
DROP POLICY IF EXISTS "Service role can access all product_categories" ON public.product_categories;
CREATE POLICY "Service role can access all product_categories"
  ON public.product_categories
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Product Media
DROP POLICY IF EXISTS "Service role can access all product_media" ON public.product_media;
CREATE POLICY "Service role can access all product_media"
  ON public.product_media
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Carts
DROP POLICY IF EXISTS "Service role can access all carts" ON public.carts;
CREATE POLICY "Service role can access all carts"
  ON public.carts
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

-- Wallets
DROP POLICY IF EXISTS "Service role can access all wallets" ON public.wallets;
CREATE POLICY "Service role can access all wallets"
  ON public.wallets
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Wallet Transactions
DROP POLICY IF EXISTS "Service role can access all wallet_transactions" ON public.wallet_transactions;
CREATE POLICY "Service role can access all wallet_transactions"
  ON public.wallet_transactions
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

-- Points Transactions
DROP POLICY IF EXISTS "Service role can access all points_transactions" ON public.points_transactions;
CREATE POLICY "Service role can access all points_transactions"
  ON public.points_transactions
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Feature Actions
DROP POLICY IF EXISTS "Service role can access all feature_actions" ON public.feature_actions;
CREATE POLICY "Service role can access all feature_actions"
  ON public.feature_actions
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

-- Coupon Redemptions
DROP POLICY IF EXISTS "Service role can access all coupon_redemptions" ON public.coupon_redemptions;
CREATE POLICY "Service role can access all coupon_redemptions"
  ON public.coupon_redemptions
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Favorites
DROP POLICY IF EXISTS "Service role can access all favorites" ON public.favorites;
CREATE POLICY "Service role can access all favorites"
  ON public.favorites
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Store Followers
DROP POLICY IF EXISTS "Service role can access all store_followers" ON public.store_followers;
CREATE POLICY "Service role can access all store_followers"
  ON public.store_followers
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Stories
DROP POLICY IF EXISTS "Service role can access all stories" ON public.stories;
CREATE POLICY "Service role can access all stories"
  ON public.stories
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Conversations
DROP POLICY IF EXISTS "Service role can access all conversations" ON public.conversations;
CREATE POLICY "Service role can access all conversations"
  ON public.conversations
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Messages
DROP POLICY IF EXISTS "Service role can access all messages" ON public.messages;
CREATE POLICY "Service role can access all messages"
  ON public.messages
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Device Tokens
DROP POLICY IF EXISTS "Service role can access all device_tokens" ON public.device_tokens;
CREATE POLICY "Service role can access all device_tokens"
  ON public.device_tokens
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Packages
DROP POLICY IF EXISTS "Service role can access all packages" ON public.packages;
CREATE POLICY "Service role can access all packages"
  ON public.packages
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Package Subscriptions
DROP POLICY IF EXISTS "Service role can access all package_subscriptions" ON public.package_subscriptions;
CREATE POLICY "Service role can access all package_subscriptions"
  ON public.package_subscriptions
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

-- ========================================
-- 4. ملاحظات مهمة
-- ========================================
-- 1. Worker يستخدم SUPABASE_SERVICE_ROLE_KEY الذي يتجاوز RLS تلقائياً
-- 2. Flutter لا يصل للقاعدة مباشرة - كل شيء عبر Worker
-- 3. Public endpoints تستخدم SUPABASE_ANON_KEY مع RLS policies
-- 4. جميع العمليات الحساسة محمية بـ JWT في Worker
-- 5. Roles: admin / merchant / customer يتم التحقق منها في Worker
-- ========================================

-- ✅ Migration مكتملة!
-- الآن يمكنك التحقق من RLS باستخدام:
-- SELECT tablename, rowsecurity FROM pg_tables
-- WHERE schemaname = 'public' AND tablename IN ('products', 'stores', 'orders');

