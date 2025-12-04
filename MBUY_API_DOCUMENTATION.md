# 📘 توثيق MBUY API Gateway

## 🔧 معلومات المشروع

**البنية المعمارية:** 3-Tier Architecture
- **Flutter App** → **Cloudflare Worker** → **Supabase Edge Functions**

**Worker Domain:** `https://misty-mode-b68b.baharista1.workers.dev`

---

## 🔐 الأمان والمصادقة

### 1. المسارات العامة (`/public/*`)
- **لا تتطلب JWT**
- متاحة لجميع المستخدمين
- مثال: `/public/register`

### 2. المسارات الآمنة (`/secure/*`)
- **تتطلب JWT في الـ Header:**
  ```
  Authorization: Bearer <your_jwt_token>
  ```
- يتم التحقق من JWT باستخدام `SUPABASE_JWKS_URL`
- في حالة فشل التحقق → `401 Unauthorized`

### 3. Edge Functions Security
- جميع Edge Functions تتطلب:
  ```
  x-internal-key: <EDGE_INTERNAL_KEY>
  ```
- هذا المفتاح موجود فقط في Worker ولا يتم كشفه للعميل
- في حالة فشل التحقق → `403 Forbidden`

---

## 📋 قائمة المسارات المكتملة

### ✅ الوظائف الموجودة حالياً:

#### 🔓 Public Routes
- `POST /public/register` - تسجيل تاجر جديد

#### 🖼️ Media Routes
- `POST /media/image` - رفع صورة
- `POST /media/video` - رفع فيديو

#### 🔒 Secure Routes
- `POST /secure/wallet/add` - إضافة رصيد
- `GET /secure/wallet` - الحصول على رصيد المحفظة
- `POST /secure/points/add` - إضافة/خصم نقاط
- `GET /secure/points` - الحصول على رصيد النقاط
- `POST /secure/orders/create` - إنشاء طلب
- `GET /secure/products` - قائمة المنتجات
- `POST /secure/products` - إنشاء منتج
- `PUT /secure/products/:id` - تحديث منتج
- `DELETE /secure/products/:id` - حذف منتج
- `GET /secure/stores/:id` - معلومات متجر
- `PUT /secure/stores/:id` - تحديث متجر

### ✅ Edge Functions المكتملة:

1. `wallet_add` - إضافة رصيد + FCM
2. `points_add` - إضافة/خصم نقاط + FCM
3. `merchant_register` - تسجيل تاجر + FCM
4. `create_order` - إنشاء طلب + معالجة دفع + FCM
5. `products_list` - قائمة المنتجات
6. `product_create` - إنشاء منتج
7. `product_update` - تحديث منتج
8. `product_delete` - حذف منتج
9. `store_update` - تحديث متجر

---

## 📖 تفاصيل الاستخدام

### 1️⃣ رفع الوسائط (Media Upload)

#### رفع صورة
```http
POST /media/image
Content-Type: application/json

{
  "filename": "product.jpg"
}
```

**الاستجابة:**
```json
{
  "ok": true,
  "uploadURL": "https://upload.imagedelivery.net/...",
  "id": "image-uuid",
  "viewURL": "https://imagedelivery.net/.../public"
}
```

**خطوات الرفع:**
1. احصل على `uploadURL` من `/media/image`
2. ارفع الملف إلى `uploadURL` مباشرة
3. استخدم `viewURL` لعرض الصورة

#### رفع فيديو
```http
POST /media/video
Content-Type: application/json

{
  "filename": "promo.mp4"
}
```

**الاستجابة:**
```json
{
  "ok": true,
  "uploadURL": "https://upload.videodelivery.net/...",
  "playbackId": "video-uuid",
  "viewURL": "https://customer-....cloudflarestream.com/.../manifest/video.m3u8"
}
```

---

### 2️⃣ تسجيل التاجر

```http
POST /public/register
Content-Type: application/json

{
  "user_id": "uuid-from-supabase-auth",
  "store_name": "متجر الإلكترونيات",
  "store_description": "متجر متخصص في الأجهزة الإلكترونية",
  "city": "الرياض"
}
```

**الاستجابة:**
```json
{
  "ok": true,
  "data": {
    "store_id": "uuid",
    "store_name": "متجر الإلكترونيات",
    "wallet_id": "uuid",
    "points_account_id": "uuid",
    "welcome_bonus": 100
  }
}
```

**ما يحدث في الخلفية:**
- إنشاء متجر جديد
- تحديث دور المستخدم إلى `merchant`
- إنشاء محفظة بنوع `merchant`
- إنشاء حساب نقاط مع 100 نقطة ترحيبية
- إرسال إشعار FCM ترحيبي

