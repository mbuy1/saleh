-- ============================================================================
-- AUTOMATIC STORE_ID SYNC TRIGGER
-- ============================================================================
-- هذا السكربت ينشئ Trigger في قاعدة البيانات لضمان نسخ store_id تلقائياً
-- من جدول stores إلى جدول user_profiles بمجرد إنشاء المتجر أو تحديثه.
-- هذا يحل المشكلة من جذورها ولا يعتمد على الكود البرمجي.

-- 1. إنشاء دالة المزامنة (Function)
CREATE OR REPLACE FUNCTION public.sync_store_id_to_profile()
RETURNS TRIGGER AS $$
BEGIN
  -- إذا تم إنشاء متجر جديد أو تحديث مالك المتجر
  -- قم بتحديث store_id في جدول user_profiles للمالك
  IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE' AND NEW.owner_id IS DISTINCT FROM OLD.owner_id) THEN
    UPDATE public.user_profiles
    SET store_id = NEW.id,
        updated_at = NOW()
    WHERE id = NEW.owner_id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. إنشاء التريجر (Trigger)
DROP TRIGGER IF EXISTS trigger_sync_store_id ON public.stores;

CREATE TRIGGER trigger_sync_store_id
AFTER INSERT OR UPDATE OF owner_id ON public.stores
FOR EACH ROW
EXECUTE FUNCTION public.sync_store_id_to_profile();

-- ============================================================================
-- 3. إصلاح البيانات القديمة (Backfill)
-- ============================================================================
-- تشغيل هذا الاستعلام مرة واحدة لضمان أن جميع المستخدمين الحاليين لديهم store_id صحيح
UPDATE public.user_profiles up
SET store_id = s.id
FROM public.stores s
WHERE s.owner_id = up.id
  AND (up.store_id IS NULL OR up.store_id != s.id);

-- ============================================================================
-- التحقق من النتيجة
-- ============================================================================
SELECT 
  up.email,
  up.role,
  up.store_id AS profile_store_id,
  s.id AS actual_store_id,
  CASE 
    WHEN up.store_id = s.id THEN '✅ Synced'
    ELSE '❌ Not Synced'
  END AS status
FROM public.user_profiles up
JOIN public.stores s ON s.owner_id = up.id;
