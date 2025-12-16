-- ============================================================================
-- MBUY Abandoned Cart System - نظام السلة المتروكة
-- الميزة #3 من 23
-- تاريخ الإنشاء: ديسمبر 2025
-- ============================================================================

-- ============================================================================
-- 1. جدول السلات المتروكة (Abandoned Carts)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.abandoned_carts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    
    -- معلومات العميل
    customer_id UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    customer_email VARCHAR(255),
    customer_phone VARCHAR(20),
    customer_name VARCHAR(100),
    
    -- معلومات السلة
    cart_token VARCHAR(100), -- للزوار غير المسجلين
    cart_total DECIMAL(10,2) NOT NULL DEFAULT 0,
    items_count INTEGER NOT NULL DEFAULT 0,
    
    -- محتويات السلة (JSON)
    cart_items JSONB NOT NULL DEFAULT '[]',
    
    -- حالة السلة
    status VARCHAR(30) DEFAULT 'abandoned', -- abandoned, recovered, expired, converted
    
    -- تتبع الإشعارات
    reminder_sent_at TIMESTAMPTZ,
    reminder_count INTEGER DEFAULT 0,
    last_reminder_type VARCHAR(30), -- email, sms, push, whatsapp
    
    -- الكوبون المُرسل
    coupon_id UUID REFERENCES public.coupons(id) ON DELETE SET NULL,
    coupon_sent_at TIMESTAMPTZ,
    
    -- التحويل
    converted_order_id UUID,
    converted_at TIMESTAMPTZ,
    
    -- التوقيت
    cart_created_at TIMESTAMPTZ DEFAULT NOW(),
    abandoned_at TIMESTAMPTZ DEFAULT NOW(),
    expires_at TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '30 days'),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_abandoned_carts_store_id ON public.abandoned_carts(store_id);
CREATE INDEX IF NOT EXISTS idx_abandoned_carts_customer_id ON public.abandoned_carts(customer_id);
CREATE INDEX IF NOT EXISTS idx_abandoned_carts_status ON public.abandoned_carts(status);
CREATE INDEX IF NOT EXISTS idx_abandoned_carts_abandoned_at ON public.abandoned_carts(abandoned_at);
CREATE INDEX IF NOT EXISTS idx_abandoned_carts_cart_token ON public.abandoned_carts(cart_token);

-- ============================================================================
-- 2. جدول إعدادات استرجاع السلة (Cart Recovery Settings)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.cart_recovery_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE UNIQUE,
    
    -- تفعيل الميزة
    is_enabled BOOLEAN DEFAULT true,
    
    -- توقيت الإشعارات (بالساعات)
    first_reminder_hours INTEGER DEFAULT 1,
    second_reminder_hours INTEGER DEFAULT 24,
    third_reminder_hours INTEGER DEFAULT 72,
    
    -- قنوات الإشعار
    enable_email BOOLEAN DEFAULT true,
    enable_sms BOOLEAN DEFAULT false,
    enable_push BOOLEAN DEFAULT true,
    enable_whatsapp BOOLEAN DEFAULT false,
    
    -- الكوبون التلقائي
    auto_coupon_enabled BOOLEAN DEFAULT false,
    auto_coupon_discount INTEGER DEFAULT 10, -- نسبة الخصم
    auto_coupon_min_cart DECIMAL(10,2) DEFAULT 0, -- الحد الأدنى للسلة
    auto_coupon_on_reminder INTEGER DEFAULT 2, -- إرسال الكوبون مع التذكير رقم
    
    -- قوالب الرسائل
    email_subject_ar VARCHAR(200) DEFAULT 'نسيت شيئاً في سلتك! 🛒',
    email_template_ar TEXT DEFAULT 'مرحباً {customer_name}، لاحظنا أنك تركت بعض المنتجات في سلة التسوق. أكمل طلبك الآن!',
    sms_template_ar VARCHAR(500) DEFAULT 'سلتك في {store_name} تنتظرك! أكمل طلبك الآن: {cart_link}',
    push_title_ar VARCHAR(100) DEFAULT 'سلتك تنتظرك! 🛒',
    push_body_ar VARCHAR(200) DEFAULT 'لديك {items_count} منتج في سلة التسوق',
    
    -- الإحصائيات
    total_abandoned INTEGER DEFAULT 0,
    total_recovered INTEGER DEFAULT 0,
    total_revenue_recovered DECIMAL(12,2) DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- 3. جدول سجل الإشعارات (Recovery Notifications Log)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.cart_recovery_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    abandoned_cart_id UUID NOT NULL REFERENCES public.abandoned_carts(id) ON DELETE CASCADE,
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    
    -- نوع الإشعار
    notification_type VARCHAR(30) NOT NULL, -- email, sms, push, whatsapp
    reminder_number INTEGER NOT NULL, -- 1, 2, 3
    
    -- الحالة
    status VARCHAR(20) DEFAULT 'sent', -- sent, delivered, opened, clicked, failed
    
    -- التفاصيل
    sent_to VARCHAR(255), -- البريد أو الرقم
    message_content TEXT,
    coupon_code VARCHAR(50),
    
    -- التتبع
    opened_at TIMESTAMPTZ,
    clicked_at TIMESTAMPTZ,
    error_message TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_recovery_logs_cart_id ON public.cart_recovery_logs(abandoned_cart_id);
CREATE INDEX IF NOT EXISTS idx_recovery_logs_store_id ON public.cart_recovery_logs(store_id);

-- ============================================================================
-- 4. RLS Policies
-- ============================================================================

ALTER TABLE public.abandoned_carts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cart_recovery_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cart_recovery_logs ENABLE ROW LEVEL SECURITY;

