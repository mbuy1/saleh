-- ========================================
-- SQL Script لإنشاء الجداول الناقصة
-- تاريخ: ديسمبر 2025
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
-- 2. ربط المنتجات بالفئات (Product Categories)
-- ========================================
CREATE TABLE IF NOT EXISTS product_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(product_id, category_id)
);

-- Indexes للبحث السريع
CREATE INDEX IF NOT EXISTS idx_product_categories_product_id ON product_categories(product_id);
CREATE INDEX IF NOT EXISTS idx_product_categories_category_id ON product_categories(category_id);

-- ========================================
-- 3. قصص المتاجر (Stories)
-- ========================================
CREATE TABLE IF NOT EXISTS stories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  title TEXT,
  media_url TEXT NOT NULL, -- رابط الصورة/الفيديو من Cloudflare
  media_type TEXT NOT NULL DEFAULT 'image', -- 'image' أو 'video'
  duration INTEGER DEFAULT 5, -- مدة العرض بالثواني (للصور)
  link_url TEXT, -- رابط عند الضغط على الستوري
  is_pinned BOOLEAN DEFAULT false, -- مثبت (24 ساعة إضافية)
  views_count INTEGER DEFAULT 0,
  clicks_count INTEGER DEFAULT 0,
  expires_at TIMESTAMPTZ NOT NULL, -- تنتهي بعد 24 ساعة
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_stories_store_id ON stories(store_id);
CREATE INDEX IF NOT EXISTS idx_stories_expires_at ON stories(expires_at);
CREATE INDEX IF NOT EXISTS idx_stories_is_pinned ON stories(is_pinned);

