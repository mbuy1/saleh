# 📋 خطة ترحيل استدعاءات Supabase المباشرة إلى Worker API

**📅 تاريخ الإنشاء:** 5 ديسمبر 2025  
**🎯 الهدف:** نقل جميع الاتصالات المباشرة بـ Supabase من Flutter إلى Cloudflare Worker  
**⚠️ الحالة:** خطة فقط - لم يتم التنفيذ بعد

---

## 📊 ملخص تنفيذي

| العنصر | العدد |
|--------|-------|
| **إجمالي الاستدعاءات المباشرة** | 11 استدعاء |
| **عدد الملفات المتأثرة** | 6 ملفات |
| **عدد الجداول المستخدمة** | 6 جداول |
| **Endpoints مطلوبة في Worker** | 8 endpoints جديدة |

---

## 1️⃣ جدول الاستدعاءات المباشرة الحالية

### 🔴 المجموعة الأولى: Auth (التسجيل وإنشاء الحسابات)

| # | الملف | السطر | العملية | الجدول | السياق |
|---|-------|-------|---------|--------|---------|
| 1 | `lib/features/auth/data/auth_service.dart` | 75 | INSERT | `user_profiles` | إنشاء ملف المستخدم بعد التسجيل |
| 2 | `lib/features/auth/data/auth_service.dart` | 88 | INSERT | `wallets` | إنشاء محفظة للمستخدم الجديد |
| 3 | `lib/core/root_widget.dart` | 128 | INSERT | `user_profiles` | إنشاء ملف إذا لم يكن موجوداً |
| 4 | `lib/core/root_widget.dart` | 135 | INSERT | `wallets` | إنشاء محفظة إذا لم تكن موجودة |

**الحقول المُستخدمة:**
```dart
// user_profiles
{
  'id': userId,
  'role': 'customer' | 'merchant',
  'display_name': displayName,
}

// wallets
{
  'owner_id': userId,
  'type': 'customer' | 'merchant',
  'balance': 0,
  'currency': 'SAR',
}
```

---

### 🟡 المجموعة الثانية: Customer (الطلبات والسلة)

| # | الملف | السطر | العملية | الجدول | السياق |
|---|-------|-------|---------|--------|---------|
| 5 | `lib/features/customer/data/order_service.dart` | 64 | INSERT | `order_items` | إضافة عناصر الطلب (loop على cart items) |
| 6 | `lib/features/customer/data/order_service.dart` | 75 | DELETE | `cart_items` | حذف السلة بعد إنشاء الطلب |

**الحقول المُستخدمة:**
```dart
// order_items
{
  'order_id': orderId,
  'product_id': productId,
  'quantity': quantity,
  'price': price, // السعر وقت الطلب
}

// cart_items (DELETE)
WHERE cart_id = ?
```

---

### 🟠 المجموعة الثالثة: Merchant (النقاط والمعاملات)

| # | الملف | السطر | العملية | الجدول | السياق |
|---|-------|-------|---------|--------|---------|
| 7 | `lib/features/merchant/data/merchant_points_service.dart` | 36 | INSERT | `points_accounts` | إنشاء حساب نقاط للتاجر |
| 8 | `lib/features/merchant/data/merchant_points_service.dart` | 124 | INSERT | `points_transactions` | تسجيل صرف نقاط (spend) |
| 9 | `lib/features/merchant/data/merchant_points_service.dart` | 243 | INSERT | `points_transactions` | تسجيل شراء نقاط (purchase) |

**الحقول المُستخدمة:**
```dart
// points_accounts
{
  'user_id': userId,
  'points_balance': 0,
}

// points_transactions (spend)
{
  'points_account_id': accountId,
  'type': 'spend_feature',
  'feature_key': featureKey,
  'points_change': -cost,
  'meta': {...},
}

// points_transactions (purchase)
{
  'points_account_id': accountId,
  'type': 'purchase',
  'feature_key': null,
  'points_change': points,
  'meta': {...},
}
```

