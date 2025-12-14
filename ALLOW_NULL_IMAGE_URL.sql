-- ============================================================================
-- ALLOW NULL IMAGE URL
-- ============================================================================
-- هذا السكربت يعدل جدول المنتجات ليسمح بإضافة منتج بدون صورة رئيسية.
-- المشكلة الحالية: العمود main_image_url لا يقبل NULL، مما يسبب فشل الإضافة.

ALTER TABLE public.products 
ALTER COLUMN main_image_url DROP NOT NULL;

-- التحقق من التغيير
SELECT 
    column_name, 
    is_nullable 
FROM information_schema.columns 
WHERE table_name = 'products' 
  AND column_name = 'main_image_url';
