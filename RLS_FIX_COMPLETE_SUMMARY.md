# ✅ ملخص إصلاح مشكلة FORBIDDEN

## 📋 المشكلة
خطأ `FORBIDDEN` عند محاولة إضافة منتج جديد من تطبيق Flutter.

**السبب الجذري:**
- ❌ جدول `user_profiles` لا يحتوي على عمود `user_id`
- ❌ RLS Policies تستخدم `auth.uid() = id` بدلاً من `auth.uid() = user_id`
- ❌ RLS Policies في `products` لا تتحقق بشكل صحيح من ملكية المتجر

---

## ✅ الحل الشامل

### Migration Script جاهز:
**الملف:** `mbuy-backend/migrations/20250106000003_fix_user_profiles_and_rls_policies.sql`

---

## 📊 التغييرات في Migration

### 1. إضافة الأعمدة المفقودة:
```sql
-- إضافة user_id
ALTER TABLE public.user_profiles 
  ADD COLUMN user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

-- إضافة full_name
ALTER TABLE public.user_profiles 
  ADD COLUMN full_name TEXT;
```

### 2. تحديث البيانات:
```sql
-- تعبئة user_id
UPDATE public.user_profiles 
SET user_id = id 
WHERE user_id IS NULL;

-- تعبئة full_name
UPDATE public.user_profiles 
SET full_name = display_name 
WHERE full_name IS NULL AND display_name IS NOT NULL;

-- جعل user_id NOT NULL
ALTER TABLE public.user_profiles 
  ALTER COLUMN user_id SET NOT NULL;
```

### 3. RLS Policies لـ user_profiles:
```sql
-- SELECT
CREATE POLICY "Users can read own profile"
ON public.user_profiles FOR SELECT
USING (user_id = auth.uid());

-- UPDATE
CREATE POLICY "Users can update own profile"
ON public.user_profiles FOR UPDATE
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- INSERT
CREATE POLICY "Users can insert own profile"
ON public.user_profiles FOR INSERT
WITH CHECK (user_id = auth.uid());
```

### 4. RLS Policies لـ products:
```sql
-- INSERT (للـ merchants فقط)
CREATE POLICY "Merchants insert their own products"
ON public.products FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 
        FROM public.stores 
        INNER JOIN public.user_profiles 
          ON user_profiles.id = stores.owner_id
        WHERE stores.id = products.store_id 
        AND user_profiles.user_id = auth.uid()
        AND user_profiles.role = 'merchant'
    )
);
```

### 5. RLS Policies لـ stores:
```sql
-- SELECT للتجار
CREATE POLICY "Merchants can view own stores"
ON public.stores FOR SELECT
USING (
    EXISTS (
        SELECT 1 
        FROM public.user_profiles 
        WHERE user_profiles.id = stores.owner_id 
        AND user_profiles.user_id = auth.uid()
    )
);
```

---

## ✅ التحقق من JWT

### Flutter (`api_service.dart`):
```dart
static Future<String?> _getJwtToken() async {
  final session = supabaseClient.auth.currentSession;
  return session?.accessToken; // ✅ صحيح
}

// يرسل في Header:
'Authorization': 'Bearer $jwt' // ✅ صحيح
```

### Worker (`index.ts`):
```typescript
const authHeader = c.req.header('Authorization');
const token = authHeader.substring(7); // ✅ يستخرج Bearer token
const payload = JSON.parse(atob(parts[1]));
c.set('userId', payload.sub); // ✅ auth.users.id
```

### Edge Function (`product_create/index.ts`):
```typescript
const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: { autoRefreshToken: false, persistSession: false },
}); // ✅ يستخدم SERVICE_ROLE_KEY - يتجاوز RLS
```

---

## 🔐 السكيمة النهائية

### جدول user_profiles:
```
- id (UUID, PK, FK → auth.users.id)
- user_id (UUID, FK → auth.users.id, NOT NULL) ✅ جديد
- role (TEXT)
- display_name (TEXT)
- full_name (TEXT) ✅ جديد
- phone (TEXT)
- avatar_url (TEXT)
- email (TEXT)
- created_at, updated_at
```

### العلاقات:
```
auth.users.id 
  ↓
user_profiles.user_id (FK → auth.users.id) ✅
user_profiles.id (PK, FK → auth.users.id)
  ↓
stores.owner_id (FK → user_profiles.id)
  ↓
products.store_id (FK → stores.id)
```

---

## 🧪 خطوات الاختبار

### 1. تشغيل Migration:
```
1. افتح Supabase Dashboard
2. SQL Editor
3. انسخ محتوى: mbuy-backend/migrations/20250106000003_fix_user_profiles_and_rls_policies.sql
4. اضغط Run
```

### 2. التحقق:
```sql
-- التحقق من الأعمدة
SELECT column_name FROM information_schema.columns
WHERE table_name = 'user_profiles' 
AND column_name IN ('user_id', 'full_name');

-- التحقق من البيانات
SELECT id, user_id, id = user_id FROM user_profiles LIMIT 5;
```

### 3. اختبار من Flutter:
```
1. سجل دخول كتاجر
2. أضف منتج جديد
3. يجب أن يعمل بدون خطأ FORBIDDEN
```

---

## 📁 الملفات

### Migration Script:
- ✅ `mbuy-backend/migrations/20250106000003_fix_user_profiles_and_rls_policies.sql`

### الكود (لا يحتاج تعديل):
- ✅ `saleh/lib/core/services/api_service.dart` - يرسل JWT صحيح
- ✅ `mbuy-worker/src/index.ts` - يقرأ JWT صحيح
- ✅ `mbuy-backend/functions/product_create/index.ts` - يستخدم SERVICE_ROLE_KEY

---

## ✅ النتيجة المتوقعة

بعد تنفيذ Migration:
- ✅ جدول `user_profiles` يحتوي على `user_id` و `full_name`
- ✅ جميع الصفوف: `user_id = id`
- ✅ RLS Policies تستخدم `user_id = auth.uid()`
- ✅ يمكن للتجار إضافة منتجات بدون خطأ FORBIDDEN
- ✅ يمكن للمستخدمين قراءة وتحديث ملفاتهم الشخصية

---

**تاريخ الإصلاح:** 2025-01-06  
**الحالة:** ✅ جاهز للتنفيذ

