-- ============================================================================
-- MBUY Complete System Migration
-- Version: 1.0.0
-- Date: 2025-12-14
-- 
-- This migration adds:
-- 1. Store subdomain system (slug, public_url)
-- 2. Promotions & Boost system
-- 3. Analytics events & daily rollups
-- 4. PDF Reports system
-- 5. Audit logs system
-- 6. Inventory movements system
-- 7. Merchant shortcuts system
-- ============================================================================

-- ============================================================================
-- (0) STORE SUBDOMAIN SYSTEM
-- ============================================================================

-- Add slug and public_url to stores table
ALTER TABLE stores ADD COLUMN IF NOT EXISTS slug TEXT UNIQUE;
ALTER TABLE stores ADD COLUMN IF NOT EXISTS public_url TEXT;

-- Create index for slug lookups
CREATE INDEX IF NOT EXISTS idx_stores_slug ON stores(slug) WHERE slug IS NOT NULL;

-- Function to generate slug from name
CREATE OR REPLACE FUNCTION generate_store_slug(store_name TEXT)
RETURNS TEXT AS $$
DECLARE
  base_slug TEXT;
  final_slug TEXT;
  counter INTEGER := 0;
BEGIN
  -- Convert to lowercase, replace spaces with hyphens, remove special chars
  base_slug := lower(regexp_replace(store_name, '[^a-zA-Z0-9\u0621-\u064A\s-]', '', 'g'));
  base_slug := regexp_replace(base_slug, '\s+', '-', 'g');
  base_slug := regexp_replace(base_slug, '-+', '-', 'g');
  base_slug := trim(both '-' from base_slug);
  
  -- If empty, generate random slug
  IF base_slug = '' OR base_slug IS NULL THEN
    base_slug := 'store-' || substring(gen_random_uuid()::text, 1, 8);
  END IF;
  
  final_slug := base_slug;
  
  -- Check for uniqueness and add counter if needed
  WHILE EXISTS (SELECT 1 FROM stores WHERE slug = final_slug) LOOP
    counter := counter + 1;
    final_slug := base_slug || '-' || counter;
  END LOOP;
  
  RETURN final_slug;
END;
$$ LANGUAGE plpgsql;

-- Function to compute public_url
CREATE OR REPLACE FUNCTION compute_store_public_url(store_slug TEXT)
RETURNS TEXT AS $$
BEGIN
  RETURN 'https://' || store_slug || '.mbuy.pro';
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Trigger to auto-generate slug and public_url on store insert/update
CREATE OR REPLACE FUNCTION trigger_store_slug_public_url()
RETURNS TRIGGER AS $$
BEGIN
  -- Generate slug if not provided or name changed
  IF NEW.slug IS NULL OR (TG_OP = 'UPDATE' AND OLD.name != NEW.name AND NEW.slug = OLD.slug) THEN
    NEW.slug := generate_store_slug(NEW.name);
  END IF;
  
  -- Always compute public_url from slug
  NEW.public_url := compute_store_public_url(NEW.slug);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_store_slug_url ON stores;
CREATE TRIGGER trigger_store_slug_url
  BEFORE INSERT OR UPDATE ON stores
  FOR EACH ROW
  EXECUTE FUNCTION trigger_store_slug_public_url();

-- Update existing stores with slug and public_url
UPDATE stores 
SET slug = generate_store_slug(name)
WHERE slug IS NULL;

UPDATE stores 
SET public_url = compute_store_public_url(slug)
WHERE public_url IS NULL AND slug IS NOT NULL;

-- ============================================================================
-- (1) PROMOTIONS SYSTEM
-- ============================================================================

-- Promotions table
CREATE TABLE IF NOT EXISTS promotions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  target_type TEXT NOT NULL CHECK (target_type IN ('store', 'product')),
  target_id UUID, -- NULL if target_type = 'store', product_id if target_type = 'product'
  promo_type TEXT NOT NULL CHECK (promo_type IN ('pin', 'boost')),
  weight INTEGER DEFAULT 1 CHECK (weight >= 1 AND weight <= 10), -- For boost ranking
  start_at TIMESTAMPTZ NOT NULL,
  end_at TIMESTAMPTZ NOT NULL,
  status TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'active', 'expired', 'cancelled')),
  budget_points INTEGER, -- Points spent for this promotion
  created_by UUID NOT NULL REFERENCES user_profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Constraints
  CONSTRAINT valid_date_range CHECK (end_at > start_at),
  CONSTRAINT valid_target CHECK (
    (target_type = 'store' AND target_id IS NULL) OR
    (target_type = 'product' AND target_id IS NOT NULL)
  )
);

