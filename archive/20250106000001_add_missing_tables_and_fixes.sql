-- ========================================
-- إضافة الجداول المفقودة وإصلاح المشاكل
-- تاريخ: يناير 2025
-- ========================================

-- ========================================
-- 1. جدول Wishlist (قائمة الأمنيات)
-- ========================================
CREATE TABLE IF NOT EXISTS wishlist (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, product_id)
);

CREATE INDEX IF NOT EXISTS idx_wishlist_user_id ON wishlist(user_id);
CREATE INDEX IF NOT EXISTS idx_wishlist_product_id ON wishlist(product_id);
CREATE INDEX IF NOT EXISTS idx_wishlist_created_at ON wishlist(created_at);

COMMENT ON TABLE wishlist IS 'قائمة الأمنيات (Wishlist) - منتجات يريد المستخدم حفظها لاحقاً';

-- ========================================
-- 2. جدول Recently Viewed (المشاهدة مؤخراً)
-- ========================================
CREATE TABLE IF NOT EXISTS recently_viewed (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  viewed_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, product_id)
);

CREATE INDEX IF NOT EXISTS idx_recently_viewed_user_id ON recently_viewed(user_id);
CREATE INDEX IF NOT EXISTS idx_recently_viewed_product_id ON recently_viewed(product_id);
CREATE INDEX IF NOT EXISTS idx_recently_viewed_viewed_at ON recently_viewed(viewed_at DESC);

COMMENT ON TABLE recently_viewed IS 'المنتجات التي شاهدها المستخدم مؤخراً';

-- ========================================
-- 3. جدول Product Variants (المقاسات والألوان)
-- ========================================
CREATE TABLE IF NOT EXISTS product_variants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  variant_name TEXT NOT NULL, -- مثال: "اللون", "المقاس", "الحجم"
  variant_value TEXT NOT NULL, -- مثال: "أحمر", "كبير", "XL"
  price_modifier DECIMAL(10, 2) DEFAULT 0, -- تعديل السعر (+5.00 أو -3.00)
  stock_quantity INTEGER DEFAULT 0,
  sku TEXT,
  image_url TEXT,
  is_active BOOLEAN DEFAULT true,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_product_variants_product_id ON product_variants(product_id);
CREATE INDEX IF NOT EXISTS idx_product_variants_is_active ON product_variants(is_active);
CREATE INDEX IF NOT EXISTS idx_product_variants_variant_name ON product_variants(variant_name);

COMMENT ON TABLE product_variants IS 'المقاسات والألوان والخيارات للمنتجات (Product Variants)';

-- ========================================
-- 4. إصلاح: توحيد استخدام stock في products
-- ========================================
-- التأكد من أن products تستخدم stock فقط (وليس stock_quantity)
-- إذا كان هناك حقل stock_quantity، نحذفه أو ندمجه مع stock

DO $$
BEGIN
  -- التحقق من وجود حقل stock_quantity وإزالته إذا كان موجوداً
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_name = 'products' 
    AND column_name = 'stock_quantity'
  ) THEN
    -- نقل البيانات من stock_quantity إلى stock إذا كان stock فارغ
    UPDATE products 
    SET stock = stock_quantity 
    WHERE stock = 0 OR stock IS NULL;
    
    -- حذف الحقل
    ALTER TABLE products DROP COLUMN IF EXISTS stock_quantity;
    
    RAISE NOTICE 'تم حذف حقل stock_quantity وتوحيد استخدام stock';
  END IF;
END $$;

-- التأكد من أن stock موجود
ALTER TABLE products 
  ADD COLUMN IF NOT EXISTS stock INTEGER DEFAULT 0;

-- إضافة CHECK constraint للسعر والمخزون
ALTER TABLE products 
  DROP CONSTRAINT IF EXISTS check_products_price_positive;
ALTER TABLE products 
  ADD CONSTRAINT check_products_price_positive 
  CHECK (price >= 0);

ALTER TABLE products 
  DROP CONSTRAINT IF EXISTS check_products_stock_non_negative;
ALTER TABLE products 
  ADD CONSTRAINT check_products_stock_non_negative 
  CHECK (stock >= 0);

-- ========================================
-- 5. إصلاح: مراجعة conversations.merchant_id
-- ========================================
-- ملاحظة: conversations.merchant_id يشير إلى stores
-- هذا صحيح من الناحية المنطقية (المحادثة مع المتجر)
-- لكن قد نحتاج إضافة حقل owner_id للوصول السريع للمالك

-- إضافة حقل مساعد للوصول السريع إلى owner
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_name = 'conversations' 
    AND column_name = 'merchant_owner_id'
  ) THEN
    ALTER TABLE conversations 
    ADD COLUMN merchant_owner_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE;
    
    -- ملء البيانات من stores
    UPDATE conversations c
    SET merchant_owner_id = s.owner_id
    FROM stores s
    WHERE c.merchant_id = s.id;
    
    CREATE INDEX IF NOT EXISTS idx_conversations_merchant_owner_id 
    ON conversations(merchant_owner_id);
    
    RAISE NOTICE 'تم إضافة merchant_owner_id للوصول السريع';
  END IF;
END $$;

COMMENT ON COLUMN conversations.merchant_id IS 'المتجر (مرجع إلى stores)';
COMMENT ON COLUMN conversations.merchant_owner_id IS 'مالك المتجر (للوصول السريع)';