---

### 🔵 المجموعة الرابعة: Notifications (FCM Tokens)

| # | الملف | السطر | العملية | الجدول | السياق |
|---|-------|-------|---------|--------|---------|
| 10 | `lib/core/firebase_service.dart` | 390 | INSERT | `user_fcm_tokens` | حفظ FCM token للمستخدم |

**الحقول المُستخدمة:**
```dart
// user_fcm_tokens
{
  'user_id': userId,
  'token': fcmToken,
  'device_type': 'mobile',
  'created_at': timestamp,
}
```

---

### ⚪ ملاحظة: استدعاء معلّق (تم تعطيله)

| # | الملف | السطر | العملية | الجدول | الحالة |
|---|-------|-------|---------|--------|--------|
| 11 | `lib/examples/product_image_upload_example.dart` | 207 | INSERT | `products` | ❌ معلّق (commented out) - لا يحتاج معالجة |

---

## 2️⃣ Worker Endpoints المقترحة

### 🔴 Auth Endpoints

#### 1. إنشاء ملف المستخدم والمحفظة
```typescript
POST /secure/auth/initialize-user
```

**Request Body:**
```json
{
  "role": "customer" | "merchant",
  "display_name": "اسم المستخدم"
}
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "user_profile": { "id": "...", "role": "...", "display_name": "..." },
    "wallet": { "id": "...", "owner_id": "...", "balance": 0, "type": "..." }
  }
}
```

**ما يفعله Worker:**
1. التحقق من JWT token
2. إنشاء سجل في `user_profiles` (أو تحديثه إذا موجود)
3. إنشاء سجل في `wallets` (أو إرجاع الموجود)
4. إرجاع البيانات بشكل موحد

**استخدام في Flutter:**
```dart
// بدلاً من استدعاءين منفصلين
await ApiService.post('/secure/auth/initialize-user', body: {
  'role': role,
  'display_name': displayName,
});
```

---

### 🟡 Customer Endpoints

#### 2. إنشاء طلب من السلة
```typescript
POST /secure/orders/create-from-cart
```

**Request Body:**
```json
{
  "cart_id": "uuid",
  "delivery_address": "العنوان",
  "payment_method": "wallet | cash",
  "total_amount": 100.0
}
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "order_id": "uuid",
    "order_items": [
      { "product_id": "...", "quantity": 2, "price": 50.0 }
    ]
  }
}
```

**ما يفعله Worker:**
1. التحقق من JWT token
2. جلب عناصر السلة من `cart_items`
3. إنشاء سجل في `orders`
4. **Bulk insert** في `order_items` (دفعة واحدة بدلاً من loop)
5. حذف عناصر السلة من `cart_items`
6. **Transaction wrapper** لضمان Atomicity

**فائدة:**
- ✅ أسرع (bulk insert بدلاً من N+1 queries)
- ✅ Transaction آمن (إما ينجح الكل أو يفشل الكل)
- ✅ Validation مركزي

---

### 🟠 Merchant Endpoints

#### 3. إنشاء حساب نقاط
```typescript
POST /secure/merchant/points/create-account
```

**Request Body:**
```json
{
  "initial_balance": 0
}
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "points_account_id": "uuid",
    "user_id": "uuid",
    "points_balance": 0
  }
}
```

**ما يفعله Worker:**
1. التحقق من JWT token
2. استخراج `userId` من JWT
3. إنشاء سجل في `points_accounts` (مع handling للـ duplicate)
4. إرجاع البيانات

---

#### 4. صرف نقاط (Spend Feature)
```typescript
POST /secure/merchant/points/spend
```

**Request Body:**
```json
{
  "feature_key": "feature_ai_assistant",
  "cost": 10,
  "meta": {
    "action": "generate_description",
    "tokens_used": 500
  }
}
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "transaction_id": "uuid",
    "new_balance": 40,
    "points_spent": 10
  }
}
```

