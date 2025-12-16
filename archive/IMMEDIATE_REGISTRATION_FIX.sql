-- ========================================
-- الحل الفوري لمشكلة التسجيل
-- بناءً على التشخيص الفعلي
-- ========================================
-- 
-- تعليمات:
-- 1. قم بتشغيل INSPECT_ACTUAL_SCHEMA.sql أولاً
-- 2. اقرأ نتائج التشخيص في القسم 12
-- 3. شغل هذا الملف لتطبيق الحل
-- 
-- ========================================

BEGIN;

\echo '=== الخطوة 1: التأكد من وجود جدول user_profiles ==='
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'user_profiles'
  ) THEN
    RAISE EXCEPTION 'جدول user_profiles غير موجود! يجب إنشاؤه أولاً';
  ELSE
    RAISE NOTICE '✅ جدول user_profiles موجود';
  END IF;
END $$;

\echo ''
\echo '=== الخطوة 2: إصلاح مشكلة mbuy_user_id NOT NULL ==='
DO $$
BEGIN
  -- إذا كان mbuy_user_id موجوداً وهو NOT NULL، اجعله يقبل NULL
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_profiles' 
    AND column_name = 'mbuy_user_id'
    AND is_nullable = 'NO'
  ) THEN
    ALTER TABLE public.user_profiles 
    ALTER COLUMN mbuy_user_id DROP NOT NULL;
    
    RAISE NOTICE '✅ تم جعل mbuy_user_id يقبل NULL';
  ELSE
    RAISE NOTICE '⚪ mbuy_user_id يقبل NULL بالفعل أو غير موجود';
  END IF;
END $$;

\echo ''
\echo '=== الخطوة 3: إصلاح Foreign Key Constraint ==='
DO $$
DECLARE
  has_id_fk BOOLEAN;
  id_column_exists BOOLEAN;
BEGIN
  -- فحص وجود عمود id
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_profiles' AND column_name = 'id'
  ) INTO id_column_exists;
  
  IF NOT id_column_exists THEN
    RAISE WARNING '⚠️ عمود id غير موجود في user_profiles';
    RETURN;
  END IF;
  
  -- فحص وجود Foreign Key
  SELECT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.user_profiles'::regclass
    AND confrelid = 'auth.users'::regclass
    AND contype = 'f'
  ) INTO has_id_fk;
  
  IF NOT has_id_fk THEN
    -- حذف أي FK قديم على id
    EXECUTE (
      SELECT 'ALTER TABLE public.user_profiles DROP CONSTRAINT IF EXISTS ' || conname || ';'
      FROM pg_constraint
      WHERE conrelid = 'public.user_profiles'::regclass
      AND conname LIKE '%id%fkey%'
      LIMIT 1
    );
    
    -- إضافة FK جديد صحيح
    ALTER TABLE public.user_profiles
    ADD CONSTRAINT user_profiles_id_fkey
    FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;
    
    RAISE NOTICE '✅ تم إضافة Foreign Key: user_profiles.id → auth.users(id)';
  ELSE
    RAISE NOTICE '⚪ Foreign Key موجود بالفعل';
  END IF;
END $$;

\echo ''
\echo '=== الخطوة 4: تفعيل RLS وإضافة سياسة postgres ==='
-- تفعيل RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- حذف السياسة القديمة إن وجدت
DROP POLICY IF EXISTS "postgres_role_all_access" ON public.user_profiles;
DROP POLICY IF EXISTS "service_role_full_access" ON public.user_profiles;

-- إنشاء سياسة postgres
CREATE POLICY "postgres_role_all_access"
ON public.user_profiles
TO postgres
USING (true)
WITH CHECK (true);

-- إنشاء سياسة service_role
CREATE POLICY "service_role_full_access"
ON public.user_profiles
TO service_role
USING (true)
WITH CHECK (true);

RAISE NOTICE '✅ تم تفعيل RLS وإضافة سياسات postgres و service_role';