-- Abandoned Carts
DROP POLICY IF EXISTS "Store owner can manage abandoned carts" ON public.abandoned_carts;
DROP POLICY IF EXISTS "Service role full access to abandoned_carts" ON public.abandoned_carts;

CREATE POLICY "Store owner can manage abandoned carts" ON public.abandoned_carts
    FOR ALL USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to abandoned_carts" ON public.abandoned_carts
    FOR ALL USING (auth.role() = 'service_role');

-- Cart Recovery Settings
DROP POLICY IF EXISTS "Store owner can manage recovery settings" ON public.cart_recovery_settings;
DROP POLICY IF EXISTS "Service role full access to cart_recovery_settings" ON public.cart_recovery_settings;

CREATE POLICY "Store owner can manage recovery settings" ON public.cart_recovery_settings
    FOR ALL USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to cart_recovery_settings" ON public.cart_recovery_settings
    FOR ALL USING (auth.role() = 'service_role');

-- Recovery Logs
DROP POLICY IF EXISTS "Store owner can view recovery logs" ON public.cart_recovery_logs;
DROP POLICY IF EXISTS "Service role full access to cart_recovery_logs" ON public.cart_recovery_logs;

CREATE POLICY "Store owner can view recovery logs" ON public.cart_recovery_logs
    FOR SELECT USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to cart_recovery_logs" ON public.cart_recovery_logs
    FOR ALL USING (auth.role() = 'service_role');

-- ============================================================================
-- 5. Functions
-- ============================================================================

-- دالة لإنشاء سلة متروكة جديدة
CREATE OR REPLACE FUNCTION create_abandoned_cart(
    p_store_id UUID,
    p_customer_id UUID,
    p_cart_items JSONB,
    p_cart_total DECIMAL,
    p_customer_email VARCHAR DEFAULT NULL,
    p_customer_phone VARCHAR DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    v_cart_id UUID;
    v_items_count INTEGER;
BEGIN
    v_items_count := jsonb_array_length(p_cart_items);
    
    INSERT INTO public.abandoned_carts (
        store_id, customer_id, cart_items, cart_total, items_count,
        customer_email, customer_phone, status
    ) VALUES (
        p_store_id, p_customer_id, p_cart_items, p_cart_total, v_items_count,
        p_customer_email, p_customer_phone, 'abandoned'
    ) RETURNING id INTO v_cart_id;
    
    -- تحديث إحصائيات المتجر
    UPDATE public.cart_recovery_settings
    SET total_abandoned = total_abandoned + 1, updated_at = NOW()
    WHERE store_id = p_store_id;
    
    RETURN v_cart_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- دالة لتحويل السلة إلى طلب
CREATE OR REPLACE FUNCTION convert_abandoned_cart(
    p_cart_id UUID,
    p_order_id UUID
)
RETURNS void AS $$
DECLARE
    v_store_id UUID;
    v_cart_total DECIMAL;
BEGIN
    -- جلب معلومات السلة
    SELECT store_id, cart_total INTO v_store_id, v_cart_total
    FROM public.abandoned_carts WHERE id = p_cart_id;
    
    -- تحديث السلة
    UPDATE public.abandoned_carts
    SET status = 'converted',
        converted_order_id = p_order_id,
        converted_at = NOW(),
        updated_at = NOW()
    WHERE id = p_cart_id;
    
    -- تحديث إحصائيات المتجر
    UPDATE public.cart_recovery_settings
    SET total_recovered = total_recovered + 1,
        total_revenue_recovered = total_revenue_recovered + v_cart_total,
        updated_at = NOW()
    WHERE store_id = v_store_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- دالة للحصول على السلات المتروكة التي تحتاج تذكير
CREATE OR REPLACE FUNCTION get_carts_needing_reminder(p_store_id UUID)
RETURNS TABLE (
    cart_id UUID,
    customer_email VARCHAR,
    customer_phone VARCHAR,
    cart_total DECIMAL,
    items_count INTEGER,
    hours_since_abandoned DOUBLE PRECISION,
    reminder_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ac.id as cart_id,
        ac.customer_email,
        ac.customer_phone,
        ac.cart_total,
        ac.items_count,
        EXTRACT(EPOCH FROM (NOW() - ac.abandoned_at)) / 3600 as hours_since_abandoned,
        ac.reminder_count
    FROM public.abandoned_carts ac
    JOIN public.cart_recovery_settings crs ON ac.store_id = crs.store_id
    WHERE ac.store_id = p_store_id
    AND ac.status = 'abandoned'
    AND crs.is_enabled = true
    AND (
        (ac.reminder_count = 0 AND EXTRACT(EPOCH FROM (NOW() - ac.abandoned_at)) / 3600 >= crs.first_reminder_hours)
        OR (ac.reminder_count = 1 AND EXTRACT(EPOCH FROM (NOW() - ac.abandoned_at)) / 3600 >= crs.second_reminder_hours)
        OR (ac.reminder_count = 2 AND EXTRACT(EPOCH FROM (NOW() - ac.abandoned_at)) / 3600 >= crs.third_reminder_hours)
    )
    AND ac.reminder_count < 3;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 6. Trigger لتحديث updated_at
-- ============================================================================
CREATE OR REPLACE FUNCTION update_abandoned_cart_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS abandoned_carts_updated_at ON public.abandoned_carts;
CREATE TRIGGER abandoned_carts_updated_at
    BEFORE UPDATE ON public.abandoned_carts
    FOR EACH ROW
    EXECUTE FUNCTION update_abandoned_cart_timestamp();

-- ============================================================================
-- ✅ تم الإنشاء بنجاح!
-- ============================================================================
SELECT 'Abandoned Cart system installed successfully!' as status;
