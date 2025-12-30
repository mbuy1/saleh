-- =====================================================
-- MBUY Studio Tables Migration
-- استوديو المحتوى الذكي - جداول قاعدة البيانات
-- =====================================================

-- 1. جدول رصيد المستخدم (Credits)
CREATE TABLE IF NOT EXISTS user_credits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    store_id UUID REFERENCES stores(id) ON DELETE SET NULL,
    balance INTEGER NOT NULL DEFAULT 100, -- رصيد افتراضي 100 credit
    total_earned INTEGER NOT NULL DEFAULT 100,
    total_spent INTEGER NOT NULL DEFAULT 0,
    last_free_refill TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id)
);

-- 2. جدول القوالب (Templates)
CREATE TABLE IF NOT EXISTS studio_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    description TEXT,
    description_ar TEXT,
    category VARCHAR(50) NOT NULL DEFAULT 'general', -- product_ad, ugc, promo, story
    thumbnail_url TEXT,
    preview_video_url TEXT,
    scenes_config JSONB NOT NULL DEFAULT '[]', -- تكوين المشاهد الافتراضية
    duration_seconds INTEGER NOT NULL DEFAULT 30,
    aspect_ratio VARCHAR(20) NOT NULL DEFAULT '9:16', -- 9:16, 16:9, 1:1
    is_premium BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    usage_count INTEGER NOT NULL DEFAULT 0,
    credits_cost INTEGER NOT NULL DEFAULT 10,
    tags TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. جدول المشاريع (Projects)
