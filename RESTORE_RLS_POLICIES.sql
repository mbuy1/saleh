-- ========================================
-- RLS Policies Template - MBUY Platform
-- لاستخدامها بعد إصلاح التسجيل
-- ========================================

-- ========================================
-- user_profiles - RLS Policies
-- ========================================

-- Enable RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- Policy 1: postgres role (للـ triggers)
DROP POLICY IF EXISTS "postgres_role_all_access" ON public.user_profiles;
CREATE POLICY "postgres_role_all_access"
  ON public.user_profiles
  TO postgres
  USING (true)
  WITH CHECK (true);

-- Policy 2: service_role (للـ Worker)
DROP POLICY IF EXISTS "service_role_full_access" ON public.user_profiles;
CREATE POLICY "service_role_full_access"
  ON public.user_profiles
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Policy 3: Users see own profile
DROP POLICY IF EXISTS "users_view_own_profile" ON public.user_profiles;
CREATE POLICY "users_view_own_profile"
  ON public.user_profiles
  FOR SELECT
  TO authenticated
  USING (id = auth.uid());

-- Policy 4: Users update own profile
DROP POLICY IF EXISTS "users_update_own_profile" ON public.user_profiles;
CREATE POLICY "users_update_own_profile"
  ON public.user_profiles
  FOR UPDATE
  TO authenticated
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- Policy 5: Admins see all
DROP POLICY IF EXISTS "admins_view_all_profiles" ON public.user_profiles;
CREATE POLICY "admins_view_all_profiles"
  ON public.user_profiles
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.user_profiles up
      WHERE up.id = auth.uid() AND up.role = 'admin'
    )
  );

-- ========================================
-- stores - RLS Policies
-- ========================================

ALTER TABLE public.stores ENABLE ROW LEVEL SECURITY;

-- Service role full access
DROP POLICY IF EXISTS "service_role_stores_access" ON public.stores;
CREATE POLICY "service_role_stores_access"
  ON public.stores
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Public can view active stores
DROP POLICY IF EXISTS "public_view_active_stores" ON public.stores;
CREATE POLICY "public_view_active_stores"
  ON public.stores
  FOR SELECT
  TO anon, authenticated
  USING (status = 'active' AND visibility = 'public');

-- Owners can manage their stores
DROP POLICY IF EXISTS "owners_manage_own_stores" ON public.stores;
CREATE POLICY "owners_manage_own_stores"
  ON public.stores
  FOR ALL
  TO authenticated
  USING (owner_id = auth.uid())
  WITH CHECK (owner_id = auth.uid());

-- ========================================
-- products - RLS Policies
-- ========================================

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- Service role full access
DROP POLICY IF EXISTS "service_role_products_access" ON public.products;
CREATE POLICY "service_role_products_access"
  ON public.products
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Public can view active products from active stores
DROP POLICY IF EXISTS "public_view_active_products" ON public.products;
CREATE POLICY "public_view_active_products"
  ON public.products
  FOR SELECT
  TO anon, authenticated
  USING (
    status = 'active'
    AND EXISTS (
      SELECT 1 FROM public.stores s
      WHERE s.id = store_id
      AND s.status = 'active'
      AND s.visibility = 'public'
    )
  );

-- Store owners manage their products
DROP POLICY IF EXISTS "store_owners_manage_products" ON public.products;
CREATE POLICY "store_owners_manage_products"
  ON public.products
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.stores s
      WHERE s.id = store_id
      AND s.owner_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.stores s
      WHERE s.id = store_id
      AND s.owner_id = auth.uid()
    )
  );

-- ========================================
-- orders - RLS Policies
-- ========================================

ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- Service role full access
DROP POLICY IF EXISTS "service_role_orders_access" ON public.orders;
CREATE POLICY "service_role_orders_access"
  ON public.orders
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Customers view their orders
DROP POLICY IF EXISTS "customers_view_own_orders" ON public.orders;
CREATE POLICY "customers_view_own_orders"
  ON public.orders
  FOR SELECT
  TO authenticated
  USING (customer_id = auth.uid());

-- Merchants view orders for their stores
DROP POLICY IF EXISTS "merchants_view_store_orders" ON public.orders;
CREATE POLICY "merchants_view_store_orders"
  ON public.orders
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.stores s
      WHERE s.id = store_id
      AND s.owner_id = auth.uid()
    )
  );

-- ========================================
-- wallets - RLS Policies
-- ========================================

ALTER TABLE public.wallets ENABLE ROW LEVEL SECURITY;

-- Service role full access
DROP POLICY IF EXISTS "service_role_wallets_access" ON public.wallets;
CREATE POLICY "service_role_wallets_access"
  ON public.wallets
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Users view their own wallets
DROP POLICY IF EXISTS "users_view_own_wallets" ON public.wallets;
CREATE POLICY "users_view_own_wallets"
  ON public.wallets
  FOR SELECT
  TO authenticated
  USING (owner_id = auth.uid());

-- Users cannot directly modify wallets (only through Worker)
DROP POLICY IF EXISTS "users_cannot_modify_wallets" ON public.wallets;
CREATE POLICY "users_cannot_modify_wallets"
  ON public.wallets
  FOR UPDATE
  TO authenticated
  USING (false)
  WITH CHECK (false);

-- ========================================
-- wallet_transactions - RLS Policies
-- ========================================

