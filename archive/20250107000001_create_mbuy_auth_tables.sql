-- ========================================
-- إنشاء جداول Auth مخصصة لـ MBUY
-- تاريخ: يناير 2025
-- الهدف: نظام Auth مخصص بدون الاعتماد على Supabase Auth
-- ========================================

-- ========================================
-- 1. جدول mbuy_users - المستخدمون
-- ========================================
CREATE TABLE IF NOT EXISTS public.mbuy_users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  full_name TEXT,
  phone TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  
  -- Indexes
  CONSTRAINT mbuy_users_email_unique UNIQUE (email)
);

-- Index for faster email lookups
CREATE INDEX IF NOT EXISTS idx_mbuy_users_email ON public.mbuy_users(email);
CREATE INDEX IF NOT EXISTS idx_mbuy_users_is_active ON public.mbuy_users(is_active);

-- ========================================
-- 2. جدول mbuy_sessions - الجلسات
-- ========================================
CREATE TABLE IF NOT EXISTS public.mbuy_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.mbuy_users(id) ON DELETE CASCADE,
  token_hash TEXT NOT NULL, -- hash of JWT token for revocation tracking
  user_agent TEXT,
  ip_address TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  expires_at TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT true,
  
  -- Indexes
  CONSTRAINT mbuy_sessions_user_id_fkey FOREIGN KEY (user_id) 
    REFERENCES public.mbuy_users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_mbuy_sessions_user_id ON public.mbuy_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_mbuy_sessions_token_hash ON public.mbuy_sessions(token_hash);
CREATE INDEX IF NOT EXISTS idx_mbuy_sessions_is_active ON public.mbuy_sessions(is_active);
CREATE INDEX IF NOT EXISTS idx_mbuy_sessions_expires_at ON public.mbuy_sessions(expires_at);

-- ========================================
-- 3. Function لتحديث updated_at تلقائياً
-- ========================================
CREATE OR REPLACE FUNCTION update_mbuy_users_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger لتحديث updated_at
DROP TRIGGER IF EXISTS trigger_update_mbuy_users_updated_at ON public.mbuy_users;
CREATE TRIGGER trigger_update_mbuy_users_updated_at
  BEFORE UPDATE ON public.mbuy_users
  FOR EACH ROW
  EXECUTE FUNCTION update_mbuy_users_updated_at();

-- ========================================
-- 4. RLS Policies (مغلقة - سنستخدم Service Role)
-- ========================================
ALTER TABLE public.mbuy_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mbuy_sessions ENABLE ROW LEVEL SECURITY;

-- Policy: Service Role يمكنه الوصول لجميع البيانات
CREATE POLICY "Service role can access all mbuy_users"
  ON public.mbuy_users
  FOR ALL
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Service role can access all mbuy_sessions"
  ON public.mbuy_sessions
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- ========================================
-- 5. ربط mbuy_users مع user_profiles (إن وجد)
-- ========================================
-- إضافة عمود mbuy_user_id في user_profiles للربط
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = 'user_profiles'
  ) THEN
    -- إضافة عمود mbuy_user_id إذا لم يكن موجوداً
    IF NOT EXISTS (
      SELECT 1 
      FROM information_schema.columns 
      WHERE table_schema = 'public' 
      AND table_name = 'user_profiles' 
      AND column_name = 'mbuy_user_id'
    ) THEN
      ALTER TABLE public.user_profiles 
        ADD COLUMN mbuy_user_id UUID REFERENCES public.mbuy_users(id) ON DELETE CASCADE;
      
      CREATE INDEX IF NOT EXISTS idx_user_profiles_mbuy_user_id 
        ON public.user_profiles(mbuy_user_id);
      
      RAISE NOTICE '✅ تم إضافة عمود mbuy_user_id إلى user_profiles';
    ELSE
      RAISE NOTICE '⚠️ عمود mbuy_user_id موجود بالفعل - تم تخطيه';
    END IF;
  END IF;
END $$;

-- ========================================
-- 6. ربط mbuy_users مع stores (إن وجد)
-- ========================================
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = 'stores'
  ) THEN
    -- إضافة عمود mbuy_owner_id إذا لم يكن موجوداً
    IF NOT EXISTS (
      SELECT 1 
      FROM information_schema.columns 
      WHERE table_schema = 'public' 
      AND table_name = 'stores' 
      AND column_name = 'mbuy_owner_id'
    ) THEN
      ALTER TABLE public.stores 
        ADD COLUMN mbuy_owner_id UUID REFERENCES public.mbuy_users(id) ON DELETE SET NULL;
      
      CREATE INDEX IF NOT EXISTS idx_stores_mbuy_owner_id 
        ON public.stores(mbuy_owner_id);
      
      RAISE NOTICE '✅ تم إضافة عمود mbuy_owner_id إلى stores';
    ELSE
      RAISE NOTICE '⚠️ عمود mbuy_owner_id موجود بالفعل - تم تخطيه';
    END IF;
  END IF;
END $$;

-- ========================================
-- ملاحظات:
-- ========================================
-- 1. جميع الجداول تستخدم Service Role Key للوصول
-- 2. RLS Policies مفتوحة للـ Service Role فقط
-- 3. يمكن ربط mbuy_users مع الجداول الموجودة عبر mbuy_user_id
-- 4. password_hash يجب أن يكون مشفراً باستخدام bcrypt أو argon2
-- 5. token_hash في sessions يمكن استخدامه لتتبع الجلسات النشطة
-- ========================================