CREATE TABLE IF NOT EXISTS studio_projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    store_id UUID REFERENCES stores(id) ON DELETE SET NULL,
    template_id UUID REFERENCES studio_templates(id) ON DELETE SET NULL,
    product_id UUID REFERENCES products(id) ON DELETE SET NULL,
    
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'draft', -- draft, generating, processing, ready, failed
    
    -- بيانات المنتج المستخدمة
    product_data JSONB DEFAULT '{}', -- name, description, price, images
    
    -- السيناريو المولد
    script_data JSONB DEFAULT '{}', -- generated script with scenes
    
    -- إعدادات المشروع
    settings JSONB DEFAULT '{
        "aspect_ratio": "9:16",
        "duration": 30,
        "language": "ar",
        "voice_id": null,
        "music_id": null,
        "logo_url": null,
        "brand_color": "#000000"
    }',
    
    -- معلومات التصدير
    output_url TEXT,
    output_thumbnail_url TEXT,
    output_duration INTEGER,
    output_size_bytes BIGINT,
    
    -- التكلفة
    credits_used INTEGER NOT NULL DEFAULT 0,
    
    -- التتبع
    error_message TEXT,
    progress INTEGER DEFAULT 0, -- 0-100
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. جدول المشاهد (Scenes)
CREATE TABLE IF NOT EXISTS studio_scenes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES studio_projects(id) ON DELETE CASCADE,
    
    order_index INTEGER NOT NULL DEFAULT 0,
    scene_type VARCHAR(50) NOT NULL DEFAULT 'image', -- image, video, ugc, text, transition
    
    -- المحتوى
    prompt TEXT, -- وصف المشهد لتوليد AI
    script_text TEXT, -- النص المنطوق
    duration_ms INTEGER NOT NULL DEFAULT 5000,
    
    -- الأصول المولدة
    generated_image_url TEXT,
    generated_video_url TEXT,
    generated_audio_url TEXT,
    
    -- الحالة
    status VARCHAR(50) NOT NULL DEFAULT 'pending', -- pending, generating, ready, failed
    error_message TEXT,
    
    -- الطبقات (النصوص والعناصر)
    layers JSONB DEFAULT '[]',
    
    -- التأثيرات
    transition_in VARCHAR(50) DEFAULT 'fade',
    transition_out VARCHAR(50) DEFAULT 'fade',
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 5. جدول الأصول (Assets)
CREATE TABLE IF NOT EXISTS studio_assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID REFERENCES studio_projects(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    store_id UUID REFERENCES stores(id) ON DELETE SET NULL,
    
    name VARCHAR(255),
    asset_type VARCHAR(50) NOT NULL, -- image, video, audio, font, logo
    source VARCHAR(50) NOT NULL DEFAULT 'uploaded', -- uploaded, ai_generated, template, product
    
    url TEXT NOT NULL,
    thumbnail_url TEXT,
    
    -- معلومات الملف
    file_size_bytes BIGINT,
    mime_type VARCHAR(100),
    duration_ms INTEGER, -- للفيديو والصوت
    width INTEGER, -- للصور والفيديو
    height INTEGER,
    
    -- البيانات الوصفية
    metadata JSONB DEFAULT '{}',
    
    -- AI Generation info
    ai_prompt TEXT,
    ai_model VARCHAR(100),
    ai_cost_credits INTEGER,
    
    is_favorite BOOLEAN DEFAULT false,
    usage_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 6. جدول سجل الرندر (Render Jobs)
CREATE TABLE IF NOT EXISTS studio_renders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES studio_projects(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    
    status VARCHAR(50) NOT NULL DEFAULT 'queued', -- queued, processing, completed, failed
    progress INTEGER DEFAULT 0, -- 0-100
    
    -- الإعدادات
    format VARCHAR(20) NOT NULL DEFAULT 'mp4',
    resolution VARCHAR(20) NOT NULL DEFAULT '1080p', -- 720p, 1080p, 4k
    quality VARCHAR(20) NOT NULL DEFAULT 'high', -- low, medium, high
    
    -- النتيجة
    output_url TEXT,
    output_size_bytes BIGINT,
    render_time_seconds INTEGER,
    
    -- التكلفة
    credits_cost INTEGER NOT NULL DEFAULT 5,
    
    -- الأخطاء
    error_message TEXT,
    error_code VARCHAR(50),
    retry_count INTEGER DEFAULT 0,
    
    -- التوقيت
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 7. جدول سجل استخدام الـ API
CREATE TABLE IF NOT EXISTS studio_api_usage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    project_id UUID REFERENCES studio_projects(id) ON DELETE SET NULL,
    
    api_provider VARCHAR(50) NOT NULL, -- openrouter, fal, elevenlabs, did
    api_endpoint VARCHAR(255),
    
    request_data JSONB,
    response_status INTEGER,
    
    credits_cost INTEGER NOT NULL DEFAULT 0,
    actual_cost_usd DECIMAL(10, 6),
    
    processing_time_ms INTEGER,
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 8. جدول طلبات الباقات (Package Orders)
CREATE TABLE IF NOT EXISTS studio_package_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    store_id UUID REFERENCES stores(id) ON DELETE SET NULL,
    
    package_type VARCHAR(50) NOT NULL, -- motion_graphics, vlogs, ad_campaigns, ugc_video, social_ads, brand_identity
    status VARCHAR(50) NOT NULL DEFAULT 'pending', -- pending, processing, completed, failed, cancelled
    
    -- بيانات المدخلات
    product_data JSONB NOT NULL DEFAULT '{}', -- اسم المنتج، وصفه، صوره، سعره
    brand_data JSONB DEFAULT '{}', -- الشعار، الألوان، الخطوط
    preferences JSONB DEFAULT '{}', -- تفضيلات إضافية
    
    -- المخرجات
    deliverables JSONB DEFAULT '[]', -- قائمة المخرجات المُنشأة
    
    -- التكلفة
    credits_cost INTEGER NOT NULL DEFAULT 0,
    credits_refunded INTEGER DEFAULT 0,
    
    -- التتبع
    progress INTEGER DEFAULT 0, -- 0-100
    current_step VARCHAR(100),
    error_message TEXT,
    
    -- التوقيت
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 9. جدول مخرجات الباقات (Package Deliverables)
CREATE TABLE IF NOT EXISTS studio_package_deliverables (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES studio_package_orders(id) ON DELETE CASCADE,
    
    deliverable_type VARCHAR(50) NOT NULL, -- video, image, logo, banner, landing_page
    name VARCHAR(255),
    name_ar VARCHAR(255),
    description TEXT,
    
    -- الملف
    url TEXT NOT NULL,
    thumbnail_url TEXT,
    file_size_bytes BIGINT,
    mime_type VARCHAR(100),
    
    -- للفيديو
    duration_seconds INTEGER,
    resolution VARCHAR(20),
    
    -- للصور
    width INTEGER,
    height INTEGER,
    
    -- الحالة
    is_applied BOOLEAN DEFAULT false, -- هل تم تطبيقه على المتجر
    applied_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 10. جدول سجل العمليات (Tool Usage Log)
CREATE TABLE IF NOT EXISTS studio_tool_usage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    store_id UUID REFERENCES stores(id) ON DELETE SET NULL,
    
    tool_type VARCHAR(50) NOT NULL, -- edit أو generate
    tool_name VARCHAR(50) NOT NULL, -- اسم الأداة
    
    -- المدخلات والمخرجات
    input_data JSONB DEFAULT '{}',
    output_url TEXT,
    output_data JSONB DEFAULT '{}',
    
    -- التكلفة والوقت
    credits_cost INTEGER NOT NULL DEFAULT 0,
    processing_time_ms INTEGER,
    
    -- الحالة
    status VARCHAR(50) NOT NULL DEFAULT 'completed', -- pending, processing, completed, failed
    error_message TEXT,
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================================
-- INDEXES
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_user_credits_user_id ON user_credits(user_id);
CREATE INDEX IF NOT EXISTS idx_studio_templates_category ON studio_templates(category);
CREATE INDEX IF NOT EXISTS idx_studio_templates_active ON studio_templates(is_active);
CREATE INDEX IF NOT EXISTS idx_studio_projects_user_id ON studio_projects(user_id);
CREATE INDEX IF NOT EXISTS idx_studio_projects_store_id ON studio_projects(store_id);
CREATE INDEX IF NOT EXISTS idx_studio_projects_status ON studio_projects(status);
CREATE INDEX IF NOT EXISTS idx_studio_scenes_project_id ON studio_scenes(project_id);
CREATE INDEX IF NOT EXISTS idx_studio_scenes_order ON studio_scenes(project_id, order_index);
CREATE INDEX IF NOT EXISTS idx_studio_assets_user_id ON studio_assets(user_id);
CREATE INDEX IF NOT EXISTS idx_studio_assets_project_id ON studio_assets(project_id);
CREATE INDEX IF NOT EXISTS idx_studio_assets_type ON studio_assets(asset_type);
CREATE INDEX IF NOT EXISTS idx_studio_renders_project_id ON studio_renders(project_id);
CREATE INDEX IF NOT EXISTS idx_studio_renders_status ON studio_renders(status);
CREATE INDEX IF NOT EXISTS idx_studio_api_usage_user_id ON studio_api_usage(user_id);
CREATE INDEX IF NOT EXISTS idx_studio_api_usage_created_at ON studio_api_usage(created_at);
CREATE INDEX IF NOT EXISTS idx_studio_package_orders_user_id ON studio_package_orders(user_id);
CREATE INDEX IF NOT EXISTS idx_studio_package_orders_store_id ON studio_package_orders(store_id);
CREATE INDEX IF NOT EXISTS idx_studio_package_orders_status ON studio_package_orders(status);
CREATE INDEX IF NOT EXISTS idx_studio_package_deliverables_order_id ON studio_package_deliverables(order_id);
CREATE INDEX IF NOT EXISTS idx_studio_tool_usage_user_id ON studio_tool_usage(user_id);
CREATE INDEX IF NOT EXISTS idx_studio_tool_usage_created_at ON studio_tool_usage(created_at);

-- =====================================================
-- RLS POLICIES
-- =====================================================

-- تفعيل RLS
ALTER TABLE user_credits ENABLE ROW LEVEL SECURITY;
ALTER TABLE studio_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE studio_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE studio_scenes ENABLE ROW LEVEL SECURITY;
ALTER TABLE studio_assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE studio_renders ENABLE ROW LEVEL SECURITY;
ALTER TABLE studio_api_usage ENABLE ROW LEVEL SECURITY;
ALTER TABLE studio_package_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE studio_package_deliverables ENABLE ROW LEVEL SECURITY;
ALTER TABLE studio_tool_usage ENABLE ROW LEVEL SECURITY;

-- حذف السياسات القديمة إن وجدت
DROP POLICY IF EXISTS "Users can view own credits" ON user_credits;
DROP POLICY IF EXISTS "Users can update own credits" ON user_credits;
DROP POLICY IF EXISTS "Anyone can view active templates" ON studio_templates;
DROP POLICY IF EXISTS "Users can view own projects" ON studio_projects;
DROP POLICY IF EXISTS "Users can create own projects" ON studio_projects;
DROP POLICY IF EXISTS "Users can update own projects" ON studio_projects;
DROP POLICY IF EXISTS "Users can delete own projects" ON studio_projects;
DROP POLICY IF EXISTS "Users can view own scenes" ON studio_scenes;
DROP POLICY IF EXISTS "Users can manage own scenes" ON studio_scenes;
DROP POLICY IF EXISTS "Users can view own assets" ON studio_assets;
DROP POLICY IF EXISTS "Users can create own assets" ON studio_assets;
DROP POLICY IF EXISTS "Users can update own assets" ON studio_assets;
DROP POLICY IF EXISTS "Users can delete own assets" ON studio_assets;
DROP POLICY IF EXISTS "Users can view own renders" ON studio_renders;
DROP POLICY IF EXISTS "Users can create own renders" ON studio_renders;
DROP POLICY IF EXISTS "Users can view own api usage" ON studio_api_usage;
DROP POLICY IF EXISTS "Users can view own package orders" ON studio_package_orders;
DROP POLICY IF EXISTS "Users can create own package orders" ON studio_package_orders;
DROP POLICY IF EXISTS "Users can update own package orders" ON studio_package_orders;
DROP POLICY IF EXISTS "Users can view own deliverables" ON studio_package_deliverables;
DROP POLICY IF EXISTS "Users can view own tool usage" ON studio_tool_usage;
DROP POLICY IF EXISTS "Users can create own tool usage" ON studio_tool_usage;

-- سياسات user_credits
CREATE POLICY "Users can view own credits" ON user_credits
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own credits" ON user_credits
    FOR UPDATE USING (auth.uid() = user_id);

-- سياسات studio_templates (الجميع يمكنهم القراءة)
CREATE POLICY "Anyone can view active templates" ON studio_templates
    FOR SELECT USING (is_active = true);

-- سياسات studio_projects
CREATE POLICY "Users can view own projects" ON studio_projects
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own projects" ON studio_projects
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own projects" ON studio_projects
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own projects" ON studio_projects
    FOR DELETE USING (auth.uid() = user_id);

-- سياسات studio_scenes
CREATE POLICY "Users can view own scenes" ON studio_scenes
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM studio_projects 
            WHERE id = studio_scenes.project_id 
            AND user_id = auth.uid()
        )
    );

CREATE POLICY "Users can manage own scenes" ON studio_scenes
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM studio_projects 
            WHERE id = studio_scenes.project_id 
            AND user_id = auth.uid()
        )
    );

