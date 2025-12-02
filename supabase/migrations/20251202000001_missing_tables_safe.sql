-- ========================================
-- SQL Script لإنشاء الجداول الناقصة (Safe Version)
-- تاريخ: ديسمبر 2025
-- This version only creates tables that don't depend on potentially missing tables
-- ========================================

-- ========================================
-- 1. جدول الفئات (Categories)
-- ========================================
CREATE TABLE IF NOT EXISTS categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  name_ar TEXT,
  description TEXT,
  parent_id UUID REFERENCES categories(id) ON DELETE CASCADE,
  icon TEXT, -- اسم الأيقونة أو emoji
  image_url TEXT, -- صورة الفئة من Cloudflare
  slug TEXT UNIQUE NOT NULL,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index للبحث السريع
CREATE INDEX IF NOT EXISTS idx_categories_parent_id ON categories(parent_id);
CREATE INDEX IF NOT EXISTS idx_categories_slug ON categories(slug);
CREATE INDEX IF NOT EXISTS idx_categories_is_active ON categories(is_active);

-- ========================================
-- 2. قصص المتاجر (Stories) - Depends on stores
-- ========================================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'stores') THEN
    CREATE TABLE IF NOT EXISTS stories (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
      title TEXT,
      media_url TEXT NOT NULL, -- رابط الصورة/الفيديو من Cloudflare
      media_type TEXT DEFAULT 'image', -- image or video
      link_url TEXT, -- رابط عند النقر على القصة
      view_count INTEGER DEFAULT 0,
      expires_at TIMESTAMPTZ DEFAULT NOW() + INTERVAL '24 hours',
      created_at TIMESTAMPTZ DEFAULT NOW(),
      is_active BOOLEAN DEFAULT true
    );

    -- Indexes
    CREATE INDEX IF NOT EXISTS idx_stories_store_id ON stories(store_id);
    CREATE INDEX IF NOT EXISTS idx_stories_expires_at ON stories(expires_at);
    CREATE INDEX IF NOT EXISTS idx_stories_is_active ON stories(is_active);
  END IF;
END $$;

-- ========================================
-- 3. ملفات وسائط المنتج (Product Media) - Depends on products
-- ========================================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'products') THEN
    CREATE TABLE IF NOT EXISTS product_media (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
      media_url TEXT NOT NULL,
      media_type TEXT DEFAULT 'image', -- image or video
      display_order INTEGER DEFAULT 0,
      is_primary BOOLEAN DEFAULT false,
      created_at TIMESTAMPTZ DEFAULT NOW()
    );

    CREATE INDEX IF NOT EXISTS idx_product_media_product_id ON product_media(product_id);
    CREATE INDEX IF NOT EXISTS idx_product_media_is_primary ON product_media(is_primary);
  END IF;
END $$;

-- ========================================
-- 4. متابعو المتاجر (Store Followers) - Depends on stores and users
-- ========================================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'stores') 
     AND EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users') THEN
    CREATE TABLE IF NOT EXISTS store_followers (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
      user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      followed_at TIMESTAMPTZ DEFAULT NOW(),
      UNIQUE(store_id, user_id)
    );

    CREATE INDEX IF NOT EXISTS idx_store_followers_store_id ON store_followers(store_id);
    CREATE INDEX IF NOT EXISTS idx_store_followers_user_id ON store_followers(user_id);
  END IF;
END $$;

-- ========================================
-- 5. المحادثات (Conversations) - Depends on stores and users
-- ========================================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'stores') 
     AND EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users') THEN
    CREATE TABLE IF NOT EXISTS conversations (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      customer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      merchant_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
      last_message_at TIMESTAMPTZ DEFAULT NOW(),
      is_active BOOLEAN DEFAULT true,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      UNIQUE(customer_id, merchant_id)
    );

    CREATE INDEX IF NOT EXISTS idx_conversations_customer_id ON conversations(customer_id);
    CREATE INDEX IF NOT EXISTS idx_conversations_merchant_id ON conversations(merchant_id);
    CREATE INDEX IF NOT EXISTS idx_conversations_last_message_at ON conversations(last_message_at);
  END IF;
END $$;

-- ========================================
-- 6. الرسائل (Messages) - Depends on conversations and users
-- ========================================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'conversations') 
     AND EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users') THEN
    CREATE TABLE IF NOT EXISTS messages (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
      sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      content TEXT NOT NULL,
      media_url TEXT, -- صورة/فيديو مرفق
      is_read BOOLEAN DEFAULT false,
      created_at TIMESTAMPTZ DEFAULT NOW()
    );

    CREATE INDEX IF NOT EXISTS idx_messages_conversation_id ON messages(conversation_id);
    CREATE INDEX IF NOT EXISTS idx_messages_sender_id ON messages(sender_id);
    CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at);
  END IF;
END $$;

-- ========================================
-- 7. Device Tokens for FCM - Independent
-- ========================================
CREATE TABLE IF NOT EXISTS device_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  token TEXT NOT NULL UNIQUE,
  platform TEXT NOT NULL, -- 'ios', 'android', 'web'
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_used_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_device_tokens_user_id ON device_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_device_tokens_token ON device_tokens(token);

-- ========================================
-- 8. باقات الاشتراك للتجار (Packages) - Independent
-- ========================================
CREATE TABLE IF NOT EXISTS packages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  name_ar TEXT,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  duration_days INTEGER NOT NULL, -- مدة الباقة بالأيام
  features JSONB, -- مزايا الباقة
  max_products INTEGER, -- عدد المنتجات المسموح بها
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_packages_is_active ON packages(is_active);

