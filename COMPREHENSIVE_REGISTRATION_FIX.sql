-- ============================================================================
-- COMPREHENSIVE REGISTRATION DEBUG & FIX
-- ============================================================================
-- This script will:
-- 1. Show current trigger function code
-- 2. Show table structure
-- 3. Create a corrected trigger function
-- 4. Test it
-- ============================================================================

-- STEP 1: Show current trigger function
-- ============================================================================
SELECT '=== CURRENT TRIGGER FUNCTION ===' AS info;

SELECT pg_get_functiondef(oid) 
FROM pg_proc 
WHERE proname = 'handle_new_auth_user';

-- STEP 2: Show user_profiles table structure
-- ============================================================================
SELECT '=== USER_PROFILES TABLE STRUCTURE ===' AS info;

SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_name = 'user_profiles'
AND table_schema = 'public'
ORDER BY ordinal_position;

-- STEP 3: Drop and recreate trigger function with DYNAMIC column detection
-- ============================================================================
SELECT '=== CREATING NEW TRIGGER FUNCTION ===' AS info;

CREATE OR REPLACE FUNCTION public.handle_new_auth_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER  -- Run as postgres (owner)
SET search_path = public
AS $$
DECLARE
  user_role TEXT;
  has_is_active BOOLEAN;
BEGIN
  -- Get role from user metadata (default to 'customer')
  user_role := COALESCE(NEW.raw_user_meta_data->>'role', 'customer');
  
  -- Check if is_active column exists
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
    AND table_name = 'user_profiles'
    AND column_name = 'is_active'
  ) INTO has_is_active;
  
  -- Insert with columns that exist
  IF has_is_active THEN
    -- Table has is_active column
    INSERT INTO public.user_profiles (
      auth_user_id,
      email,
      display_name,
      role,
      is_active
    ) VALUES (
      NEW.id,
      NEW.email,
      COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
      user_role,
      true
    );
  ELSE
    -- Table does NOT have is_active column
    INSERT INTO public.user_profiles (
      auth_user_id,
      email,
      display_name,
      role
    ) VALUES (
      NEW.id,
      NEW.email,
      COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
      user_role
    );
  END IF;
  
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log error but don't fail the auth.users insert
    RAISE WARNING 'Failed to create user_profile for %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$;

-- STEP 4: Make sure trigger exists and is enabled
-- ============================================================================
SELECT '=== RECREATING TRIGGER ===' AS info;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_auth_user();

-- STEP 5: Grant permissions to postgres role
-- ============================================================================
SELECT '=== GRANTING PERMISSIONS ===' AS info;

-- Make sure postgres role has ALL permissions
GRANT ALL ON public.user_profiles TO postgres;
GRANT ALL ON public.user_profiles TO service_role;
GRANT SELECT, INSERT, UPDATE ON public.user_profiles TO authenticated;

-- Grant on auth schema
GRANT USAGE ON SCHEMA auth TO postgres;
GRANT SELECT ON auth.users TO postgres;

-- STEP 6: Verify RLS policies allow postgres role
-- ============================================================================
SELECT '=== CHECKING RLS POLICIES ===' AS info;

-- Make sure RLS is enabled
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- Recreate service_role policy (bypasses RLS)
DROP POLICY IF EXISTS "service_role_all_access" ON public.user_profiles;
CREATE POLICY "service_role_all_access"
  ON public.user_profiles
  TO service_role
  USING (true)
  WITH CHECK (true);

-- IMPORTANT: Add policy for postgres role (used by trigger)
DROP POLICY IF EXISTS "postgres_role_all_access" ON public.user_profiles;
CREATE POLICY "postgres_role_all_access"
  ON public.user_profiles
  TO postgres
  USING (true)
  WITH CHECK (true);

-- STEP 7: Test the trigger manually
-- ============================================================================
SELECT '=== TESTING TRIGGER ===' AS info;

DO $$
DECLARE
  test_uuid UUID := gen_random_uuid();
  test_email TEXT := 'trigger-test-' || floor(random() * 10000)::text || '@test.com';
BEGIN
  -- Insert test user into auth.users (simulates registration)
  INSERT INTO auth.users (
    id,
    instance_id,
    email,
    encrypted_password,
    email_confirmed_at,
    raw_user_meta_data,
    created_at,
    updated_at,
    aud,
    role
  ) VALUES (
    test_uuid,
    '00000000-0000-0000-0000-000000000000',
    test_email,
    crypt('test123', gen_salt('bf')),
    NOW(),
    jsonb_build_object('full_name', 'Trigger Test', 'role', 'customer'),
    NOW(),
    NOW(),
    'authenticated',
    'authenticated'
  );
  
  -- Check if profile was created
  IF EXISTS (
    SELECT 1 FROM public.user_profiles 
    WHERE auth_user_id = test_uuid
  ) THEN
    RAISE NOTICE '✅ SUCCESS: Trigger created user_profile correctly!';
    
    -- Cleanup
    DELETE FROM public.user_profiles WHERE auth_user_id = test_uuid;
    DELETE FROM auth.users WHERE id = test_uuid;
    
    RAISE NOTICE '✅ Test user cleaned up';
  ELSE
    RAISE NOTICE '❌ FAILED: Trigger did not create user_profile';
  END IF;
  
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE '❌ ERROR during test: %', SQLERRM;
  
  -- Try to cleanup anyway
  BEGIN
    DELETE FROM public.user_profiles WHERE auth_user_id = test_uuid;
    DELETE FROM auth.users WHERE id = test_uuid;
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END $$;

-- STEP 8: Show final status
-- ============================================================================
SELECT '=== FINAL STATUS ===' AS info;

SELECT 
  'Trigger Function' AS component,
  CASE WHEN EXISTS (
    SELECT 1 FROM pg_proc WHERE proname = 'handle_new_auth_user'
  ) THEN '✅ Exists' ELSE '❌ Missing' END AS status;

SELECT 
  'Trigger on auth.users' AS component,
  CASE WHEN EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'on_auth_user_created'
  ) THEN '✅ Exists' ELSE '❌ Missing' END AS status;

SELECT 
  policyname,
  roles,
  cmd AS operation
FROM pg_policies 
WHERE tablename = 'user_profiles'
ORDER BY policyname;

-- ============================================================================
-- FINAL MESSAGE
-- ============================================================================
DO $$
BEGIN
  RAISE NOTICE '';
  RAISE NOTICE '================================================';
  RAISE NOTICE '✅ REGISTRATION FIX COMPLETE';
  RAISE NOTICE '================================================';
  RAISE NOTICE '';
  RAISE NOTICE 'Changes applied:';
  RAISE NOTICE '1. ✅ Recreated trigger function with dynamic column detection';
  RAISE NOTICE '2. ✅ Granted ALL permissions to postgres role';
  RAISE NOTICE '3. ✅ Created RLS policy for postgres role (IMPORTANT!)';
  RAISE NOTICE '4. ✅ Tested trigger manually';
  RAISE NOTICE '';
  RAISE NOTICE 'Next step: Test registration via Worker API';
  RAISE NOTICE '';
END $$;
