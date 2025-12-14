-- إنشاء جدول product_media لدعم عدة صور وفيديو لكل منتج
-- Migration: 20241210_create_product_media

-- إنشاء الجدول
CREATE TABLE IF NOT EXISTS product_media (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    media_type TEXT NOT NULL CHECK (media_type IN ('image', 'video')),
    url TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_main BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- إنشاء index للبحث السريع بـ product_id
CREATE INDEX IF NOT EXISTS idx_product_media_product_id ON product_media(product_id);

-- إنشاء index للبحث بالصورة الرئيسية
CREATE INDEX IF NOT EXISTS idx_product_media_is_main 
    ON product_media(product_id, is_main) 
    WHERE is_main = true;

-- إنشاء index للترتيب
CREATE INDEX IF NOT EXISTS idx_product_media_sort_order 
    ON product_media(product_id, sort_order);

-- تفعيل RLS
ALTER TABLE product_media ENABLE ROW LEVEL SECURITY;

-- سياسة قراءة عامة (أي شخص يمكنه رؤية وسائط المنتجات)
CREATE POLICY "Public read access for product media"
    ON product_media
    FOR SELECT
    USING (true);

-- سياسة إدراج (التجار فقط يمكنهم إضافة وسائط لمنتجاتهم)
CREATE POLICY "Merchants can insert their product media"
    ON product_media
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1
            FROM products p
            INNER JOIN stores s ON p.store_id = s.id
            INNER JOIN user_profiles pr ON s.owner_id = pr.id
            WHERE p.id = product_media.product_id
              AND pr.mbuy_user_id = auth.uid()
              AND pr.role = 'merchant'
        )
    );

-- سياسة تحديث (التجار فقط يمكنهم تحديث وسائط منتجاتهم)
CREATE POLICY "Merchants can update their product media"
    ON product_media
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1
            FROM products p
            INNER JOIN stores s ON p.store_id = s.id
            INNER JOIN user_profiles pr ON s.owner_id = pr.id
            WHERE p.id = product_media.product_id
              AND pr.mbuy_user_id = auth.uid()
              AND pr.role = 'merchant'
        )
    );

-- سياسة حذف (التجار فقط يمكنهم حذف وسائط منتجاتهم)
CREATE POLICY "Merchants can delete their product media"
    ON product_media
    FOR DELETE
    USING (
        EXISTS (
            SELECT 1
            FROM products p
            INNER JOIN stores s ON p.store_id = s.id
            INNER JOIN user_profiles pr ON s.owner_id = pr.id
            WHERE p.id = product_media.product_id
              AND pr.mbuy_user_id = auth.uid()
              AND pr.role = 'merchant'
        )
    );

-- إضافة تعليق على الجدول
COMMENT ON TABLE product_media IS 'يحتوي على وسائط المنتجات (صور وفيديوهات) - يدعم حتى 4 صور وفيديو واحد لكل منتج';
COMMENT ON COLUMN product_media.media_type IS 'نوع الوسائط: image أو video';
COMMENT ON COLUMN product_media.is_main IS 'هل هذه الصورة/الفيديو الرئيسي للمنتج';
COMMENT ON COLUMN product_media.sort_order IS 'ترتيب عرض الوسائط (0 = أول، 1 = ثاني، إلخ)';
