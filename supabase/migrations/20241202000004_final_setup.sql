-- ============================================
-- 🔧 Final setup: Views and Permissions
-- ============================================

-- View لعناصر السلة مع تفاصيل المنتج
CREATE OR REPLACE VIEW public.cart_items_with_details AS
SELECT 
    ci.id,
    ci.user_id,
    ci.product_id,
    ci.quantity,
    ci.created_at,
    ci.updated_at,
    p.name as product_name,
    p.price,
    p.discount_price,
    p.image_url,
    p.stock_quantity,
    COALESCE(p.discount_price, p.price) as final_price,
    COALESCE(p.discount_price, p.price) * ci.quantity as item_total,
    s.name as store_name,
    c.name as category_name
FROM public.cart_items ci
JOIN public.products p ON ci.product_id = p.id
LEFT JOIN public.stores s ON p.store_id = s.id
LEFT JOIN public.categories c ON p.category_id = c.id;

-- View للمنتجات المتاحة
CREATE OR REPLACE VIEW public.available_products AS
SELECT *
FROM public.products
WHERE is_active = true 
  AND stock_quantity > 0;

-- منح الصلاحيات
GRANT SELECT ON public.cart_items_with_details TO authenticated;
GRANT SELECT ON public.available_products TO authenticated;
GRANT SELECT ON public.available_products TO anon;

-- ============================================
-- ✅ Setup Complete!
-- ============================================
