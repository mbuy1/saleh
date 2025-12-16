-- إصلاح جدول product_media
-- تنفيذ هذا SQL في Supabase SQL Editor

-- 1. التحقق من وجود الجدول وإنشاؤه إذا لم يكن موجوداً
CREATE TABLE IF NOT EXISTS product_media (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    media_type TEXT NOT NULL CHECK (media_type IN ('image', 'video')),
    url TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_main BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. إنشاء indexes
CREATE INDEX IF NOT EXISTS idx_product_media_product_id ON product_media(product_id);
CREATE INDEX IF NOT EXISTS idx_product_media_is_main ON product_media(product_id, is_main) WHERE is_main = true;
CREATE INDEX IF NOT EXISTS idx_product_media_sort_order ON product_media(product_id, sort_order);

-- 3. تفعيل RLS
ALTER TABLE product_media ENABLE ROW LEVEL SECURITY;

-- 4. حذف السياسات القديمة إن وجدت
DROP POLICY IF EXISTS "Anyone can read product_media" ON product_media;
DROP POLICY IF EXISTS "Store owners can insert product_media" ON product_media;
DROP POLICY IF EXISTS "Store owners can update product_media" ON product_media;
DROP POLICY IF EXISTS "Store owners can delete product_media" ON product_media;
DROP POLICY IF EXISTS "Service role full access to product_media" ON product_media;

-- 5. إنشاء سياسة تسمح للـ service role بالوصول الكامل (مهم جداً!)
CREATE POLICY "Service role full access to product_media"
    ON product_media
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

-- 6. سياسة القراءة للجميع (للتطبيق)
CREATE POLICY "Anyone can read product_media"
    ON product_media
    FOR SELECT
    TO authenticated, anon
    USING (true);

-- 7. سياسة الإدراج لأصحاب المتاجر
CREATE POLICY "Store owners can insert product_media"
    ON product_media
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM products p
            JOIN stores s ON p.store_id = s.id
            JOIN user_profiles up ON s.owner_id = up.id
            WHERE p.id = product_media.product_id
            AND up.auth_user_id = auth.uid()
        )
    );

-- 8. التحقق من البيانات
SELECT 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'product_media'
ORDER BY ordinal_position;

-- 9. عرض السياسات الموجودة
SELECT 
    policyname, 
    cmd, 
    roles 
FROM pg_policies 
WHERE tablename = 'product_media';
