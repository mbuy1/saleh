-- ============================================================================
-- Create profile for existing user: baharista1@gmail.com
-- ============================================================================
-- User ID: 3c6eabfe-445e-4e40-954c-8932d58148e8
-- This user was created before the trigger fix, so no profile exists
-- ============================================================================

-- Insert profile manually
INSERT INTO public.user_profiles (
  auth_user_id,
  email,
  display_name,
  role,
  is_active
) VALUES (
  '3c6eabfe-445e-4e40-954c-8932d58148e8',
  'baharista1@gmail.com',
  'Baharista',
  'merchant',  -- أو 'customer' أو 'admin' حسب الحاجة
  true
)
ON CONFLICT (auth_user_id) DO NOTHING;

-- Verify the profile was created
SELECT 
  id,
  auth_user_id,
  email,
  display_name,
  role,
  is_active,
  created_at
FROM public.user_profiles
WHERE auth_user_id = '3c6eabfe-445e-4e40-954c-8932d58148e8';

SELECT '✅ Profile created for baharista1@gmail.com' AS status;
