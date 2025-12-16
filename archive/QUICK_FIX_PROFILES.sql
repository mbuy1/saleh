-- Quick SQL Fix for Missing Profiles
-- Run this in Supabase SQL Editor

-- Create missing profiles for all auth users
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

-- Verify fix
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
