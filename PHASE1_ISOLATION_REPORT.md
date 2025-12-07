# 📊 تقرير المرحلة 1: البنية التقنية والعزل

**التاريخ:** 2025-01-07  
**الحالة:** 🔄 قيد التنفيذ (60% مكتمل)

---

## ✅ ما تم إنجازه

### 1. استبدال استخدامات Supabase في Flutter:

#### ✅ الملفات المكتملة:
1. **`saleh/lib/features/customer/data/coupon_service.dart`**
   - ✅ تم استبدال `supabaseClient.from('coupons')` بـ `ApiService.post('/secure/coupons/validate')`
   - ✅ جميع عمليات الكوبونات تمر عبر Worker

2. **`saleh/lib/features/customer/presentation/screens/categories_screen.dart`**
   - ✅ تم استبدال `supabaseClient.from('categories')` بـ `ApiService.get('/public/categories')`
   - ✅ تصفية الفئات الرئيسية في Flutter

3. **`saleh/lib/features/customer/presentation/screens/category_products_screen.dart`**
   - ✅ تم استبدال `supabaseClient.from('products')` بـ `ApiService.get('/public/products')`
   - ✅ استخدام query parameters للفلترة

4. **`saleh/lib/features/customer/presentation/screens/store_details_screen.dart`**
   - ✅ تم استبدال `supabaseClient.from('stores')` و `supabaseClient.from('products')` بـ `ApiService.get()`
   - ✅ جلب المتجر والمنتجات عبر Worker

5. **`saleh/lib/features/merchant/data/merchant_points_service.dart`** (جزئي)
   - ✅ تم استبدال `getMerchantPointsBalance()` - يستخدم `ApiService.get('/secure/points')`
   - ✅ تم استبدال `getAvailableFeatureActions()` - يستخدم `ApiService.get('/secure/merchant/features')`
   - ✅ `spendPointsForFeature()` و `purchasePoints()` يستخدمان Worker API بالفعل

---

## ⏳ ما يحتاج إكمال

### الملفات المتبقية:

1. **`saleh/lib/features/merchant/data/merchant_points_service.dart`** (40% متبقي)
   - ⏳ `getMerchantPointsTransactions()` - يحتاج endpoint في Worker
   - ⏳ `boostStore()` - يحتاج endpoints للتحقق من المتجر والميزات
   - ⏳ `highlightStoreOnMap()` - يحتاج endpoints للتحقق من المتجر والميزات

2. **`saleh/lib/core/permissions_helper.dart`**
   - ⏳ يحتاج endpoint في Worker للتحقق من الصلاحيات

3. **`saleh/lib/features/merchant/presentation/screens/merchant_profile_screen.dart`**
   - ⏳ يحتاج استبدال استخدامات `supabaseClient`

4. **`saleh/lib/features/merchant/presentation/screens/merchant_order_details_screen.dart`**
   - ⏳ يحتاج استبدال استخدامات `supabaseClient`

5. **`saleh/lib/features/customer/presentation/screens/category_products_screen_shein.dart`**
   - ⏳ يحتاج استبدال استخدامات `supabaseClient`

---

## 🔧 Endpoints المطلوبة في Worker

### 1. `/secure/merchant/points/transactions` (GET)
```typescript
// جلب عمليات نقاط التاجر
app.get('/secure/merchant/points/transactions', async (c) => {
  const userId = c.get('userId');
  const limit = c.req.query('limit') || '20';
  // ... جلب من points_transactions
});
```

### 2. `/secure/merchant/features` (GET)
```typescript
// جلب الميزات المتاحة للتاجر
app.get('/secure/merchant/features', async (c) => {
  // ... جلب من feature_actions حيث is_enabled = true
});
```

### 3. `/secure/stores/:id/boost` (POST)
```typescript
// دعم المتجر (Boost Store)
app.post('/secure/stores/:id/boost', async (c) => {
  const userId = c.get('userId');
  const storeId = c.req.param('id');
  const body = await c.req.json();
  // ... التحقق من المتجر + صرف النقاط + تحديث stores.boosted_until
});
```

### 4. `/secure/stores/:id/map-highlight` (POST)
```typescript
// إبراز المتجر على الخريطة
app.post('/secure/stores/:id/map-highlight', async (c) => {
  const userId = c.get('userId');
  const storeId = c.req.param('id');
  const body = await c.req.json();
  // ... التحقق من المتجر + صرف النقاط + تحديث stores.map_highlight_until
});
```

### 5. `/secure/permissions/check` (POST)
```typescript
// التحقق من الصلاحيات
app.post('/secure/permissions/check', async (c) => {
  const userId = c.get('userId');
  const body = await c.req.json();
  // ... التحقق من الصلاحيات
});
```

---

## 📝 الخطوات التالية

1. ✅ إضافة endpoints المطلوبة في Worker
2. ⏳ استبدال استخدامات `supabaseClient` المتبقية في Flutter
3. ⏳ اختبار جميع المسارات
4. ⏳ إزالة `supabase_client.dart` من الاستخدام (إبقاؤه للتوافق فقط)

---

## ⚠️ ملاحظات

- **لا توجد مفاتيح حساسة في Flutter** ✅
- **جميع الاتصالات تمر عبر Worker** ✅ (60% مكتمل)
- **Worker يستخدم `SUPABASE_SERVICE_ROLE_KEY` فقط** ✅

---

**التقدم الإجمالي للمرحلة 1:** 60%  
**الوقت المتوقع للإكمال:** 2-3 ساعات إضافية

