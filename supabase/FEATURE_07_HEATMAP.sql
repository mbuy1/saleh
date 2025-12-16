-- ============================================================================
-- MBUY Heatmap Analytics - خريطة حرارية
-- الميزة #7 من 23
-- تاريخ الإنشاء: ديسمبر 2025
-- ============================================================================

-- ============================================================================
-- 1. جدول أحداث التفاعل (Interaction Events)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.heatmap_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    
    -- معلومات الجلسة
    session_id VARCHAR(100) NOT NULL,
    visitor_id VARCHAR(100),
    user_id UUID REFERENCES public.user_profiles(id),
    
    -- نوع الحدث
    event_type VARCHAR(30) NOT NULL, -- click, scroll, hover, move, tap
    
    -- الصفحة
    page_url TEXT NOT NULL,
    page_path VARCHAR(255) NOT NULL,
    page_title VARCHAR(255),
    
    -- موقع التفاعل
    x_position INTEGER NOT NULL, -- موقع X بالبكسل
    y_position INTEGER NOT NULL, -- موقع Y بالبكسل
    x_percent DECIMAL(5,2), -- نسبة من عرض الصفحة
    y_percent DECIMAL(5,2), -- نسبة من ارتفاع الصفحة
    
    -- العنصر المستهدف
    element_tag VARCHAR(50),
    element_id VARCHAR(100),
    element_class VARCHAR(255),
    element_text VARCHAR(255),
    
    -- معلومات الشاشة
    viewport_width INTEGER,
    viewport_height INTEGER,
    page_height INTEGER,
    scroll_depth INTEGER,
    
    -- معلومات الجهاز
    device_type VARCHAR(20), -- mobile, tablet, desktop
    browser VARCHAR(50),
    os VARCHAR(50),
    
    -- التوقيت
    duration_ms INTEGER, -- مدة التفاعل (للـ hover)
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- فهارس للأداء
CREATE INDEX IF NOT EXISTS idx_heatmap_events_store_id ON public.heatmap_events(store_id);
CREATE INDEX IF NOT EXISTS idx_heatmap_events_page_path ON public.heatmap_events(page_path);
CREATE INDEX IF NOT EXISTS idx_heatmap_events_event_type ON public.heatmap_events(event_type);
CREATE INDEX IF NOT EXISTS idx_heatmap_events_timestamp ON public.heatmap_events(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_heatmap_events_session ON public.heatmap_events(session_id);

-- ============================================================================
-- 2. جدول ملخص الصفحات (Page Heatmap Summary)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.heatmap_page_summary (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    
    -- الصفحة
    page_path VARCHAR(255) NOT NULL,
    page_title VARCHAR(255),
    
    -- الفترة
    period_date DATE NOT NULL,
    
    -- إحصائيات النقرات
    total_clicks INTEGER DEFAULT 0,
    unique_visitors INTEGER DEFAULT 0,
    
    -- مناطق النقر الساخنة (أعلى 10)
    hot_zones JSONB DEFAULT '[]',
    
    -- متوسط عمق التمرير
    avg_scroll_depth DECIMAL(5,2) DEFAULT 0,
    max_scroll_depth DECIMAL(5,2) DEFAULT 0,
    
    -- العناصر الأكثر نقراً
    top_clicked_elements JSONB DEFAULT '[]',
    
    -- توزيع الأجهزة
    device_breakdown JSONB DEFAULT '{}',
    
    -- خريطة النقرات المجمعة (grid 20x20)
    click_grid JSONB DEFAULT '[]',
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(store_id, page_path, period_date)
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_heatmap_page_summary_store ON public.heatmap_page_summary(store_id);
CREATE INDEX IF NOT EXISTS idx_heatmap_page_summary_page ON public.heatmap_page_summary(page_path);
CREATE INDEX IF NOT EXISTS idx_heatmap_page_summary_date ON public.heatmap_page_summary(period_date DESC);

-- ============================================================================
-- 3. جدول تسجيلات الجلسات (Session Recordings)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.session_recordings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    
    -- معلومات الجلسة
    session_id VARCHAR(100) NOT NULL UNIQUE,
    visitor_id VARCHAR(100),
    user_id UUID REFERENCES public.user_profiles(id),
    
    -- معلومات الزائر
    device_type VARCHAR(20),
    browser VARCHAR(50),
    os VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(100),
    
    -- مدة الجلسة
    started_at TIMESTAMPTZ NOT NULL,
    ended_at TIMESTAMPTZ,
    duration_seconds INTEGER,
    
    -- الصفحات
    pages_visited INTEGER DEFAULT 0,
    page_views JSONB DEFAULT '[]',
    
    -- الأحداث
    total_events INTEGER DEFAULT 0,
    total_clicks INTEGER DEFAULT 0,
    
    -- حالة التسجيل
    status VARCHAR(20) DEFAULT 'recording', -- recording, completed, error
    
    -- بيانات التسجيل (مضغوطة)
    recording_data JSONB,
    recording_size_kb INTEGER,
    
    -- علامات
    is_starred BOOLEAN DEFAULT false,
    tags TEXT[],
    notes TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_session_recordings_store ON public.session_recordings(store_id);
CREATE INDEX IF NOT EXISTS idx_session_recordings_started ON public.session_recordings(started_at DESC);
CREATE INDEX IF NOT EXISTS idx_session_recordings_duration ON public.session_recordings(duration_seconds DESC);

-- ============================================================================
-- 4. جدول إعدادات الخريطة الحرارية
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.heatmap_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE UNIQUE,
    
    -- تفعيل
    is_enabled BOOLEAN DEFAULT true,
    track_clicks BOOLEAN DEFAULT true,
    track_moves BOOLEAN DEFAULT false, -- يستهلك موارد أكثر
    track_scrolls BOOLEAN DEFAULT true,
    record_sessions BOOLEAN DEFAULT false,
    
    -- التصفية
    exclude_admin BOOLEAN DEFAULT true,
    exclude_bots BOOLEAN DEFAULT true,
    sample_rate INTEGER DEFAULT 100, -- نسبة العينة (100 = الكل)
    
    -- الاحتفاظ بالبيانات
    data_retention_days INTEGER DEFAULT 30,
    max_sessions_stored INTEGER DEFAULT 1000,
    
    -- الصفحات المستهدفة
    tracked_pages TEXT[], -- NULL = كل الصفحات
    excluded_pages TEXT[],
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- 5. RLS Policies
-- ============================================================================

ALTER TABLE public.heatmap_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.heatmap_page_summary ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.session_recordings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.heatmap_settings ENABLE ROW LEVEL SECURITY;

-- Heatmap Events
DROP POLICY IF EXISTS "Store owner can view heatmap events" ON public.heatmap_events;
DROP POLICY IF EXISTS "Service role full access to heatmap_events" ON public.heatmap_events;

CREATE POLICY "Store owner can view heatmap events" ON public.heatmap_events
    FOR SELECT USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to heatmap_events" ON public.heatmap_events
    FOR ALL USING (auth.role() = 'service_role');

-- Page Summary
DROP POLICY IF EXISTS "Store owner can view page summary" ON public.heatmap_page_summary;
DROP POLICY IF EXISTS "Service role full access to heatmap_page_summary" ON public.heatmap_page_summary;

CREATE POLICY "Store owner can view page summary" ON public.heatmap_page_summary
    FOR SELECT USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to heatmap_page_summary" ON public.heatmap_page_summary
    FOR ALL USING (auth.role() = 'service_role');

-- Session Recordings
DROP POLICY IF EXISTS "Store owner can manage recordings" ON public.session_recordings;
DROP POLICY IF EXISTS "Service role full access to session_recordings" ON public.session_recordings;

CREATE POLICY "Store owner can manage recordings" ON public.session_recordings
    FOR ALL USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to session_recordings" ON public.session_recordings
    FOR ALL USING (auth.role() = 'service_role');

-- Heatmap Settings
DROP POLICY IF EXISTS "Store owner can manage heatmap settings" ON public.heatmap_settings;
DROP POLICY IF EXISTS "Service role full access to heatmap_settings" ON public.heatmap_settings;

CREATE POLICY "Store owner can manage heatmap settings" ON public.heatmap_settings
    FOR ALL USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Service role full access to heatmap_settings" ON public.heatmap_settings
    FOR ALL USING (auth.role() = 'service_role');

-- ============================================================================
-- 6. Functions
-- ============================================================================

-- دالة لتسجيل حدث تفاعل
CREATE OR REPLACE FUNCTION record_heatmap_event(
    p_store_id UUID,
    p_session_id VARCHAR,
    p_event_type VARCHAR,
    p_page_path VARCHAR,
    p_x INTEGER,
    p_y INTEGER,
    p_viewport_width INTEGER,
    p_viewport_height INTEGER,
    p_element_tag VARCHAR DEFAULT NULL,
    p_element_id VARCHAR DEFAULT NULL,
    p_device_type VARCHAR DEFAULT 'desktop'
)
RETURNS UUID AS $$
DECLARE
    v_event_id UUID;
    v_x_percent DECIMAL;
    v_y_percent DECIMAL;
BEGIN
    -- حساب النسب المئوية
    v_x_percent := CASE WHEN p_viewport_width > 0 THEN (p_x::DECIMAL / p_viewport_width) * 100 ELSE 0 END;
    v_y_percent := CASE WHEN p_viewport_height > 0 THEN (p_y::DECIMAL / p_viewport_height) * 100 ELSE 0 END;
    
    INSERT INTO public.heatmap_events (
        store_id, session_id, event_type, page_path,
        x_position, y_position, x_percent, y_percent,
        viewport_width, viewport_height,
        element_tag, element_id, device_type
    ) VALUES (
        p_store_id, p_session_id, p_event_type, p_page_path,
        p_x, p_y, v_x_percent, v_y_percent,
        p_viewport_width, p_viewport_height,
        p_element_tag, p_element_id, p_device_type
    ) RETURNING id INTO v_event_id;
    
    RETURN v_event_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- دالة لتجميع بيانات الخريطة الحرارية يومياً
CREATE OR REPLACE FUNCTION aggregate_daily_heatmap(
    p_store_id UUID,
    p_date DATE DEFAULT CURRENT_DATE - 1
)
RETURNS VOID AS $$
DECLARE
    v_page RECORD;
    v_hot_zones JSONB;
    v_top_elements JSONB;
    v_click_grid JSONB;
BEGIN
    -- لكل صفحة في المتجر
    FOR v_page IN 
        SELECT DISTINCT page_path, MAX(page_title) as page_title
        FROM public.heatmap_events
        WHERE store_id = p_store_id
          AND timestamp::DATE = p_date
        GROUP BY page_path
    LOOP
        -- تجميع المناطق الساخنة (clusters)
        SELECT COALESCE(jsonb_agg(zone), '[]'::jsonb)
        INTO v_hot_zones
        FROM (
            SELECT jsonb_build_object(
                'x', ROUND(AVG(x_percent)),
                'y', ROUND(AVG(y_percent)),
                'count', COUNT(*),
                'intensity', ROUND(COUNT(*)::DECIMAL / NULLIF(SUM(COUNT(*)) OVER(), 0) * 100, 1)
            ) as zone
            FROM public.heatmap_events
            WHERE store_id = p_store_id
              AND page_path = v_page.page_path
              AND timestamp::DATE = p_date
              AND event_type = 'click'
            GROUP BY 
                FLOOR(x_percent / 10), 
                FLOOR(y_percent / 10)
            ORDER BY COUNT(*) DESC
            LIMIT 10
        ) zones;
        
        -- العناصر الأكثر نقراً
        SELECT COALESCE(jsonb_agg(elem), '[]'::jsonb)
        INTO v_top_elements
        FROM (
            SELECT jsonb_build_object(
                'tag', element_tag,
                'id', element_id,
                'text', MAX(element_text),
                'clicks', COUNT(*)
            ) as elem
            FROM public.heatmap_events
            WHERE store_id = p_store_id
              AND page_path = v_page.page_path
              AND timestamp::DATE = p_date
              AND event_type = 'click'
              AND element_tag IS NOT NULL
            GROUP BY element_tag, element_id
            ORDER BY COUNT(*) DESC
            LIMIT 10
        ) elements;
        
        -- إدراج أو تحديث الملخص
        INSERT INTO public.heatmap_page_summary (
            store_id, page_path, page_title, period_date,
            total_clicks, unique_visitors,
            hot_zones, top_clicked_elements,
            avg_scroll_depth
        )
        SELECT 
            p_store_id,
            v_page.page_path,
            v_page.page_title,
            p_date,
            COUNT(*) FILTER (WHERE event_type = 'click'),
            COUNT(DISTINCT session_id),
            v_hot_zones,
            v_top_elements,
            AVG(scroll_depth) FILTER (WHERE event_type = 'scroll')
        FROM public.heatmap_events
        WHERE store_id = p_store_id
          AND page_path = v_page.page_path
          AND timestamp::DATE = p_date
        ON CONFLICT (store_id, page_path, period_date) 
        DO UPDATE SET
            total_clicks = EXCLUDED.total_clicks,
            unique_visitors = EXCLUDED.unique_visitors,
            hot_zones = EXCLUDED.hot_zones,
            top_clicked_elements = EXCLUDED.top_clicked_elements,
            avg_scroll_depth = EXCLUDED.avg_scroll_depth,
            updated_at = NOW();
    END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- دالة لتنظيف البيانات القديمة
CREATE OR REPLACE FUNCTION cleanup_old_heatmap_data()
RETURNS INTEGER AS $$
DECLARE
    v_deleted INTEGER := 0;
    v_store RECORD;
BEGIN
    FOR v_store IN 
        SELECT store_id, data_retention_days 
        FROM public.heatmap_settings 
        WHERE data_retention_days > 0
    LOOP
        DELETE FROM public.heatmap_events
        WHERE store_id = v_store.store_id
          AND created_at < NOW() - (v_store.data_retention_days || ' days')::INTERVAL;
        
        v_deleted := v_deleted + (SELECT COUNT(*) FROM public.heatmap_events WHERE store_id = v_store.store_id);
    END LOOP;
    
    RETURN v_deleted;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 7. Triggers
-- ============================================================================
CREATE OR REPLACE FUNCTION update_heatmap_settings_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS heatmap_settings_updated_at ON public.heatmap_settings;
CREATE TRIGGER heatmap_settings_updated_at
    BEFORE UPDATE ON public.heatmap_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_heatmap_settings_timestamp();

-- ============================================================================
-- ✅ تم الإنشاء بنجاح!
-- ============================================================================
SELECT 'Heatmap Analytics installed successfully!' as status;
