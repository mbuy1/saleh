# 📌 الخطة الذهبية الرسمية لمشروع MBUY

> **تاريخ الاعتماد:** 11 ديسمبر 2025  
> **الحالة:** ✅ **المرجع المعماري الرسمي الوحيد**  
> **الأولوية:** 🔴 **إلزامي التطبيق**

---

## 🎯 مقدمة

هذه الوثيقة تمثل **القرار المعماري النهائي** لمشروع MBUY. أي كود أو توثيق أو منطق يخالفها يُعتبر Legacy أو خطأ ويجب تصحيحه فوراً.

---

## 1️⃣ نظام التوثيق (Authentication System)

### 1.1 المصدر الوحيد للهوية

✅ **المعتمد:**
```
Supabase Auth → auth.users table
```

**الوصف:**
- جدول `auth.users` هو **المصدر الوحيد** لجميع الهويات في النظام
- يدار بالكامل بواسطة Supabase Auth
- يحتوي على: email, encrypted_password, email_confirmed, metadata

### 1.2 ممنوع استخدام

❌ **محظور تماماً:**
1. جدول `mbuy_users` كنظام Auth → **Legacy فقط**
2. أي Custom JWT أو Auth System خارج Supabase Auth
3. جدول `mbuy_sessions` كنظام Sessions → **Legacy فقط**
4. أي نظام توثيق مخصص

### 1.3 الـ JWT المعتمد

✅ **Supabase Auth Access Token:**
```json
{
  "sub": "<auth.users.id>",
  "email": "user@example.com",
  "aud": "authenticated",
  "role": "authenticated",
  "iss": "https://sirqidofuvphqcxqchyc.supabase.co/auth/v1",
  "exp": 1234567890
}
```

**الاستخدام:**
- Flutter يخزن هذا الـ JWT في Secure Storage
- Worker يتحقق منه عبر Supabase Auth API
- RLS policies تستخدم `auth.uid()` لاستخراج user_id منه

❌ **محظور:**
- أي Custom JWT مبني من `mbuy_users`
- أي JWT يحتوي على `mbuy_user_id`

---

## 2️⃣ مسار الهوية وربط الجداول (Identity Chain)

### 2.1 المسار الرسمي الوحيد

```
┌─────────────────────────┐
│     auth.users          │  ← Supabase Auth (Identity Source)
│  - id (PK)              │
│  - email                │
│  - encrypted_password   │
└─────────┬───────────────┘
          │ 1:1
          │ user_profiles.auth_user_id = auth.users.id
          ↓
┌─────────────────────────┐
│   user_profiles         │  ← Business Profile
│  - id (PK = auth_user_id)│  Same UUID as auth.users.id
│  - auth_user_id (FK, UNIQUE)
│  - role                 │  'customer' | 'merchant' | 'admin'
│  - display_name         │
│  - email                │
│  - phone                │
└─────────┬───────────────┘
          │ 1:N
          │ stores.owner_id → user_profiles.id
          ↓
┌─────────────────────────┐
│      stores             │  ← Merchant Stores
│  - id (PK)              │
│  - owner_id (FK)        │  REFERENCES user_profiles(id)
│  - name                 │
│  - is_active            │
└─────────┬───────────────┘
          │ 1:N
          │ products.store_id → stores.id
          ↓
┌─────────────────────────┐
│     products            │  ← Store Products
│  - id (PK)              │
│  - store_id (FK)        │  REFERENCES stores(id)
│  - name                 │
│  - price                │
└─────────────────────────┘
```

### 2.2 صيغة خط واحدة

```
auth.users.id → user_profiles.auth_user_id → stores.owner_id → products.store_id
```

### 2.3 ممنوع استخدام

❌ **محظور في المسار الرسمي:**
- `user_profiles.mbuy_user_id` → Legacy column (nullable)
- جدول `merchants` منفصل → لا يوجد (role في user_profiles)
- جدول `profiles` منفصل → لا يوجد (user_profiles هو الصحيح)

---

## 3️⃣ قناة الاتصال (Communication Channel)

### 3.1 Architecture Pattern

