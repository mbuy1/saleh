-- إضافة منتجات تجريبية لاختبار التطبيق
-- تأكد من تشغيل هذا في Supabase SQL Editor

-- Insert sample products (one per category)
INSERT INTO products (
  store_id,
  category_id,
  name,
  name_ar,
  description,
  price,
  discount_price,
  discount_percentage,
  stock_quantity,
  is_active,
  status
)
SELECT 
  '98f67597-ad0f-459c-9f3f-4b8984a37a05', -- store_id (متجر mbuy)
  id, -- category_id
  'Sample Product for ' || name,
  'منتج تجريبي لـ ' || name_ar,
  'This is a sample product for testing purposes. منتج تجريبي للاختبار.',
  FLOOR(RANDOM() * 500 + 50)::numeric, -- random price between 50-550
  CASE 
    WHEN RANDOM() > 0.5 THEN FLOOR((RANDOM() * 500 + 50) * 0.8)::numeric
    ELSE NULL 
  END, -- 50% chance of discount
  CASE 
    WHEN RANDOM() > 0.5 THEN 20 
    ELSE NULL 
  END,
  FLOOR(RANDOM() * 100 + 10)::integer, -- random stock 10-110
  true,
  'active'
FROM categories
WHERE is_active = true
LIMIT 20;

-- Verify products were created
SELECT 
  p.id,
  p.name,
  p.name_ar,
  p.price,
  p.stock_quantity,
  c.name_ar as category,
  s.name as store
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN stores s ON p.store_id = s.id
WHERE p.is_active = true
ORDER BY p.created_at DESC
LIMIT 10;
