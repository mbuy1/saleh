-- ========================================
-- فحص وإصلاح بنية البيانات للتتوافق مع product_create
-- تاريخ: يناير 2025
-- الهدف: التأكد من توافق auth.users → user_profiles → stores → products
-- ========================================
--
-- ⚠️ تحذير مهم:
-- هذا السكربت يحتوي على استعلامات SELECT فقط للفحص
-- جميع أوامر INSERT/UPDATE/DELETE معلقة بالتعليقات وتحتاج مراجعة قبل التنفيذ
--
-- ========================================
-- المنطق المتوقع:
-- ========================================
-- 1. jwt.sub = auth.users.id
-- 2. user_profiles.id = auth.users.id (FK مباشر)
-- 3. stores.owner_id = user_profiles.id (FK)
-- 4. products.store_id = stores.id (FK)
-- 5. user_profiles.role = 'merchant' للتجار
-- 6. stores.is_active = true للمتاجر النشطة
-- ========================================

-- ========================================
-- القسم A: فحص الوضع الحالي (SELECT فقط)
-- ========================================

-- ========================================
-- A1. فحص بنية الجداول الأساسية
-- ========================================
DO $$
DECLARE
  user_profiles_id_type TEXT;
  stores_owner_id_type TEXT;
  products_store_id_type TEXT;
  stores_has_is_active BOOLEAN;
BEGIN
  -- التحقق من نوع عمود user_profiles.id
  SELECT data_type INTO user_profiles_id_type
  FROM information_schema.columns
  WHERE table_schema = 'public' AND table_name = 'user_profiles' AND column_name = 'id';
  
  -- التحقق من نوع عمود stores.owner_id
  SELECT data_type INTO stores_owner_id_type
  FROM information_schema.columns
  WHERE table_schema = 'public' AND table_name = 'stores' AND column_name = 'owner_id';
  
  -- التحقق من نوع عمود products.store_id
  SELECT data_type INTO products_store_id_type
  FROM information_schema.columns
  WHERE table_schema = 'public' AND table_name = 'products' AND column_name = 'store_id';
  
  -- التحقق من وجود عمود is_active في stores
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'stores' AND column_name = 'is_active'
  ) INTO stores_has_is_active;
  
  RAISE NOTICE '========================================';
  RAISE NOTICE '📊 تقرير بنية الجداول:';
  RAISE NOTICE '========================================';
  RAISE NOTICE 'user_profiles.id type: %', user_profiles_id_type;
  RAISE NOTICE 'stores.owner_id type: %', stores_owner_id_type;
  RAISE NOTICE 'products.store_id type: %', products_store_id_type;
  RAISE NOTICE 'stores.has_is_active: %', stores_has_is_active;
  RAISE NOTICE '========================================';
END $$;

-- ========================================
-- A2. فحص المستخدمين في auth.users الذين لا يملكون profile
-- ========================================
SELECT 
  '⚠️ المستخدمون بدون profile' as check_type,
  au.id as auth_user_id,
  au.email,
  au.created_at as user_created_at
FROM auth.users au
LEFT JOIN public.user_profiles up ON au.id = up.id
WHERE up.id IS NULL
ORDER BY au.created_at DESC;

-- ========================================
-- A3. فحص الصفوف في user_profiles التي لا تقابلها users في auth.users
-- ========================================
SELECT 
  '⚠️ Profiles بدون مستخدم في auth.users' as check_type,
  up.id as profile_id,
  up.role,
  up.display_name,
  up.email,
  up.created_at
FROM public.user_profiles up
LEFT JOIN auth.users au ON up.id = au.id
WHERE au.id IS NULL
ORDER BY up.created_at DESC;

-- ========================================
-- A4. فحص المتاجر التي owner_id لا يوجد في user_profiles
-- ========================================
SELECT 
  '⚠️ المتاجر بدون owner في user_profiles' as check_type,
  s.id as store_id,
  s.owner_id,
  s.name as store_name,
  s.status,
  s.created_at
FROM public.stores s
LEFT JOIN public.user_profiles up ON s.owner_id = up.id
WHERE up.id IS NULL
ORDER BY s.created_at DESC;

-- ========================================
-- A5. فحص قيم role في user_profiles
-- ========================================
SELECT 
  '📊 توزيع الأدوار في user_profiles' as check_type,
  role,
  COUNT(*) as count,
  array_agg(id::text ORDER BY created_at DESC) FILTER (WHERE created_at > NOW() - INTERVAL '30 days') as recent_ids
FROM public.user_profiles
GROUP BY role
ORDER BY count DESC;

