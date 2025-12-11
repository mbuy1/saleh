# 📋 ملخص RLS Policies - Golden Plan

**تاريخ:** 2025-12-12  
**الإصدار:** 1.0  
**الحالة:** ✅ جاهز للتطبيق

---

## 📊 نظرة عامة

تم بناء نظام RLS شامل يغطي **21 جدول** بناءً على **Golden Plan Architecture**.

### المبدأ الأساسي:

```
auth.users.id (Supabase Auth)
  ↓ auth_user_id (FK)
user_profiles.id (PK)
  ↓ owner_id (FK)
stores.id
  ↓ store_id (FK)  
products.id
```

---

## 🗂️ الجداول المحمية بـ RLS

### 1. Core Tables (جداول أساسية)

| الجدول | RLS مفعّل | عدد Policies | الوصول العام |
|--------|-----------|-------------|--------------|
| `user_profiles` | ✅ | 5 | Merchants فقط |
| `stores` | ✅ | 6 | Active stores |
| `products` | ✅ | 6 | Active products |

### 2. Order Management (إدارة الطلبات)

| الجدول | RLS مفعّل | عدد Policies | الوصول العام |
|--------|-----------|-------------|--------------|
| `orders` | ✅ | 5 | ❌ خاص |
| `order_items` | ✅ | 3 | ❌ خاص |
| `order_status_history` | ✅ | 2 | ❌ خاص |

### 3. Shopping Cart (السلة)

| الجدول | RLS مفعّل | عدد Policies | الوصول العام |
|--------|-----------|-------------|--------------|
| `carts` | ✅ | 3 | ❌ خاص |
| `cart_items` | ✅ | 3 | ❌ خاص |

### 4. Financial (المالية)

| الجدول | RLS مفعّل | عدد Policies | الوصول العام |
|--------|-----------|-------------|--------------|
| `wallets` | ✅ | 4 | ❌ خاص |
| `wallet_transactions` | ✅ | 2 | ❌ خاص |
| `points_accounts` | ✅ | 3 | ❌ خاص |
| `points_transactions` | ✅ | 2 | ❌ خاص |

### 5. Media & Content (الوسائط)

| الجدول | RLS مفعّل | عدد Policies | الوصول العام |
|--------|-----------|-------------|--------------|
| `product_media` | ✅ | 3 | Active products |
| `reviews` | ✅ | 5 | ✅ عام |

### 6. User Interactions (تفاعلات المستخدم)

| الجدول | RLS مفعّل | عدد Policies | الوصول العام |
|--------|-----------|-------------|--------------|
| `favorites` | ✅ | 3 | ❌ خاص |
| `wishlist` | ✅ | 3 | ❌ خاص |
| `recently_viewed` | ✅ | 3 | ❌ خاص |
| `store_followers` | ✅ | 3 | ✅ عدد Followers |

### 7. Notifications (الإشعارات)

| الجدول | RLS مفعّل | عدد Policies | الوصول العام |
|--------|-----------|-------------|--------------|
| `notifications` | ✅ | 3 | ❌ خاص |
| `user_fcm_tokens` | ✅ | 2 | ❌ خاص |

### 8. Marketing (التسويق)

| الجدول | RLS مفعّل | عدد Policies | الوصول العام |
|--------|-----------|-------------|--------------|
| `coupons` | ✅ | 3 | Active coupons |
| `coupon_redemptions` | ✅ | 2 | ❌ خاص |

---

## 🔐 أنواع Policies المطبقة

### For All Tables:

#### 1. Service Role Policy
```sql
CREATE POLICY "Service role full access"
  ON public.{table}
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);
```
- **الغرض:** السماح للـ Worker بالوصول الكامل
- **المستخدم:** Worker Backend (SERVICE_ROLE_KEY)
- **الصلاحيات:** SELECT, INSERT, UPDATE, DELETE

---

### Table-Specific Policies:

#### user_profiles

```sql
-- 1. Users can view own profile
USING (auth_user_id = auth.uid())

-- 2. Public can view merchant profiles
USING (role = 'merchant' AND is_active = true)

-- 3. Users can update own profile
USING (auth_user_id = auth.uid())
WITH CHECK (auth_user_id = auth.uid())

-- 4. Enable insert for authenticated users
WITH CHECK (auth_user_id = auth.uid())
```

