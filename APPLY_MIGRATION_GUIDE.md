# 📝 دليل تطبيق Migration - RLS Security

**التاريخ:** 2025-01-07  
**الملف:** `mbuy-backend/migrations/20250107000002_finalize_rls_security.sql`

---

## 🎯 الهدف

تفعيل RLS (Row Level Security) بالكامل على جميع الجداول الحساسة في Supabase، مع ضمان أن Worker فقط يمكنه الوصول للقاعدة باستخدام `SUPABASE_SERVICE_ROLE_KEY`.

---

## 📋 الخطوات

### 1. فتح Supabase Dashboard

1. اذهب إلى [Supabase Dashboard](https://app.supabase.com)
2. اختر المشروع الخاص بك
3. اذهب إلى **SQL Editor** من القائمة الجانبية

### 2. نسخ Migration

1. افتح الملف: `mbuy-backend/migrations/20250107000002_finalize_rls_security.sql`
2. انسخ المحتوى بالكامل

### 3. تطبيق Migration

1. في SQL Editor، الصق المحتوى
2. اضغط **Run** أو **Ctrl+Enter**
3. انتظر حتى يكتمل التنفيذ

### 4. التحقق من النتيجة

**يجب أن ترى:**
- ✅ `ALTER TABLE` statements تم تنفيذها بنجاح
- ✅ `CREATE POLICY` statements تم تنفيذها بنجاح
- ✅ لا توجد أخطاء

**إذا ظهرت أخطاء:**
- تحقق من أن الجداول موجودة
- تحقق من أن Policies السابقة تم حذفها
- راجع رسائل الخطأ

---

## ✅ التحقق من RLS

### 1. التحقق من تفعيل RLS:

```sql
SELECT 
  tablename, 
  rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN (
  'products', 
  'stores', 
  'orders', 
  'order_items', 
  'cart_items', 
  'user_profiles', 
  'wallets', 
  'points_accounts', 
  'coupons', 
  'categories', 
  'reviews', 
  'mbuy_users', 
  'mbuy_sessions'
)
ORDER BY tablename;
```

**النتيجة المتوقعة:** جميع الجداول يجب أن يكون `rowsecurity = true`

### 2. التحقق من Policies:

```sql
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE schemaname = 'public'
AND tablename IN (
  'products', 
  'stores', 
  'orders', 
  'user_profiles', 
  'mbuy_users', 
  'mbuy_sessions'
)
ORDER BY tablename, policyname;
```

**النتيجة المتوقعة:** يجب أن ترى Policies للـ Service Role و Public Access

---

## 🔍 اختبار RLS

### 1. اختبار Service Role (Worker):

```sql
-- هذا يجب أن يعمل (Worker يستخدم SERVICE_ROLE_KEY)
-- لكن لا يمكنك اختباره من SQL Editor مباشرة
-- يجب اختباره من Worker
```

### 2. اختبار Public Access:

```sql
-- استخدام ANON_KEY (يجب أن يعمل فقط للقراءة)
-- من Flutter أو Postman
```

### 3. اختبار بدون Key:

```sql
-- محاولة الوصول بدون key (يجب أن يفشل)
-- هذا يثبت أن RLS يعمل
```

---

## ⚠️ ملاحظات مهمة

1. **Service Role Key:**
   - Worker يستخدم `SUPABASE_SERVICE_ROLE_KEY` الذي يتجاوز RLS تلقائياً
   - لا تضع هذا المفتاح في Flutter أبداً

2. **Public Access:**
   - Public endpoints تستخدم `SUPABASE_ANON_KEY` مع RLS policies
   - يمكن القراءة فقط للمحتوى النشط

3. **Backup:**
   - احفظ نسخة من Migration قبل التطبيق
   - يمكنك التراجع عن Migration إذا لزم الأمر

---

## 🔄 التراجع عن Migration

إذا أردت التراجع عن Migration:

```sql
-- حذف Policies
DROP POLICY IF EXISTS "Service role can access all products" ON public.products;
DROP POLICY IF EXISTS "Public can view active products" ON public.products;
-- ... (كرر لجميع الجداول)

-- تعطيل RLS (غير مستحسن)
ALTER TABLE public.products DISABLE ROW LEVEL SECURITY;
-- ... (كرر لجميع الجداول)
```

**⚠️ تحذير:** التراجع عن RLS يقلل الأمان، استخدمه فقط في حالات الطوارئ.

---

## ✅ قائمة التحقق

- [ ] Migration مطبقة بنجاح
- [ ] RLS مفعّل على جميع الجداول
- [ ] Policies موجودة
- [ ] Worker يمكنه الوصول للقاعدة
- [ ] Public endpoints تعمل
- [ ] Flutter لا يصل للقاعدة مباشرة

---

**تاريخ التطبيق:**  
**الحالة:** ✅ مكتمل / ❌ فشل  
**ملاحظات:**

