-- ============================================================================
-- MBUY - Clear All Data Script
-- ============================================================================
-- Execute this in Supabase SQL Editor to delete all old data
-- This will clear all orders, wallets, points, and related transactions
-- ============================================================================

BEGIN;

-- Clear transaction tables first (child tables)
DELETE FROM wallet_transactions;
DELETE FROM points_transactions;
DELETE FROM order_items;

-- Clear main tables
DELETE FROM orders;
DELETE FROM wallets;
DELETE FROM points_accounts;

COMMIT;

-- Verify deletion - should all show 0
SELECT 'orders' as table_name, COUNT(*) as remaining_records FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'wallets', COUNT(*) FROM wallets
UNION ALL
SELECT 'wallet_transactions', COUNT(*) FROM wallet_transactions
UNION ALL
SELECT 'points_accounts', COUNT(*) FROM points_accounts
UNION ALL
SELECT 'points_transactions', COUNT(*) FROM points_transactions
ORDER BY table_name;
