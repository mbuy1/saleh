-- ============================================
-- Migration: حذف مستخدم baharista1@gmail.com
-- التاريخ: 2025-01-01
-- ============================================

-- حذف المستخدم من auth.users (سيحذف تلقائياً جميع السجلات المرتبطة بسبب CASCADE)
DO $$
DECLARE
  user_uuid UUID;
BEGIN
  -- البحث عن المستخدم في auth.users
  SELECT id INTO user_uuid
  FROM auth.users
  WHERE email = 'baharista1@gmail.com';
  
  IF user_uuid IS NOT NULL THEN
    -- حذف المستخدم من auth.users
    -- سيحذف تلقائياً من: user_profiles, stores, carts, orders, wallets, points_accounts, story_views, story_likes, user_fcm_tokens
    DELETE FROM auth.users WHERE id = user_uuid;
    
    RAISE NOTICE '✅ تم حذف المستخدم: baharista1@gmail.com (ID: %)', user_uuid;
  ELSE
    -- إذا لم يوجد في auth.users، جرب حذفه من user_profiles مباشرة
    SELECT id INTO user_uuid
    FROM user_profiles
    WHERE email = 'baharista1@gmail.com';
    
    IF user_uuid IS NOT NULL THEN
      -- حذف من user_profiles (سيحذف السجلات المرتبطة)
      DELETE FROM user_profiles WHERE id = user_uuid;
      RAISE NOTICE '✅ تم حذف المستخدم من user_profiles: baharista1@gmail.com (ID: %)', user_uuid;
    ELSE
      RAISE NOTICE '❌ المستخدم غير موجود: baharista1@gmail.com';
    END IF;
  END IF;
END $$;