**ما يفعله Worker:**
1. التحقق من JWT token
2. جلب `points_account_id` للمستخدم
3. التحقق من الرصيد الكافي
4. تحديث `points_balance` (تقليل)
5. إضافة سجل في `points_transactions`
6. **Transaction wrapper** لضمان Consistency

---

#### 5. شراء نقاط (Purchase Points)
```typescript
POST /secure/merchant/points/purchase
```

**Request Body:**
```json
{
  "points": 100,
  "payment_method": "wallet",
  "meta": {
    "package": "basic",
    "price": 50.0
  }
}
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "transaction_id": "uuid",
    "new_balance": 150,
    "points_added": 100
  }
}
```

**ما يفعله Worker:**
1. التحقق من JWT token
2. جلب `points_account_id`
3. تحديث `points_balance` (زيادة)
4. إضافة سجل في `points_transactions`
5. **Transaction wrapper**

---

### 🔵 Notifications Endpoints

#### 6. تسجيل FCM Token
```typescript
POST /secure/notifications/register-token
```

**Request Body:**
```json
{
  "fcm_token": "fcm_token_string",
  "device_type": "android" | "ios" | "web"
}
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "token_id": "uuid",
    "registered_at": "2025-12-05T10:00:00Z"
  }
}
```

**ما يفعله Worker:**
1. التحقق من JWT token
2. استخراج `userId` من JWT
3. البحث عن Token موجود بنفس القيمة
4. إذا لم يوجد → INSERT جديد
5. إذا موجود → UPDATE `updated_at`

---

## 3️⃣ ملخص Endpoints المطلوبة

| # | Endpoint | Method | الميزة الرئيسية |
|---|----------|--------|-----------------|
| 1 | `/secure/auth/initialize-user` | POST | إنشاء ملف + محفظة دفعة واحدة |
| 2 | `/secure/orders/create-from-cart` | POST | Bulk insert + Transaction |
| 3 | `/secure/merchant/points/create-account` | POST | Duplicate handling |
| 4 | `/secure/merchant/points/spend` | POST | Balance check + Transaction |
| 5 | `/secure/merchant/points/purchase` | POST | Transaction wrapper |
| 6 | `/secure/notifications/register-token` | POST | Upsert logic |

**إجمالي:** 6 endpoints جديدة

---

## 4️⃣ خطة الترحيل المقترحة (بالترتيب)

### 🔴 المرحلة 1: Notifications (الأسهل - 1 ساعة)

**الترتيب:** 1  
**الأولوية:** منخفضة (لكن الأسهل للبدء)

**الخطوات:**
1. ✅ إنشاء endpoint في Worker: `POST /secure/notifications/register-token`
2. ✅ تعديل `lib/core/firebase_service.dart` (السطر 390)
3. ✅ اختبار FCM token registration
4. ✅ حذف الاستدعاء المباشر

**الوقت المقدر:** 1 ساعة

---

### 🟡 المرحلة 2: Auth (مهم - 2-3 ساعات)

**الترتيب:** 2  
**الأولوية:** عالية (يؤثر على التسجيل)

**الخطوات:**
1. ✅ إنشاء endpoint في Worker: `POST /secure/auth/initialize-user`
2. ✅ تعديل `lib/features/auth/data/auth_service.dart` (السطور 75, 88)
3. ✅ تعديل `lib/core/root_widget.dart` (السطور 128, 135)
4. ✅ اختبار التسجيل الجديد (customer + merchant)
5. ✅ اختبار حالة المستخدم الموجود مسبقاً
6. ✅ حذف الاستدعاءات المباشرة

**الوقت المقدر:** 2-3 ساعات

---

### 🟠 المرحلة 3: Merchant Points (متوسط - 3-4 ساعات)

**الترتيب:** 3  
**الأولوية:** متوسطة

