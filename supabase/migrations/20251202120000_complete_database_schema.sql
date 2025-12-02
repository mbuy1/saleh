-- ========================================
-- قاعدة بيانات Mbuy - Schema كامل
-- تاريخ: ديسمبر 2025
-- ========================================

-- تفعيل UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ========================================
-- 1. ملفات المستخدمين (User Profiles)
-- ========================================
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL DEFAULT 'customer', -- 'admin', 'merchant', 'customer'
  display_name TEXT,
  phone TEXT,
  avatar_url TEXT,
  email TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_user_profiles_role ON user_profiles(role);

-- ========================================
-- 2. المتاجر (Stores)
-- ========================================
CREATE TABLE IF NOT EXISTS stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  slug TEXT UNIQUE,
  city TEXT,
  address TEXT,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  phone TEXT,
  logo_url TEXT,
  cover_image_url TEXT,
  rating DECIMAL(3, 2) DEFAULT 0,
  followers_count INTEGER DEFAULT 0,
  is_verified BOOLEAN DEFAULT false,
  visibility TEXT DEFAULT 'public', -- 'public', 'private'
  status TEXT DEFAULT 'active', -- 'active', 'inactive', 'suspended'
  boosted_until TIMESTAMPTZ,
  map_highlight_until TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_stores_owner_id ON stores(owner_id);
CREATE INDEX IF NOT EXISTS idx_stores_slug ON stores(slug);
CREATE INDEX IF NOT EXISTS idx_stores_city ON stores(city);
CREATE INDEX IF NOT EXISTS idx_stores_status ON stores(status);
CREATE INDEX IF NOT EXISTS idx_stores_boosted_until ON stores(boosted_until);

-- ========================================
-- 3. الفئات (Categories)
-- ========================================
CREATE TABLE IF NOT EXISTS categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  name_ar TEXT,
  description TEXT,
  parent_id UUID REFERENCES categories(id) ON DELETE CASCADE,
  icon TEXT,
  image_url TEXT,
  slug TEXT UNIQUE NOT NULL,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_categories_parent_id ON categories(parent_id);
CREATE INDEX IF NOT EXISTS idx_categories_slug ON categories(slug);
CREATE INDEX IF NOT EXISTS idx_categories_is_active ON categories(is_active);

-- ========================================
-- 4. المنتجات (Products)
-- ========================================
CREATE TABLE IF NOT EXISTS products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  compare_at_price DECIMAL(10, 2),
  cost_per_item DECIMAL(10, 2),
  stock INTEGER DEFAULT 0,
  sku TEXT,
  barcode TEXT,
  image_url TEXT,
  main_image_url TEXT,
  weight DECIMAL(10, 2),
  dimensions JSONB, -- {length, width, height}
  status TEXT DEFAULT 'active', -- 'active', 'draft', 'archived'
  is_featured BOOLEAN DEFAULT false,
  rating DECIMAL(3, 2) DEFAULT 0,
  reviews_count INTEGER DEFAULT 0,
  sales_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_products_store_id ON products(store_id);
CREATE INDEX IF NOT EXISTS idx_products_status ON products(status);
CREATE INDEX IF NOT EXISTS idx_products_is_featured ON products(is_featured);
CREATE INDEX IF NOT EXISTS idx_products_price ON products(price);

-- ========================================
-- 5. ربط المنتجات بالفئات (Product Categories)
-- ========================================
CREATE TABLE IF NOT EXISTS product_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(product_id, category_id)
);

CREATE INDEX IF NOT EXISTS idx_product_categories_product_id ON product_categories(product_id);
CREATE INDEX IF NOT EXISTS idx_product_categories_category_id ON product_categories(category_id);

-- ========================================
-- 6. صور المنتجات الإضافية (Product Media)
-- ========================================
CREATE TABLE IF NOT EXISTS product_media (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  media_url TEXT NOT NULL,
  media_type TEXT DEFAULT 'image', -- 'image', 'video'
  display_order INTEGER DEFAULT 0,
  is_primary BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_product_media_product_id ON product_media(product_id);

-- ========================================
-- 7. السلة (Carts)
-- ========================================
CREATE TABLE IF NOT EXISTS carts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE INDEX IF NOT EXISTS idx_carts_user_id ON carts(user_id);

-- ========================================
-- 8. عناصر السلة (Cart Items)
-- ========================================
CREATE TABLE IF NOT EXISTS cart_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cart_id UUID NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL DEFAULT 1,
  added_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(cart_id, product_id)
);

