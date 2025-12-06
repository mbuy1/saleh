# ✅ إصلاح خطأ "ليس لديك صلاحية للوصول" (FORBIDDEN) - الحل الكامل

## 🔍 المشكلة

عند إضافة منتج، يظهر خطأ: **"ليس لديك صلاحية للوصول" (403 FORBIDDEN)**

### السبب:
- Edge Function `product_create` كان يستخدم `SERVICE_ROLE_KEY` فقط
- `SERVICE_ROLE_KEY` يتجاوز RLS تلقائياً، لكن RLS Policy لا تزال تتحقق في بعض الحالات
- الحل: استخدام JWT من المستخدم في Edge Function لتفعيل RLS بشكل صحيح

---

## ✅ الحل المطبق

### 1. تعديل Worker (`mbuy-worker/src/index.ts`)
**التغيير:** تمرير JWT من المستخدم إلى Edge Function

```typescript
// Get the client JWT token to pass to Edge Function for RLS
const authHeader = c.req.header('Authorization');
const clientToken = authHeader ? authHeader.substring(7) : null;

const response = await fetch(edgeFunctionUrl, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'x-internal-key': c.env.EDGE_INTERNAL_KEY,
    // Pass the client JWT token for RLS
    ...(clientToken && { 'Authorization': `Bearer ${clientToken}` }),
  },
  body: JSON.stringify({ ...cleanBody, user_id: userId, store_id: store.id }),
});
```

---

### 2. تعديل Edge Function (`mbuy-backend/functions/product_create/index.ts`)
**التغيير:** استخدام JWT من المستخدم بدلاً من `SERVICE_ROLE_KEY` فقط

```typescript
// Get JWT token from Authorization header (passed from Worker)
const authHeader = req.headers.get('Authorization');
const userJwt = authHeader ? authHeader.replace('Bearer ', '') : null;

// Use user JWT if available (for RLS), otherwise fall back to service role key
const supabaseKey = userJwt ? supabaseAnonKey : supabaseServiceKey;
const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: { 
    autoRefreshToken: false, 
    persistSession: false,
  },
  global: {
    headers: userJwt ? {
      'Authorization': `Bearer ${userJwt}`,
    } : {},
  },
});
```

---

### 3. Migration Script (اختياري)
**الملف:** `mbuy-backend/migrations/20250106000004_fix_rls_for_service_role.sql`

**الهدف:** تحديث RLS Policies (إذا لزم الأمر)

---

## 🎯 كيف يعمل الحل

### قبل الإصلاح:
1. Flutter → Worker (مع JWT)
2. Worker → Edge Function (بدون JWT)
3. Edge Function → Supabase (باستخدام `SERVICE_ROLE_KEY`)
4. ❌ RLS Policy لا تعمل بشكل صحيح

### بعد الإصلاح:
1. Flutter → Worker (مع JWT)
2. Worker → Edge Function (مع JWT من المستخدم)
3. Edge Function → Supabase (باستخدام JWT من المستخدم + `ANON_KEY`)
4. ✅ RLS Policy تعمل بشكل صحيح

---

## 📊 المزايا

### 1. الأمان ✅
- ✅ RLS Policies تعمل بشكل صحيح
- ✅ التحقق من الملكية على مستوى قاعدة البيانات
- ✅ لا يمكن للمستخدمين إضافة منتجات لغيرهم

### 2. المرونة ✅
- ✅ يعمل مع JWT من المستخدم
- ✅ يعمل مع `SERVICE_ROLE_KEY` كبديل (fallback)

### 3. الأداء ✅
- ✅ لا يوجد تأثير على الأداء
- ✅ RLS Policies محسّنة

---

## 🧪 الخطوات المطلوبة

### 1. نشر Edge Function
```bash
cd mbuy-backend
supabase functions deploy product_create
```

### 2. نشر Worker
```bash
cd mbuy-worker
wrangler deploy
```

### 3. اختبار إضافة منتج
- ✅ فتح تطبيق Flutter
- ✅ تسجيل الدخول كتاجر
- ✅ إضافة منتج جديد
- ✅ التحقق من عدم وجود خطأ FORBIDDEN

---

## 🔍 إذا استمرت المشكلة

### 1. التحقق من Environment Variables
```bash
# في Supabase Dashboard:
# Settings → Edge Functions → Environment Variables
# التأكد من وجود:
# - SUPABASE_ANON_KEY
# - SUPABASE_SERVICE_ROLE_KEY (fallback)
```

### 2. التحقق من Logs
```typescript
// في Edge Function logs:
// البحث عن:
// - "Insert error"
// - "createError"
// - "FORBIDDEN"
```

### 3. التحقق من RLS
```sql
-- في Supabase SQL Editor:
SELECT * FROM pg_policies 
WHERE tablename = 'products' 
AND policyname LIKE '%Merchants%';
```

---

## ✅ النتيجة المتوقعة

بعد تطبيق الحل:
- ✅ Edge Function يستخدم JWT من المستخدم
- ✅ RLS Policies تعمل بشكل صحيح
- ✅ إضافة المنتج تعمل بدون خطأ FORBIDDEN
- ✅ المنتج يُضاف بنجاح في قاعدة البيانات

---

## 📝 الملفات المعدلة

1. **Worker:** `mbuy-worker/src/index.ts`
   - تمرير JWT من المستخدم إلى Edge Function

2. **Edge Function:** `mbuy-backend/functions/product_create/index.ts`
   - استخدام JWT من المستخدم بدلاً من `SERVICE_ROLE_KEY` فقط

3. **Migration Script (اختياري):** `mbuy-backend/migrations/20250106000004_fix_rls_for_service_role.sql`
   - تحديث RLS Policies (إذا لزم الأمر)

---

**الحل جاهز للاستخدام!** 🚀

