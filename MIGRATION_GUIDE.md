# 🔄 دليل الترحيل من Supabase المباشر إلى API Gateway

## 📖 نظرة عامة

تم إنشاء طبقة **API Gateway** باستخدام Cloudflare Worker لتأمين جميع عمليات الـ backend.

### ما الذي تغير؟

#### ❌ القديم (غير آمن)
```dart
// الاتصال المباشر بـ Supabase
final response = await supabaseClient
    .from('wallets')
    .select()
    .eq('owner_id', userId)
    .single();
```

#### ✅ الجديد (آمن)
```dart
// عبر API Gateway
final wallet = await WalletService.getBalance();
```

---

## 🛠️ الـ Services المتاحة

تم إنشاء 4 services رئيسية في `lib/core/services/`:

### 1. WalletService
```dart
import 'package:saleh/core/services/services.dart';

// الحصول على الرصيد
final balance = await WalletService.getBalance();

// إضافة رصيد
await WalletService.addFunds(
  amount: 100.0,
  paymentMethod: 'card',
  paymentReference: 'pay_123',
);

// التحقق من كفاية الرصيد
final hasEnough = await WalletService.hasSufficientBalance(50.0);
```

### 2. PointsService
```dart
// الحصول على النقاط
final points = await PointsService.getBalance();

// تحويل نقاط إلى ريال
final sar = PointsService.pointsToSAR(100); // 10.0 SAR

// التحقق من كفاية النقاط
final hasPoints = await PointsService.hasSufficientPoints(50);
```

### 3. OrderService
```dart
// إنشاء طلب
final result = await OrderService.createOrder(
  cartItems: [
    {'product_id': 'uuid', 'quantity': 2, 'price': 150.0},
  ],
  deliveryAddress: 'العنوان',
  paymentMethod: 'wallet',
  pointsToUse: 100,
);

// حساب ملخص الطلب
final summary = OrderService.calculateOrderSummary(
  items: cartItems,
  pointsToUse: 100,
  couponDiscount: 20.0,
);
```

### 4. MediaService
```dart
// رفع صورة
final imageUrl = await MediaService.uploadImage(imageFile);

// رفع عدة صور
final urls = await MediaService.uploadImages(imageFiles);
```

---

## 📝 أمثلة التحديث

### مثال 1: تحديث صفحة المحفظة

#### قبل:
```dart
Future<void> _loadWallet() async {
  final user = supabaseClient.auth.currentUser;
  final response = await supabaseClient
      .from('wallets')
      .select()
      .eq('owner_id', user!.id)
      .single();
      
  setState(() {
    _balance = response['balance'];
  });
}
```

#### بعد:
```dart
Future<void> _loadWallet() async {
  final balance = await WalletService.getBalance();
  setState(() {
    _balance = balance;
  });
}
```

### مثال 2: تحديث إضافة رصيد

#### قبل:
```dart
// كان يتطلب service_role_key في Flutter (غير آمن!)
await supabaseClient.from('wallet_transactions').insert({
  'wallet_id': walletId,
  'amount': amount,
  'type': 'credit',
});
```

#### بعد:
```dart
// آمن - يتم عبر API Gateway
await WalletService.addFunds(
  amount: amount,
  paymentMethod: paymentMethod,
  paymentReference: reference,
);
```

### مثال 3: تحديث إنشاء طلب

#### قبل:
```dart
// معالجة معقدة في Flutter
final orderId = uuid.v4();
await supabaseClient.from('orders').insert({...});
await supabaseClient.from('order_items').insert([...]);
// تحديث المخزون
// خصم النقاط
// إرسال إشعارات
```

#### بعد:
```dart
// كل شيء يحدث في الـ backend
final result = await OrderService.createOrder(
  cartItems: cartItems,
  deliveryAddress: address,
  paymentMethod: 'wallet',
  pointsToUse: 100,
);
```

---

## 🔍 الملفات التي تحتاج تحديث

### أولوية عالية ⚠️
هذه الملفات تستخدم عمليات حساسة يجب تحديثها فوراً:

1. **Wallet Screens**
   - `lib/features/customer/presentation/screens/customer_wallet_screen.dart`
   - `lib/features/merchant/presentation/screens/merchant_wallet_screen.dart`
   - استبدل جميع `supabaseClient.from('wallets')` بـ `WalletService`

2. **Order Screens**
   - أي ملف يحتوي على `supabaseClient.from('orders')`
   - استخدم `OrderService.createOrder()` بدلاً من الإدراج المباشر

