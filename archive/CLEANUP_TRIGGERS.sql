-- ============================================================================
-- CLEANUP AND RESTORE TRIGGERS
-- ============================================================================

-- 1. حذف التريجر المسبب للمشكلة (set_product_store_id)
-- هذا التريجر كان يحاول تعيين store_id تلقائياً ولكنه كان يفسد البيانات القادمة من الـ Worker.
DROP TRIGGER IF EXISTS set_product_store_id ON public.products;

-- 2. إعادة تفعيل التريجرز (لإعادة تشغيل update_products_updated_at المفيد)
ALTER TABLE public.products ENABLE TRIGGER USER;

-- 3. التحقق النهائي من التريجرز المتبقية
SELECT 
    trigger_name,
    action_timing,
    event_manipulation
FROM information_schema.triggers
WHERE event_object_table = 'products'
  AND trigger_schema = 'public';
