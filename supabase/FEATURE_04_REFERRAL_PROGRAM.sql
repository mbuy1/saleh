-- ============================================================================
-- MBUY Referral Program - برنامج الإحالة
-- الميزة #4 من 23
-- تاريخ الإنشاء: ديسمبر 2025
-- ============================================================================

-- ============================================================================
-- 1. جدول إعدادات برنامج الإحالة (Referral Settings)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.referral_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE UNIQUE,
    
    -- تفعيل البرنامج
    is_enabled BOOLEAN DEFAULT true,
    
    -- مكافأة المُحيل (صاحب الكود)
    referrer_reward_type VARCHAR(20) DEFAULT 'percentage', -- percentage, fixed, points
    referrer_reward_value DECIMAL(10,2) DEFAULT 10, -- 10% أو 10 ريال أو 10 نقطة
    referrer_reward_max DECIMAL(10,2), -- الحد الأقصى للمكافأة
    
    -- مكافأة المُحال (العميل الجديد)
    referee_reward_type VARCHAR(20) DEFAULT 'percentage', -- percentage, fixed, points
    referee_reward_value DECIMAL(10,2) DEFAULT 10,
    referee_min_order DECIMAL(10,2) DEFAULT 50, -- الحد الأدنى للطلب
    
    -- شروط الإحالة
    require_first_purchase BOOLEAN DEFAULT true, -- يجب أن يكون أول شراء
    require_min_order BOOLEAN DEFAULT true,
    min_order_amount DECIMAL(10,2) DEFAULT 100,
    max_referrals_per_user INTEGER DEFAULT 50, -- الحد الأقصى للإحالات لكل مستخدم
    reward_validity_days INTEGER DEFAULT 30, -- صلاحية المكافأة
    
    -- الإحصائيات
    total_referrals INTEGER DEFAULT 0,
    successful_referrals INTEGER DEFAULT 0,
    total_rewards_given DECIMAL(12,2) DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- 2. جدول أكواد الإحالة (Referral Codes)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.referral_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    
    -- الكود
    code VARCHAR(20) NOT NULL,
    
    -- الإحصائيات
    total_uses INTEGER DEFAULT 0,
    successful_uses INTEGER DEFAULT 0,
    total_earnings DECIMAL(12,2) DEFAULT 0,
    
    -- الحالة
    is_active BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(store_id, code),
    UNIQUE(store_id, user_id)
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_referral_codes_store_id ON public.referral_codes(store_id);
CREATE INDEX IF NOT EXISTS idx_referral_codes_user_id ON public.referral_codes(user_id);
CREATE INDEX IF NOT EXISTS idx_referral_codes_code ON public.referral_codes(code);

-- ============================================================================
-- 3. جدول الإحالات (Referrals)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.referrals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    referral_code_id UUID NOT NULL REFERENCES public.referral_codes(id) ON DELETE CASCADE,
    
    -- المُحيل والمُحال
    referrer_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    referee_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    
    -- حالة الإحالة
    status VARCHAR(20) DEFAULT 'pending', -- pending, completed, expired, cancelled
    
    -- الطلب المرتبط
    order_id UUID,
    order_amount DECIMAL(10,2),
    
    -- المكافآت
    referrer_reward_type VARCHAR(20),
    referrer_reward_value DECIMAL(10,2),
    referrer_reward_status VARCHAR(20) DEFAULT 'pending', -- pending, credited, expired
    referrer_credited_at TIMESTAMPTZ,
    
    referee_reward_type VARCHAR(20),
    referee_reward_value DECIMAL(10,2),
    referee_reward_status VARCHAR(20) DEFAULT 'pending',
    referee_credited_at TIMESTAMPTZ,
    
    -- التوقيت
    expires_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(store_id, referee_id) -- كل عميل يمكن إحالته مرة واحدة فقط لكل متجر
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_referrals_store_id ON public.referrals(store_id);
CREATE INDEX IF NOT EXISTS idx_referrals_referrer_id ON public.referrals(referrer_id);
CREATE INDEX IF NOT EXISTS idx_referrals_referee_id ON public.referrals(referee_id);
CREATE INDEX IF NOT EXISTS idx_referrals_status ON public.referrals(status);

