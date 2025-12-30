-- ========================================
-- إصلاح جدول user_profiles و RLS Policies
-- تاريخ: يناير 2025
-- الهدف: إصلاح مشكلة FORBIDDEN عند إضافة منتج
-- ========================================

DO $$
BEGIN
  -- ========================================
  -- 1. إضافة عمود user_id إذا لم يكن موجوداً
  -- ========================================
  IF NOT EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'user_profiles' 
    AND column_name = 'user_id'
  ) THEN
    ALTER TABLE public.user_profiles 
      ADD COLUMN user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;
    
    RAISE NOTICE '✅ تم إضافة عمود user_id إلى user_profiles';
  ELSE
    RAISE NOTICE '⚠️ عمود user_id موجود بالفعل - تم تخطيه';
  END IF;

  -- ========================================
  -- 2. إضافة عمود full_name إذا لم يكن موجوداً
  -- ========================================
  IF NOT EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'user_profiles' 
    AND column_name = 'full_name'
  ) THEN
    ALTER TABLE public.user_profiles 
      ADD COLUMN full_name TEXT;
    
    RAISE NOTICE '✅ تم إضافة عمود full_name إلى user_profiles';
  ELSE
    RAISE NOTICE '⚠️ عمود full_name موجود بالفعل - تم تخطيه';
  END IF;

  -- ========================================
  -- 3. تحديث user_id = id للصفوف الموجودة
  -- ========================================
  UPDATE public.user_profiles 
  SET user_id = id 
  WHERE user_id IS NULL;
  
  RAISE NOTICE '✅ تم تحديث user_id = id للصفوف الموجودة';

  -- ========================================
  -- 4. جعل user_id NOT NULL بعد التحديث
  -- ========================================
  ALTER TABLE public.user_profiles 
    ALTER COLUMN user_id SET NOT NULL;
  
  RAISE NOTICE '✅ تم جعل user_id NOT NULL';

  -- ========================================
  -- 5. تحديث full_name من display_name للصفوف الموجودة
  -- ========================================
  UPDATE public.user_profiles 
  SET full_name = display_name 
  WHERE full_name IS NULL AND display_name IS NOT NULL;
  
  RAISE NOTICE '✅ تم تحديث full_name من display_name';

  -- ========================================
  -- 6. إضافة فهرس على user_id
  -- ========================================
  CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id 
    ON public.user_profiles(user_id);
  
  RAISE NOTICE '✅ تم إضافة فهرس على user_id';

  -- ========================================
  -- 7. إضافة فهرس على full_name
  -- ========================================
  CREATE INDEX IF NOT EXISTS idx_user_profiles_full_name 
    ON public.user_profiles(full_name);
  
  RAISE NOTICE '✅ تم إضافة فهرس على full_name';

  -- ========================================
  -- 8. إضافة CHECK constraint لضمان user_id = id دائماً
  -- ========================================
  ALTER TABLE public.user_profiles 
    DROP CONSTRAINT IF EXISTS user_profiles_user_id_equals_id;
  
  ALTER TABLE public.user_profiles
    ADD CONSTRAINT user_profiles_user_id_equals_id 
    CHECK (user_id = id);
  
  RAISE NOTICE '✅ تم إضافة CHECK constraint: user_id = id';

  -- ========================================
  -- 9. إنشاء Trigger للتزامن التلقائي
  -- ========================================
  CREATE OR REPLACE FUNCTION sync_user_profiles_user_id()
  RETURNS TRIGGER AS $$
  BEGIN
    -- تأكد أن user_id = id دائماً
    IF NEW.user_id IS NULL OR NEW.user_id != NEW.id THEN
      NEW.user_id := NEW.id;
    END IF;
    RETURN NEW;
  END;
  $$ LANGUAGE plpgsql;

  DROP TRIGGER IF EXISTS sync_user_profiles_user_id_trigger ON public.user_profiles;
  
  CREATE TRIGGER sync_user_profiles_user_id_trigger
  BEFORE INSERT OR UPDATE ON public.user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION sync_user_profiles_user_id();
  
  RAISE NOTICE '✅ تم إنشاء Trigger للتزامن التلقائي';

  -- ========================================
  -- 10. تعليقات توضيحية
  -- ========================================
  COMMENT ON COLUMN public.user_profiles.user_id IS 
    'معرّف المستخدم من auth.users (FK → auth.users.id). يجب أن يساوي id دائماً.';
  
  COMMENT ON COLUMN public.user_profiles.full_name IS 
    'الاسم الكامل للمستخدم';

  RAISE NOTICE '✅ تم إضافة التعليقات التوضيحية';

END $$;

-- ========================================
-- 11. تفعيل RLS على user_profiles
-- ========================================
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- ========================================
-- 12. حذف السياسات القديمة لـ user_profiles
-- ========================================
DROP POLICY IF EXISTS "Users can view own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can read own profile" ON public.user_profiles;

-- ========================================
-- 13. إنشاء سياسة SELECT جديدة لـ user_profiles
-- ========================================
CREATE POLICY "Users can read own profile"
ON public.user_profiles 
FOR SELECT
USING (user_id = auth.uid());

-- ========================================
-- 14. إنشاء سياسة UPDATE جديدة لـ user_profiles
-- ========================================
CREATE POLICY "Users can update own profile"
ON public.user_profiles 
FOR UPDATE
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- ========================================
-- 15. إنشاء سياسة INSERT جديدة لـ user_profiles
-- ========================================
CREATE POLICY "Users can insert own profile"
ON public.user_profiles 
FOR INSERT
WITH CHECK (user_id = auth.uid());