**ملاحظات:**
- المستخدم يرى ويحدّث profile الخاص به فقط
- العامة ترى profiles التجار (للعرض العام)
- عند Insert: يجب أن يكون auth_user_id = المستخدم الحالي

---

#### stores

```sql
-- 1. Public can view active stores
USING (is_active = true AND visibility = 'public')

-- 2. Merchants can view own stores
USING (
  owner_id IN (
    SELECT id FROM public.user_profiles
    WHERE auth_user_id = auth.uid()
  )
)

-- 3. Merchants can insert own stores
WITH CHECK (
  owner_id IN (
    SELECT id FROM public.user_profiles
    WHERE auth_user_id = auth.uid()
    AND role IN ('merchant', 'admin')
  )
)

-- 4. Merchants can update own stores
-- 5. Merchants can delete own stores
```

**ملاحظات:**
- العامة ترى المتاجر النشطة فقط
- التاجر يرى متاجره حتى لو غير نشطة
- عند Insert: يجب أن يكون role = merchant أو admin

---

#### products

```sql
-- 1. Public can view active products
USING (
  is_active = true
  AND EXISTS (
    SELECT 1 FROM public.stores
    WHERE stores.id = products.store_id
    AND stores.is_active = true
    AND stores.visibility = 'public'
  )
)

-- 2. Merchants can view own products
USING (
  store_id IN (
    SELECT s.id
    FROM public.stores s
    JOIN public.user_profiles up ON s.owner_id = up.id
    WHERE up.auth_user_id = auth.uid()
  )
)

-- 3. Merchants can insert/update/delete own products
```

**ملاحظات:**
- المنتجات النشطة من المتاجر النشطة فقط للعامة
- التاجر يدير منتجات متاجره فقط
- الربط عبر stores → user_profiles → auth.users

---

#### orders

```sql
-- 1. Customers can view own orders
USING (
  customer_id IN (
    SELECT id FROM public.user_profiles
    WHERE auth_user_id = auth.uid()
  )
  OR user_id IN (...)
)

-- 2. Merchants can view store orders
USING (
  store_id IN (
    SELECT s.id
    FROM public.stores s
    JOIN public.user_profiles up ON s.owner_id = up.id
    WHERE up.auth_user_id = auth.uid()
  )
)

-- 3. Customers can create orders
-- 4. Customers can update own orders (pending/processing only)
```

**ملاحظات:**
- العميل يرى طلباته فقط
- التاجر يرى طلبات متاجره فقط
- التحديث محدود للطلبات قيد المعالجة
- customer_id و user_id يشيران إلى user_profiles.id (ليس auth.users.id)

---

#### wallets

```sql
-- 1. Users can view own wallet
USING (
  user_id IN (...) OR owner_id IN (...)
)

-- 2. Users can create own wallet
-- 3. Users can update own wallet
```

**ملاحظات:**
- دعم كل من user_id و owner_id للتوافق
- تحديث الرصيد عبر service_role فقط (أمان)
- كل مستخدم له محفظة واحدة

---

#### wallet_transactions

```sql
-- 1. Users can view own transactions
USING (
  wallet_id IN (
    SELECT w.id FROM public.wallets w
    WHERE w.user_id IN (...) OR w.owner_id IN (...)
  )
)

-- Note: INSERT عبر service_role فقط
```

**ملاحظات:**
- المستخدم يشاهد معاملاته فقط
- الإنشاء محصور بـ Worker (منع التلاعب)

---

#### cart & cart_items

```sql
-- Users can manage own cart/items
USING (
  user_id IN (
    SELECT id FROM public.user_profiles
    WHERE auth_user_id = auth.uid()
  )
)
```

**ملاحظات:**
- كل مستخدم يدير سلته الخاصة
- cart_id اختياري (يمكن استخدام user_id مباشرة)

---

#### reviews

```sql
-- 1. Public can view reviews
USING (true)

-- 2. Users can create/update/delete own reviews
USING (
  user_id IN (...) OR customer_id IN (...)
)
```

