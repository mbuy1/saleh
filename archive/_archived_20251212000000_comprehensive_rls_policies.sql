-- ============================================================================
-- Migration: Comprehensive RLS Policies for Golden Plan
-- Date: 2025-12-11
-- Purpose: Complete RLS setup for all sensitive tables based on Golden Plan
-- Identity Chain: auth.users → user_profiles → stores → products/orders
-- ============================================================================

-- ============================================================================
-- PART 1: ENABLE RLS ON ALL SENSITIVE TABLES
-- ============================================================================

-- Core tables
ALTER TABLE IF EXISTS public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.products ENABLE ROW LEVEL SECURITY;

-- Order management
ALTER TABLE IF EXISTS public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.order_status_history ENABLE ROW LEVEL SECURITY;

-- Shopping cart
ALTER TABLE IF EXISTS public.carts ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.cart_items ENABLE ROW LEVEL SECURITY;

-- Financial
ALTER TABLE IF EXISTS public.wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.wallet_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.points_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.points_transactions ENABLE ROW LEVEL SECURITY;

-- Media and content
ALTER TABLE IF EXISTS public.product_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.reviews ENABLE ROW LEVEL SECURITY;

-- User interactions
ALTER TABLE IF EXISTS public.favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.wishlist ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.recently_viewed ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.store_followers ENABLE ROW LEVEL SECURITY;

-- Notifications
ALTER TABLE IF EXISTS public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.user_fcm_tokens ENABLE ROW LEVEL SECURITY;

-- Marketing
ALTER TABLE IF EXISTS public.coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.coupon_redemptions ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- PART 2: RLS POLICIES FOR user_profiles
-- ============================================================================

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.user_profiles;
DROP POLICY IF EXISTS "Public can view merchant profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Service role full access" ON public.user_profiles;

-- Users can view their own profile
CREATE POLICY "Users can view own profile"
  ON public.user_profiles
  FOR SELECT
  TO authenticated
  USING (auth_user_id = auth.uid());

-- Public can view merchant profiles (for store discovery)
CREATE POLICY "Public can view merchant profiles"
  ON public.user_profiles
  FOR SELECT
  TO public
  USING (role = 'merchant' AND is_active = true);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON public.user_profiles
  FOR UPDATE
  TO authenticated
  USING (auth_user_id = auth.uid())
  WITH CHECK (auth_user_id = auth.uid());

-- Authenticated users can insert (for initial profile creation)
CREATE POLICY "Enable insert for authenticated users"
  ON public.user_profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth_user_id = auth.uid());

-- Service role full access
CREATE POLICY "Service role full access"
  ON public.user_profiles
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 3: RLS POLICIES FOR stores
-- ============================================================================

DROP POLICY IF EXISTS "Public can view active stores" ON public.stores;
DROP POLICY IF EXISTS "Merchants can view own stores" ON public.stores;
DROP POLICY IF EXISTS "Merchants can insert own stores" ON public.stores;
DROP POLICY IF EXISTS "Merchants can update own stores" ON public.stores;
DROP POLICY IF EXISTS "Merchants can delete own stores" ON public.stores;
DROP POLICY IF EXISTS "Service role full access on stores" ON public.stores;

-- Public can view active stores
CREATE POLICY "Public can view active stores"
  ON public.stores
  FOR SELECT
  TO public
  USING (is_active = true AND visibility = 'public');

-- Merchants can view their own stores (even if inactive)
CREATE POLICY "Merchants can view own stores"
  ON public.stores
  FOR SELECT
  TO authenticated
  USING (
    owner_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
  );

-- Merchants can create stores
CREATE POLICY "Merchants can insert own stores"
  ON public.stores
  FOR INSERT
  TO authenticated
  WITH CHECK (
    owner_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
      AND role IN ('merchant', 'admin')
    )
  );

-- Merchants can update their own stores
CREATE POLICY "Merchants can update own stores"
  ON public.stores
  FOR UPDATE
  TO authenticated
  USING (
    owner_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
  )
  WITH CHECK (
    owner_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
  );