-- ========================================
-- A6. فحص المتاجر ومالكيها
-- ========================================
SELECT 
  '📊 المتاجر ومالكوها' as check_type,
  s.id as store_id,
  s.name as store_name,
  s.owner_id,
  s.status,
  s.is_active,
  up.id as profile_id,
  up.role as owner_role,
  up.display_name as owner_name,
  au.id as auth_user_id,
  au.email as owner_email
FROM public.stores s
LEFT JOIN public.user_profiles up ON s.owner_id = up.id
LEFT JOIN auth.users au ON up.id = au.id
ORDER BY s.created_at DESC;

-- ========================================
-- A7. فحص المنتجات والمتاجر المرتبطة بها
-- ========================================
SELECT 
  '📊 المنتجات والمتاجر' as check_type,
  p.id as product_id,
  p.name as product_name,
  p.store_id,
  s.id as store_exists,
  s.owner_id,
  s.name as store_name,
  s.is_active as store_is_active,
  up.id as owner_profile_id,
  up.role as owner_role
FROM public.products p
LEFT JOIN public.stores s ON p.store_id = s.id
LEFT JOIN public.user_profiles up ON s.owner_id = up.id
ORDER BY p.created_at DESC
LIMIT 50;

-- ========================================
-- A8. فحص Foreign Keys والعلاقات
-- ========================================
SELECT 
  '🔗 Foreign Keys في الجداول' as check_type,
  tc.table_name,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name,
  rc.delete_rule
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
JOIN information_schema.referential_constraints AS rc
  ON tc.constraint_name = rc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
  AND tc.table_name IN ('user_profiles', 'stores', 'products')
ORDER BY tc.table_name, kcu.column_name;

-- ========================================
-- القسم B: أوامر إصلاح مقترحة (معلقة بالتعليقات)
-- ========================================
-- ⚠️ جميع أوامر INSERT/UPDATE/DELETE في هذا القسم معلقة
-- ⚠️ يجب مراجعة النتائج من القسم A قبل فك التعليقات
-- ⚠️ يجب تعديل قيم PLACEHOLDER قبل التنفيذ

-- ========================================
-- B1. التأكد من وجود عمود is_active في stores
-- ========================================
/*
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' 
    AND table_name = 'stores' 
    AND column_name = 'is_active'
  ) THEN
    ALTER TABLE public.stores 
      ADD COLUMN is_active BOOLEAN DEFAULT true;
    
    -- تحديث القيم الموجودة إلى true
    UPDATE public.stores 
    SET is_active = true 
    WHERE is_active IS NULL;
    
    RAISE NOTICE '✅ تم إضافة عمود is_active إلى stores';
  ELSE
    RAISE NOTICE '⚠️ عمود is_active موجود بالفعل في stores';
  END IF;
END $$;
*/

-- ========================================
-- B2. إنشاء user_profiles للمستخدمين المفقودين
-- ========================================
/*
-- ⚠️ يجب تعديل قائمة merchant_user_ids قبل التنفيذ
-- ⚠️ ضع UUIDs المستخدمين الذين يجب أن يكونوا تجار

DO $$
DECLARE
  merchant_user_ids UUID[] := ARRAY[
    'PLACEHOLDER_USER_ID_1'::UUID,
    'PLACEHOLDER_USER_ID_2'::UUID
    -- أضف UUIDs المستخدمين الذين يجب أن يكونوا تجار
  ];
  auth_user RECORD;
BEGIN
  FOR auth_user IN 
    SELECT au.id, au.email, au.raw_user_meta_data
    FROM auth.users au
    LEFT JOIN public.user_profiles up ON au.id = up.id
    WHERE up.id IS NULL
  LOOP
    INSERT INTO public.user_profiles (
      id,
      role,
      display_name,
      email,
      created_at,
      updated_at
    ) VALUES (
      auth_user.id,
      CASE 
        WHEN auth_user.id = ANY(merchant_user_ids) THEN 'merchant'
        ELSE 'customer'
      END,
      COALESCE(
        auth_user.raw_user_meta_data->>'display_name',
        auth_user.raw_user_meta_data->>'full_name',
        split_part(auth_user.email, '@', 1),
        'User'
      ),
      auth_user.email,
      NOW(),
      NOW()
    )
    ON CONFLICT (id) DO NOTHING;
    
    RAISE NOTICE '✅ تم إنشاء profile للمستخدم: % (%)', auth_user.email, auth_user.id;
  END LOOP;
END $$;
*/