-- ========================================
-- 16. تفعيل RLS على products
-- ========================================
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- ========================================
-- 17. حذف السياسات القديمة لـ products
-- ========================================
DROP POLICY IF EXISTS "Merchants insert their own products" ON public.products;
DROP POLICY IF EXISTS "Merchants can insert products" ON public.products;
DROP POLICY IF EXISTS "Anyone can view active products" ON public.products;
DROP POLICY IF EXISTS "Merchants can update own products" ON public.products;

-- ========================================
-- 18. إنشاء سياسة SELECT لـ products (للجميع)
-- ========================================
CREATE POLICY "Anyone can view active products"
ON public.products 
FOR SELECT
USING (is_active = true);

-- ========================================
-- 19. إنشاء سياسة INSERT لـ products (للتجار فقط)
-- ========================================
CREATE POLICY "Merchants insert their own products"
ON public.products 
FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 
        FROM public.stores 
        INNER JOIN public.user_profiles 
          ON user_profiles.id = stores.owner_id
        WHERE stores.id = products.store_id 
        AND user_profiles.user_id = auth.uid()
        AND user_profiles.role = 'merchant'
    )
);

-- ========================================
-- 20. إنشاء سياسة UPDATE لـ products (للتجار فقط)
-- ========================================
CREATE POLICY "Merchants can update own products"
ON public.products 
FOR UPDATE
USING (
    EXISTS (
        SELECT 1 
        FROM public.stores 
        INNER JOIN public.user_profiles 
          ON user_profiles.id = stores.owner_id
        WHERE stores.id = products.store_id 
        AND user_profiles.user_id = auth.uid()
        AND user_profiles.role = 'merchant'
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 
        FROM public.stores 
        INNER JOIN public.user_profiles 
          ON user_profiles.id = stores.owner_id
        WHERE stores.id = products.store_id 
        AND user_profiles.user_id = auth.uid()
    )
);

-- ========================================
-- 21. إنشاء سياسة DELETE لـ products (للتجار فقط)
-- ========================================
CREATE POLICY "Merchants can delete own products"
ON public.products 
FOR DELETE
USING (
    EXISTS (
        SELECT 1 
        FROM public.stores 
        INNER JOIN public.user_profiles 
          ON user_profiles.id = stores.owner_id
        WHERE stores.id = products.store_id 
        AND user_profiles.user_id = auth.uid()
        AND user_profiles.role = 'merchant'
    )
);

-- ========================================
-- 22. تصحيح سياسات stores لاستخدام user_id
-- ========================================
ALTER TABLE public.stores ENABLE ROW LEVEL SECURITY;

-- حذف السياسات القديمة لـ stores
DROP POLICY IF EXISTS "Anyone can view active stores" ON public.stores;
DROP POLICY IF EXISTS "Merchants can view own stores" ON public.stores;
DROP POLICY IF EXISTS "Merchants can manage own stores" ON public.stores;
DROP POLICY IF EXISTS "Admins can manage all stores" ON public.stores;

-- سياسة SELECT للجميع (المتاجر النشطة)
CREATE POLICY "Anyone can view active stores"
ON public.stores 
FOR SELECT
USING (status = 'active' AND visibility = 'public');

-- سياسة SELECT للتجار (متاجرهم الخاصة)
CREATE POLICY "Merchants can view own stores"
ON public.stores 
FOR SELECT
USING (
    EXISTS (
        SELECT 1 
        FROM public.user_profiles 
        WHERE user_profiles.id = stores.owner_id 
        AND user_profiles.user_id = auth.uid()
    )
);

-- سياسة INSERT/UPDATE/DELETE للتجار (متاجرهم فقط)
CREATE POLICY "Merchants can manage own stores"
ON public.stores 
FOR ALL
USING (
    EXISTS (
        SELECT 1 
        FROM public.user_profiles 
        WHERE user_profiles.id = stores.owner_id 
        AND user_profiles.user_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 
        FROM public.user_profiles 
        WHERE user_profiles.id = stores.owner_id 
        AND user_profiles.user_id = auth.uid()
    )
);

-- ========================================
-- 23. التحقق من النتيجة
-- ========================================
DO $$
DECLARE
  user_id_exists BOOLEAN;
  full_name_exists BOOLEAN;
  rls_enabled_user_profiles BOOLEAN;
  rls_enabled_products BOOLEAN;
BEGIN
  -- التحقق من الأعمدة
  SELECT EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'user_profiles' 
    AND column_name = 'user_id'
  ) INTO user_id_exists;
  
  SELECT EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'user_profiles' 
    AND column_name = 'full_name'
  ) INTO full_name_exists;
  
  -- التحقق من RLS
  SELECT row_security 
  FROM pg_tables 
  WHERE schemaname = 'public' 
  AND tablename = 'user_profiles'
  INTO rls_enabled_user_profiles;
  
  SELECT row_security 
  FROM pg_tables 
  WHERE schemaname = 'public' 
  AND tablename = 'products'
  INTO rls_enabled_products;
  
  RAISE NOTICE '========================================';
  RAISE NOTICE '✅ تقرير التحقق:';
  RAISE NOTICE '========================================';
  RAISE NOTICE 'user_profiles.user_id: %', user_id_exists;
  RAISE NOTICE 'user_profiles.full_name: %', full_name_exists;
  RAISE NOTICE 'RLS enabled on user_profiles: %', rls_enabled_user_profiles;
  RAISE NOTICE 'RLS enabled on products: %', rls_enabled_products;
  RAISE NOTICE '========================================';
  
  IF user_id_exists AND full_name_exists AND rls_enabled_user_profiles AND rls_enabled_products THEN
    RAISE NOTICE '✅ جميع الإصلاحات تمت بنجاح!';
  ELSE
    RAISE WARNING '⚠️ بعض الإصلاحات لم تكتمل';
  END IF;
END $$;