-- ========================================
-- 9. اشتراكات التجار (Package Subscriptions) - Depends on packages and stores
-- ========================================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'stores') THEN
    CREATE TABLE IF NOT EXISTS package_subscriptions (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
      package_id UUID NOT NULL REFERENCES packages(id) ON DELETE CASCADE,
      starts_at TIMESTAMPTZ NOT NULL,
      expires_at TIMESTAMPTZ NOT NULL,
      is_active BOOLEAN DEFAULT true,
      payment_id UUID, -- ربط مع جدول المدفوعات
      created_at TIMESTAMPTZ DEFAULT NOW()
    );

    CREATE INDEX IF NOT EXISTS idx_package_subscriptions_store_id ON package_subscriptions(store_id);
    CREATE INDEX IF NOT EXISTS idx_package_subscriptions_expires_at ON package_subscriptions(expires_at);
    CREATE INDEX IF NOT EXISTS idx_package_subscriptions_is_active ON package_subscriptions(is_active);
  END IF;
END $$;

-- ========================================
-- 10. ربط المنتجات بالفئات (Product Categories) - Depends on products
-- ========================================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'products') THEN
    CREATE TABLE IF NOT EXISTS product_categories (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
      category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      UNIQUE(product_id, category_id)
    );

    CREATE INDEX IF NOT EXISTS idx_product_categories_product_id ON product_categories(product_id);
    CREATE INDEX IF NOT EXISTS idx_product_categories_category_id ON product_categories(category_id);
  END IF;
END $$;

-- ========================================
-- Sample Data: Categories
-- ========================================
INSERT INTO categories (name, name_ar, description, slug, display_order, icon) VALUES
('Electronics', 'إلكترونيات', 'Electronic devices and accessories', 'electronics', 1, '📱'),
('Fashion', 'أزياء', 'Clothing and fashion items', 'fashion', 2, '👔'),
('Home & Garden', 'منزل وحديقة', 'Home and garden products', 'home-garden', 3, '🏠'),
('Sports', 'رياضة', 'Sports equipment and gear', 'sports', 4, '⚽'),
('Books', 'كتب', 'Books and publications', 'books', 5, '📚'),
('Toys', 'ألعاب', 'Toys and games', 'toys', 6, '🧸'),
('Health & Beauty', 'صحة وجمال', 'Health and beauty products', 'health-beauty', 7, '💄'),
('Automotive', 'سيارات', 'Automotive parts and accessories', 'automotive', 8, '🚗'),
('Food & Beverages', 'طعام ومشروبات', 'Food and beverage products', 'food-beverages', 9, '🍔'),
('Office Supplies', 'مستلزمات مكتبية', 'Office and school supplies', 'office-supplies', 10, '📎')
ON CONFLICT (slug) DO NOTHING;

-- Sub-categories (children of main categories)
INSERT INTO categories (name, name_ar, parent_id, slug, display_order, icon) 
SELECT 'Smartphones', 'هواتف ذكية', id, 'smartphones', 1, '📱' FROM categories WHERE slug = 'electronics'
UNION ALL
SELECT 'Laptops', 'حواسيب محمولة', id, 'laptops', 2, '💻' FROM categories WHERE slug = 'electronics'
UNION ALL
SELECT 'Men Fashion', 'أزياء رجالية', id, 'men-fashion', 1, '👔' FROM categories WHERE slug = 'fashion'
UNION ALL
SELECT 'Women Fashion', 'أزياء نسائية', id, 'women-fashion', 2, '👗' FROM categories WHERE slug = 'fashion'
UNION ALL
SELECT 'Furniture', 'أثاث', id, 'furniture', 1, '🛋️' FROM categories WHERE slug = 'home-garden'
UNION ALL
SELECT 'Gym Equipment', 'معدات رياضية', id, 'gym-equipment', 1, '🏋️' FROM categories WHERE slug = 'sports'
UNION ALL
SELECT 'Fiction', 'روايات', id, 'fiction', 1, '📖' FROM categories WHERE slug = 'books'
UNION ALL
SELECT 'Educational', 'تعليمية', id, 'educational', 1, '🎓' FROM categories WHERE slug = 'toys'
UNION ALL
SELECT 'Skincare', 'العناية بالبشرة', id, 'skincare', 1, '🧴' FROM categories WHERE slug = 'health-beauty'
UNION ALL
SELECT 'Car Parts', 'قطع غيار', id, 'car-parts', 1, '🔧' FROM categories WHERE slug = 'automotive'
ON CONFLICT (slug) DO NOTHING;

-- ========================================
-- Sample Data: Packages
-- ========================================
INSERT INTO packages (name, name_ar, description, price, duration_days, max_products, features) VALUES
('Basic', 'أساسية', 'Basic package for small stores', 99.00, 30, 50, '{"support": "email", "analytics": false}'),
('Professional', 'احترافية', 'Professional package for growing stores', 299.00, 30, 200, '{"support": "priority", "analytics": true, "featured": false}'),
('Enterprise', 'مؤسسية', 'Enterprise package for large businesses', 999.00, 30, 1000, '{"support": "24/7", "analytics": true, "featured": true, "custom_domain": true}')
ON CONFLICT DO NOTHING;

-- ========================================
-- Permissions
-- ========================================
GRANT ALL ON categories TO postgres;
GRANT ALL ON device_tokens TO postgres;
GRANT ALL ON packages TO postgres;

GRANT SELECT, INSERT, UPDATE, DELETE ON categories TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON device_tokens TO authenticated;
GRANT SELECT ON packages TO authenticated;
