-- ============================================================================
-- COMPLETE SUPABASE DATABASE INSPECTION
-- ============================================================================
-- This will show EVERYTHING about the database structure and policies
-- ============================================================================

-- ============================================================================
-- SECTION 1: USER_PROFILES TABLE DETAILED INSPECTION
-- ============================================================================

SELECT '========================================' AS section;
SELECT '1. USER_PROFILES TABLE STRUCTURE' AS section;
SELECT '========================================' AS section;

-- Show all columns with full details
SELECT 
  column_name,
  data_type,
  character_maximum_length,
  is_nullable,
  column_default,
  ordinal_position
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'user_profiles'
ORDER BY ordinal_position;

-- ============================================================================
-- SECTION 2: CONSTRAINTS AND FOREIGN KEYS
-- ============================================================================

SELECT '========================================' AS section;
SELECT '2. CONSTRAINTS ON USER_PROFILES' AS section;
SELECT '========================================' AS section;

-- Primary Key
SELECT 
  'Primary Key' AS constraint_type,
  constraint_name,
  column_name
FROM information_schema.key_column_usage
WHERE table_schema = 'public'
  AND table_name = 'user_profiles'
  AND constraint_name IN (
    SELECT constraint_name 
    FROM information_schema.table_constraints 
    WHERE constraint_type = 'PRIMARY KEY'
      AND table_name = 'user_profiles'
  );

-- Foreign Keys
SELECT 
  'Foreign Key' AS constraint_type,
  tc.constraint_name,
  kcu.column_name,
  ccu.table_name AS foreign_table,
  ccu.column_name AS foreign_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
  AND tc.table_name = 'user_profiles';

-- Unique Constraints
SELECT 
  'Unique Constraint' AS constraint_type,
  constraint_name,
  column_name
FROM information_schema.key_column_usage
WHERE table_schema = 'public'
  AND table_name = 'user_profiles'
  AND constraint_name IN (
    SELECT constraint_name 
    FROM information_schema.table_constraints 
    WHERE constraint_type = 'UNIQUE'
      AND table_name = 'user_profiles'
  );

-- ============================================================================
-- SECTION 3: RLS STATUS AND POLICIES
-- ============================================================================

SELECT '========================================' AS section;
SELECT '3. ROW LEVEL SECURITY STATUS' AS section;
SELECT '========================================' AS section;

-- Check if RLS is enabled
SELECT 
  tablename,
  rowsecurity AS rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'user_profiles';

-- List ALL policies on user_profiles
SELECT '========================================' AS section;
SELECT '4. ALL RLS POLICIES ON USER_PROFILES' AS section;
SELECT '========================================' AS section;

SELECT 
  policyname,
  permissive,
  roles::text[],
  cmd AS operation,
  qual AS using_expression,
  with_check AS check_expression
FROM pg_policies 
WHERE schemaname = 'public'
  AND tablename = 'user_profiles'
ORDER BY policyname;

-- ============================================================================
-- SECTION 5: GRANTS AND PERMISSIONS
-- ============================================================================

SELECT '========================================' AS section;
SELECT '5. TABLE PERMISSIONS' AS section;
SELECT '========================================' AS section;

SELECT 
  grantee,
  privilege_type,
  is_grantable
FROM information_schema.table_privileges
WHERE table_schema = 'public'
  AND table_name = 'user_profiles'
ORDER BY grantee, privilege_type;

-- ============================================================================
-- SECTION 6: TRIGGER INSPECTION
-- ============================================================================

SELECT '========================================' AS section;
SELECT '6. TRIGGERS ON AUTH.USERS' AS section;
SELECT '========================================' AS section;

SELECT 
  trigger_name,
  event_manipulation,
  action_timing,
  action_statement
FROM information_schema.triggers
WHERE event_object_schema = 'auth'
  AND event_object_table = 'users'
  AND trigger_name LIKE '%auth_user%';

-- Show trigger function definition
SELECT '========================================' AS section;
SELECT '7. TRIGGER FUNCTION CODE' AS section;
SELECT '========================================' AS section;

SELECT pg_get_functiondef(oid) 
FROM pg_proc 
WHERE proname = 'handle_new_auth_user';

-- Show function owner and security settings
SELECT 
  proname AS function_name,
  proowner::regrole AS owner,
  prosecdef AS security_definer,
  provolatile AS volatility
FROM pg_proc 
WHERE proname = 'handle_new_auth_user';

-- ============================================================================
-- SECTION 8: AUTH SCHEMA PERMISSIONS
-- ============================================================================

SELECT '========================================' AS section;
SELECT '8. AUTH SCHEMA PERMISSIONS' AS section;
SELECT '========================================' AS section;

