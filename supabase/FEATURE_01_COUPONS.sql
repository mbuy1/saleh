-- ============================================================================
-- MBUY Coupons System - نظام الكوبونات الذكي
-- تاريخ الإنشاء: ديسمبر 2025
-- ============================================================================

-- ============================================================================
-- 1. جدول الكوبونات (Coupons)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.coupons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    
    -- معلومات الكوبون
    code VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    title_ar VARCHAR(100),
    description TEXT,
    description_ar TEXT,
    
    -- نوع الخصم
    discount_type VARCHAR(20) NOT NULL DEFAULT 'percentage', -- percentage, fixed, free_shipping
    discount_value DECIMAL(10,2) NOT NULL, -- نسبة أو مبلغ
    max_discount DECIMAL(10,2), -- الحد الأقصى للخصم (للنسبة المئوية)
    
    -- الشروط
    min_order_amount DECIMAL(10,2) DEFAULT 0, -- الحد الأدنى للطلب
    min_items INTEGER DEFAULT 0, -- الحد الأدنى للمنتجات
    
    -- حدود الاستخدام
    usage_limit INTEGER, -- NULL = غير محدود
    usage_per_customer INTEGER DEFAULT 1,
    times_used INTEGER DEFAULT 0,
    
    -- الصلاحية
    starts_at TIMESTAMPTZ DEFAULT NOW(),
    expires_at TIMESTAMPTZ,
    
    -- الاستهداف
    target_type VARCHAR(30) DEFAULT 'all', -- all, new_customers, returning, specific_customers
    target_customers UUID[], -- للعملاء المحددين
    applicable_products UUID[], -- NULL = جميع المنتجات
    applicable_categories UUID[], -- NULL = جميع الفئات
    
    -- نوع الكوبون الذكي
    smart_type VARCHAR(30), -- abandoned_cart, first_order, win_back, social_share
    auto_apply BOOLEAN DEFAULT false, -- تطبيق تلقائي
    
    -- الحالة
    is_active BOOLEAN DEFAULT true,
    
    -- البيانات الوصفية
    metadata JSONB DEFAULT '{}',
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(store_id, code)
);

-- فهارس للبحث السريع
CREATE INDEX IF NOT EXISTS idx_coupons_store_id ON public.coupons(store_id);
CREATE INDEX IF NOT EXISTS idx_coupons_code ON public.coupons(code);
CREATE INDEX IF NOT EXISTS idx_coupons_is_active ON public.coupons(is_active);
CREATE INDEX IF NOT EXISTS idx_coupons_smart_type ON public.coupons(smart_type);
CREATE INDEX IF NOT EXISTS idx_coupons_expires_at ON public.coupons(expires_at);

-- ============================================================================
-- 2. جدول استخدامات الكوبون (Coupon Uses)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.coupon_uses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    coupon_id UUID NOT NULL REFERENCES public.coupons(id) ON DELETE CASCADE,
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    customer_id UUID, -- NULL للزوار
    order_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,
    
    -- تفاصيل الاستخدام
    discount_applied DECIMAL(10,2) NOT NULL,
    order_total DECIMAL(10,2) NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_coupon_uses_coupon_id ON public.coupon_uses(coupon_id);
CREATE INDEX IF NOT EXISTS idx_coupon_uses_customer_id ON public.coupon_uses(customer_id);
CREATE INDEX IF NOT EXISTS idx_coupon_uses_store_id ON public.coupon_uses(store_id);

-- ============================================================================
-- 3. RLS Policies
-- ============================================================================

-- تفعيل RLS
ALTER TABLE public.coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.coupon_uses ENABLE ROW LEVEL SECURITY;

-- Coupons: التاجر يدير كوبوناته
CREATE POLICY "Store owner can manage coupons" ON public.coupons
    FOR ALL USING (
        store_id IN (
            SELECT id FROM public.stores WHERE owner_id = auth.uid()
        )
    );

