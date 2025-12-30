-- ========================================
-- تفعيل Row Level Security (RLS) في Supabase
-- تاريخ: يناير 2025
-- ========================================

-- ========================================
-- 1. تفعيل RLS على الجداول الرئيسية
-- ========================================

-- User Profiles
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Stores
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;

-- Products
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Categories
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Orders
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Order Items
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Cart Items
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;

-- Wallets
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;

-- Wallet Transactions
ALTER TABLE wallet_transactions ENABLE ROW LEVEL SECURITY;

-- Points Accounts
ALTER TABLE points_accounts ENABLE ROW LEVEL SECURITY;

-- Points Transactions
ALTER TABLE points_transactions ENABLE ROW LEVEL SECURITY;

-- Coupons
ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;

-- Reviews
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Favorites
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

-- ========================================
-- 2. Policies لـ user_profiles
-- ========================================

-- يمكن للمستخدمين قراءة ملفاتهم الشخصية فقط
CREATE POLICY "Users can view own profile"
ON user_profiles FOR SELECT
USING (auth.uid() = id);

-- يمكن للمستخدمين تحديث ملفاتهم الشخصية فقط
CREATE POLICY "Users can update own profile"
ON user_profiles FOR UPDATE
USING (auth.uid() = id);

-- يمكن للمستخدمين إدراج ملفاتهم الشخصية فقط
CREATE POLICY "Users can insert own profile"
ON user_profiles FOR INSERT
WITH CHECK (auth.uid() = id);

-- ========================================
-- 3. Policies لـ stores
-- ========================================

-- يمكن للجميع قراءة المتاجر النشطة
CREATE POLICY "Anyone can view active stores"
ON stores FOR SELECT
USING (status = 'active' AND visibility = 'public');

-- يمكن لأصحاب المتاجر قراءة متاجرهم
CREATE POLICY "Merchants can view own stores"
ON stores FOR SELECT
USING (auth.uid() = owner_id);

-- يمكن لأصحاب المتاجر إدارة متاجرهم
CREATE POLICY "Merchants can manage own stores"
ON stores FOR ALL
USING (auth.uid() = owner_id);

-- يمكن للمسؤولين إدارة جميع المتاجر
CREATE POLICY "Admins can manage all stores"
ON stores FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_profiles.id = auth.uid()
    AND user_profiles.role = 'admin'
  )
);

-- ========================================
-- 4. Policies لـ products
-- ========================================

-- يمكن للجميع قراءة المنتجات النشطة
CREATE POLICY "Anyone can view active products"
ON products FOR SELECT
USING (status = 'active');

-- يمكن لأصحاب المتاجر إدارة منتجات متاجرهم
CREATE POLICY "Merchants can manage own store products"
ON products FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM stores
    WHERE stores.id = products.store_id
    AND stores.owner_id = auth.uid()
  )
);

-- ========================================
-- 5. Policies لـ orders
-- ========================================

-- يمكن للعملاء قراءة طلباتهم
CREATE POLICY "Customers can view own orders"
ON orders FOR SELECT
USING (auth.uid() = customer_id);

-- يمكن للعملاء إنشاء طلبات جديدة
CREATE POLICY "Customers can create orders"
ON orders FOR INSERT
WITH CHECK (auth.uid() = customer_id);

-- يمكن للتجار قراءة طلبات متاجرهم
CREATE POLICY "Merchants can view store orders"
ON orders FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM order_items
    JOIN products ON products.id = order_items.product_id
    JOIN stores ON stores.id = products.store_id
    WHERE order_items.order_id = orders.id
    AND stores.owner_id = auth.uid()
  )
);

-- يمكن للتجار تحديث طلبات متاجرهم
CREATE POLICY "Merchants can update store orders"
ON orders FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM order_items
    JOIN products ON products.id = order_items.product_id
    JOIN stores ON stores.id = products.store_id
    WHERE order_items.order_id = orders.id
    AND stores.owner_id = auth.uid()
  )
);

-- ========================================
-- 6. Policies لـ cart_items
-- ========================================

-- يمكن للعملاء إدارة عناصر سلة التسوق الخاصة بهم
CREATE POLICY "Customers can manage own cart"
ON cart_items FOR ALL
USING (auth.uid() = user_id);