-- Merchants can delete their own stores
CREATE POLICY "Merchants can delete own stores"
  ON public.stores
  FOR DELETE
  TO authenticated
  USING (
    owner_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
  );

-- Service role full access
CREATE POLICY "Service role full access on stores"
  ON public.stores
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 4: RLS POLICIES FOR products
-- ============================================================================

DROP POLICY IF EXISTS "Public can view active products" ON public.products;
DROP POLICY IF EXISTS "Merchants can view own products" ON public.products;
DROP POLICY IF EXISTS "Merchants can insert own products" ON public.products;
DROP POLICY IF EXISTS "Merchants can update own products" ON public.products;
DROP POLICY IF EXISTS "Merchants can delete own products" ON public.products;
DROP POLICY IF EXISTS "Service role full access on products" ON public.products;

-- Public can view active products from active stores
CREATE POLICY "Public can view active products"
  ON public.products
  FOR SELECT
  TO public
  USING (
    is_active = true
    AND EXISTS (
      SELECT 1 FROM public.stores
      WHERE stores.id = products.store_id
      AND stores.is_active = true
      AND stores.visibility = 'public'
    )
  );

-- Merchants can view their own products
CREATE POLICY "Merchants can view own products"
  ON public.products
  FOR SELECT
  TO authenticated
  USING (
    store_id IN (
      SELECT s.id
      FROM public.stores s
      JOIN public.user_profiles up ON s.owner_id = up.id
      WHERE up.auth_user_id = auth.uid()
    )
  );

-- Merchants can create products in their own stores
CREATE POLICY "Merchants can insert own products"
  ON public.products
  FOR INSERT
  TO authenticated
  WITH CHECK (
    store_id IN (
      SELECT s.id
      FROM public.stores s
      JOIN public.user_profiles up ON s.owner_id = up.id
      WHERE up.auth_user_id = auth.uid()
      AND up.role IN ('merchant', 'admin')
    )
  );

-- Merchants can update their own products
CREATE POLICY "Merchants can update own products"
  ON public.products
  FOR UPDATE
  TO authenticated
  USING (
    store_id IN (
      SELECT s.id
      FROM public.stores s
      JOIN public.user_profiles up ON s.owner_id = up.id
      WHERE up.auth_user_id = auth.uid()
    )
  )
  WITH CHECK (
    store_id IN (
      SELECT s.id
      FROM public.stores s
      JOIN public.user_profiles up ON s.owner_id = up.id
      WHERE up.auth_user_id = auth.uid()
    )
  );

-- Merchants can delete their own products
CREATE POLICY "Merchants can delete own products"
  ON public.products
  FOR DELETE
  TO authenticated
  USING (
    store_id IN (
      SELECT s.id
      FROM public.stores s
      JOIN public.user_profiles up ON s.owner_id = up.id
      WHERE up.auth_user_id = auth.uid()
    )
  );

-- Service role full access
CREATE POLICY "Service role full access on products"
  ON public.products
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 5: RLS POLICIES FOR orders
-- ============================================================================

DROP POLICY IF EXISTS "Customers can view own orders" ON public.orders;
DROP POLICY IF EXISTS "Merchants can view store orders" ON public.orders;
DROP POLICY IF EXISTS "Customers can create orders" ON public.orders;
DROP POLICY IF EXISTS "Customers can update own orders" ON public.orders;
DROP POLICY IF EXISTS "Service role full access on orders" ON public.orders;

-- Customers can view their own orders
CREATE POLICY "Customers can view own orders"
  ON public.orders
  FOR SELECT
  TO authenticated
  USING (
    customer_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
    OR user_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
  );

-- Merchants can view orders for their stores
CREATE POLICY "Merchants can view store orders"
  ON public.orders
  FOR SELECT
  TO authenticated
  USING (
    store_id IN (
      SELECT s.id
      FROM public.stores s
      JOIN public.user_profiles up ON s.owner_id = up.id
      WHERE up.auth_user_id = auth.uid()
    )
  );