-- سياسات studio_assets
CREATE POLICY "Users can view own assets" ON studio_assets
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own assets" ON studio_assets
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own assets" ON studio_assets
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own assets" ON studio_assets
    FOR DELETE USING (auth.uid() = user_id);

-- سياسات studio_renders
CREATE POLICY "Users can view own renders" ON studio_renders
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own renders" ON studio_renders
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- سياسات studio_api_usage
CREATE POLICY "Users can view own api usage" ON studio_api_usage
    FOR SELECT USING (auth.uid() = user_id);

-- سياسات studio_package_orders
CREATE POLICY "Users can view own package orders" ON studio_package_orders
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own package orders" ON studio_package_orders
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own package orders" ON studio_package_orders
    FOR UPDATE USING (auth.uid() = user_id);

-- سياسات studio_package_deliverables
CREATE POLICY "Users can view own deliverables" ON studio_package_deliverables
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM studio_package_orders 
            WHERE id = studio_package_deliverables.order_id 
            AND user_id = auth.uid()
        )
    );

-- سياسات studio_tool_usage
CREATE POLICY "Users can view own tool usage" ON studio_tool_usage
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own tool usage" ON studio_tool_usage
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- =====================================================
-- FUNCTIONS
-- =====================================================

-- دالة خصم الرصيد
CREATE OR REPLACE FUNCTION deduct_credits(
    p_user_id UUID,
    p_amount INTEGER,
    p_description TEXT DEFAULT NULL
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_current_balance INTEGER;
BEGIN
    -- الحصول على الرصيد الحالي
    SELECT balance INTO v_current_balance
    FROM user_credits
    WHERE user_id = p_user_id
    FOR UPDATE;
    
    -- التحقق من وجود رصيد كافي
    IF v_current_balance IS NULL OR v_current_balance < p_amount THEN
        RETURN FALSE;
    END IF;
    
    -- خصم الرصيد
    UPDATE user_credits
    SET 
        balance = balance - p_amount,
        total_spent = total_spent + p_amount,
        updated_at = NOW()
    WHERE user_id = p_user_id;
    
    RETURN TRUE;
END;
$$;

-- دالة إضافة رصيد
CREATE OR REPLACE FUNCTION add_credits(
    p_user_id UUID,
    p_amount INTEGER
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- إنشاء سجل إذا لم يكن موجوداً
    INSERT INTO user_credits (user_id, balance, total_earned)
    VALUES (p_user_id, p_amount, p_amount)
    ON CONFLICT (user_id) DO UPDATE
    SET 
        balance = user_credits.balance + p_amount,
        total_earned = user_credits.total_earned + p_amount,
        updated_at = NOW();
    
    RETURN TRUE;
END;
$$;

-- دالة إنشاء مشروع جديد
CREATE OR REPLACE FUNCTION create_studio_project(
    p_user_id UUID,
    p_store_id UUID,
    p_template_id UUID,
    p_product_id UUID DEFAULT NULL,
    p_name VARCHAR(255) DEFAULT 'مشروع جديد'
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_project_id UUID;
    v_template_config JSONB;
BEGIN
    -- جلب تكوين القالب
    IF p_template_id IS NOT NULL THEN
        SELECT scenes_config INTO v_template_config
        FROM studio_templates
        WHERE id = p_template_id;
    END IF;
    
    -- إنشاء المشروع
    INSERT INTO studio_projects (
        user_id, store_id, template_id, product_id, name
    )
    VALUES (
        p_user_id, p_store_id, p_template_id, p_product_id, p_name
    )
    RETURNING id INTO v_project_id;
    
    RETURN v_project_id;
END;
$$;

-- دالة تحديث حالة المشروع
CREATE OR REPLACE FUNCTION update_project_status(
    p_project_id UUID,
    p_status VARCHAR(50),
    p_progress INTEGER DEFAULT NULL,
    p_error_message TEXT DEFAULT NULL
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE studio_projects
    SET 
        status = p_status,
        progress = COALESCE(p_progress, progress),
        error_message = p_error_message,
        updated_at = NOW()
    WHERE id = p_project_id;
    
    RETURN FOUND;
END;
$$;

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Trigger لتحديث updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- حذف الـ triggers القديمة إن وجدت
DROP TRIGGER IF EXISTS update_user_credits_updated_at ON user_credits;
DROP TRIGGER IF EXISTS update_studio_templates_updated_at ON studio_templates;
DROP TRIGGER IF EXISTS update_studio_projects_updated_at ON studio_projects;
DROP TRIGGER IF EXISTS update_studio_scenes_updated_at ON studio_scenes;

CREATE TRIGGER update_user_credits_updated_at
    BEFORE UPDATE ON user_credits
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_studio_templates_updated_at
    BEFORE UPDATE ON studio_templates
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_studio_projects_updated_at
    BEFORE UPDATE ON studio_projects
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_studio_scenes_updated_at
    BEFORE UPDATE ON studio_scenes
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger لإنشاء رصيد للمستخدم الجديد
CREATE OR REPLACE FUNCTION create_user_credits()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_credits (user_id, balance, total_earned)
    VALUES (NEW.id, 100, 100)
    ON CONFLICT (user_id) DO NOTHING;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ربط الـ trigger بجدول auth.users (إذا لم يكن موجوداً)
-- DROP TRIGGER IF EXISTS on_auth_user_created_credits ON auth.users;
-- CREATE TRIGGER on_auth_user_created_credits
--     AFTER INSERT ON auth.users
--     FOR EACH ROW
--     EXECUTE FUNCTION create_user_credits();

-- =====================================================
-- SEED DATA - القوالب الافتراضية
-- =====================================================

INSERT INTO studio_templates (name, name_ar, description, description_ar, category, duration_seconds, aspect_ratio, credits_cost, scenes_config, tags) VALUES
(
    'Product Showcase',
    'عرض المنتج',
    'Professional product showcase with smooth transitions',
    'عرض احترافي للمنتج مع انتقالات سلسة',
    'product_ad',
    30,
    '9:16',
    10,
    '[
        {"type": "intro", "duration": 3000, "prompt": "Product reveal with elegant animation"},
        {"type": "image", "duration": 5000, "prompt": "Product hero shot"},
        {"type": "image", "duration": 5000, "prompt": "Product features close-up"},
        {"type": "image", "duration": 5000, "prompt": "Product in use"},
        {"type": "text", "duration": 4000, "prompt": "Key benefits"},
        {"type": "image", "duration": 4000, "prompt": "Product lifestyle"},
        {"type": "cta", "duration": 4000, "prompt": "Call to action with price"}
    ]',
    ARRAY['product', 'showcase', 'professional']
),
(
    'UGC Style Review',
    'مراجعة UGC',
    'User-generated content style with talking head',
    'أسلوب محتوى المستخدم مع وجه متحدث',
    'ugc',
    45,
    '9:16',
    20,
    '[
        {"type": "ugc", "duration": 8000, "prompt": "Excited introduction"},
        {"type": "image", "duration": 4000, "prompt": "Product unboxing"},
        {"type": "ugc", "duration": 10000, "prompt": "Explaining benefits"},
        {"type": "image", "duration": 5000, "prompt": "Product demonstration"},
        {"type": "ugc", "duration": 8000, "prompt": "Personal recommendation"},
        {"type": "image", "duration": 5000, "prompt": "Final product shot"},
        {"type": "cta", "duration": 5000, "prompt": "Call to action"}
    ]',
    ARRAY['ugc', 'review', 'authentic']
),
(
    'Flash Sale',
    'عرض سريع',
    'High-energy promotional video for sales',
    'فيديو ترويجي عالي الطاقة للعروض',
    'promo',
    15,
    '9:16',
    8,
    '[
        {"type": "text", "duration": 2000, "prompt": "SALE! attention grabber"},
        {"type": "image", "duration": 3000, "prompt": "Product showcase"},
        {"type": "text", "duration": 3000, "prompt": "Discount percentage"},
        {"type": "image", "duration": 3000, "prompt": "Product benefits"},
        {"type": "cta", "duration": 4000, "prompt": "Limited time offer CTA"}
    ]',
    ARRAY['sale', 'promo', 'urgent']
),
(
    'Instagram Story',
    'قصة انستقرام',
    'Perfect for Instagram stories format',
    'مثالي لتنسيق قصص انستقرام',
    'story',
    15,
    '9:16',
    5,
    '[
        {"type": "image", "duration": 3000, "prompt": "Eye-catching opener"},
        {"type": "image", "duration": 4000, "prompt": "Product highlight"},
        {"type": "text", "duration": 4000, "prompt": "Key message"},
        {"type": "cta", "duration": 4000, "prompt": "Swipe up CTA"}
    ]',
    ARRAY['story', 'instagram', 'short']
),
(
    'YouTube Shorts',
    'يوتيوب شورتس',
    'Vertical video optimized for YouTube Shorts',
    'فيديو عمودي محسن ليوتيوب شورتس',
    'product_ad',
    60,
    '9:16',
    15,
    '[
        {"type": "intro", "duration": 3000, "prompt": "Hook - attention grabber"},
        {"type": "ugc", "duration": 10000, "prompt": "Problem introduction"},
        {"type": "image", "duration": 8000, "prompt": "Product as solution"},
        {"type": "image", "duration": 8000, "prompt": "Feature 1"},
        {"type": "image", "duration": 8000, "prompt": "Feature 2"},
        {"type": "ugc", "duration": 10000, "prompt": "Testimonial"},
        {"type": "image", "duration": 8000, "prompt": "Results"},
        {"type": "cta", "duration": 5000, "prompt": "Call to action"}
    ]',
    ARRAY['youtube', 'shorts', 'vertical']
)
ON CONFLICT DO NOTHING;

