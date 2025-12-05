# تعليمات إضافة البيانات التجريبية

## خطوات إضافة منتجات تجريبية:

1. افتح Supabase Dashboard: https://supabase.com/dashboard/project/sirqidofuvphqcxqchyc

2. اذهب إلى SQL Editor (من القائمة الجانبية)

3. انسخ محتوى ملف `add_sample_products.sql`

4. الصقه في SQL Editor

5. اضغط على "Run" (F5)

6. ستظهر رسالة نجاح: "Success. No rows returned"

7. تحقق من إضافة المنتجات بتشغيل:
   ```sql
   SELECT COUNT(*) FROM products;
   ```

## البديل: إضافة منتج واحد يدوياً

إذا أردت إضافة منتج واحد فقط للاختبار:

```sql
INSERT INTO products (
  store_id,
  category_id,
  name,
  name_ar,
  description,
  price,
  stock_quantity,
  is_active,
  status
) VALUES (
  '98f67597-ad0f-459c-9f3f-4b8984a37a05', -- متجر mbuy
  (SELECT id FROM categories WHERE name_ar = 'إلكترونيات' LIMIT 1),
  'Test Product',
  'منتج تجريبي',
  'This is a test product',
  99.99,
  50,
  true,
  'active'
);
```

## ملاحظات:
- المنتجات التجريبية ستظهر في التطبيق فوراً
- يمكنك تعديل/حذف المنتجات من لوحة التحكم
- لحذف جميع المنتجات التجريبية:
  ```sql
  DELETE FROM products WHERE description LIKE '%testing%';
  ```
