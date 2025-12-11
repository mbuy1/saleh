# ✅ Checklist: إصلاح مشكلة التسجيل

## 🎯 الهدف
إصلاح خطأ `CREATE_FAILED` عند التسجيل

---

## 📋 القائمة

### المرحلة 1: الإعداد
- [ ] فتح Supabase Dashboard (https://supabase.com/dashboard)
- [ ] اختيار المشروع: `sirqidofuvphqcxqchyc`
- [ ] فتح SQL Editor

### المرحلة 2: التشخيص
- [ ] نسخ كود من `DIAGNOSTIC_registration_issue.sql`
- [ ] تنفيذ في SQL Editor
- [ ] التحقق من النتائج:
  - [ ] Trigger: ✅ Enabled
  - [ ] Function: ✅ SECURITY DEFINER
  - [ ] RLS: 🔒 Enabled
  - [ ] INSERT Test: ❌ Failed (متوقع)

### المرحلة 3: تطبيق الإصلاح
- [ ] نسخ كود من `20251212000001_fix_registration_rls.sql`
- [ ] تنفيذ في SQL Editor
- [ ] التحقق من الرسالة: `✅ Registration RLS Fix Applied`

### المرحلة 4: التحقق
- [ ] تنفيذ Verification query
- [ ] التأكد من: `✅ SUCCESS: Trigger can now insert`

### المرحلة 5: اختبار API
- [ ] فتح PowerShell
- [ ] تنفيذ: `.\test-registration-fix.ps1`
- [ ] التحقق من:
  - [ ] ✅ Test 1: Customer Registration
  - [ ] ✅ Test 2: User Login
  - [ ] ✅ Test 3: Merchant Registration

### المرحلة 6: التحقق النهائي
- [ ] فتح Table Editor → user_profiles
- [ ] التحقق من وجود test users
- [ ] التأكد من صحة البيانات:
  - [ ] `auth_user_id` موجود
  - [ ] `role` صحيح (customer/merchant)
  - [ ] `display_name` مطابق

---

## ✅ معايير النجاح

### Database:
- [x] Trigger enabled
- [x] Function is SECURITY DEFINER
- [x] RLS enabled with policies
- [x] Service role has bypass policy
- [x] Authenticated can self-insert

### API:
- [ ] Registration returns `success: true`
- [ ] Profile created with correct role
- [ ] Login works after registration
- [ ] JWT token returned

### Data:
- [ ] user_profiles row exists
- [ ] auth_user_id matches auth.users.id
- [ ] Role matches request
- [ ] Display name matches request

---

## 🚨 إذا فشل أي اختبار

### INSERT Test Failed:
```sql
-- Check permissions
SELECT grantee, privilege_type 
FROM information_schema.table_privileges
WHERE table_name = 'user_profiles'
AND grantee IN ('postgres', 'service_role');
```

### API Test Failed:
```powershell
# Check Worker logs
cd c:\muath
npx wrangler tail --format pretty
```

### Profile Not Created:
```sql
-- Check trigger status
SELECT tgname, tgenabled 
FROM pg_trigger 
WHERE tgname = 'on_auth_user_created';

-- If disabled, enable it:
ALTER TABLE auth.users ENABLE TRIGGER on_auth_user_created;
```

---

## 📊 تقدم العمل

```
[████████████████████████████████████████] 100%

✅ Phase 1: Flutter Auth Fix
✅ Phase 2: Edge Functions Deprecation
✅ Phase 3: Legacy Code Archival
🔄 Phase 4: Registration Fix (IN PROGRESS)
⏳ Phase 5: RLS Policies
⏳ Phase 6: Testing
```

---

## 🎯 الخطوة التالية بعد الإكمال

عند إكمال جميع النقاط أعلاه:

```
✅ Registration Fix Complete

Next Step: Apply RLS Policies
File: 20251212000000_comprehensive_rls_policies.sql
Time: 10-15 minutes
```

---

**تاريخ البدء:** __________  
**تاريخ الإكمال:** __________  
**الحالة:** 🔄 قيد التنفيذ
