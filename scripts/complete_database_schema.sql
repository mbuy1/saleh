-- ============================================
-- إكمال جداول Supabase الأساسية
-- Saleh / Mbuy App
-- ============================================

-- ============================================
-- أ) المحفظة (Wallets)
-- ============================================

-- جدول المحافظ
CREATE TABLE IF NOT EXISTS wallets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('customer', 'merchant')),
  balance NUMERIC(12,2) NOT NULL DEFAULT 0,
  currency TEXT NOT NULL DEFAULT 'SAR',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT wallets_owner_type_unique UNIQUE (owner_id, type)
);

-- جدول معاملات المحفظة
CREATE TABLE IF NOT EXISTS wallet_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  wallet_id UUID NOT NULL REFERENCES wallets(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('deposit', 'withdraw', 'commission', 'cashback', 'refund')),
  amount NUMERIC(12,2) NOT NULL,
  description TEXT,
  meta JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- ب) النقاط (Points للتاجر)
-- ============================================

-- جدول حسابات النقاط (إن لم يكن موجوداً)
CREATE TABLE IF NOT EXISTS points_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  balance BIGINT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT points_accounts_user_unique UNIQUE (user_id)
);

-- جدول معاملات النقاط (إن لم يكن موجوداً)
CREATE TABLE IF NOT EXISTS points_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id UUID NOT NULL REFERENCES points_accounts(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('purchase', 'spend', 'adjust')),
  feature_key TEXT, -- مثل: 'boost_store_24h', 'map_highlight_24h'
  amount BIGINT NOT NULL,
  meta JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول تعريف الميزات (إن لم يكن موجوداً)
CREATE TABLE IF NOT EXISTS feature_actions (
  key TEXT PRIMARY KEY, -- 'boost_store_24h' مثلاً
  title TEXT NOT NULL,
  description TEXT,
  default_cost BIGINT NOT NULL,
  config JSONB DEFAULT '{}'::jsonb,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- ج) الكوبونات
-- ============================================

-- جدول الكوبونات
CREATE TABLE IF NOT EXISTS coupons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  owner_store_id UUID REFERENCES stores(id) ON DELETE SET NULL,
  type TEXT NOT NULL CHECK (type IN ('fixed', 'percent')),
  value NUMERIC(12,2) NOT NULL,
  max_uses INT,
  used_count INT NOT NULL DEFAULT 0,
  min_order_amount NUMERIC(12,2),
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  is_active BOOLEAN NOT NULL DEFAULT true
);

-- جدول استخدامات الكوبونات
CREATE TABLE IF NOT EXISTS coupon_redemptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  coupon_id UUID NOT NULL REFERENCES coupons(id) ON DELETE CASCADE,
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  customer_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  discount_amount NUMERIC(12,2) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT coupon_redemptions_order_unique UNIQUE (order_id)
);

-- ============================================
-- د) المفضلة والتفاعل
-- ============================================

-- جدول المفضلة
CREATE TABLE IF NOT EXISTS favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  target_type TEXT NOT NULL CHECK (target_type IN ('product', 'store')),
  target_id UUID NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT favorites_user_target_unique UNIQUE (user_id, target_type, target_id)
);

-- جدول التقييمات والمراجعات
CREATE TABLE IF NOT EXISTS reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
  customer_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT reviews_order_product_unique UNIQUE (order_id, product_id)
);

-- ============================================
-- هـ) الشحن والدفع
-- ============================================

-- جدول طرق الشحن
CREATE TABLE IF NOT EXISTS shipping_methods (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  provider_key TEXT, -- مثل اسم شركة الشحن
  base_cost NUMERIC(12,2),
  meta JSONB DEFAULT '{}'::jsonb,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول شحنات الطلبات
CREATE TABLE IF NOT EXISTS shipping_orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  shipping_method_id UUID REFERENCES shipping_methods(id),
  tracking_number TEXT,
  status TEXT,
  meta JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT shipping_orders_order_unique UNIQUE (order_id)
);

-- جدول مزودي الدفع
CREATE TABLE IF NOT EXISTS payment_providers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL, -- TAP, HYPERPAY, ...
  key TEXT UNIQUE NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول جلسات الدفع
CREATE TABLE IF NOT EXISTS payment_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  provider_id UUID REFERENCES payment_providers(id),
  amount NUMERIC(12,2) NOT NULL,
  currency TEXT NOT NULL DEFAULT 'SAR',
  status TEXT NOT NULL, -- initiated, pending, paid, failed, canceled
  provider_reference TEXT, -- reference/id من TAP أو غيرها
  meta JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- و) أجهزة المستخدم لـ Firebase
-- ============================================

-- جدول أجهزة المستخدم
CREATE TABLE IF NOT EXISTS user_devices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  device_token TEXT NOT NULL,
  platform TEXT NOT NULL CHECK (platform IN ('android', 'ios', 'web')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_seen_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT user_devices_token_unique UNIQUE (user_id, device_token)
);

-- ============================================
-- إضافة أعمدة ناقصة للجداول الموجودة
-- ============================================

-- إضافة logo_url للمتاجر (إن لم يكن موجوداً)
ALTER TABLE stores
ADD COLUMN IF NOT EXISTS logo_url TEXT;

-- إضافة image_url للمنتجات (إن لم يكن موجوداً)
ALTER TABLE products
ADD COLUMN IF NOT EXISTS image_url TEXT;

