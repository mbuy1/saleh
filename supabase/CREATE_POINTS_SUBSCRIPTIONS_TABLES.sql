-- ============================================================================
-- MBUY Points & Subscriptions System
-- تاريخ الإنشاء: ديسمبر 2025
-- ============================================================================

-- ============================================================================
-- 1. جدول الاشتراكات (Subscriptions)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    store_id UUID REFERENCES public.stores(id) ON DELETE CASCADE,
    
    -- معلومات الباقة
    plan_id VARCHAR(50) NOT NULL DEFAULT 'starter', -- starter, pro, business, enterprise
    plan_name VARCHAR(100) NOT NULL DEFAULT 'باقة البداية',
    
    -- الحالة
    status VARCHAR(20) NOT NULL DEFAULT 'active', -- active, cancelled, expired, paused
    
    -- التواريخ
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    
    -- الدفع
    price DECIMAL(10,2) DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'SAR',
    payment_method VARCHAR(50), -- card, apple_pay, mada, stc_pay
    payment_provider VARCHAR(50), -- stripe, moyasar, tap
    external_subscription_id VARCHAR(255), -- معرف من مزود الدفع
    
    -- الحدود
    ai_images_limit INTEGER DEFAULT 3,
    ai_images_used INTEGER DEFAULT 0,
    ai_videos_limit INTEGER DEFAULT 0,
    ai_videos_used INTEGER DEFAULT 0,
    products_limit INTEGER DEFAULT 50,
    
    -- البيانات الوصفية
    metadata JSONB DEFAULT '{}',
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- فهرس للبحث السريع
CREATE INDEX IF NOT EXISTS idx_subscriptions_user_id ON public.subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_store_id ON public.subscriptions(store_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_status ON public.subscriptions(status);
CREATE INDEX IF NOT EXISTS idx_subscriptions_plan_id ON public.subscriptions(plan_id);

-- ============================================================================
-- 2. جدول النقاط (Points)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.points (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    store_id UUID REFERENCES public.stores(id) ON DELETE CASCADE,
    
    -- الأرصدة
    current_balance INTEGER NOT NULL DEFAULT 0,
    lifetime_earned INTEGER NOT NULL DEFAULT 0,
    lifetime_redeemed INTEGER NOT NULL DEFAULT 0,
    
    -- المستوى
    level VARCHAR(20) DEFAULT 'bronze', -- bronze, silver, gold, platinum, diamond
    level_progress INTEGER DEFAULT 0, -- التقدم نحو المستوى التالي (0-100)
    
    -- آخر نشاط
    last_earned_at TIMESTAMPTZ,
    last_redeemed_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(user_id)
);

-- فهرس للبحث السريع
CREATE INDEX IF NOT EXISTS idx_points_user_id ON public.points(user_id);
CREATE INDEX IF NOT EXISTS idx_points_store_id ON public.points(store_id);
CREATE INDEX IF NOT EXISTS idx_points_level ON public.points(level);

-- ============================================================================
-- 3. جدول معاملات النقاط (Point Transactions)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.point_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    points_id UUID REFERENCES public.points(id) ON DELETE CASCADE,
    
    -- نوع المعاملة
    type VARCHAR(20) NOT NULL, -- earned, redeemed, bonus, expired, adjusted
    
    -- المبلغ
    amount INTEGER NOT NULL, -- موجب للكسب، سالب للاستبدال
    balance_after INTEGER NOT NULL, -- الرصيد بعد المعاملة
    
    -- التفاصيل
    description TEXT,
    description_ar TEXT,
    
    -- المرجع
    reference_type VARCHAR(50), -- order, product, challenge, referral, reward
    reference_id UUID,
    
    -- المكافأة المستبدلة (إن وجدت)
    reward_id VARCHAR(50),
    reward_name VARCHAR(100),
    
    -- البيانات الوصفية
    metadata JSONB DEFAULT '{}',
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- فهرس للبحث السريع
CREATE INDEX IF NOT EXISTS idx_point_transactions_user_id ON public.point_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_point_transactions_type ON public.point_transactions(type);
CREATE INDEX IF NOT EXISTS idx_point_transactions_created_at ON public.point_transactions(created_at DESC);

-- ============================================================================
-- 4. جدول المكافآت المتاحة (Point Rewards)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.point_rewards (
    id VARCHAR(50) PRIMARY KEY,
    
    -- معلومات المكافأة
    title VARCHAR(100) NOT NULL,
    title_ar VARCHAR(100) NOT NULL,
    description TEXT,
    description_ar TEXT,
    
    -- التكلفة
    points_cost INTEGER NOT NULL,
    
    -- النوع
    reward_type VARCHAR(50) NOT NULL, -- discount, ai_credits, priority_support, free_month
    reward_value JSONB DEFAULT '{}', -- قيمة المكافأة حسب النوع
    
    -- الحالة
    is_active BOOLEAN DEFAULT true,
    
    -- الحدود
    max_redemptions_per_user INTEGER, -- NULL = غير محدود
    total_available INTEGER, -- NULL = غير محدود
    total_redeemed INTEGER DEFAULT 0,
    
    -- التواريخ
    available_from TIMESTAMPTZ,
    available_until TIMESTAMPTZ,
    
    -- الترتيب والعرض
    display_order INTEGER DEFAULT 0,
    icon VARCHAR(50),
    color VARCHAR(20),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- 5. جدول توكنات الإشعارات (Push Tokens)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.push_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    
    -- معلومات التوكن
    token TEXT NOT NULL,
    platform VARCHAR(20) NOT NULL, -- ios, android, web
    device_id VARCHAR(255),
    device_name VARCHAR(255),
    
    -- الحالة
    is_active BOOLEAN DEFAULT true,
    last_used_at TIMESTAMPTZ,
    
    -- التفضيلات
    notifications_enabled BOOLEAN DEFAULT true,
    marketing_enabled BOOLEAN DEFAULT true,
    orders_enabled BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(user_id, token)
);

-- فهرس للبحث السريع
CREATE INDEX IF NOT EXISTS idx_push_tokens_user_id ON public.push_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_push_tokens_platform ON public.push_tokens(platform);
CREATE INDEX IF NOT EXISTS idx_push_tokens_is_active ON public.push_tokens(is_active);

-- ============================================================================
-- 6. جدول الإشعارات (Notifications)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    
    -- المحتوى
    title VARCHAR(255) NOT NULL,
    title_ar VARCHAR(255),
    body TEXT NOT NULL,
    body_ar TEXT,
    
    -- النوع
    type VARCHAR(50) NOT NULL, -- order, promotion, system, points, subscription
    
    -- البيانات
    data JSONB DEFAULT '{}',
    action_url VARCHAR(500),
    image_url VARCHAR(500),
    
    -- الحالة
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMPTZ,
    
    -- الإرسال
    is_sent BOOLEAN DEFAULT false,
    sent_at TIMESTAMPTZ,
    send_error TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- فهرس للبحث السريع
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON public.notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_type ON public.notifications(type);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON public.notifications(created_at DESC);

-- ============================================================================
-- 7. RLS Policies
-- ============================================================================

-- تفعيل RLS
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.points ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.point_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.point_rewards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.push_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Subscriptions: المستخدم يرى اشتراكه فقط
CREATE POLICY "Users can view own subscriptions" ON public.subscriptions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Service role full access to subscriptions" ON public.subscriptions
    FOR ALL USING (auth.role() = 'service_role');

-- Points: المستخدم يرى نقاطه فقط
CREATE POLICY "Users can view own points" ON public.points
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Service role full access to points" ON public.points
    FOR ALL USING (auth.role() = 'service_role');

-- Point Transactions: المستخدم يرى معاملاته فقط
CREATE POLICY "Users can view own point transactions" ON public.point_transactions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Service role full access to point_transactions" ON public.point_transactions
    FOR ALL USING (auth.role() = 'service_role');

-- Point Rewards: الجميع يمكنهم رؤية المكافآت النشطة
CREATE POLICY "Anyone can view active rewards" ON public.point_rewards
    FOR SELECT USING (is_active = true);

CREATE POLICY "Service role full access to point_rewards" ON public.point_rewards
    FOR ALL USING (auth.role() = 'service_role');

-- Push Tokens: المستخدم يدير توكناته
CREATE POLICY "Users can manage own push tokens" ON public.push_tokens
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Service role full access to push_tokens" ON public.push_tokens
    FOR ALL USING (auth.role() = 'service_role');

-- Notifications: المستخدم يرى إشعاراته فقط
CREATE POLICY "Users can view own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications" ON public.notifications
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Service role full access to notifications" ON public.notifications
    FOR ALL USING (auth.role() = 'service_role');

-- ============================================================================
-- 8. إدراج المكافآت الافتراضية
-- ============================================================================
INSERT INTO public.point_rewards (id, title, title_ar, description, description_ar, points_cost, reward_type, reward_value, icon, color, display_order) VALUES
('discount_5', '5% Discount', 'خصم 5%', 'Get 5% off your next subscription', 'خصم على الباقة التالية', 500, 'discount', '{"percentage": 5}', 'discount', 'green', 1),
('discount_10', '10% Discount', 'خصم 10%', 'Get 10% off your next subscription', 'خصم على الباقة التالية', 900, 'discount', '{"percentage": 10}', 'discount', 'blue', 2),
('ai_images_5', '5 Free AI Images', '5 صور AI مجانية', 'Get 5 extra AI image generations', 'صور إضافية لهذا الشهر', 300, 'ai_credits', '{"images": 5}', 'image', 'purple', 3),
('ai_video_1', '1 Free AI Video', 'فيديو AI مجاني', 'Get 1 extra AI video generation', 'فيديو واحد إضافي', 600, 'ai_credits', '{"videos": 1}', 'videocam', 'orange', 4),
('priority_support', 'Priority Support', 'دعم أولوية', 'One week of priority support', 'أسبوع من الدعم المميز', 1000, 'priority_support', '{"days": 7}', 'support_agent', 'red', 5)
ON CONFLICT (id) DO UPDATE SET
    points_cost = EXCLUDED.points_cost,
    updated_at = NOW();

-- ============================================================================
-- تم الإنشاء بنجاح!
-- ============================================================================
