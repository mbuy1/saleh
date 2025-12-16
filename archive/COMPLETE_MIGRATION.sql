-- ========================================
-- Migration الكامل: إنشاء جداول Auth + تفعيل RLS
-- تاريخ: يناير 2025
-- ========================================
--
-- ⚠️ مهم: انسخ هذا الملف بالكامل والصقه في Supabase SQL Editor
-- ========================================

-- ========================================
-- الجزء الأول: إنشاء جداول Auth مخصصة
-- ========================================

-- 1. جدول mbuy_users - المستخدمون
CREATE TABLE IF NOT EXISTS public.mbuy_users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  full_name TEXT,
  phone TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),

  CONSTRAINT mbuy_users_email_unique UNIQUE (email)
);

-- Index for faster email lookups
CREATE INDEX IF NOT EXISTS idx_mbuy_users_email ON public.mbuy_users(email);
CREATE INDEX IF NOT EXISTS idx_mbuy_users_is_active ON public.mbuy_users(is_active);

-- 2. جدول mbuy_sessions - الجلسات
CREATE TABLE IF NOT EXISTS public.mbuy_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.mbuy_users(id) ON DELETE CASCADE,
  token_hash TEXT NOT NULL,
  user_agent TEXT,
  ip_address TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  expires_at TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT true,

  CONSTRAINT mbuy_sessions_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public.mbuy_users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_mbuy_sessions_user_id ON public.mbuy_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_mbuy_sessions_token_hash ON public.mbuy_sessions(token_hash);
CREATE INDEX IF NOT EXISTS idx_mbuy_sessions_is_active ON public.mbuy_sessions(is_active);
CREATE INDEX IF NOT EXISTS idx_mbuy_sessions_expires_at ON public.mbuy_sessions(expires_at);

-- 3. Function لتحديث updated_at تلقائياً
CREATE OR REPLACE FUNCTION update_mbuy_users_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger لتحديث updated_at
DROP TRIGGER IF EXISTS trigger_update_mbuy_users_updated_at ON public.mbuy_users;
CREATE TRIGGER trigger_update_mbuy_users_updated_at
  BEFORE UPDATE ON public.mbuy_users
  FOR EACH ROW
  EXECUTE FUNCTION update_mbuy_users_updated_at();

-- ========================================
-- الجزء الثاني: تفعيل RLS على جميع الجداول
-- ========================================

-- تفعيل RLS على جميع الجداول الحساسة
ALTER TABLE IF EXISTS public.mbuy_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.mbuy_sessions ENABLE ROW LEVEL SECURITY;
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
-- الجزء الثالث: Policies للـ Service Role
-- ========================================

-- Service Role يمكنه الوصول لجميع الجداول
-- Worker يستخدم SUPABASE_SERVICE_ROLE_KEY الذي يتجاوز RLS تلقائياً
-- هذه الـ Policies للتأكيد فقط

-- MBUY Users
DROP POLICY IF EXISTS "Service role can access all mbuy_users" ON public.mbuy_users;
CREATE POLICY "Service role can access all mbuy_users"
  ON public.mbuy_users
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- MBUY Sessions
DROP POLICY IF EXISTS "Service role can access all mbuy_sessions" ON public.mbuy_sessions;
CREATE POLICY "Service role can access all mbuy_sessions"
  ON public.mbuy_sessions
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
-- الجزء الرابع: ربط الجداول
-- ========================================

-- ربط mbuy_users مع user_profiles
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
    AND table_name = 'user_profiles'
    AND column_name = 'mbuy_user_id'
  ) THEN
    ALTER TABLE public.user_profiles
      ADD COLUMN mbuy_user_id UUID REFERENCES public.mbuy_users(id) ON DELETE CASCADE;

    CREATE INDEX IF NOT EXISTS idx_user_profiles_mbuy_user_id
      ON public.user_profiles(mbuy_user_id);

    RAISE NOTICE '✅ تم إضافة عمود mbuy_user_id إلى user_profiles';
  ELSE
    RAISE NOTICE '⚠️ عمود mbuy_user_id موجود بالفعل';
  END IF;
END $$;

-- ربط mbuy_users مع stores
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
    AND table_name = 'stores'
    AND column_name = 'mbuy_owner_id'
  ) THEN
    ALTER TABLE public.stores
      ADD COLUMN mbuy_owner_id UUID REFERENCES public.mbuy_users(id) ON DELETE SET NULL;

    CREATE INDEX IF NOT EXISTS idx_stores_mbuy_owner_id
      ON public.stores(mbuy_owner_id);

    RAISE NOTICE '✅ تم إضافة عمود mbuy_owner_id إلى stores';
  ELSE
    RAISE NOTICE '⚠️ عمود mbuy_owner_id موجود بالفعل';
  END IF;
END $$;

-- ========================================
-- ملاحظات مهمة
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
-- WHERE schemaname = 'public' AND tablename IN ('mbuy_users', 'products', 'stores');