CREATE INDEX IF NOT EXISTS idx_cart_items_cart_id ON cart_items(cart_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_product_id ON cart_items(product_id);

-- ========================================
-- 9. الطلبات (Orders)
-- ========================================
CREATE TABLE IF NOT EXISTS orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number TEXT UNIQUE,
  customer_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  status TEXT DEFAULT 'pending', -- 'pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled'
  payment_status TEXT DEFAULT 'pending', -- 'pending', 'paid', 'failed', 'refunded'
  payment_method TEXT, -- 'wallet', 'cash', 'card', 'bank_transfer'
  subtotal DECIMAL(10, 2) NOT NULL,
  discount_amount DECIMAL(10, 2) DEFAULT 0,
  tax_amount DECIMAL(10, 2) DEFAULT 0,
  shipping_amount DECIMAL(10, 2) DEFAULT 0,
  total_amount DECIMAL(10, 2) NOT NULL,
  notes TEXT,
  shipping_address JSONB,
  coupon_code TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_store_id ON orders(store_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_order_number ON orders(order_number);

-- ========================================
-- 10. عناصر الطلب (Order Items)
-- ========================================
CREATE TABLE IF NOT EXISTS order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
  product_name TEXT NOT NULL,
  product_image_url TEXT,
  quantity INTEGER NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  total DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);

-- ========================================
-- 11. المحافظ (Wallets)
-- ========================================
CREATE TABLE IF NOT EXISTS wallets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  type TEXT NOT NULL DEFAULT 'customer', -- 'customer', 'merchant'
  balance DECIMAL(10, 2) DEFAULT 0,
  currency TEXT DEFAULT 'SAR',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(owner_id, type)
);

CREATE INDEX IF NOT EXISTS idx_wallets_owner_id ON wallets(owner_id);

-- ========================================
-- 12. معاملات المحفظة (Wallet Transactions)
-- ========================================
CREATE TABLE IF NOT EXISTS wallet_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  wallet_id UUID NOT NULL REFERENCES wallets(id) ON DELETE CASCADE,
  type TEXT NOT NULL, -- 'deposit', 'withdraw', 'commission', 'cashback', 'refund'
  amount DECIMAL(10, 2) NOT NULL,
  balance_after DECIMAL(10, 2) NOT NULL,
  description TEXT,
  reference_type TEXT, -- 'order', 'transfer', 'manual'
  reference_id UUID,
  meta JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_wallet_transactions_wallet_id ON wallet_transactions(wallet_id);
CREATE INDEX IF NOT EXISTS idx_wallet_transactions_created_at ON wallet_transactions(created_at);

-- ========================================
-- 13. حسابات النقاط (Points Accounts)
-- ========================================
CREATE TABLE IF NOT EXISTS points_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  account_type TEXT NOT NULL DEFAULT 'merchant', -- 'merchant', 'customer'
  points_balance INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, account_type)
);

CREATE INDEX IF NOT EXISTS idx_points_accounts_user_id ON points_accounts(user_id);

-- ========================================
-- 14. معاملات النقاط (Points Transactions)
-- ========================================
CREATE TABLE IF NOT EXISTS points_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  points_account_id UUID NOT NULL REFERENCES points_accounts(id) ON DELETE CASCADE,
  type TEXT NOT NULL, -- 'earn', 'spend', 'refund', 'adjustment'
  points_amount INTEGER NOT NULL,
  balance_after INTEGER NOT NULL,
  description TEXT,
  reference_type TEXT, -- 'feature', 'purchase', 'reward', 'manual'
  reference_id UUID,
  meta JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_points_transactions_points_account_id ON points_transactions(points_account_id);

-- ========================================
-- 15. الميزات المدفوعة (Feature Actions)
-- ========================================
CREATE TABLE IF NOT EXISTS feature_actions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  action_name TEXT UNIQUE NOT NULL,
  action_name_ar TEXT,
  description TEXT,
  points_cost INTEGER NOT NULL,
  duration_hours INTEGER, -- مدة الميزة بالساعات (24, 48, إلخ)
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_feature_actions_is_active ON feature_actions(is_active);