-- ============================================================================
-- 4. جدول سجل المكافآت (Referral Rewards Log)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.referral_rewards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    referral_id UUID NOT NULL REFERENCES public.referrals(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    
    -- نوع المكافأة
    reward_for VARCHAR(20) NOT NULL, -- referrer, referee
    reward_type VARCHAR(20) NOT NULL, -- percentage, fixed, points, coupon
    reward_value DECIMAL(10,2) NOT NULL,
    
    -- الحالة
    status VARCHAR(20) DEFAULT 'pending', -- pending, credited, expired, cancelled
    
    -- التفاصيل
    coupon_id UUID REFERENCES public.coupons(id),
    points_added INTEGER,
    wallet_credited DECIMAL(10,2),
    
    -- التوقيت
    credited_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_referral_rewards_user_id ON public.referral_rewards(user_id);
CREATE INDEX IF NOT EXISTS idx_referral_rewards_referral_id ON public.referral_rewards(referral_id);

-- ============================================================================
-- 5. RLS Policies
-- ============================================================================

ALTER TABLE public.referral_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.referral_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.referrals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.referral_rewards ENABLE ROW LEVEL SECURITY;

-- Referral Settings
DROP POLICY IF EXISTS "Store owner can manage referral settings" ON public.referral_settings;
DROP POLICY IF EXISTS "Service role full access to referral_settings" ON public.referral_settings;

CREATE POLICY "Store owner can manage referral settings" ON public.referral_settings
    FOR ALL USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to referral_settings" ON public.referral_settings
    FOR ALL USING (auth.role() = 'service_role');

-- Referral Codes
DROP POLICY IF EXISTS "Users can view own referral codes" ON public.referral_codes;
DROP POLICY IF EXISTS "Store owner can manage referral codes" ON public.referral_codes;
DROP POLICY IF EXISTS "Service role full access to referral_codes" ON public.referral_codes;

CREATE POLICY "Users can view own referral codes" ON public.referral_codes
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Store owner can manage referral codes" ON public.referral_codes
    FOR ALL USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to referral_codes" ON public.referral_codes
    FOR ALL USING (auth.role() = 'service_role');

-- Referrals
DROP POLICY IF EXISTS "Users can view own referrals" ON public.referrals;
DROP POLICY IF EXISTS "Store owner can manage referrals" ON public.referrals;
DROP POLICY IF EXISTS "Service role full access to referrals" ON public.referrals;

CREATE POLICY "Users can view own referrals" ON public.referrals
    FOR SELECT USING (referrer_id = auth.uid() OR referee_id = auth.uid());

CREATE POLICY "Store owner can manage referrals" ON public.referrals
    FOR ALL USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to referrals" ON public.referrals
    FOR ALL USING (auth.role() = 'service_role');

-- Referral Rewards
DROP POLICY IF EXISTS "Users can view own rewards" ON public.referral_rewards;
DROP POLICY IF EXISTS "Store owner can view rewards" ON public.referral_rewards;
DROP POLICY IF EXISTS "Service role full access to referral_rewards" ON public.referral_rewards;

CREATE POLICY "Users can view own rewards" ON public.referral_rewards
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Store owner can view rewards" ON public.referral_rewards
    FOR SELECT USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to referral_rewards" ON public.referral_rewards
    FOR ALL USING (auth.role() = 'service_role');

-- ============================================================================
-- 6. Functions
-- ============================================================================

-- دالة لإنشاء كود إحالة للمستخدم
CREATE OR REPLACE FUNCTION generate_referral_code(
    p_store_id UUID,
    p_user_id UUID
)
RETURNS VARCHAR AS $$
DECLARE
    v_code VARCHAR(20);
    v_exists BOOLEAN;
BEGIN
    -- التحقق من وجود كود مسبق
    SELECT EXISTS(
        SELECT 1 FROM public.referral_codes 
        WHERE store_id = p_store_id AND user_id = p_user_id
    ) INTO v_exists;
    
    IF v_exists THEN
        SELECT code INTO v_code FROM public.referral_codes 
        WHERE store_id = p_store_id AND user_id = p_user_id;
        RETURN v_code;
    END IF;
    
    -- إنشاء كود جديد
    LOOP
        v_code := 'REF' || UPPER(SUBSTR(MD5(RANDOM()::TEXT), 1, 6));
        SELECT EXISTS(
            SELECT 1 FROM public.referral_codes 
            WHERE store_id = p_store_id AND code = v_code
        ) INTO v_exists;
        EXIT WHEN NOT v_exists;
    END LOOP;
    
    INSERT INTO public.referral_codes (store_id, user_id, code)
    VALUES (p_store_id, p_user_id, v_code);
    
    RETURN v_code;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- دالة للتحقق من كود الإحالة
CREATE OR REPLACE FUNCTION validate_referral_code(
    p_store_id UUID,
    p_code VARCHAR,
    p_referee_id UUID
)
RETURNS JSONB AS $$
DECLARE
    v_referral_code RECORD;
    v_settings RECORD;
    v_already_referred BOOLEAN;
BEGIN
    -- جلب إعدادات البرنامج
    SELECT * INTO v_settings FROM public.referral_settings 
    WHERE store_id = p_store_id;
    
    IF NOT FOUND OR NOT v_settings.is_enabled THEN
        RETURN jsonb_build_object('valid', false, 'error', 'برنامج الإحالة غير مفعل');
    END IF;
    
    -- جلب كود الإحالة
    SELECT * INTO v_referral_code FROM public.referral_codes 
    WHERE store_id = p_store_id AND code = UPPER(p_code) AND is_active = true;
    
    IF NOT FOUND THEN
        RETURN jsonb_build_object('valid', false, 'error', 'كود الإحالة غير صالح');
    END IF;
    
    -- التحقق أن المستخدم لا يحيل نفسه
    IF v_referral_code.user_id = p_referee_id THEN
        RETURN jsonb_build_object('valid', false, 'error', 'لا يمكنك استخدام كود الإحالة الخاص بك');
    END IF;
    
    -- التحقق من عدم الإحالة المسبقة
    SELECT EXISTS(
        SELECT 1 FROM public.referrals 
        WHERE store_id = p_store_id AND referee_id = p_referee_id
    ) INTO v_already_referred;
    
    IF v_already_referred THEN
        RETURN jsonb_build_object('valid', false, 'error', 'لقد تمت إحالتك مسبقاً');
    END IF;
    
    -- التحقق من الحد الأقصى للإحالات
    IF v_referral_code.successful_uses >= v_settings.max_referrals_per_user THEN
        RETURN jsonb_build_object('valid', false, 'error', 'وصل صاحب الكود للحد الأقصى من الإحالات');
    END IF;
    
    RETURN jsonb_build_object(
        'valid', true,
        'referral_code_id', v_referral_code.id,
        'referrer_id', v_referral_code.user_id,
        'referee_reward_type', v_settings.referee_reward_type,
        'referee_reward_value', v_settings.referee_reward_value,
        'min_order', v_settings.referee_min_order
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- دالة لتطبيق الإحالة عند إتمام الطلب
CREATE OR REPLACE FUNCTION apply_referral(
    p_store_id UUID,
    p_referral_code_id UUID,
    p_referee_id UUID,
    p_order_id UUID,
    p_order_amount DECIMAL
)
RETURNS JSONB AS $$
DECLARE
    v_referral_code RECORD;
    v_settings RECORD;
    v_referral_id UUID;
    v_referrer_reward DECIMAL;
    v_referee_reward DECIMAL;
BEGIN
    -- جلب الإعدادات
    SELECT * INTO v_settings FROM public.referral_settings 
    WHERE store_id = p_store_id;
    
    -- جلب كود الإحالة
    SELECT * INTO v_referral_code FROM public.referral_codes 
    WHERE id = p_referral_code_id;
    
    -- حساب مكافأة المُحيل
    IF v_settings.referrer_reward_type = 'percentage' THEN
        v_referrer_reward := p_order_amount * (v_settings.referrer_reward_value / 100);
        IF v_settings.referrer_reward_max IS NOT NULL THEN
            v_referrer_reward := LEAST(v_referrer_reward, v_settings.referrer_reward_max);
        END IF;
    ELSE
        v_referrer_reward := v_settings.referrer_reward_value;
    END IF;
    
    -- حساب مكافأة المُحال
    IF v_settings.referee_reward_type = 'percentage' THEN
        v_referee_reward := p_order_amount * (v_settings.referee_reward_value / 100);
    ELSE
        v_referee_reward := v_settings.referee_reward_value;
    END IF;
    
    -- إنشاء سجل الإحالة
    INSERT INTO public.referrals (
        store_id, referral_code_id, referrer_id, referee_id,
        order_id, order_amount, status,
        referrer_reward_type, referrer_reward_value,
        referee_reward_type, referee_reward_value,
        completed_at
    ) VALUES (
        p_store_id, p_referral_code_id, v_referral_code.user_id, p_referee_id,
        p_order_id, p_order_amount, 'completed',
        v_settings.referrer_reward_type, v_referrer_reward,
        v_settings.referee_reward_type, v_referee_reward,
        NOW()
    ) RETURNING id INTO v_referral_id;
    
    -- تحديث إحصائيات الكود
    UPDATE public.referral_codes
    SET total_uses = total_uses + 1,
        successful_uses = successful_uses + 1,
        total_earnings = total_earnings + v_referrer_reward,
        updated_at = NOW()
    WHERE id = p_referral_code_id;
    
    -- تحديث إحصائيات البرنامج
    UPDATE public.referral_settings
    SET total_referrals = total_referrals + 1,
        successful_referrals = successful_referrals + 1,
        total_rewards_given = total_rewards_given + v_referrer_reward + v_referee_reward,
        updated_at = NOW()
    WHERE store_id = p_store_id;
    
    RETURN jsonb_build_object(
        'success', true,
        'referral_id', v_referral_id,
        'referrer_reward', v_referrer_reward,
        'referee_reward', v_referee_reward
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 7. Triggers
-- ============================================================================
CREATE OR REPLACE FUNCTION update_referral_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS referral_settings_updated_at ON public.referral_settings;
CREATE TRIGGER referral_settings_updated_at
    BEFORE UPDATE ON public.referral_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_referral_timestamp();

DROP TRIGGER IF EXISTS referral_codes_updated_at ON public.referral_codes;
CREATE TRIGGER referral_codes_updated_at
    BEFORE UPDATE ON public.referral_codes
    FOR EACH ROW
    EXECUTE FUNCTION update_referral_timestamp();

DROP TRIGGER IF EXISTS referrals_updated_at ON public.referrals;
CREATE TRIGGER referrals_updated_at
    BEFORE UPDATE ON public.referrals
    FOR EACH ROW
    EXECUTE FUNCTION update_referral_timestamp();

-- ============================================================================
-- ✅ تم الإنشاء بنجاح!
-- ============================================================================
SELECT 'Referral Program installed successfully!' as status;
