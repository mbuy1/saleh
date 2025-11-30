-- ============================================
-- إعداد جداول وميزات نظام النقاط للتاجر
-- ============================================

-- 1) إضافة أعمدة للمتاجر في جدول stores
ALTER TABLE stores
ADD COLUMN IF NOT EXISTS boosted_until timestamptz,
ADD COLUMN IF NOT EXISTS map_highlight_until timestamptz;

-- 2) إنشاء جدول feature_actions (إن لم يكن موجوداً)
CREATE TABLE IF NOT EXISTS feature_actions (
  key           text PRIMARY KEY,
  title         text NOT NULL,
  description   text,
  default_cost  integer NOT NULL,
  is_enabled    boolean NOT NULL DEFAULT true,
  config        jsonb,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);

-- 3) إدخال تعريف الميزتين
INSERT INTO feature_actions (key, title, description, default_cost, is_enabled, config)
VALUES
  (
    'boost_store_24h',
    'دعم المتجر في صفحة المتاجر',
    'تثبيت المتجر في أعلى صفحة المتاجر لمدة 24 ساعة',
    10,
    true,
    jsonb_build_object('duration_hours', 24)
  ),
  (
    'map_highlight_24h',
    'إبراز المتجر على الخريطة',
    'إظهار المتجر بشكل مميز على الخريطة لمدة 24 ساعة',
    8,
    true,
    jsonb_build_object('duration_hours', 24)
  )
ON CONFLICT (key) DO NOTHING;

-- 4) إنشاء جدول points_accounts (إن لم يكن موجوداً)
CREATE TABLE IF NOT EXISTS points_accounts (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  points_balance integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT points_accounts_user_unique UNIQUE (user_id)
);

-- 5) إنشاء جدول points_transactions (إن لم يكن موجوداً)
-- ملاحظة: يمكن استخدام points_account_id أو account_id حسب هيكل الجدول الموجود
CREATE TABLE IF NOT EXISTS points_transactions (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  points_account_id uuid NOT NULL REFERENCES points_accounts(id) ON DELETE CASCADE,
  type           text NOT NULL CHECK (type IN ('purchase', 'spend_feature')),
  feature_key    text,
  points_change  integer NOT NULL,
  meta           jsonb,
  created_at     timestamptz NOT NULL DEFAULT now()
);

-- إذا كان الجدول موجوداً ويستخدم account_id بدلاً من points_account_id، استخدم:
-- ALTER TABLE points_transactions RENAME COLUMN account_id TO points_account_id;

-- ملاحظة: لا نفعّل RLS الآن، نعمل بدون سياسات أمان

