-- ============================================================================
-- Migration: Golden Plan Schema Setup
-- Date: 2025-12-11
-- Purpose: Establish complete identity chain: auth.users → user_profiles → stores → products
-- ============================================================================

-- ============================================================================
-- PART 1: USER_PROFILES TABLE SCHEMA
-- ============================================================================

-- 1.1: Ensure user_profiles table exists with correct structure
CREATE TABLE IF NOT EXISTS public.user_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_user_id UUID UNIQUE NOT NULL,
  email TEXT,
  display_name TEXT,
  phone TEXT,
  avatar_url TEXT,
  role TEXT NOT NULL DEFAULT 'customer' CHECK (role IN ('customer', 'merchant', 'admin')),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 1.2: Add auth_user_id column if it doesn't exist (for existing tables)
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'user_profiles' 
    AND column_name = 'auth_user_id'
  ) THEN
    ALTER TABLE public.user_profiles 
    ADD COLUMN auth_user_id UUID;
  END IF;
END $$;

-- 1.3: Make auth_user_id NOT NULL (after ensuring it's populated)
-- Note: This will fail if there are NULL values. Run sync function first.
DO $$ 
BEGIN
  -- Only proceed if column exists and has no NULLs
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'user_profiles' 
    AND column_name = 'auth_user_id'
  ) THEN
    -- Check if there are any NULL values
    IF NOT EXISTS (
      SELECT 1 FROM public.user_profiles WHERE auth_user_id IS NULL LIMIT 1
    ) THEN
      -- Safe to add NOT NULL constraint
      ALTER TABLE public.user_profiles 
      ALTER COLUMN auth_user_id SET NOT NULL;
    ELSE
      RAISE NOTICE 'Cannot set auth_user_id to NOT NULL: NULL values exist. Run sync function first.';
    END IF;
  END IF;
END $$;

-- 1.4: Add UNIQUE constraint on auth_user_id if not exists
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'user_profiles_auth_user_id_key'
    AND conrelid = 'public.user_profiles'::regclass
  ) THEN
    ALTER TABLE public.user_profiles 
    ADD CONSTRAINT user_profiles_auth_user_id_key UNIQUE (auth_user_id);
  END IF;
END $$;

-- 1.5: Add Foreign Key to auth.users if not exists
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'user_profiles_auth_user_id_fkey'
    AND conrelid = 'public.user_profiles'::regclass
  ) THEN
    ALTER TABLE public.user_profiles 
    ADD CONSTRAINT user_profiles_auth_user_id_fkey 
    FOREIGN KEY (auth_user_id) 
    REFERENCES auth.users(id) 
    ON DELETE CASCADE;
  END IF;
END $$;

-- 1.6: Add role column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'user_profiles' 
    AND column_name = 'role'
  ) THEN
    ALTER TABLE public.user_profiles 
    ADD COLUMN role TEXT NOT NULL DEFAULT 'customer' 
    CHECK (role IN ('customer', 'merchant', 'admin'));
  END IF;
END $$;

-- ============================================================================
-- PART 2: STORES TABLE SCHEMA
-- ============================================================================

-- 2.1: Ensure stores table exists
CREATE TABLE IF NOT EXISTS public.stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  city TEXT,
  visibility TEXT DEFAULT 'public' CHECK (visibility IN ('public', 'private')),
  is_active BOOLEAN DEFAULT true,
  is_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2.2: Add owner_id column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'stores' 
    AND column_name = 'owner_id'
  ) THEN
    ALTER TABLE public.stores 
    ADD COLUMN owner_id UUID;
  END IF;
END $$;

-- 2.3: Make owner_id NOT NULL
DO $$ 
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'stores' 
    AND column_name = 'owner_id'
    AND is_nullable = 'YES'
  ) THEN
    -- Only proceed if no NULL values
    IF NOT EXISTS (
      SELECT 1 FROM public.stores WHERE owner_id IS NULL LIMIT 1
    ) THEN
      ALTER TABLE public.stores 
      ALTER COLUMN owner_id SET NOT NULL;
    ELSE
      RAISE NOTICE 'Cannot set owner_id to NOT NULL: NULL values exist.';
    END IF;
  END IF;
END $$;