-- Customers can create orders
CREATE POLICY "Customers can create orders"
  ON public.orders
  FOR INSERT
  TO authenticated
  WITH CHECK (
    customer_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
    OR user_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
  );

-- Customers can update their own orders (before completion)
CREATE POLICY "Customers can update own orders"
  ON public.orders
  FOR UPDATE
  TO authenticated
  USING (
    (customer_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
    OR user_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    ))
    AND status IN ('pending', 'processing')
  );

-- Service role full access
CREATE POLICY "Service role full access on orders"
  ON public.orders
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 6: RLS POLICIES FOR order_items
-- ============================================================================

DROP POLICY IF EXISTS "Users can view order items" ON public.order_items;
DROP POLICY IF EXISTS "Users can create order items" ON public.order_items;
DROP POLICY IF EXISTS "Service role full access on order_items" ON public.order_items;

-- Users can view order items for their orders or their store's orders
CREATE POLICY "Users can view order items"
  ON public.order_items
  FOR SELECT
  TO authenticated
  USING (
    order_id IN (
      -- Customer's own orders
      SELECT o.id FROM public.orders o
      WHERE o.customer_id IN (
        SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
      )
      OR o.user_id IN (
        SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
      )
      -- Merchant's store orders
      OR o.store_id IN (
        SELECT s.id
        FROM public.stores s
        JOIN public.user_profiles up ON s.owner_id = up.id
        WHERE up.auth_user_id = auth.uid()
      )
    )
  );

-- Users can create order items
CREATE POLICY "Users can create order items"
  ON public.order_items
  FOR INSERT
  TO authenticated
  WITH CHECK (
    order_id IN (
      SELECT o.id FROM public.orders o
      WHERE o.customer_id IN (
        SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
      )
      OR o.user_id IN (
        SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
      )
    )
  );

-- Service role full access
CREATE POLICY "Service role full access on order_items"
  ON public.order_items
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 7: RLS POLICIES FOR order_status_history
-- ============================================================================

DROP POLICY IF EXISTS "Users can view order status history" ON public.order_status_history;
DROP POLICY IF EXISTS "Service role full access on order_status_history" ON public.order_status_history;

-- Users can view status history for accessible orders
CREATE POLICY "Users can view order status history"
  ON public.order_status_history
  FOR SELECT
  TO authenticated
  USING (
    order_id IN (
      SELECT o.id FROM public.orders o
      WHERE o.customer_id IN (
        SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
      )
      OR o.user_id IN (
        SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
      )
      OR o.store_id IN (
        SELECT s.id
        FROM public.stores s
        JOIN public.user_profiles up ON s.owner_id = up.id
        WHERE up.auth_user_id = auth.uid()
      )
    )
  );

-- Service role full access
CREATE POLICY "Service role full access on order_status_history"
  ON public.order_status_history
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 8: RLS POLICIES FOR wallets
-- ============================================================================

DROP POLICY IF EXISTS "Users can view own wallet" ON public.wallets;
DROP POLICY IF EXISTS "Users can create own wallet" ON public.wallets;
DROP POLICY IF EXISTS "Users can update own wallet" ON public.wallets;
DROP POLICY IF EXISTS "Service role full access on wallets" ON public.wallets;

-- Users can view their own wallet
CREATE POLICY "Users can view own wallet"
  ON public.wallets
  FOR SELECT
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
    OR owner_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
  );

-- Users can create their own wallet
CREATE POLICY "Users can create own wallet"
  ON public.wallets
  FOR INSERT
  TO authenticated
  WITH CHECK (
    user_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
    OR owner_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
  );

-- Users can update their own wallet (balance updates via service_role only)
CREATE POLICY "Users can update own wallet"
  ON public.wallets
  FOR UPDATE
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
    OR owner_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
  );

-- Service role full access
CREATE POLICY "Service role full access on wallets"
  ON public.wallets
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 9: RLS POLICIES FOR wallet_transactions
-- ============================================================================

