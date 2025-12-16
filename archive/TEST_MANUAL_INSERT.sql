-- ============================================================================
-- TEST MANUAL INSERT (محاولة إدخال يدوية بنفس بيانات التطبيق)
-- ============================================================================

DO $$
DECLARE
    v_store_id UUID := '8fa922c4-60f6-42d4-9716-b9e64aebaccc';
    v_category_id UUID := 'f28778b7-56b4-425e-bac9-7fc973c5e977';
    v_exists BOOLEAN;
BEGIN
    -- 1. التحقق من وجود المتجر
    SELECT EXISTS(SELECT 1 FROM public.stores WHERE id = v_store_id) INTO v_exists;
    IF NOT v_exists THEN
        RAISE EXCEPTION '❌ Store ID % does not exist!', v_store_id;
    ELSE
        RAISE NOTICE '✅ Store exists.';
    END IF;

    -- 2. التحقق من وجود التصنيف (Category)
    SELECT EXISTS(SELECT 1 FROM public.categories WHERE id = v_category_id) INTO v_exists;
    IF NOT v_exists THEN
        RAISE EXCEPTION '❌ Category ID % does not exist!', v_category_id;
    ELSE
        RAISE NOTICE '✅ Category exists.';
    END IF;

    -- 3. محاولة الإدخال (نفس البيانات التي أرسلها التطبيق)
    INSERT INTO public.products (
        store_id,
        category_id,
        name,
        description,
        price,
        stock,
        main_image_url,
        is_active
    ) VALUES (
        v_store_id,
        v_category_id,
        'hcxx',
        'ggv',
        658,
        688,
        NULL, -- main_image_url
        true
    );

    RAISE NOTICE '✅ INSERT SUCCESSFUL! The problem is not in the database constraints.';
    
    -- (اختياري) التراجع عن الإدخال حتى لا يبقى بيانات وهمية
    -- RAISE EXCEPTION 'Test complete, rolling back transaction' USING ERRCODE = 'check_violation';
END $$;