-- 2.4: Drop old FK to mbuy_users if exists
DO $$ 
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'stores_owner_id_fkey'
    AND conrelid = 'public.stores'::regclass
  ) THEN
    ALTER TABLE public.stores 
    DROP CONSTRAINT stores_owner_id_fkey;
  END IF;
END $$;

-- 2.5: Add FK to user_profiles.id (Golden Plan)
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'stores_owner_id_fkey_golden'
    AND conrelid = 'public.stores'::regclass
  ) THEN
    ALTER TABLE public.stores 
    ADD CONSTRAINT stores_owner_id_fkey_golden 
    FOREIGN KEY (owner_id) 
    REFERENCES public.user_profiles(id) 
    ON DELETE CASCADE;
  END IF;
END $$;

-- ============================================================================
-- PART 3: PRODUCTS TABLE SCHEMA
-- ============================================================================

-- 3.1: Ensure products table exists
CREATE TABLE IF NOT EXISTS public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  stock INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3.2: Add store_id column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'products' 
    AND column_name = 'store_id'
  ) THEN
    ALTER TABLE public.products 
    ADD COLUMN store_id UUID;
  END IF;
END $$;

-- 3.3: Make store_id NOT NULL
DO $$ 
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'products' 
    AND column_name = 'store_id'
    AND is_nullable = 'YES'
  ) THEN
    IF NOT EXISTS (
      SELECT 1 FROM public.products WHERE store_id IS NULL LIMIT 1
    ) THEN
      ALTER TABLE public.products 
      ALTER COLUMN store_id SET NOT NULL;
    ELSE
      RAISE NOTICE 'Cannot set store_id to NOT NULL: NULL values exist.';
    END IF;
  END IF;
END $$;

-- 3.4: Add FK to stores.id if not exists
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'products_store_id_fkey'
    AND conrelid = 'public.products'::regclass
  ) THEN
    ALTER TABLE public.products 
    ADD CONSTRAINT products_store_id_fkey 
    FOREIGN KEY (store_id) 
    REFERENCES public.stores(id) 
    ON DELETE CASCADE;
  END IF;
END $$;

-- ============================================================================
-- PART 4: INDEXES FOR PERFORMANCE
-- ============================================================================

-- 4.1: Index on user_profiles.auth_user_id (already UNIQUE, but ensure)
CREATE INDEX IF NOT EXISTS idx_user_profiles_auth_user_id 
ON public.user_profiles(auth_user_id);

-- 4.2: Index on user_profiles.email
CREATE INDEX IF NOT EXISTS idx_user_profiles_email 
ON public.user_profiles(email);

-- 4.3: Index on user_profiles.role
CREATE INDEX IF NOT EXISTS idx_user_profiles_role 
ON public.user_profiles(role);

-- 4.4: Index on stores.owner_id
CREATE INDEX IF NOT EXISTS idx_stores_owner_id 
ON public.stores(owner_id);

-- 4.5: Index on products.store_id
CREATE INDEX IF NOT EXISTS idx_products_store_id 
ON public.products(store_id);

-- ============================================================================
-- PART 5: UPDATED_AT TRIGGER
-- ============================================================================

-- 5.1: Create or replace updated_at trigger function
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 5.2: Add trigger to user_profiles
DROP TRIGGER IF EXISTS update_user_profiles_updated_at ON public.user_profiles;
CREATE TRIGGER update_user_profiles_updated_at
  BEFORE UPDATE ON public.user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- 5.3: Add trigger to stores
DROP TRIGGER IF EXISTS update_stores_updated_at ON public.stores;
CREATE TRIGGER update_stores_updated_at
  BEFORE UPDATE ON public.stores
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- 5.4: Add trigger to products
DROP TRIGGER IF EXISTS update_products_updated_at ON public.products;
CREATE TRIGGER update_products_updated_at
  BEFORE UPDATE ON public.products
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- ============================================================================
-- VERIFICATION QUERIES (Comment out before running)
-- ============================================================================

/*
-- Verify constraints
SELECT 
  tc.table_name, 
  tc.constraint_name, 
  tc.constraint_type,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
LEFT JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_schema = 'public'
  AND tc.table_name IN ('user_profiles', 'stores', 'products')
ORDER BY tc.table_name, tc.constraint_type;

-- Verify indexes
SELECT 
  schemaname,
  tablename,
  indexname,
  indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename IN ('user_profiles', 'stores', 'products')
ORDER BY tablename, indexname;
*/
