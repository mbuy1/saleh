# 📘 دليل الترحيل من Supabase Direct إلى Worker API

## 🎯 الهدف
تحويل جميع استدعاءات `supabaseClient.from()` المباشرة إلى استدعاءات API عبر Worker

---

## 📝 النمط العام

### ❌ القديم (مباشر)
```dart
import '../../../core/supabase_client.dart';

final result = await supabaseClient
    .from('table_name')
    .insert({'field': 'value'})
    .select();
```

### ✅ الجديد (عبر Worker)
```dart
import '../../../core/services/api_service.dart';

final result = await ApiService.post(
  '/secure/resource/action',
  body: {'field': 'value'},
);
```

---

## 🛒 1. Cart Operations

### إضافة عنصر للسلة
```dart
// ❌ القديم
await supabaseClient.from('cart_items').insert({
  'user_id': userId,
  'product_id': productId,
  'quantity': quantity,
  'price': price,
});

// ✅ الجديد
await ApiService.post('/secure/cart/add', body: {
  'product_id': productId,
  'quantity': quantity,
  'price': price,
});
// ملاحظة: user_id سيتم استخراجه من JWT في Worker
```

### حذف عنصر من السلة
```dart
// ❌ القديم
await supabaseClient.from('cart_items').delete().eq('id', cartItemId);

// ✅ الجديد
await ApiService.delete('/secure/cart/item/$cartItemId');
```

### مسح السلة
```dart
// ❌ القديم
await supabaseClient.from('cart_items').delete().eq('user_id', userId);

// ✅ الجديد
await ApiService.delete('/secure/cart/clear');
```

**Worker Endpoint المطلوب:**
```typescript
// في cloudflare/src/index.ts
app.post('/secure/cart/add', async (c) => {
  const userId = c.get('userId');
  const body = await c.req.json();
  
  const response = await fetch(
    `${c.env.SUPABASE_URL}/functions/v1/cart_add`,
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-internal-key': c.env.EDGE_INTERNAL_KEY,
        'x-user-id': userId,
      },
      body: JSON.stringify(body),
    }
  );
  
  return c.json(await response.json(), response.status);
});
```

---

## 📊 قائمة المراجعة

- [ ] Cart: 5 استدعاءات
- [ ] Orders: 1 استدعاء
- [ ] Favorites: 1 استدعاء  
- [ ] Stories: 2 استدعاءات
- [ ] Auth/Users: 2 استدعاءات
- [ ] Merchant: 4 استدعاءات
- [ ] Notifications: 1 استدعاء
- [ ] Root Widget: 2 استدعاءات

**المجموع:** 20 استدعاء

---

## ✅ المعايير النهائية

عند الانتهاء، يجب أن:
- ✅ لا توجد استدعاءات `supabaseClient.from()` في Flutter
- ✅ جميع العمليات تمر عبر `ApiService`
- ✅ JWT verification في Worker لكل طلب
- ✅ Logging مركزي في Worker
- ✅ Error handling موحد