```
┌─────────────┐
│   Flutter   │  ← Frontend (Dart)
│     App     │
└──────┬──────┘
       │ HTTP POST/GET
       │ Authorization: Bearer <Supabase JWT>
       ↓
┌─────────────────────┐
│ Cloudflare Worker  │  ← API Gateway / BFF
│  - Auth endpoints   │
│  - Business logic   │
│  - Validation       │
│  - Security         │
└──────┬──────────────┘
       │ Supabase Client (JS SDK)
       │ ANON_KEY + User JWT (RLS)
       │ OR SERVICE_ROLE_KEY (Admin)
       ↓
┌─────────────────────┐
│    Supabase         │  ← Backend Database + Auth
│  - PostgreSQL       │
│  - Auth Service     │
│  - RLS Policies     │
│  - Storage          │
└─────────────────────┘
```

### 3.2 Flutter → Worker ONLY

✅ **مسموح:**
```dart
// lib/core/services/api_service.dart
class ApiService {
  final String baseUrl = 'https://misty-mode-b68b.baharista1.workers.dev';
  
  Future<Response> post(String endpoint, Map<String, dynamic> body) {
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $supabaseJWT',  // ✅ Supabase JWT
      },
      body: jsonEncode(body),
    );
  }
}
```

❌ **محظور تماماً:**
```dart
// ❌ NO DIRECT SUPABASE CONNECTION
import 'package:supabase_flutter/supabase_flutter.dart';  // FORBIDDEN

final supabase = Supabase.instance.client;  // NEVER DO THIS
await supabase.from('products').select();   // FORBIDDEN
```

### 3.3 pubspec.yaml Requirements

✅ **مطلوب:**
```yaml
dependencies:
  http: ^1.2.0  # ✅ For Worker communication only
```

❌ **محظور:**
```yaml
dependencies:
  supabase_flutter: ^x.x.x  # ❌ FORBIDDEN - DO NOT ADD
```

### 3.4 Worker → Supabase

✅ **Worker يتواصل مع Supabase فقط:**
```typescript
// Worker is the ONLY component that talks to Supabase
import { createClient } from '@supabase/supabase-js';

// User client (RLS active)
const userClient = createClient(SUPABASE_URL, ANON_KEY, {
  global: { headers: { Authorization: `Bearer ${userJWT}` } }
});

// Admin client (RLS bypass)
const adminClient = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);
```

---

## 4️⃣ Supabase Clients في Worker

### 4.1 userClient (للعمليات العادية)

**الاستخدام:**
```typescript
const userClient = createClient(
  env.SUPABASE_URL,
  env.SUPABASE_ANON_KEY,
  {
    global: {
      headers: { Authorization: `Bearer ${userJWT}` }
    }
  }
);
```

**الخصائص:**
- ✅ يستخدم `SUPABASE_ANON_KEY`
- ✅ يمرر JWT المستخدم في Headers
- ✅ RLS Policies **نشطة**
- ✅ `auth.uid()` يعود بـ user_id من JWT
- ✅ المستخدم يرى بياناته فقط

**متى يُستخدم:**
- جلب profile المستخدم
- جلب منتجات متجر المستخدم
- إنشاء/تعديل منتجات
- جلب طلبات المستخدم

### 4.2 adminClient (للعمليات الإدارية فقط)

**الاستخدام:**
```typescript
const adminClient = createClient(
  env.SUPABASE_URL,
  env.SUPABASE_SERVICE_ROLE_KEY
);
```

**الخصائص:**
- ✅ يستخدم `SERVICE_ROLE_KEY`
- ⚠️ يتجاوز RLS تماماً
- ⚠️ وصول كامل لجميع البيانات
- ⚠️ استخدام خطير إذا لم يُراقب

**متى يُستخدم (فقط):**
- إنشاء مستخدم جديد في auth.users (Registration)
- إنشاء profile في user_profiles
- مهام النظام (system tasks)
- Admin dashboard operations
- Cleanup/maintenance jobs

