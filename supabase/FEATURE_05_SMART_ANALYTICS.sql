-- ============================================================================
-- MBUY Smart Analytics Dashboard - لوحة تحكم ذكية
-- الميزة #5 من 23
-- تاريخ الإنشاء: ديسمبر 2025
-- ============================================================================

-- ============================================================================
-- 1. جدول ملخصات التحليلات اليومية (Daily Analytics Summary)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.analytics_daily (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    
    -- المبيعات
    total_revenue DECIMAL(12,2) DEFAULT 0,
    total_orders INTEGER DEFAULT 0,
    average_order_value DECIMAL(10,2) DEFAULT 0,
    
    -- المنتجات
    products_sold INTEGER DEFAULT 0,
    unique_products_sold INTEGER DEFAULT 0,
    top_product_id UUID,
    top_product_sales DECIMAL(10,2) DEFAULT 0,
    
    -- العملاء
    total_customers INTEGER DEFAULT 0,
    new_customers INTEGER DEFAULT 0,
    returning_customers INTEGER DEFAULT 0,
    
    -- الزيارات
    page_views INTEGER DEFAULT 0,
    unique_visitors INTEGER DEFAULT 0,
    bounce_rate DECIMAL(5,2) DEFAULT 0,
    avg_session_duration INTEGER DEFAULT 0, -- بالثواني
    
    -- التحويل
    conversion_rate DECIMAL(5,2) DEFAULT 0,
    cart_abandonment_rate DECIMAL(5,2) DEFAULT 0,
    
    -- المصادر
    traffic_sources JSONB DEFAULT '{}',
    device_breakdown JSONB DEFAULT '{}',
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(store_id, date)
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_analytics_daily_store_date ON public.analytics_daily(store_id, date DESC);

-- ============================================================================
-- 2. جدول التحليلات بالساعة (Hourly Analytics)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.analytics_hourly (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    hour INTEGER NOT NULL CHECK (hour >= 0 AND hour <= 23),
    
    revenue DECIMAL(10,2) DEFAULT 0,
    orders_count INTEGER DEFAULT 0,
    visitors INTEGER DEFAULT 0,
    page_views INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(store_id, date, hour)
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_analytics_hourly_store ON public.analytics_hourly(store_id, date, hour);

-- ============================================================================
-- 3. جدول أداء المنتجات (Product Performance)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.product_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    
    -- المبيعات
    units_sold INTEGER DEFAULT 0,
    revenue DECIMAL(10,2) DEFAULT 0,
    
    -- المشاهدات
    views INTEGER DEFAULT 0,
    unique_views INTEGER DEFAULT 0,
    
    -- التفاعل
    add_to_cart INTEGER DEFAULT 0,
    wishlist_adds INTEGER DEFAULT 0,
    
    -- التحويل
    view_to_cart_rate DECIMAL(5,2) DEFAULT 0,
    cart_to_purchase_rate DECIMAL(5,2) DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(store_id, product_id, date)
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_product_analytics_store ON public.product_analytics(store_id, date);
CREATE INDEX IF NOT EXISTS idx_product_analytics_product ON public.product_analytics(product_id, date);

-- ============================================================================
-- 4. جدول تحليلات العملاء (Customer Analytics)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.customer_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    
    -- القيمة
    total_spent DECIMAL(12,2) DEFAULT 0,
    total_orders INTEGER DEFAULT 0,
    average_order_value DECIMAL(10,2) DEFAULT 0,
    
    -- التصنيف
    customer_segment VARCHAR(30) DEFAULT 'new', -- new, active, loyal, vip, at_risk, churned
    lifetime_value DECIMAL(12,2) DEFAULT 0,
    
    -- السلوك
    first_order_at TIMESTAMPTZ,
    last_order_at TIMESTAMPTZ,
    days_since_last_order INTEGER,
    purchase_frequency DECIMAL(5,2) DEFAULT 0, -- طلبات/شهر
    
    -- التفضيلات
    favorite_categories JSONB DEFAULT '[]',
    favorite_products JSONB DEFAULT '[]',
    preferred_payment_method VARCHAR(50),
    
    -- التفاعل
    email_open_rate DECIMAL(5,2) DEFAULT 0,
    notification_click_rate DECIMAL(5,2) DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(store_id, customer_id)
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_customer_analytics_store ON public.customer_analytics(store_id);
CREATE INDEX IF NOT EXISTS idx_customer_analytics_segment ON public.customer_analytics(customer_segment);

-- ============================================================================
-- 5. جدول الرؤى الذكية (Smart Insights)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.smart_insights (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    
    -- نوع الرؤية
    insight_type VARCHAR(50) NOT NULL, -- sales_trend, product_opportunity, customer_risk, etc.
    priority VARCHAR(20) DEFAULT 'medium', -- low, medium, high, critical
    
    -- المحتوى
    title VARCHAR(200) NOT NULL,
    title_ar VARCHAR(200),
    description TEXT,
    description_ar TEXT,
    
    -- البيانات
    data JSONB DEFAULT '{}',
    metric_value DECIMAL(15,2),
    metric_change DECIMAL(10,2), -- نسبة التغيير
    comparison_period VARCHAR(20), -- day, week, month
    
    -- التوصية
    recommendation TEXT,
    recommendation_ar TEXT,
    action_url VARCHAR(500),
    action_type VARCHAR(50), -- view_report, create_promotion, contact_customer, etc.
    
    -- الحالة
    is_read BOOLEAN DEFAULT false,
    is_dismissed BOOLEAN DEFAULT false,
    is_actioned BOOLEAN DEFAULT false,
    
    -- التوقيت
    valid_until TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_smart_insights_store ON public.smart_insights(store_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_smart_insights_type ON public.smart_insights(insight_type);
CREATE INDEX IF NOT EXISTS idx_smart_insights_priority ON public.smart_insights(priority);

-- ============================================================================
-- 6. جدول الأهداف (Goals/KPIs)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.store_goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    
    -- نوع الهدف
    goal_type VARCHAR(50) NOT NULL, -- revenue, orders, customers, conversion, etc.
    period VARCHAR(20) NOT NULL, -- daily, weekly, monthly, yearly
    
    -- القيم
    target_value DECIMAL(15,2) NOT NULL,
    current_value DECIMAL(15,2) DEFAULT 0,
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- التفاصيل
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    
    -- الحالة
    status VARCHAR(20) DEFAULT 'in_progress', -- in_progress, achieved, failed
    achieved_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_store_goals_store ON public.store_goals(store_id);

-- ============================================================================
-- 7. RLS Policies
-- ============================================================================

ALTER TABLE public.analytics_daily ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.analytics_hourly ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.product_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customer_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.smart_insights ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.store_goals ENABLE ROW LEVEL SECURITY;

-- Analytics Daily
DROP POLICY IF EXISTS "Store owner can view analytics" ON public.analytics_daily;
DROP POLICY IF EXISTS "Service role full access to analytics_daily" ON public.analytics_daily;

CREATE POLICY "Store owner can view analytics" ON public.analytics_daily
    FOR SELECT USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to analytics_daily" ON public.analytics_daily
    FOR ALL USING (auth.role() = 'service_role');

-- Analytics Hourly
DROP POLICY IF EXISTS "Store owner can view hourly analytics" ON public.analytics_hourly;
DROP POLICY IF EXISTS "Service role full access to analytics_hourly" ON public.analytics_hourly;

CREATE POLICY "Store owner can view hourly analytics" ON public.analytics_hourly
    FOR SELECT USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to analytics_hourly" ON public.analytics_hourly
    FOR ALL USING (auth.role() = 'service_role');

-- Product Analytics
DROP POLICY IF EXISTS "Store owner can view product analytics" ON public.product_analytics;
DROP POLICY IF EXISTS "Service role full access to product_analytics" ON public.product_analytics;

CREATE POLICY "Store owner can view product analytics" ON public.product_analytics
    FOR SELECT USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to product_analytics" ON public.product_analytics
    FOR ALL USING (auth.role() = 'service_role');

-- Customer Analytics
DROP POLICY IF EXISTS "Store owner can view customer analytics" ON public.customer_analytics;
DROP POLICY IF EXISTS "Service role full access to customer_analytics" ON public.customer_analytics;

CREATE POLICY "Store owner can view customer analytics" ON public.customer_analytics
    FOR SELECT USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to customer_analytics" ON public.customer_analytics
    FOR ALL USING (auth.role() = 'service_role');

-- Smart Insights
DROP POLICY IF EXISTS "Store owner can manage insights" ON public.smart_insights;
DROP POLICY IF EXISTS "Service role full access to smart_insights" ON public.smart_insights;

CREATE POLICY "Store owner can manage insights" ON public.smart_insights
    FOR ALL USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to smart_insights" ON public.smart_insights
    FOR ALL USING (auth.role() = 'service_role');

-- Store Goals
DROP POLICY IF EXISTS "Store owner can manage goals" ON public.store_goals;
DROP POLICY IF EXISTS "Service role full access to store_goals" ON public.store_goals;

CREATE POLICY "Store owner can manage goals" ON public.store_goals
    FOR ALL USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to store_goals" ON public.store_goals
    FOR ALL USING (auth.role() = 'service_role');

-- ============================================================================
-- 8. Functions
-- ============================================================================

-- دالة لتجميع التحليلات اليومية
CREATE OR REPLACE FUNCTION aggregate_daily_analytics(p_store_id UUID, p_date DATE)
RETURNS void AS $$
DECLARE
    v_stats RECORD;
BEGIN
    -- حساب الإحصائيات من الطلبات
    SELECT 
        COALESCE(COUNT(*), 0) as total_orders,
        COALESCE(SUM(total_amount), 0) as total_revenue,
        COALESCE(AVG(total_amount), 0) as avg_order_value,
        COALESCE(COUNT(DISTINCT customer_id), 0) as total_customers
    INTO v_stats
    FROM public.orders
    WHERE store_id = p_store_id
    AND DATE(created_at) = p_date
    AND status NOT IN ('cancelled', 'refunded');

    -- إدراج أو تحديث السجل
    INSERT INTO public.analytics_daily (
        store_id, date,
        total_revenue, total_orders, average_order_value, total_customers
    ) VALUES (
        p_store_id, p_date,
        v_stats.total_revenue, v_stats.total_orders, v_stats.avg_order_value, v_stats.total_customers
    )
    ON CONFLICT (store_id, date)
    DO UPDATE SET
        total_revenue = v_stats.total_revenue,
        total_orders = v_stats.total_orders,
        average_order_value = v_stats.avg_order_value,
        total_customers = v_stats.total_customers,
        updated_at = NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- دالة لإنشاء رؤية ذكية
CREATE OR REPLACE FUNCTION create_smart_insight(
    p_store_id UUID,
    p_type VARCHAR,
    p_priority VARCHAR,
    p_title VARCHAR,
    p_title_ar VARCHAR,
    p_description TEXT,
    p_description_ar TEXT,
    p_data JSONB,
    p_recommendation TEXT DEFAULT NULL,
    p_recommendation_ar TEXT DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    v_insight_id UUID;
BEGIN
    INSERT INTO public.smart_insights (
        store_id, insight_type, priority,
        title, title_ar, description, description_ar,
        data, recommendation, recommendation_ar,
        valid_until
    ) VALUES (
        p_store_id, p_type, p_priority,
        p_title, p_title_ar, p_description, p_description_ar,
        p_data, p_recommendation, p_recommendation_ar,
        NOW() + INTERVAL '7 days'
    ) RETURNING id INTO v_insight_id;
    
    RETURN v_insight_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- دالة لتحديث تصنيف العميل
CREATE OR REPLACE FUNCTION update_customer_segment(p_store_id UUID, p_customer_id UUID)
RETURNS void AS $$
DECLARE
    v_stats RECORD;
    v_segment VARCHAR(30);
BEGIN
    -- جلب إحصائيات العميل
    SELECT 
        COALESCE(SUM(total_amount), 0) as total_spent,
        COALESCE(COUNT(*), 0) as total_orders,
        MAX(created_at) as last_order,
        MIN(created_at) as first_order
    INTO v_stats
    FROM public.orders
    WHERE store_id = p_store_id AND customer_id = p_customer_id
    AND status NOT IN ('cancelled', 'refunded');
    
    -- تحديد التصنيف
    IF v_stats.total_orders = 0 THEN
        v_segment := 'new';
    ELSIF v_stats.last_order < NOW() - INTERVAL '90 days' THEN
        v_segment := 'churned';
    ELSIF v_stats.last_order < NOW() - INTERVAL '60 days' THEN
        v_segment := 'at_risk';
    ELSIF v_stats.total_spent > 5000 OR v_stats.total_orders > 20 THEN
        v_segment := 'vip';
    ELSIF v_stats.total_orders > 5 THEN
        v_segment := 'loyal';
    ELSE
        v_segment := 'active';
    END IF;
    
    -- تحديث أو إنشاء سجل التحليلات
    INSERT INTO public.customer_analytics (
        store_id, customer_id,
        total_spent, total_orders, customer_segment,
        first_order_at, last_order_at,
        days_since_last_order
    ) VALUES (
        p_store_id, p_customer_id,
        v_stats.total_spent, v_stats.total_orders, v_segment,
        v_stats.first_order, v_stats.last_order,
        EXTRACT(DAY FROM NOW() - v_stats.last_order)::INTEGER
    )
    ON CONFLICT (store_id, customer_id)
    DO UPDATE SET
        total_spent = v_stats.total_spent,
        total_orders = v_stats.total_orders,
        customer_segment = v_segment,
        last_order_at = v_stats.last_order,
        days_since_last_order = EXTRACT(DAY FROM NOW() - v_stats.last_order)::INTEGER,
        updated_at = NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- ✅ تم الإنشاء بنجاح!
-- ============================================================================
SELECT 'Smart Analytics Dashboard installed successfully!' as status;