-- Check auth schema access
SELECT 
  has_schema_privilege('postgres', 'auth', 'USAGE') AS postgres_can_use_auth,
  has_schema_privilege('service_role', 'auth', 'USAGE') AS service_role_can_use_auth,
  has_table_privilege('postgres', 'auth.users', 'SELECT') AS postgres_can_read_auth_users,
  has_table_privilege('postgres', 'auth.users', 'INSERT') AS postgres_can_insert_auth_users,
  has_table_privilege('postgres', 'auth.users', 'TRIGGER') AS postgres_can_trigger_auth_users;

-- ============================================================================
-- SECTION 9: RELATED TABLES STRUCTURE
-- ============================================================================

SELECT '========================================' AS section;
SELECT '9. STORES TABLE STRUCTURE' AS section;
SELECT '========================================' AS section;

SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'stores'
ORDER BY ordinal_position;

-- Stores foreign keys
SELECT 
  'Stores Foreign Keys' AS info,
  tc.constraint_name,
  kcu.column_name,
  ccu.table_name AS foreign_table,
  ccu.column_name AS foreign_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
  AND tc.table_name = 'stores';

SELECT '========================================' AS section;
SELECT '10. PRODUCTS TABLE STRUCTURE' AS section;
SELECT '========================================' AS section;

SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'products'
ORDER BY ordinal_position;

-- Products foreign keys
SELECT 
  'Products Foreign Keys' AS info,
  tc.constraint_name,
  kcu.column_name,
  ccu.table_name AS foreign_table,
  ccu.column_name AS foreign_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
  AND tc.table_name = 'products';

-- ============================================================================
-- SECTION 11: CRITICAL CHECKS
-- ============================================================================

SELECT '========================================' AS section;
SELECT '11. CRITICAL CHECKS' AS section;
SELECT '========================================' AS section;

-- Check 1: Does postgres_role_all_access policy exist?
SELECT 
  CASE 
    WHEN EXISTS (
      SELECT 1 FROM pg_policies 
      WHERE tablename = 'user_profiles' 
        AND policyname = 'postgres_role_all_access'
    ) 
    THEN '✅ EXISTS'
    ELSE '❌ MISSING - THIS IS CRITICAL!'
  END AS postgres_policy_status;

-- Check 2: Can postgres role actually insert?
DO $$
DECLARE
  test_uuid UUID := gen_random_uuid();
  can_insert BOOLEAN := false;
BEGIN
  BEGIN
    -- Try to insert as postgres
    INSERT INTO public.user_profiles (
      auth_user_id,
      email,
      display_name,
      role,
      auth_provider
    ) VALUES (
      test_uuid,
      'postgres-test@test.com',
      'Postgres Test',
      'customer',
      'supabase_auth'
    );
    
    can_insert := true;
    
    -- Cleanup
    DELETE FROM public.user_profiles WHERE auth_user_id = test_uuid;
    
  EXCEPTION WHEN OTHERS THEN
    can_insert := false;
  END;
  
  IF can_insert THEN
    RAISE NOTICE '✅ Postgres role CAN insert into user_profiles';
  ELSE
    RAISE NOTICE '❌ Postgres role CANNOT insert into user_profiles - RLS is blocking!';
  END IF;
END $$;

-- Check 3: List all roles that have policies
SELECT 
  DISTINCT unnest(roles::text[]) AS role_with_policy
FROM pg_policies 
WHERE tablename = 'user_profiles';

-- ============================================================================
-- SECTION 12: SEQUENCES
-- ============================================================================

SELECT '========================================' AS section;
SELECT '12. SEQUENCES RELATED TO USER_PROFILES' AS section;
SELECT '========================================' AS section;

SELECT 
  sequence_name,
  data_type,
  start_value,
  minimum_value,
  maximum_value,
  increment
FROM information_schema.sequences
WHERE sequence_schema = 'public'
  AND sequence_name LIKE '%user_profile%';

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

DO $$
BEGIN
  RAISE NOTICE '';
  RAISE NOTICE '================================================';
  RAISE NOTICE 'DATABASE INSPECTION COMPLETE';
  RAISE NOTICE '================================================';
  RAISE NOTICE '';
  RAISE NOTICE 'Review the results above to find:';
  RAISE NOTICE '1. Exact column names in user_profiles';
  RAISE NOTICE '2. All foreign key relationships';
  RAISE NOTICE '3. Current RLS policies';
  RAISE NOTICE '4. Whether postgres role has necessary permissions';
  RAISE NOTICE '5. Trigger function code';
  RAISE NOTICE '';
  RAISE NOTICE 'Look for any ❌ marks - those indicate problems!';
  RAISE NOTICE '';
END $$;