❌ **محظور استخدامه لـ:**
- عمليات المستخدم العادي
- جلب بيانات المستخدم
- أي عملية يمكن أن تتم عبر userClient

### 4.3 القاعدة الذهبية

```
IF (user operation) THEN use userClient + JWT
IF (admin operation) THEN use adminClient
```

---

## 5️⃣ الربط من JWT داخل Worker

### 5.1 Middleware Flow

```typescript
// supabaseAuthMiddleware.ts
export async function supabaseAuthMiddleware(c, next) {
  // 1. Extract JWT from Authorization header
  const token = c.req.header('Authorization')?.substring(7);
  
  // 2. Verify with Supabase Auth
  const response = await fetch(`${SUPABASE_URL}/auth/v1/user`, {
    headers: {
      'Authorization': `Bearer ${token}`,
      'apikey': ANON_KEY
    }
  });
  
  const { id, email } = await response.json();  // auth.users.id
  
  // 3. Get user_profile
  const profile = await supabase
    .from('user_profiles')
    .select('id, role')
    .eq('auth_user_id', id)  // ✅ Uses auth_user_id
    .single();
  
  // 4. Set context
  c.set('authUserId', id);          // auth.users.id
  c.set('profileId', profile.id);   // user_profiles.id
  c.set('userRole', profile.role);  // customer | merchant | admin
  
  await next();
}
```

### 5.2 استخدام Context في Endpoints

```typescript
// GET /secure/merchant/store
app.get('/secure/merchant/store', supabaseAuthMiddleware, async (c) => {
  const profileId = c.get('profileId');  // user_profiles.id
  
  // Query stores using profileId
  const { data: store } = await supabase
    .from('stores')
    .select('*')
    .eq('owner_id', profileId)  // ✅ Uses profileId from user_profiles
    .single();
  
  return c.json({ ok: true, data: store });
});
```

### 5.3 المتغيرات في Context

| Variable | Source | Type | Usage |
|----------|--------|------|-------|
| `authUserId` | `auth.users.id` | UUID | Auth identity |
| `profileId` | `user_profiles.id` | UUID | Business identity |
| `userRole` | `user_profiles.role` | String | Permission check |
| `userClient` | Supabase client | Object | RLS queries |

---

## 6️⃣ حالة الجداول القديمة (Legacy Tables)

### 6.1 Legacy Tables (غير مستخدمة في المسار الرسمي)

| Table | Status | Usage | Action |
|-------|--------|-------|--------|
| `mbuy_users` | 🔴 Legacy | Custom Auth (old) | ⏸️ Keep for migration |
| `mbuy_sessions` | 🔴 Legacy | Custom Sessions (old) | ⏸️ Keep for migration |
| `profiles` | ⚪ N/A | Doesn't exist | ❌ Never existed |
| `merchants` | ⚪ N/A | Doesn't exist | ❌ Use user_profiles.role |

### 6.2 التعامل مع Legacy Tables

✅ **مسموح مؤقتاً:**
- الإبقاء على الجداول في قاعدة البيانات
- قراءة البيانات للـ migration
- عرض بيانات قديمة (read-only)

❌ **محظور نهائياً:**
- إنشاء users جدد في `mbuy_users`
- إنشاء sessions جديدة في `mbuy_sessions`
- استخدام `mbuy_user_id` في logic جديد
- بناء JWT من `mbuy_users`

### 6.3 خطة الإزالة (بعد 3-6 أشهر)

```sql
-- Phase 1: Make tables read-only
ALTER TABLE mbuy_users SET (autovacuum_enabled = false);
REVOKE INSERT, UPDATE, DELETE ON mbuy_users FROM PUBLIC;

-- Phase 2: Archive data
CREATE TABLE mbuy_users_archive AS SELECT * FROM mbuy_users;

-- Phase 3: Drop tables (after verification)
DROP TABLE mbuy_sessions;
DROP TABLE mbuy_users;

-- Phase 4: Clean user_profiles
ALTER TABLE user_profiles DROP COLUMN mbuy_user_id;
```

---

## 7️⃣ RLS Policies - Row Level Security

### 7.1 المبدأ الأساسي

