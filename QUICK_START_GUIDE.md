# 🚀 MBUY - دليل البدء السريع

## ✅ تم التنفيذ بنجاح!

جميع مكونات النظام تعمل الآن:
- ✅ Cloudflare Worker (API Gateway)
- ✅ 4 Edge Functions
- ✅ Database Functions
- ✅ جميع الـ Secrets

---

## 🔗 الـ Endpoints الرئيسية

### Base URL
```
https://misty-mode-b68b.baharista1.workers.dev
```

---

## 📱 1. رفع الصور والفيديوهات

### رفع صورة
```bash
POST /media/image
Content-Type: application/json

{
  "filename": "product.jpg"
}
```

**Response:**
```json
{
  "ok": true,
  "uploadURL": "https://upload.imagedelivery.net/...",
  "id": "49c1a8d7-0f44-4693-f248-e836ccf6f900",
  "viewURL": "https://imagedelivery.net/.../public"
}
```

**Flutter Example:**
```dart
// 1. احصل على upload URL
final response = await http.post(
  Uri.parse('https://misty-mode-b68b.baharista1.workers.dev/media/image'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode({'filename': 'product.jpg'}),
);

final data = json.decode(response.body);
final uploadURL = data['uploadURL'];
final viewURL = data['viewURL'];

// 2. ارفع الصورة
final file = File('path/to/image.jpg');
final uploadResponse = await http.post(
  Uri.parse(uploadURL),
  body: file.readAsBytesSync(),
  headers: {'Content-Type': 'image/jpeg'},
);

// 3. احفظ viewURL في database
print('Image URL: $viewURL');
```

### رفع فيديو
```bash
POST /media/video
Content-Type: application/json

{
  "filename": "demo.mp4"
}
```

---

## 👤 2. تسجيل التاجر

```bash
POST /public/register
Content-Type: application/json

{
  "user_id": "uuid-here",
  "store_name": "متجر الإلكترونيات",
  "city": "الرياض",
  "district": "حي النخيل",
  "address": "شارع الملك فهد، مبنى 123"
}
```

**Response:**
```json
{
  "ok": true,
  "store": { /* بيانات المتجر */ },
  "wallet": { /* محفظة التاجر */ },
  "points": { /* حساب النقاط مع 100 نقطة ترحيبية */ }
}
```

**Flutter Example:**
```dart
final user = supabase.auth.currentUser!;

final response = await http.post(
  Uri.parse('https://misty-mode-b68b.baharista1.workers.dev/public/register'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode({
    'user_id': user.id,
    'store_name': storeNameController.text,
    'city': selectedCity,
    'district': districtController.text,
    'address': addressController.text,
  }),
);

if (response.statusCode == 200) {
  final data = json.decode(response.body);
  print('Store created: ${data['store']['id']}');
  print('Welcome bonus: ${data['points']['balance']} points');
}
```

---

## 💰 3. عمليات المحفظة (تحتاج JWT)

### الحصول على رصيد المحفظة
```bash
GET /secure/wallet
Authorization: Bearer <JWT_TOKEN>
```

**Flutter Example:**
```dart
final session = supabase.auth.currentSession!;
final jwt = session.accessToken;

final response = await http.get(
  Uri.parse('https://misty-mode-b68b.baharista1.workers.dev/secure/wallet'),
  headers: {'Authorization': 'Bearer $jwt'},
);

final data = json.decode(response.body);
final balance = data['data']['balance'];
print('Wallet balance: $balance SAR');
```

### إضافة رصيد للمحفظة
```bash
POST /secure/wallet/add
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json

{
  "amount": 100.50,
  "payment_method": "card",
  "payment_reference": "pay_123456789"
}
```

**Flutter Example:**
```dart
final response = await http.post(
  Uri.parse('https://misty-mode-b68b.baharista1.workers.dev/secure/wallet/add'),
  headers: {
    'Authorization': 'Bearer $jwt',
    'Content-Type': 'application/json',
  },
  body: json.encode({
    'amount': 100.50,
    'payment_method': 'card',
    'payment_reference': 'pay_123456789',
  }),
);
```

---

## ⭐ 4. عمليات النقاط (تحتاج JWT)

### الحصول على رصيد النقاط
```bash
GET /secure/points
Authorization: Bearer <JWT_TOKEN>
```

### إضافة أو خصم نقاط
```bash
POST /secure/points/add
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json

{
  "points": 50,
  "reason": "purchase_reward"
}
```

