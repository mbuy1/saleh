# 🗂️ جدول مرجعي سريع - RLS Policies

## 📋 قائمة الجداول والـ Policies

| # | الجدول | RLS | عدد Policies | عام للقراءة | ملاحظات |
|---|--------|-----|-------------|-------------|----------|
| 1 | `user_profiles` | ✅ | 5 | Merchants فقط | المستخدم يرى profile الخاص فقط |
| 2 | `stores` | ✅ | 6 | Active stores | التاجر يرى متاجره كلها |
| 3 | `products` | ✅ | 6 | Active products | التاجر يدير منتجات متاجره |
| 4 | `orders` | ✅ | 5 | ❌ | العميل يرى طلباته، التاجر يرى طلبات متجره |
| 5 | `order_items` | ✅ | 3 | ❌ | مرتبط بـ orders |
| 6 | `order_status_history` | ✅ | 2 | ❌ | سجل حالة الطلب |
| 7 | `carts` | ✅ | 3 | ❌ | كل مستخدم يدير سلته |
| 8 | `cart_items` | ✅ | 3 | ❌ | عناصر السلة |
| 9 | `wallets` | ✅ | 4 | ❌ | محفظة شخصية لكل مستخدم |
| 10 | `wallet_transactions` | ✅ | 2 | ❌ | معاملات المحفظة (service_role للإنشاء) |
| 11 | `points_accounts` | ✅ | 3 | ❌ | حساب النقاط |
| 12 | `points_transactions` | ✅ | 2 | ❌ | معاملات النقاط |
| 13 | `product_media` | ✅ | 3 | Active products | صور ومقاطع المنتجات |
| 14 | `reviews` | ✅ | 5 | ✅ عام | التقييمات عامة، التعديل للمالك فقط |
| 15 | `favorites` | ✅ | 3 | ❌ | المفضلات الشخصية |
| 16 | `wishlist` | ✅ | 3 | ❌ | قائمة الأمنيات |
| 17 | `recently_viewed` | ✅ | 3 | ❌ | المنتجات المشاهدة مؤخراً |
| 18 | `store_followers` | ✅ | 3 | عدد المتابعين | متابعة المتاجر |
| 19 | `notifications` | ✅ | 3 | ❌ | الإشعارات الشخصية |
| 20 | `user_fcm_tokens` | ✅ | 2 | ❌ | رموز FCM للإشعارات |
| 21 | `coupons` | ✅ | 3 | Active coupons | كوبونات الخصم |
| 22 | `coupon_redemptions` | ✅ | 2 | ❌ | استخدام الكوبونات |

**الإجمالي:** 22 جدول محمي بـ RLS  
**إجمالي Policies:** 80+ policy

---

## 🎭 مصفوفة الصلاحيات

| العملية | anon | customer | merchant | service_role |
|---------|------|----------|----------|--------------|
| **user_profiles** |
| قراءة Merchants | ✅ | ✅ | ✅ | ✅ |
| قراءة الـ profile الخاص | ❌ | ✅ | ✅ | ✅ |
| تحديث الـ profile الخاص | ❌ | ✅ | ✅ | ✅ |
| **stores** |
| قراءة متاجر نشطة | ✅ | ✅ | ✅ | ✅ |
| قراءة المتاجر الخاصة | ❌ | ❌ | ✅ (own) | ✅ |
| إنشاء متجر | ❌ | ❌ | ✅ | ✅ |
| تحديث متجر | ❌ | ❌ | ✅ (own) | ✅ |
| حذف متجر | ❌ | ❌ | ✅ (own) | ✅ |
| **products** |
| قراءة منتجات نشطة | ✅ | ✅ | ✅ | ✅ |
| قراءة منتجات المتجر | ❌ | ❌ | ✅ (own) | ✅ |
| إنشاء منتج | ❌ | ❌ | ✅ (own store) | ✅ |
| تحديث منتج | ❌ | ❌ | ✅ (own) | ✅ |
| حذف منتج | ❌ | ❌ | ✅ (own) | ✅ |
| **orders** |
| قراءة طلبات عامة | ❌ | ❌ | ❌ | ✅ |
| قراءة الطلبات الخاصة | ❌ | ✅ (own) | ✅ (store) | ✅ |
| إنشاء طلب | ❌ | ✅ | ✅ | ✅ |
| تحديث طلب | ❌ | ✅ (pending) | ❌ | ✅ |
| **wallets** |
| قراءة المحفظة الخاصة | ❌ | ✅ (own) | ✅ (own) | ✅ |
| تحديث رصيد | ❌ | ❌ | ❌ | ✅ |
| **wallet_transactions** |
| قراءة المعاملات الخاصة | ❌ | ✅ (own) | ✅ (own) | ✅ |
| إنشاء معاملة | ❌ | ❌ | ❌ | ✅ |
| **cart** |
| إدارة السلة | ❌ | ✅ (own) | ✅ (own) | ✅ |
| **reviews** |
| قراءة تقييمات | ✅ | ✅ | ✅ | ✅ |
| كتابة تقييم | ❌ | ✅ | ✅ | ✅ |
| تعديل تقييم | ❌ | ✅ (own) | ✅ (own) | ✅ |
| حذف تقييم | ❌ | ✅ (own) | ✅ (own) | ✅ |
| **favorites/wishlist** |
| إدارة المفضلات | ❌ | ✅ (own) | ✅ (own) | ✅ |
| **notifications** |
| قراءة إشعارات | ❌ | ✅ (own) | ✅ (own) | ✅ |
| تحديث حالة إشعار | ❌ | ✅ (own) | ✅ (own) | ✅ |
| إنشاء إشعار | ❌ | ❌ | ❌ | ✅ |
| **coupons** |
| قراءة كوبونات نشطة | ✅ | ✅ | ✅ | ✅ |
| إنشاء كوبون | ❌ | ❌ | ✅ (own store) | ✅ |
| تحديث كوبون | ❌ | ❌ | ✅ (own) | ✅ |

