# 🚀 MBUY Deployment Guide

## ✅ ما تم تنفيذه

تم بناء البنية الكاملة لـ MBUY API:

### 1. Cloudflare Worker (API Gateway) ✅
- **الموقع:** `cloudflare/src/index.ts`
- **المسارات:**
  - `GET /` - Health check
  - `POST /public/register` - تسجيل تاجر جديد
  - `POST /media/image` - رفع صورة
  - `POST /media/video` - رفع فيديو
  - `POST /secure/wallet/add` - إضافة رصيد للمحفظة
  - `POST /secure/points/add` - إضافة/خصم نقاط
  - `POST /secure/orders/create` - إنشاء طلب
  - `GET /secure/wallet` - جلب محفظة المستخدم
  - `GET /secure/points` - جلب نقاط المستخدم

### 2. Supabase Edge Functions ✅
- **wallet_add** - إضافة رصيد للمحفظة
- **points_add** - إدارة النقاط
- **merchant_register** - تسجيل التجار
- **create_order** - إنشاء الطلبات مع الدفع

### 3. Features ✅
- ✅ JWT Verification (JWKS)
- ✅ Double-gate Security (JWT + INTERNAL_KEY)
- ✅ Media Uploads (Cloudflare Images + Stream)
- ✅ FCM Notifications
- ✅ Wallet System
- ✅ Points System
- ✅ Order Processing
- ✅ Payment Integration (ready for Tap/HyperPay/Tamara/Tabby)

---

## 📋 خطوات النشر

### المرحلة 1: إعداد Cloudflare Worker

```bash
cd cloudflare
npm install
wrangler login
```

**تعيين Secrets:**
```bash
# Cloudflare Images
wrangler secret put CF_IMAGES_API_TOKEN
# أدخل: k7E4jFO2KaAAB46acu5NFAbjxvCEHedddgvRmDq4

# Cloudflare Stream
wrangler secret put CF_STREAM_API_TOKEN
# أدخل: 8TgwP9eC5REnQQO_5ODk-Zx_4CJPh-_zXWPmN5eb

# R2
wrangler secret put R2_ACCESS_KEY_ID
# أدخل: 8dd4bc0a9ccac4d87ae966d58bb7226c

wrangler secret put R2_SECRET_ACCESS_KEY
# أدخل: 0f25cdc74371817702e2572f21c229e7498816c00118cf8eb3b054cacd8a863f

# Supabase
wrangler secret put SUPABASE_ANON_KEY
# أدخل: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNpcnFpZG9mdXZwaHFjeHFjaHljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ2NzUwMTAsImV4cCI6MjA4MDI1MTAxMH0.bnjGGAXAI6h14IL1gaoTFrHusxMjMX_xf0UA7WlGi04

# Internal Key (اختر مفتاح قوي)
wrangler secret put EDGE_INTERNAL_KEY
# أدخل: [مفتاح سري قوي - احفظه جيداً]
```

**تعيين Variables (plaintext):**

أضف في `wrangler.jsonc`:
```jsonc
{
  "name": "mbuy-api",
  "main": "src/index.ts",
  "compatibility_date": "2025-11-28",
  "observability": {
    "enabled": true
  },
  "vars": {
    "CF_IMAGES_ACCOUNT_ID": "0be397f41b9240364b007e5e392c26de",
    "CF_STREAM_ACCOUNT_ID": "0be397f41b9240364b007e5e392c26de",
    "R2_BUCKET_NAME": "muath-saleh",
    "R2_S3_ENDPOINT": "https://0be397f41b9240364b007e5e392c26de.r2.cloudflarestorage.com",
    "R2_PUBLIC_URL": "https://pub-26059c033186488b9b411de8eaa60228.r2.dev",
    "SUPABASE_URL": "https://sirqidofuvphqcxqchyc.supabase.co",
    "SUPABASE_JWKS_URL": "https://sirqidofuvphqcxqchyc.supabase.co/auth/v1/jwks"
  }
}
```

**النشر:**
```bash
wrangler deploy
```

احفظ الرابط الذي سيظهر، مثل:
```
https://mbuy-api.your-subdomain.workers.dev
```

---

### المرحلة 2: إعداد Supabase Edge Functions

```bash
cd supabase
supabase login
supabase link --project-ref sirqidofuvphqcxqchyc
```