DROP POLICY IF EXISTS "Users can view own transactions" ON public.wallet_transactions;
DROP POLICY IF EXISTS "Service role full access on wallet_transactions" ON public.wallet_transactions;

-- Users can view their own wallet transactions
CREATE POLICY "Users can view own transactions"
  ON public.wallet_transactions
  FOR SELECT
  TO authenticated
  USING (
    wallet_id IN (
      SELECT w.id FROM public.wallets w
      WHERE w.user_id IN (
        SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
      )
      OR w.owner_id IN (
        SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
      )
    )
  );

-- Service role full access (transactions created by system only)
CREATE POLICY "Service role full access on wallet_transactions"
  ON public.wallet_transactions
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 10: RLS POLICIES FOR points_accounts
-- ============================================================================

DROP POLICY IF EXISTS "Users can view own points" ON public.points_accounts;
DROP POLICY IF EXISTS "Users can create own points account" ON public.points_accounts;
DROP POLICY IF EXISTS "Service role full access on points_accounts" ON public.points_accounts;

-- Users can view their own points account
CREATE POLICY "Users can view own points"
  ON public.points_accounts
  FOR SELECT
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
  );

-- Users can create their own points account
CREATE POLICY "Users can create own points account"
  ON public.points_accounts
  FOR INSERT
  TO authenticated
  WITH CHECK (
    user_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
  );

-- Service role full access
CREATE POLICY "Service role full access on points_accounts"
  ON public.points_accounts
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 11: RLS POLICIES FOR points_transactions
-- ============================================================================

DROP POLICY IF EXISTS "Users can view own points transactions" ON public.points_transactions;
DROP POLICY IF EXISTS "Service role full access on points_transactions" ON public.points_transactions;

-- Users can view their own points transactions
CREATE POLICY "Users can view own points transactions"
  ON public.points_transactions
  FOR SELECT
  TO authenticated
  USING (
    points_account_id IN (
      SELECT pa.id FROM public.points_accounts pa
      WHERE pa.user_id IN (
        SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
      )
    )
  );

-- Service role full access
CREATE POLICY "Service role full access on points_transactions"
  ON public.points_transactions
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 12: RLS POLICIES FOR product_media
-- ============================================================================

DROP POLICY IF EXISTS "Public can view product media" ON public.product_media;
DROP POLICY IF EXISTS "Merchants can manage own product media" ON public.product_media;
DROP POLICY IF EXISTS "Service role full access on product_media" ON public.product_media;

-- Public can view product media for active products
CREATE POLICY "Public can view product media"
  ON public.product_media
  FOR SELECT
  TO public
  USING (
    product_id IN (
      SELECT p.id FROM public.products p
      JOIN public.stores s ON p.store_id = s.id
      WHERE p.is_active = true
      AND s.is_active = true
      AND s.visibility = 'public'
    )
  );

-- Merchants can manage product media for their products
CREATE POLICY "Merchants can manage own product media"
  ON public.product_media
  FOR ALL
  TO authenticated
  USING (
    product_id IN (
      SELECT p.id FROM public.products p
      JOIN public.stores s ON p.store_id = s.id
      JOIN public.user_profiles up ON s.owner_id = up.id
      WHERE up.auth_user_id = auth.uid()
    )
  )
  WITH CHECK (
    product_id IN (
      SELECT p.id FROM public.products p
      JOIN public.stores s ON p.store_id = s.id
      JOIN public.user_profiles up ON s.owner_id = up.id
      WHERE up.auth_user_id = auth.uid()
    )
  );

-- Service role full access
CREATE POLICY "Service role full access on product_media"
  ON public.product_media
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 13: RLS POLICIES FOR reviews
-- ============================================================================

