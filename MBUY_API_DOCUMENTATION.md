# 📚 MBUY API Documentation

## 🎯 Overview

MBUY API Gateway هو نقطة الاتصال الوحيدة بين Flutter Application وبقية الخدمات. يوفر:
- ✅ توجيه الطلبات (Routing)
- ✅ التحقق من JWT (Authentication)
- ✅ رفع الوسائط (Media Uploads)
- ✅ حماية Edge Functions

---

## 🏗️ Architecture

```
Flutter App
    ↓
Cloudflare Worker (API Gateway)
    ↓
Supabase Edge Functions
    ↓
Supabase Database
```

---

## 🔑 Authentication

### Public Routes
لا تتطلب Authentication

### Secure Routes (`/secure/*`)
تتطلب JWT Token في Header:
```
Authorization: Bearer <JWT_TOKEN>
```

**كيفية الحصول على JWT:**
```dart
// في Flutter
final session = await Supabase.instance.client.auth.currentSession;
final token = session?.accessToken;
```

---

## 📡 API Endpoints

### 1. Health Check

**GET** `/`

**Response:**
```json
{
  "ok": true,
  "message": "MBUY API Gateway",
  "version": "1.0.0"
}
```

---

### 2. Media Upload - Image

**POST** `/media/image`

**Request Body:**
```json
{
  "filename": "product.jpg"
}
```

**Response:**
```json
{
  "ok": true,
  "uploadURL": "https://upload.imagedelivery.net/...",
  "id": "uuid-here",
  "viewURL": "https://imagedelivery.net/account-id/image-id/public"
}
```

**Usage:**
1. استدعاء `/media/image` للحصول على `uploadURL`
2. رفع الصورة إلى `uploadURL` باستخدام `PUT` request
3. استخدام `viewURL` لعرض الصورة

**Flutter Example:**
```dart
// 1. Get upload URL
final response = await http.post(
  Uri.parse('https://your-worker.workers.dev/media/image'),
  body: jsonEncode({'filename': 'product.jpg'}),
);
final data = jsonDecode(response.body);

// 2. Upload image
final imageFile = File('path/to/image.jpg');
final uploadResponse = await http.put(
  Uri.parse(data['uploadURL']),
  body: await imageFile.readAsBytes(),
);

// 3. Use viewURL
final imageUrl = data['viewURL'];
```

---

### 3. Media Upload - Video

**POST** `/media/video`

**Request Body:**
```json
{
  "filename": "product-demo.mp4"
}
```

**Response:**
```json
{
  "ok": true,
  "uploadURL": "https://upload.cloudflarestream.com/...",
  "playbackId": "video-uuid",
  "viewURL": "https://customer-account-id.cloudflarestream.com/video-uuid/manifest/video.m3u8"
}
```

**Usage:**
مثل الصور، لكن للفيديوهات. استخدم `viewURL` مع video player يدعم HLS.

---

### 4. Merchant Registration

**POST** `/public/register`

**Request Body:**
```json
{
  "user_id": "uuid",
  "store_name": "متجر محمد",
  "store_description": "متجر متخصص في الإلكترونيات",
  "city": "الرياض"
}
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "store_id": "uuid",
    "store_name": "متجر محمد",
    "wallet_id": "uuid",
    "points_account_id": "uuid",
    "welcome_bonus": 100
  }
}
```

**Notes:**
- ينشئ متجر جديد
- يحدث دور المستخدم إلى `merchant`
- ينشئ محفظة تاجر
- يمنح 100 نقطة كمكافأة ترحيبية

---

### 5. Add Wallet Funds

**POST** `/secure/wallet/add` 🔒

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
```

**Request Body:**
```json
{
  "amount": 100.50,
  "source": "payment",
  "meta": {
    "payment_method": "card",
    "transaction_id": "tx_12345"
  }
}
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "wallet_id": "uuid",
    "transaction_id": "uuid",
    "old_balance": 50.00,
    "new_balance": 150.50,
    "amount_added": 100.50
  }
}
```

**Sources:**
- `payment` - دفع من بوابة دفع
- `refund` - استرجاع مبلغ
- `bonus` - مكافأة
- `admin` - إضافة من Admin

---

### 6. Add Points

**POST** `/secure/points/add` 🔒

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
```

**Request Body:**
```json
{
  "points": 50,
  "reason": "purchase",
  "meta": {
    "order_id": "uuid"
  }
}
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "account_id": "uuid",
    "transaction_id": "uuid",
    "old_balance": 100,
    "new_balance": 150,
    "points_changed": 50
  }
}
```

