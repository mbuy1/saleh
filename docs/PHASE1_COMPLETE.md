# Phase 1 Complete: Setup & Preparation ✅

> **التاريخ:** ديسمبر 2025  
> **الحالة:** مكتمل - جاهز للتطبيق  
> **المدة المتوقعة للتطبيق:** 30-60 دقيقة

---

## 📋 نظرة عامة

**Phase 1** يجهز البنية التحتية لـ Supabase Auth بدون كسر أي شيء موجود.

**الهدف:** تجهيز النظام لدعم **كلا** نظامي Auth (Custom JWT + Supabase Auth) بشكل متوازي.

**النتيجة:** النظام القديم يعمل 100% + البنية جاهزة للنظام الجديد.

---

## ✅ ما تم إنجازه

### 1. Database Changes ✅

**الملف:** `mbuy-backend/supabase/migrations/20250112000001_prepare_dual_auth_phase1.sql`

**التغييرات:**
- ✅ إضافة عمود `auth_user_id` في `user_profiles` (nullable, FK to auth.users)
- ✅ إضافة عمود `auth_provider` ('mbuy_custom' | 'supabase_auth')
- ✅ إضافة constraint: كل profile يجب أن يكون له `mbuy_user_id` OR `auth_user_id`
- ✅ إضافة unique constraint على `auth_user_id`
- ✅ إضافة index على `auth_user_id` للأداء
- ✅ إنشاء trigger `on_auth_user_created` (ينشئ profile تلقائياً عند إنشاء auth.user)
- ✅ تحديث RLS policies لدعم كلا النظامين

**الحالة:** ✅ Migration جاهز لكن **لم يُطبق بعد**

### 2. Worker Changes ✅

#### A. User Client (موجود مسبقاً) ✅
**الملف:** `mbuy-worker/src/utils/supabaseUser.ts`

- ✅ موجود ويعمل
- ✅ يستخدم ANON_KEY + User JWT
- ✅ RLS active

#### B. Admin Client (محدّث) ✅
**الملف:** `mbuy-worker/src/utils/supabase.ts`

- ✅ تمت إضافة تعليقات توضيحية
- ✅ واضح أنه Admin Client فقط
- ✅ يستخدم SERVICE_ROLE_KEY

#### C. Supabase Auth Middleware (جديد) ✅
**الملف:** `mbuy-worker/src/middleware/supabaseAuthMiddleware.ts`

**الوظائف:**
- ✅ يتحقق من Supabase Auth JWT
- ✅ يجلب user profile
- ✅ يضبط context variables
- ✅ يدعم role-based access control
- ✅ يستخدم userClient (RLS active)

**الحالة:** ✅ مُنشأ لكن **غير مستخدم بعد**

### 3. Flutter Changes ✅

#### A. Supabase SDK (مضاف) ✅
**الملف:** `saleh/pubspec.yaml`

```yaml
dependencies:
  supabase_flutter: ^2.3.4  # NEW
```

**الحالة:** ✅ مضاف لكن **لم يُثبت بعد**

#### B. Supabase Config (جديد) ✅
**الملف:** `saleh/lib/core/config/supabase_config.dart`

**الوظائف:**
- ✅ `initialize()` - لتهيئة Supabase SDK
- ✅ `client` - للوصول إلى Supabase client
- ✅ `currentUser` - للحصول على المستخدم الحالي
- ✅ `accessToken` - للحصول على JWT
- ✅ `authStateChanges` - للاستماع لتغييرات Auth

**الحالة:** ✅ مُنشأ لكن **غير مستخدم بعد**

---

## 🚀 خطوات التطبيق

### الخطوة 1: تطبيق Database Migration

```bash
# في مجلد mbuy-backend
cd c:\muath\mbuy-backend

# Apply migration عبر Supabase CLI أو Dashboard
supabase db push

# أو عبر Dashboard:
# 1. افتح Supabase Dashboard
# 2. SQL Editor
# 3. انسخ محتوى ملف 20250112000001_prepare_dual_auth_phase1.sql
# 4. شغّل SQL
```

**التحقق:**
```sql
-- تأكد من إضافة الأعمدة
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'user_profiles'
AND column_name IN ('auth_user_id', 'auth_provider');

-- تأكد من وجود Trigger
SELECT tgname, tgtype, tgenabled
FROM pg_trigger
WHERE tgname = 'on_auth_user_created';

-- تأكد من RLS Policies
SELECT policyname, cmd, roles
FROM pg_policies
WHERE tablename = 'user_profiles';
```

### الخطوة 2: تحديث Environment Variables (اختياري)

إذا كنت تريد اختبار Supabase Auth:

**Flutter:** `saleh/lib/core/config/supabase_config.dart`
```dart
static const String supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
static const String supabaseAnonKey = 'eyJ...YOUR_ANON_KEY';
```

