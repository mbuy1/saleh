-- ============================================================================
-- MBUY Coupons System - نظام الكوبونات الذكي (V2 - مع ALTER TABLE)
-- تاريخ الإنشاء: ديسمبر 2025
-- ============================================================================

-- ============================================================================
-- 1. إنشاء أو تعديل جدول الكوبونات (Coupons)
-- ============================================================================

-- إنشاء الجدول إذا لم يكن موجوداً
CREATE TABLE IF NOT EXISTS public.coupons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    code VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    discount_type VARCHAR(20) NOT NULL DEFAULT 'percentage',
    discount_value DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- إضافة الأعمدة المفقودة (لن تفشل إذا كانت موجودة)
DO $$ 
BEGIN
    -- title_ar
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'title_ar') THEN
        ALTER TABLE public.coupons ADD COLUMN title_ar VARCHAR(100);
    END IF;
    
    -- description
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'description') THEN
        ALTER TABLE public.coupons ADD COLUMN description TEXT;
    END IF;
    
    -- description_ar
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'description_ar') THEN
        ALTER TABLE public.coupons ADD COLUMN description_ar TEXT;
    END IF;
    
    -- max_discount
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'max_discount') THEN
        ALTER TABLE public.coupons ADD COLUMN max_discount DECIMAL(10,2);
    END IF;
    
    -- min_order_amount
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'min_order_amount') THEN
        ALTER TABLE public.coupons ADD COLUMN min_order_amount DECIMAL(10,2) DEFAULT 0;
    END IF;
    
    -- min_items
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'min_items') THEN
        ALTER TABLE public.coupons ADD COLUMN min_items INTEGER DEFAULT 0;
    END IF;
    
    -- usage_limit
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'usage_limit') THEN
        ALTER TABLE public.coupons ADD COLUMN usage_limit INTEGER;
    END IF;
    
    -- usage_per_customer
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'usage_per_customer') THEN
        ALTER TABLE public.coupons ADD COLUMN usage_per_customer INTEGER DEFAULT 1;
    END IF;
    
    -- times_used
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'times_used') THEN
        ALTER TABLE public.coupons ADD COLUMN times_used INTEGER DEFAULT 0;
    END IF;
    
    -- starts_at
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'starts_at') THEN
        ALTER TABLE public.coupons ADD COLUMN starts_at TIMESTAMPTZ DEFAULT NOW();
    END IF;
    
    -- expires_at
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'expires_at') THEN
        ALTER TABLE public.coupons ADD COLUMN expires_at TIMESTAMPTZ;
    END IF;
    
    -- target_type
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'target_type') THEN
        ALTER TABLE public.coupons ADD COLUMN target_type VARCHAR(30) DEFAULT 'all';
    END IF;
    
    -- target_customers
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'target_customers') THEN
        ALTER TABLE public.coupons ADD COLUMN target_customers UUID[];
    END IF;
    
    -- applicable_products
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'applicable_products') THEN
        ALTER TABLE public.coupons ADD COLUMN applicable_products UUID[];
    END IF;
    
    -- applicable_categories
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'applicable_categories') THEN
        ALTER TABLE public.coupons ADD COLUMN applicable_categories UUID[];
    END IF;
    
    -- smart_type (العمود المفقود)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'smart_type') THEN
        ALTER TABLE public.coupons ADD COLUMN smart_type VARCHAR(30);
    END IF;
    
    -- auto_apply
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'auto_apply') THEN
        ALTER TABLE public.coupons ADD COLUMN auto_apply BOOLEAN DEFAULT false;
    END IF;
    
    -- metadata
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'coupons' AND column_name = 'metadata') THEN
        ALTER TABLE public.coupons ADD COLUMN metadata JSONB DEFAULT '{}';
    END IF;
END $$;

-- إضافة UNIQUE constraint إذا لم يكن موجوداً
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'coupons_store_id_code_key'
    ) THEN
        ALTER TABLE public.coupons ADD CONSTRAINT coupons_store_id_code_key UNIQUE (store_id, code);
    END IF;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;

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
    customer_id UUID,
    order_id UUID,
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

-- حذف السياسات القديمة إذا وجدت
DROP POLICY IF EXISTS "Store owner can manage coupons" ON public.coupons;
DROP POLICY IF EXISTS "Anyone can view active coupons by code" ON public.coupons;
DROP POLICY IF EXISTS "Service role full access to coupons" ON public.coupons;
DROP POLICY IF EXISTS "Store owner can view coupon uses" ON public.coupon_uses;
DROP POLICY IF EXISTS "Service role full access to coupon_uses" ON public.coupon_uses;

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
-- ✅ تم الإنشاء بنجاح!
-- ============================================================================
SELECT 'Coupons system installed successfully!' as status;