**Reasons:**
- `purchase` - شراء منتج
- `bonus` - مكافأة
- `refund` - استرجاع
- `signup` - تسجيل جديد

**Notes:**
- يمكن إضافة نقاط موجبة أو سالبة
- إذا كانت سالبة، يتحقق من كفاية الرصيد

---

### 7. Create Order

**POST** `/secure/orders/create` 🔒

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
```

**Request Body:**
```json
{
  "items": [
    {
      "product_id": "uuid",
      "quantity": 2
    }
  ],
  "payment_method": "wallet",
  "shipping_address_id": "uuid",
  "use_points": 50,
  "coupon_code": "SALE20"
}
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "order_id": "uuid",
    "total_amount": 285.50,
    "payment_status": "paid",
    "payment_reference": null,
    "points_used": 50,
    "points_earned": 3,
    "discount_applied": 25.00
  }
}
```

**Payment Methods:**
- `cash` - الدفع عند الاستلام
- `wallet` - من المحفظة
- `card` - بطاقة ائتمانية
- `tap` - Tap Payment
- `hyperpay` - HyperPay
- `tamara` - Tamara (تقسيط)
- `tabby` - Tabby (تقسيط)

**Order Process:**
1. التحقق من المنتجات والمخزون
2. حساب المجموع (subtotal)
3. تطبيق خصم النقاط (إذا وُجد)
4. تطبيق كوبون الخصم (إذا وُجد)
5. إضافة رسوم الشحن
6. معالجة الدفع
7. إنشاء الطلب
8. تحديث المخزون
9. خصم النقاط المستخدمة
10. منح نقاط على الشراء (1% من المجموع)
11. إرسال إشعارات FCM

---

### 8. Get Wallet

**GET** `/secure/wallet` 🔒

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "id": "uuid",
    "owner_id": "uuid",
    "type": "customer",
    "balance": 150.50,
    "created_at": "2025-12-03T..."
  }
}
```

---

### 9. Get Points

**GET** `/secure/points` 🔒

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "id": "uuid",
    "user_id": "uuid",
    "points_balance": 250,
    "created_at": "2025-12-03T..."
  }
}
```

---

## 🔐 Security

### Double-Gate Protection

كل Edge Function محمية بطبقتين:

1. **JWT Verification في Worker**
   - يتحقق من صلاحية التوكن
   - يستخرج `user_id`

2. **Internal Key Verification في Edge Function**
   - يتحقق من `x-internal-key` header
   - يمنع الاستدعاء المباشر

```
Flutter → Worker (checks JWT) → Edge Function (checks INTERNAL_KEY) → Database
```

---

## 📨 FCM Notifications

تُرسل الإشعارات تلقائياً في الحالات التالية:

### Wallet Add
```json
{
  "title": "تم إضافة رصيد",
  "body": "تم إضافة 100 ر.س إلى محفظتك",
  "data": {
    "type": "wallet_add",
    "amount": "100"
  }
}
```

### Points Add/Deduct
```json
{
  "title": "تم إضافة نقاط",
  "body": "تم إضافة 50 نقطة إلى حسابك",
  "data": {
    "type": "points_change",
    "points": "50"
  }
}
```

### Merchant Registration
```json
{
  "title": "مرحباً بك كتاجر!",
  "body": "تم إنشاء متجرك 'اسم المتجر' بنجاح. حصلت على 100 نقطة كمكافأة ترحيبية!",
  "data": {
    "type": "merchant_registered",
    "store_id": "uuid"
  }
}
```

### Order Created (للعميل)
```json
{
  "title": "تم إنشاء الطلب بنجاح",
  "body": "رقم الطلب: uuid - المبلغ: 285.50 ر.س",
  "data": {
    "type": "order_created",
    "order_id": "uuid"
  }
}
```

### New Order (للتاجر)
```json
{
  "title": "طلب جديد",
  "body": "لديك طلب جديد رقم uuid",
  "data": {
    "type": "new_order",
    "order_id": "uuid"
  }
}
```

---

## 🛠️ Environment Variables

### Cloudflare Worker Secrets

```bash
# Cloudflare Images
CF_IMAGES_ACCOUNT_ID=<account-id>
CF_IMAGES_API_TOKEN=<secret>

# Cloudflare Stream
CF_STREAM_ACCOUNT_ID=<account-id>
CF_STREAM_API_TOKEN=<secret>