**الخطوات:**
1. ✅ إنشاء 3 endpoints:
   - `POST /secure/merchant/points/create-account`
   - `POST /secure/merchant/points/spend`
   - `POST /secure/merchant/points/purchase`
2. ✅ تعديل `lib/features/merchant/data/merchant_points_service.dart` (السطور 36, 124, 243)
3. ✅ اختبار:
   - إنشاء حساب نقاط
   - صرف نقاط (مع فحص الرصيد)
   - شراء نقاط
4. ✅ حذف الاستدعاءات المباشرة

**الوقت المقدر:** 3-4 ساعات

---

### 🟢 المرحلة 4: Customer Orders (الأكثر تعقيداً - 4-5 ساعات)

**الترتيب:** 4  
**الأولوية:** عالية (core functionality)

**الخطوات:**
1. ✅ إنشاء endpoint: `POST /secure/orders/create-from-cart`
2. ✅ تطبيق Transaction logic في Worker:
   ```typescript
   // Pseudo-code
   BEGIN TRANSACTION
     1. SELECT cart_items
     2. INSERT INTO orders
     3. BULK INSERT INTO order_items
     4. DELETE FROM cart_items
   COMMIT
   ```
3. ✅ تعديل `lib/features/customer/data/order_service.dart` (السطور 64, 75)
4. ✅ إزالة loop → استخدام bulk insert
5. ✅ اختبار:
   - إنشاء طلب من سلة فارغة (error handling)
   - إنشاء طلب من سلة بعناصر متعددة
   - التحقق من حذف السلة بعد الطلب
6. ✅ حذف الاستدعاءات المباشرة

**الوقت المقدر:** 4-5 ساعات

---

## 5️⃣ جدول زمني مقترح

| المرحلة | الوقت | التراكمي | الأولوية |
|---------|-------|----------|----------|
| **1. Notifications** | 1 ساعة | 1 ساعة | 🔵 منخفضة |
| **2. Auth** | 2-3 ساعات | 3-4 ساعات | 🔴 عالية |
| **3. Merchant Points** | 3-4 ساعات | 6-8 ساعات | 🟡 متوسطة |
| **4. Customer Orders** | 4-5 ساعات | 10-13 ساعة | 🔴 عالية |

**الوقت الإجمالي:** 10-13 ساعة عمل فعلي

**توزيع مقترح:**
- **اليوم 1:** المرحلة 1 + 2 (Notifications + Auth) - 3-4 ساعات
- **اليوم 2:** المرحلة 3 (Merchant Points) - 3-4 ساعات
- **اليوم 3:** المرحلة 4 (Customer Orders) + اختبار شامل - 4-5 ساعات

---

## 6️⃣ فوائد الترحيل

### ✅ الأمان
- 🔐 JWT verification موحد
- 🔐 لا مزيد من ANON_KEY في Flutter
- 🔐 Rate limiting مركزي
- 🔐 Input validation في مكان واحد

### ✅ الأداء
- ⚡ Bulk inserts بدلاً من N+1 queries
- ⚡ Transaction wrappers لـ Atomicity
- ⚡ Connection pooling في Worker
- ⚡ Edge caching ممكن

### ✅ الصيانة
- 🛠️ Business logic في مكان واحد
- 🛠️ سهولة التعديل (Worker فقط)
- 🛠️ Logging مركزي
- 🛠️ Error handling موحد

### ✅ الموثوقية
- ✅ Transaction wrappers تمنع data inconsistency
- ✅ Duplicate handling واضح
- ✅ Rollback تلقائي عند الفشل

---

## 7️⃣ مخاطر ونقاط الانتباه

### ⚠️ مخاطر محتملة

#### 1. Breaking Changes
**المشكلة:** تغيير API قد يكسر التطبيقات الموجودة  
**الحل:**
- اختبار شامل قبل الإطلاق
- إنشاء endpoints جديدة بدون حذف القديمة أولاً
- إطلاق تدريجي (versioning: `/v2/secure/...`)

