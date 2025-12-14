-- Quick verification query
-- Run this in Supabase Dashboard to verify the fix was applied

-- Check 1: Verify postgres_role_all_access policy exists
SELECT 
  '1. RLS Policies on user_profiles' AS check_section,
  policyname,
  roles::text[],
  cmd
FROM pg_policies 
WHERE tablename = 'user_profiles'
ORDER BY policyname;

-- Check 2: Verify trigger function exists
SELECT 
  '2. Trigger Function Status' AS check_section,
  proname AS function_name,
  proowner::regrole AS owner,
  prosecdef AS is_security_definer
FROM pg_proc 
WHERE proname = 'handle_new_auth_user';

-- Check 3: Verify trigger exists
SELECT 
  '3. Trigger Status' AS check_section,
  tgname AS trigger_name,
  tgenabled AS is_enabled
FROM pg_trigger 
WHERE tgname = 'on_auth_user_created';

-- Check 4: Test manual INSERT (bypass trigger)
DO $$
DECLARE
  test_uuid UUID := gen_random_uuid();
BEGIN
  -- Try direct INSERT as postgres
  INSERT INTO public.user_profiles (
    auth_user_id,
    email,
    display_name,
    role,
    auth_provider
  ) VALUES (
    test_uuid,
    'manual-test@test.com',
    'Manual Test',
    'customer',
    'supabase_auth'
  );
  
  -- Cleanup
  DELETE FROM public.user_profiles WHERE auth_user_id = test_uuid;
  
  RAISE NOTICE '✅ Manual INSERT works - RLS allows postgres role';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE '❌ Manual INSERT failed: %', SQLERRM;
END $$;

-- Check 5: Look for the CRITICAL postgres_role_all_access policy
SELECT 
  CASE 
    WHEN EXISTS (
      SELECT 1 FROM pg_policies 
      WHERE tablename = 'user_profiles' 
      AND policyname = 'postgres_role_all_access'
    ) 
    THEN '✅ FOUND: postgres_role_all_access policy exists'
    ELSE '❌ MISSING: postgres_role_all_access policy - THIS IS THE PROBLEM!'
  END AS critical_check;