3. **Points Screens**
   - أي ملف يتعامل مع `points_accounts`
   - استخدم `PointsService`

### أولوية متوسطة 📋

4. **Product Management**
   - `lib/features/merchant/presentation/screens/merchant_products_screen.dart`
   - استخدم `MediaService` لرفع صور المنتجات

5. **Merchant Registration**
   - أي ملف يسجل تاجر جديد
   - استخدم `ApiService.registerMerchant()`

### أولوية منخفضة ✅

6. **Read-Only Operations**
   - عمليات القراءة (SELECT) يمكن أن تبقى مباشرة مع Supabase
   - لكن يفضل نقلها تدريجياً للـ API Gateway

---

## ⚡ خطوات التحديث السريعة

### 1. أضف import
```dart
import 'package:saleh/core/services/services.dart';
import 'package:saleh/core/api_service.dart';
```

### 2. استبدل الكود
استخدم Find & Replace في VS Code:

**البحث عن:**
```dart
supabaseClient.from('wallets')
```

**استبدال بـ:**
```dart
WalletService
```

### 3. تحديث الأساليب
- `select()` → استخدم `getBalance()` أو `getWalletDetails()`
- `insert()` → استخدم `addFunds()`
- `update()` → استخدم الـ service المناسب

---

## 🎯 أمثلة متقدمة

### مثال: شاشة Checkout كاملة

```dart
class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  
  const CheckoutScreen({required this.cartItems});
  
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double _walletBalance = 0.0;
  int _pointsBalance = 0;
  int _pointsToUse = 0;
  
  @override
  void initState() {
    super.initState();
    _loadBalances();
  }
  
  Future<void> _loadBalances() async {
    final wallet = await WalletService.getBalance();
    final points = await PointsService.getBalance();
    
    setState(() {
      _walletBalance = wallet;
      _pointsBalance = points;
    });
  }
  
  Future<void> _processOrder() async {
    // حساب الملخص
    final summary = OrderService.calculateOrderSummary(
      items: widget.cartItems,
      pointsToUse: _pointsToUse,
    );
    
    final total = summary['total']!;
    
    // التحقق من الرصيد
    if (!await WalletService.hasSufficientBalance(total)) {
      _showError('رصيد غير كافٍ');
      return;
    }
    
    // إنشاء الطلب
    final result = await OrderService.createOrder(
      cartItems: widget.cartItems,
      deliveryAddress: _addressController.text,
      paymentMethod: 'wallet',
      pointsToUse: _pointsToUse,
    );
    
    if (result != null) {
      _showSuccess('تم إنشاء الطلب بنجاح');
      Navigator.pop(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إتمام الطلب')),
      body: Column(
        children: [
          // عرض الرصيد والنقاط
          Card(
            child: ListTile(
              title: Text('رصيد المحفظة: $_walletBalance SAR'),
              subtitle: Text('النقاط: $_pointsBalance'),
            ),
          ),
          
          // اختيار النقاط للاستخدام
          Slider(
            value: _pointsToUse.toDouble(),
            max: _pointsBalance.toDouble(),
            onChanged: (value) {
              setState(() => _pointsToUse = value.toInt());
            },
          ),
          
          // زر الطلب
          ElevatedButton(
            onPressed: _processOrder,
            child: const Text('تأكيد الطلب'),
          ),
        ],
      ),
    );
  }
}
```

---

## 🔐 ملاحظات أمنية مهمة

### ✅ الأمان الآن
- جميع المفاتيح السرية في Cloudflare Worker
- JWT verification على مستوى API Gateway
- Double-gate security (JWT + INTERNAL_KEY)
- لا توجد service keys في Flutter

### ❌ تجنب
- **لا تستخدم** `service_role_key` في Flutter أبداً
- **لا تضع** أي مفاتيح API في الكود
- **لا تتجاوز** API Gateway للعمليات الحساسة

---

## 📞 الدعم

إذا واجهت مشاكل:

1. تحقق من الأمثلة في `lib/examples/api_service_examples.dart`
2. راجع الدليل الكامل في `QUICK_START_GUIDE.md`
3. تحقق من logs في:
   - Cloudflare Worker Logs
   - Supabase Edge Function Logs

---

## ✨ الفوائد

✅ **أمان أعلى** - جميع المفاتيح في الـ backend
✅ **كود أبسط** - service layer واضح
✅ **أداء أفضل** - Cloudflare Edge Network
✅ **صيانة أسهل** - centralized business logic
✅ **توسع أسرع** - إضافة features جديدة بسهولة

---

تم التحديث: 4 ديسمبر 2025
