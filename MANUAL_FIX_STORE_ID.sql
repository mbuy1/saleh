-- ============================================================================
-- MANUAL FIX FOR STORE_ID (إصلاح يدوي مباشر)
-- ============================================================================

-- 1️⃣ ضع بريد التاجر هنا بدلاً من 'YOUR_EMAIL_HERE'
\set email 'baharista1@gmail.com'

-- أو قم بتعديل السطر أدناه مباشرة إذا لم يعمل المتغير
-- WHERE up.email = 'test@example.com';

DO $$
DECLARE
    target_email TEXT := 'YOUR_EMAIL_HERE'; -- 👈 ضع البريد هنا
    v_user_id UUID;
    v_store_id UUID;
BEGIN
    -- 1. الحصول على معرف المستخدم
    SELECT id INTO v_user_id FROM auth.users WHERE email = target_email;
    
    IF v_user_id IS NULL THEN
        RAISE NOTICE '❌ User not found with email: %', target_email;
        RETURN;
    END IF;

    -- 2. الحصول على معرف المتجر المملوك لهذا المستخدم
    SELECT id INTO v_store_id FROM public.stores WHERE owner_id = (SELECT id FROM public.user_profiles WHERE email = target_email);

    IF v_store_id IS NULL THEN
        RAISE NOTICE '❌ No store found for user: %', target_email;
        -- محاولة إنشاء متجر إذا لم يوجد (اختياري)
        -- INSERT INTO public.stores ...
        RETURN;
    END IF;

    -- 3. تحديث store_id في user_profiles بالقوة
    UPDATE public.user_profiles
    SET store_id = v_store_id,
        updated_at = NOW()
    WHERE email = target_email;

    RAISE NOTICE '✅ SUCCESS: Linked User % to Store %', target_email, v_store_id;
END $$;

-- ============================================================================
-- التحقق النهائي (Final Check)
-- ============================================================================
SELECT 
    up.email,
    up.store_id AS "Profile Store ID",
    s.id AS "Actual Store ID",
    CASE WHEN up.store_id = s.id THEN '✅ OK' ELSE '❌ MISMATCH' END AS status
FROM public.user_profiles up
LEFT JOIN public.stores s ON s.owner_id = up.id
WHERE up.email = 'YOUR_EMAIL_HERE'; -- 👈 ضع البريد هنا أيضاً
