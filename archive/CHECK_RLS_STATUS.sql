-- التحقق من حالة RLS بعد تطبيق Migration
-- تشغيل هذا الاستعلام في Supabase SQL Editor

-- 1. التحقق من تفعيل RLS على الجداول
SELECT
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
    AND tablename IN (
        'user_profiles', 'stores', 'products', 'categories',
        'orders', 'order_items', 'cart_items', 'wallets',
        'points_accounts', 'coupons'
    )
ORDER BY tablename;

-- 2. التحقق من وجود Policies
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE schemaname = 'public'
    AND tablename IN ('user_profiles', 'products', 'stores')
ORDER BY tablename, policyname;