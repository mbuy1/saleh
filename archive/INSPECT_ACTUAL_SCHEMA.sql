-- ========================================
-- فحص Schema الفعلي لـ user_profiles
-- لتحديد المشكلة الحقيقية في التسجيل
-- ========================================

\echo '=== 1. هيكل جدول user_profiles الفعلي ==='
SELECT 
  column_name AS "اسم العمود",
  data_type AS "نوع البيانات",
  is_nullable AS "يقبل NULL",
  column_default AS "القيمة الافتراضية",
  character_maximum_length AS "الطول الأقصى"
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'user_profiles'
ORDER BY ordinal_position;

\echo ''
\echo '=== 2. القيود (Constraints) على user_profiles ==='
SELECT 
  conname AS "اسم القيد",
  contype AS "النوع",
  CASE contype
    WHEN 'p' THEN 'PRIMARY KEY'
    WHEN 'f' THEN 'FOREIGN KEY'
    WHEN 'u' THEN 'UNIQUE'
    WHEN 'c' THEN 'CHECK'
    ELSE contype::text
  END AS "وصف النوع",
  pg_get_constraintdef(oid) AS "تعريف القيد"
FROM pg_constraint
WHERE conrelid = 'public.user_profiles'::regclass
ORDER BY contype;

\echo ''
\echo '=== 3. الفهارس (Indexes) على user_profiles ==='
SELECT 
  indexname AS "اسم الفهرس",
  indexdef AS "تعريف الفهرس"
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename = 'user_profiles';

\echo ''
\echo '=== 4. سياسات RLS على user_profiles ==='
SELECT 
  schemaname AS "المخطط",
  tablename AS "الجدول",
  policyname AS "اسم السياسة",
  permissive AS "مسموح",
  roles AS "الأدوار",
  cmd AS "الأمر",
  qual AS "شرط USING",
  with_check AS "شرط WITH CHECK"
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'user_profiles';

\echo ''
\echo '=== 5. حالة RLS على user_profiles ==='
SELECT 
  tablename AS "اسم الجدول",
  rowsecurity AS "RLS مفعل؟"
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'user_profiles';

\echo ''
\echo '=== 6. الصلاحيات على user_profiles ==='
SELECT 
  grantee AS "المستخدم/الدور",
  privilege_type AS "نوع الصلاحية"
FROM information_schema.table_privileges
WHERE table_schema = 'public'
  AND table_name = 'user_profiles'
ORDER BY grantee, privilege_type;

\echo ''
\echo '=== 7. فحص trigger function الحالي ==='
SELECT 
  p.proname AS "اسم الـ Function",
  pg_get_functiondef(p.oid) AS "كود الـ Function"
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
  AND p.proname LIKE '%auth_user%';

\echo ''
\echo '=== 8. فحص triggers على auth.users ==='
SELECT 
  tgname AS "اسم الـ Trigger",
  tgenabled AS "مفعل؟",
  pg_get_triggerdef(oid) AS "تعريف الـ Trigger"
FROM pg_trigger
WHERE tgrelid = 'auth.users'::regclass
  AND tgname LIKE '%auth_user%';

\echo ''
\echo '=== 9. عدد السجلات الحالية ==='
SELECT 
  (SELECT COUNT(*) FROM auth.users) AS "عدد المستخدمين في auth.users",
  (SELECT COUNT(*) FROM public.user_profiles) AS "عدد البروفايلات في user_profiles",
  (SELECT COUNT(*) FROM auth.users au 
   WHERE NOT EXISTS (
     SELECT 1 FROM public.user_profiles up WHERE up.id = au.id
   )) AS "مستخدمين بدون profiles";

\echo ''
\echo '=== 10. فحص وجود جدول mbuy_users ==='
SELECT 
  EXISTS(
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'mbuy_users'
  ) AS "mbuy_users موجود؟";

\echo ''
\echo '=== 11. اختبار صلاحيات postgres role ==='
-- محاولة INSERT تجريبي (سيتم ROLLBACK)
BEGIN;
SET ROLE postgres;

DO $$
BEGIN
  -- محاولة INSERT مع قيم وهمية
  INSERT INTO public.user_profiles (
    id, role, display_name, email
  ) VALUES (
    '00000000-0000-0000-0000-000000000099'::UUID,
    'customer',
    'Test User',
    'test@example.com'
  );
  
  RAISE NOTICE '✅ postgres role يمكنه INSERT في user_profiles';
  
  -- حذف السجل التجريبي
  DELETE FROM public.user_profiles 
  WHERE id = '00000000-0000-0000-0000-000000000099'::UUID;
  