```sql
-- ✅ GOLDEN RULE: Use auth.uid() always
auth.uid() = user_profiles.auth_user_id
```

### 7.2 أمثلة RLS Policies

```sql
-- user_profiles: Users can view own profile
CREATE POLICY "users_view_own_profile"
ON user_profiles FOR SELECT
USING (auth.uid() = auth_user_id);  -- ✅ Correct

-- stores: Merchants can manage their stores
CREATE POLICY "merchants_manage_stores"
ON stores FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_profiles.id = stores.owner_id
    AND user_profiles.auth_user_id = auth.uid()  -- ✅ Correct
  )
);

-- products: Merchants can manage store products
CREATE POLICY "merchants_manage_products"
ON products FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM stores
    JOIN user_profiles ON stores.owner_id = user_profiles.id
    WHERE products.store_id = stores.id
    AND user_profiles.auth_user_id = auth.uid()  -- ✅ Correct
  )
);
```

❌ **محظور:**
```sql
-- ❌ WRONG: Using mbuy_user_id
CREATE POLICY "wrong_policy"
ON user_profiles FOR SELECT
USING (auth.uid() = mbuy_user_id);  -- WRONG!

-- ❌ WRONG: Not using auth.uid() at all
CREATE POLICY "no_auth_check"
ON user_profiles FOR SELECT
USING (true);  -- Security hole!
```

---

## 8️⃣ Worker Endpoints Architecture

### 8.1 Auth Endpoints

✅ **Supabase Auth (Golden Plan):**
```typescript
POST /auth/supabase/register  → Create user in auth.users
POST /auth/supabase/login     → Get Supabase JWT
POST /auth/supabase/logout    → Revoke Supabase session
POST /auth/supabase/refresh   → Refresh Supabase JWT
```

❌ **Legacy (Deprecated - Return 410 Gone):**
```typescript
POST /auth/register  → 410 Gone
POST /auth/login     → 410 Gone
POST /auth/logout    → 410 Gone
POST /auth/refresh   → 410 Gone
GET  /auth/me        → 410 Gone
```

### 8.2 Business Endpoints

✅ **Using supabaseAuthMiddleware:**
```typescript
// User profile
GET /secure/users/me

// Merchant stores
GET  /secure/merchant/store
POST /secure/merchant/store

// Products
GET    /secure/products
POST   /secure/products
PUT    /secure/products/:id
DELETE /secure/products/:id

// Media
POST /secure/media/upload-urls
```

### 8.3 Endpoint Pattern

```typescript
// Standard pattern for all secure endpoints
app.get('/secure/endpoint', supabaseAuthMiddleware, async (c) => {
  // 1. Get context from middleware
  const authUserId = c.get('authUserId');    // auth.users.id
  const profileId = c.get('profileId');      // user_profiles.id
  const userRole = c.get('userRole');        // role
  
  // 2. Check permissions
  if (userRole !== 'merchant') {
    return c.json({ error: 'forbidden' }, 403);
  }
  
  // 3. Query using profileId
  const { data } = await supabase
    .from('stores')
    .select('*')
    .eq('owner_id', profileId);  // ✅ Uses profileId
  
  // 4. Return data
  return c.json({ ok: true, data });
});
```

---

## 9️⃣ Flutter App Architecture

### 9.1 Services Structure

```
lib/
├── core/
│   ├── services/
│   │   ├── api_service.dart         ✅ HTTP to Worker only
│   │   ├── auth_service.dart        ✅ Manages Supabase JWT
│   │   └── storage_service.dart     ✅ Local secure storage
│   ├── config/
│   │   └── api_config.dart          ✅ Worker URL
│   └── models/
│       ├── user_model.dart          ✅ user_profiles model
│       └── auth_response_model.dart ✅ Supabase JWT response
```

### 9.2 Auth Service Example

