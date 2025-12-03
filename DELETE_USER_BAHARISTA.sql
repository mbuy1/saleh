-- ============================================
-- حذف مستخدم baharista1@gmail.com من جميع الجداول
-- ============================================

-- 1. البحث عن المستخدم في auth.users
SELECT id, email, created_at 
FROM auth.users 
WHERE email = 'baharista1@gmail.com';

-- 2. البحث عن المستخدم في user_profiles
SELECT id, email, role, display_name 
FROM user_profiles 
WHERE email = 'baharista1@gmail.com';

-- 3. حذف المستخدم (سيحذف تلقائياً جميع السجلات المرتبطة بسبب CASCADE)
-- استبدل USER_ID_HERE بـ ID المستخدم من النتائج أعلاه
-- DELETE FROM auth.users WHERE id = 'USER_ID_HERE';

-- أو حذف مباشر بالبريد الإلكتروني:
DO $$
DECLARE
  user_uuid UUID;
BEGIN
  -- البحث عن المستخدم
  SELECT id INTO user_uuid
  FROM auth.users
  WHERE email = 'baharista1@gmail.com';
  
  IF user_uuid IS NOT NULL THEN
    -- حذف المستخدم (سيحذف تلقائياً جميع السجلات المرتبطة)
    DELETE FROM auth.users WHERE id = user_uuid;
    RAISE NOTICE '✅ تم حذف المستخدم: baharista1@gmail.com (ID: %)', user_uuid;
  ELSE
    -- إذا لم يوجد في auth.users، جرب حذفه من user_profiles
    SELECT id INTO user_uuid
    FROM user_profiles
    WHERE email = 'baharista1@gmail.com';
    
    IF user_uuid IS NOT NULL THEN
      DELETE FROM user_profiles WHERE id = user_uuid;
      RAISE NOTICE '✅ تم حذف المستخدم من user_profiles: baharista1@gmail.com (ID: %)', user_uuid;
    ELSE
      RAISE NOTICE '❌ المستخدم غير موجود: baharista1@gmail.com';
    END IF;
  END IF;
END $$;