**ملاحظات:**
- التقييمات عامة (للجميع)
- فقط صاحب التقييم يمكنه التعديل/الحذف
- دعم كل من user_id و customer_id

---

#### favorites, wishlist, recently_viewed

```sql
-- Users can manage own data
USING (
  user_id IN (
    SELECT id FROM public.user_profiles
    WHERE auth_user_id = auth.uid()
  )
)
```

**ملاحظات:**
- كل مستخدم يدير بياناته الخاصة
- لا يمكن رؤية مفضلات الآخرين

---

#### notifications

```sql
-- 1. Users can view own notifications
USING (user_id IN (...))

-- 2. Users can update own notifications (mark as read)
USING (user_id IN (...))

-- Note: INSERT عبر service_role فقط
```

**ملاحظات:**
- الإشعارات يتم إنشاؤها بواسطة النظام
- المستخدم يمكنه القراءة وتحديث الحالة فقط

---

## 🎭 الأدوار (Roles)

### 1. Anonymous (anon)

**الصلاحيات:**
- ✅ عرض المتاجر النشطة
- ✅ عرض المنتجات النشطة
- ✅ عرض profiles التجار
- ✅ عرض التقييمات
- ❌ لا يمكن الوصول للبيانات الشخصية

**Use Cases:**
- تصفح التطبيق بدون تسجيل دخول
- البحث عن منتجات
- عرض تفاصيل المتاجر

---

### 2. Customer (authenticated - role: customer)

**الصلاحيات:**
- ✅ عرض وتحديث profile الخاص
- ✅ إنشاء وعرض الطلبات
- ✅ إدارة السلة
- ✅ عرض المحفظة والمعاملات
- ✅ إدارة المفضلات والـ wishlist
- ✅ كتابة تقييمات
- ❌ لا يمكن إنشاء متاجر أو منتجات

**Use Cases:**
- التسوق
- تتبع الطلبات
- إدارة المحفظة

---

### 3. Merchant (authenticated - role: merchant)

**الصلاحيات:**
- ✅ كل صلاحيات Customer
- ✅ إنشاء وإدارة المتاجر
- ✅ إنشاء وإدارة المنتجات
- ✅ عرض طلبات المتاجر
- ✅ إدارة كوبونات الخصم
- ✅ عرض محفظة التاجر
- ❌ لا يمكن الوصول لبيانات التجار الآخرين

**Use Cases:**
- إدارة المتجر
- إضافة منتجات
- متابعة المبيعات

---

### 4. Admin (authenticated - role: admin)

**الصلاحيات:**
- ✅ كل صلاحيات Merchant
- ✅ صلاحيات إدارية إضافية (حسب التطبيق)

---

### 5. Service Role (service_role)

**الصلاحيات:**
- ✅ وصول كامل لجميع الجداول (bypasses RLS)
- ✅ يمكنه تنفيذ أي عملية

**Use Cases:**
- Worker Backend operations
- Automated tasks
- System maintenance

**⚠️ تحذير:** SERVICE_ROLE_KEY يجب أن يبقى سري تماماً!

---

## 🔄 سلسلة الهوية (Identity Chain)

### الترتيب الصحيح:

```sql
-- 1. Auth Layer
auth.users.id (UUID)
  ↓
-- 2. Profile Layer  
user_profiles.auth_user_id = auth.users.id (FK)
user_profiles.id (PK) ← هذا هو المستخدم في باقي الجداول
  ↓
-- 3. Business Layer
stores.owner_id = user_profiles.id (FK)
stores.id (PK)
  ↓
-- 4. Product Layer
products.store_id = stores.id (FK)

-- Orders Layer
orders.customer_id = user_profiles.id (FK)
orders.user_id = user_profiles.id (FK)
orders.store_id = stores.id (FK)

-- Wallet Layer
wallets.user_id = user_profiles.id (FK)
wallets.owner_id = user_profiles.id (FK)
```

### ❌ الأخطاء الشائعة:

```sql
-- ❌ خطأ: استخدام auth.users.id مباشرة
stores.owner_id = auth.users.id  -- WRONG!

-- ✅ صحيح: استخدام user_profiles.id
stores.owner_id = user_profiles.id  -- CORRECT!
```