-- ========================================
-- B3. تصحيح owner_id في stores ليطابق user_profiles.id
-- ========================================
/*
-- ⚠️ هذا الأمر يصلح المتاجر التي owner_id لا يطابق user_profiles.id
-- ⚠️ يجب مراجعة النتائج من A6 قبل التنفيذ

UPDATE public.stores s
SET owner_id = up.id
FROM public.user_profiles up
WHERE s.owner_id IS NOT NULL
  AND EXISTS (
    SELECT 1 FROM auth.users au 
    WHERE au.id = up.id 
    AND au.email = 'PLACEHOLDER_EMAIL' -- ⚠️ ضع الإيميل الحقيقي
  )
  AND NOT EXISTS (
    SELECT 1 FROM public.user_profiles up2 
    WHERE up2.id = s.owner_id
  );

-- التحقق من النتيجة
SELECT 
  '✅ بعد الإصلاح' as status,
  COUNT(*) as stores_with_valid_owner
FROM public.stores s
INNER JOIN public.user_profiles up ON s.owner_id = up.id;
*/

-- ========================================
-- B4. ضبط role = 'merchant' للتجار الحقيقيين
-- ========================================
/*
-- ⚠️ يجب تعديل قائمة merchant_profile_ids قبل التنفيذ
-- ⚠️ ضع UUIDs من user_profiles.id للمستخدمين الذين يجب أن يكونوا تجار

DO $$
DECLARE
  merchant_profile_ids UUID[] := ARRAY[
    'PLACEHOLDER_PROFILE_ID_1'::UUID,
    'PLACEHOLDER_PROFILE_ID_2'::UUID
    -- أضف UUIDs من user_profiles.id للمستخدمين الذين يجب أن يكونوا تجار
  ];
BEGIN
  UPDATE public.user_profiles
  SET role = 'merchant',
      updated_at = NOW()
  WHERE id = ANY(merchant_profile_ids)
    AND role != 'merchant';
  
  RAISE NOTICE '✅ تم ضبط role = merchant لـ % مستخدم', array_length(merchant_profile_ids, 1);
END $$;
*/

-- ========================================
-- B5. ضبط is_active = true للمتاجر النشطة
-- ========================================
/*
-- ⚠️ هذا الأمر يفعّل جميع المتاجر التي لديها owner صحيح
-- ⚠️ يجب مراجعة النتائج من A6 قبل التنفيذ

UPDATE public.stores s
SET is_active = true,
    updated_at = NOW()
WHERE EXISTS (
  SELECT 1 
  FROM public.user_profiles up 
  WHERE up.id = s.owner_id 
  AND up.role = 'merchant'
)
AND (
  is_active IS NULL 
  OR is_active = false
  OR status = 'active'
);

-- التحقق من النتيجة
SELECT 
  '✅ بعد الإصلاح' as status,
  COUNT(*) as active_stores
FROM public.stores s
INNER JOIN public.user_profiles up ON s.owner_id = up.id
WHERE s.is_active = true
  AND up.role = 'merchant';
*/

-- ========================================
-- B6. إزالة المتاجر اليتيمة (بدون owner)
-- ========================================
/*
-- ⚠️ تحذير: هذا الأمر يحذف المتاجر التي لا تملك owner
-- ⚠️ يجب مراجعة النتائج من A4 قبل التنفيذ
-- ⚠️ قد يحذف بيانات مهمة - استخدم بحذر!

DELETE FROM public.stores s
WHERE NOT EXISTS (
  SELECT 1 
  FROM public.user_profiles up 
  WHERE up.id = s.owner_id
);

-- التحقق من النتيجة
SELECT 
  '✅ بعد الإصلاح' as status,
  COUNT(*) as orphaned_stores
FROM public.stores s
LEFT JOIN public.user_profiles up ON s.owner_id = up.id
WHERE up.id IS NULL;
*/

-- ========================================
-- B7. إزالة المنتجات اليتيمة (بدون store)
-- ========================================
/*
-- ⚠️ تحذير: هذا الأمر يحذف المنتجات التي لا تملك store
-- ⚠️ يجب مراجعة النتائج من A7 قبل التنفيذ
-- ⚠️ قد يحذف بيانات مهمة - استخدم بحذر!

DELETE FROM public.products p
WHERE NOT EXISTS (
  SELECT 1 
  FROM public.stores s 
  WHERE s.id = p.store_id
);

-- التحقق من النتيجة
SELECT 
  '✅ بعد الإصلاح' as status,
  COUNT(*) as orphaned_products
FROM public.products p
LEFT JOIN public.stores s ON p.store_id = s.id
WHERE s.id IS NULL;
*/

-- ========================================
-- القسم C: ملاحظات على RLS Policies
-- ========================================

