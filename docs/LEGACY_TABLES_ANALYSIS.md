# تحليل الجداول القديمة في MBUY

> **📅 تاريخ التحليل:** 11 ديسمبر 2025  
> **🎯 الهدف:** فهم وضع الجداول القديمة قبل اتخاذ قرار الحذف/الأرشفة

---

## 📊 ملخص تنفيذي

### الوضع الحالي للبنية:
- ✅ **المعمول به حالياً:** `auth.users` → `user_profiles` → `stores` → `products`
- ⚠️ **Legacy System:** `mbuy_users` + `mbuy_sessions` (لا يزال مستخدماً في بعض Endpoints)
- ❌ **Not Found:** `profiles`, `merchants` (لا وجود لهذه الجداول كجداول منفصلة)

---

## 1️⃣ تحليل الجداول الأربعة

### A. `mbuy_users`

**الحالة:** 🔴 **LEGACY - لا يزال مستخدماً**

**الوصف التاريخي:**
- نظام التوثيق القديم (Custom JWT)
- يحتوي على: email, password_hash, full_name, phone
- كان المصدر الأساسي للهوية قبل الانتقال إلى Supabase Auth

**الاستخدام الحالي:**

| الموقع | الملف | السطور | الوظيفة |
|--------|------|--------|---------|
| Worker | `src/endpoints/auth.ts` | 76, 92, 128, 146, 296, 454 | Register, Login, GetUser |
| Worker | `src/middleware/authMiddleware.ts` | 69 | JWT verification (Custom JWT) |
| Worker | `src/utils/userMapping.ts` | 29 | Mapping mbuy_users ↔ user_profiles |
| Worker | `src/utils/jwtHelper.ts` | 60 | Create JWT for mbuy_users |
| Worker | `src/index.ts` | 2628-2644 | GET /secure/users/me |
| Database | `migrations/20251206201515_create_mbuy_auth_tables.sql` | Full file | Table creation |

**الجداول المرتبطة:**
- `user_profiles.mbuy_user_id` → `mbuy_users.id`
- `mbuy_sessions.user_id` → `mbuy_users.id`

**التقييم:**
- ✅ الجدول موجود ومستخدم فعلياً
- ⚠️ يتعارض مع الخطة الذهبية (Supabase Auth فقط)
- ⚠️ Endpoints القديمة (`/auth/register`, `/auth/login`) لا تزال تستخدمه

---

### B. `mbuy_sessions`

**الحالة:** 🔴 **LEGACY - لا يزال مستخدماً**

**الوصف التاريخي:**
- تخزين جلسات Custom JWT
- يحتوي على: token_hash, user_id (من mbuy_users), expires_at

**الاستخدام الحالي:**

| الموقع | الملف | السطور | الوظيفة |
|--------|------|--------|---------|
| Worker | `src/endpoints/auth.ts` | 210, 393, 516-527, 573, 597 | Store/validate sessions |
| Database | `migrations/20251206201515_create_mbuy_auth_tables.sql` | Full file | Table creation |
| Database | `migrations/20251208120000_add_token_hash_to_mbuy_sessions.sql` | Full file | Add token_hash |

**الجداول المرتبطة:**
- `mbuy_sessions.user_id` → `mbuy_users.id`

**التقييم:**
- ✅ الجدول موجود ومستخدم فعلياً
- ⚠️ Supabase Auth لا يحتاج لهذا الجدول (يدير Sessions داخلياً)
- ⚠️ Logout/Refresh endpoints لا تزال تستخدمه

---

### C. `profiles`

**الحالة:** ✅ **لا يوجد - تم استبداله بـ `user_profiles`**

**التحليل:**
- ❌ لم أجد أي جدول باسم `profiles` في:
  - Migrations
  - Worker code
  - Flutter code
- ✅ الجدول المستخدم حالياً هو `user_profiles`
- **الخلاصة:** لا يوجد جدول باسم `profiles` - قد يكون خطأ في التسمية أو تم استبداله منذ البداية

---

### D. `merchants`

**الحالة:** ✅ **لا يوجد - مدمج في `user_profiles`**

**التحليل:**
- ❌ لم أجد أي جدول منفصل باسم `merchants`
- ✅ المنطق الحالي: 
  - `user_profiles.role` = 'merchant' | 'customer' | 'admin'
  - `stores.owner_id` → `user_profiles.id`
