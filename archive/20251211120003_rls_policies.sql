-- ============================================================================
-- Migration: Row Level Security (RLS) for Golden Plan Tables
-- Date: 2025-12-11
-- Purpose: Enable RLS and create policies for user_profiles, stores, products
-- ============================================================================

-- ============================================================================
-- PART 1: ENABLE RLS ON TABLES
-- ============================================================================

-- 1.1: Enable RLS on user_profiles
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- 1.2: Enable RLS on stores
ALTER TABLE public.stores ENABLE ROW LEVEL SECURITY;

-- 1.3: Enable RLS on products
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- PART 2: RLS POLICIES FOR user_profiles
-- ============================================================================

-- 2.1: Drop existing policies if any
DROP POLICY IF EXISTS "Users can view own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Service role full access" ON public.user_profiles;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.user_profiles;

-- 2.2: Allow users to view their own profile
CREATE POLICY "Users can view own profile"
  ON public.user_profiles
  FOR SELECT
  USING (auth.uid() = auth_user_id);

-- 2.3: Allow users to update their own profile
CREATE POLICY "Users can update own profile"
  ON public.user_profiles
  FOR UPDATE
  USING (auth.uid() = auth_user_id)
  WITH CHECK (auth.uid() = auth_user_id);

-- 2.4: Allow authenticated users to insert (for initial profile creation)
CREATE POLICY "Enable insert for authenticated users"
  ON public.user_profiles
  FOR INSERT
  WITH CHECK (auth.uid() = auth_user_id);

-- 2.5: Service role has full access (bypass RLS)
CREATE POLICY "Service role full access"
  ON public.user_profiles
  FOR ALL
  USING (auth.jwt()->>'role' = 'service_role')
  WITH CHECK (auth.jwt()->>'role' = 'service_role');

-- ============================================================================
-- PART 3: RLS POLICIES FOR stores
-- ============================================================================

-- 3.1: Drop existing policies
DROP POLICY IF EXISTS "Public can view active stores" ON public.stores;
DROP POLICY IF EXISTS "Merchants can view own stores" ON public.stores;
DROP POLICY IF EXISTS "Merchants can insert own stores" ON public.stores;
DROP POLICY IF EXISTS "Merchants can update own stores" ON public.stores;
DROP POLICY IF EXISTS "Service role full access on stores" ON public.stores;

-- 3.2: Public can view active stores
CREATE POLICY "Public can view active stores"
  ON public.stores
  FOR SELECT
  USING (is_active = true AND visibility = 'public');

-- 3.3: Merchants can view their own stores (even if inactive)
CREATE POLICY "Merchants can view own stores"
  ON public.stores
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.user_profiles
      WHERE user_profiles.auth_user_id = auth.uid()
      AND user_profiles.id = stores.owner_id
    )
  );

-- 3.4: Merchants can create stores (owner_id must match their profile)
CREATE POLICY "Merchants can insert own stores"
  ON public.stores
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.user_profiles
      WHERE user_profiles.auth_user_id = auth.uid()
      AND user_profiles.id = owner_id
      AND user_profiles.role IN ('merchant', 'admin')
    )
  );

-- 3.5: Merchants can update their own stores
CREATE POLICY "Merchants can update own stores"
  ON public.stores
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.user_profiles
      WHERE user_profiles.auth_user_id = auth.uid()
      AND user_profiles.id = stores.owner_id
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.user_profiles
      WHERE user_profiles.auth_user_id = auth.uid()
      AND user_profiles.id = stores.owner_id
    )
  );

-- 3.6: Service role full access
CREATE POLICY "Service role full access on stores"
  ON public.stores
  FOR ALL
  USING (auth.jwt()->>'role' = 'service_role')
  WITH CHECK (auth.jwt()->>'role' = 'service_role');

-- ============================================================================
-- PART 4: RLS POLICIES FOR products
-- ============================================================================

-- 4.1: Drop existing policies
DROP POLICY IF EXISTS "Public can view active products" ON public.products;
DROP POLICY IF EXISTS "Merchants can view own products" ON public.products;
DROP POLICY IF EXISTS "Merchants can insert own products" ON public.products;
DROP POLICY IF EXISTS "Merchants can update own products" ON public.products;
DROP POLICY IF EXISTS "Merchants can delete own products" ON public.products;
DROP POLICY IF EXISTS "Service role full access on products" ON public.products;

-- 4.2: Public can view active products from active stores
CREATE POLICY "Public can view active products"
  ON public.products
  FOR SELECT
  USING (
    is_active = true 
    AND EXISTS (
      SELECT 1 FROM public.stores
      WHERE stores.id = products.store_id
      AND stores.is_active = true
      AND stores.visibility = 'public'
    )
  );

-- 4.3: Merchants can view their own products
CREATE POLICY "Merchants can view own products"
  ON public.products
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.stores
      JOIN public.user_profiles ON stores.owner_id = user_profiles.id
      WHERE stores.id = products.store_id
      AND user_profiles.auth_user_id = auth.uid()
    )
  );

-- 4.4: Merchants can create products in their own stores
CREATE POLICY "Merchants can insert own products"
  ON public.products
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.stores
      JOIN public.user_profiles ON stores.owner_id = user_profiles.id
      WHERE stores.id = store_id
      AND user_profiles.auth_user_id = auth.uid()
      AND user_profiles.role IN ('merchant', 'admin')
    )
  );

-- 4.5: Merchants can update their own products
CREATE POLICY "Merchants can update own products"
  ON public.products
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.stores
      JOIN public.user_profiles ON stores.owner_id = user_profiles.id
      WHERE stores.id = products.store_id
      AND user_profiles.auth_user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.stores
      JOIN public.user_profiles ON stores.owner_id = user_profiles.id
      WHERE stores.id = products.store_id
      AND user_profiles.auth_user_id = auth.uid()
    )
  );

-- 4.6: Merchants can delete their own products
CREATE POLICY "Merchants can delete own products"
  ON public.products
  FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.stores
      JOIN public.user_profiles ON stores.owner_id = user_profiles.id
      WHERE stores.id = products.store_id
      AND user_profiles.auth_user_id = auth.uid()
    )
  );

-- 4.7: Service role full access
CREATE POLICY "Service role full access on products"
  ON public.products
  FOR ALL
  USING (auth.jwt()->>'role' = 'service_role')
  WITH CHECK (auth.jwt()->>'role' = 'service_role');

-- ============================================================================
-- VERIFICATION QUERIES (Comment out before running)
-- ============================================================================

/*
-- Check RLS status
SELECT 
  schemaname,
  tablename,
  rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN ('user_profiles', 'stores', 'products');

-- List all policies
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename IN ('user_profiles', 'stores', 'products')
ORDER BY tablename, policyname;
*/

-- ============================================================================
-- NOTES:
-- ============================================================================
-- 1. RLS is enabled on all Golden Plan tables
-- 2. Users can only access their own data by default
-- 3. Public can view active stores and products
-- 4. Merchants can manage their own stores and products
-- 5. Service role bypasses RLS (for Worker backend operations)
-- 6. auth.uid() returns the current user's auth.users.id
-- 7. Policies use JOIN to user_profiles to verify ownership
-- ============================================================================