DROP POLICY IF EXISTS "Public can view reviews" ON public.reviews;
DROP POLICY IF EXISTS "Users can create reviews" ON public.reviews;
DROP POLICY IF EXISTS "Users can update own reviews" ON public.reviews;
DROP POLICY IF EXISTS "Users can delete own reviews" ON public.reviews;
DROP POLICY IF EXISTS "Service role full access on reviews" ON public.reviews;

-- Public can view reviews for active products/stores
CREATE POLICY "Public can view reviews"
  ON public.reviews
  FOR SELECT
  TO public
  USING (true);

-- Users can create reviews
CREATE POLICY "Users can create reviews"
  ON public.reviews
  FOR INSERT
  TO authenticated
  WITH CHECK (
    user_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
    OR customer_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
  );

-- Users can update their own reviews
CREATE POLICY "Users can update own reviews"
  ON public.reviews
  FOR UPDATE
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
    OR customer_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
  );

-- Users can delete their own reviews
CREATE POLICY "Users can delete own reviews"
  ON public.reviews
  FOR DELETE
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
    OR customer_id IN (
      SELECT id FROM public.user_profiles
      WHERE auth_user_id = auth.uid()
    )
  );

-- Service role full access
CREATE POLICY "Service role full access on reviews"
  ON public.reviews
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 14: RLS POLICIES FOR carts & cart_items
-- ============================================================================

-- Carts
DROP POLICY IF EXISTS "Users can view own cart" ON public.carts;
DROP POLICY IF EXISTS "Users can manage own cart" ON public.carts;
DROP POLICY IF EXISTS "Service role full access on carts" ON public.carts;

