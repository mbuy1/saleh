-- ============================================================================
-- COMPLETE FIX: Create missing profiles for all existing auth users
-- ============================================================================
-- This script will:
-- 1. Find all auth.users that don't have a profile
-- 2. Create profiles for them automatically
-- 3. Specifically fix baharista1@gmail.com
-- 4. Verify the fix
-- ============================================================================

-- STEP 1: Show current state
SELECT '=== CURRENT STATE ===' AS info;

SELECT 
  COUNT(*) as total_auth_users
FROM auth.users;

SELECT 
  COUNT(*) as total_user_profiles
FROM public.user_profiles;

SELECT 
  COUNT(*) as users_without_profiles
FROM auth.users au
LEFT JOIN public.user_profiles up ON au.id = up.auth_user_id
WHERE up.id IS NULL;

-- STEP 2: Show users without profiles
SELECT '=== USERS WITHOUT PROFILES ===' AS info;

SELECT 
  au.id as auth_user_id,
  au.email,
  au.created_at,
  au.raw_user_meta_data->>'role' as requested_role,
  au.raw_user_meta_data->>'full_name' as full_name
FROM auth.users au
LEFT JOIN public.user_profiles up ON au.id = up.auth_user_id
WHERE up.id IS NULL
ORDER BY au.created_at DESC;

-- STEP 3: Create profiles for ALL missing users
SELECT '=== CREATING MISSING PROFILES ===' AS info;

INSERT INTO public.user_profiles (
  auth_user_id,
  email,
  display_name,
  role,
  is_active
)
SELECT 
  au.id,
  au.email,
  COALESCE(au.raw_user_meta_data->>'full_name', au.email) as display_name,
  COALESCE(au.raw_user_meta_data->>'role', 'customer') as role,
  true as is_active
FROM auth.users au
LEFT JOIN public.user_profiles up ON au.id = up.auth_user_id
WHERE up.id IS NULL
ON CONFLICT (auth_user_id) DO UPDATE SET
  email = EXCLUDED.email,
  updated_at = NOW();

-- STEP 4: Verify baharista1@gmail.com specifically
SELECT '=== VERIFYING baharista1@gmail.com ===' AS info;

SELECT 
  up.id,
  up.auth_user_id,
  up.email,
  up.display_name,
  up.role,
  up.is_active,
  up.store_id,
  up.created_at,
  au.email as auth_email
FROM public.user_profiles up
JOIN auth.users au ON up.auth_user_id = au.id
WHERE au.email = 'baharista1@gmail.com';

-- STEP 5: Show final statistics
SELECT '=== FINAL STATISTICS ===' AS info;

SELECT 
  'Total auth.users' as metric,
  COUNT(*) as count
FROM auth.users
UNION ALL
SELECT 
  'Total user_profiles' as metric,
  COUNT(*) as count
FROM public.user_profiles
UNION ALL
SELECT 
  'Users without profiles' as metric,
  COUNT(*) as count
FROM auth.users au
LEFT JOIN public.user_profiles up ON au.id = up.auth_user_id
WHERE up.id IS NULL;

-- STEP 6: Test query as Worker would do it
SELECT '=== TESTING WORKER QUERY ===' AS info;

-- Simulate the exact query the Worker middleware uses
SELECT 
  id,
  role,
  display_name,
  auth_user_id,
  store_id
FROM public.user_profiles
WHERE auth_user_id = '3c6eabfe-445e-4e40-954c-8932d58148e8'
LIMIT 1;

-- Show success message
DO $$
DECLARE
  missing_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO missing_count
  FROM auth.users au
  LEFT JOIN public.user_profiles up ON au.id = up.auth_user_id
  WHERE up.id IS NULL;
  
  IF missing_count = 0 THEN
    RAISE NOTICE '';
    RAISE NOTICE '================================================';
    RAISE NOTICE '✅ ALL USERS NOW HAVE PROFILES';
    RAISE NOTICE '================================================';
    RAISE NOTICE '';
  ELSE
    RAISE NOTICE '';
    RAISE NOTICE '⚠️  Still % users without profiles', missing_count;
    RAISE NOTICE '';
  END IF;
END $$;