---

## 🧪 الاختبار

### ملف الاختبار:
`test_rls_policies.sql`

### السيناريوهات المغطاة:

1. **Anonymous User**
   - عرض البيانات العامة ✅
   - منع الوصول للبيانات الخاصة ✅

2. **Customer User**
   - عرض البيانات الخاصة ✅
   - إنشاء طلبات ✅
   - منع إنشاء متاجر ✅
   - منع الوصول لبيانات الآخرين ✅

3. **Merchant User**
   - إدارة المتاجر ✅
   - إدارة المنتجات ✅
   - عرض طلبات المتجر ✅
   - منع الوصول لمتاجر الآخرين ✅

4. **Service Role**
   - وصول كامل ✅
   - تجاوز RLS ✅

5. **Security Tests**
   - منع Cross-user access ✅
   - منع Unauthorized modifications ✅
   - حماية البيانات المالية ✅

6. **Golden Plan Verification**
   - التحقق من سلسلة الهوية ✅
   - التحقق من FKs الصحيحة ✅

---

## 📈 الأداء (Performance)

### Indexes المطلوبة:

```sql
-- user_profiles
CREATE INDEX idx_user_profiles_auth_user_id ON user_profiles(auth_user_id);
CREATE INDEX idx_user_profiles_role ON user_profiles(role);

-- stores
CREATE INDEX idx_stores_owner_id ON stores(owner_id);
CREATE INDEX idx_stores_is_active ON stores(is_active);

-- products
CREATE INDEX idx_products_store_id ON products(store_id);
CREATE INDEX idx_products_is_active ON products(is_active);

-- orders
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_store_id ON orders(store_id);

-- wallets
CREATE INDEX idx_wallets_user_id ON wallets(user_id);
CREATE INDEX idx_wallets_owner_id ON wallets(owner_id);
```

**ملاحظة:** هذه Indexes موجودة بالفعل في Golden Plan Schema.

---

## 🚀 التطبيق

### الخطوات:

1. **تأكد من تطبيق Golden Plan Schema:**
   ```bash
   # في Supabase Dashboard → SQL Editor
   # تنفيذ: 20251211120000_golden_plan_schema_setup.sql
   ```

2. **تطبيق RLS Policies:**
   ```bash
   # تنفيذ: 20251212000000_comprehensive_rls_policies.sql
   ```

3. **اختبار Policies:**
   ```bash
   # تنفيذ أجزاء من: test_rls_policies.sql
   # استبدل UUIDs بقيم حقيقية
   ```

4. **التحقق من النتائج:**
   ```sql
   -- فحص RLS status
   SELECT tablename, rowsecurity
   FROM pg_tables
   WHERE schemaname = 'public'
   ORDER BY tablename;

   -- فحص Policies
   SELECT tablename, policyname, cmd
   FROM pg_policies
   WHERE schemaname = 'public'
   ORDER BY tablename, policyname;
   ```

---

## ⚠️ ملاحظات مهمة

### 1. Service Role Key
- **يجب** أن يبقى سري
- **لا تشاركه** في Frontend
- استخدمه **فقط** في Worker Backend

### 2. JWT Claims
- `auth.uid()` يرجع `auth.users.id`
- RLS policies تستخدم `auth.uid()` للتحقق
- Worker يمرر JWT في Authorization header

### 3. Performance
- Policies تستخدم JOINs → تأكد من وجود Indexes
- لو الـ queries بطيئة، استخدم EXPLAIN ANALYZE

### 4. Maintenance
- عند إضافة جداول جديدة، لا تنسى RLS!
- راجع Policies بشكل دوري
- اختبر بعد كل تعديل

---

## 📚 المراجع

- [Golden Plan Schema](./20251211120000_golden_plan_schema_setup.sql)
- [RLS Policies](./20251212000000_comprehensive_rls_policies.sql)
- [Test Queries](./test_rls_policies.sql)
- [Supabase RLS Documentation](https://supabase.com/docs/guides/auth/row-level-security)

---

**تم بواسطة:** GitHub Copilot  
**تاريخ:** 2025-12-12  
**الإصدار:** Golden Plan v1.0