**لخصم النقاط:**
```json
{
  "points": -20,
  "reason": "discount_used"
}
```

---

## 🛒 5. إنشاء طلب (تحتاج JWT)

```bash
POST /secure/orders/create
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json

{
  "products": [
    {
      "product_id": "uuid-1",
      "quantity": 2,
      "price": 150.00
    },
    {
      "product_id": "uuid-2",
      "quantity": 1,
      "price": 300.00
    }
  ],
  "delivery_address": "حي النخيل، الرياض",
  "payment_method": "wallet",
  "points_to_use": 100,
  "coupon_code": "SAVE10"
}
```

**Flutter Example:**
```dart
final response = await http.post(
  Uri.parse('https://misty-mode-b68b.baharista1.workers.dev/secure/orders/create'),
  headers: {
    'Authorization': 'Bearer $jwt',
    'Content-Type': 'application/json',
  },
  body: json.encode({
    'products': cartItems.map((item) => {
      'product_id': item.productId,
      'quantity': item.quantity,
      'price': item.price,
    }).toList(),
    'delivery_address': deliveryAddress,
    'payment_method': 'wallet', // wallet, cash, card, tap, hyperpay, tamara, tabby
    'points_to_use': pointsToUse,
  }),
);

if (response.statusCode == 200) {
  final data = json.decode(response.body);
  print('Order created: ${data['order']['id']}');
  print('Total: ${data['order']['total_amount']} SAR');
}
```

---

## 🔐 الحصول على JWT Token

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

// 1. تسجيل الدخول
final response = await supabase.auth.signInWithPassword(
  email: 'user@example.com',
  password: 'password123',
);

// 2. احصل على JWT
final session = supabase.auth.currentSession;
final jwt = session!.accessToken;

// 3. استخدم JWT في جميع الطلبات
final headers = {
  'Authorization': 'Bearer $jwt',
  'Content-Type': 'application/json',
};
```

---

## 📊 Payment Methods المتاحة

| Method | الوصف | الحالة |
|--------|------|--------|
| `wallet` | الدفع من المحفظة | ✅ متاح |
| `cash` | الدفع عند الاستلام | ✅ متاح |
| `card` | بطاقة مباشرة | 🔄 جاهز للربط |
| `tap` | Tap Payments | 🔄 جاهز للربط |
| `hyperpay` | HyperPay | 🔄 جاهز للربط |
| `tamara` | Tamara (تقسيط) | 🔄 جاهز للربط |
| `tabby` | Tabby (تقسيط) | 🔄 جاهز للربط |

---

## 📱 إعداد FCM Notifications

### 1. حفظ FCM Token
عند تسجيل الدخول، احفظ FCM token في `user_profiles`:

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

final fcmToken = await FirebaseMessaging.instance.getToken();

await supabase.from('user_profiles').update({
  'fcm_token': fcmToken,
}).eq('id', user.id);
```

### 2. استقبال الإشعارات
```dart
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Notification: ${message.notification?.title}');
  print('Data: ${message.data}');
  
  // أنواع الإشعارات:
  // - wallet_credit: رصيد محفظة جديد
  // - points_credit: نقاط جديدة
  // - order_created: طلب جديد (للتاجر)
  // - order_confirmed: تأكيد الطلب (للعميل)
});
```

---

## 🎯 النقاط الرئيسية

### ✅ الأمان
- جميع الـ endpoints الحساسة تحتاج JWT
- لا توجد service keys في Flutter
- Double-gate security (JWT + INTERNAL_KEY)

### ✅ الأداء
- Cloudflare Edge Network (سرعة عالية)
- Caching تلقائي للصور
- Database functions محسّنة

### ✅ المرونة
- دعم 7 طرق دفع
- نظام نقاط متكامل
- إشعارات فورية

---

## 🔍 التحقق من الحالة

```bash
# Health Check
curl https://misty-mode-b68b.baharista1.workers.dev

# Expected: {"ok":true,"message":"MBUY API Gateway","version":"1.0.0"}
```

---

## 📞 الدعم والمتابعة

- **Cloudflare Dashboard**: https://dash.cloudflare.com/
- **Supabase Dashboard**: https://supabase.com/dashboard/project/sirqidofuvphqcxqchyc
- **Worker Logs**: Cloudflare → Workers → misty-mode-b68b → Logs
- **Edge Function Logs**: Supabase → Functions → [اسم الـ Function] → Logs

---

تم التحديث: 4 ديسمبر 2025 ✅