**الرموز:**
- ✅ = مسموح
- ❌ = ممنوع
- (own) = البيانات الخاصة فقط
- (store) = بيانات المتجر فقط

---

## 🔗 سلسلة الهوية - مرجع سريع

```
┌─────────────────┐
│  auth.users.id  │ ← Supabase Auth (JWT)
└────────┬────────┘
         │ auth_user_id (FK)
         ↓
┌─────────────────────┐
│ user_profiles.id    │ ← Profile Layer
└────────┬────────────┘
         │ owner_id (FK)
         ↓
┌─────────────────┐
│   stores.id     │ ← Business Layer
└────────┬────────┘
         │ store_id (FK)
         ↓
┌─────────────────┐
│  products.id    │ ← Product Layer
└─────────────────┘

         ┌─ customer_id/user_id (FK) → user_profiles.id
         │
┌────────┴────────┐
│    orders.id    │ ← Order Layer
└─────────────────┘
```

**القاعدة الذهبية:**  
❌ لا تستخدم `auth.users.id` مباشرة كـ FK  
✅ استخدم `user_profiles.id` دائماً

---

## 🧪 أمثلة استعلامات للاختبار

### 1. اختبار كـ Customer

```sql
-- محاكاة customer
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims TO '{"sub": "YOUR_AUTH_UUID"}';

-- هل يمكنني رؤية طلباتي؟
SELECT * FROM orders 
WHERE customer_id IN (
  SELECT id FROM user_profiles WHERE auth_user_id = 'YOUR_AUTH_UUID'
);
-- المتوقع: ✅ نعم

-- هل يمكنني رؤية طلبات الآخرين؟
SELECT * FROM orders 
WHERE customer_id NOT IN (
  SELECT id FROM user_profiles WHERE auth_user_id = 'YOUR_AUTH_UUID'
);
-- المتوقع: ❌ لا (empty result)

RESET ROLE;
```

### 2. اختبار كـ Merchant

```sql
-- محاكاة merchant
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims TO '{"sub": "MERCHANT_AUTH_UUID"}';

-- هل يمكنني رؤية منتجاتي؟
SELECT * FROM products
WHERE store_id IN (
  SELECT s.id FROM stores s
  JOIN user_profiles up ON s.owner_id = up.id
  WHERE up.auth_user_id = 'MERCHANT_AUTH_UUID'
);
-- المتوقع: ✅ نعم

-- هل يمكنني إنشاء منتج في متجر آخر؟
INSERT INTO products (store_id, name, price)
SELECT s.id, 'Hack', 10.00
FROM stores s
WHERE s.owner_id NOT IN (
  SELECT id FROM user_profiles WHERE auth_user_id = 'MERCHANT_AUTH_UUID'
);
-- المتوقع: ❌ Policy violation

RESET ROLE;
```

### 3. اختبار كـ Anonymous

```sql
SET LOCAL ROLE anon;

-- هل يمكنني رؤية المتاجر النشطة؟
SELECT * FROM stores 
WHERE is_active = true AND visibility = 'public';
-- المتوقع: ✅ نعم

-- هل يمكنني رؤية الطلبات؟
SELECT * FROM orders;
-- المتوقع: ❌ لا (empty)

RESET ROLE;
```

---

## ⚡ Troubleshooting

### مشكلة: "new row violates row-level security policy"

**السبب:** محاولة INSERT/UPDATE بيانات لا تتطابق مع WITH CHECK

**الحل:**
```sql
-- تحقق من الـ policy
SELECT * FROM pg_policies 
WHERE tablename = 'YOUR_TABLE' 
AND cmd = 'INSERT';

-- تأكد أن البيانات تتطابق مع WITH CHECK
```

### مشكلة: "permission denied for table"

**السبب:** RLS مفعّل لكن لا توجد policies

**الحل:**
```sql
-- تحقق من RLS status
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'YOUR_TABLE';

-- تحقق من وجود policies
SELECT COUNT(*) FROM pg_policies 
WHERE tablename = 'YOUR_TABLE';
```

### مشكلة: Query بطيء

**السبب:** Policies تستخدم JOINs بدون indexes

**الحل:**
```sql
-- استخدم EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT * FROM products 
WHERE store_id IN (
  SELECT s.id FROM stores s
  JOIN user_profiles up ON s.owner_id = up.id
  WHERE up.auth_user_id = auth.uid()
);

-- أنشئ indexes مناسبة
CREATE INDEX IF NOT EXISTS idx_stores_owner_id ON stores(owner_id);
CREATE INDEX IF NOT EXISTS idx_user_profiles_auth_user_id ON user_profiles(auth_user_id);
```

---

## 📦 الملفات المرفقة

1. **20251212000000_comprehensive_rls_policies.sql**
   - جميع الـ RLS policies (80+ policy)
   - جاهز للتطبيق مباشرة

2. **test_rls_policies.sql**
   - اختبارات شاملة لجميع السيناريوهات
   - أمثلة لكل role

3. **RLS_POLICIES_SUMMARY.md**
   - شرح تفصيلي لكل policy
   - أمثلة وتوضيحات

4. **RLS_QUICK_REFERENCE.md** (هذا الملف)
   - جداول مرجعية سريعة
   - أمثلة عملية

---

**آخر تحديث:** 2025-12-12  
**الإصدار:** Golden Plan v1.0