- **الخلاصة:** لا يوجد جدول منفصل للتجار - المعلومات مخزنة في `user_profiles` مع `role='merchant'`

---

## 2️⃣ تصنيف الجداول

| الجدول | التصنيف | الاستخدام الحالي | السبب |
|--------|---------|------------------|-------|
| `mbuy_users` | 🔴 **LEGACY** | ✅ نعم | Custom Auth القديم - يتعارض مع Supabase Auth |
| `mbuy_sessions` | 🔴 **LEGACY** | ✅ نعم | Sessions للCustom JWT - غير مطلوب مع Supabase Auth |
| `profiles` | ✅ **N/A** | ❌ لا يوجد | لا يوجد جدول بهذا الاسم |
| `merchants` | ✅ **N/A** | ❌ لا يوجد | مدمج في `user_profiles` كـ `role` |

---

## 3️⃣ علاقة الجداول بالخطة الذهبية

### البنية المعتمدة الآن (من `MBUY_ARCHITECTURE_REFERENCE.md`):

```
┌─────────────────────────┐
│     auth.users          │ ← Supabase Auth (Identity Source)
│  - id (PK)              │
│  - email                │
│  - encrypted_password   │
└─────────┬───────────────┘
          │ 1:1
          │ user_profiles.id = auth.users.id
          ↓
┌─────────────────────────┐
│   user_profiles         │ ← Business Profile
│  - id (PK, FK)          │   REFERENCES auth.users(id)
│  - auth_user_id         │   (للربط مع auth.users)
│  - role                 │ ← 'customer', 'merchant', 'admin'
│  - mbuy_user_id         │ ← ⚠️ LEGACY (للنظام القديم)
└─────────┬───────────────┘
          │ 1:N
          │ stores.owner_id → user_profiles.id
          ↓
┌─────────────────────────┐
│      stores             │
│  - id (PK)              │
│  - owner_id (FK)        │ ← REFERENCES user_profiles(id)
│  - name                 │
└─────────┬───────────────┘
          │ 1:N
          ↓
┌─────────────────────────┐
│     products            │
│  - store_id (FK)        │ ← REFERENCES stores(id)
└─────────────────────────┘
```

### ✅ التحقق من البنية:

**تم التحقق من:**
1. ✅ `user_profiles` يحتوي على `auth_user_id UUID REFERENCES auth.users(id)`
2. ✅ `stores.owner_id` يربط مع `user_profiles.id`
3. ✅ `products.store_id` يربط مع `stores.id`
4. ⚠️ `user_profiles.mbuy_user_id` موجود (LEGACY - للتوافق المؤقت)

### ⚠️ المشكلة:

**`mbuy_users` لا يزال مستخدماً في:**
- `/auth/register` (Old endpoint)
- `/auth/login` (Old endpoint)
- `/auth/logout` (Old endpoint)
- `/auth/refresh` (Old endpoint)
- `authMiddleware.ts` (Custom JWT verification)

**بينما الخطة الذهبية تقول:**
- ✅ `/auth/supabase/register` (New endpoint)
- ✅ `/auth/supabase/login` (New endpoint)
- ✅ `/auth/supabase/logout` (New endpoint)
- ✅ `/auth/supabase/refresh` (New endpoint)
- ✅ `supabaseAuthMiddleware.ts` (Supabase JWT verification)

---

## 4️⃣ الكود المعتمد على الجداول القديمة

### Worker Endpoints التي تستخدم `mbuy_users`:

1. **`POST /auth/register`** (`src/endpoints/auth.ts:15-230`)
   - Creates user in `mbuy_users`
   - Creates profile in `user_profiles` with `mbuy_user_id`
   - Generates Custom JWT

2. **`POST /auth/login`** (`src/endpoints/auth.ts:238-400`)
   - Queries `mbuy_users` for email
   - Verifies password
   - Creates session in `mbuy_sessions`
   - Returns Custom JWT

3. **`GET /auth/me`** (`src/endpoints/auth.ts:408-490`)
   - Uses `mbuyAuthMiddleware`
   - Fetches from `mbuy_users`