-- ========================================
-- 7. Policies لـ wallets
-- ========================================

-- يمكن للمستخدمين قراءة محافظهم فقط
CREATE POLICY "Users can view own wallets"
ON wallets FOR SELECT
USING (auth.uid() = owner_id);

-- يمكن للمستخدمين إنشاء محافظهم
CREATE POLICY "Users can create own wallets"
ON wallets FOR INSERT
WITH CHECK (auth.uid() = owner_id);

-- ========================================
-- 8. Policies لـ wallet_transactions
-- ========================================

-- يمكن للمستخدمين قراءة معاملات محافظهم
CREATE POLICY "Users can view own wallet transactions"
ON wallet_transactions FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM wallets
    WHERE wallets.id = wallet_transactions.wallet_id
    AND wallets.owner_id = auth.uid()
  )
);

-- ========================================
-- 9. Policies لـ points_accounts
-- ========================================

-- يمكن للمستخدمين قراءة حسابات نقاطهم
CREATE POLICY "Users can view own points accounts"
ON points_accounts FOR SELECT
USING (auth.uid() = user_id);

-- يمكن للمستخدمين إنشاء حسابات نقاطهم
CREATE POLICY "Users can create own points accounts"
ON points_accounts FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- ========================================
-- 10. Policies لـ points_transactions
-- ========================================

-- يمكن للمستخدمين قراءة معاملات نقاطهم
CREATE POLICY "Users can view own points transactions"
ON points_transactions FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM points_accounts
    WHERE points_accounts.id = points_transactions.points_account_id
    AND points_accounts.user_id = auth.uid()
  )
);

-- ========================================
-- 11. Policies لـ reviews
-- ========================================

-- يمكن للجميع قراءة التقييمات
CREATE POLICY "Anyone can view reviews"
ON reviews FOR SELECT
USING (true);

-- يمكن للعملاء إضافة تقييمات للمنتجات المشتراة
CREATE POLICY "Customers can add reviews for purchased products"
ON reviews FOR INSERT
WITH CHECK (
  auth.uid() = customer_id
  AND EXISTS (
    SELECT 1 FROM orders
    JOIN order_items ON order_items.order_id = orders.id
    WHERE orders.customer_id = auth.uid()
    AND order_items.product_id = reviews.product_id
    AND orders.status = 'completed'
  )
);

-- يمكن للعملاء تحديث تقييماتهم
CREATE POLICY "Customers can update own reviews"
ON reviews FOR UPDATE
USING (auth.uid() = customer_id);

-- ========================================
-- 12. Policies لـ favorites
-- ========================================

-- يمكن للمستخدمين إدارة مفضلاتهم
CREATE POLICY "Users can manage own favorites"
ON favorites FOR ALL
USING (auth.uid() = user_id);

-- ========================================
-- 13. Policies لـ categories
-- ========================================

-- يمكن للجميع قراءة الفئات النشطة
CREATE POLICY "Anyone can view active categories"
ON categories FOR SELECT
USING (is_active = true);

-- يمكن للمسؤولين إدارة الفئات
CREATE POLICY "Admins can manage categories"
ON categories FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_profiles.id = auth.uid()
    AND user_profiles.role = 'admin'
  )
);

-- ========================================
-- 14. Policies لـ coupons
-- ========================================

-- يمكن للجميع قراءة الكوبونات النشطة
CREATE POLICY "Anyone can view active coupons"
ON coupons FOR SELECT
USING (is_active = true AND expires_at > NOW());

-- يمكن للمسؤولين إدارة الكوبونات
CREATE POLICY "Admins can manage coupons"
ON coupons FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_profiles.id = auth.uid()
    AND user_profiles.role = 'admin'
  )
);

-- ========================================
-- ملاحظات مهمة:
-- ========================================
-- 1. هذه السياسات تحمي البيانات على مستوى الصفوف
-- 2. يجب اختبار جميع السياسات بعد التفعيل
-- 3. يمكن تعديل السياسات حسب الحاجة
-- 4. بعض الجداول قد تحتاج سياسات إضافية حسب المتطلبات
-- ========================================