# Cloudflare R2
R2_ACCESS_KEY_ID=<secret>
R2_SECRET_ACCESS_KEY=<secret>
R2_BUCKET_NAME=<bucket-name>
R2_S3_ENDPOINT=<endpoint>
R2_PUBLIC_URL=<public-url>

# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_JWKS_URL=https://your-project.supabase.co/auth/v1/jwks
SUPABASE_ANON_KEY=<secret>

# Internal Security
EDGE_INTERNAL_KEY=<secret-key>
```

### Supabase Edge Function Secrets

```bash
# Supabase
SB_URL=https://your-project.supabase.co
SB_SERVICE_ROLE_KEY=<secret>

# Internal Security
EDGE_INTERNAL_KEY=<same-as-worker>

# Optional: Firebase
FIREBASE_SERVER_KEY=<secret>

# Optional: Payments
PAYMENT_TAP_API_KEY=<secret>
PAYMENT_HYPERPAY_API_KEY=<secret>
PAYMENT_TAMARA_API_KEY=<secret>
PAYMENT_TABBY_API_KEY=<secret>

# Optional: Shipping
SHIPPING_SMSA_API_KEY=<secret>
SHIPPING_ARAMEX_API_KEY=<secret>
```

---

## 📦 Deployment

### Deploy Worker

```bash
cd cloudflare
npm install
wrangler login
wrangler deploy
```

### Deploy Edge Functions

```bash
cd supabase
supabase login
supabase link --project-ref <your-project-ref>

# Deploy all functions
supabase functions deploy wallet_add
supabase functions deploy points_add
supabase functions deploy merchant_register
supabase functions deploy create_order
```

### Set Secrets

```bash
# Worker secrets
wrangler secret put CF_IMAGES_API_TOKEN
wrangler secret put CF_STREAM_API_TOKEN
# ... etc

# Edge function secrets
supabase secrets set EDGE_INTERNAL_KEY=your-secret-key
supabase secrets set SB_SERVICE_ROLE_KEY=your-service-role-key
# ... etc
```

---

## 🧪 Testing

### Test Worker Locally

```bash
cd cloudflare
wrangler dev
```

### Test Edge Functions Locally

```bash
cd supabase
supabase functions serve wallet_add
```

### Test Endpoint

```bash
# Health check
curl https://your-worker.workers.dev/

# Create order (with JWT)
curl -X POST https://your-worker.workers.dev/secure/orders/create \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "items": [{"product_id": "uuid", "quantity": 1}],
    "payment_method": "cash"
  }'
```

---

## ❌ Error Responses

جميع الأخطاء تُرجع بهذا الشكل:

```json
{
  "error": "Error type",
  "detail": "Detailed error message"
}
```

### HTTP Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized (JWT invalid)
- `403` - Forbidden (Internal key invalid)
- `404` - Not Found
- `409` - Conflict (e.g., merchant already exists)
- `500` - Internal Server Error

---

## 📱 Flutter Integration Example

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class MbuyApiClient {
  static const String baseUrl = 'https://your-worker.workers.dev';

  Future<String?> getJwtToken() async {
    final session = await Supabase.instance.client.auth.currentSession;
    return session?.accessToken;
  }

  Future<Map<String, dynamic>> createOrder({
    required List<OrderItem> items,
    required String paymentMethod,
  }) async {
    final token = await getJwtToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/secure/orders/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'items': items.map((e) => e.toJson()).toList(),
        'payment_method': paymentMethod,
      }),
    );

    if (response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['detail']);
    }

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    // 1. Get upload URL
    final urlResponse = await http.post(
      Uri.parse('$baseUrl/media/image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'filename': 'image.jpg'}),
    );

    final urlData = jsonDecode(urlResponse.body);

    // 2. Upload image
    await http.put(
      Uri.parse(urlData['uploadURL']),
      body: await imageFile.readAsBytes(),
    );

    // 3. Return view URL
    return urlData;
  }
}
```

---

## 🎉 Complete!

المعمارية الآن جاهزة ومكتملة:
- ✅ Cloudflare Worker (API Gateway)
- ✅ 4 Edge Functions
- ✅ JWT Verification
- ✅ Media Uploads
- ✅ FCM Notifications
- ✅ Payment Integration (ready)
- ✅ Points & Wallet System
- ✅ Double-gate Security

**Base URL:** `https://your-worker.workers.dev`

استبدل `your-worker` باسم Worker الخاص بك بعد النشر.
