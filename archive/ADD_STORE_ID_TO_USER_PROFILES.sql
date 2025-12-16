-- ============================================================================
-- Migration: Add store_id to user_profiles + Auto-sync Triggers
-- Date: 2025-12-11
-- Purpose: Fix relationship between user_profiles and stores
-- ============================================================================

-- ============================================================================
-- PART 1: Add store_id column to user_profiles
-- ============================================================================

-- Step 1: Add column if not exists
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'user_profiles' 
    AND column_name = 'store_id'
  ) THEN
    ALTER TABLE public.user_profiles 
    ADD COLUMN store_id UUID;
    RAISE NOTICE '✅ Added store_id column to user_profiles';
  ELSE
    RAISE NOTICE '⚠️ store_id column already exists in user_profiles';
  END IF;
END $$;

-- Step 2: Add Foreign Key constraint
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'user_profiles_store_id_fkey'
    AND conrelid = 'public.user_profiles'::regclass
  ) THEN
    ALTER TABLE public.user_profiles 
    ADD CONSTRAINT user_profiles_store_id_fkey 
    FOREIGN KEY (store_id) 
    REFERENCES public.stores(id) 
    ON DELETE SET NULL;
    RAISE NOTICE '✅ Added FK constraint user_profiles_store_id_fkey';
  ELSE
    RAISE NOTICE '⚠️ FK constraint user_profiles_store_id_fkey already exists';
  END IF;
END $$;

-- Step 3: Add Index for performance
CREATE INDEX IF NOT EXISTS idx_user_profiles_store_id 
ON public.user_profiles(store_id);

-- ============================================================================
-- PART 2: Sync existing data
-- ============================================================================

-- Update user_profiles with store_id from stores
UPDATE public.user_profiles up
SET store_id = s.id,
    updated_at = NOW()
FROM public.stores s
WHERE s.owner_id = up.id
  AND up.store_id IS NULL;

-- Show results
DO $$
DECLARE
  updated_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO updated_count
  FROM public.user_profiles up
  JOIN public.stores s ON s.owner_id = up.id
  WHERE up.store_id IS NOT NULL;
  
  RAISE NOTICE '✅ Synced % user profiles with their stores', updated_count;
END $$;

-- ============================================================================
-- PART 3: Create Auto-sync Triggers
-- ============================================================================

-- Trigger 1: Auto-update user_profiles when store is created
CREATE OR REPLACE FUNCTION update_user_profile_store_id()
RETURNS TRIGGER AS $$
BEGIN
  -- Update user_profiles with new store_id
  UPDATE public.user_profiles
  SET store_id = NEW.id,
      updated_at = NOW()
  WHERE id = NEW.owner_id;
  
  RAISE NOTICE '[Trigger] Updated user_profiles.store_id for profile %', NEW.owner_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop if exists and create trigger
DROP TRIGGER IF EXISTS trigger_update_user_profile_store_id ON public.stores;
CREATE TRIGGER trigger_update_user_profile_store_id
AFTER INSERT ON public.stores
FOR EACH ROW
EXECUTE FUNCTION update_user_profile_store_id();

-- Trigger 2: Auto-clear user_profiles when store is deleted
CREATE OR REPLACE FUNCTION clear_user_profile_store_id()
RETURNS TRIGGER AS $$
BEGIN
  -- Clear store_id from user_profiles
  UPDATE public.user_profiles
  SET store_id = NULL,
      updated_at = NOW()
  WHERE id = OLD.owner_id;
  
  RAISE NOTICE '[Trigger] Cleared user_profiles.store_id for profile %', OLD.owner_id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Drop if exists and create trigger
DROP TRIGGER IF EXISTS trigger_clear_user_profile_store_id ON public.stores;
CREATE TRIGGER trigger_clear_user_profile_store_id
BEFORE DELETE ON public.stores
FOR EACH ROW
EXECUTE FUNCTION clear_user_profile_store_id();

-- ============================================================================
-- PART 4: Verification
-- ============================================================================

-- Show current state
SELECT '=== VERIFICATION RESULTS ===' AS info;

-- Count total merchants
SELECT 
  'Total merchants' AS metric,
  COUNT(*) AS count
FROM public.user_profiles
WHERE role = 'merchant';

-- Count merchants with stores
SELECT 
  'Merchants with stores' AS metric,
  COUNT(*) AS count
FROM public.user_profiles up
JOIN public.stores s ON s.owner_id = up.id
WHERE up.role = 'merchant';

-- Count merchants with store_id set
SELECT 
  'Merchants with store_id in profile' AS metric,
  COUNT(*) AS count
FROM public.user_profiles
WHERE role = 'merchant' AND store_id IS NOT NULL;

-- Show merchants and their stores
SELECT 
  up.id AS profile_id,
  up.email,
  up.role,
  up.store_id AS "store_id (in profile)",
  s.id AS "store_id (in stores)",
  s.name AS store_name,
  CASE 
    WHEN up.store_id = s.id THEN '✅ OK'
    WHEN up.store_id IS NULL AND s.id IS NOT NULL THEN '❌ MISSING'
    WHEN up.store_id IS NOT NULL AND s.id IS NULL THEN '❌ ORPHAN'
    ELSE '⚠️ NO STORE'
  END AS status
FROM public.user_profiles up
LEFT JOIN public.stores s ON s.owner_id = up.id
WHERE up.role = 'merchant'
ORDER BY up.email;

-- ============================================================================
-- PART 5: Test Triggers (Optional - comment out after testing)
-- ============================================================================

-- Uncomment to test:
/*
-- Test 1: Create a test store
DO $$
DECLARE
  test_profile_id UUID;
  test_store_id UUID;
BEGIN
  -- Get a merchant profile
  SELECT id INTO test_profile_id
  FROM public.user_profiles
  WHERE role = 'merchant'
  LIMIT 1;
  
  IF test_profile_id IS NOT NULL THEN
    -- Create test store
    INSERT INTO public.stores (owner_id, name, description)
    VALUES (test_profile_id, 'Test Store (will be deleted)', 'Testing trigger')
    RETURNING id INTO test_store_id;
    
    -- Check if profile was updated
    IF EXISTS (
      SELECT 1 FROM public.user_profiles 
      WHERE id = test_profile_id 
      AND store_id = test_store_id
    ) THEN
      RAISE NOTICE '✅ INSERT trigger works!';
    ELSE
      RAISE NOTICE '❌ INSERT trigger failed!';
    END IF;
    
    -- Delete test store
    DELETE FROM public.stores WHERE id = test_store_id;
    
    -- Check if profile was cleared
    IF EXISTS (
      SELECT 1 FROM public.user_profiles 
      WHERE id = test_profile_id 
      AND store_id IS NULL
    ) THEN
      RAISE NOTICE '✅ DELETE trigger works!';
    ELSE
      RAISE NOTICE '❌ DELETE trigger failed!';
    END IF;
  ELSE
    RAISE NOTICE '⚠️ No merchant profile found for testing';
  END IF;
END $$;
*/

-- ============================================================================
-- COMPLETE
-- ============================================================================

SELECT '=== MIGRATION COMPLETE ===' AS info;
SELECT '✅ user_profiles now has store_id column' AS result;
SELECT '✅ Existing data synced' AS result;
SELECT '✅ Triggers created for auto-sync' AS result;
SELECT '✅ Worker code will now work correctly!' AS result;