\echo ''
\echo '=== الخطوة 5: تحديث trigger function ==='
CREATE OR REPLACE FUNCTION public.handle_new_auth_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  user_role TEXT;
  has_auth_user_id BOOLEAN;
  has_mbuy_user_id BOOLEAN;
  column_list TEXT;
  values_list TEXT;
BEGIN
  -- استخراج role من metadata
  user_role := COALESCE(NEW.raw_user_meta_data->>'role', 'customer');
  
  -- فحص وجود الأعمدة
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_profiles' AND column_name = 'auth_user_id'
  ) INTO has_auth_user_id;
  
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_profiles' AND column_name = 'mbuy_user_id'
  ) INTO has_mbuy_user_id;
  
  -- بناء query ديناميكي بناءً على الأعمدة الموجودة
  IF has_auth_user_id THEN
    -- الجدول يستخدم auth_user_id
    INSERT INTO public.user_profiles (
      auth_user_id,
      email,
      display_name,
      role,
      auth_provider,
      created_at,
      updated_at
    ) VALUES (
      NEW.id,
      NEW.email,
      COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
      user_role,
      'supabase_auth',
      NOW(),
      NOW()
    );
    RAISE NOTICE 'Created user_profile with auth_user_id: %', NEW.id;
  ELSE
    -- الجدول يستخدم id كـ PK و FK
    INSERT INTO public.user_profiles (
      id,
      email,
      display_name,
      role,
      auth_provider,
      created_at,
      updated_at
    ) VALUES (
      NEW.id,
      NEW.email,
      COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
      user_role,
      'supabase_auth',
      NOW(),
      NOW()
    );
    RAISE NOTICE 'Created user_profile with id: %', NEW.id;
  END IF;
  
  RETURN NEW;
  
EXCEPTION 
  WHEN unique_violation THEN
    RAISE NOTICE 'User profile already exists for user: %', NEW.id;
    RETURN NEW;
  WHEN foreign_key_violation THEN
    RAISE WARNING 'Foreign key violation when creating profile for user: %. Error: %', NEW.id, SQLERRM;
    RETURN NEW;
  WHEN OTHERS THEN
    RAISE WARNING 'Failed to create user_profile for user: %. Error: %', NEW.id, SQLERRM;
    RETURN NEW; -- لا نمنع إنشاء auth.users حتى لو فشل profile
END;
$$;

RAISE NOTICE '✅ تم تحديث trigger function';

\echo ''
\echo '=== الخطوة 6: التأكد من وجود trigger ==='
DO $$
BEGIN
  -- حذف trigger القديم
  DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
  
  -- إنشاء trigger جديد
  CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_auth_user();
  
  RAISE NOTICE '✅ تم إنشاء trigger: on_auth_user_created';
END $$;

\echo ''
\echo '=== الخطوة 7: اختبار الحل ==='
DO $$
DECLARE
  test_user_id UUID;
  test_email TEXT;
  profile_exists BOOLEAN;