-- ========================================
-- C1. التحقق من RLS Policies الحالية
-- ========================================
SELECT 
  '🔐 RLS Policies الحالية' as check_type,
  tablename,
  policyname,
  cmd as operation,
  qual as using_expression,
  with_check as with_check_expression
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename IN ('user_profiles', 'stores', 'products')
ORDER BY tablename, policyname;

-- ========================================
-- C2. ملاحظات على RLS Policies المتوقعة
-- ========================================
/*
📋 RLS Policies المتوقعة (موجودة في 20250106000005_simplify_rls_policies.sql):

1. user_profiles:
   - SELECT: USING (id = auth.uid())
   - ✅ متوافق مع المنطق: auth.users.id = user_profiles.id

2. stores:
   - SELECT (public): USING (status = 'active' AND visibility = 'public')
   - SELECT (owner): USING (auth.uid() = owner_id)
   - INSERT/UPDATE/DELETE: USING (auth.uid() = owner_id)
   - ✅ متوافق مع المنطق: stores.owner_id = user_profiles.id = auth.users.id

3. products:
   - SELECT (public): USING (is_active = true)
   - INSERT/UPDATE/DELETE: 
     USING (EXISTS (SELECT 1 FROM stores WHERE stores.id = products.store_id AND stores.owner_id = auth.uid()))
   - ✅ متوافق مع المنطق: products.store_id → stores.id → stores.owner_id = auth.uid()

⚠️ ملاحظات مهمة:
- Edge Function يستخدم SERVICE_ROLE_KEY، لذلك يتجاوز RLS تلقائياً
- RLS Policies مهمة للاستعلامات المباشرة من Flutter/Worker باستخدام ANON_KEY
- يجب التأكد من تفعيل RLS على جميع الجداول الثلاثة
*/

-- ========================================
-- C3. التحقق من تفعيل RLS
-- ========================================
SELECT 
  '🔐 حالة تفعيل RLS' as check_type,
  schemaname,
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN ('user_profiles', 'stores', 'products')
ORDER BY tablename;

-- ========================================
-- C4. التحقق من Foreign Keys
-- ========================================
SELECT 
  '🔗 Foreign Keys المتوقعة' as check_type,
  'user_profiles.id' as column_name,
  'auth.users.id' as references_table_column,
  CASE 
    WHEN EXISTS (
      SELECT 1 FROM information_schema.table_constraints tc
      JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
      JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name
      WHERE tc.table_name = 'user_profiles'
      AND kcu.column_name = 'id'
      AND ccu.table_name = 'users'
      AND ccu.table_schema = 'auth'
    ) THEN '✅ موجود'
    ELSE '⚠️ غير موجود'
  END as status
UNION ALL
SELECT 
  'stores.owner_id',
  'user_profiles.id',
  CASE 
    WHEN EXISTS (
      SELECT 1 FROM information_schema.table_constraints tc
      JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
      JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name
      WHERE tc.table_name = 'stores'
      AND kcu.column_name = 'owner_id'
      AND ccu.table_name = 'user_profiles'
    ) THEN '✅ موجود'
    ELSE '⚠️ غير موجود'
  END
UNION ALL
SELECT 
  'products.store_id',
  'stores.id',
  CASE 
    WHEN EXISTS (
      SELECT 1 FROM information_schema.table_constraints tc
      JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
      JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name
      WHERE tc.table_name = 'products'
      AND kcu.column_name = 'store_id'
      AND ccu.table_name = 'stores'
    ) THEN '✅ موجود'
    ELSE '⚠️ غير موجود'
  END;

-- ========================================
-- ملخص تنفيذ السكربت
-- ========================================
DO $$
BEGIN
  RAISE NOTICE '========================================';
  RAISE NOTICE '✅ تم تنفيذ فحص الوضع الحالي';
  RAISE NOTICE '========================================';
  RAISE NOTICE '';
  RAISE NOTICE '📋 الخطوات التالية:';
  RAISE NOTICE '1. راجع نتائج القسم A (فحص الوضع الحالي)';
  RAISE NOTICE '2. راجع القسم B (أوامر الإصلاح المقترحة)';
  RAISE NOTICE '3. عدّل قيم PLACEHOLDER في القسم B';
  RAISE NOTICE '4. فك التعليق عن الأوامر التي تحتاجها';
  RAISE NOTICE '5. نفّذ الأوامر المطلوبة خطوة بخطوة';
  RAISE NOTICE '';
  RAISE NOTICE '⚠️ لا تنفّذ جميع أوامر B دفعة واحدة!';
  RAISE NOTICE '⚠️ راجع كل أمر بعناية قبل تنفيذه!';
  RAISE NOTICE '========================================';
END $$;