ALTER TABLE public.wallet_transactions ENABLE ROW LEVEL SECURITY;

-- Service role full access
DROP POLICY IF EXISTS "service_role_wallet_transactions_access" ON public.wallet_transactions;
CREATE POLICY "service_role_wallet_transactions_access"
  ON public.wallet_transactions
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Users view their own transactions
DROP POLICY IF EXISTS "users_view_own_transactions" ON public.wallet_transactions;
CREATE POLICY "users_view_own_transactions"
  ON public.wallet_transactions
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.wallets w
      WHERE w.id = wallet_id
      AND w.owner_id = auth.uid()
    )
  );

-- ========================================
-- points_accounts - RLS Policies
-- ========================================

ALTER TABLE public.points_accounts ENABLE ROW LEVEL SECURITY;

-- Service role full access
DROP POLICY IF EXISTS "service_role_points_access" ON public.points_accounts;
CREATE POLICY "service_role_points_access"
  ON public.points_accounts
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Users view their own points
DROP POLICY IF EXISTS "users_view_own_points" ON public.points_accounts;
CREATE POLICY "users_view_own_points"
  ON public.points_accounts
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- ========================================
-- favorites - RLS Policies
-- ========================================

ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;

-- Service role full access
DROP POLICY IF EXISTS "service_role_favorites_access" ON public.favorites;
CREATE POLICY "service_role_favorites_access"
  ON public.favorites
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Users manage their own favorites
DROP POLICY IF EXISTS "users_manage_own_favorites" ON public.favorites;
CREATE POLICY "users_manage_own_favorites"
  ON public.favorites
  FOR ALL
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- ========================================
-- carts - RLS Policies
-- ========================================

ALTER TABLE public.carts ENABLE ROW LEVEL SECURITY;

-- Service role full access
DROP POLICY IF EXISTS "service_role_carts_access" ON public.carts;
CREATE POLICY "service_role_carts_access"
  ON public.carts
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Users manage their own cart
DROP POLICY IF EXISTS "users_manage_own_cart" ON public.carts;
CREATE POLICY "users_manage_own_cart"
  ON public.carts
  FOR ALL
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- ========================================
-- cart_items - RLS Policies
-- ========================================

ALTER TABLE public.cart_items ENABLE ROW LEVEL SECURITY;

-- Service role full access
DROP POLICY IF EXISTS "service_role_cart_items_access" ON public.cart_items;
CREATE POLICY "service_role_cart_items_access"
  ON public.cart_items
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Users manage items in their cart
DROP POLICY IF EXISTS "users_manage_own_cart_items" ON public.cart_items;
CREATE POLICY "users_manage_own_cart_items"
  ON public.cart_items
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.carts c
      WHERE c.id = cart_id
      AND c.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.carts c
      WHERE c.id = cart_id
      AND c.user_id = auth.uid()
    )
  );

-- ========================================
-- messages - RLS Policies
-- ========================================

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- Service role full access
DROP POLICY IF EXISTS "service_role_messages_access" ON public.messages;
CREATE POLICY "service_role_messages_access"
  ON public.messages
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Participants can view messages
DROP POLICY IF EXISTS "participants_view_messages" ON public.messages;
CREATE POLICY "participants_view_messages"
  ON public.messages
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.conversations conv
      WHERE conv.id = conversation_id
      AND (conv.customer_id = auth.uid() OR 
           EXISTS (SELECT 1 FROM public.stores s 
                   WHERE s.id = conv.merchant_id 
                   AND s.owner_id = auth.uid()))
    )
  );

-- Participants can send messages
DROP POLICY IF EXISTS "participants_send_messages" ON public.messages;
CREATE POLICY "participants_send_messages"
  ON public.messages
  FOR INSERT
  TO authenticated
  WITH CHECK (
    sender_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.conversations conv
      WHERE conv.id = conversation_id
      AND (conv.customer_id = auth.uid() OR 
           EXISTS (SELECT 1 FROM public.stores s 
                   WHERE s.id = conv.merchant_id 
                   AND s.owner_id = auth.uid()))
    )
  );

-- ========================================
-- Verification Script
-- ========================================

DO $$
DECLARE
  table_name TEXT;
  rls_enabled BOOLEAN;
  policy_count INT;
BEGIN
  RAISE NOTICE '====================================';
  RAISE NOTICE 'RLS Status Check';
  RAISE NOTICE '====================================';
  
  FOR table_name IN 
    SELECT tablename FROM pg_tables 
    WHERE schemaname = 'public' 
    AND tablename IN (
      'user_profiles', 'stores', 'products', 'orders', 
      'wallets', 'wallet_transactions', 'points_accounts',
      'favorites', 'carts', 'cart_items', 'messages'
    )
    ORDER BY tablename
  LOOP
    -- Check RLS enabled
    SELECT rowsecurity INTO rls_enabled
    FROM pg_tables
    WHERE schemaname = 'public' AND tablename = table_name;
    
    -- Count policies
    SELECT COUNT(*) INTO policy_count
    FROM pg_policies
    WHERE schemaname = 'public' AND tablename = table_name;
    
    RAISE NOTICE '% - RLS: % | Policies: %', 
      table_name, 
      CASE WHEN rls_enabled THEN '✅' ELSE '❌' END,
      policy_count;
  END LOOP;
  
  RAISE NOTICE '====================================';
END $$;
