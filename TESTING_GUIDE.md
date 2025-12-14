# دليل الاختبار السريع - Auth System

## ✅ التعديلات المنفذة

### 1. Worker Changes
- ✅ إضافة `GET /auth/profile` endpoint
- ✅ نشر Worker (Version: d71011a6-291c-48f0-a6d6-82f510e6780a)

### 2. Flutter Changes
- ✅ تحسين auto-logout في `ApiService`
- ✅ إضافة `hasValidTokens()` method

---

## 🧪 خطوات الاختبار

### ⚠️ قبل الاختبار: حل مشكلة Registration

**المشكلة الحالية:**
```
POST /auth/supabase/register → 500 CREATE_FAILED
السبب: Database trigger لا يستطيع INSERT في user_profiles (RLS issue)
```

**الحل:**
1. افتح Supabase Dashboard → SQL Editor
2. انسخ محتوى: `c:\muath\FINAL_REGISTRATION_FIX_CORRECTED.sql`
3. نفّذ SQL
4. تحقق من رسالة: `✅ SUCCESS: Postgres role CAN insert`

---

### Test 1: تسجيل مستخدم جديد

```powershell
$random = Get-Random -Minimum 1000 -Maximum 9999
$email = "merchant-test-$random@mbuy.com"

$body = @{
  email = $email
  password = "test123456"
  full_name = "Test Merchant"
  role = "merchant"
} | ConvertTo-Json

$response = Invoke-WebRequest `
  -Uri "https://misty-mode-b68b.baharista1.workers.dev/auth/supabase/register" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body $body

$data = $response.Content | ConvertFrom-Json
$token = $data.access_token

Write-Host "✅ Registration successful!" -ForegroundColor Green
Write-Host "Email: $email"
Write-Host "Token: $($token.Substring(0,50))..."
```

**النتيجة المتوقعة:**
```json
{
  "success": true,
  "access_token": "eyJ...",
  "refresh_token": "...",
  "expires_in": 3600,
  "user": {
    "id": "uuid",
    "email": "merchant-test-XXXX@mbuy.com",
    "role": "merchant"
  },
  "profile": {
    "id": "profile-uuid",
    "role": "merchant",
    "display_name": "Test Merchant",
    ...
  }
}
```

---

### Test 2: اختبار Profile Endpoint الجديد ✨

```powershell
# استخدم token من Test 1
$profileResponse = Invoke-WebRequest `
  -Uri "https://misty-mode-b68b.baharista1.workers.dev/auth/profile" `
  -Method GET `
  -Headers @{"Authorization"="Bearer $token"}

Write-Host "✅ Profile fetched:" -ForegroundColor Green
$profileResponse.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

**النتيجة المتوقعة:**
```json
{
  "ok": true,
  "user": {
    "id": "auth-user-uuid",
    "email": "merchant-test-XXXX@mbuy.com",
    "role": "merchant"
  },
  "profile": {
    "id": "profile-uuid",
    "auth_user_id": "auth-user-uuid",
    "role": "merchant",
    "display_name": "Test Merchant",
    "email": "merchant-test-XXXX@mbuy.com",
    "avatar_url": null,
    "phone": null,
    "created_at": "2025-12-11T...",
    "updated_at": "2025-12-11T..."
  },
  "store": null  // لأن المستخدم لم ينشئ متجر بعد
}
```

---

### Test 3: إنشاء متجر

```powershell
$storeBody = @{
  name = "متجر اختبار"
  description = "وصف المتجر"
} | ConvertTo-Json

$storeResponse = Invoke-WebRequest `
  -Uri "https://misty-mode-b68b.baharista1.workers.dev/secure/store" `
  -Method POST `
  -Headers @{
    "Authorization"="Bearer $token"
    "Content-Type"="application/json"
  } `
  -Body $storeBody

Write-Host "✅ Store created!" -ForegroundColor Green
$storeResponse.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

---

### Test 4: جلب Profile مرة أخرى (مع Store)

```powershell
$profileResponse2 = Invoke-WebRequest `
  -Uri "https://misty-mode-b68b.baharista1.workers.dev/auth/profile" `
  -Method GET `
  -Headers @{"Authorization"="Bearer $token"}

Write-Host "✅ Profile with store:" -ForegroundColor Green
$profileResponse2.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

**النتيجة المتوقعة:**
```json
{
  "ok": true,
  "user": { ... },
  "profile": { ... },
  "store": {  // ✅ الآن يظهر المتجر
    "id": "store-uuid",
    "name": "متجر اختبار",
    "description": "وصف المتجر",
    "logo_url": null,
    "status": "active",
    "created_at": "2025-12-11T..."
  }
}
```

---

### Test 5: إضافة منتج (JWT-based, no store_id from client)