4. **`POST /auth/logout`** (`src/endpoints/auth.ts:498-542`)
   - Deletes from `mbuy_sessions`

5. **`POST /auth/refresh`** (`src/endpoints/auth.ts:550-609`)
   - Queries `mbuy_sessions`
   - Updates `expires_at`

6. **`GET /secure/users/me`** (`src/index.ts:2628-2700`)
   - Queries `mbuy_users` directly

### Middleware المعتمد على النظام القديم:

1. **`authMiddleware.ts`**
   - Verifies Custom JWT
   - Sets `userId` = `mbuy_users.id`
   - Maps to `user_profiles` via `mbuy_user_id`

2. **`roleMiddleware.ts`**
   - Queries `user_profiles` by `mbuy_user_id`

### Utils المعتمد على النظام القديم:

1. **`userMapping.ts`**
   - Maps `mbuy_users.id` ↔ `user_profiles.id`
   - Creates profile if missing

2. **`jwtHelper.ts`**
   - Creates Custom JWT with `mbuy_users.id`

---

## 5️⃣ خطة الانتقال المقترحة (بدون تنفيذ)

### **Phase 1: وقف استخدام Endpoints القديمة** ⏸️

**الهدف:** منع أي تسجيل/دخول جديد عبر النظام القديم

**الخطوات:**
1. إيقاف endpoints القديمة:
   - `POST /auth/register` → Return 410 Gone
   - `POST /auth/login` → Return 410 Gone
   - (أو redirect إلى `/auth/supabase/*`)

2. إضافة warning logs عند استخدام `authMiddleware` القديم

**SQL المقترح:**
```sql
-- لا شيء هنا - فقط تعديلات على Worker
```

**Duration:** 1 يوم

---

### **Phase 2: تحويل جميع Business Endpoints للنظام الجديد** 🔄

**الهدف:** جعل جميع `/secure/*` endpoints تستخدم `supabaseAuthMiddleware`

**الخطوات:**
1. استبدال `mbuyAuthMiddleware` بـ `supabaseAuthMiddleware` في:
   - `/secure/store/*`
   - `/secure/products/*`
   - `/secure/orders/*`
   - `/secure/users/me`

2. تحديث الكود ليستخدم:
   - `c.get('authUserId')` بدلاً من `c.get('userId')`
   - `user_profiles.auth_user_id` بدلاً من `user_profiles.mbuy_user_id`

**SQL المقترح:**
```sql
-- تحديث user_profiles للمستخدمين الموجودين
-- (سيتم تنفيذه يدوياً لكل user حسب الحاجة)
```

**Duration:** 2-3 أيام

---

### **Phase 3: تحويل المستخدمين الموجودين** 👥

**الهدف:** migrate existing users من `mbuy_users` إلى `auth.users`

**الخطوات:**
1. **Manual Migration** (للمستخدمين المهمين):
   - Create user في Supabase Auth Dashboard
   - Call `handle_new_auth_user_manual()`
   - Update `user_profiles.auth_user_id`

2. **أو Force Re-registration:**
   - Send email notification
   - Users re-register via `/auth/supabase/register`

**SQL المقترح:**
```sql
-- Migration script (manual execution per user)
DO $$
DECLARE
  old_user RECORD;
  new_auth_id UUID;
BEGIN
  FOR old_user IN SELECT id, email, full_name FROM mbuy_users LOOP
    -- Note: Cannot create Supabase Auth users via SQL
    -- Must use Dashboard or Worker endpoint
    
    -- Update profile after auth.users creation
    -- UPDATE user_profiles 
    -- SET auth_user_id = <new_auth_id>
    -- WHERE mbuy_user_id = old_user.id;
  END LOOP;
END $$;
```

**Duration:** Depends on user count (1-2 weeks)

---

### **Phase 4: جعل الجداول القديمة Read-Only** 🔒

**الهدف:** منع أي تعديلات على `mbuy_users` و `mbuy_sessions`

**الخطوات:**
1. إزالة جميع `INSERT`, `UPDATE`, `DELETE` على هذه الجداول من الكود
2. إضافة RLS policies لمنع الكتابة

