# 🚀 تطبيق إصلاح التسجيل - خطوة بخطوة

## ⚠️ مهم: هذا الإصلاح يُطبّق يدوياً في Supabase Dashboard

---

## الخطوة 1️⃣: افتح Supabase Dashboard

1. اذهب إلى: https://supabase.com/dashboard
2. اختر مشروع: `sirqidofuvphqcxqchyc`
3. انتقل إلى: **SQL Editor**

---

## الخطوة 2️⃣: نفّذ التشخيص

انسخ والصق الكود التالي:

```sql
-- ============================================================================
-- DIAGNOSTIC: Check Registration Issue
-- ============================================================================

-- 1️⃣ Check trigger status
SELECT 
  '1️⃣ Trigger' AS check_name,
  tgname,
  CASE tgenabled
    WHEN 'O' THEN '✅ Enabled'
    WHEN 'D' THEN '❌ Disabled'
  END AS status
FROM pg_trigger 
WHERE tgname = 'on_auth_user_created';

-- 2️⃣ Check function
SELECT 
  '2️⃣ Function' AS check_name,
  proname,
  CASE prosecdef 
    WHEN true THEN '✅ SECURITY DEFINER'
    ELSE '❌ Not SECURITY DEFINER'
  END AS security
FROM pg_proc 
WHERE proname = 'handle_new_auth_user';

-- 3️⃣ Check RLS
SELECT 
  '3️⃣ RLS' AS check_name,
  tablename,
  CASE rowsecurity 
    WHEN true THEN '🔒 Enabled'
    ELSE '🔓 Disabled'
  END AS status
FROM pg_tables 
WHERE tablename = 'user_profiles';

-- 4️⃣ Check policies
SELECT 
  '4️⃣ Policies' AS check_name,
  policyname,
  roles
FROM pg_policies 
WHERE tablename = 'user_profiles';

-- 5️⃣ Test INSERT (this will likely FAIL before fix)
DO $$
DECLARE
  test_id UUID := gen_random_uuid();
BEGIN
  BEGIN
    INSERT INTO public.user_profiles (
      auth_user_id, email, display_name, role
    ) VALUES (
      test_id, 'test@example.com', 'Test', 'customer'
    );
    
    DELETE FROM public.user_profiles WHERE auth_user_id = test_id;
    RAISE NOTICE '✅ INSERT works';
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '❌ INSERT failed: %', SQLERRM;
  END;
END $$;
```

**توقّع النتائج:**
- ✅ Trigger enabled
- ✅ Function is SECURITY DEFINER
- 🔒 RLS enabled
- ⚠️ Few or no policies
- ❌ **INSERT test fails** ← هذا سبب المشكلة!

---

## الخطوة 3️⃣: طبّق الإصلاح

انسخ والصق الكود التالي (ملف كامل):

```sql
-- ============================================================================
-- FIX: Registration RLS Issue
-- ============================================================================

-- Grant permissions
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON public.user_profiles TO postgres, service_role;
GRANT SELECT, INSERT, UPDATE ON public.user_profiles TO authenticated;
GRANT SELECT ON public.user_profiles TO anon;

-- Drop existing service_role policy
DROP POLICY IF EXISTS "Service role has full access to user_profiles" 
  ON public.user_profiles;

-- Create service_role bypass policy
CREATE POLICY "Service role has full access to user_profiles"
  ON public.user_profiles
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Drop existing self-insert policy
DROP POLICY IF EXISTS "Users can insert own profile during registration" 
  ON public.user_profiles;

-- Create self-insert policy
CREATE POLICY "Users can insert own profile during registration"
  ON public.user_profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth_user_id = auth.uid());

-- Verify
DO $$ 
BEGIN
  RAISE NOTICE '✅ Registration RLS Fix Applied';
  RAISE NOTICE 'Policies created:';
  RAISE NOTICE '1. Service role bypass';
  RAISE NOTICE '2. Authenticated self-insert';
END $$;
```

**انقر: Run** (في أعلى اليمين)

**توقّع النتيجة:**
```
✅ Registration RLS Fix Applied
Policies created:
1. Service role bypass
2. Authenticated self-insert
```