EXCEPTION WHEN OTHERS THEN
  RAISE WARNING '❌ postgres role لا يمكنه INSERT: %', SQLERRM;
END $$;

ROLLBACK;

\echo ''
\echo '=== 12. تشخيص مشكلة التسجيل ==='
DO $$
DECLARE
  has_id_column BOOLEAN;
  has_auth_user_id_column BOOLEAN;
  has_mbuy_user_id_column BOOLEAN;
  has_id_fk BOOLEAN;
  mbuy_user_id_nullable BOOLEAN;
  rls_enabled BOOLEAN;
  has_postgres_policy BOOLEAN;
BEGIN
  -- فحص الأعمدة
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_profiles' AND column_name = 'id'
  ) INTO has_id_column;
  
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_profiles' AND column_name = 'auth_user_id'
  ) INTO has_auth_user_id_column;
  
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_profiles' AND column_name = 'mbuy_user_id'
  ) INTO has_mbuy_user_id_column;
  
  -- فحص Foreign Key على id
  SELECT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.user_profiles'::regclass
    AND conname LIKE '%id%fkey%'
    AND confrelid = 'auth.users'::regclass
  ) INTO has_id_fk;
  
  -- فحص mbuy_user_id nullable
  IF has_mbuy_user_id_column THEN
    SELECT is_nullable = 'YES' INTO mbuy_user_id_nullable
    FROM information_schema.columns
    WHERE table_name = 'user_profiles' AND column_name = 'mbuy_user_id';
  END IF;
  
  -- فحص RLS
  SELECT rowsecurity INTO rls_enabled
  FROM pg_tables
  WHERE tablename = 'user_profiles';
  
  -- فحص postgres policy
  SELECT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'user_profiles'
    AND (policyname LIKE '%postgres%' OR policyname LIKE '%service_role%')
  ) INTO has_postgres_policy;
  
  -- طباعة التشخيص
  RAISE NOTICE '====================================';
  RAISE NOTICE 'تشخيص مشكلة التسجيل:';
  RAISE NOTICE '====================================';
  RAISE NOTICE 'هيكل الجدول:';
  RAISE NOTICE '  ✓ عمود id موجود: %', has_id_column;
  RAISE NOTICE '  ✓ عمود auth_user_id موجود: %', has_auth_user_id_column;
  RAISE NOTICE '  ✓ عمود mbuy_user_id موجود: %', has_mbuy_user_id_column;
  RAISE NOTICE '';
  RAISE NOTICE 'القيود:';
  RAISE NOTICE '  ✓ id → auth.users(id) FK موجود: %', has_id_fk;
  IF has_mbuy_user_id_column THEN
    RAISE NOTICE '  ✓ mbuy_user_id يقبل NULL: %', mbuy_user_id_nullable;
  END IF;
  RAISE NOTICE '';
  RAISE NOTICE 'الأمان:';
  RAISE NOTICE '  ✓ RLS مفعل: %', rls_enabled;
  RAISE NOTICE '  ✓ سياسة postgres موجودة: %', has_postgres_policy;
  RAISE NOTICE '';
  
  -- تحديد المشكلة
  IF NOT has_id_column AND NOT has_auth_user_id_column THEN
    RAISE WARNING '🔴 مشكلة: لا يوجد عمود للربط مع auth.users!';
  END IF;
  
  IF has_mbuy_user_id_column AND NOT mbuy_user_id_nullable THEN
    RAISE WARNING '🔴 مشكلة: mbuy_user_id لا يقبل NULL - سيفشل التسجيل!';
    RAISE NOTICE '💡 الحل: ALTER TABLE user_profiles ALTER COLUMN mbuy_user_id DROP NOT NULL;';
  END IF;
  
  IF rls_enabled AND NOT has_postgres_policy THEN
    RAISE WARNING '🔴 مشكلة: RLS مفعل لكن لا توجد سياسة لـ postgres!';
    RAISE NOTICE '💡 الحل: إضافة CREATE POLICY للـ postgres role';
  END IF;
  
  IF has_id_column AND NOT has_id_fk THEN
    RAISE WARNING '⚠️ تحذير: عمود id موجود لكن Foreign Key مفقود';
    RAISE NOTICE '💡 الحل: ALTER TABLE user_profiles ADD CONSTRAINT ... FOREIGN KEY (id) REFERENCES auth.users(id);';
  END IF;
  
END $$;

\echo ''
\echo '=== تم الانتهاء من الفحص ==='
