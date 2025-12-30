-- ========================================
-- إصلاح نهائي لـ RLS Policies لإضافة المنتجات
-- تاريخ: يناير 2025
-- الهدف: ضمان عمل product_create بدون FORBIDDEN
-- ========================================
--
-- ملاحظة: هذه Migration إضافية للسياسات الموجودة
-- تحافظ على سياسات Public ولا تحذفها
--

-- ========================================
-- 1. التأكد من تفعيل RLS على الجداول
-- ========================================
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- ========================================
-- 2. user_profiles: سياسة SELECT للمالك
-- ========================================
-- حذف السياسات القديمة إن وجدت
DROP POLICY IF EXISTS "Users can read own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Profiles are viewable by owner" ON public.user_profiles;

-- إنشاء سياسة SELECT للمالك
CREATE POLICY "Profiles are viewable by owner"
ON public.user_profiles
FOR SELECT
USING (id = auth.uid());

-- ========================================
-- 3. stores: سياسات للتجار (إضافة فقط، لا تحذف public)
-- ========================================

-- حذف السياسات القديمة للتجار إن وجدت (لإعادة إنشائها)
DROP POLICY IF EXISTS "Store owners can view own stores" ON public.stores;
DROP POLICY IF EXISTS "Users can insert own stores" ON public.stores;
DROP POLICY IF EXISTS "Store owners can update own stores" ON public.stores;
DROP POLICY IF EXISTS "Store owners can delete own stores" ON public.stores;

-- SELECT: المالك يمكنه رؤية متجره (بالإضافة للـ public)
CREATE POLICY "Store owners can view own stores"
ON public.stores 
FOR SELECT
USING (auth.uid() = owner_id);

-- INSERT: المالك فقط يمكنه إنشاء متجر لنفسه
CREATE POLICY "Users can insert own stores"
ON public.stores 
FOR INSERT
WITH CHECK (auth.uid() = owner_id);

-- UPDATE: المالك فقط يمكنه تحديث متجره
CREATE POLICY "Store owners can update own stores"
ON public.stores 
FOR UPDATE
USING (auth.uid() = owner_id)
WITH CHECK (auth.uid() = owner_id);

-- DELETE: المالك فقط يمكنه حذف متجره
CREATE POLICY "Store owners can delete own stores"
ON public.stores 
FOR DELETE
USING (auth.uid() = owner_id);

-- ========================================
-- 4. products: سياسات للتجار (إضافة فقط، لا تحذف public)
-- ========================================

-- حذف السياسات القديمة للتجار إن وجدت (لإعادة إنشائها)
DROP POLICY IF EXISTS "Store owners can insert products" ON public.products;
DROP POLICY IF EXISTS "Store owners can update products" ON public.products;
DROP POLICY IF EXISTS "Store owners can delete products" ON public.products;
DROP POLICY IF EXISTS "Store owners can view own products" ON public.products;

-- INSERT: فقط مالك المتجر يمكنه إضافة منتجات لمتجره
CREATE POLICY "Store owners can insert products"
ON public.products 
FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 
        FROM public.stores 
        WHERE stores.id = products.store_id 
        AND stores.owner_id = auth.uid()
    )
);

-- UPDATE: فقط مالك المتجر يمكنه تحديث منتجات متجره
CREATE POLICY "Store owners can update products"
ON public.products 
FOR UPDATE
USING (
    EXISTS (
        SELECT 1 
        FROM public.stores 
        WHERE stores.id = products.store_id 
        AND stores.owner_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 
        FROM public.stores 
        WHERE stores.id = products.store_id 
        AND stores.owner_id = auth.uid()
    )
);

-- DELETE: فقط مالك المتجر يمكنه حذف منتجات متجره
CREATE POLICY "Store owners can delete products"
ON public.products 
FOR DELETE
USING (
    EXISTS (
        SELECT 1 
        FROM public.stores 
        WHERE stores.id = products.store_id 
        AND stores.owner_id = auth.uid()
    )
);

-- SELECT: المالك يمكنه رؤية منتجاته (بالإضافة للـ public)
CREATE POLICY "Store owners can view own products"
ON public.products 
FOR SELECT
USING (
    EXISTS (
        SELECT 1 
        FROM public.stores 
        WHERE stores.id = products.store_id 
        AND stores.owner_id = auth.uid()
    )
);

-- ========================================
-- 5. التحقق من النتيجة
-- ========================================
DO $$
DECLARE
  user_profiles_policy_count INTEGER;
  stores_policy_count INTEGER;
  products_policy_count INTEGER;
BEGIN
  SELECT COUNT(*) 
  INTO user_profiles_policy_count
  FROM pg_policies 
  WHERE tablename = 'user_profiles';
  
  SELECT COUNT(*) 
  INTO stores_policy_count
  FROM pg_policies 
  WHERE tablename = 'stores';
  
  SELECT COUNT(*) 
  INTO products_policy_count
  FROM pg_policies 
  WHERE tablename = 'products';
  
  RAISE NOTICE '========================================';
  RAISE NOTICE '✅ تقرير التحقق من RLS Policies:';
  RAISE NOTICE '========================================';
  RAISE NOTICE 'عدد سياسات user_profiles: %', user_profiles_policy_count;
  RAISE NOTICE 'عدد سياسات stores: %', stores_policy_count;
  RAISE NOTICE 'عدد سياسات products: %', products_policy_count;
  RAISE NOTICE '========================================';
  
  IF user_profiles_policy_count >= 1 AND stores_policy_count >= 5 AND products_policy_count >= 4 THEN
    RAISE NOTICE '✅ جميع السياسات تم إنشاؤها بنجاح!';
  ELSE
    RAISE WARNING '⚠️ بعض السياسات لم يتم إنشاؤها - يرجى المراجعة';
  END IF;
END $$;

