-- Migration: Add Order Status Tracking
-- Created: 2025-12-05

-- 1. Create order_status_history table
CREATE TABLE IF NOT EXISTS order_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    status TEXT NOT NULL CHECK (status IN ('pending', 'confirmed', 'preparing', 'ready', 'out_for_delivery', 'delivered', 'cancelled')),
    notes TEXT,
    changed_by UUID REFERENCES auth.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Add index for faster queries
CREATE INDEX IF NOT EXISTS idx_order_status_history_order_id ON order_status_history(order_id);
CREATE INDEX IF NOT EXISTS idx_order_status_history_created_at ON order_status_history(created_at DESC);

-- 3. Add RLS policies
ALTER TABLE order_status_history ENABLE ROW LEVEL SECURITY;

-- Customers can view their own order status history
CREATE POLICY "Customers can view own order status history" 
    ON order_status_history 
    FOR SELECT 
    USING (
        EXISTS (
            SELECT 1 FROM orders 
            WHERE orders.id = order_status_history.order_id 
            AND orders.customer_id = auth.uid()
        )
    );

-- Merchants can view their store's order status history
CREATE POLICY "Merchants can view store order status history" 
    ON order_status_history 
    FOR SELECT 
    USING (
        EXISTS (
            SELECT 1 FROM orders o
            JOIN order_items oi ON oi.order_id = o.id
            JOIN products p ON p.id = oi.product_id
            JOIN stores s ON s.id = p.store_id
            WHERE o.id = order_status_history.order_id
            AND s.owner_id = auth.uid()
        )
    );

-- Merchants can insert status updates for their orders
CREATE POLICY "Merchants can update order status" 
    ON order_status_history 
    FOR INSERT 
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM orders o
            JOIN order_items oi ON oi.order_id = o.id
            JOIN products p ON p.id = oi.product_id
            JOIN stores s ON s.id = p.store_id
            WHERE o.id = order_status_history.order_id
            AND s.owner_id = auth.uid()
        )
    );

-- 4. Create function to automatically log initial status
CREATE OR REPLACE FUNCTION log_initial_order_status()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO order_status_history (order_id, status, notes, changed_by)
    VALUES (NEW.id, NEW.status, 'Order created', NEW.customer_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Create trigger
DROP TRIGGER IF EXISTS on_order_created ON orders;
CREATE TRIGGER on_order_created
    AFTER INSERT ON orders
    FOR EACH ROW
    EXECUTE FUNCTION log_initial_order_status();

-- 6. Add notification trigger function
CREATE OR REPLACE FUNCTION notify_order_status_change()
RETURNS TRIGGER AS $$
DECLARE
    order_record RECORD;
    customer_fcm_token TEXT;
    merchant_fcm_token TEXT;
BEGIN
    -- Get order details
    SELECT o.*, s.owner_id as merchant_id
    INTO order_record
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.id
    JOIN products p ON p.id = oi.product_id
    JOIN stores s ON s.id = p.store_id
    WHERE o.id = NEW.order_id
    LIMIT 1;

    -- Get customer FCM token
    SELECT fcm_token INTO customer_fcm_token
    FROM fcm_tokens
    WHERE user_id = order_record.customer_id
    ORDER BY updated_at DESC
    LIMIT 1;

    -- Get merchant FCM token
    SELECT fcm_token INTO merchant_fcm_token
    FROM fcm_tokens
    WHERE user_id = order_record.merchant_id
    ORDER BY updated_at DESC
    LIMIT 1;

    -- TODO: Send FCM notification via Worker API
    -- This will be implemented in the Worker endpoint
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 7. Create trigger for status change notifications
DROP TRIGGER IF EXISTS on_order_status_changed ON order_status_history;
CREATE TRIGGER on_order_status_changed
    AFTER INSERT ON order_status_history
    FOR EACH ROW
    EXECUTE FUNCTION notify_order_status_change();

-- 8. Seed initial history for existing orders
INSERT INTO order_status_history (order_id, status, notes, changed_by)
SELECT 
    id,
    status,
    'Migrated from existing data',
    customer_id
FROM orders
WHERE NOT EXISTS (
    SELECT 1 FROM order_status_history WHERE order_status_history.order_id = orders.id
);
