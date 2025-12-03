-- ============================================
-- 🔧 Fix cart_items table structure
-- ============================================

-- حذف الجدول القديم إذا كان موجوداً
DROP TABLE IF EXISTS public.cart_items CASCADE;

-- إنشاء جدول cart_items من جديد بالبنية الصحيحة
CREATE TABLE public.cart_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, product_id)
);

COMMENT ON TABLE public.cart_items IS 'سلة التسوق - عناصر السلة لكل مستخدم';

-- إنشاء الفهارس
CREATE INDEX idx_cart_items_user_id ON public.cart_items(user_id);
CREATE INDEX idx_cart_items_product_id ON public.cart_items(product_id);

-- تفعيل RLS
ALTER TABLE public.cart_items ENABLE ROW LEVEL SECURITY;

-- السياسات
DROP POLICY IF EXISTS "Users can view their own cart" ON public.cart_items;
CREATE POLICY "Users can view their own cart"
ON public.cart_items FOR SELECT
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can add to their own cart" ON public.cart_items;
CREATE POLICY "Users can add to their own cart"
ON public.cart_items FOR INSERT
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update their own cart" ON public.cart_items;
CREATE POLICY "Users can update their own cart"
ON public.cart_items FOR UPDATE
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete from their own cart" ON public.cart_items;
CREATE POLICY "Users can delete from their own cart"
ON public.cart_items FOR DELETE
USING (auth.uid() = user_id);

-- Trigger لتحديث updated_at
DROP TRIGGER IF EXISTS update_cart_items_updated_at ON public.cart_items;
CREATE TRIGGER update_cart_items_updated_at
BEFORE UPDATE ON public.cart_items
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- منح الصلاحيات
GRANT SELECT, INSERT, UPDATE, DELETE ON public.cart_items TO authenticated;
