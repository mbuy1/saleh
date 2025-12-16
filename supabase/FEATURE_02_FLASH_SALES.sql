-- ============================================================================
-- MBUY Flash Sales System - نظام العروض الخاطفة
-- الميزة #2 من 23
-- تاريخ الإنشاء: ديسمبر 2025
-- ============================================================================

-- ============================================================================
-- 1. جدول العروض الخاطفة (Flash Sales)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.flash_sales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    
    -- معلومات العرض
    title VARCHAR(200) NOT NULL,
    title_ar VARCHAR(200),
    description TEXT,
    description_ar TEXT,
    
    -- صورة الغلاف
    cover_image TEXT,
    
    -- التوقيت
    starts_at TIMESTAMPTZ NOT NULL,
    ends_at TIMESTAMPTZ NOT NULL,
    
    -- نوع الخصم الافتراضي
    default_discount_type VARCHAR(20) DEFAULT 'percentage', -- percentage, fixed
    default_discount_value DECIMAL(10,2),
    
    -- الحدود
    max_orders INTEGER, -- الحد الأقصى للطلبات (NULL = غير محدود)
    orders_count INTEGER DEFAULT 0,
    
    -- الحالة
    status VARCHAR(20) DEFAULT 'draft', -- draft, scheduled, active, ended, cancelled
    is_featured BOOLEAN DEFAULT false, -- عرض مميز في الصفحة الرئيسية
    
    -- الإحصائيات
    views_count INTEGER DEFAULT 0,
    
    -- البيانات الوصفية
    metadata JSONB DEFAULT '{}',
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT valid_dates CHECK (ends_at > starts_at)
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_flash_sales_store_id ON public.flash_sales(store_id);
CREATE INDEX IF NOT EXISTS idx_flash_sales_status ON public.flash_sales(status);
CREATE INDEX IF NOT EXISTS idx_flash_sales_starts_at ON public.flash_sales(starts_at);
CREATE INDEX IF NOT EXISTS idx_flash_sales_ends_at ON public.flash_sales(ends_at);

-- ============================================================================
-- 2. جدول منتجات العرض الخاطف (Flash Sale Products)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.flash_sale_products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    flash_sale_id UUID NOT NULL REFERENCES public.flash_sales(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    
    -- السعر
    original_price DECIMAL(10,2) NOT NULL,
    sale_price DECIMAL(10,2) NOT NULL,
    discount_percentage DECIMAL(5,2) GENERATED ALWAYS AS (
        ROUND(((original_price - sale_price) / original_price * 100)::numeric, 2)
    ) STORED,
    
    -- الكمية
    quantity_limit INTEGER, -- الكمية المتاحة للعرض
    quantity_sold INTEGER DEFAULT 0,
    
    -- الترتيب
    sort_order INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(flash_sale_id, product_id)
);

-- فهارس
CREATE INDEX IF NOT EXISTS idx_fsp_flash_sale_id ON public.flash_sale_products(flash_sale_id);
CREATE INDEX IF NOT EXISTS idx_fsp_product_id ON public.flash_sale_products(product_id);

-- ============================================================================
-- 3. RLS Policies
-- ============================================================================

ALTER TABLE public.flash_sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.flash_sale_products ENABLE ROW LEVEL SECURITY;

-- Flash Sales
DROP POLICY IF EXISTS "Store owner can manage flash sales" ON public.flash_sales;
DROP POLICY IF EXISTS "Anyone can view active flash sales" ON public.flash_sales;
DROP POLICY IF EXISTS "Service role full access to flash_sales" ON public.flash_sales;

CREATE POLICY "Store owner can manage flash sales" ON public.flash_sales
    FOR ALL USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Anyone can view active flash sales" ON public.flash_sales
    FOR SELECT USING (status = 'active' AND NOW() BETWEEN starts_at AND ends_at);

CREATE POLICY "Service role full access to flash_sales" ON public.flash_sales
    FOR ALL USING (auth.role() = 'service_role');

-- Flash Sale Products
DROP POLICY IF EXISTS "Store owner can manage flash sale products" ON public.flash_sale_products;
DROP POLICY IF EXISTS "Anyone can view active flash sale products" ON public.flash_sale_products;
DROP POLICY IF EXISTS "Service role full access to flash_sale_products" ON public.flash_sale_products;

CREATE POLICY "Store owner can manage flash sale products" ON public.flash_sale_products
    FOR ALL USING (
        store_id IN (SELECT id FROM public.stores WHERE owner_id = auth.uid())
    );

CREATE POLICY "Anyone can view active flash sale products" ON public.flash_sale_products
    FOR SELECT USING (
        flash_sale_id IN (
            SELECT id FROM public.flash_sales 
            WHERE status = 'active' AND NOW() BETWEEN starts_at AND ends_at
        )
    );

CREATE POLICY "Service role full access to flash_sale_products" ON public.flash_sale_products
    FOR ALL USING (auth.role() = 'service_role');

-- ============================================================================
-- 4. Functions
-- ============================================================================

-- تحديث حالة العروض تلقائياً
CREATE OR REPLACE FUNCTION update_flash_sale_status()
RETURNS void AS $$
BEGIN
    -- تفعيل العروض المجدولة
    UPDATE public.flash_sales
    SET status = 'active', updated_at = NOW()
    WHERE status = 'scheduled' 
    AND NOW() >= starts_at 
    AND NOW() < ends_at;
    
    -- إنهاء العروض المنتهية
    UPDATE public.flash_sales
    SET status = 'ended', updated_at = NOW()
    WHERE status = 'active' 
    AND NOW() >= ends_at;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- جلب العروض النشطة لمتجر
CREATE OR REPLACE FUNCTION get_active_flash_sales(p_store_id UUID)
RETURNS TABLE (
    id UUID,
    title VARCHAR,
    title_ar VARCHAR,
    cover_image TEXT,
    starts_at TIMESTAMPTZ,
    ends_at TIMESTAMPTZ,
    products_count BIGINT,
    time_remaining INTERVAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        fs.id,
        fs.title,
        fs.title_ar,
        fs.cover_image,
        fs.starts_at,
        fs.ends_at,
        COUNT(fsp.id) as products_count,
        fs.ends_at - NOW() as time_remaining
    FROM public.flash_sales fs
    LEFT JOIN public.flash_sale_products fsp ON fs.id = fsp.flash_sale_id
    WHERE fs.store_id = p_store_id
    AND fs.status = 'active'
    AND NOW() BETWEEN fs.starts_at AND fs.ends_at
    GROUP BY fs.id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 5. Trigger لتحديث updated_at
-- ============================================================================
CREATE OR REPLACE FUNCTION update_flash_sale_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS flash_sales_updated_at ON public.flash_sales;
CREATE TRIGGER flash_sales_updated_at
    BEFORE UPDATE ON public.flash_sales
    FOR EACH ROW
    EXECUTE FUNCTION update_flash_sale_timestamp();

-- ============================================================================
-- ✅ تم الإنشاء بنجاح!
-- ============================================================================
SELECT 'Flash Sales system installed successfully!' as status;