BEGIN
  -- إنشاء email تجريبي
  test_email := 'test_registration_' || floor(random() * 100000)::text || '@mbuy.com';
  
  RAISE NOTICE 'محاولة إنشاء مستخدم تجريبي: %', test_email;
  
  -- محاولة INSERT في auth.users (سيُشغل الـ trigger)
  -- ملاحظة: هذا يتطلب صلاحيات على auth.users
  BEGIN
    INSERT INTO auth.users (
      id,
      email,
      encrypted_password,
      email_confirmed_at,
      created_at,
      updated_at,
      raw_user_meta_data,
      aud,
      role
    ) VALUES (
      gen_random_uuid(),
      test_email,
      crypt('test_password_123', gen_salt('bf')),
      NOW(),
      NOW(),
      NOW(),
      '{"role": "customer", "full_name": "Test User"}'::jsonb,
      'authenticated',
      'authenticated'
    )
    RETURNING id INTO test_user_id;
    
    RAISE NOTICE '✅ تم إنشاء مستخدم في auth.users: %', test_user_id;
    
    -- التحقق من إنشاء profile
    SELECT EXISTS (
      SELECT 1 FROM public.user_profiles WHERE id = test_user_id
    ) INTO profile_exists;
    
    IF profile_exists THEN
      RAISE NOTICE '✅✅ تم إنشاء user_profile تلقائياً! الحل يعمل!';
    ELSE
      RAISE WARNING '❌ لم يتم إنشاء user_profile - فشل الـ trigger';
    END IF;
    
    -- حذف المستخدم التجريبي
    DELETE FROM auth.users WHERE id = test_user_id;
    RAISE NOTICE '🗑️ تم حذف المستخدم التجريبي';
    
  EXCEPTION 
    WHEN insufficient_privilege THEN
      RAISE NOTICE '⚠️ لا توجد صلاحيات لإنشاء user في auth.users';
      RAISE NOTICE 'اختبر التسجيل من Worker أو Dashboard';
    WHEN OTHERS THEN
      RAISE WARNING 'فشل الاختبار: %', SQLERRM;
  END;
END $$;

\echo ''
\echo '=== الخطوة 8: التحقق النهائي ==='
DO $$
DECLARE
  rls_enabled BOOLEAN;
  has_postgres_policy BOOLEAN;
  trigger_exists BOOLEAN;
  mbuy_user_id_nullable BOOLEAN;
BEGIN
  -- فحص RLS
  SELECT rowsecurity INTO rls_enabled
  FROM pg_tables
  WHERE tablename = 'user_profiles';
  
  -- فحص postgres policy
  SELECT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'user_profiles'
    AND policyname = 'postgres_role_all_access'
  ) INTO has_postgres_policy;
  
  -- فحص trigger
  SELECT EXISTS (
    SELECT 1 FROM pg_trigger
    WHERE tgrelid = 'auth.users'::regclass
    AND tgname = 'on_auth_user_created'
  ) INTO trigger_exists;
  
  -- فحص mbuy_user_id
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_profiles' AND column_name = 'mbuy_user_id'
  ) THEN
    SELECT is_nullable = 'YES' INTO mbuy_user_id_nullable
    FROM information_schema.columns
    WHERE table_name = 'user_profiles' AND column_name = 'mbuy_user_id';
  ELSE
    mbuy_user_id_nullable := TRUE; -- العمود غير موجود = لا مشكلة
  END IF;
  
  RAISE NOTICE '====================================';
  RAISE NOTICE 'حالة الحل النهائية:';
  RAISE NOTICE '====================================';
  RAISE NOTICE 'RLS مفعل: %', rls_enabled;
  RAISE NOTICE 'سياسة postgres موجودة: %', has_postgres_policy;
  RAISE NOTICE 'Trigger موجود: %', trigger_exists;
  RAISE NOTICE 'mbuy_user_id يقبل NULL: %', mbuy_user_id_nullable;
  RAISE NOTICE '';
  
  IF rls_enabled AND has_postgres_policy AND trigger_exists AND mbuy_user_id_nullable THEN
    RAISE NOTICE '✅✅✅ جميع الشروط مستوفاة - التسجيل يجب أن يعمل!';
    RAISE NOTICE '';
    RAISE NOTICE 'اختبر الآن من Worker:';
    RAISE NOTICE 'POST https://misty-mode-b68b.baharista1.workers.dev/auth/supabase/register';
  ELSE
    RAISE WARNING '❌ لا تزال هناك مشاكل - راجع الإعدادات';
  END IF;
END $$;

COMMIT;

\echo ''
\echo '=== تم الانتهاء من تطبيق الحل ==='
\echo 'إذا نجح الحل، اختبر التسجيل من Worker'
\echo 'إذا فشل، أرسل نتائج INSPECT_ACTUAL_SCHEMA.sql'