#### 2. Transaction Timeout
**المشكلة:** Worker قد يتوقف عند معاملات طويلة (CPU time limit)  
**الحل:**
- استخدام Supabase transactions (Postgres native)
- تجنب nested transactions معقدة
- Timeout handling في Worker

#### 3. Data Migration
**المشكلة:** بيانات موجودة قد لا تتوافق مع Validation الجديد  
**الحل:**
- فحص البيانات الموجودة أولاً
- إضافة migration script إذا لزم الأمر
- Soft validation (تحذيرات بدلاً من أخطاء)

---

### 🎯 نقاط الانتباه

#### 1. Error Messages
- ✅ رسائل خطأ واضحة بالعربية
- ✅ Error codes موحدة (400, 401, 403, 500)
- ✅ Logging في Worker لكل فشل

#### 2. Testing Checklist
```markdown
□ اختبار حالة النجاح (Happy path)
□ اختبار حالة المستخدم غير مسجل (Unauthorized)
□ اختبار حالة البيانات المفقودة (Missing fields)
□ اختبار حالة Duplicate (مثل FCM token موجود)
□ اختبار حالة Transaction failure (Rollback)
□ اختبار حالة Rate limiting (إذا مفعل)
```

#### 3. Rollback Plan
إذا فشل الترحيل:
1. ✅ Worker endpoints الجديدة لن تؤثر على القديمة
2. ✅ يمكن العودة للاستدعاءات المباشرة بسهولة (Git revert)
3. ✅ لا حاجة لـ database migration (البيانات نفسها)

---

## 8️⃣ ملفات ستُعدّل (6 ملفات فقط)

### Flutter Files (4 ملفات)

1. **`lib/core/firebase_service.dart`**
   - السطر 390: FCM token registration

2. **`lib/features/auth/data/auth_service.dart`**
   - السطور 75, 88: إنشاء user_profile + wallet

3. **`lib/core/root_widget.dart`**
   - السطور 128, 135: إنشاء user_profile + wallet (fallback)

4. **`lib/features/customer/data/order_service.dart`**
   - السطور 64, 75: إنشاء order_items + حذف cart_items

5. **`lib/features/merchant/data/merchant_points_service.dart`**
   - السطور 36, 124, 243: نقاط التاجر (إنشاء + صرف + شراء)

### Worker Files (1 ملف)

6. **`mbuy-worker/src/index.ts`**
   - إضافة 6 endpoints جديدة (~200 سطر جديد)

---

## 9️⃣ الخطوة التالية

### ما يجب عمله الآن:

1. **مراجعة هذه الخطة** ✅ (أنت هنا)
2. **الموافقة على الترتيب والأولويات**
3. **البدء بالمرحلة 1** (Notifications - الأسهل)
4. **اختبار كل مرحلة قبل الانتقال للتالية**

### الأمر التالي المقترح:

```bash
# بعد الموافقة، سنبدأ بـ:
"ابدأ بالمرحلة 1: إنشاء endpoint للـ FCM tokens"
```

---

## 📞 ملاحظات ختامية

### ✅ ما تم في هذه الوثيقة:

- ✅ تحديد جميع الاستدعاءات المباشرة (11 استدعاء)
- ✅ تصنيفها حسب الـ feature (4 مجموعات)
- ✅ اقتراح 6 endpoints في Worker
- ✅ خطة زمنية واضحة (10-13 ساعة)
- ✅ تحديد المخاطر والحلول
- ✅ تحديد الملفات المتأثرة (6 ملفات)

### ⚠️ ما لم يتم بعد:

- ❌ لم يتم تعديل أي كود
- ❌ لم يتم إنشاء Endpoints
- ❌ لم يتم الاختبار

### 🎯 الهدف النهائي:

**0 استدعاءات مباشرة لـ Supabase في Flutter**  
**جميع العمليات عبر Worker API فقط**

---

**📋 الوثيقة جاهزة للمراجعة والموافقة**