**SQL المقترح:**
```sql
-- Make mbuy_users and mbuy_sessions read-only
DROP POLICY IF EXISTS "Service role can access all mbuy_users" ON public.mbuy_users;
CREATE POLICY "mbuy_users_read_only"
  ON public.mbuy_users
  FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Service role can access all mbuy_sessions" ON public.mbuy_sessions;
CREATE POLICY "mbuy_sessions_read_only"
  ON public.mbuy_sessions
  FOR SELECT
  USING (true);

-- Add comment
COMMENT ON TABLE public.mbuy_users IS 
'LEGACY TABLE - READ ONLY. Use auth.users for new users.';

COMMENT ON TABLE public.mbuy_sessions IS 
'LEGACY TABLE - READ ONLY. Supabase Auth manages sessions internally.';
```

**Duration:** 1 يوم

---

### **Phase 5: أرشفة أو حذف الجداول القديمة** 🗑️

**الهدف:** تنظيف قاعدة البيانات بعد التأكد من عدم الحاجة للبيانات

**الخطوات:**

**Option A: Archive (موصى به)**
```sql
-- Move to separate schema
CREATE SCHEMA IF NOT EXISTS legacy;

-- Move tables
ALTER TABLE public.mbuy_users SET SCHEMA legacy;
ALTER TABLE public.mbuy_sessions SET SCHEMA legacy;

-- Add timestamp
ALTER TABLE legacy.mbuy_users 
ADD COLUMN IF NOT EXISTS archived_at TIMESTAMPTZ DEFAULT NOW();

COMMENT ON SCHEMA legacy IS 
'Archived tables from old authentication system. For reference only.';
```

**Option B: Backup then Drop**
```sql
-- Export to JSON/CSV first (via pg_dump or Dashboard)

-- Then drop
DROP TABLE IF EXISTS public.mbuy_sessions CASCADE;
DROP TABLE IF EXISTS public.mbuy_users CASCADE;

-- Clean up user_profiles
ALTER TABLE public.user_profiles DROP COLUMN IF EXISTS mbuy_user_id;
```

**Duration:** 1 يوم (بعد Backup)

---

## 6️⃣ الإخراج المطلوب

### جدول ملخص الجداول:

| الجدول | الاستخدام الحالي | التصنيف | كود يعتمد عليه | أمثلة |
|--------|------------------|---------|----------------|--------|
| **mbuy_users** | ✅ نعم | 🔴 LEGACY | ✅ نعم | `auth.ts`, `authMiddleware.ts`, `userMapping.ts` |
| **mbuy_sessions** | ✅ نعم | 🔴 LEGACY | ✅ نعم | `auth.ts` (logout/refresh) |
| **profiles** | ❌ لا يوجد | ⚪ N/A | ❌ لا | - |
| **merchants** | ❌ لا يوجد | ⚪ N/A | ❌ لا | - |

---

### توصيات واضحة:

#### ✅ **التوصية الفورية (الآن):**

1. **لا تحذف أي جدول** - البيانات لا تزال مستخدمة
2. **أكمل تطبيق Phase 1 & 2** من خطة Migration الموجودة في `MBUY_ARCHITECTURE_REFERENCE.md`
3. **اختبر Supabase Auth Endpoints** بشكل كامل:
   - `/auth/supabase/register`
   - `/auth/supabase/login`
   - Authenticated requests مع Supabase JWT

#### 🔄 **الخطوة التالية (بعد الاختبار):**

1. **قم بتحويل Business Endpoints** لاستخدام `supabaseAuthMiddleware`:
   ```typescript
   // Old
   app.get('/secure/store', mbuyAuthMiddleware, getStoreHandler);
   
   // New
   app.get('/secure/store', supabaseAuthMiddleware, getStoreHandler);
   ```

2. **أوقف Endpoints القديمة**:
   ```typescript
   app.post('/auth/register', (c) => {
     return c.json({
       error: 'DEPRECATED',
       message: 'Please use /auth/supabase/register'
     }, 410);
   });
   ```

#### ⏸️ **خطة طويلة المدى (3-6 أشهر):**

1. **Migrate existing users** (إذا كان هناك users حاليين)
2. **اجعل الجداول Read-Only** (Phase 4)
3. **أرشف الجداول** (Phase 5 - Option A recommended)
4. **احذف العمود `mbuy_user_id`** من `user_profiles`

---

## 7️⃣ SQL Scripts (مقترحة - غير منفذة)

