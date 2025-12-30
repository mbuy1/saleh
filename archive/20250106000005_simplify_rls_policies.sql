-- ========================================
-- تبسيط RLS Policies للـ stores و products
-- تاريخ: يناير 2025
-- الهدف: استخدام auth.uid() مباشرة = owner_id
-- ========================================

-- ========================================
-- 1. تفعيل RLS على user_profiles
-- ========================================
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- حذف السياسات القديمة لـ user_profiles
DROP POLICY IF EXISTS "Users can read own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Profiles are viewable by owner" ON public.user_profiles;

-- إنشاء سياسة SELECT للمالك
CREATE POLICY "Profiles are viewable by owner"
ON public.user_profiles
FOR SELECT
USING (id = auth.uid());

-- ========================================
-- 2. حذف السياسات القديمة لـ stores
-- ========================================
DROP POLICY IF EXISTS "Anyone can view active stores" ON public.stores;
DROP POLICY IF EXISTS "Merchants can view own stores" ON public.stores;
DROP POLICY IF EXISTS "Merchants can manage own stores" ON public.stores;
DROP POLICY IF EXISTS "Admins can manage all stores" ON public.stores;

-- ========================================
-- 3. إنشاء سياسات مبسطة لـ stores
-- ========================================

-- SELECT: يمكن للجميع رؤية المتاجر النشطة العامة
CREATE POLICY "Anyone can view active public stores"
ON public.stores 
FOR SELECT
USING (status = 'active' AND visibility = 'public');

-- SELECT: المالك يمكنه رؤية متجره
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
-- 4. حذف السياسات القديمة لـ products
-- ========================================
DROP POLICY IF EXISTS "Anyone can view active products" ON public.products;
DROP POLICY IF EXISTS "Merchants insert their own products" ON public.products;
DROP POLICY IF EXISTS "Merchants can update own products" ON public.products;
DROP POLICY IF EXISTS "Merchants can delete own products" ON public.products;

-- ========================================
-- 5. إنشاء سياسات مبسطة لـ products
-- ========================================

-- SELECT: يمكن للجميع رؤية المنتجات النشطة
CREATE POLICY "Anyone can view active products"
ON public.products 
FOR SELECT
USING (is_active = true);

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

-- ========================================
-- 6. التحقق من النتيجة
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
  RAISE NOTICE '✅ تقرير التحقق:';
  RAISE NOTICE '========================================';
  RAISE NOTICE 'عدد سياسات user_profiles: %', user_profiles_policy_count;
  RAISE NOTICE 'عدد سياسات stores: %', stores_policy_count;
  RAISE NOTICE 'عدد سياسات products: %', products_policy_count;
  RAISE NOTICE '========================================';
  
  IF user_profiles_policy_count >= 1 AND stores_policy_count >= 5 AND products_policy_count >= 4 THEN
    RAISE NOTICE '✅ جميع السياسات تم إنشاؤها بنجاح!';
  ELSE
    RAISE WARNING '⚠️ بعض السياسات لم يتم إنشاؤها';
  END IF;
END $$;