---

### 3️⃣ المحفظة (Wallet)

#### الحصول على الرصيد
```http
GET /secure/wallet
Authorization: Bearer <jwt>
```

**الاستجابة:**
```json
{
  "ok": true,
  "data": {
    "id": "uuid",
    "owner_id": "user-uuid",
    "type": "customer",
    "balance": 500.00,
    "created_at": "2024-12-01T10:00:00Z"
  }
}
```

#### إضافة رصيد
```http
POST /secure/wallet/add
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "amount": 100.00,
  "source": "payment",
  "meta": {
    "payment_method": "tap",
    "transaction_ref": "PAY-123456"
  }
}
```

**الاستجابة:**
```json
{
  "ok": true,
  "data": {
    "wallet_id": "uuid",
    "transaction_id": "uuid",
    "old_balance": 400.00,
    "new_balance": 500.00,
    "amount_added": 100.00
  }
}
```

**إشعار FCM:** "تم إضافة 100 ر.س إلى محفظتك"

---

### 4️⃣ النقاط (Points)

#### الحصول على النقاط
```http
GET /secure/points
Authorization: Bearer <jwt>
```

#### إضافة نقاط
```http
POST /secure/points/add
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "points": 50,
  "reason": "purchase_reward",
  "meta": {
    "order_id": "uuid"
  }
}
```

#### خصم نقاط
```http
POST /secure/points/add
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "points": -50,
  "reason": "order_discount",
  "meta": {
    "order_id": "uuid"
  }
}
```

---

### 5️⃣ الطلبات (Orders)

```http
POST /secure/orders/create
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "items": [
    {
      "product_id": "product-uuid-1",
      "quantity": 2
    },
    {
      "product_id": "product-uuid-2",
      "quantity": 1,
      "price": 99.99
    }
  ],
  "payment_method": "wallet",
  "shipping_address_id": "address-uuid",
  "use_points": 100,
  "coupon_code": "SAVE10"
}
```

**طرق الدفع:**
- `cash` - نقداً عند الاستلام
- `wallet` - من المحفظة
- `tap` - بوابة Tap
- `hyperpay` - بوابة HyperPay
- `tamara` - تقسيط Tamara
- `tabby` - تقسيط Tabby

**الاستجابة:**
```json
{
  "ok": true,
  "data": {
    "order_id": "uuid",
    "total_amount": 285.00,
    "payment_status": "paid",
    "points_used": 100,
    "points_earned": 28,
    "discount_applied": 110.00
  }
}
```

**العمليات التلقائية:**
1. التحقق من المخزون
2. حساب الخصومات (نقاط 0.1 ر.س + كوبونات)
3. معالجة الدفع
4. إنشاء الطلب وعناصره
5. تحديث المخزون (decrement_stock)
6. خصم النقاط المستخدمة
7. منح نقاط جديدة (1% من الإجمالي)
8. إرسال إشعارات FCM للعميل والتجار

---

### 6️⃣ المنتجات (Products)

#### قائمة المنتجات
```http
GET /secure/products
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "limit": 50,
  "offset": 0
}
```

**الاستجابة:**
```json
{
  "ok": true,
  "data": [
    {
      "id": "uuid",
      "store_id": "uuid",
      "name": "هاتف ذكي",
      "description": "هاتف بمواصفات عالية",
      "price": 2999.99,
      "stock_quantity": 15,
      "category": "إلكترونيات",
      "main_image_url": "https://...",
      "images": ["https://...", "https://..."],
      "created_at": "2024-12-01T10:00:00Z"
    }
  ],
  "total": 45,
  "limit": 50,
  "offset": 0
}
```

#### إنشاء منتج
```http
POST /secure/products
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "name": "منتج جديد",
  "description": "وصف المنتج",
  "price": 199.99,
  "stock_quantity": 50,
  "category": "إكسسوارات",
  "main_image_url": "https://imagedelivery.net/.../public",
  "images": [
    "https://imagedelivery.net/.../public",
    "https://imagedelivery.net/.../public"
  ]
}
```

#### تحديث منتج
```http
PUT /secure/products/{product_id}
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "price": 179.99,
  "stock_quantity": 30
}
```

#### حذف منتج
```http
DELETE /secure/products/{product_id}
Authorization: Bearer <jwt>
```

---

### 7️⃣ المتاجر (Stores)

#### معلومات المتجر
```http
GET /secure/stores/{store_id}
Authorization: Bearer <jwt>
```