### Script 1: Make Tables Read-Only
```sql
-- في ملف: migrations/future_make_legacy_readonly.sql
-- ⚠️ لا تنفذ الآن - فقط للرجوع

DROP POLICY IF EXISTS "Service role can access all mbuy_users" ON public.mbuy_users;
DROP POLICY IF EXISTS "Service role can access all mbuy_sessions" ON public.mbuy_sessions;

CREATE POLICY "mbuy_users_read_only"
  ON public.mbuy_users
  FOR SELECT
  USING (true);

CREATE POLICY "mbuy_sessions_read_only"
  ON public.mbuy_sessions
  FOR SELECT
  USING (true);

COMMENT ON TABLE public.mbuy_users IS 
'LEGACY TABLE - READ ONLY since 2025-12-11. Use auth.users for identity.';

COMMENT ON TABLE public.mbuy_sessions IS 
'LEGACY TABLE - READ ONLY since 2025-12-11. Supabase Auth manages sessions.';
```

### Script 2: Archive to Legacy Schema
```sql
-- في ملف: migrations/future_archive_legacy_tables.sql
-- ⚠️ لا تنفذ الآن - فقط للرجوع

-- Create legacy schema
CREATE SCHEMA IF NOT EXISTS legacy;

-- Move tables
ALTER TABLE public.mbuy_users SET SCHEMA legacy;
ALTER TABLE public.mbuy_sessions SET SCHEMA legacy;

-- Add archived timestamp
ALTER TABLE legacy.mbuy_users 
ADD COLUMN IF NOT EXISTS archived_at TIMESTAMPTZ DEFAULT NOW();

ALTER TABLE legacy.mbuy_sessions 
ADD COLUMN IF NOT EXISTS archived_at TIMESTAMPTZ DEFAULT NOW();

-- Update comments
COMMENT ON SCHEMA legacy IS 
'Archived tables from pre-Supabase Auth system (before 2025-12-11). 
Tables are kept for historical reference only.
Do NOT use in application code.';

COMMENT ON TABLE legacy.mbuy_users IS 
'Archived from public.mbuy_users on 2025-12-11. 
Replaced by auth.users + user_profiles system.';

COMMENT ON TABLE legacy.mbuy_sessions IS 
'Archived from public.mbuy_sessions on 2025-12-11. 
Sessions now managed internally by Supabase Auth.';
```

### Script 3: Clean up user_profiles (Far Future)
```sql
-- في ملف: migrations/future_cleanup_user_profiles.sql
-- ⚠️ لا تنفذ الآن - بعد migration كل المستخدمين فقط

-- Remove legacy column
ALTER TABLE public.user_profiles 
DROP COLUMN IF EXISTS mbuy_user_id;

-- Make auth_user_id NOT NULL
ALTER TABLE public.user_profiles 
ALTER COLUMN auth_user_id SET NOT NULL;

-- Update comment
COMMENT ON TABLE public.user_profiles IS
'User profiles linked to Supabase Auth (auth.users).
Primary identity field: id = auth.users.id';
```

---

## 📝 ملاحظات إضافية

### لماذا لم أجد `profiles` و `merchants`؟

**السبب المحتمل:**
1. **`profiles`**: قد يكون الاسم الأصلي كان `profiles` ثم تم تغييره إلى `user_profiles` في مرحلة مبكرة من المشروع
2. **`merchants`**: القرار التصميمي كان استخدام `role` في `user_profiles` بدلاً من جدول منفصل (تصميم جيد)

### تأكيدات مهمة:

✅ **البنية الحالية صحيحة:**
- `auth.users` → `user_profiles` → `stores` → `products`
- `user_profiles.auth_user_id` موجود ويشير إلى `auth.users(id)`
- `stores.owner_id` يشير إلى `user_profiles.id`

⚠️ **المشكلة الوحيدة:**
- `mbuy_users` و `mbuy_sessions` لا يزالان مستخدمين في Endpoints القديمة
- يجب التحول الكامل إلى Supabase Auth

---

**آخر تحديث:** 11 ديسمبر 2025  
**الحالة:** تحليل كامل - بانتظار قرار التنفيذ  
**المرجع:** `MBUY_ARCHITECTURE_REFERENCE.md`