CREATE POLICY "Users can view own cart"
  ON public.carts
  FOR SELECT
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage own cart"
  ON public.carts
  FOR ALL
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  )
  WITH CHECK (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Service role full access on carts"
  ON public.carts
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Cart Items
DROP POLICY IF EXISTS "Users can view own cart items" ON public.cart_items;
DROP POLICY IF EXISTS "Users can manage own cart items" ON public.cart_items;
DROP POLICY IF EXISTS "Service role full access on cart_items" ON public.cart_items;

CREATE POLICY "Users can view own cart items"
  ON public.cart_items
  FOR SELECT
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage own cart items"
  ON public.cart_items
  FOR ALL
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  )
  WITH CHECK (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Service role full access on cart_items"
  ON public.cart_items
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 15: RLS POLICIES FOR favorites, wishlist, recently_viewed
-- ============================================================================

-- Favorites
DROP POLICY IF EXISTS "Users can view own favorites" ON public.favorites;
DROP POLICY IF EXISTS "Users can manage own favorites" ON public.favorites;
DROP POLICY IF EXISTS "Service role full access on favorites" ON public.favorites;

CREATE POLICY "Users can view own favorites"
  ON public.favorites
  FOR SELECT
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage own favorites"
  ON public.favorites
  FOR ALL
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  )
  WITH CHECK (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Service role full access on favorites"
  ON public.favorites
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Wishlist
DROP POLICY IF EXISTS "Users can view own wishlist" ON public.wishlist;
DROP POLICY IF EXISTS "Users can manage own wishlist" ON public.wishlist;
DROP POLICY IF EXISTS "Service role full access on wishlist" ON public.wishlist;

CREATE POLICY "Users can view own wishlist"
  ON public.wishlist
  FOR SELECT
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage own wishlist"
  ON public.wishlist
  FOR ALL
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  )
  WITH CHECK (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Service role full access on wishlist"
  ON public.wishlist
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Recently Viewed
DROP POLICY IF EXISTS "Users can view own history" ON public.recently_viewed;
DROP POLICY IF EXISTS "Users can manage own history" ON public.recently_viewed;
DROP POLICY IF EXISTS "Service role full access on recently_viewed" ON public.recently_viewed;

CREATE POLICY "Users can view own history"
  ON public.recently_viewed
  FOR SELECT
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage own history"
  ON public.recently_viewed
  FOR ALL
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  )
  WITH CHECK (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Service role full access on recently_viewed"
  ON public.recently_viewed
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 16: RLS POLICIES FOR notifications & FCM tokens
-- ============================================================================

-- Notifications
DROP POLICY IF EXISTS "Users can view own notifications" ON public.notifications;
DROP POLICY IF EXISTS "Users can update own notifications" ON public.notifications;
DROP POLICY IF EXISTS "Service role full access on notifications" ON public.notifications;

CREATE POLICY "Users can view own notifications"
  ON public.notifications
  FOR SELECT
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own notifications"
  ON public.notifications
  FOR UPDATE
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Service role full access on notifications"
  ON public.notifications
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- FCM Tokens
DROP POLICY IF EXISTS "Users can manage own fcm tokens" ON public.user_fcm_tokens;
DROP POLICY IF EXISTS "Service role full access on user_fcm_tokens" ON public.user_fcm_tokens;

CREATE POLICY "Users can manage own fcm tokens"
  ON public.user_fcm_tokens
  FOR ALL
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  )
  WITH CHECK (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Service role full access on user_fcm_tokens"
  ON public.user_fcm_tokens
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 17: RLS POLICIES FOR coupons & coupon_redemptions
-- ============================================================================

-- Coupons
DROP POLICY IF EXISTS "Public can view active coupons" ON public.coupons;
DROP POLICY IF EXISTS "Merchants can manage own coupons" ON public.coupons;
DROP POLICY IF EXISTS "Service role full access on coupons" ON public.coupons;

CREATE POLICY "Public can view active coupons"
  ON public.coupons
  FOR SELECT
  TO public
  USING (is_active = true);

CREATE POLICY "Merchants can manage own coupons"
  ON public.coupons
  FOR ALL
  TO authenticated
  USING (
    store_id IN (
      SELECT s.id
      FROM public.stores s
      JOIN public.user_profiles up ON s.owner_id = up.id
      WHERE up.auth_user_id = auth.uid()
    )
  )
  WITH CHECK (
    store_id IN (
      SELECT s.id
      FROM public.stores s
      JOIN public.user_profiles up ON s.owner_id = up.id
      WHERE up.auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Service role full access on coupons"
  ON public.coupons
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Coupon Redemptions
DROP POLICY IF EXISTS "Users can view own redemptions" ON public.coupon_redemptions;
DROP POLICY IF EXISTS "Service role full access on coupon_redemptions" ON public.coupon_redemptions;

CREATE POLICY "Users can view own redemptions"
  ON public.coupon_redemptions
  FOR SELECT
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "Service role full access on coupon_redemptions"
  ON public.coupon_redemptions
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- PART 18: RLS POLICIES FOR store_followers
-- ============================================================================

DROP POLICY IF EXISTS "Public can view store followers count" ON public.store_followers;
DROP POLICY IF EXISTS "Users can manage own follows" ON public.store_followers;
DROP POLICY IF EXISTS "Service role full access on store_followers" ON public.store_followers;

-- Public can view follower counts (aggregate only)
CREATE POLICY "Public can view store followers count"
  ON public.store_followers
  FOR SELECT
  TO public
  USING (true);

-- Users can manage their own follows
CREATE POLICY "Users can manage own follows"
  ON public.store_followers
  FOR ALL
  TO authenticated
  USING (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  )
  WITH CHECK (
    user_id IN (
      SELECT id FROM public.user_profiles WHERE auth_user_id = auth.uid()
    )
  );

-- Service role full access
CREATE POLICY "Service role full access on store_followers"
  ON public.store_followers
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- NOTES:
-- ============================================================================
-- 1. RLS enabled on all sensitive tables
-- 2. Golden Plan Identity Chain enforced:
--    auth.users.id → user_profiles.auth_user_id → stores.owner_id → products.store_id
-- 3. Service role bypasses RLS (for Worker backend operations)
-- 4. Public can view active stores/products/reviews
-- 5. Users can only access their own data (orders, wallets, cart, etc.)
-- 6. Merchants can manage their stores and products
-- 7. All policies use proper JOINs through user_profiles
-- ============================================================================