**تعيين Secrets:**
```bash
# Supabase
supabase secrets set SB_URL=https://sirqidofuvphqcxqchyc.supabase.co
supabase secrets set SB_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNpcnFpZG9mdXZwaHFjeHFjaHljIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NDY3NTAxMCwiZXhwIjoyMDgwMjUxMDEwfQ.B1PRMsrqMSQ9KIC9-jnZbbxRVRb37uwGQy47CMKjWjI

# Internal Key (نفس الذي استخدمته في Worker)
supabase secrets set EDGE_INTERNAL_KEY=[نفس-المفتاح-من-الخطوة-السابقة]

# Optional: Firebase FCM
supabase secrets set FIREBASE_SERVER_KEY=[your-firebase-key]

# Optional: Payment Gateways
# supabase secrets set PAYMENT_TAP_API_KEY=[tap-key]
# supabase secrets set PAYMENT_HYPERPAY_API_KEY=[hyperpay-key]
```

**نشر Functions:**
```bash
supabase functions deploy wallet_add
supabase functions deploy points_add
supabase functions deploy merchant_register
supabase functions deploy create_order
```

---

### المرحلة 3: إعداد Database Function (للمخزون)

قم بتشغيل هذا SQL في Supabase SQL Editor:

```sql
-- Function لتحديث المخزون بشكل آمن
CREATE OR REPLACE FUNCTION decrement_stock(
  product_id uuid,
  quantity integer
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE products
  SET stock_quantity = stock_quantity - quantity
  WHERE id = product_id
  AND stock_quantity >= quantity;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Insufficient stock for product %', product_id;
  END IF;
END;
$$;
```

---

### المرحلة 4: اختبار API

```bash
# 1. Test health check
curl https://mbuy-api.your-subdomain.workers.dev/

# النتيجة المتوقعة:
# {"ok":true,"message":"MBUY API Gateway","version":"1.0.0"}
```

```bash
# 2. Test image upload
curl -X POST https://mbuy-api.your-subdomain.workers.dev/media/image \
  -H "Content-Type: application/json" \
  -d '{"filename":"test.jpg"}'

# النتيجة المتوقعة:
# {"ok":true,"uploadURL":"https://...","id":"...","viewURL":"https://..."}
```

```bash
# 3. Test merchant registration
curl -X POST https://mbuy-api.your-subdomain.workers.dev/public/register \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "test-user-id",
    "store_name": "متجر تجريبي"
  }'

# النتيجة المتوقعة:
# {"ok":true,"data":{...}}
```

---

### المرحلة 5: تحديث Flutter

في Flutter، استبدل جميع استدعاءات Supabase المباشرة بـ:

```dart
class MbuyApiClient {
  static const String baseUrl = 'https://mbuy-api.your-subdomain.workers.dev';

  // استخدم هذا بدلاً من Supabase مباشرة
}
```

**مثال:**

**قبل (خطأ):**
```dart
await supabaseClient.from('orders').insert({...});
```

**بعد (صحيح):**
```dart
final token = await Supabase.instance.client.auth.currentSession?.accessToken;
final response = await http.post(
  Uri.parse('$baseUrl/secure/orders/create'),
  headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  },
  body: jsonEncode({...}),
);
```

---

## 📊 Checklist النشر

- [ ] تم نشر Cloudflare Worker
- [ ] تم تعيين جميع Secrets في Worker
- [ ] تم تعيين جميع Variables في Worker
- [ ] تم نشر جميع Edge Functions (4 functions)
- [ ] تم تعيين جميع Secrets في Supabase
- [ ] تم إنشاء Database Function (decrement_stock)
- [ ] تم اختبار Health Check
- [ ] تم اختبار Media Upload
- [ ] تم اختبار Merchant Registration
- [ ] تم تحديث Flutter للاستخدام Worker بدلاً من Supabase

---

## 🔧 استكشاف الأخطاء

### خطأ: "Invalid internal key"
**الحل:** تأكد أن `EDGE_INTERNAL_KEY` متطابق في Worker و Edge Functions

### خطأ: "JWT verification failed"
**الحل:** تأكد من صحة `SUPABASE_JWKS_URL`

### خطأ: "Failed to create upload URL"
**الحل:** تحقق من صحة `CF_IMAGES_API_TOKEN` و `CF_STREAM_API_TOKEN`

### خطأ: "Insufficient stock"
**الحل:** تأكد من تشغيل SQL لإنشاء `decrement_stock` function

---

## 📚 التوثيق الكامل

راجع `MBUY_API_DOCUMENTATION.md` للتوثيق الشامل مع أمثلة Flutter.

---

## ✅ جاهز للاستخدام!

بعد إكمال جميع الخطوات، المعمارية ستكون:

```
Flutter App
    ↓ (Auth only)
Supabase Auth
    ↓ (JWT Token)
Flutter App
    ↓ (All API calls)
Cloudflare Worker (API Gateway)
    ↓ (JWT verified)
Supabase Edge Functions
    ↓ (INTERNAL_KEY verified)
Supabase Database
```

**Base URL:** `https://mbuy-api.your-subdomain.workers.dev`

استخدم هذا الرابط في Flutter بدلاً من الاتصال المباشر بـ Supabase.
