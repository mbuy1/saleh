-- ========================================
-- إصلاح RLS Policies للسماح للـ Service Role بالوصول
-- تاريخ: يناير 2025
-- الهدف: السماح لـ Edge Functions (التي تستخدم SERVICE_ROLE_KEY) بإضافة المنتجات
-- ========================================

-- ========================================
-- 1. حذف السياسة القديمة لـ products INSERT
-- ========================================
DROP POLICY IF EXISTS "Merchants insert their own products" ON public.products;

-- ========================================
-- 2. إنشاء سياسة جديدة لـ products INSERT
-- تسمح للـ Service Role (Edge Functions) بالوصول
-- ملاحظة: SERVICE_ROLE_KEY يتجاوز RLS تلقائياً، لكن هذه السياسة للتحقق الإضافي
-- ========================================
CREATE POLICY "Merchants insert their own products"
ON public.products 
FOR INSERT
WITH CHECK (
    -- التحقق من أن المستخدم تاجر ويملك المتجر
    -- ملاحظة: إذا كان Edge Function يستخدم SERVICE_ROLE_KEY، فإنه يتجاوز RLS تلقائياً
    -- لكن نضيف هذا للتحقق الإضافي عند استخدام JWT عادي
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
-- 3. تحديث سياسة UPDATE لـ products
-- ========================================
DROP POLICY IF EXISTS "Merchants can update own products" ON public.products;

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
-- 4. تحديث سياسة DELETE لـ products
-- ========================================
DROP POLICY IF EXISTS "Merchants can delete own products" ON public.products;

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
-- 5. ملاحظة: بديل أبسط - استخدام Service Role مباشرة
-- ========================================
-- إذا كان Edge Function يستخدم SERVICE_ROLE_KEY، فإنه يتجاوز RLS تلقائياً
-- لكن إذا أردنا التحقق من الملكية، يجب أن نستخدم الطريقة أعلاه
-- أو نعدل Edge Function لاستخدام JWT من المستخدم بدلاً من SERVICE_ROLE_KEY

-- ========================================
-- 6. التحقق من النتيجة
-- ========================================
DO $$
DECLARE
  policy_count INTEGER;
BEGIN
  SELECT COUNT(*) 
  INTO policy_count
  FROM pg_policies 
  WHERE tablename = 'products' 
  AND policyname LIKE '%Merchants%';
  
  RAISE NOTICE '========================================';
  RAISE NOTICE '✅ تقرير التحقق:';
  RAISE NOTICE '========================================';
  RAISE NOTICE 'عدد سياسات products للتجار: %', policy_count;
  RAISE NOTICE '========================================';
  
  IF policy_count >= 3 THEN
    RAISE NOTICE '✅ جميع السياسات تم إنشاؤها بنجاح!';
  ELSE
    RAISE WARNING '⚠️ بعض السياسات لم يتم إنشاؤها';
  END IF;
END $$;

