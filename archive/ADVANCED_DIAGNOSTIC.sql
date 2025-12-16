-- ============================================================================
-- Advanced Diagnostic: Deep Dive into Registration Issue
-- ============================================================================

-- 1. Check if trigger exists and details
SELECT 
  '1. Trigger Details' AS section,
  t.tgname AS trigger_name,
  CASE t.tgenabled
    WHEN 'O' THEN 'Enabled'
    WHEN 'D' THEN 'Disabled'
    WHEN 'R' THEN 'Replica'
    WHEN 'A' THEN 'Always'
  END AS status,
  pg_get_triggerdef(t.oid) AS definition
FROM pg_trigger t
WHERE t.tgname = 'on_auth_user_created';

-- 2. Check function exists and details
SELECT 
  '2. Function Details' AS section,
  p.proname AS function_name,
  p.prosecdef AS is_security_definer,
  pg_get_functiondef(p.oid) AS definition
FROM pg_proc p
WHERE p.proname = 'handle_new_auth_user';

-- 3. Check user_profiles table structure
SELECT 
  '3. Table Structure' AS section,
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name = 'user_profiles'
ORDER BY ordinal_position;

-- 4. Check constraints on user_profiles
SELECT 
  '4. Constraints' AS section,
  conname AS constraint_name,
  contype AS constraint_type,
  pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE conrelid = 'public.user_profiles'::regclass;

-- 5. Check RLS status and policies
SELECT 
  '5. RLS Status' AS section,
  tablename,
  rowsecurity AS rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
AND tablename = 'user_profiles';

SELECT 
  '5. RLS Policies' AS section,
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
AND tablename = 'user_profiles';

-- 6. Check permissions
SELECT 
  '6. Permissions' AS section,
  grantee,
  privilege_type,
  is_grantable
FROM information_schema.table_privileges
WHERE table_schema = 'public'
AND table_name = 'user_profiles'
ORDER BY grantee, privilege_type;

-- 7. Test trigger function manually
DO $$
DECLARE
  test_auth_id UUID := gen_random_uuid();
  test_result TEXT;
BEGIN
  RAISE NOTICE '7. Manual Trigger Test';
  RAISE NOTICE 'Test auth_user_id: %', test_auth_id;
  
  BEGIN
    -- Simulate what trigger does
    INSERT INTO public.user_profiles (
      auth_user_id,
      email,
      display_name,
      role,
      is_active
    ) VALUES (
      test_auth_id,
      'manual-test@example.com',
      'Manual Test',
      'customer',
      true
    );
    
    test_result := 'SUCCESS';
    
    -- Cleanup
    DELETE FROM public.user_profiles WHERE auth_user_id = test_auth_id;
    
    RAISE NOTICE 'Result: % - Trigger function CAN insert', test_result;
  EXCEPTION WHEN OTHERS THEN
    test_result := 'FAILED';
    RAISE NOTICE 'Result: % - Error: %', test_result, SQLERRM;
  END;
END $$;

-- 8. Check auth.users permissions
SELECT 
  '8. Auth Schema Permissions' AS section,
  has_schema_privilege('postgres', 'auth', 'USAGE') AS postgres_can_use_auth_schema,
  has_table_privilege('postgres', 'auth.users', 'SELECT') AS postgres_can_select_auth_users,
  has_table_privilege('postgres', 'auth.users', 'INSERT') AS postgres_can_insert_auth_users;

-- 9. Check if there are any active sessions/locks
SELECT 
  '9. Active Sessions' AS section,
  pid,
  usename,
  application_name,
  state,
  query
FROM pg_stat_activity
WHERE datname = current_database()
AND state = 'active'
AND query NOT LIKE '%pg_stat_activity%';

-- 10. Summary and Recommendations
DO $$
DECLARE
  trigger_exists BOOLEAN;
  function_exists BOOLEAN;
  rls_enabled BOOLEAN;
  policy_count INTEGER;
BEGIN
  -- Check trigger
  SELECT EXISTS(
    SELECT 1 FROM pg_trigger WHERE tgname = 'on_auth_user_created'
  ) INTO trigger_exists;
  
  -- Check function
  SELECT EXISTS(
    SELECT 1 FROM pg_proc WHERE proname = 'handle_new_auth_user'
  ) INTO function_exists;
  
  -- Check RLS
  SELECT rowsecurity 
  FROM pg_tables 
  WHERE tablename = 'user_profiles'
  INTO rls_enabled;
  
  -- Count policies
  SELECT COUNT(*)
  FROM pg_policies
  WHERE tablename = 'user_profiles'
  INTO policy_count;
  
  RAISE NOTICE '10. Summary';
  RAISE NOTICE '============';
  RAISE NOTICE 'Trigger exists: %', trigger_exists;
  RAISE NOTICE 'Function exists: %', function_exists;
  RAISE NOTICE 'RLS enabled: %', rls_enabled;
  RAISE NOTICE 'Policy count: %', policy_count;
  RAISE NOTICE '';
  
  IF NOT trigger_exists THEN
    RAISE NOTICE '❌ PROBLEM: Trigger does not exist!';
    RAISE NOTICE 'SOLUTION: Run 20251211120001_auto_create_user_profile_trigger.sql';
  ELSIF NOT function_exists THEN
    RAISE NOTICE '❌ PROBLEM: Function does not exist!';
    RAISE NOTICE 'SOLUTION: Run 20251211120001_auto_create_user_profile_trigger.sql';
  ELSIF rls_enabled AND policy_count < 2 THEN
    RAISE NOTICE '❌ PROBLEM: RLS enabled but insufficient policies!';
    RAISE NOTICE 'SOLUTION: Run 20251212000001_fix_registration_rls.sql';
  ELSE
    RAISE NOTICE '✅ All components present. Issue may be in Supabase Auth config.';
  END IF;
END $$;
