-- ============================================
-- إنشاء جدول الفئات (Categories)
-- ============================================

-- جدول الفئات
CREATE TABLE IF NOT EXISTS categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  name_en TEXT,
  icon TEXT NOT NULL, -- emoji أو اسم أيقونة
  description TEXT,
  image_url TEXT,
  parent_id UUID REFERENCES categories(id) ON DELETE CASCADE, -- للفئات الفرعية
  display_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- إضافة عمود category_id لجدول المنتجات
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS category_id UUID REFERENCES categories(id) ON DELETE SET NULL;

-- إنشاء Index للأداء
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_categories_parent_id ON categories(parent_id);

-- تعطيل RLS للسماح بالوصول
ALTER TABLE categories DISABLE ROW LEVEL SECURITY;

-- منح الصلاحيات
GRANT ALL ON categories TO anon, authenticated, service_role;

-- إدراج البيانات الأولية (الفئات الرئيسية)
INSERT INTO categories (name, name_en, icon, description, display_order) VALUES
  ('إلكترونيات', 'Electronics', '📱', 'هواتف، أجهزة لوحية، حواسيب وملحقاتها', 1),
  ('أزياء', 'Fashion', '👕', 'ملابس، أحذية، إكسسوارات للرجال والنساء', 2),
  ('طعام ومشروبات', 'Food & Beverages', '🍕', 'مطاعم، مقاهي، مخابز ومشروبات', 3),
  ('رياضة', 'Sports', '⚽', 'معدات رياضية، ملابس رياضية، مكملات غذائية', 4),
  ('كتب', 'Books', '📚', 'كتب، مجلات، قرطاسية وأدوات مكتبية', 5),
  ('منزل وديكور', 'Home & Decor', '🏠', 'أثاث، ديكور، أدوات منزلية ومطبخية', 6),
  ('صحة وجمال', 'Health & Beauty', '💄', 'عناية بالبشرة، مكياج، عطور ومنتجات صحية', 7),
  ('ألعاب', 'Games', '🎮', 'ألعاب فيديو، ألعاب أطفال، ألعاب جماعية', 8),
  ('سيارات', 'Automotive', '🚗', 'قطع غيار، إكسسوارات، زيوت وخدمات سيارات', 9),
  ('خدمات', 'Services', '🛠️', 'خدمات صيانة، تنظيف، توصيل ومقاولات', 10)
ON CONFLICT DO NOTHING;

-- تحديث بعض المنتجات الموجودة لربطها بالفئات (اختياري)
-- يمكنك تعديل هذا حسب بياناتك الفعلية
-- UPDATE products SET category_id = (SELECT id FROM categories WHERE name = 'إلكترونيات' LIMIT 1) 
-- WHERE name ILIKE '%هاتف%' OR name ILIKE '%جهاز%';

COMMENT ON TABLE categories IS 'جدول الفئات الرئيسية والفرعية للمنتجات والمتاجر';
COMMENT ON COLUMN categories.parent_id IS 'معرف الفئة الأب للفئات الفرعية (NULL للفئات الرئيسية)';
COMMENT ON COLUMN categories.display_order IS 'ترتيب العرض في الواجهة';
