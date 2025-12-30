-- ============================================
-- 🔧 Add category_id and store_id to products
-- ============================================

ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS category_id UUID REFERENCES public.categories(id);

ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS store_id UUID REFERENCES public.stores(id);

-- إنشاء الفهارس
CREATE INDEX IF NOT EXISTS idx_products_category_id 
ON public.products(category_id) 
WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_products_store_id 
ON public.products(store_id) 
WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_products_active_stock 
ON public.products(is_active, stock_quantity) 
WHERE is_active = true AND stock_quantity > 0;

CREATE INDEX IF NOT EXISTS idx_products_discount 
ON public.products(discount_price) 
WHERE discount_price IS NOT NULL AND is_active = true;

CREATE INDEX IF NOT EXISTS idx_products_created_at 
ON public.products(created_at DESC) 
WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_products_rating 
ON public.products(rating DESC NULLS LAST) 
WHERE is_active = true AND rating IS NOT NULL;

-- فهارس البحث النصي
CREATE INDEX IF NOT EXISTS idx_products_name 
ON public.products USING gin(to_tsvector('arabic', name));

CREATE INDEX IF NOT EXISTS idx_products_description 
ON public.products USING gin(to_tsvector('arabic', COALESCE(description, '')));
