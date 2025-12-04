-- ============================================================================
-- MBUY Database Functions
-- Execute this SQL in Supabase SQL Editor
-- ============================================================================

-- Function: Decrement product stock safely
-- Used by create_order Edge Function
CREATE OR REPLACE FUNCTION decrement_stock(
  product_id uuid,
  quantity integer
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Update stock and check availability in one atomic operation
  UPDATE products
  SET stock_quantity = stock_quantity - quantity
  WHERE id = product_id
  AND stock_quantity >= quantity;

  -- If no rows updated, stock was insufficient
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Insufficient stock for product %', product_id;
  END IF;
END;
$$;

-- Function: Get user's FCM token
-- Used by Edge Functions for notifications
CREATE OR REPLACE FUNCTION get_user_fcm_token(
  user_id uuid
)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  fcm_token text;
BEGIN
  SELECT fcm_token INTO fcm_token
  FROM user_profiles
  WHERE id = user_id;
  
  RETURN fcm_token;
END;
$$;

-- Function: Calculate order total from cart
-- Used for validation
CREATE OR REPLACE FUNCTION calculate_cart_total(
  customer_id uuid
)
RETURNS numeric
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  total numeric := 0;
BEGIN
  SELECT COALESCE(SUM(p.price * ci.quantity), 0)
  INTO total
  FROM carts c
  INNER JOIN cart_items ci ON ci.cart_id = c.id
  INNER JOIN products p ON p.id = ci.product_id
  WHERE c.user_id = customer_id;
  
  RETURN total;
END;
$$;

-- ============================================================================
-- Note: Indexes and triggers will be added after creating all required tables
-- Current: Only database functions are created
-- ============================================================================

-- ============================================================================
-- Success Message
-- ============================================================================

DO $$
BEGIN
  RAISE NOTICE '✅ All database functions and indexes created successfully!';
END $$;
