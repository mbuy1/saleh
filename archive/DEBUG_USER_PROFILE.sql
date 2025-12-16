-- ============================================================================
-- Debug: Check existing user profile for baharista1@gmail.com
-- ============================================================================

-- 1. Check if user exists in auth.users
SELECT 
  id,
  email,
  created_at,
  raw_user_meta_data->>'role' as metadata_role
FROM auth.users
WHERE email = 'baharista1@gmail.com';

-- 2. Check if profile exists in user_profiles
SELECT 
  id,
  auth_user_id,
  email,
  display_name,
  role,
  is_active,
  store_id,
  created_at
FROM public.user_profiles
WHERE auth_user_id = '3c6eabfe-445e-4e40-954c-8932d58148e8'
   OR email = 'baharista1@gmail.com';

-- 3. Check RLS policies on user_profiles
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE tablename = 'user_profiles'
ORDER BY policyname;

-- 4. Test query as service_role would do it
SET LOCAL ROLE service_role;
SELECT 
  id,
  auth_user_id,
  role,
  store_id
FROM public.user_profiles
WHERE auth_user_id = '3c6eabfe-445e-4e40-954c-8932d58148e8';
RESET ROLE;

-- If profile doesn't exist, show count of all profiles
SELECT 
  COUNT(*) as total_profiles,
  COUNT(CASE WHEN role = 'merchant' THEN 1 END) as merchant_profiles,
  COUNT(CASE WHEN auth_user_id IS NULL THEN 1 END) as null_auth_user_ids
FROM public.user_profiles;
