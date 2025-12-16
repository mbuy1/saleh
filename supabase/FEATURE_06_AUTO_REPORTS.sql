-- ============================================================================
-- MBUY Auto Reports - تقارير تلقائية
-- الميزة #6 من 23
-- تاريخ الإنشاء: ديسمبر 2025
-- ============================================================================

-- ============================================================================
-- 1. جدول إعدادات التقارير (Report Settings)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.report_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE UNIQUE,
    
    -- تفعيل التقارير التلقائية
    is_enabled BOOLEAN DEFAULT true,
    
    -- التقرير اليومي
    daily_report_enabled BOOLEAN DEFAULT true,
    daily_report_time TIME DEFAULT '08:00:00',
    
    -- التقرير الأسبوعي
    weekly_report_enabled BOOLEAN DEFAULT true,
    weekly_report_day INTEGER DEFAULT 0, -- 0 = الأحد
    weekly_report_time TIME DEFAULT '09:00:00',
    
    -- التقرير الشهري
    monthly_report_enabled BOOLEAN DEFAULT true,
    monthly_report_day INTEGER DEFAULT 1, -- اليوم من الشهر
    monthly_report_time TIME DEFAULT '10:00:00',
    
    -- قنوات الإرسال
    send_email BOOLEAN DEFAULT true,
    send_push BOOLEAN DEFAULT true,
    send_sms BOOLEAN DEFAULT false,
    
    -- البريد الإلكتروني للتقارير
    report_email VARCHAR(255),
    cc_emails TEXT[], -- نسخة إلى
    
    -- تنسيق التقرير
    report_format VARCHAR(20) DEFAULT 'detailed', -- summary, detailed, executive
    include_charts BOOLEAN DEFAULT true,
    include_recommendations BOOLEAN DEFAULT true,
    
    -- اللغة
    report_language VARCHAR(10) DEFAULT 'ar',
    
    -- التخصيص
    custom_metrics JSONB DEFAULT '[]',
    excluded_sections TEXT[],
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- 2. جدول التقارير المُنشأة (Generated Reports)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.generated_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    
    -- نوع التقرير
    report_type VARCHAR(20) NOT NULL, -- daily, weekly, monthly, custom
    report_period_start DATE NOT NULL,
    report_period_end DATE NOT NULL,
    
    -- العنوان
    title VARCHAR(255) NOT NULL,
    title_ar VARCHAR(255),
    
    -- ملخص سريع
    executive_summary TEXT,
    
    -- البيانات الأساسية
    total_revenue DECIMAL(12,2) DEFAULT 0,
    total_orders INTEGER DEFAULT 0,
    total_customers INTEGER DEFAULT 0,
    new_customers INTEGER DEFAULT 0,
    returning_customers INTEGER DEFAULT 0,
    avg_order_value DECIMAL(10,2) DEFAULT 0,
    
    -- المقارنة بالفترة السابقة
    revenue_change DECIMAL(5,2), -- نسبة التغير
    orders_change DECIMAL(5,2),
    customers_change DECIMAL(5,2),
    
    -- المنتجات الأكثر مبيعاً
    top_products JSONB DEFAULT '[]',
    
    -- تحليل العملاء
    customer_insights JSONB DEFAULT '{}',
    
    -- التوصيات
    recommendations JSONB DEFAULT '[]',
    
    -- المشاكل والتنبيهات
    alerts JSONB DEFAULT '[]',
    
    -- البيانات الكاملة للتقرير
    full_data JSONB DEFAULT '{}',
    
    -- حالة الإرسال
    is_sent BOOLEAN DEFAULT false,
    sent_at TIMESTAMPTZ,
    sent_to TEXT[],
    send_status VARCHAR(20) DEFAULT 'pending', -- pending, sent, failed
    send_error TEXT,
    
    -- ملف PDF
    pdf_url TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_generated_reports_store_id ON public.generated_reports(store_id);
CREATE INDEX IF NOT EXISTS idx_generated_reports_type ON public.generated_reports(report_type);
CREATE INDEX IF NOT EXISTS idx_generated_reports_period ON public.generated_reports(report_period_start, report_period_end);
CREATE INDEX IF NOT EXISTS idx_generated_reports_created ON public.generated_reports(created_at DESC);

