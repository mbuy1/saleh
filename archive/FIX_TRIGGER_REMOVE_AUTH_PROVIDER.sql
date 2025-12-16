-- ============================================================================
-- FIX: Remove auth_provider column from trigger
-- ============================================================================
-- Problem: Trigger tries to insert auth_provider column which doesn't exist
-- Solution: Remove auth_provider from INSERT statement
-- ============================================================================

-- Drop and recreate trigger function WITHOUT auth_provider
CREATE OR REPLACE FUNCTION public.handle_new_auth_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
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
  
  -- Insert with columns that exist (NO auth_provider)
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

-- Test the trigger
DO $$
DECLARE
  test_uuid UUID := gen_random_uuid();
  test_email TEXT := 'trigger-test-fix-' || floor(random() * 10000)::text || '@test.com';
BEGIN
  -- Insert test user
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
    jsonb_build_object('full_name', 'Trigger Fix Test', 'role', 'merchant'),
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
    RAISE NOTICE '✅ SUCCESS: Trigger created profile correctly!';
    
    -- Show the created profile
    RAISE NOTICE 'Profile data: %', (
      SELECT row_to_json(up.*) 
      FROM user_profiles up 
      WHERE auth_user_id = test_uuid
    );
    
    -- Cleanup
    DELETE FROM public.user_profiles WHERE auth_user_id = test_uuid;
    DELETE FROM auth.users WHERE id = test_uuid;
    
    RAISE NOTICE '✅ Test cleaned up';
  ELSE
    RAISE NOTICE '❌ FAILED: Trigger did not create profile';
  END IF;
  
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE '❌ ERROR: %', SQLERRM;
  
  -- Cleanup
  BEGIN
    DELETE FROM public.user_profiles WHERE auth_user_id = test_uuid;
    DELETE FROM auth.users WHERE id = test_uuid;
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END $$;

-- Show confirmation
SELECT '✅ Trigger function updated - auth_provider column removed' AS status;
