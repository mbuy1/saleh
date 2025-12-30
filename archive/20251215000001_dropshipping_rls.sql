-- ========================================
-- RLS Policies لنظام دروب شوبينق
-- تاريخ: ديسمبر 2025
-- ========================================

-- تفعيل RLS على الجداول الجديدة
ALTER TABLE dropship_products ENABLE ROW LEVEL SECURITY;
ALTER TABLE reseller_listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE supplier_orders ENABLE ROW LEVEL SECURITY;

-- ========================================
-- 1. Policies لـ dropship_products
-- ========================================

-- Supplier يرى ويعدّل فقط منتجاته
CREATE POLICY "Suppliers can view their own dropship products"
  ON dropship_products
  FOR SELECT
  USING (
    supplier_store_id IN (
      SELECT id FROM stores WHERE owner_id = auth.uid()
    )
  );

CREATE POLICY "Suppliers can insert their own dropship products"
  ON dropship_products
  FOR INSERT
  WITH CHECK (
    supplier_store_id IN (
      SELECT id FROM stores WHERE owner_id = auth.uid()
    )
  );

CREATE POLICY "Suppliers can update their own dropship products"
  ON dropship_products
  FOR UPDATE
  USING (
    supplier_store_id IN (
      SELECT id FROM stores WHERE owner_id = auth.uid()
    )
  );

-- Resellers يمكنهم قراءة المنتجات المتاحة فقط (is_dropship_enabled=true AND is_active=true)
CREATE POLICY "Resellers can view available dropship products"
  ON dropship_products
  FOR SELECT
  USING (
    is_dropship_enabled = true 
    AND is_active = true 
    AND stock_qty > 0
    AND supplier_store_id NOT IN (
      SELECT id FROM stores WHERE owner_id = auth.uid()
    )
  );

-- ========================================
-- 2. Policies لـ reseller_listings
-- ========================================

-- Reseller يرى ويعدّل فقط listings الخاصة به
CREATE POLICY "Resellers can view their own listings"
  ON reseller_listings
  FOR SELECT
  USING (
    reseller_store_id IN (
      SELECT id FROM stores WHERE owner_id = auth.uid()
    )
  );

CREATE POLICY "Resellers can insert their own listings"
  ON reseller_listings
  FOR INSERT
  WITH CHECK (
    reseller_store_id IN (
      SELECT id FROM stores WHERE owner_id = auth.uid()
    )
  );

CREATE POLICY "Resellers can update their own listings"
  ON reseller_listings
  FOR UPDATE
  USING (
    reseller_store_id IN (
      SELECT id FROM stores WHERE owner_id = auth.uid()
    )
  );

-- ========================================
-- 3. Policies لـ supplier_orders
-- ========================================

-- Supplier يرى ويعدّل فقط طلبات التوريد الخاصة به
CREATE POLICY "Suppliers can view their own supplier orders"
  ON supplier_orders
  FOR SELECT
  USING (
    supplier_store_id IN (
      SELECT id FROM stores WHERE owner_id = auth.uid()
    )
  );

CREATE POLICY "Suppliers can update their own supplier orders"
  ON supplier_orders
  FOR UPDATE
  USING (
    supplier_store_id IN (
      SELECT id FROM stores WHERE owner_id = auth.uid()
    )
  );

-- Reseller يرى فقط طلباته (للقراءة فقط)
CREATE POLICY "Resellers can view their supplier orders"
  ON supplier_orders
  FOR SELECT
  USING (
    reseller_store_id IN (
      SELECT id FROM stores WHERE owner_id = auth.uid()
    )
  );

-- ========================================
-- 4. تحديث Policies لـ orders لدعم الدروب شوبينق
-- ========================================

-- Reseller يرى طلباته (بما فيها dropship)
CREATE POLICY "Resellers can view their orders including dropship"
  ON orders
  FOR SELECT
  USING (
    reseller_store_id IN (
      SELECT id FROM stores WHERE owner_id = auth.uid()
    )
    OR store_id IN (
      SELECT id FROM stores WHERE owner_id = auth.uid()
    )
  );

-- Supplier يرى طلبات التوريد المرتبطة به (للقراءة فقط)
CREATE POLICY "Suppliers can view related dropship orders"
  ON orders
  FOR SELECT
  USING (
    is_dropship = true
    AND supplier_store_id IN (
      SELECT id FROM stores WHERE owner_id = auth.uid()
    )
  );