**Worker:** `mbuy-worker/wrangler.toml`
```toml
[vars]
SUPABASE_URL = "https://YOUR_PROJECT.supabase.co"
SUPABASE_ANON_KEY = "eyJ...YOUR_ANON_KEY"  # Already exists
SUPABASE_SERVICE_ROLE_KEY = "eyJ...YOUR_SERVICE_KEY"  # Already exists
```

### الخطوة 3: تثبيت Dependencies في Flutter

```bash
cd c:\muath\saleh
flutter pub get
```

**التحقق:**
```bash
flutter pub deps | grep supabase
# يجب أن يظهر: supabase_flutter 2.3.4
```

### الخطوة 4: اختبار النظام الحالي (مهم!)

```bash
# 1. شغّل Flutter app
cd c:\muath\saleh
flutter run

# 2. اختبر Login بالنظام القديم
# يجب أن يعمل بشكل طبيعي 100%

# 3. اختبر Create Product
# يجب أن يعمل بشكل طبيعي 100%
```

**✅ إذا كل شيء يعمل:** Phase 1 مُطبق بنجاح!

---

## 📊 الحالة بعد Phase 1

### Database:
- ✅ `user_profiles` جاهز لكلا النظامين
- ✅ Trigger موجود لإنشاء profiles تلقائياً
- ✅ RLS policies محدّثة
- ⏳ المستخدمون الحاليون يستخدمون `mbuy_user_id`
- ⏳ لا يوجد مستخدمون في `auth.users` بعد

### Worker:
- ✅ User Client موجود (supabaseUser.ts)
- ✅ Admin Client موضح (supabase.ts)
- ✅ Supabase Auth Middleware موجود
- ⏳ Endpoints تستخدم Custom JWT فقط
- ⏳ Supabase Auth Middleware غير مستخدم

### Flutter:
- ✅ supabase_flutter SDK مضاف
- ✅ SupabaseConfig موجود
- ⏳ غير مهيأ في main.dart
- ⏳ لا يستخدم في أي service

---

## ⚠️ ملاحظات مهمة

### ما يعمل الآن:
- ✅ Custom JWT Auth (100%)
- ✅ Login/Logout (النظام القديم)
- ✅ Create/Update Products
- ✅ جميع Merchant operations
- ✅ Worker endpoints

### ما لا يعمل بعد:
- ❌ Supabase Auth (لم يُفعّل)
- ❌ Direct Flutter → Supabase
- ❌ RLS-based queries

### لا تقلق:
- ✅ لا تأثير على النظام الحالي
- ✅ المستخدمون الحاليون لن يتأثروا
- ✅ يمكن العودة بسهولة (Rollback)

---

## 🔄 التراجع (Rollback)

إذا حصلت مشكلة، يمكن التراجع بسهولة:

### 1. Rollback Database:
```sql
-- حذف الأعمدة الجديدة
ALTER TABLE user_profiles DROP COLUMN IF EXISTS auth_user_id;
ALTER TABLE user_profiles DROP COLUMN IF EXISTS auth_provider;

-- حذف Constraint
ALTER TABLE user_profiles DROP CONSTRAINT IF EXISTS check_has_auth_source;
ALTER TABLE user_profiles DROP CONSTRAINT IF EXISTS unique_auth_user_id;

-- حذف Trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_auth_user();

-- إرجاع RLS Policies القديمة
-- (راجع migrations السابقة)
```

### 2. Rollback Flutter:
```bash
# احذف supabase_flutter من pubspec.yaml
# flutter pub get
```

### 3. Rollback Worker:
```bash
# احذف supabaseAuthMiddleware.ts (اختياري - لن يؤثر إذا لم يُستخدم)
```

---

## 📝 الخطوات التالية

بعد اكتمال Phase 1 بنجاح:

### Phase 2: Dual System Support
- إنشاء Unified Auth Middleware (يدعم كلا النظامين)
- تحديث Endpoints لدعم كلا Token types
- إنشاء Dual Auth Service في Flutter
- اختبار كلا النظامين جنباً إلى جنب

**المدة المتوقعة:** 2-3 أيام

**الوثائق:** راجع `SUPABASE_AUTH_MIGRATION_PLAN.md` - Phase 2

---

## ✅ Checklist للتحقق من اكتمال Phase 1

- [ ] Database Migration مُطبق بنجاح
- [ ] أعمدة `auth_user_id` و `auth_provider` موجودة في `user_profiles`
- [ ] Trigger `on_auth_user_created` يعمل
- [ ] RLS Policies محدّثة
- [ ] `supabase_flutter` مثبت في Flutter
- [ ] `SupabaseConfig.dart` موجود
- [ ] Worker يعمل بدون مشاكل
- [ ] Flutter Login يعمل (Custom JWT)
- [ ] Create Product يعمل
- [ ] لا توجد أخطاء في Console

**إذا كل ما سبق ✅:** أنت جاهز لـ Phase 2!

---

**آخر تحديث:** ديسمبر 2025  
**الحالة:** Phase 1 Complete - جاهز للتطبيق  
**التالي:** Phase 2 - Dual System Support
