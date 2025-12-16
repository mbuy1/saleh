-- Fix: Update user_profiles with existing store_id for merchants who already have stores
-- This fixes the issue where stores exist but store_id is NULL in user_profiles

-- Step 1: Show current state
SELECT '=== CURRENT STATE ===' AS info;

-- Count merchants without store_id in profiles
SELECT 
  COUNT(*) as merchants_with_stores_but_no_storeid_in_profile
FROM public.stores s
JOIN public.user_profiles up ON s.owner_id = up.id
WHERE up.store_id IS NULL;

-- Show affected users
SELECT 
  up.id as profile_id,
  up.email,
  up.role,
  s.id as store_id,
  s.name as store_name,
  up.store_id as current_store_id_in_profile
FROM public.stores s
JOIN public.user_profiles up ON s.owner_id = up.id
WHERE up.store_id IS NULL;

-- Step 2: Fix by updating user_profiles with their store_id
SELECT '=== FIXING PROFILES ===' AS info;

UPDATE public.user_profiles up
SET store_id = s.id,
    updated_at = NOW()
FROM public.stores s
WHERE s.owner_id = up.id
  AND up.store_id IS NULL;

-- Step 3: Verify fix
SELECT '=== VERIFICATION ===' AS info;

-- Should be 0 after fix
SELECT 
  COUNT(*) as merchants_still_missing_storeid
FROM public.stores s
JOIN public.user_profiles up ON s.owner_id = up.id
WHERE up.store_id IS NULL;

-- Show all merchants with their stores
SELECT 
  up.id as profile_id,
  up.email,
  up.role,
  up.store_id,
  s.id as actual_store_id,
  s.name as store_name,
  CASE 
    WHEN up.store_id = s.id THEN 'OK ✓'
    WHEN up.store_id IS NULL THEN 'MISSING ✗'
    ELSE 'MISMATCH ✗'
  END as status
FROM public.user_profiles up
LEFT JOIN public.stores s ON s.owner_id = up.id
WHERE up.role = 'merchant'
ORDER BY up.email;

SELECT '=== FIX COMPLETE ===' AS info;
