-- ============================================================================
-- MBUY Additional Tables Migration
-- Version: 1.0.1
-- Date: 2025-12-14
-- 
-- This migration adds:
-- 1. Notifications table
-- 2. Customers/Followers table
-- ============================================================================

-- ============================================================================
-- (1) NOTIFICATIONS SYSTEM
-- ============================================================================

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  body TEXT,
  type TEXT NOT NULL DEFAULT 'general' CHECK (type IN (
    'general', 'order', 'product', 'payment', 'promotion', 'system', 'chat'
  )),
  data JSONB DEFAULT '{}', -- Additional data like order_id, product_id, etc.
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for notifications
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON notifications(user_id, is_read) WHERE is_read = false;

-- Enable RLS
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "notifications_select_own" ON notifications FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "notifications_update_own" ON notifications FOR UPDATE
  USING (user_id = auth.uid());

CREATE POLICY "notifications_delete_own" ON notifications FOR DELETE
  USING (user_id = auth.uid());

-- Service role can insert
CREATE POLICY "notifications_service_insert" ON notifications FOR INSERT
  WITH CHECK (true);

-- ============================================================================
-- (2) STORE FOLLOWERS/CUSTOMERS SYSTEM
-- ============================================================================

-- Store followers (customers who follow a store)
CREATE TABLE IF NOT EXISTS store_followers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  followed_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(store_id, user_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_store_followers_store ON store_followers(store_id);
CREATE INDEX IF NOT EXISTS idx_store_followers_user ON store_followers(user_id);

-- Enable RLS
ALTER TABLE store_followers ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "store_followers_select_all" ON store_followers FOR SELECT
  USING (true);

CREATE POLICY "store_followers_insert_own" ON store_followers FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "store_followers_delete_own" ON store_followers FOR DELETE
  USING (user_id = auth.uid());

-- ============================================================================
-- (3) STORE CUSTOMERS VIEW (combines orders and followers)
-- ============================================================================

-- This is a view that shows all customers who have interacted with a store
CREATE OR REPLACE VIEW store_customers AS
SELECT DISTINCT
  s.id as store_id,
  up.id as customer_id,
  up.full_name as customer_name,
  up.phone as customer_phone,
  up.email as customer_email,
  up.avatar_url as customer_avatar,
  COALESCE(order_stats.total_orders, 0) as total_orders,
  COALESCE(order_stats.total_spent, 0) as total_spent,
  order_stats.last_order_date,
  sf.followed_at as follow_date,
  CASE WHEN sf.id IS NOT NULL THEN true ELSE false END as is_follower
FROM stores s
CROSS JOIN user_profiles up
LEFT JOIN store_followers sf ON sf.store_id = s.id AND sf.user_id = up.id
LEFT JOIN LATERAL (
  SELECT 
    COUNT(*) as total_orders,
    SUM(total_amount) as total_spent,
    MAX(created_at) as last_order_date
  FROM orders 
  WHERE orders.store_id = s.id AND orders.customer_id = up.id
) order_stats ON true
WHERE sf.id IS NOT NULL OR order_stats.total_orders > 0;

-- ============================================================================
-- MIGRATION COMPLETE
-- Run this SQL in Supabase SQL Editor after the main migration
-- ============================================================================