```dart
// lib/core/services/auth_service.dart
class AuthService {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();
  
  // ✅ Register via Worker
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await _api.post('/auth/supabase/register', {
      'email': email,
      'password': password,
      'full_name': fullName,
    });
    
    // Store Supabase JWT
    await _storage.saveToken(response['access_token']);
    return AuthResponse.fromJson(response);
  }
  
  // ✅ Login via Worker
  Future<AuthResponse> login(String email, String password) async {
    final response = await _api.post('/auth/supabase/login', {
      'email': email,
      'password': password,
    });
    
    await _storage.saveToken(response['access_token']);
    return AuthResponse.fromJson(response);
  }
  
  // ✅ Get current user via Worker
  Future<UserProfile> getCurrentUser() async {
    final token = await _storage.getToken();
    final response = await _api.get('/secure/users/me', token);
    return UserProfile.fromJson(response['data']);
  }
}
```

❌ **محظور:**
```dart
// ❌ NEVER DO THIS
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
await supabase.auth.signUp(email: email, password: password);
```

---

## 🔟 Database Schema Reference

### 10.1 Core Tables

```sql
-- auth.users (Managed by Supabase)
CREATE TABLE auth.users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  encrypted_password TEXT NOT NULL,
  email_confirmed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- user_profiles (Business layer)
CREATE TABLE public.user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  auth_user_id UUID UNIQUE NOT NULL REFERENCES auth.users(id),
  role TEXT NOT NULL CHECK (role IN ('customer', 'merchant', 'admin')),
  display_name TEXT,
  email TEXT,
  phone TEXT,
  avatar_url TEXT,
  mbuy_user_id UUID,  -- ⚠️ Legacy, nullable
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- stores
CREATE TABLE public.stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES user_profiles(id),
  name TEXT NOT NULL,
  description TEXT,
  city TEXT,
  is_active BOOLEAN DEFAULT true,
  is_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- products
CREATE TABLE public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id),
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  stock INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 10.2 Key Constraints

```sql
-- Foreign Keys (enforcing identity chain)
ALTER TABLE user_profiles
  ADD CONSTRAINT fk_auth_user
  FOREIGN KEY (auth_user_id)
  REFERENCES auth.users(id)
  ON DELETE CASCADE;

ALTER TABLE stores
  ADD CONSTRAINT fk_owner
  FOREIGN KEY (owner_id)
  REFERENCES user_profiles(id)
  ON DELETE CASCADE;

ALTER TABLE products
  ADD CONSTRAINT fk_store
  FOREIGN KEY (store_id)
  REFERENCES stores(id)
  ON DELETE CASCADE;

-- Unique constraints
ALTER TABLE user_profiles
  ADD CONSTRAINT unique_auth_user_id
  UNIQUE (auth_user_id);
```

---

## 1️⃣1️⃣ Deployment Checklist

### 11.1 Worker Deployment

```bash
# 1. Update code to follow Golden Plan
# 2. Run tests
npm test

# 3. Deploy to Cloudflare
npm run deploy

# 4. Verify endpoints
curl https://misty-mode-b68b.baharista1.workers.dev/auth/supabase/register
```

### 11.2 Database Migration

```sql
-- 1. Apply migration
psql -f migrations/20251211000001_supabase_auth_phase1.sql

-- 2. Verify schema
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'user_profiles'
AND column_name IN ('auth_user_id', 'mbuy_user_id');

-- 3. Test RLS
SET ROLE authenticated;
SELECT * FROM user_profiles WHERE auth_user_id = auth.uid();
```

### 11.3 Flutter App Update

```bash
# 1. Update dependencies
flutter pub get

# 2. Verify no supabase_flutter
grep "supabase_flutter" pubspec.yaml  # Should return nothing