---

## الخطوة 4️⃣: تحقق من الإصلاح

انسخ والصق الكود التالي:

```sql
-- Verify fix worked
DO $$
DECLARE
  test_id UUID := gen_random_uuid();
  success BOOLEAN := false;
BEGIN
  BEGIN
    -- Try INSERT
    INSERT INTO public.user_profiles (
      auth_user_id, email, display_name, role
    ) VALUES (
      test_id, 'test-verify@example.com', 'Test Verify', 'customer'
    );
    
    success := true;
    
    -- Cleanup
    DELETE FROM public.user_profiles WHERE auth_user_id = test_id;
    
    RAISE NOTICE '✅ SUCCESS: Trigger can now insert into user_profiles';
    RAISE NOTICE 'Registration should work!';
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '❌ STILL FAILING: %', SQLERRM;
    RAISE NOTICE 'Check permissions and policies again';
  END;
END $$;
```

**توقّع النتيجة:**
```
✅ SUCCESS: Trigger can now insert into user_profiles
Registration should work!
```

---

## الخطوة 5️⃣: اختبر التسجيل عبر API

افتح **PowerShell** وانسخ:

```powershell
# Test registration
$body = @{
    email = "test-dashboard-fix@mbuy.com"
    password = "test123456"
    full_name = "Dashboard Fix Test"
    role = "customer"
} | ConvertTo-Json

Invoke-WebRequest `
  -Uri "https://misty-mode-b68b.baharista1.workers.dev/auth/supabase/register" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body $body
```

**توقّع النتيجة:**
```json
{
  "success": true,
  "message": "User registered and logged in successfully",
  "user": {
    "id": "...",
    "email": "test-dashboard-fix@mbuy.com"
  },
  "profile": {
    "role": "customer",
    "display_name": "Dashboard Fix Test"
  }
}
```

---

## الخطوة 6️⃣: تحقق من user_profiles

في **Supabase Dashboard → Table Editor → user_profiles**:

```sql
SELECT 
  id,
  auth_user_id,
  email,
  display_name,
  role,
  created_at
FROM user_profiles
WHERE email = 'test-dashboard-fix@mbuy.com';
```

**يجب أن ترى:**
- Row موجود ✅
- `auth_user_id` له قيمة (UUID) ✅
- `display_name` = "Dashboard Fix Test" ✅
- `role` = "customer" ✅

---

## ✅ علامات النجاح

| الفحص | الحالة المطلوبة |
|-------|-----------------|
| 🔧 Trigger enabled | ✅ |
| 🔧 Function SECURITY DEFINER | ✅ |
| 🔒 RLS enabled | ✅ |
| 📋 Service role policy exists | ✅ |
| 📋 Self-insert policy exists | ✅ |
| 🧪 INSERT test succeeds | ✅ |
| 🌐 API registration works | ✅ |
| 📊 Profile created in DB | ✅ |

---

## 🚨 إذا فشل التسجيل بعد الإصلاح

### احتمال 1: الـ Trigger معطّل

```sql
ALTER TABLE auth.users ENABLE TRIGGER on_auth_user_created;
```

### احتمال 2: الـ Function مفقودة

أعد تطبيق:
```sql
-- من ملف: 20251211120001_auto_create_user_profile_trigger.sql
-- نسخ الـ function والـ trigger من الملف
```

### احتمال 3: Policies لم تُطبّق

```sql
-- تحقق من الـ policies
SELECT policyname FROM pg_policies WHERE tablename = 'user_profiles';

-- يجب أن ترى على الأقل:
-- "Service role has full access to user_profiles"
-- "Users can insert own profile during registration"
```

---

## 📞 الدعم

إذا استمرت المشكلة:
1. ✅ تأكد من تطبيق **جميع** أوامر SQL في الخطوة 3
2. ✅ تحقق من نتائج التشخيص في الخطوة 2
3. ✅ راجع Supabase logs: Dashboard → Logs → Postgres Logs

---

**آخر تحديث:** 2025-12-12  
**الإصدار:** Golden Plan v1.0  
**الحالة:** جاهز للتطبيق ✅
