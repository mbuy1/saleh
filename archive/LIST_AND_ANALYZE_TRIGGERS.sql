-- ============================================================================
-- LIST ALL USER TRIGGERS ON PRODUCTS
-- ============================================================================
-- هذا السكربت سيعرض أسماء الـ Triggers التي عطلناها.
-- نحتاج لمعرفة أسمائها لنحذف "الفاسد" منها ونعيد تفعيل "الصالح".

SELECT 
    trigger_name,
    action_timing,
    event_manipulation,
    action_statement
FROM information_schema.triggers
WHERE event_object_table = 'products'
  AND trigger_schema = 'public';