-- ========================================
-- 16. الكوبونات (Coupons)
-- ========================================
CREATE TABLE IF NOT EXISTS coupons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  discount_type TEXT NOT NULL, -- 'percentage', 'fixed'
  discount_value DECIMAL(10, 2) NOT NULL,
  min_order_amount DECIMAL(10, 2) DEFAULT 0,
  max_discount_amount DECIMAL(10, 2),
  usage_limit INTEGER,
  usage_count INTEGER DEFAULT 0,
  user_id UUID REFERENCES user_profiles(id), -- إذا كان خاص بمستخدم معين
  store_id UUID REFERENCES stores(id), -- إذا كان خاص بمتجر معين
  starts_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_coupons_code ON coupons(code);
CREATE INDEX IF NOT EXISTS idx_coupons_is_active ON coupons(is_active);

-- ========================================
-- 17. استخدام الكوبونات (Coupon Redemptions)
-- ========================================
CREATE TABLE IF NOT EXISTS coupon_redemptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  coupon_id UUID NOT NULL REFERENCES coupons(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
  discount_amount DECIMAL(10, 2) NOT NULL,
  redeemed_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_coupon_redemptions_coupon_id ON coupon_redemptions(coupon_id);
CREATE INDEX IF NOT EXISTS idx_coupon_redemptions_user_id ON coupon_redemptions(user_id);

-- ========================================
-- 18. المفضلة (Favorites)
-- ========================================
CREATE TABLE IF NOT EXISTS favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, product_id)
);

CREATE INDEX IF NOT EXISTS idx_favorites_user_id ON favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_product_id ON favorites(product_id);

-- ========================================
-- 19. متابعو المتاجر (Store Followers)
-- ========================================
CREATE TABLE IF NOT EXISTS store_followers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  followed_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(store_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_store_followers_store_id ON store_followers(store_id);
CREATE INDEX IF NOT EXISTS idx_store_followers_user_id ON store_followers(user_id);

-- ========================================
-- 20. قصص المتاجر (Stories)
-- ========================================
CREATE TABLE IF NOT EXISTS stories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  title TEXT,
  media_url TEXT NOT NULL,
  media_type TEXT DEFAULT 'image', -- 'image', 'video'
  link_url TEXT,
  view_count INTEGER DEFAULT 0,
  expires_at TIMESTAMPTZ DEFAULT NOW() + INTERVAL '24 hours',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_stories_store_id ON stories(store_id);
CREATE INDEX IF NOT EXISTS idx_stories_expires_at ON stories(expires_at);

-- ========================================
-- 21. المحادثات (Conversations)
-- ========================================
CREATE TABLE IF NOT EXISTS conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  merchant_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  last_message_at TIMESTAMPTZ DEFAULT NOW(),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(customer_id, merchant_id)
);

CREATE INDEX IF NOT EXISTS idx_conversations_customer_id ON conversations(customer_id);
CREATE INDEX IF NOT EXISTS idx_conversations_merchant_id ON conversations(merchant_id);

-- ========================================
-- 22. الرسائل (Messages)
-- ========================================
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  media_url TEXT,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at);

-- ========================================
-- 23. رموز الأجهزة (Device Tokens) - FCM
-- ========================================
CREATE TABLE IF NOT EXISTS device_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  token TEXT NOT NULL UNIQUE,
  platform TEXT NOT NULL, -- 'android', 'ios', 'web'
  device_model TEXT,
  app_version TEXT,
  is_active BOOLEAN DEFAULT true,
  last_used_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_device_tokens_user_id ON device_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_device_tokens_token ON device_tokens(token);

-- ========================================
-- 24. الباقات (Packages)
-- ========================================
CREATE TABLE IF NOT EXISTS packages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  name_ar TEXT,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  duration_days INTEGER NOT NULL,
  features JSONB,
  max_products INTEGER,
  is_active BOOLEAN DEFAULT true,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_packages_is_active ON packages(is_active);

-- ========================================
-- 25. اشتراكات الباقات (Package Subscriptions)
-- ========================================
CREATE TABLE IF NOT EXISTS package_subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  package_id UUID NOT NULL REFERENCES packages(id) ON DELETE CASCADE,
  starts_at TIMESTAMPTZ NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  is_active BOOLEAN DEFAULT true,
  payment_id UUID,
  auto_renew BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_package_subscriptions_store_id ON package_subscriptions(store_id);