-- Indexes for promotions
CREATE INDEX IF NOT EXISTS idx_promotions_store_id ON promotions(store_id);
CREATE INDEX IF NOT EXISTS idx_promotions_status ON promotions(status);
CREATE INDEX IF NOT EXISTS idx_promotions_active ON promotions(store_id, status, start_at, end_at) 
  WHERE status = 'active';
CREATE INDEX IF NOT EXISTS idx_promotions_target ON promotions(target_type, target_id) 
  WHERE target_id IS NOT NULL;

-- Function to auto-update promotion status
CREATE OR REPLACE FUNCTION update_promotion_status()
RETURNS void AS $$
BEGIN
  -- Activate scheduled promotions
  UPDATE promotions 
  SET status = 'active', updated_at = NOW()
  WHERE status = 'scheduled' AND start_at <= NOW() AND end_at > NOW();
  
  -- Expire active promotions
  UPDATE promotions 
  SET status = 'expired', updated_at = NOW()
  WHERE status = 'active' AND end_at <= NOW();
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- (2) ANALYTICS EVENTS SYSTEM
-- ============================================================================

-- Analytics events table (event stream)
CREATE TABLE IF NOT EXISTS analytics_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id) ON DELETE SET NULL,
  user_id UUID REFERENCES user_profiles(id) ON DELETE SET NULL,
  event_type TEXT NOT NULL CHECK (event_type IN (
    'view_store', 'view_product', 'search_impression', 'click',
    'add_to_cart', 'remove_from_cart', 'checkout', 'order_paid',
    'order_cancelled', 'share', 'follow', 'unfollow'
  )),
  source TEXT DEFAULT 'app' CHECK (source IN ('app', 'web', 'api')),
  promotion_id UUID REFERENCES promotions(id) ON DELETE SET NULL,
  meta JSONB DEFAULT '{}', -- device, locale, query, referrer, etc.
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for analytics_events (optimized for time-series queries)
CREATE INDEX IF NOT EXISTS idx_analytics_events_store_time ON analytics_events(store_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_analytics_events_product_time ON analytics_events(product_id, created_at DESC) 
  WHERE product_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_analytics_events_type ON analytics_events(event_type, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_analytics_events_promotion ON analytics_events(promotion_id, created_at DESC) 
  WHERE promotion_id IS NOT NULL;
-- Note: For date-based queries, use created_at with date range instead of DATE() function

-- Partitioning hint: Consider partitioning by month for large datasets
-- CREATE TABLE analytics_events_2025_12 PARTITION OF analytics_events FOR VALUES FROM ('2025-12-01') TO ('2026-01-01');

-- ============================================================================
-- (3) ANALYTICS DAILY ROLLUPS
-- ============================================================================

-- Daily aggregated analytics
CREATE TABLE IF NOT EXISTS analytics_daily_rollups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  date DATE NOT NULL,
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  promotion_id UUID REFERENCES promotions(id) ON DELETE CASCADE,
  
  -- Metrics
  views INTEGER DEFAULT 0,
  clicks INTEGER DEFAULT 0,
  impressions INTEGER DEFAULT 0,
  add_to_cart INTEGER DEFAULT 0,
  orders INTEGER DEFAULT 0,
  revenue DECIMAL(12, 2) DEFAULT 0,
  
  -- Computed rates
  ctr DECIMAL(5, 4) DEFAULT 0, -- Click-through rate
  conversion_rate DECIMAL(5, 4) DEFAULT 0, -- Orders / Views
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Unique constraint using nullable columns directly
  UNIQUE(date, store_id, product_id, promotion_id)
);

-- Indexes for rollups
CREATE INDEX IF NOT EXISTS idx_rollups_date ON analytics_daily_rollups(date DESC);
CREATE INDEX IF NOT EXISTS idx_rollups_store_date ON analytics_daily_rollups(store_id, date DESC);
CREATE INDEX IF NOT EXISTS idx_rollups_promotion ON analytics_daily_rollups(promotion_id, date DESC) 
  WHERE promotion_id IS NOT NULL;

-- Function to generate daily rollups
CREATE OR REPLACE FUNCTION generate_daily_rollups(target_date DATE DEFAULT CURRENT_DATE - 1)
RETURNS INTEGER AS $$
DECLARE
  rows_inserted INTEGER;
BEGIN
  -- Delete existing rollups for this date first, then insert new ones
  DELETE FROM analytics_daily_rollups WHERE date = target_date;
  
  -- Insert rollups for the target date
  INSERT INTO analytics_daily_rollups (date, store_id, product_id, promotion_id, views, clicks, impressions, add_to_cart, orders, revenue, ctr, conversion_rate)
  SELECT 
    target_date,
    store_id,
    product_id,
    promotion_id,
    COUNT(*) FILTER (WHERE event_type IN ('view_store', 'view_product')) as views,
    COUNT(*) FILTER (WHERE event_type = 'click') as clicks,
    COUNT(*) FILTER (WHERE event_type = 'search_impression') as impressions,
    COUNT(*) FILTER (WHERE event_type = 'add_to_cart') as add_to_cart,
    COUNT(*) FILTER (WHERE event_type = 'order_paid') as orders,
    COALESCE(SUM(CASE WHEN event_type = 'order_paid' THEN (meta->>'amount')::DECIMAL ELSE 0 END), 0) as revenue,
    CASE WHEN COUNT(*) FILTER (WHERE event_type = 'search_impression') > 0 
         THEN COUNT(*) FILTER (WHERE event_type = 'click')::DECIMAL / COUNT(*) FILTER (WHERE event_type = 'search_impression') 
         ELSE 0 END as ctr,
    CASE WHEN COUNT(*) FILTER (WHERE event_type IN ('view_store', 'view_product')) > 0 
         THEN COUNT(*) FILTER (WHERE event_type = 'order_paid')::DECIMAL / COUNT(*) FILTER (WHERE event_type IN ('view_store', 'view_product')) 
         ELSE 0 END as conversion_rate
  FROM analytics_events
  WHERE DATE(created_at) = target_date
  GROUP BY store_id, product_id, promotion_id;
  
  GET DIAGNOSTICS rows_inserted = ROW_COUNT;
  RETURN rows_inserted;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- (4) PROMOTION REPORTS SYSTEM
-- ============================================================================

-- Promotion reports table
CREATE TABLE IF NOT EXISTS promotion_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  promotion_id UUID NOT NULL REFERENCES promotions(id) ON DELETE CASCADE,
  report_date DATE, -- NULL for final/on-demand reports
  report_type TEXT NOT NULL CHECK (report_type IN ('daily', 'final', 'on_demand')),
  pdf_url TEXT, -- R2/Storage URL
  summary_json JSONB DEFAULT '{}', -- Quick access to report data
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for reports
CREATE INDEX IF NOT EXISTS idx_reports_promotion ON promotion_reports(promotion_id, report_type);
CREATE INDEX IF NOT EXISTS idx_reports_date ON promotion_reports(report_date DESC) WHERE report_date IS NOT NULL;

-- ============================================================================
-- (5) AUDIT LOGS SYSTEM
-- ============================================================================

-- Audit logs table
CREATE TABLE IF NOT EXISTS audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
  actor_user_id UUID REFERENCES user_profiles(id) ON DELETE SET NULL,
  action TEXT NOT NULL CHECK (action IN (
    'product_create', 'product_update', 'product_delete', 'product_restore',
    'inventory_adjust', 'inventory_restock',
    'promotion_create', 'promotion_cancel', 'promotion_end',
    'store_update', 'store_settings_update',
    'order_create', 'order_update', 'order_cancel', 'order_complete',
    'user_login', 'user_logout', 'password_change',
    'shortcut_add', 'shortcut_remove', 'shortcut_reorder'
  )),
  entity_type TEXT NOT NULL CHECK (entity_type IN (
    'product', 'promotion', 'inventory', 'store', 'order', 'user', 'shortcut'
  )),
  entity_id UUID,
  severity TEXT DEFAULT 'info' CHECK (severity IN ('info', 'warning', 'critical')),
  meta JSONB DEFAULT '{}', -- before/after, diff, reason, ip, user_agent
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for audit logs
CREATE INDEX IF NOT EXISTS idx_audit_store_time ON audit_logs(store_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_action ON audit_logs(action, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_severity ON audit_logs(severity, created_at DESC) WHERE severity != 'info';
CREATE INDEX IF NOT EXISTS idx_audit_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_audit_actor ON audit_logs(actor_user_id, created_at DESC);

-- Function to create audit log
CREATE OR REPLACE FUNCTION create_audit_log(
  p_store_id UUID,
  p_actor_id UUID,
  p_action TEXT,
  p_entity_type TEXT,
  p_entity_id UUID,
  p_severity TEXT DEFAULT 'info',
  p_meta JSONB DEFAULT '{}'
)
RETURNS UUID AS $$
DECLARE
  log_id UUID;
BEGIN
  INSERT INTO audit_logs (store_id, actor_user_id, action, entity_type, entity_id, severity, meta)
  VALUES (p_store_id, p_actor_id, p_action, p_entity_type, p_entity_id, p_severity, p_meta)
  RETURNING id INTO log_id;
  
  RETURN log_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- (6) INVENTORY MOVEMENTS SYSTEM
-- ============================================================================

-- Add stock thresholds to products if not exists
ALTER TABLE products ADD COLUMN IF NOT EXISTS stock_threshold INTEGER DEFAULT 5;
ALTER TABLE products ADD COLUMN IF NOT EXISTS stock_alert_enabled BOOLEAN DEFAULT true;

-- Inventory movements table
CREATE TABLE IF NOT EXISTS inventory_movements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  delta INTEGER NOT NULL, -- Positive = add, Negative = remove
  stock_before INTEGER NOT NULL,
  stock_after INTEGER NOT NULL,
  reason TEXT NOT NULL CHECK (reason IN (
    'manual_adjust', 'order_reserved', 'order_paid', 'order_cancelled',
    'restock', 'return', 'damage', 'initial'
  )),
  reference_type TEXT CHECK (reference_type IN ('order', 'manual', 'import', 'return')),
  reference_id UUID, -- Order ID or import batch ID
  actor_user_id UUID REFERENCES user_profiles(id) ON DELETE SET NULL,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for inventory movements
CREATE INDEX IF NOT EXISTS idx_inventory_product ON inventory_movements(product_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_inventory_store ON inventory_movements(store_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_inventory_reason ON inventory_movements(reason, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_inventory_reference ON inventory_movements(reference_type, reference_id) 
  WHERE reference_id IS NOT NULL;

-- Function to adjust inventory with movement tracking
CREATE OR REPLACE FUNCTION adjust_inventory(
  p_product_id UUID,
  p_delta INTEGER,
  p_reason TEXT,
  p_actor_id UUID,
  p_reference_type TEXT DEFAULT NULL,
  p_reference_id UUID DEFAULT NULL,
  p_notes TEXT DEFAULT NULL
)
RETURNS TABLE (
  movement_id UUID,
  new_stock INTEGER,
  alert_triggered BOOLEAN
) AS $$
DECLARE
  v_product RECORD;
  v_movement_id UUID;
  v_new_stock INTEGER;
  v_alert BOOLEAN := false;
BEGIN
  -- Get product with lock
  SELECT id, store_id, stock, stock_threshold, stock_alert_enabled 
  INTO v_product
  FROM products 
  WHERE id = p_product_id
  FOR UPDATE;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Product not found: %', p_product_id;
  END IF;
  
  -- Calculate new stock
  v_new_stock := GREATEST(0, v_product.stock + p_delta);
  
  -- Update product stock
  UPDATE products SET stock = v_new_stock, updated_at = NOW() WHERE id = p_product_id;
  
  -- Create movement record
  INSERT INTO inventory_movements (
    store_id, product_id, delta, stock_before, stock_after, 
    reason, reference_type, reference_id, actor_user_id, notes
  ) VALUES (
    v_product.store_id, p_product_id, p_delta, v_product.stock, v_new_stock,
    p_reason, p_reference_type, p_reference_id, p_actor_id, p_notes
  ) RETURNING id INTO v_movement_id;
  
  -- Check if alert should be triggered
  IF v_product.stock_alert_enabled AND v_new_stock <= v_product.stock_threshold AND v_product.stock > v_product.stock_threshold THEN
    v_alert := true;
    -- Could trigger notification here
  END IF;
  
  RETURN QUERY SELECT v_movement_id, v_new_stock, v_alert;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- (7) MERCHANT SHORTCUTS SYSTEM
-- ============================================================================

-- Store settings table for shortcuts and other settings
CREATE TABLE IF NOT EXISTS store_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL UNIQUE REFERENCES stores(id) ON DELETE CASCADE,
  
  -- Shortcuts configuration
  shortcuts JSONB DEFAULT '[]', -- [{id, title, route, iconKey, enabled, order}]
  
  -- Other settings can be added here
  notification_settings JSONB DEFAULT '{}',
  display_settings JSONB DEFAULT '{}',
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for store_settings
CREATE INDEX IF NOT EXISTS idx_store_settings_store ON store_settings(store_id);

-- Available shortcuts/actions (managed by admin, read by merchants)
CREATE TABLE IF NOT EXISTS available_shortcuts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key TEXT UNIQUE NOT NULL, -- Unique identifier
  title TEXT NOT NULL,
  title_ar TEXT NOT NULL,
  description TEXT,
  route TEXT NOT NULL, -- Route path in the app
  icon_key TEXT NOT NULL, -- Flutter icon name
  category TEXT DEFAULT 'general', -- Category for grouping
  is_enabled BOOLEAN DEFAULT true, -- Admin can disable
  requires_premium BOOLEAN DEFAULT false,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert default available shortcuts
INSERT INTO available_shortcuts (key, title, title_ar, route, icon_key, category, sort_order) VALUES
  ('add_product', 'Add Product', 'إضافة منتج', '/dashboard/products/add', 'add_box', 'products', 1),
  ('view_orders', 'View Orders', 'عرض الطلبات', '/dashboard/orders', 'shopping_bag', 'orders', 2),
  ('view_analytics', 'Analytics', 'التحليلات', '/dashboard/analytics', 'analytics', 'analytics', 3),
  ('boost_store', 'Boost Store', 'ضاعف ظهورك', '/dashboard/boost-sales', 'rocket_launch', 'marketing', 4),
  ('view_inventory', 'Inventory', 'المخزون', '/dashboard/inventory', 'inventory', 'products', 5),
  ('create_promotion', 'Create Promotion', 'إنشاء حملة', '/dashboard/promotions/create', 'campaign', 'marketing', 6),
  ('view_customers', 'Customers', 'العملاء', '/dashboard/customers', 'people', 'customers', 7),
  ('store_settings', 'Store Settings', 'إعدادات المتجر', '/dashboard/store', 'settings', 'settings', 8),
  ('view_audit_logs', 'Audit Logs', 'السجلات', '/dashboard/audit-logs', 'history', 'settings', 9),
  ('marketing', 'Marketing', 'التسويق', '/dashboard/marketing', 'campaign', 'marketing', 10),
  ('mbuy_studio', 'Mbuy Studio', 'Mbuy Studio', '/dashboard/studio', 'auto_awesome', 'tools', 11),
  ('mbuy_tools', 'Mbuy Tools', 'Mbuy Tools', '/dashboard/tools', 'build', 'tools', 12)
ON CONFLICT (key) DO UPDATE SET
  title = EXCLUDED.title,
  title_ar = EXCLUDED.title_ar,
  route = EXCLUDED.route,
  icon_key = EXCLUDED.icon_key,
  category = EXCLUDED.category,
  sort_order = EXCLUDED.sort_order;

-- ============================================================================
-- (8) RLS POLICIES
-- ============================================================================

-- Enable RLS on new tables
ALTER TABLE promotions ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics_daily_rollups ENABLE ROW LEVEL SECURITY;
ALTER TABLE promotion_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE store_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE available_shortcuts ENABLE ROW LEVEL SECURITY;

-- Promotions policies
CREATE POLICY "promotions_select_own" ON promotions FOR SELECT
  USING (store_id IN (SELECT id FROM stores WHERE owner_id = auth.uid()));

CREATE POLICY "promotions_insert_own" ON promotions FOR INSERT
  WITH CHECK (store_id IN (SELECT id FROM stores WHERE owner_id = auth.uid()));

CREATE POLICY "promotions_update_own" ON promotions FOR UPDATE
  USING (store_id IN (SELECT id FROM stores WHERE owner_id = auth.uid()));

-- Analytics events policies (merchants can read their store's events)
CREATE POLICY "analytics_events_select_own" ON analytics_events FOR SELECT
  USING (store_id IN (SELECT id FROM stores WHERE owner_id = auth.uid()));

-- Analytics rollups policies
CREATE POLICY "analytics_rollups_select_own" ON analytics_daily_rollups FOR SELECT
  USING (store_id IN (SELECT id FROM stores WHERE owner_id = auth.uid()));

-- Promotion reports policies
CREATE POLICY "promotion_reports_select_own" ON promotion_reports FOR SELECT
  USING (promotion_id IN (
    SELECT id FROM promotions WHERE store_id IN (
      SELECT id FROM stores WHERE owner_id = auth.uid()
    )
  ));

-- Audit logs policies
CREATE POLICY "audit_logs_select_own" ON audit_logs FOR SELECT
  USING (store_id IN (SELECT id FROM stores WHERE owner_id = auth.uid()));

-- Inventory movements policies
CREATE POLICY "inventory_movements_select_own" ON inventory_movements FOR SELECT
  USING (store_id IN (SELECT id FROM stores WHERE owner_id = auth.uid()));

-- Store settings policies
CREATE POLICY "store_settings_select_own" ON store_settings FOR SELECT
  USING (store_id IN (SELECT id FROM stores WHERE owner_id = auth.uid()));

CREATE POLICY "store_settings_update_own" ON store_settings FOR UPDATE
  USING (store_id IN (SELECT id FROM stores WHERE owner_id = auth.uid()));

CREATE POLICY "store_settings_insert_own" ON store_settings FOR INSERT
  WITH CHECK (store_id IN (SELECT id FROM stores WHERE owner_id = auth.uid()));

-- Available shortcuts (public read)
CREATE POLICY "available_shortcuts_select_all" ON available_shortcuts FOR SELECT
  USING (true);

-- ============================================================================
-- (9) SERVICE ROLE POLICIES (for Worker)
-- ============================================================================

-- Allow service role to insert analytics events
CREATE POLICY "analytics_events_service_insert" ON analytics_events FOR INSERT
  WITH CHECK (true);

-- Allow service role to manage audit logs
CREATE POLICY "audit_logs_service_insert" ON audit_logs FOR INSERT
  WITH CHECK (true);

-- Allow service role to manage inventory movements
CREATE POLICY "inventory_movements_service_all" ON inventory_movements FOR ALL
  USING (true);

-- Allow service role to manage rollups
CREATE POLICY "analytics_rollups_service_all" ON analytics_daily_rollups FOR ALL
  USING (true);

-- Allow service role to manage promotion reports
CREATE POLICY "promotion_reports_service_all" ON promotion_reports FOR ALL
  USING (true);

-- Allow service role to update promotion status
CREATE POLICY "promotions_service_update" ON promotions FOR UPDATE
  USING (true);

-- ============================================================================
-- (10) SCHEDULED FUNCTIONS (to be called by Worker cron)
-- ============================================================================

-- Function to run all daily maintenance tasks
CREATE OR REPLACE FUNCTION run_daily_maintenance()
RETURNS JSONB AS $$
DECLARE
  result JSONB := '{}';
  rollups_count INTEGER;
BEGIN
  -- Update promotion statuses
  PERFORM update_promotion_status();
  
  -- Generate yesterday's rollups
  rollups_count := generate_daily_rollups(CURRENT_DATE - 1);
  
  result := jsonb_build_object(
    'date', CURRENT_DATE,
    'rollups_generated', rollups_count,
    'promotions_updated', true
  );
  
  RETURN result;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- MIGRATION COMPLETE
-- ============================================================================
-- Run this SQL in Supabase SQL Editor
-- After running, deploy the Worker with new endpoints
-- ============================================================================
