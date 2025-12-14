-- ============================================================================
-- FINAL FIX: Registration Trigger Issue
-- ============================================================================
-- Problem: Trigger cannot insert into user_profiles due to RLS
-- Solution: Grant ALL permissions + create proper bypass policies

-- ============================================================================
-- STEP 1: Check current state
-- ============================================================================

SELECT '1. Trigger Status' AS check_type;
SELECT tgname, tgenabled, tgisinternal
FROM pg_trigger 
WHERE tgname = 'on_auth_user_created';

SELECT '2. Function Owner' AS check_type;
SELECT proname, proowner::regrole AS owner, prosecdef
FROM pg_proc 
WHERE proname = 'handle_new_auth_user';

SELECT '3. Current Permissions' AS check_type;
SELECT grantee, privilege_type
FROM information_schema.table_privileges
WHERE table_name = 'user_profiles'
AND grantee IN ('postgres', 'service_role', 'authenticated')
ORDER BY grantee, privilege_type;

-- ============================================================================
-- STEP 2: GRANT ALL permissions to postgres role
-- ============================================================================

-- Postgres role needs FULL access (it's the trigger owner)
GRANT ALL ON public.user_profiles TO postgres;

-- Service role needs FULL access (for Worker API)
GRANT ALL ON public.user_profiles TO service_role;

-- Authenticated users need limited access
GRANT SELECT, INSERT, UPDATE ON public.user_profiles TO authenticated;

-- Grant schema usage
GRANT USAGE ON SCHEMA public TO postgres, service_role, authenticated, anon;

-- ============================================================================
-- STEP 3: Add GRANT on sequences (if any)
-- ============================================================================

-- Check if table has sequences
DO $$
DECLARE
  seq_name TEXT;
BEGIN
  FOR seq_name IN 
    SELECT sequence_name 
    FROM information_schema.sequences 
    WHERE sequence_schema = 'public'
  LOOP
    EXECUTE format('GRANT USAGE, SELECT ON SEQUENCE public.%I TO postgres, service_role, authenticated', seq_name);
    RAISE NOTICE 'Granted permissions on sequence: %', seq_name;
  END LOOP;
END $$;

-- ============================================================================
-- STEP 4: Ensure RLS policies exist
-- ============================================================================

-- Enable RLS (if not already)
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- Drop and recreate service_role policy
DROP POLICY IF EXISTS "service_role_all_access" ON public.user_profiles;

CREATE POLICY "service_role_all_access"
  ON public.user_profiles
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Drop and recreate authenticated self-insert policy
DROP POLICY IF EXISTS "authenticated_self_insert" ON public.user_profiles;

CREATE POLICY "authenticated_self_insert"
  ON public.user_profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth_user_id = auth.uid());

-- Users can view their own profile
DROP POLICY IF EXISTS "users_view_own_profile" ON public.user_profiles;

CREATE POLICY "users_view_own_profile"
  ON public.user_profiles
  FOR SELECT
  TO authenticated
  USING (auth_user_id = auth.uid());

-- Users can update their own profile
DROP POLICY IF EXISTS "users_update_own_profile" ON public.user_profiles;

CREATE POLICY "users_update_own_profile"
  ON public.user_profiles
  FOR UPDATE
  TO authenticated
  USING (auth_user_id = auth.uid())
  WITH CHECK (auth_user_id = auth.uid());

-- Public can view merchant profiles
DROP POLICY IF EXISTS "public_view_merchants" ON public.user_profiles;

CREATE POLICY "public_view_merchants"
  ON public.user_profiles
  FOR SELECT
  TO anon, authenticated
  USING (role = 'merchant' AND is_active = true);

-- ============================================================================
-- STEP 5: Test INSERT as postgres (simulating trigger)
-- ============================================================================

DO $$
DECLARE
  test_uuid UUID := gen_random_uuid();
BEGIN
  -- This simulates what the trigger does
  INSERT INTO public.user_profiles (
    auth_user_id,
    email,
    display_name,
    role,
    is_active
  ) VALUES (
    test_uuid,
    'trigger-test@example.com',
    'Trigger Test',
    'customer',
    true
  );
  
  -- Cleanup
  DELETE FROM public.user_profiles WHERE auth_user_id = test_uuid;
  
  RAISE NOTICE '✅ SUCCESS: Postgres role CAN insert into user_profiles';
  RAISE NOTICE 'Trigger should now work!';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE '❌ FAILED: %', SQLERRM;
  RAISE NOTICE 'Additional investigation needed';
END $$;

-- ============================================================================
-- STEP 6: Verify policies
-- ============================================================================

SELECT '4. Final Policy List' AS check_type;
SELECT 
  policyname,
  roles,
  cmd
FROM pg_policies 
WHERE tablename = 'user_profiles'
ORDER BY policyname;

-- ============================================================================
-- STEP 7: Check auth.users permissions
-- ============================================================================

SELECT '5. Auth Schema Access' AS check_type;
SELECT 
  has_schema_privilege('postgres', 'auth', 'USAGE') AS can_use_auth,
  has_table_privilege('postgres', 'auth.users', 'TRIGGER') AS can_trigger_auth_users;

-- ============================================================================
-- FINAL NOTES
-- ============================================================================

DO $$
BEGIN
  RAISE NOTICE '============================================';
  RAISE NOTICE 'Registration Fix Applied!';
  RAISE NOTICE '============================================';
  RAISE NOTICE '';
  RAISE NOTICE 'Changes made:';
  RAISE NOTICE '1. ✅ Granted ALL to postgres role';
  RAISE NOTICE '2. ✅ Granted ALL to service_role';
  RAISE NOTICE '3. ✅ Created 5 RLS policies';
  RAISE NOTICE '4. ✅ Tested INSERT (should succeed)';
  RAISE NOTICE '';
  RAISE NOTICE 'Next step: Test registration via API';
END $$;