-- ========================================
-- 6. إضافة CHECK Constraints للجداول المهمة
-- ========================================

-- wallets
ALTER TABLE wallets 
  DROP CONSTRAINT IF EXISTS check_wallets_balance_non_negative;
ALTER TABLE wallets 
  ADD CONSTRAINT check_wallets_balance_non_negative 
  CHECK (balance >= 0);

-- wallet_transactions
ALTER TABLE wallet_transactions 
  DROP CONSTRAINT IF EXISTS check_wallet_transactions_amount_positive;
ALTER TABLE wallet_transactions 
  ADD CONSTRAINT check_wallet_transactions_amount_positive 
  CHECK (amount > 0);

-- orders
ALTER TABLE orders 
  DROP CONSTRAINT IF EXISTS check_orders_amounts_non_negative;
ALTER TABLE orders 
  ADD CONSTRAINT check_orders_amounts_non_negative 
  CHECK (
    subtotal >= 0 AND
    discount_amount >= 0 AND
    tax_amount >= 0 AND
    shipping_amount >= 0 AND
    total_amount >= 0
  );

-- order_items
ALTER TABLE order_items 
  DROP CONSTRAINT IF EXISTS check_order_items_positive;
ALTER TABLE order_items 
  ADD CONSTRAINT check_order_items_positive 
  CHECK (
    quantity > 0 AND
    price >= 0 AND
    total >= 0
  );

-- cart_items
ALTER TABLE cart_items 
  DROP CONSTRAINT IF EXISTS check_cart_items_quantity_positive;
ALTER TABLE cart_items 
  ADD CONSTRAINT check_cart_items_quantity_positive 
  CHECK (quantity > 0);

-- coupons
ALTER TABLE coupons 
  DROP CONSTRAINT IF EXISTS check_coupons_values_positive;
ALTER TABLE coupons 
  ADD CONSTRAINT check_coupons_values_positive 
  CHECK (
    discount_value > 0 AND
    min_order_amount >= 0 AND
    (max_discount_amount IS NULL OR max_discount_amount > 0) AND
    (usage_limit IS NULL OR usage_limit > 0) AND
    usage_count >= 0
  );

-- product_variants
ALTER TABLE product_variants 
  DROP CONSTRAINT IF EXISTS check_product_variants_stock_non_negative;
ALTER TABLE product_variants 
  ADD CONSTRAINT check_product_variants_stock_non_negative 
  CHECK (stock_quantity >= 0);

-- ========================================
-- 7. تحديث البيانات الأولية للفئات (إذا لزم الأمر)
-- ========================================
-- التأكد من وجود الفئات الأساسية

INSERT INTO categories (name, name_ar, slug, display_order, icon, is_active) VALUES
('Electronics', 'إلكترونيات', 'electronics', 1, '📱', true),
('Fashion', 'أزياء', 'fashion', 2, '👔', true),
('Home & Garden', 'منزل وحديقة', 'home-garden', 3, '🏠', true),
('Sports', 'رياضة', 'sports', 4, '⚽', true),
('Books', 'كتب', 'books', 5, '📚', true),
('Toys', 'ألعاب', 'toys', 6, '🧸', true),
('Health & Beauty', 'صحة وجمال', 'health-beauty', 7, '💄', true),
('Automotive', 'سيارات', 'automotive', 8, '🚗', true),
('Food & Beverages', 'طعام ومشروبات', 'food-beverages', 9, '🍔', true),
('Office Supplies', 'مستلزمات مكتبية', 'office-supplies', 10, '📎', true)
ON CONFLICT (slug) DO UPDATE 
SET name_ar = EXCLUDED.name_ar, 
    icon = EXCLUDED.icon,
    is_active = EXCLUDED.is_active;

-- ========================================
-- 8. منح الصلاحيات للجداول الجديدة
-- ========================================
GRANT ALL ON wishlist TO postgres, authenticated, service_role;
GRANT ALL ON recently_viewed TO postgres, authenticated, service_role;
GRANT ALL ON product_variants TO postgres, authenticated, service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON wishlist TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON recently_viewed TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON product_variants TO authenticated;

GRANT SELECT ON wishlist TO anon;
GRANT SELECT ON recently_viewed TO anon;
GRANT SELECT ON product_variants TO anon;

-- ========================================
-- 9. تفعيل/تعطيل RLS للجداول الجديدة (حسب الحاجة)
-- ========================================
-- ملاحظة: RLS معطل حالياً للتطوير
-- في الإنتاج، يجب إنشاء policies مناسبة

ALTER TABLE wishlist DISABLE ROW LEVEL SECURITY;
ALTER TABLE recently_viewed DISABLE ROW LEVEL SECURITY;
ALTER TABLE product_variants DISABLE ROW LEVEL SECURITY;

-- ========================================
-- رسالة نجاح
-- ========================================
DO $$
BEGIN
  RAISE NOTICE '✅ تم إنشاء الجداول المفقودة وإصلاح المشاكل بنجاح!';
  RAISE NOTICE '✅ تم إضافة: wishlist, recently_viewed, product_variants';
  RAISE NOTICE '✅ تم توحيد استخدام stock';
  RAISE NOTICE '✅ تم إضافة CHECK constraints';
  RAISE NOTICE '✅ تم إضافة merchant_owner_id إلى conversations';
END $$;