-- Public can view active coupons (for validation)
CREATE POLICY "Anyone can view active coupons by code" ON public.coupons
    FOR SELECT USING (is_active = true AND (expires_at IS NULL OR expires_at > NOW()));

CREATE POLICY "Service role full access to coupons" ON public.coupons
    FOR ALL USING (auth.role() = 'service_role');

-- Coupon Uses
CREATE POLICY "Store owner can view coupon uses" ON public.coupon_uses
    FOR SELECT USING (
        store_id IN (
            SELECT id FROM public.stores WHERE owner_id = auth.uid()
        )
    );

CREATE POLICY "Service role full access to coupon_uses" ON public.coupon_uses
    FOR ALL USING (auth.role() = 'service_role');

-- ============================================================================
-- 4. Functions للكوبونات الذكية
-- ============================================================================

-- دالة لإنشاء كوبون تلقائي للعملاء الجدد
CREATE OR REPLACE FUNCTION create_first_order_coupon(p_store_id UUID, p_discount_value DECIMAL)
RETURNS UUID AS $$
DECLARE
    v_coupon_id UUID;
    v_code VARCHAR(50);
BEGIN
    v_code := 'WELCOME' || UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 6));
    
    INSERT INTO public.coupons (
        store_id, code, title, title_ar, discount_type, discount_value,
        target_type, smart_type, is_active
    ) VALUES (
        p_store_id, v_code, 'Welcome Discount', 'خصم الترحيب',
        'percentage', p_discount_value, 'new_customers', 'first_order', true
    ) RETURNING id INTO v_coupon_id;
    
    RETURN v_coupon_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- دالة للتحقق من صلاحية الكوبون
CREATE OR REPLACE FUNCTION validate_coupon(
    p_coupon_code VARCHAR,
    p_store_id UUID,
    p_customer_id UUID,
    p_order_total DECIMAL
)
RETURNS JSONB AS $$
DECLARE
    v_coupon RECORD;
    v_customer_uses INTEGER;
    v_result JSONB;
BEGIN
    -- جلب الكوبون
    SELECT * INTO v_coupon FROM public.coupons
    WHERE code = p_coupon_code 
    AND store_id = p_store_id 
    AND is_active = true
    AND (expires_at IS NULL OR expires_at > NOW())
    AND (starts_at IS NULL OR starts_at <= NOW());
    
    IF v_coupon IS NULL THEN
        RETURN jsonb_build_object('valid', false, 'error', 'الكوبون غير صالح أو منتهي');
    END IF;
    
    -- التحقق من حد الاستخدام الكلي
    IF v_coupon.usage_limit IS NOT NULL AND v_coupon.times_used >= v_coupon.usage_limit THEN
        RETURN jsonb_build_object('valid', false, 'error', 'تم استنفاذ عدد استخدامات الكوبون');
    END IF;
    
    -- التحقق من حد الاستخدام للعميل
    IF p_customer_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_customer_uses FROM public.coupon_uses
        WHERE coupon_id = v_coupon.id AND customer_id = p_customer_id;
        
        IF v_customer_uses >= v_coupon.usage_per_customer THEN
            RETURN jsonb_build_object('valid', false, 'error', 'لقد استخدمت هذا الكوبون من قبل');
        END IF;
    END IF;
    
    -- التحقق من الحد الأدنى للطلب
    IF p_order_total < v_coupon.min_order_amount THEN
        RETURN jsonb_build_object(
            'valid', false, 
            'error', 'الحد الأدنى للطلب ' || v_coupon.min_order_amount || ' ر.س'
        );
    END IF;
    
    -- حساب الخصم
    v_result := jsonb_build_object(
        'valid', true,
        'coupon_id', v_coupon.id,
        'discount_type', v_coupon.discount_type,
        'discount_value', v_coupon.discount_value,
        'max_discount', v_coupon.max_discount
    );
    
    RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- تم الإنشاء بنجاح!
-- ============================================================================
