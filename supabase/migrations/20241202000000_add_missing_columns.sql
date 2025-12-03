-- ============================================
-- 🔧 Add missing columns to products table
-- ============================================

-- إضافة الأعمدة المفقودة إذا لم تكن موجودة
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS stock_quantity INTEGER DEFAULT 0;

ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS discount_price DECIMAL(10,2);

ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS rating DECIMAL(3,2);

ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS reviews_count INTEGER DEFAULT 0;

ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS image_url TEXT;

-- إضافة الأعمدة المفقودة إلى stores
ALTER TABLE public.stores 
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

ALTER TABLE public.stores 
ADD COLUMN IF NOT EXISTS rating DECIMAL(3,2);

ALTER TABLE public.stores 
ADD COLUMN IF NOT EXISTS products_count INTEGER DEFAULT 0;

ALTER TABLE public.stores 
ADD COLUMN IF NOT EXISTS logo_url TEXT;

ALTER TABLE public.stores 
ADD COLUMN IF NOT EXISTS banner_url TEXT;

-- إضافة الأعمدة المفقودة إلى categories
ALTER TABLE public.categories 
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

ALTER TABLE public.categories 
ADD COLUMN IF NOT EXISTS display_order INTEGER DEFAULT 0;

ALTER TABLE public.categories 
ADD COLUMN IF NOT EXISTS icon_url TEXT;

ALTER TABLE public.categories 
ADD COLUMN IF NOT EXISTS products_count INTEGER DEFAULT 0;

-- ============================================
-- ✅ تم إضافة جميع الأعمدة المفقودة
-- ============================================
