# 🔧 دليل إصلاح مشكلة التسجيل (Registration Issue)

## 📋 المشكلة

عند محاولة التسجيل عبر Worker API:
```json
{
  "error": "CREATE_FAILED",
  "message": "Database error creating new user"
}
```

---

## 🔍 السبب المحتمل

المشكلة في **RLS على جدول `user_profiles`**:

1. عند التسجيل، Supabase Auth ينشئ مستخدم في `auth.users`
2. Trigger يحاول إنشاء profile في `user_profiles`
3. إذا كان RLS مفعّل **بدون policy للـ service_role**، الـ INSERT يفشل
4. النتيجة: CREATE_FAILED

---

## ✅ الحل - خطوات التطبيق

### الخطوة 1: تشخيص المشكلة

افتح **Supabase Dashboard → SQL Editor** ونفّذ:

```sql
-- نسخ محتوى الملف
c:\muath\mbuy-backend\supabase\migrations\DIAGNOSTIC_registration_issue.sql
```

**النتائج المتوقعة:**
- ✅ Trigger enabled
- ✅ Function is SECURITY DEFINER
- ✅ Insert test succeeds

**إذا فشل Insert Test:**
👉 انتقل للخطوة 2

---

### الخطوة 2: تطبيق الإصلاح

في **Supabase Dashboard → SQL Editor**:

```sql
-- نسخ محتوى الملف
c:\muath\mbuy-backend\supabase\migrations\20251212000001_fix_registration_rls.sql
```

**ماذا يفعل هذا الإصلاح:**
1. ✅ يمنح صلاحيات كاملة لـ `postgres` role (مالك الـ trigger)
2. ✅ ينشئ policy لـ `service_role` للـ bypass RLS
3. ✅ يتحقق من أن الـ trigger مفعّل
4. ✅ يضيف policy للمستخدمين لإدخال profile الخاص

---

### الخطوة 3: اختبار التسجيل

في **PowerShell**:

```powershell
# اختبار التسجيل
$email = "test-fix-$(Get-Random)@mbuy.com"
$body = @{
  email = $email
  password = "test123456"
  full_name = "Test Fix User"
  role = "customer"
} | ConvertTo-Json

Write-Host "🧪 Testing registration with: $email"

$response = Invoke-WebRequest `
  -Uri "https://misty-mode-b68b.baharista1.workers.dev/auth/supabase/register" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body $body

Write-Host "📊 Status: $($response.StatusCode)"
$response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

**النتيجة المتوقعة:**
```json
{
  "success": true,
  "message": "User registered and logged in successfully",
  "session": {
    "access_token": "eyJ...",
    "refresh_token": "...",
    "expires_in": 3600
  },
  "user": {
    "id": "UUID",
    "email": "test-fix-XXX@mbuy.com",
    "role": "customer"
  },
  "profile": {
    "id": "UUID",
    "auth_user_id": "UUID",
    "display_name": "Test Fix User",
    "role": "customer"
  }
}
```

---

### الخطوة 4: التحقق من الـ Profile

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
WHERE email LIKE 'test-fix-%@mbuy.com'
ORDER BY created_at DESC
LIMIT 5;
```

**يجب أن ترى:**
- ✅ Row موجود مع `auth_user_id` matching `auth.users.id`
- ✅ `display_name` = "Test Fix User"
- ✅ `role` = "customer"

---

## 🔬 إذا استمرت المشكلة

### احتمال 1: الـ Trigger معطّل

```sql
-- تحقق من حالة الـ trigger
SELECT tgname, tgenabled 
FROM pg_trigger 
WHERE tgname = 'on_auth_user_created';

-- إذا كان معطّل (tgenabled = 'D')
ALTER TABLE auth.users 
ENABLE TRIGGER on_auth_user_created;
```

### احتمال 2: الـ Function مفقودة

```sql
-- تحقق من وجود الـ function
SELECT proname FROM pg_proc 
WHERE proname = 'handle_new_auth_user';

-- إذا لم توجد، أعد تطبيق:
-- c:\muath\mbuy-backend\supabase\migrations\20251211120001_auto_create_user_profile_trigger.sql
```

### احتمال 3: مشكلة في الصلاحيات على `auth.users`

```sql
-- تحقق من صلاحيات auth schema
GRANT USAGE ON SCHEMA auth TO postgres;
GRANT ALL ON auth.users TO postgres;
```

### احتمال 4: Worker لا يرسل البيانات بشكل صحيح

تحقق من logs في Cloudflare:

```powershell
cd c:\muath
npx wrangler tail --format pretty
```

ثم نفّذ التسجيل وشاهد الـ logs.

---

## 📊 الحالة النهائية المطلوبة

بعد تطبيق الإصلاح، يجب أن تكون:

| المكون | الحالة | الوصف |
|--------|---------|-------|
| **Trigger** | ✅ Enabled | `on_auth_user_created` active |
| **Function** | ✅ SECURITY DEFINER | `handle_new_auth_user()` runs as postgres |
| **RLS** | 🔒 Enabled | RLS active with proper policies |
| **Policies** | ✅ 2+ policies | service_role + authenticated |
| **Permissions** | ✅ Granted | postgres/service_role have ALL |
| **Registration** | ✅ Works | Users can register successfully |

---

## 🎯 الخطوة التالية

بعد نجاح التسجيل:

1. **إنشاء مستخدمين للاختبار:**
   - Customer: `test-customer@mbuy.com`
   - Merchant: `test-merchant@mbuy.com`

2. **تطبيق RLS Policies:**
   ```sql
   -- ملف الـ RLS policies الشامل
   c:\muath\mbuy-backend\supabase\migrations\20251212000000_comprehensive_rls_policies.sql
   ```

3. **اختبار الـ RLS:**
   ```sql
   -- ملف الاختبارات
   c:\muath\mbuy-backend\supabase\migrations\test_rls_policies.sql
   ```

---

## 📝 ملاحظات مهمة

⚠️ **لا تنسَ:**
- الـ trigger يعمل فقط عند التسجيل عبر **Supabase Auth**
- إذا أنشأت مستخدمين يدوياً في Dashboard، يجب إنشاء profiles يدوياً أيضاً
- الـ Worker يستخدم `service_role` key الذي يتجاوز RLS

✅ **ما تم إصلاحه:**
- منع RLS من إيقاف الـ trigger
- السماح للـ trigger بإنشاء profiles تلقائياً
- إضافة policies لضمان عمل التسجيل

---

**آخر تحديث:** 2025-12-12  
**الإصدار:** Golden Plan v1.0 - Registration Fix