# 3. Run app
flutter run
```

---

## 1️⃣2️⃣ التزامات التوثيق

### 12.1 ملفات يجب تحديثها

✅ **مطلوب التحديث:**
1. `docs/MBUY_ARCHITECTURE_REFERENCE.md` → يجب أن يعكس الخطة الذهبية
2. `docs/API.md` → توثيق endpoints الجديدة
3. `README.md` → نظرة عامة تتوافق مع الخطة
4. `mbuy-worker/README.md` → Worker architecture
5. `saleh/README.md` → Flutter app architecture

❌ **محظور:**
- أي توثيق يذكر `mbuy_users` كنظام حالي
- أي توثيق يذكر Custom JWT كنظام معتمد
- أي توثيق يقول "Flutter → Supabase مباشرة"

### 12.2 Code Comments

✅ **استخدم:**
```typescript
// ✅ GOLDEN PLAN: Uses Supabase Auth
// ✅ CORRECT: auth.users → user_profiles
// ✅ FOLLOWS: Identity chain
```

❌ **لا تستخدم:**
```typescript
// Uses mbuy_users  // ❌ WRONG - Legacy
// Custom JWT system  // ❌ WRONG - Deprecated
```

---

## 1️⃣3️⃣ القواعد الذهبية (Golden Rules)

### ✅ DO (مطلوب):

1. **Always use Supabase Auth**
   - Register via `/auth/supabase/register`
   - Login returns Supabase JWT
   - RLS uses `auth.uid()`

2. **Flutter → Worker ONLY**
   - No `supabase_flutter` package
   - HTTP requests to Worker
   - Worker handles all Supabase communication

3. **Follow Identity Chain**
   ```
   auth.users.id → user_profiles.auth_user_id → stores.owner_id → products.store_id
   ```

4. **Use Correct Supabase Client**
   - `userClient` for user operations (RLS active)
   - `adminClient` for system operations only

5. **Enforce RLS**
   - All policies use `auth.uid()`
   - Never bypass RLS for user operations

### ❌ DON'T (محظور):

1. **Never use Legacy Auth**
   - No `mbuy_users` for new users
   - No Custom JWT generation
   - No `mbuy_sessions` table

2. **Never bypass Worker**
   - Flutter cannot talk to Supabase directly
   - No direct database queries from Flutter

3. **Never misuse adminClient**
   - Don't use SERVICE_ROLE_KEY for regular users
   - Don't bypass RLS unnecessarily

4. **Never break Identity Chain**
   - Don't use `mbuy_user_id` in new code
   - Don't create custom auth tables

5. **Never ignore Security**
   - Always verify JWT
   - Always check user permissions
   - Always use RLS policies

---

## 1️⃣4️⃣ الحالة الحالية (As of Dec 11, 2025)

### ✅ Completed:
- ✅ Supabase Auth endpoints created
- ✅ Core business endpoints updated
- ✅ Legacy endpoints deprecated (410 Gone)
- ✅ Worker deployed successfully
- ✅ Documentation created
- ✅ Flutter app compliant (no supabase_flutter)

### ⏸️ In Progress:
- ⏸️ Remaining endpoints need middleware
- ⏸️ Testing full authentication flow
- ⏸️ Data migration from mbuy_users

### 📅 Future:
- 📅 Remove Legacy tables (3-6 months)
- 📅 Clean up deprecated code
- 📅 Full system audit

---

## 📞 Contact & Support

**للمساعدة أو التوضيح:**
- راجع `GOLDEN_ARCHITECTURE_COMPLIANCE_REPORT.md`
- راجع `WORKER_AUTH_MIGRATION_PROGRESS.md`
- افحص أمثلة الكود في `mbuy-worker/src/endpoints/supabaseAuth.ts`

**عند الشك:**
```
IF (using auth.users) THEN ✅ Correct
IF (using mbuy_users) THEN ❌ Legacy - Update code
IF (Flutter → Supabase directly) THEN ❌ Wrong - Use Worker
```

---

## 🎯 الخلاصة النهائية

هذه الوثيقة هي **المرجع الوحيد المعتمد** لمعمارية MBUY. أي كود أو توثيق يخالفها يعتبر:
1. خطأ يجب تصحيحه
2. Legacy code يجب تحديثه
3. Security risk يجب معالجته

**القاعدة الأساسية:**
```
Supabase Auth → Worker → Flutter
auth.users → user_profiles → stores → products
```

**لا تخالف هذه الخطة.**

---

**📌 تاريخ آخر تحديث:** 11 ديسمبر 2025  
**✅ الحالة:** معتمد ونشط  
**🔒 الإلزامية:** إجبارية على جميع المطورين