-- ============================================================================
-- 3. جدول جدولة التقارير (Report Schedule)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.report_schedule (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    
    -- نوع التقرير
    report_type VARCHAR(20) NOT NULL, -- daily, weekly, monthly
    
    -- موعد التنفيذ التالي
    next_run_at TIMESTAMPTZ NOT NULL,
    
    -- آخر تنفيذ
    last_run_at TIMESTAMPTZ,
    last_run_status VARCHAR(20), -- success, failed
    last_run_error TEXT,
    
    -- حالة الجدولة
    is_active BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(store_id, report_type)
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_report_schedule_next_run ON public.report_schedule(next_run_at) WHERE is_active = true;

-- ============================================================================
-- 4. جدول قوالب التقارير (Report Templates)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.report_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID REFERENCES public.stores(id) ON DELETE CASCADE, -- NULL للقوالب العامة
    
    -- معلومات القالب
    name VARCHAR(100) NOT NULL,
    name_ar VARCHAR(100),
    description TEXT,
    
    -- نوع القالب
    template_type VARCHAR(20) NOT NULL, -- system, custom
    report_type VARCHAR(20) NOT NULL, -- daily, weekly, monthly, custom
    
    -- الأقسام المضمنة
    sections JSONB DEFAULT '["summary", "sales", "products", "customers", "recommendations"]',
    
    -- التنسيق
    format_settings JSONB DEFAULT '{}',
    
    -- الحالة
    is_default BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- 5. RLS Policies
-- ============================================================================

ALTER TABLE public.report_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.generated_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.report_schedule ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.report_templates ENABLE ROW LEVEL SECURITY;

-- Report Settings
DROP POLICY IF EXISTS "Store owner can manage report settings" ON public.report_settings;
DROP POLICY IF EXISTS "Service role full access to report_settings" ON public.report_settings;

CREATE POLICY "Store owner can manage report settings" ON public.report_settings
    FOR ALL USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to report_settings" ON public.report_settings
    FOR ALL USING (auth.role() = 'service_role');

-- Generated Reports
DROP POLICY IF EXISTS "Store owner can view own reports" ON public.generated_reports;
DROP POLICY IF EXISTS "Service role full access to generated_reports" ON public.generated_reports;

CREATE POLICY "Store owner can view own reports" ON public.generated_reports
    FOR SELECT USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to generated_reports" ON public.generated_reports
    FOR ALL USING (auth.role() = 'service_role');

-- Report Schedule
DROP POLICY IF EXISTS "Store owner can manage schedule" ON public.report_schedule;
DROP POLICY IF EXISTS "Service role full access to report_schedule" ON public.report_schedule;

CREATE POLICY "Store owner can manage schedule" ON public.report_schedule
    FOR ALL USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to report_schedule" ON public.report_schedule
    FOR ALL USING (auth.role() = 'service_role');

-- Report Templates
DROP POLICY IF EXISTS "Anyone can view system templates" ON public.report_templates;
DROP POLICY IF EXISTS "Store owner can manage own templates" ON public.report_templates;
DROP POLICY IF EXISTS "Service role full access to report_templates" ON public.report_templates;

CREATE POLICY "Anyone can view system templates" ON public.report_templates
    FOR SELECT USING (store_id IS NULL AND is_active = true);

CREATE POLICY "Store owner can manage own templates" ON public.report_templates
    FOR ALL USING (
        store_id IS NOT NULL AND 
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to report_templates" ON public.report_templates
    FOR ALL USING (auth.role() = 'service_role');

-- ============================================================================
-- 6. Functions
-- ============================================================================

-- دالة لإنشاء تقرير يومي
CREATE OR REPLACE FUNCTION generate_daily_report(p_store_id UUID)
RETURNS UUID AS $$
DECLARE
    v_report_id UUID;
    v_period_start DATE := CURRENT_DATE - 1;
    v_period_end DATE := CURRENT_DATE - 1;
    v_revenue DECIMAL(12,2);
    v_orders INTEGER;
    v_customers INTEGER;
    v_new_customers INTEGER;
    v_prev_revenue DECIMAL(12,2);
    v_prev_orders INTEGER;
    v_top_products JSONB;
BEGIN
    -- حساب إيرادات اليوم
    SELECT COALESCE(SUM(total_amount), 0)
    INTO v_revenue
    FROM public.orders
    WHERE store_id = p_store_id
      AND created_at::DATE = v_period_start
      AND status NOT IN ('cancelled', 'refunded');
    
    -- حساب عدد الطلبات
    SELECT COUNT(*)
    INTO v_orders
    FROM public.orders
    WHERE store_id = p_store_id
      AND created_at::DATE = v_period_start
      AND status NOT IN ('cancelled', 'refunded');
    
    -- حساب عدد العملاء
    SELECT COUNT(DISTINCT customer_id)
    INTO v_customers
    FROM public.orders
    WHERE store_id = p_store_id
      AND created_at::DATE = v_period_start;
    
    -- حساب العملاء الجدد
    SELECT COUNT(DISTINCT customer_id)
    INTO v_new_customers
    FROM public.orders
    WHERE store_id = p_store_id
      AND created_at::DATE = v_period_start
      AND customer_id NOT IN (
          SELECT DISTINCT customer_id FROM public.orders
          WHERE store_id = p_store_id
            AND created_at::DATE < v_period_start
            AND customer_id IS NOT NULL
      );
    
    -- بيانات اليوم السابق للمقارنة
    SELECT COALESCE(SUM(total_amount), 0)
    INTO v_prev_revenue
    FROM public.orders
    WHERE store_id = p_store_id
      AND created_at::DATE = v_period_start - 1
      AND status NOT IN ('cancelled', 'refunded');
    
    SELECT COUNT(*)
    INTO v_prev_orders
    FROM public.orders
    WHERE store_id = p_store_id
      AND created_at::DATE = v_period_start - 1
      AND status NOT IN ('cancelled', 'refunded');
    
    -- المنتجات الأكثر مبيعاً
    SELECT COALESCE(jsonb_agg(product_data), '[]'::jsonb)
    INTO v_top_products
    FROM (
        SELECT jsonb_build_object(
            'product_id', oi.product_id,
            'quantity', SUM(oi.quantity),
            'revenue', SUM(oi.total_price)
        ) as product_data
        FROM public.order_items oi
        JOIN public.orders o ON o.id = oi.order_id
        WHERE o.store_id = p_store_id
          AND o.created_at::DATE = v_period_start
        GROUP BY oi.product_id
        ORDER BY SUM(oi.quantity) DESC
        LIMIT 5
    ) top;
    
    -- إنشاء التقرير
    INSERT INTO public.generated_reports (
        store_id, report_type, report_period_start, report_period_end,
        title, title_ar,
        total_revenue, total_orders, total_customers, new_customers,
        returning_customers, avg_order_value,
        revenue_change, orders_change,
        top_products
    ) VALUES (
        p_store_id, 'daily', v_period_start, v_period_end,
        'Daily Report - ' || v_period_start::TEXT,
        'التقرير اليومي - ' || v_period_start::TEXT,
        v_revenue, v_orders, v_customers, v_new_customers,
        v_customers - v_new_customers,
        CASE WHEN v_orders > 0 THEN v_revenue / v_orders ELSE 0 END,
        CASE WHEN v_prev_revenue > 0 THEN ((v_revenue - v_prev_revenue) / v_prev_revenue * 100) ELSE 0 END,
        CASE WHEN v_prev_orders > 0 THEN ((v_orders - v_prev_orders)::DECIMAL / v_prev_orders * 100) ELSE 0 END,
        v_top_products
    ) RETURNING id INTO v_report_id;
    
    RETURN v_report_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- دالة لجدولة التقرير التالي
CREATE OR REPLACE FUNCTION schedule_next_report(
    p_store_id UUID,
    p_report_type VARCHAR
)
RETURNS TIMESTAMPTZ AS $$
DECLARE
    v_settings RECORD;
    v_next_run TIMESTAMPTZ;
BEGIN
    SELECT * INTO v_settings FROM public.report_settings WHERE store_id = p_store_id;
    
    IF NOT FOUND THEN
        RETURN NULL;
    END IF;
    
    CASE p_report_type
        WHEN 'daily' THEN
            v_next_run := (CURRENT_DATE + 1)::TIMESTAMPTZ + v_settings.daily_report_time;
        WHEN 'weekly' THEN
            -- حساب يوم الأسبوع التالي
            v_next_run := (CURRENT_DATE + (7 - EXTRACT(DOW FROM CURRENT_DATE)::INT + v_settings.weekly_report_day) % 7 + 7)::TIMESTAMPTZ + v_settings.weekly_report_time;
        WHEN 'monthly' THEN
            -- حساب اليوم من الشهر التالي
            v_next_run := (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month' + (v_settings.monthly_report_day - 1) * INTERVAL '1 day')::TIMESTAMPTZ + v_settings.monthly_report_time;
    END CASE;
    
    -- تحديث الجدولة
    INSERT INTO public.report_schedule (store_id, report_type, next_run_at)
    VALUES (p_store_id, p_report_type, v_next_run)
    ON CONFLICT (store_id, report_type) 
    DO UPDATE SET next_run_at = v_next_run, updated_at = NOW();
    
    RETURN v_next_run;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 7. Triggers
-- ============================================================================
CREATE OR REPLACE FUNCTION update_report_settings_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS report_settings_updated_at ON public.report_settings;
CREATE TRIGGER report_settings_updated_at
    BEFORE UPDATE ON public.report_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_report_settings_timestamp();

-- ============================================================================
-- 8. إدراج القوالب الافتراضية
-- ============================================================================
INSERT INTO public.report_templates (name, name_ar, template_type, report_type, is_default, sections)
VALUES 
    ('Daily Summary', 'ملخص يومي', 'system', 'daily', true, 
     '["summary", "sales", "top_products", "alerts"]'),
    ('Weekly Performance', 'الأداء الأسبوعي', 'system', 'weekly', true, 
     '["summary", "sales", "products", "customers", "trends", "recommendations"]'),
    ('Monthly Executive', 'التقرير الشهري التنفيذي', 'system', 'monthly', true, 
     '["executive_summary", "sales", "products", "customers", "growth", "goals", "recommendations"]')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- ✅ تم الإنشاء بنجاح!
-- ============================================================================
SELECT 'Auto Reports installed successfully!' as status;