CREATE INDEX IF NOT EXISTS idx_package_subscriptions_expires_at ON package_subscriptions(expires_at);

-- ========================================
-- البيانات الأولية: الفئات
-- ========================================
INSERT INTO categories (name, name_ar, slug, display_order, icon) VALUES
('Electronics', 'إلكترونيات', 'electronics', 1, '📱'),
('Fashion', 'أزياء', 'fashion', 2, '👔'),
('Home & Garden', 'منزل وحديقة', 'home-garden', 3, '🏠'),
('Sports', 'رياضة', 'sports', 4, '⚽'),
('Books', 'كتب', 'books', 5, '📚'),
('Toys', 'ألعاب', 'toys', 6, '🧸'),
('Health & Beauty', 'صحة وجمال', 'health-beauty', 7, '💄'),
('Automotive', 'سيارات', 'automotive', 8, '🚗'),
('Food & Beverages', 'طعام ومشروبات', 'food-beverages', 9, '🍔'),
('Office Supplies', 'مستلزمات مكتبية', 'office-supplies', 10, '📎')
ON CONFLICT (slug) DO NOTHING;

-- الفئات الفرعية
INSERT INTO categories (name, name_ar, parent_id, slug, display_order) 
SELECT 'Smartphones', 'هواتف ذكية', id, 'smartphones', 1 FROM categories WHERE slug = 'electronics'
UNION ALL
SELECT 'Laptops', 'حواسيب محمولة', id, 'laptops', 2 FROM categories WHERE slug = 'electronics'
UNION ALL
SELECT 'Men Fashion', 'أزياء رجالية', id, 'men-fashion', 1 FROM categories WHERE slug = 'fashion'
UNION ALL
SELECT 'Women Fashion', 'أزياء نسائية', id, 'women-fashion', 2 FROM categories WHERE slug = 'fashion'
ON CONFLICT (slug) DO NOTHING;

-- ========================================
-- البيانات الأولية: الميزات المدفوعة
-- ========================================
INSERT INTO feature_actions (action_name, action_name_ar, description, points_cost, duration_hours) VALUES
('boost_store_24h', 'تعزيز المتجر 24 ساعة', 'ظهور المتجر في أعلى نتائج البحث', 100, 24),
('boost_store_48h', 'تعزيز المتجر 48 ساعة', 'ظهور المتجر في أعلى نتائج البحث', 180, 48),
('boost_store_7d', 'تعزيز المتجر 7 أيام', 'ظهور المتجر في أعلى نتائج البحث', 500, 168),
('highlight_map_24h', 'إبراز الموقع على الخريطة 24 ساعة', 'متجرك يظهر بشكل مميز على الخريطة', 50, 24),
('highlight_map_7d', 'إبراز الموقع على الخريطة 7 أيام', 'متجرك يظهر بشكل مميز على الخريطة', 300, 168),
('generate_video', 'إنشاء فيديو منتج بالذكاء الاصطناعي', 'تحويل صور المنتج لفيديو احترافي', 200, NULL)
ON CONFLICT (action_name) DO NOTHING;

-- ========================================
-- البيانات الأولية: الباقات
-- ========================================
INSERT INTO packages (name, name_ar, description, price, duration_days, max_products, features) VALUES
('Free', 'مجانية', 'باقة تجريبية للمتاجر الجديدة', 0, 30, 10, '{"support": "community", "analytics": false, "featured": false}'::jsonb),
('Basic', 'أساسية', 'مناسبة للمتاجر الصغيرة', 99, 30, 50, '{"support": "email", "analytics": true, "featured": false}'::jsonb),
('Professional', 'احترافية', 'للمتاجر المتوسطة', 299, 30, 200, '{"support": "priority", "analytics": true, "featured": true}'::jsonb),
('Enterprise', 'مؤسسية', 'للشركات الكبيرة', 999, 30, 1000, '{"support": "24/7", "analytics": true, "featured": true, "custom_domain": true}'::jsonb)
ON CONFLICT DO NOTHING;

-- ========================================
-- منح الصلاحيات
-- ========================================
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon;

-- ========================================
-- ملاحظات مهمة
-- ========================================
-- 1. RLS معطل حالياً للتطوير - يجب تفعيله في الإنتاج
-- 2. تأكد من تفعيل Auth في Supabase
-- 3. Cloudflare Images للصور
-- 4. Firebase FCM للإشعارات
