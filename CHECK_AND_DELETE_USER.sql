-- ============================================
-- البحث عن وحذف مستخدم baharista1@gmail.com
-- ============================================

-- 1. البحث في auth.users
SELECT 'auth.users' as table_name, id, email, created_at 
FROM auth.users 
WHERE email ILIKE '%baharista%'
UNION ALL
-- 2. البحث في user_profiles
SELECT 'user_profiles' as table_name, id, email, created_at 
FROM user_profiles 
WHERE email ILIKE '%baharista%';

-- 3. حذف المستخدم (انسخ ID من النتائج أعلاه واستخدمه)
-- DELETE FROM auth.users WHERE id = 'USER_ID_HERE';