```powershell
$productBody = @{
  name = "منتج تجريبي"
  price = 99.99
  stock = 10
  description = "وصف المنتج"
  category_id = "get-from-database"  # استبدل بـ category_id حقيقي
} | ConvertTo-Json

$productResponse = Invoke-WebRequest `
  -Uri "https://misty-mode-b68b.baharista1.workers.dev/secure/products" `
  -Method POST `
  -Headers @{
    "Authorization"="Bearer $token"
    "Content-Type"="application/json"
  } `
  -Body $productBody

Write-Host "✅ Product created!" -ForegroundColor Green
$productResponse.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

**ملاحظة مهمة:**
- ❌ لا ترسل `store_id` من Flutter
- ✅ Worker يجلب `store_id` من قاعدة البيانات باستخدام `profileId` من JWT
- ✅ المنتج يُنشأ بـ `store_id` الصحيح تلقائياً

---

### Test 6: Token Refresh

```powershell
# احفظ refresh_token
$refreshToken = $data.refresh_token

# بعد فترة (أو حذف access_token يدوياً لمحاكاة انتهاء الصلاحية)
Start-Sleep -Seconds 5

$refreshBody = @{
  refresh_token = $refreshToken
} | ConvertTo-Json

$refreshResponse = Invoke-WebRequest `
  -Uri "https://misty-mode-b68b.baharista1.workers.dev/auth/supabase/refresh" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body $refreshBody

Write-Host "✅ Token refreshed!" -ForegroundColor Green
$newTokens = $refreshResponse.Content | ConvertFrom-Json
$newToken = $newTokens.access_token

Write-Host "New Access Token: $($newToken.Substring(0,50))..."
```

---

### Test 7: Auto-Logout Test (في Flutter)

**Scenario 1: Refresh نجح**
1. حذف `access_token` من SecureStorage
2. حاول إضافة منتج
3. **المتوقع:**
   - Worker يرجع 401
   - `ApiService` يستدعي `/auth/supabase/refresh`
   - يحفظ tokens جديدة
   - يعيد محاولة الطلب → ينجح

**Scenario 2: Refresh فشل**
1. حذف `refresh_token` من SecureStorage
2. حاول إضافة منتج
3. **المتوقع:**
   - Worker يرجع 401
   - `ApiService` يحاول refresh → يفشل (لا يوجد refresh_token)
   - ✅ **جديد:** `ApiService` يحذف جميع tokens تلقائياً
   - UI تكتشف `hasValidTokens() = false`
   - توجيه لصفحة Login مع رسالة: "انتهت الجلسة"

---

## 📊 سيناريوهات الاختبار الشاملة

### ✅ Scenario 1: Happy Path (كل شيء يعمل)
1. Register → Login → Create Store → Add Product → Success!

### ✅ Scenario 2: Token Expiry + Auto-Refresh
1. Login → Wait for token to expire (or delete manually)
2. Try to add product → 401 → Auto-refresh → Retry → Success!

### ✅ Scenario 3: Session Expired + Auto-Logout
1. Login → Delete refresh_token
2. Try to add product → 401 → Refresh fails → Auto-logout → Redirect to Login

### ✅ Scenario 4: Profile Fetch
1. Login → GET /auth/profile → Returns user + profile + store (if exists)

### ✅ Scenario 5: JWT Security
1. Try to send fake `store_id` in product creation request
2. Worker ignores it and uses `store_id` from database
3. Product created with correct `store_id`

---

## 🔧 استكشاف الأخطاء

### مشكلة: Registration يفشل
**الرسالة:** `CREATE_FAILED: Database error creating new user`
**الحل:** نفّذ `FINAL_REGISTRATION_FIX_CORRECTED.sql` في Supabase Dashboard

### مشكلة: 401 Unauthorized
**الأسباب المحتملة:**
1. Token منتهي → يجب أن يحدث auto-refresh
2. Token غير صالح → تأكد من Authorization header
3. Refresh_token منتهي → يجب حذف tokens و redirect to login

### مشكلة: Profile endpoint يرجع 404
**الأسباب:**
1. user_profiles غير موجود (trigger فشل أثناء registration)
2. auth_user_id لا يطابق أي profile

### مشكلة: Product creation يفشل
**الأسباب:**
1. لا يوجد store للتاجر → أنشئ store أولاً
2. Store غير مفعّل (status != 'active')
3. category_id غير صالح

---

## 📝 ملاحظات مهمة

### ✅ ما تم تحسينه:
1. **Profile Endpoint** - GET /auth/profile (جديد)
2. **Auto-Logout** - يحذف tokens عند فشل refresh (جديد)
3. **hasValidTokens()** - للتحقق من الجلسة (جديد)

### ✅ ما كان يعمل بالفعل:
1. Flutter → Worker → Supabase (بنية صحيحة)
2. JWT-based authentication
3. Auto-refresh on 401
4. Worker لا يثق بـ client-provided IDs
5. Secure endpoints محمية بـ JWT

### ⏳ ما يحتاج عمل:
1. تنفيذ SQL fix لحل registration RLS issue
2. اختبار شامل بعد حل المشكلة

---

**Good luck with testing! 🚀**
