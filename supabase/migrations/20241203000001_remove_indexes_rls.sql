-- ============================================
-- 🗑️ Remove all indexes and RLS policies
-- ============================================

-- حذف جميع الفهارس
DROP INDEX IF EXISTS public.idx_cart_items_user_id;
DROP INDEX IF EXISTS public.idx_cart_items_product_id;
DROP INDEX IF EXISTS public.idx_products_category_id;
DROP INDEX IF EXISTS public.idx_products_store_id;
DROP INDEX IF EXISTS public.idx_products_active_stock;
DROP INDEX IF EXISTS public.idx_products_discount;
DROP INDEX IF EXISTS public.idx_products_created_at;
DROP INDEX IF EXISTS public.idx_products_rating;
DROP INDEX IF EXISTS public.idx_products_name;
DROP INDEX IF EXISTS public.idx_products_description;

-- إيقاف RLS على cart_items
ALTER TABLE public.cart_items DISABLE ROW LEVEL SECURITY;

-- حذف جميع السياسات
DROP POLICY IF EXISTS "Users can view their own cart" ON public.cart_items;
DROP POLICY IF EXISTS "Users can add to their own cart" ON public.cart_items;
DROP POLICY IF EXISTS "Users can update their own cart" ON public.cart_items;
DROP POLICY IF EXISTS "Users can delete from their own cart" ON public.cart_items;

-- منح صلاحيات كاملة بدون RLS
GRANT ALL ON public.cart_items TO authenticated;
GRANT ALL ON public.cart_items TO anon;

-- ✅ تم إلغاء جميع الفهارس والـ RLS