-- إضافة main_image_url للمنتجات (إن لم يكن موجوداً)
ALTER TABLE products
ADD COLUMN IF NOT EXISTS main_image_url TEXT;

-- ============================================
-- الصلاحيات (Grants)
-- ============================================

-- منح الصلاحيات للجداول الجديدة
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;

-- ============================================
-- تعطيل RLS (Row Level Security)
-- ============================================

-- تعطيل RLS على جميع الجداول الجديدة
ALTER TABLE wallets DISABLE ROW LEVEL SECURITY;
ALTER TABLE wallet_transactions DISABLE ROW LEVEL SECURITY;
ALTER TABLE points_accounts DISABLE ROW LEVEL SECURITY;
ALTER TABLE points_transactions DISABLE ROW LEVEL SECURITY;
ALTER TABLE feature_actions DISABLE ROW LEVEL SECURITY;
ALTER TABLE coupons DISABLE ROW LEVEL SECURITY;
ALTER TABLE coupon_redemptions DISABLE ROW LEVEL SECURITY;
ALTER TABLE favorites DISABLE ROW LEVEL SECURITY;
ALTER TABLE reviews DISABLE ROW LEVEL SECURITY;
ALTER TABLE shipping_methods DISABLE ROW LEVEL SECURITY;
ALTER TABLE shipping_orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE payment_providers DISABLE ROW LEVEL SECURITY;
ALTER TABLE payment_sessions DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_devices DISABLE ROW LEVEL SECURITY;

-- ============================================
-- إنشاء Indexes للأداء
-- ============================================

-- Indexes للمحفظة
CREATE INDEX IF NOT EXISTS idx_wallets_owner_id ON wallets(owner_id);
CREATE INDEX IF NOT EXISTS idx_wallet_transactions_wallet_id ON wallet_transactions(wallet_id);
CREATE INDEX IF NOT EXISTS idx_wallet_transactions_created_at ON wallet_transactions(created_at);

-- Indexes للنقاط
CREATE INDEX IF NOT EXISTS idx_points_accounts_user_id ON points_accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_points_transactions_account_id ON points_transactions(account_id);
CREATE INDEX IF NOT EXISTS idx_points_transactions_feature_key ON points_transactions(feature_key);

-- Indexes للكوبونات
CREATE INDEX IF NOT EXISTS idx_coupons_code ON coupons(code);
CREATE INDEX IF NOT EXISTS idx_coupons_owner_store_id ON coupons(owner_store_id);
CREATE INDEX IF NOT EXISTS idx_coupon_redemptions_coupon_id ON coupon_redemptions(coupon_id);
CREATE INDEX IF NOT EXISTS idx_coupon_redemptions_order_id ON coupon_redemptions(order_id);

-- Indexes للمفضلة
CREATE INDEX IF NOT EXISTS idx_favorites_user_id ON favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_target ON favorites(target_type, target_id);

-- Indexes للتقييمات
CREATE INDEX IF NOT EXISTS idx_reviews_product_id ON reviews(product_id);
CREATE INDEX IF NOT EXISTS idx_reviews_customer_id ON reviews(customer_id);
CREATE INDEX IF NOT EXISTS idx_reviews_order_id ON reviews(order_id);

-- Indexes للشحن
CREATE INDEX IF NOT EXISTS idx_shipping_orders_order_id ON shipping_orders(order_id);
CREATE INDEX IF NOT EXISTS idx_shipping_orders_tracking_number ON shipping_orders(tracking_number);

-- Indexes للدفع
CREATE INDEX IF NOT EXISTS idx_payment_sessions_order_id ON payment_sessions(order_id);
CREATE INDEX IF NOT EXISTS idx_payment_sessions_provider_id ON payment_sessions(provider_id);
CREATE INDEX IF NOT EXISTS idx_payment_sessions_status ON payment_sessions(status);

-- Indexes للأجهزة
CREATE INDEX IF NOT EXISTS idx_user_devices_user_id ON user_devices(user_id);
CREATE INDEX IF NOT EXISTS idx_user_devices_device_token ON user_devices(device_token);

-- ============================================
-- إدراج بيانات أولية (إن لزم)
-- ============================================

-- إدراج مزودي الدفع الأساسيين
INSERT INTO payment_providers (name, key, is_active)
VALUES
  ('Tap Payments', 'tap', true),
  ('HyperPay', 'hyperpay', true)
ON CONFLICT (key) DO NOTHING;

-- إدراج طرق الشحن الأساسية
INSERT INTO shipping_methods (name, provider_key, base_cost, is_active)
VALUES
  ('الشحن السريع', 'express', 15.00, true),
  ('الشحن العادي', 'standard', 10.00, true),
  ('الشحن المجاني', 'free', 0.00, true)
ON CONFLICT DO NOTHING;

-- ============================================
-- ملاحظات
-- ============================================

-- 1. جميع الجداول تم تعطيل RLS عليها (سنضيف السياسات لاحقاً)
-- 2. تم منح الصلاحيات الكاملة لـ anon, authenticated, service_role
-- 3. تم إنشاء Indexes للأداء على الحقول المهمة
-- 4. تم إضافة أعمدة logo_url و image_url للجداول الموجودة
-- 5. تم إدراج بيانات أولية لمزودي الدفع وطرق الشحن