-- ========================================
-- 4. صور ومقاطع المنتجات الإضافية (Product Media)
-- ========================================
CREATE TABLE IF NOT EXISTS product_media (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  media_url TEXT NOT NULL, -- رابط الصورة/الفيديو من Cloudflare
  media_type TEXT NOT NULL DEFAULT 'image', -- 'image' أو 'video'
  display_order INTEGER DEFAULT 0,
  is_primary BOOLEAN DEFAULT false, -- الصورة الرئيسية
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_product_media_product_id ON product_media(product_id);
CREATE INDEX IF NOT EXISTS idx_product_media_is_primary ON product_media(is_primary);

-- ========================================
-- 5. متابعي المتاجر (Store Followers)
-- ========================================
CREATE TABLE IF NOT EXISTS store_followers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(store_id, user_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_store_followers_store_id ON store_followers(store_id);
CREATE INDEX IF NOT EXISTS idx_store_followers_user_id ON store_followers(user_id);

-- ========================================
-- 6. المحادثات (Conversations)
-- ========================================
CREATE TABLE IF NOT EXISTS conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  merchant_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  store_id UUID REFERENCES stores(id) ON DELETE SET NULL,
  last_message_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(customer_id, merchant_id, store_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_conversations_customer_id ON conversations(customer_id);
CREATE INDEX IF NOT EXISTS idx_conversations_merchant_id ON conversations(merchant_id);
CREATE INDEX IF NOT EXISTS idx_conversations_last_message_at ON conversations(last_message_at);

-- ========================================
-- 7. الرسائل (Messages)
-- ========================================
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  message_text TEXT,
  media_url TEXT, -- صورة أو ملف مرفق
  media_type TEXT, -- 'image', 'video', 'file'
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_messages_sender_id ON messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at);

-- ========================================
-- 8. رموز الأجهزة (Device Tokens) لـ FCM
-- ========================================
CREATE TABLE IF NOT EXISTS device_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  token TEXT NOT NULL UNIQUE,
  platform TEXT NOT NULL, -- 'android', 'ios', 'web'
  device_model TEXT,
  os_version TEXT,
  app_version TEXT,
  is_active BOOLEAN DEFAULT true,
  last_used_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_device_tokens_user_id ON device_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_device_tokens_token ON device_tokens(token);
CREATE INDEX IF NOT EXISTS idx_device_tokens_is_active ON device_tokens(is_active);

-- ========================================
-- 9. الباقات (Packages) - للتجار
-- ========================================
CREATE TABLE IF NOT EXISTS packages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  name_ar TEXT NOT NULL,
  description TEXT,
  description_ar TEXT,
  price DECIMAL(10, 2) NOT NULL,
  duration_days INTEGER NOT NULL, -- مدة الباقة بالأيام
  features JSONB, -- ميزات الباقة
  is_active BOOLEAN DEFAULT true,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ========================================
-- 10. اشتراكات الباقات (Package Subscriptions)
-- ========================================
CREATE TABLE IF NOT EXISTS package_subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  merchant_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  package_id UUID NOT NULL REFERENCES packages(id) ON DELETE RESTRICT,
  starts_at TIMESTAMPTZ NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  is_active BOOLEAN DEFAULT true,
  auto_renew BOOLEAN DEFAULT false,
  payment_id UUID, -- ربط بجدول payments إذا وُجد
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_package_subscriptions_merchant_id ON package_subscriptions(merchant_id);
CREATE INDEX IF NOT EXISTS idx_package_subscriptions_expires_at ON package_subscriptions(expires_at);
CREATE INDEX IF NOT EXISTS idx_package_subscriptions_is_active ON package_subscriptions(is_active);

-- ========================================
-- إدراج بيانات أولية (Sample Data)
-- ========================================

-- الفئات الرئيسية
INSERT INTO categories (name, name_ar, slug, icon, display_order) VALUES
  ('Electronics', 'إلكترونيات', 'electronics', '📱', 1),
  ('Fashion', 'أزياء', 'fashion', '👗', 2),
  ('Home & Garden', 'منزل وحديقة', 'home-garden', '🏠', 3),
  ('Sports', 'رياضة', 'sports', '⚽', 4),
  ('Books', 'كتب', 'books', '📚', 5),
  ('Toys', 'ألعاب', 'toys', '🧸', 6),
  ('Beauty', 'تجميل', 'beauty', '💄', 7),
  ('Food', 'طعام', 'food', '🍕', 8),
  ('Automotive', 'سيارات', 'automotive', '🚗', 9),
  ('Health', 'صحة', 'health', '🏥', 10)
ON CONFLICT (slug) DO NOTHING;

-- فئات فرعية للإلكترونيات
INSERT INTO categories (name, name_ar, slug, parent_id, display_order)
SELECT 
  'Smartphones', 'هواتف ذكية', 'smartphones', id, 1 FROM categories WHERE slug = 'electronics'
UNION ALL SELECT
  'Laptops', 'حواسيب محمولة', 'laptops', id, 2 FROM categories WHERE slug = 'electronics'
UNION ALL SELECT
  'Tablets', 'أجهزة لوحية', 'tablets', id, 3 FROM categories WHERE slug = 'electronics'
UNION ALL SELECT
  'Cameras', 'كاميرات', 'cameras', id, 4 FROM categories WHERE slug = 'electronics'
UNION ALL SELECT
  'Accessories', 'إكسسوارات', 'accessories', id, 5 FROM categories WHERE slug = 'electronics'
ON CONFLICT (slug) DO NOTHING;

-- فئات فرعية للأزياء
INSERT INTO categories (name, name_ar, slug, parent_id, display_order)
SELECT 
  'Men Clothing', 'ملابس رجالية', 'men-clothing', id, 1 FROM categories WHERE slug = 'fashion'
UNION ALL SELECT
  'Women Clothing', 'ملابس نسائية', 'women-clothing', id, 2 FROM categories WHERE slug = 'fashion'
UNION ALL SELECT
  'Kids Clothing', 'ملابس أطفال', 'kids-clothing', id, 3 FROM categories WHERE slug = 'fashion'
UNION ALL SELECT
  'Shoes', 'أحذية', 'shoes', id, 4 FROM categories WHERE slug = 'fashion'
UNION ALL SELECT
  'Bags', 'حقائب', 'bags', id, 5 FROM categories WHERE slug = 'fashion'
ON CONFLICT (slug) DO NOTHING;

-- ========================================
-- منح الصلاحيات
-- ========================================
GRANT ALL ON categories TO anon, authenticated, service_role;
GRANT ALL ON product_categories TO anon, authenticated, service_role;
GRANT ALL ON stories TO anon, authenticated, service_role;
GRANT ALL ON product_media TO anon, authenticated, service_role;
GRANT ALL ON store_followers TO anon, authenticated, service_role;
GRANT ALL ON conversations TO anon, authenticated, service_role;
GRANT ALL ON messages TO anon, authenticated, service_role;
GRANT ALL ON device_tokens TO anon, authenticated, service_role;
GRANT ALL ON packages TO anon, authenticated, service_role;
GRANT ALL ON package_subscriptions TO anon, authenticated, service_role;

-- ========================================
-- ملاحظات مهمة
-- ========================================
-- 1. RLS معطل حالياً - يجب تفعيله لاحقاً في الإنتاج
-- 2. تأكد من وجود الجداول المرجعية (products, stores, user_profiles)
-- 3. Cloudflare Images: استخدم رفع الصور عبر CloudflareImagesService
-- 4. FCM Tokens: يتم حفظها تلقائياً عند تسجيل الدخول

-- ========================================
-- انتهى
-- ========================================
