-- ============================================================================
-- CHECK TRIGGERS ON PRODUCTS TABLE
-- ============================================================================
-- هذا السكربت يعرض جميع الـ Triggers المرتبطة بجدول المنتجات.
-- الهدف: معرفة ما إذا كان هناك Trigger خفي يقوم بتعديل البيانات قبل الإدخال.

SELECT 
    trigger_name,
    event_manipulation,
    event_object_table,
    action_statement,
    action_timing
FROM information_schema.triggers
WHERE event_object_table = 'products'
ORDER BY trigger_name;