#### تحديث المتجر
```http
PUT /secure/stores/{store_id}
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "name": "اسم المتجر الجديد",
  "description": "وصف محدّث",
  "logo_url": "https://...",
  "banner_url": "https://...",
  "city": "جدة",
  "phone": "0501234567"
}
```

---

## 🔔 إشعارات FCM

### الإشعارات المُرسلة تلقائياً:

| العملية | المستلم | الرسالة |
|---------|---------|---------|
| `wallet_add` | صاحب المحفظة | "تم إضافة {amount} ر.س إلى محفظتك" |
| `points_add` (+) | صاحب الحساب | "تم إضافة {points} نقطة إلى حسابك" |
| `points_add` (-) | صاحب الحساب | "تم خصم {points} نقطة من حسابك" |
| `merchant_register` | التاجر الجديد | "مرحباً بك كتاجر! تم إنشاء متجرك بنجاح" |
| `create_order` | العميل | "تم إنشاء الطلب بنجاح - رقم الطلب: {order_id}" |
| `create_order` | التجار | "طلب جديد رقم {order_id}" |

**المتطلبات:**
- `FIREBASE_SERVER_KEY` موجود في Supabase Secrets
- `fcm_token` محفوظ في `user_profiles.fcm_token`

**ملاحظة:** إذا فشل إرسال الإشعار، لن يفشل الطلب الأساسي

---

## 🔐 المفاتيح والأسرار

### Cloudflare Worker

**متغيرات عامة (Plaintext):**
```
CF_IMAGES_ACCOUNT_ID
CF_STREAM_ACCOUNT_ID
R2_BUCKET_NAME
R2_S3_ENDPOINT
R2_PUBLIC_URL
SUPABASE_URL
SUPABASE_JWKS_URL
```

**أسرار (Secrets):**
```bash
wrangler secret put CF_IMAGES_API_TOKEN
wrangler secret put CF_STREAM_API_TOKEN
wrangler secret put R2_ACCESS_KEY_ID
wrangler secret put R2_SECRET_ACCESS_KEY
wrangler secret put SUPABASE_ANON_KEY
wrangler secret put EDGE_INTERNAL_KEY
```

### Supabase Edge Functions

**مطلوبة:**
```
SB_URL (أو SUPABASE_URL)
SB_SERVICE_ROLE_KEY (أو SUPABASE_SERVICE_ROLE_KEY)
EDGE_INTERNAL_KEY
```

**اختيارية:**
```
FIREBASE_SERVER_KEY
PAYMENT_TAP_API_KEY
PAYMENT_HYPERPAY_API_KEY
PAYMENT_TAMARA_API_KEY
PAYMENT_TABBY_API_KEY
SHIPPING_SMSA_API_KEY
SHIPPING_ARAMEX_API_KEY
```

---

## ⚠️ معالجة الأخطاء

### تنسيق موحّد:
```json
{
  "error": "Error Type",
  "detail": "تفاصيل الخطأ"
}
```

### أكواد الحالة:
- `200` ✅ نجاح
- `201` ✅ تم الإنشاء
- `400` ❌ طلب خاطئ
- `401` ❌ غير مصرّح
- `403` ❌ ممنوع
- `404` ❌ غير موجود
- `409` ❌ تعارض
- `500` ❌ خطأ في الخادم

---

## 🚀 النشر

### نشر Worker:
```bash
cd cloudflare
wrangler login
wrangler deploy
```

### نشر Edge Functions:
```bash
supabase functions deploy wallet_add
supabase functions deploy points_add
supabase functions deploy merchant_register
supabase functions deploy create_order
supabase functions deploy products_list
supabase functions deploy product_create
supabase functions deploy product_update
supabase functions deploy product_delete
supabase functions deploy store_update
```

---

## 📝 ملاحظات مهمة

1. ✅ **جميع المسارات تعمل عبر Worker** - لا وصول مباشر من Flutter
2. ✅ **JWT للمسارات الآمنة فقط** - `/secure/*`
3. ✅ **Edge Functions محمية** - `x-internal-key` مطلوب
4. ✅ **FCM اختياري** - يعمل إذا كان المفتاح موجوداً
5. ⚠️ **بوابات الدفع** - تحتاج مفاتيح حقيقية للتفعيل
6. ℹ️ **R2 Storage** - مُعدّ لكن غير مُستخدم حالياً

---

**آخر تحديث:** ديسمبر 2024  
**الإصدار:** 1.0.0  
**البنية:** MBUY 3-Tier Architecture