-- =====================================================
-- GRANTS
-- =====================================================

-- منح الصلاحيات للـ service role
GRANT ALL ON user_credits TO service_role;
GRANT ALL ON studio_templates TO service_role;
GRANT ALL ON studio_projects TO service_role;
GRANT ALL ON studio_scenes TO service_role;
GRANT ALL ON studio_assets TO service_role;
GRANT ALL ON studio_renders TO service_role;
GRANT ALL ON studio_api_usage TO service_role;
GRANT ALL ON studio_package_orders TO service_role;
GRANT ALL ON studio_package_deliverables TO service_role;
GRANT ALL ON studio_tool_usage TO service_role;

-- منح صلاحيات للمستخدمين المصادقين
GRANT SELECT, INSERT, UPDATE, DELETE ON user_credits TO authenticated;
GRANT SELECT ON studio_templates TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON studio_projects TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON studio_scenes TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON studio_assets TO authenticated;
GRANT SELECT, INSERT ON studio_renders TO authenticated;
GRANT SELECT ON studio_api_usage TO authenticated;
GRANT ALL ON studio_package_orders TO authenticated;
GRANT SELECT ON studio_package_deliverables TO authenticated;
GRANT SELECT, INSERT ON studio_tool_usage TO authenticated;

-- منح صلاحية تنفيذ الدوال
GRANT EXECUTE ON FUNCTION deduct_credits TO authenticated;
GRANT EXECUTE ON FUNCTION add_credits TO service_role;
GRANT EXECUTE ON FUNCTION create_studio_project TO authenticated;
GRANT EXECUTE ON FUNCTION update_project_status TO authenticated;
