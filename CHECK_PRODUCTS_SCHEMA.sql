-- ============================================================================
-- CHECK PRODUCTS TABLE SCHEMA
-- ============================================================================
-- هذا السكربت يعرض جميع أعمدة جدول المنتجات وهل تقبل NULL أم لا.

SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'products'
ORDER BY ordinal_position;
