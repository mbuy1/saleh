# MBUY Architecture Reference - الخطة الذهبية

> **✅ هذا الملف هو المرجع الرسمي والوحيد لمشروع MBUY**  
> أي تعديل على الجداول، RLS Policies، Worker، أو Flutter يجب أن يكون متوافقاً مع **الخطة الذهبية**.

> **🎯 القرار المعماري النهائي:** الخطة الذهبية - Supabase Auth Only  
> **📅 تاريخ القرار:** 11 ديسمبر 2025  
> **🔒 الإلزامية:** جميع الأكواد الجديدة يجب أن تتبع هذه الخطة

---

## 📋 جدول المحتويات

1. [الخطة الذهبية - القرار النهائي](#1-الخطة-الذهبية)
2. [المعمارية النهائية](#2-المعمارية-النهائية)
3. [مسار الهوية الرسمي](#3-مسار-الهوية-الرسمي)
4. [تدفق البيانات](#4-تدفق-البيانات)
5. [Worker Architecture](#5-worker-architecture)
6. [RLS Policies](#6-rls-policies)
7. [Legacy Tables - للمرجعية فقط](#7-legacy-tables)

---

## 1. الخطة الذهبية

### 1.1 المبادئ الأساسية

**✅ المعتمد رسمياً:**

1. **نظام التوثيق:**
   - ✅ Supabase Auth (`auth.users`) هو المصدر الوحيد للهوية
   - ✅ لا استخدام لـ `mbuy_users` كنظام توثيق
   - ✅ لا Custom JWT قديم
   - ✅ لا `mbuy_sessions` table

2. **مسار الهوية:**
   ```
   auth.users.id → user_profiles.auth_user_id → stores.owner_id → products.store_id
   ```

3. **قناة الاتصال:**
   - ✅ Flutter → Cloudflare Worker (HTTP + Supabase JWT)
   - ✅ Worker → Supabase (userClient مع RLS / adminClient بدون RLS)
   - ❌ Flutter لا يتصل بـ Supabase مباشرة
   - ❌ لا استخدام لـ `supabase_flutter` package

4. **Worker Clients:**
   - `userClient`: SUPABASE_ANON_KEY + User JWT (RLS نشط)
   - `adminClient`: SUPABASE_SERVICE_ROLE_KEY (للمهام الإدارية فقط)

**❌ محظور تماماً:**

- ❌ استخدام `mbuy_users` كمصدر هوية
- ❌ إنشاء Custom JWT من `mbuy_users`
- ❌ استخدام `mbuy_sessions` لإدارة الجلسات
- ❌ Flutter يتصل بـ Supabase مباشرة
- ❌ استخدام `supabase_flutter` في Flutter
- ❌ أي نظام توثيق مزدوج (Dual Auth)

### 1.2 تنظيف Legacy Code

**✅ تم الإنجاز:**
- ✅ حذف `mbuy-worker/src/endpoints/auth.ts` (Custom JWT Auth)
- ✅ حذف `mbuy-worker/src/middleware/authMiddleware.ts` (Legacy Auth Middleware)
- ✅ حذف `mbuy-worker/src/middleware/roleMiddleware.ts` (Legacy Role Check)
- ✅ حذف `mbuy-worker/src/utils/jwtHelper.ts` (Custom JWT Generation)
- ✅ حذف `mbuy-worker/src/utils/userMapping.ts` (mbuy_users mapping)
- ✅ Legacy auth endpoints في index.ts تعيد 410 Gone

**⚠️ Legacy Tables (موجودة للمرجعية فقط):**
- `mbuy_users` - لا يُستخدم في Auth، للبيانات القديمة فقط
- `mbuy_sessions` - لا يُستخدم، للبيانات القديمة فقط
- `profiles` - لا يوجد هذا الجدول (نستخدم `user_profiles`)
- `merchants` - لا يوجد هذا الجدول (نستخدم `user_profiles.role`)

---

## 2. المعمارية النهائية

### 2.1 النظرة الشاملة

```
┌─────────────────────────────┐
│      Flutter App            │
│   (Dart + http package)     │
│                             │
│   • ApiService (HTTP only)  │
│   • NO Supabase SDK         │
│   • NO direct DB access     │
│   • Stores Supabase JWT     │
└──────────────┬──────────────┘
               │
               │ HTTP POST/GET
               │ Authorization: Bearer <Supabase-JWT>
               │
               ↓
    ┌──────────────────────────┐
    │   Cloudflare Worker      │
    │   (TypeScript)           │
    │                          │
    │   ┌──────────────────┐   │
    │   │ Supabase Auth    │   │
    │   │ /auth/supabase/* │───┼─→ Supabase Auth API
    │   │ - register       │   │   (creates auth.users)
    │   │ - login          │   │   (returns Supabase JWT)
    │   │ - logout         │   │
    │   │ - refresh        │   │
    │   └──────────────────┘   │
    │                          │
    │   ┌──────────────────┐   │
    │   │ Business Logic   │   │
    │   │ /secure/*        │   │
    │   │ - users/me       │   │
    │   │ - merchant/store │   │
    │   │ - products       │   │
    │   └──────────────────┘   │
    │                          │
    │   ┌──────────────────┐   │
    │   │ Supabase Clients │   │
    │   │                  │   │
    │   │ • userClient     │───┼─→ ANON_KEY + User JWT
    │   │   (RLS active)   │   │   RLS: auth.uid() checks
    │   │                  │   │
    │   │ • adminClient    │───┼─→ SERVICE_ROLE_KEY
    │   │   (RLS bypass)   │   │   System operations only
    │   └──────────────────┘   │
    └────────────┬─────────────┘
                 │
                 ↓
      ┌──────────────────────┐
      │ Supabase PostgreSQL  │
      │                      │
      │ • auth.users         │ ← Supabase Auth (Identity)
      │ • user_profiles      │ ← id = auth.users.id
      │ • stores             │ ← owner_id → user_profiles.id
      │ • products           │ ← store_id → stores.id
      │ • ...                │
      │                      │
      │ RLS: ✅ Active       │
      │ auth.uid(): ✅ Works │
      └──────────────────────┘
```

### 2.2 مسار الطلب الكامل

**1. User Login:**
```
Flutter                  Worker                    Supabase
  │                        │                          │
  ├─ POST /auth/login ────→│                          │
  │  {email, password}     │                          │
  │                        ├─ signInWithPassword() ──→│
  │                        │                          │
  │                        │←─ {jwt, refresh_token} ──┤
  │←─ {access_token} ──────┤                          │
  │  (Supabase JWT)        │                          │
```

**2. Authenticated Request:**
```
Flutter                  Worker                    Supabase
  │                        │                          │
  ├─ POST /products ───────→│                          │
  │  Bearer: <Supabase-JWT>│                          │
  │                        │                          │
  │                        ├─ Verify JWT             │
  │                        ├─ Create userClient      │
  │                        │  (ANON_KEY + JWT)       │
  │                        │                          │
  │                        ├─ userClient.from()  ────→│
  │                        │  (RLS checks auth.uid()) │
  │                        │                          │
  │                        │←─ {data} ────────────────┤
  │←─ {product} ───────────┤                          │
```

---

## 3. ربط الهوية والجداول

### 3.1 هرم الهوية (Identity Hierarchy)

```
┌─────────────────────────┐
│     auth.users          │ ← SOURCE OF TRUTH (Supabase Auth)
│  - id (PK)              │
│  - email                │
│  - encrypted_password   │
│  - email_confirmed_at   │
│  - raw_user_meta_data   │
└─────────┬───────────────┘
          │ 1:1
          │ user_profiles.id = auth.users.id
          ↓
┌─────────────────────────┐
│   user_profiles         │ ← Business Profile
│  - id (PK, FK)          │   REFERENCES auth.users(id)
│  - display_name         │
│  - role                 │ ← 'customer', 'merchant', 'admin'
│  - avatar_url           │
│  - phone                │
└─────────┬───────────────┘
          │ 1:N
          │ stores.owner_id → user_profiles.id
          ↓
┌─────────────────────────┐
│      stores             │
│  - id (PK)              │
│  - owner_id (FK)        │ ← REFERENCES user_profiles(id)
│  - name                 │
│  - status               │
└─────────┬───────────────┘
          │ 1:N
          │ products.store_id → stores.id
          ↓
┌─────────────────────────┐
│     products            │
│  - id (PK)              │
│  - store_id (FK)        │ ← REFERENCES stores(id)
│  - name                 │
│  - price                │
└─────────────────────────┘
```

### 3.2 Source of Truth Table

| الكيان | المصدر | الحقل الرئيسي |
|--------|--------|----------------|
| **الهوية** | `auth.users` | `id` (UUID) |
| **Profile** | `user_profiles` | `id` = `auth.users.id` |
| **Store Owner** | `user_profiles` | `id` |
| **JWT.sub** | Supabase Auth | `auth.users.id` |
| **RLS auth.uid()** | Supabase Auth | `auth.users.id` |

### 3.3 Schema النهائي

```sql
-- auth.users (Supabase managed - لا نعدله)
-- Automatically created by Supabase Auth

-- user_profiles (Custom table)
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'customer' 
    CHECK (role IN ('customer', 'merchant', 'admin')),
  avatar_url TEXT,
  phone TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Auto-create profile when auth.user is created
CREATE OR REPLACE FUNCTION handle_new_auth_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (id, display_name, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', SPLIT_PART(NEW.email, '@', 1)),
    'customer'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_auth_user();

-- stores
CREATE TABLE stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  status TEXT DEFAULT 'active',
  -- ...
);

-- products  
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  price DECIMAL(12, 2) NOT NULL,
  -- ...
);
```

---

## 4. تدفق البيانات

### 4.1 Flutter → Worker (HTTP Only)

**Flutter Side:**
```dart
// lib/core/services/api_service.dart
class ApiService {
  final String baseUrl = AppConfig.apiBaseUrl; // Worker URL
  final http.Client _client = http.Client();
  
  // Store JWT in secure storage
  Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'access_token');
  }
  
  // All requests go through Worker
  Future<http.Response> post(String path, {Object? body}) async {
    final token = await getToken();
    final uri = Uri.parse('$baseUrl$path');
    
    return await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }
}
```

**✅ ما يحدث:**
- Flutter يحفظ Supabase JWT محلياً
- كل طلب يمر عبر Worker فقط
- لا اتصال مباشر بـ Supabase

**❌ ما لا يحدث:**
- لا استخدام `Supabase.instance.client`
- لا `supabase_flutter` package
- لا direct database queries

### 4.2 Auth Flow (النهائي)

**Registration:**
```
1. Flutter: POST /auth/register {email, password, full_name}
   ↓
2. Worker: Calls Supabase Auth API
   const { data } = await adminClient.auth.admin.createUser({
     email, password, user_metadata: {full_name}
   });
   ↓
3. Supabase: Creates auth.users record
   ↓
4. Trigger: Auto-creates user_profiles record
   ↓
5. Worker: Returns success (no JWT yet - must login)
   ↓
6. Flutter: Shows "Check email" or auto-login
```

**Login:**
```
1. Flutter: POST /auth/login {email, password}
   ↓
2. Worker: Calls Supabase Auth
   const { data } = await adminClient.auth.signInWithPassword({
     email, password
   });
   ↓
3. Supabase Auth: Validates & returns JWT
   ↓
4. Worker: Returns {access_token, refresh_token, user}
   ↓
5. Flutter: Stores JWT in secure storage
```

**Authenticated Request:**
```
1. Flutter: POST /products + Bearer <JWT>
   ↓
2. Worker Middleware: 
   - Extracts JWT
   - Creates userClient (ANON_KEY + JWT)
   - Verifies with Supabase Auth
   - Fetches user_profile
   - Sets context
   ↓
3. Worker Endpoint:
   - Uses userClient for queries
   - RLS automatically filters by auth.uid()
   ↓
4. Supabase: Returns data (RLS applied)
   ↓
5. Worker: Returns to Flutter
```

---

## 5. Worker Architecture

### 5.1 Supabase Clients (Hybrid Model)

#### A. User Client (للمستخدمين)

```typescript
// src/utils/supabaseUser.ts
import { createClient } from '@supabase/supabase-js';

export function createUserSupabaseClient(env: Env, userJwt: string) {
  return createClient(
    env.SUPABASE_URL,
    env.SUPABASE_ANON_KEY,  // ✅ ANON_KEY
    {
      global: {
        headers: {
          Authorization: `Bearer ${userJwt}`  // ✅ User's Supabase JWT
        }
      }
    }
  );
}
```

**استخدام:**
- ✅ جميع عمليات المستخدمين
- ✅ RLS active
- ✅ `auth.uid()` يعمل
- ✅ تحقق تلقائي من الصلاحيات

#### B. Admin Client (للنظام)

```typescript
// src/utils/supabaseAdmin.ts
import { createClient } from '@supabase/supabase-js';

export function createAdminSupabaseClient(env: Env) {
  return createClient(
    env.SUPABASE_URL,
    env.SUPABASE_SERVICE_ROLE_KEY,  // ✅ SERVICE_ROLE
  );
}
```

**استخدام:**
- ✅ عمليات Admin فقط
- ✅ Cron jobs
- ✅ System workflows
- ✅ RLS bypass

**❌ لا تستخدم لـ:**
- ❌ عمليات المستخدمين العادية
- ❌ Endpoints العامة

### 5.2 Auth Middleware

```typescript
// src/middleware/supabaseAuthMiddleware.ts
import { Context, Next } from 'hono';
import { createUserSupabaseClient } from '../utils/supabaseUser';

export async function supabaseAuthMiddleware(c: Context, next: Next) {
  // 1. Extract JWT from Authorization header
  const authHeader = c.req.header('Authorization');
  if (!authHeader?.startsWith('Bearer ')) {
    return c.json({ error: 'unauthorized' }, 401);
  }
  
  const token = authHeader.substring(7);
  
  // 2. Create user client
  const userClient = createUserSupabaseClient(c.env, token);
  
  // 3. Verify token with Supabase Auth
  const { data: { user }, error } = await userClient.auth.getUser(token);
  if (error || !user) {
    return c.json({ error: 'unauthorized' }, 401);
  }
  
  // 4. Fetch user profile
  const { data: profile } = await userClient
    .from('user_profiles')
    .select('id, role, display_name')
    .eq('id', user.id)
    .single();
  
  if (!profile) {
    return c.json({ error: 'profile_not_found' }, 404);
  }
  
  // 5. Set context
  c.set('userId', user.id);           // auth.users.id
  c.set('profileId', profile.id);     // = user.id
  c.set('userRole', profile.role);
  c.set('userClient', userClient);    // ✅ RLS active
  
  await next();
}
```

### 5.3 Auth Endpoints

```typescript
// src/endpoints/auth.ts
import { Hono } from 'hono';
import { createAdminSupabaseClient } from '../utils/supabaseAdmin';

const app = new Hono();

// Register
app.post('/register', async (c) => {
  const { email, password, full_name } = await c.req.json();
  const adminClient = createAdminSupabaseClient(c.env);
  
  const { data, error } = await adminClient.auth.admin.createUser({
    email,
    password,
    email_confirm: true,  // or false if you want email verification
    user_metadata: { full_name },
  });
  
  if (error) return c.json({ error: error.message }, 400);
  
  return c.json({ 
    message: 'User created successfully',
    user: { id: data.user.id, email: data.user.email }
  }, 201);
});

// Login
app.post('/login', async (c) => {
  const { email, password } = await c.req.json();
  const adminClient = createAdminSupabaseClient(c.env);
  
  const { data, error } = await adminClient.auth.signInWithPassword({
    email,
    password,
  });
  
  if (error) return c.json({ error: 'invalid_credentials' }, 401);
  
  return c.json({
    access_token: data.session.access_token,
    refresh_token: data.session.refresh_token,
    user: {
      id: data.user.id,
      email: data.user.email,
    }
  });
});

// Logout
app.post('/logout', supabaseAuthMiddleware, async (c) => {
  const userClient = c.get('userClient');
  await userClient.auth.signOut();
  
  return c.json({ message: 'Logged out successfully' });
});

export default app;
```

### 5.4 Business Endpoints (Example)

```typescript
// src/endpoints/products.ts
import { Hono } from 'hono';
import { supabaseAuthMiddleware } from '../middleware/supabaseAuthMiddleware';

const app = new Hono();

// All routes protected
app.use('/*', supabaseAuthMiddleware);

// Create product
app.post('/', async (c) => {
  const userId = c.get('userId');
  const role = c.get('userRole');
  const userClient = c.get('userClient');  // ✅ RLS active
  
  if (role !== 'merchant' && role !== 'admin') {
    return c.json({ error: 'forbidden' }, 403);
  }
  
  // Get user's store (RLS checks ownership automatically)
  const { data: store } = await userClient
    .from('stores')
    .select('id, status')
    .eq('owner_id', userId)
    .single();
  
  if (!store) {
    return c.json({ error: 'no_store' }, 400);
  }
  
  const body = await c.req.json();
  
  // Create product (RLS checks ownership automatically)
  const { data, error } = await userClient
    .from('products')
    .insert({
      store_id: store.id,
      name: body.name,
      price: body.price,
      // ...
    })
    .select()
    .single();
  
  if (error) return c.json({ error: error.message }, 500);
  
  return c.json({ product: data }, 201);
});

export default app;
```

---

## 6. RLS Policies

### 6.1 مبادئ RLS

**✅ الآن:**
- `auth.uid()` يعمل بشكل كامل
- `user_profiles.id = auth.users.id`
- RLS فعّال ويتحقق تلقائياً
- Worker يستخدم `userClient` (ANON_KEY + JWT)

**❌ لم يعد:**
- `mbuy_user_id`
- Custom JWT checks
- Manual permission checks في الكود

### 6.2 user_profiles Policies

```sql
-- Users can view their own profile
CREATE POLICY "users_view_own_profile"
ON user_profiles
FOR SELECT
TO authenticated
USING (id = auth.uid());

-- Users can update their own profile
CREATE POLICY "users_update_own_profile"
ON user_profiles
FOR UPDATE
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Public can view merchant profiles
CREATE POLICY "public_view_merchants"
ON user_profiles
FOR SELECT
TO anon, authenticated
USING (role = 'merchant');
```

### 6.3 stores Policies

```sql
-- Merchants can create stores
CREATE POLICY "merchants_create_store"
ON stores
FOR INSERT
TO authenticated
WITH CHECK (
  owner_id = auth.uid()
  AND EXISTS (
    SELECT 1 FROM user_profiles
    WHERE id = auth.uid()
    AND role IN ('merchant', 'admin')
  )
);

-- Users can view their own stores
CREATE POLICY "users_view_own_stores"
ON stores
FOR SELECT
TO authenticated
USING (owner_id = auth.uid());

-- Users can update their own stores
CREATE POLICY "users_update_own_stores"
ON stores
FOR UPDATE
TO authenticated
USING (owner_id = auth.uid())
WITH CHECK (owner_id = auth.uid());

-- Public can view active stores
CREATE POLICY "public_view_active_stores"
ON stores
FOR SELECT
TO anon, authenticated
USING (status = 'active');
```

### 6.4 products Policies

```sql
-- Merchants can create products in their stores
CREATE POLICY "merchants_create_products"
ON products
FOR INSERT
TO authenticated
WITH CHECK (
  store_id IN (
    SELECT id FROM stores WHERE owner_id = auth.uid()
  )
);

-- Users can view their own products
CREATE POLICY "users_view_own_products"
ON products
FOR SELECT
TO authenticated
USING (
  store_id IN (
    SELECT id FROM stores WHERE owner_id = auth.uid()
  )
);

-- Users can update their own products
CREATE POLICY "users_update_own_products"
ON products
FOR UPDATE
TO authenticated
USING (
  store_id IN (
    SELECT id FROM stores WHERE owner_id = auth.uid()
  )
)
WITH CHECK (
  store_id IN (
    SELECT id FROM stores WHERE owner_id = auth.uid()
  )
);

-- Public can view active products
CREATE POLICY "public_view_active_products"
ON products
FOR SELECT
TO anon, authenticated
USING (status = 'active');
```

---

## 7. خطة الانتقال (Migration Plan)

> **⚠️ هذه الخطة للتنفيذ التدريجي من النظام الحالي (mbuy_users Custom Auth) إلى النظام النهائي (Supabase Auth)**

### Overview

**الحالة الحالية:**
- Custom JWT من `mbuy_users`
- Worker يستخدم SERVICE_ROLE_KEY فقط
- RLS موجود لكن غير فعّال

**الحالة المستهدفة:**
- Supabase Auth (`auth.users`)
- Worker يستخدم userClient (ANON_KEY + JWT)
- RLS فعّال بالكامل

**الاستراتيجية:**
- ✅ تدريجية (لا Big Bang)
- ✅ لا كسر للنظام الحالي أثناء Migration
- ✅ اختبار كل مرحلة قبل المتابعة
- ✅ إمكانية Rollback في أي وقت

---

### المرحلة 1: إدخال auth.users وربطه مع user_profiles

**الهدف:** تحضير البنية التحتية لـ Supabase Auth بدون المساس بالنظام الحالي

#### 1.1 Database Changes

**A. تعديل user_profiles:**

```sql
-- Migration: 001_add_auth_user_support.sql

-- 1. إضافة عمود auth_user_id (nullable مؤقتاً)
ALTER TABLE user_profiles
ADD COLUMN auth_user_id UUID UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE;

-- 2. إضافة index للأداء
CREATE INDEX idx_user_profiles_auth_user_id ON user_profiles(auth_user_id)
WHERE auth_user_id IS NOT NULL;

-- 3. السماح بوجود mbuy_user_id OR auth_user_id
-- (سيتم تحديث هذا لاحقاً ليكون auth_user_id فقط)
ALTER TABLE user_profiles
ALTER COLUMN mbuy_user_id DROP NOT NULL;

COMMENT ON COLUMN user_profiles.auth_user_id IS
'Links to Supabase Auth user. Will replace mbuy_user_id as primary identity.';
```

**B. إنشاء Trigger لـ Auto-Profile Creation:**

```sql
-- Function: Creates user_profile when auth.user is created
CREATE OR REPLACE FUNCTION handle_new_auth_user()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  -- Check if profile already exists (shouldn't happen, but safety first)
  IF NOT EXISTS (SELECT 1 FROM user_profiles WHERE auth_user_id = NEW.id) THEN
    INSERT INTO user_profiles (
      id,
      auth_user_id,
      display_name,
      role,
      created_at,
      updated_at
    ) VALUES (
      NEW.id,  -- user_profiles.id = auth.users.id
      NEW.id,  -- auth_user_id للربط
      COALESCE(NEW.raw_user_meta_data->>'full_name', SPLIT_PART(NEW.email, '@', 1)),
      'customer',
      NOW(),
      NOW()
    );
  END IF;
  
  RETURN NEW;
END;
$$;

-- Trigger: Fires when new auth.user is created
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_auth_user();
```

**C. اختبار النظام الجديد:**

```sql
-- Test: Create test user via Supabase Auth Dashboard
-- Verify that user_profile was auto-created with auth_user_id populated

SELECT 
  au.id as auth_id,
  au.email,
  up.id as profile_id,
  up.auth_user_id,
  up.mbuy_user_id,
  up.role
FROM auth.users au
LEFT JOIN user_profiles up ON au.id = up.auth_user_id
WHERE au.email = 'test@example.com';
```

**Status Check:**
- ✅ `auth.users` جاهز للاستخدام
- ✅ Trigger ينشئ profiles تلقائياً
- ✅ النظام القديم يعمل 100%
- ⏳ المستخدمون الحاليون لا يزالون على `mbuy_users`

---

### المرحلة 2: تعديل Worker لدعم Supabase Auth JWT

**الهدف:** إضافة دعم Supabase Auth في Worker مع الإبقاء على Custom JWT مؤقتاً

#### 2.1 إنشاء User Client

```typescript
// src/utils/supabaseUser.ts
import { createClient } from '@supabase/supabase-js';
import type { Env } from '../types';

export function createUserSupabaseClient(env: Env, userJwt: string) {
  return createClient(
    env.SUPABASE_URL,
    env.SUPABASE_ANON_KEY,
    {
      global: {
        headers: { Authorization: `Bearer ${userJwt}` }
      }
    }
  );
}
```

#### 2.2 إعادة تسمية Admin Client

```typescript
// src/utils/supabaseAdmin.ts (renamed from supabase.ts)
import { createClient } from '@supabase/supabase-js';
import type { Env } from '../types';

export function createAdminSupabaseClient(env: Env) {
  return createClient(
    env.SUPABASE_URL,
    env.SUPABASE_SERVICE_ROLE_KEY
  );
}
```

#### 2.3 إنشاء Supabase Auth Middleware

```typescript
// src/middleware/supabaseAuthMiddleware.ts
// (راجع Section 5.2 للكود الكامل)

export async function supabaseAuthMiddleware(c: Context, next: Next) {
  // 1. Extract JWT
  // 2. Create userClient
  // 3. Verify with Supabase Auth
  // 4. Fetch profile
  // 5. Set context
  // 6. Continue
}
```

#### 2.4 إنشاء Auth Endpoints

```typescript
// src/endpoints/auth.ts
// POST /auth/register
// POST /auth/login (يضرب Supabase Auth ويرجع JWT)
// POST /auth/logout
// (راجع Section 5.3 للكود الكامل)
```

#### 2.5 اختبار Endpoints الجديدة

```bash
# Test Registration
curl -X POST https://worker.com/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"new@test.com","password":"pass123","full_name":"Test User"}'

# Test Login
curl -X POST https://worker.com/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"new@test.com","password":"pass123"}'

# Should return: {access_token, refresh_token, user}
```

**Status Check:**
- ✅ Supabase Auth endpoints تعمل
- ✅ JWT من Supabase يُصدر بنجاح
- ✅ النظام القديم لا يزال يعمل
- ⏳ Business endpoints لا تزال تستخدم Custom JWT

---

### المرحلة 3: تحديث RLS لدعم auth.uid()

**الهدف:** بناء RLS جديدة تعتمد على `auth.uid()` مع الإبقاء على التوافق المؤقت

#### 3.1 تحديث user_profiles Policies

```sql
-- Migration: 002_update_rls_for_supabase_auth.sql

-- Drop old policies
DROP POLICY IF EXISTS "users_view_own_profile" ON user_profiles;
DROP POLICY IF EXISTS "users_update_own_profile" ON user_profiles;

-- Create new policies supporting auth.uid()
CREATE POLICY "users_view_own_profile"
ON user_profiles
FOR SELECT
TO authenticated
USING (
  -- New system: id = auth.uid()
  id = auth.uid()
  OR
  -- Temporary backward compatibility: auth_user_id = auth.uid()
  auth_user_id = auth.uid()
  OR
  -- Old system (will be removed later): mbuy_user_id = auth.uid()
  -- Note: This won't work with Supabase JWT, but keeps old system working
  mbuy_user_id = auth.uid()
);

CREATE POLICY "users_update_own_profile"
ON user_profiles
FOR UPDATE
TO authenticated
USING (
  id = auth.uid()
  OR auth_user_id = auth.uid()
  OR mbuy_user_id = auth.uid()
)
WITH CHECK (
  id = auth.uid()
  OR auth_user_id = auth.uid()
  OR mbuy_user_id = auth.uid()
);

-- Public view merchants (unchanged)
CREATE POLICY "public_view_merchants"
ON user_profiles
FOR SELECT
TO anon, authenticated
USING (role = 'merchant');
```

#### 3.2 تحديث stores Policies

```sql
-- Drop old policies
DROP POLICY IF EXISTS "merchants_create_store" ON stores;
DROP POLICY IF EXISTS "users_view_own_stores" ON stores;
-- ... etc

-- Create new policies
CREATE POLICY "merchants_create_store"
ON stores
FOR INSERT
TO authenticated
WITH CHECK (
  owner_id = auth.uid()
  AND EXISTS (
    SELECT 1 FROM user_profiles
    WHERE id = auth.uid()
    AND role IN ('merchant', 'admin')
  )
);

-- (راجع Section 6.3 لجميع Policies)
```

#### 3.3 تحديث باقي الجداول

```sql
-- products, orders, order_items, reviews, etc.
-- (راجع Section 6 للـ Policies الكاملة)
```

**Status Check:**
- ✅ RLS policies تدعم `auth.uid()`
- ✅ Supabase Auth users يمكنهم الوصول لبياناتهم
- ✅ النظام القديم لا يزال يعمل (SERVICE_ROLE bypass)

---

### المرحلة 4: تحويل جميع مسارات Flutter لاستخدام Supabase Auth

**الهدف:** تحديث Flutter لاستخدام Supabase Auth عبر Worker فقط

#### 4.1 تحديث AuthService في Flutter

```dart
// lib/core/services/auth_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  
  // Register
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await _apiService.post('/auth/register', body: {
      'email': email,
      'password': password,
      'full_name': fullName,
    });
    
    if (response.statusCode == 201) {
      // Success - now login
      await login(email: email, password: password);
    } else {
      throw Exception('Registration failed');
    }
  }
  
  // Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post('/auth/login', body: {
      'email': email,
      'password': password,
    });
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Save Supabase JWT
      await _storage.write(
        key: 'access_token',
        value: data['access_token'],
      );
      
      await _storage.write(
        key: 'refresh_token',
        value: data['refresh_token'],
      );
      
      // Save user info
      await _storage.write(
        key: 'user_id',
        value: data['user']['id'],
      );
    } else {
      throw Exception('Login failed');
    }
  }
  
  // Logout
  Future<void> logout() async {
    await _apiService.post('/auth/logout');
    await _storage.deleteAll();
  }
  
  // Check if authenticated
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }
}
```

#### 4.2 تحديث ApiService

```dart
// lib/core/services/api_service.dart
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';

class ApiService {
  final String baseUrl = AppConfig.apiBaseUrl;  // Worker URL
  final http.Client _client = http.Client();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  
  Future<String?> _getToken() async {
    return await _storage.read(key: 'access_token');
  }
  
  Future<http.Response> post(String path, {Object? body}) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl$path');
    
    return await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body != null ? jsonEncode(body) : null,
    );
  }
  
  Future<http.Response> get(String path) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl$path');
    
    return await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }
  
  // put, delete, etc...
}
```

#### 4.3 حذف Custom JWT Logic

```bash
# Delete old auth files
rm lib/core/services/mbuy_auth_service.dart
rm lib/core/utils/jwt_utils.dart

# Update references in all files to use new AuthService
```

#### 4.4 اختبار التدفق الكامل

```dart
// Test
void testAuthFlow() async {
  final authService = AuthService();
  
  // 1. Register
  await authService.register(
    email: 'test@example.com',
    password: 'password123',
    fullName: 'Test User',
  );
  
  // 2. Login (automatically done after register)
  final isAuth = await authService.isAuthenticated();
  print('Authenticated: $isAuth'); // Should be true
  
  // 3. Make authenticated request
  final apiService = ApiService();
  final response = await apiService.get('/products');
  print('Products: ${response.body}');
  
  // 4. Logout
  await authService.logout();
}
```

**Status Check:**
- ✅ Flutter يستخدم Supabase Auth عبر Worker
- ✅ جميع Endpoints تعمل مع Supabase JWT
- ✅ RLS يتحقق من الصلاحيات تلقائياً
- ⏳ بعض المستخدمين قد يكونون على النظام القديم

---

### المرحلة 5: تنظيف النظام القديم

**الهدف:** إزالة كل ما يتعلق بـ Custom JWT و `mbuy_users` Auth

#### 5.1 Database Cleanup

```sql
-- Migration: 003_remove_old_auth_system.sql

-- 1. تأكد من أن جميع المستخدمين انتقلوا
SELECT COUNT(*) FROM user_profiles WHERE mbuy_user_id IS NOT NULL AND auth_user_id IS NULL;
-- يجب أن يكون 0

-- 2. حذف mbuy_user_id من user_profiles
ALTER TABLE user_profiles DROP COLUMN IF EXISTS mbuy_user_id;

-- 3. جعل auth_user_id NOT NULL (optional - لأن id = auth_user_id الآن)
-- ALTER TABLE user_profiles ALTER COLUMN auth_user_id SET NOT NULL;

-- 4. تبسيط RLS Policies (إزالة backward compatibility)
DROP POLICY IF EXISTS "users_view_own_profile" ON user_profiles;

CREATE POLICY "users_view_own_profile"
ON user_profiles
FOR SELECT
TO authenticated
USING (id = auth.uid());  -- ✅ بسيطة ونهائية

-- (كرر لجميع Policies)

-- 5. اختياري: حذف جدول mbuy_users إذا لم يعد له استخدام
-- DROP TABLE IF EXISTS mbuy_users CASCADE;
-- DROP TABLE IF EXISTS mbuy_sessions CASCADE;

-- أو الإبقاء عليه للبيانات التاريخية:
-- ALTER TABLE mbuy_users RENAME TO mbuy_users_legacy;
```

#### 5.2 Worker Cleanup

```bash
# حذف الملفات القديمة
rm src/middleware/mbuyAuthMiddleware.ts
rm src/utils/jwt.ts
rm src/endpoints/mbuyAuth.ts

# تحديث index.ts لإزالة المسارات القديمة
```

```typescript
// src/index.ts (final)
import { Hono } from 'hono';
import authRoutes from './endpoints/auth';        // ✅ Supabase Auth only
import productsRoutes from './endpoints/products';

const app = new Hono();

// Auth routes (Supabase Auth)
app.route('/auth', authRoutes);

// Business routes (all protected by supabaseAuthMiddleware)
app.route('/products', productsRoutes);
app.route('/stores', storesRoutes);
// ...

export default app;
```

#### 5.3 Environment Variables Cleanup

```toml
# wrangler.toml (final)
[vars]
SUPABASE_URL = "https://xxx.supabase.co"
SUPABASE_ANON_KEY = "eyJ..."              # ✅ Used
SUPABASE_SERVICE_ROLE_KEY = "eyJ..."     # ✅ Used (admin only)
# JWT_SECRET removed - no longer needed
```

#### 5.4 التحقق النهائي

```bash
# 1. Test all endpoints
curl -X POST https://worker.com/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"pass123"}'

TOKEN="<received_jwt>"

# 2. Test authenticated endpoint
curl -X GET https://worker.com/products \
  -H "Authorization: Bearer $TOKEN"

# 3. Test RLS is working
# Should only return user's own products, not others'

# 4. Test Flutter app end-to-end
flutter run
# Login → Create Product → View Products → Logout
```

**Status Check:**
- ✅ `mbuy_users` Auth محذوف/معطل
- ✅ Custom JWT محذوف
- ✅ Supabase Auth فقط
- ✅ RLS فعّال بالكامل
- ✅ Flutter → Worker → Supabase (Supabase Auth JWT)
- ✅ النظام نظيف ومبسط

---

### ملخص المراحل

| المرحلة | المدة | الحالة | الوصف |
|---------|------|--------|-------|
| **1** | 1 يوم | ⏳ Pending | إدخال auth.users وربطه مع user_profiles |
| **2** | 2 أيام | ⏳ Pending | تعديل Worker لدعم Supabase Auth JWT |
| **3** | 1 يوم | ⏳ Pending | تحديث RLS لدعم auth.uid() |
| **4** | 2 أيام | ⏳ Pending | تحويل Flutter لاستخدام Supabase Auth عبر Worker |
| **5** | 1 يوم | ⏳ Pending | تنظيف النظام القديم |
| **Total** | ~7 أيام | | Migration كامل |

### نقاط مهمة

**✅ الفوائد:**
- أمان أفضل (RLS فعّال)
- كود أقل وأبسط
- Best practices
- دعم OAuth/MFA مستقبلاً

**⚠️ المخاطر:**
- Breaking changes للمستخدمين الحاليين
- يحتاج migration للمستخدمين
- اختبار شامل مطلوب

**🔄 Rollback:**
- كل مرحلة قابلة للتراجع
- Backup قبل كل مرحلة
- النظام القديم يعمل حتى المرحلة 5

---

**آخر تحديث:** ديسمبر 2025  
**الحالة:** خطة جاهزة - بانتظار الموافقة للتنفيذ  
**التالي:** مراجعة الخطة → الموافقة → البدء بالمرحلة 1

---

## 1. ربط المستخدمين

> **📌 الحالة:** قيد Migration من Custom JWT إلى Supabase Auth

### 1.1 المعمارية الحالية (Current - سيتم تغييرها)

```
┌─────────────────┐
│  mbuy_users     │ ← نظام Auth المخصص (Custom JWT) - سيتم إزالته
│  - id (PK)      │
│  - email        │
│  - password_hash│
│  - full_name    │
│  - phone        │
│  - is_active    │
└────────┬────────┘
         │ 1:1
         │ FK: user_profiles.mbuy_user_id
         ↓
┌─────────────────┐
│ user_profiles   │ ← البروفايل التفصيلي
│  - id (PK)      │
│  - mbuy_user_id │ ← سيتم إزالته
│  - role         │ ← 'customer', 'merchant', 'admin'
│  - display_name │
│  - avatar_url   │
└─────────────────┘
```

### 1.2 المعمارية الهدف (Target - بعد Migration)

```
┌─────────────────┐
│  auth.users     │ ← Supabase Auth (Built-in)
│  - id (PK)      │
│  - email        │
│  - encrypted_pw │
│  - email_confirmed│
│  - raw_user_metadata│
└────────┬────────┘
         │ 1:1
         │ PK = PK
         ↓
┌─────────────────┐
│ user_profiles   │ ← البروفايل التفصيلي
│  - id (PK)      │ ← = auth.users.id (REFERENCES auth.users(id))
│  - role         │ ← 'customer', 'merchant', 'admin'
│  - display_name │
│  - avatar_url   │
└─────────────────┘
```

### 1.3 Source of Truth

#### الحالي (Current):
| الاستخدام | الحقل المستخدم | الجدول |
|-----------|----------------|---------|
| **JWT.sub** | `mbuy_users.id` | `mbuy_users` |
| **Profile ID** | `user_profiles.id` | `user_profiles` |
| **Store Owner** | `user_profiles.id` | `user_profiles` → `stores.owner_id` |
| **Auth Middleware** | `JWT.sub` → `mbuy_users.id` → `user_profiles.mbuy_user_id` | ربط بينهم |

#### الهدف (Target):
| الاستخدام | الحقل المستخدم | الجدول |
|-----------|----------------|---------|
| **JWT.sub** | `auth.users.id` | `auth.users` (Supabase) |
| **Profile ID** | `user_profiles.id` | `= auth.users.id` |
| **Store Owner** | `user_profiles.id` | `user_profiles` → `stores.owner_id` |
| **Auth Middleware** | `JWT.sub` = `auth.users.id` = `user_profiles.id` | ✅ مباشر بدون joins |

### 1.4 Auth System

#### ❌ الحالي (سيتم إزالته):
- نستخدم Custom JWT مع جدول `mbuy_users`
- Worker يولّد JWT ويوقّعه بـ `JWT_SECRET`
- `auth.uid()` في RLS **لا يعمل**

#### ✅ الهدف (بعد Migration):
- نستخدم Supabase Auth (`auth.users`)
- Supabase يولّد JWT تلقائياً
- `auth.uid()` في RLS **يعمل بشكل كامل**
- دعم OAuth, MFA, Email verification مدمج

### 1.5 الربط في Worker

#### الحالي (Custom JWT):
```typescript
// في authMiddleware.ts
const mbuyUserId = payload.sub;  // من JWT.sub

// جلب user_profiles.id
const profile = await supabase.findByColumn(
  'user_profiles', 
  'mbuy_user_id',  // ← الحقل في user_profiles
  mbuyUserId,      // ← القيمة من JWT
  'id, role'
);

c.set('userId', mbuyUserId);      // mbuy_users.id
c.set('profileId', profile.id);   // user_profiles.id ← يُستخدم في stores.owner_id
c.set('userRole', profile.role);  // customer, merchant, admin
```

#### الهدف (Supabase Auth):
```typescript
// في supabaseAuthMiddleware.ts
const userClient = createUserSupabaseClient(c.env, userJwt);

// Verify token with Supabase Auth
const { data: { user }, error } = await userClient.auth.getUser(token);

// جلب user_profile
const { data: profile } = await userClient
  .from('user_profiles')
  .select('id, role, display_name')
  .eq('id', user.id)  // ✅ مباشر: user_profiles.id = auth.users.id
  .single();

c.set('userId', user.id);          // auth.users.id
c.set('profileId', profile.id);    // = user.id (نفس القيمة)
c.set('userRole', profile.role);
c.set('userClient', userClient);   // ✅ RLS active
```

---

## 2. ربط التاجر والمتجر والمنتجات

### 2.1 المخطط الهيكلي

```
┌─────────────────┐
│ user_profiles   │
│  - id (PK)      │
│  - role         │ ← 'merchant' للتجار
└────────┬────────┘
         │ 1:N
         │ FK: stores.owner_id
         ↓
┌─────────────────┐
│ stores          │
│  - id (PK)      │
│  - owner_id     │ ← REFERENCES user_profiles(id) ON DELETE CASCADE
│  - name         │
│  - status       │ ← 'active', 'inactive', 'suspended'
│  - is_active    │ ← BOOLEAN (deprecated, use status)
└────────┬────────┘
         │ 1:N
         │ FK: products.store_id
         ↓
┌─────────────────┐
│ products        │
│  - id (PK)      │
│  - store_id     │ ← REFERENCES stores(id) ON DELETE CASCADE
│  - name         │
│  - price        │
│  - stock        │
│  - status       │ ← 'active', 'draft', 'archived'
└─────────────────┘
```

### 2.2 العلاقات والقيود

#### `stores` Table

```sql
CREATE TABLE public.stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
  is_active BOOLEAN DEFAULT true,  -- ⚠️ Deprecated, استخدم status
  -- ... باقي الأعمدة
);
```

**Foreign Key:**
- `owner_id` → `user_profiles(id)`
- `NOT NULL` ✅
- `ON DELETE CASCADE` ✅

#### `products` Table

```sql
CREATE TABLE public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
  category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  price DECIMAL(12, 2) NOT NULL,
  stock INTEGER DEFAULT 0,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'draft', 'archived')),
  is_active BOOLEAN DEFAULT true,  -- ⚠️ Legacy field
  -- ... باقي الأعمدة
);
```

**Foreign Key:**
- `store_id` → `stores(id)`
- `NOT NULL` ✅ (منذ Migration 20250108)
- `ON DELETE CASCADE` ✅

### 2.3 منطق إنشاء المنتج في Worker

```typescript
// في endpoints/products.ts - createProduct()

// 1. استخراج profileId من JWT
const { profileId } = await extractAuthContext(c);

// 2. التحقق من دور المستخدم
if (authContext.role !== 'merchant' && authContext.role !== 'admin') {
  return c.json({ error: 'forbidden' }, 403);
}

// 3. جلب المتجر من user_profiles.id
const store = await supabase.findByColumn('stores', 'owner_id', profileId);

if (!store) {
  return c.json({ error: 'no_store' }, 400);
}

// 4. إضافة store_id تلقائياً
const productData = {
  store_id: store.id,  // ← يُضاف من Worker
  name: body.name,
  price: body.price,
  // ...
};

// 5. إدراج في قاعدة البيانات
await supabase.insert('products', productData);
```

**⚠️ مهم:**
- Flutter **لا يرسل** `store_id` في Request Body
- Worker **يضيفه تلقائياً** بناءً على JWT

---

## 3. طريقة الاتصال

> **📌 الحالة:** في طور التحديث من Custom JWT إلى Supabase Auth

### 3.1 Flutter ↔ Backend

#### الحالي (Custom JWT):
```dart
// في api_service.dart
class ApiService {
  final String baseUrl = AppConfig.apiBaseUrl; // Cloudflare Worker URL
  
  Future<http.Response> post(String path, {Object? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _withAuthHeaders(headers);
    
    return await http.post(uri, headers: headers, body: jsonEncode(body));
  }
}
```

**✅ الواقع الحالي:**
- Flutter يتكلم **فقط** مع Cloudflare Worker
- لا يوجد استيراد لـ `supabase_flutter` في `pubspec.yaml`
- لا يوجد `Supabase.instance` في أي ملف Dart

#### الهدف (Supabase Auth):
```dart
// في api_service.dart
class ApiService {
  final _supabase = Supabase.instance.client;
  
  // Direct Supabase queries (RLS protected)
  Future<List<Product>> getProducts() async {
    final response = await _supabase
      .from('products')
      .select('*, stores(*)')
      .eq('status', 'active');
    
    return response.map((json) => Product.fromJson(json)).toList();
  }
  
  // Worker for complex operations (optional)
  Future<void> complexOperation() async {
    final token = _supabase.auth.currentSession?.accessToken;
    
    await http.post(
      Uri.parse('${AppConfig.workerUrl}/complex-operation'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
```

**✅ الهدف:**
- Flutter يتصل مباشرة بـ Supabase (للعمليات البسيطة)
- Flutter → Worker (للعمليات المعقدة فقط)
- استخدام `supabase_flutter` SDK
- RLS يحمي البيانات تلقائياً

### 3.2 Worker → Supabase

#### الحالي (SERVICE_ROLE فقط):
```typescript
// في utils/supabase.ts
export function createSupabaseClient(env: Env) {
  const serviceRoleKey = env.SUPABASE_SERVICE_ROLE_KEY;
  
  return {
    url: supabaseUrl,
    key: serviceRoleKey,  // ← Service Role Key (bypasses RLS)
    
    async query(table: string, options: {...}) {
      const headers = {
        'apikey': serviceRoleKey,
        'Authorization': `Bearer ${serviceRoleKey}`,
        'Content-Type': 'application/json',
      };
      
      const response = await fetch(`${supabaseUrl}/rest/v1/${table}`, {
        method,
        headers,
        body: JSON.stringify(body),
      });
      
      return response.json();
    }
  };
}
```

**✅ الواقع الحالي:**
- Worker يستخدم `SERVICE_ROLE_KEY` فقط
- Worker يتجاوز RLS تلقائياً
- Worker يتحقق من الصلاحيات **يدوياً** في الكود

#### الهدف (Dual Client):
```typescript
// User Client - للعمليات العادية
export function createUserSupabaseClient(env: Env, userJwt: string) {
  return createClient(
    env.SUPABASE_URL,
    env.SUPABASE_ANON_KEY,  // ← ANON_KEY (RLS active)
    {
      global: {
        headers: { Authorization: `Bearer ${userJwt}` }
      }
    }
  );
}

// Admin Client - للعمليات الإدارية فقط
export function createAdminSupabaseClient(env: Env) {
  return createClient(
    env.SUPABASE_URL,
    env.SUPABASE_SERVICE_ROLE_KEY,  // ← SERVICE_ROLE (bypasses RLS)
  );
}
```

**✅ الهدف:**
- `userClient`: ANON_KEY + User JWT (RLS فعّال) - للمستخدمين
- `adminClient`: SERVICE_ROLE_KEY (bypasses RLS) - للـ admin operations فقط
- RLS يتحقق تلقائياً من الصلاحيات

### 3.3 مفاتيح Supabase

#### الحالي:
```typescript
export interface Env {
  SUPABASE_URL: string;
  SUPABASE_ANON_KEY: string;              // ✅ موجود لكن غير مستخدم
  SUPABASE_SERVICE_ROLE_KEY: string;      // ✅ مستخدم في جميع العمليات
  JWT_SECRET: string;                     // ✅ للتحقق من Custom JWT
}
```

**الاستخدام الحالي:**
- `SERVICE_ROLE_KEY` - **جميع** عمليات Worker → Supabase
- `ANON_KEY` - غير مستخدم
- `JWT_SECRET` - للتحقق من Custom JWT

#### الهدف:
```typescript
export interface Env {
  SUPABASE_URL: string;
  SUPABASE_ANON_KEY: string;              // ✅ للعمليات العادية (RLS active)
  SUPABASE_SERVICE_ROLE_KEY: string;      // ✅ للعمليات الإدارية فقط
  // JWT_SECRET محذوف - لم نعد نحتاجه
}
```

**الاستخدام المستهدف:**
- `ANON_KEY` - للمستخدمين (مع User JWT من Supabase Auth)
- `SERVICE_ROLE_KEY` - للـ admin endpoints فقط (cron jobs, admin panel)

---

## 4. RLS Policies

> **📌 الحالة:** Policies موجودة لكن غير فعّالة (Worker يستخدم SERVICE_ROLE)  
> **🎯 الهدف:** RLS فعّال بالكامل بعد Migration لـ Supabase Auth

### 4.1 تفعيل RLS

```sql
-- جميع الجداول الرئيسية عليها RLS مفعّل
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
```

**⚠️ الحالة الحالية:**
- RLS مفعّل ✅
- Policies موجودة ✅
- لكن Worker يستخدم SERVICE_ROLE_KEY فيتجاوز RLS ❌

**✅ الهدف بعد Migration:**
- RLS مفعّل ✅
- Policies موجودة ✅
- Worker يستخدم ANON_KEY + User JWT ✅
- RLS فعّال ويتحقق من الصلاحيات ✅

### 4.2 user_profiles Policies

#### الحالي (Custom JWT - غير فعّال):
```sql
-- المستخدمون يمكنهم قراءة بروفايلهم فقط
CREATE POLICY "users_view_own_profile"
ON user_profiles
FOR SELECT
TO authenticated
USING (mbuy_user_id = auth.uid());  -- ❌ auth.uid() لا يعمل مع Custom JWT

-- المستخدمون يمكنهم تعديل بروفايلهم فقط
CREATE POLICY "users_update_own_profile"
ON user_profiles
FOR UPDATE
TO authenticated
USING (mbuy_user_id = auth.uid())  -- ❌ auth.uid() لا يعمل
WITH CHECK (mbuy_user_id = auth.uid());

-- الجميع يمكنهم رؤية بروفايلات التجار
CREATE POLICY "public_view_merchant_profiles"
ON user_profiles
FOR SELECT
TO anon, authenticated
USING (role = 'merchant');
```

**⚠️ المشكلة:** `auth.uid()` يعيد `NULL` مع Custom JWT

#### الهدف (Supabase Auth - فعّال):
```sql
-- المستخدمون يمكنهم قراءة بروفايلهم فقط
CREATE POLICY "users_view_own_profile"
ON user_profiles
FOR SELECT
TO authenticated
USING (id = auth.uid());  -- ✅ يعمل: user_profiles.id = auth.users.id

-- المستخدمون يمكنهم تعديل بروفايلهم فقط
CREATE POLICY "users_update_own_profile"
ON user_profiles
FOR UPDATE
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- الجميع يمكنهم رؤية بروفايلات التجار
CREATE POLICY "public_view_merchant_profiles"
ON user_profiles
FOR SELECT
TO anon, authenticated
USING (role = 'merchant');
```

**✅ الحل:** `auth.uid()` يعيد `auth.users.id` الصحيح

### 4.3 stores Policies

```sql
-- التجار يمكنهم إنشاء متاجر
CREATE POLICY "merchants_insert_store"
ON stores
FOR INSERT
TO authenticated
WITH CHECK (
  owner_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid() 
    AND role IN ('merchant', 'admin')
  )
);

-- التجار يمكنهم قراءة متاجرهم
CREATE POLICY "merchants_view_own_store"
ON stores
FOR SELECT
TO authenticated
USING (
  owner_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- التجار يمكنهم تعديل متاجرهم
CREATE POLICY "merchants_update_own_store"
ON stores
FOR UPDATE
TO authenticated
USING (
  owner_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
)
WITH CHECK (
  owner_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- التجار يمكنهم حذف متاجرهم
CREATE POLICY "merchants_delete_own_store"
ON stores
FOR DELETE
TO authenticated
USING (
  owner_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- الجميع يمكنهم رؤية المتاجر النشطة
CREATE POLICY "public_view_active_stores"
ON stores
FOR SELECT
TO anon, authenticated
USING (status = 'active');
```

### 4.4 products Policies

```sql
-- التجار يمكنهم إضافة منتجات في متاجرهم
CREATE POLICY "merchants_insert_own_products"
ON products
FOR INSERT
TO authenticated
WITH CHECK (
  store_id IN (
    SELECT s.id 
    FROM stores s
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);

-- التجار يمكنهم قراءة منتجاتهم
CREATE POLICY "merchants_select_own_products"
ON products
FOR SELECT
TO authenticated
USING (
  store_id IN (
    SELECT s.id 
    FROM stores s
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);

-- التجار يمكنهم تعديل منتجاتهم
CREATE POLICY "merchants_update_own_products"
ON products
FOR UPDATE
TO authenticated
USING (
  store_id IN (
    SELECT s.id 
    FROM stores s
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
)
WITH CHECK (
  store_id IN (
    SELECT s.id 
    FROM stores s
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);

-- التجار يمكنهم حذف منتجاتهم
CREATE POLICY "merchants_delete_own_products"
ON products
FOR DELETE
TO authenticated
USING (
  store_id IN (
    SELECT s.id 
    FROM stores s
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);

-- الجميع يمكنهم رؤية المنتجات النشطة
CREATE POLICY "public_select_active_products"
ON products
FOR SELECT
TO anon, authenticated
USING (status = 'active' OR is_active = true);
```

### 4.5 product_media Policies

```sql
-- التجار يمكنهم إدارة وسائط منتجاتهم
CREATE POLICY "merchants_manage_product_media"
ON product_media
FOR ALL
TO authenticated
USING (
  product_id IN (
    SELECT p.id 
    FROM products p
    INNER JOIN stores s ON p.store_id = s.id
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
)
WITH CHECK (
  product_id IN (
    SELECT p.id 
    FROM products p
    INNER JOIN stores s ON p.store_id = s.id
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);

-- الجميع يمكنهم رؤية وسائط المنتجات النشطة
CREATE POLICY "public_view_product_media"
ON product_media
FOR SELECT
TO anon, authenticated
USING (
  product_id IN (
    SELECT id FROM products 
    WHERE status = 'active' OR is_active = true
  )
);
```

### 4.6 categories Policies

```sql
-- الجميع يمكنهم قراءة التصنيفات
CREATE POLICY "public_view_categories"
ON categories
FOR SELECT
TO anon, authenticated
USING (true);

-- ملاحظة: إدارة التصنيفات تتم عبر Worker فقط (SERVICE_ROLE)
```

### 4.7 orders & order_items Policies

```sql
-- المستخدمون يمكنهم إنشاء طلبات
CREATE POLICY "users_create_orders"
ON orders
FOR INSERT
TO authenticated
WITH CHECK (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- المستخدمون يمكنهم قراءة طلباتهم
CREATE POLICY "users_view_own_orders"
ON orders
FOR SELECT
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- التجار يمكنهم قراءة طلبات متاجرهم
CREATE POLICY "merchants_view_store_orders"
ON orders
FOR SELECT
TO authenticated
USING (
  store_id IN (
    SELECT s.id 
    FROM stores s
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);

-- المستخدمون يمكنهم تعديل طلباتهم
CREATE POLICY "users_update_own_orders"
ON orders
FOR UPDATE
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
)
WITH CHECK (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- المستخدمون يمكنهم قراءة عناصر طلباتهم
CREATE POLICY "users_view_own_order_items"
ON order_items
FOR SELECT
TO authenticated
USING (
  order_id IN (
    SELECT o.id 
    FROM orders o
    INNER JOIN user_profiles up ON o.user_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);

-- التجار يمكنهم قراءة عناصر طلبات متاجرهم
CREATE POLICY "merchants_view_store_order_items"
ON order_items
FOR SELECT
TO authenticated
USING (
  order_id IN (
    SELECT o.id 
    FROM orders o
    INNER JOIN stores s ON o.store_id = s.id
    INNER JOIN user_profiles up ON s.owner_id = up.id
    WHERE up.mbuy_user_id = auth.uid()
  )
);
```

### 4.8 reviews Policies

```sql
-- المستخدمون يمكنهم إنشاء تقييمات
CREATE POLICY "users_create_reviews"
ON reviews
FOR INSERT
TO authenticated
WITH CHECK (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- المستخدمون يمكنهم تعديل تقييماتهم
CREATE POLICY "users_update_own_reviews"
ON reviews
FOR UPDATE
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
)
WITH CHECK (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- المستخدمون يمكنهم حذف تقييماتهم
CREATE POLICY "users_delete_own_reviews"
ON reviews
FOR DELETE
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- الجميع يمكنهم قراءة التقييمات
CREATE POLICY "public_view_reviews"
ON reviews
FOR SELECT
TO anon, authenticated
USING (true);
```

### 4.9 wallets & transactions Policies

```sql
-- المستخدمون يمكنهم قراءة محفظتهم فقط
CREATE POLICY "users_view_own_wallet"
ON wallets
FOR SELECT
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- المستخدمون يمكنهم قراءة معاملاتهم فقط
CREATE POLICY "users_view_own_transactions"
ON transactions
FOR SELECT
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);
```

### 4.10 notifications Policies

```sql
-- المستخدمون يمكنهم قراءة إشعاراتهم فقط
CREATE POLICY "users_view_own_notifications"
ON notifications
FOR SELECT
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);

-- المستخدمون يمكنهم تعديل إشعاراتهم (تحديث حالة القراءة)
CREATE POLICY "users_update_own_notifications"
ON notifications
FOR UPDATE
TO authenticated
USING (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
)
WITH CHECK (
  user_id IN (
    SELECT id FROM user_profiles 
    WHERE mbuy_user_id = auth.uid()
  )
);
```

---

## 5. ملاحظات مهمة

### 5.1 Custom JWT System

**البنية:**
```json
{
  "sub": "mbuy_users.id (UUID)",
  "email": "user@example.com",
  "type": "access_token",
  "iat": 1234567890,
  "exp": 1234567890
}
```

**⚠️ التحذيرات:**
- JWT **ليس** متوافق مع Supabase Auth
- `auth.uid()` في RLS يتوقع Supabase-issued JWT
- حالياً: Worker يستخدم `SERVICE_ROLE_KEY` ويتجاوز RLS

**✅ الحل الحالي:**
- Worker يتحقق من الصلاحيات يدوياً في الكود
- RLS Policies موجودة للحماية الإضافية فقط
- في حالة استخدام `ANON_KEY` مستقبلاً، يجب تحويل JWT إلى صيغة متوافقة

### 5.2 SERVICE_ROLE_KEY vs ANON_KEY

| الخاصية | SERVICE_ROLE_KEY | ANON_KEY |
|---------|------------------|----------|
| **الاستخدام الحالي** | ✅ مستخدم في جميع عمليات Worker | ❌ غير مستخدم (موجود في Env فقط) |
| **RLS** | يتجاوز جميع Policies | يخضع لـ RLS Policies |
| **الصلاحيات** | Full access | محدود حسب Policies |
| **التحقق اليدوي** | ✅ مطلوب في Worker | ❌ RLS يتحقق تلقائياً |
| **JWT** | لا يحتاج JWT للـ PostgREST | يحتاج JWT متوافق مع Supabase Auth |

### 5.3 مشاكل معروفة

#### 5.3.1 JWT Incompatibility

**المشكلة:**
```
PGRST301: No suitable key or wrong key type
```

**السبب:**
- Custom JWT من `mbuy_users` ليس بصيغة Supabase Auth
- `auth.uid()` في RLS لا يستطيع قراءة Custom JWT

**الحل الحالي:**
- استخدام `SERVICE_ROLE_KEY` في Worker
- تجاوز RLS
- التحقق اليدوي من الصلاحيات في الكود

**الحل المستقبلي (اختياري):**
1. **Supabase Auth Migration:** تحويل `mbuy_users` إلى `auth.users`
2. **JWT Transformation:** إنشاء Supabase-compatible JWT من Custom JWT
3. **Edge Function:** استخدام Supabase Edge Function بدلاً من Cloudflare Worker

#### 5.3.2 Legacy Fields

**الحقول القديمة:**
- `stores.is_active` → استخدم `stores.status` ('active', 'inactive', 'suspended')
- `products.is_active` → استخدم `products.status` ('active', 'draft', 'archived')

**⚠️ حالياً:** Worker يتحقق من `stores.status` فقط

### 5.4 Worker Endpoints

**الـ Endpoints المحمية بـ `mbuyAuthMiddleware`:**
```
POST   /secure/products          - Create Product
GET    /secure/products          - List Merchant Products
PUT    /secure/products/:id      - Update Product
DELETE /secure/products/:id      - Delete Product
GET    /secure/store             - Get Merchant Store
POST   /secure/store             - Create Store
PUT    /secure/store             - Update Store
```

**التدفق:**
1. Flutter يرسل `Authorization: Bearer <JWT>`
2. `mbuyAuthMiddleware` يتحقق من JWT
3. يستخرج `userId` (mbuy_users.id) من `JWT.sub`
4. يجلب `profileId` (user_profiles.id) من `mbuy_user_id`
5. يضع `userId`, `profileId`, `userRole` في Context
6. Endpoint يستخدم `profileId` للتحقق من الملكية

### 5.5 Database Migrations

**الترتيب الزمني (أحدث أولاً):**

```
20250109000003_unify_user_profiles_with_mbuy_users.sql
  ↓ جعل mbuy_user_id NOT NULL و UNIQUE
  
20250109000001_add_unique_constraint_user_profiles.sql
  ↓ إضافة UNIQUE constraint على mbuy_user_id
  
20250108000003_create_tables_and_columns.sql
  ↓ إنشاء جميع الجداول الأساسية
  
20251206201515_create_mbuy_auth_tables.sql
  ↓ إنشاء mbuy_users و mbuy_sessions
  
20250106000006_fix_user_profiles_and_stores.sql
  ↓ إصلاح العلاقات بين الجداول
```

**الحالة الحالية:**
- ✅ `mbuy_users` موجود ونشط
- ✅ `user_profiles.mbuy_user_id` NOT NULL + UNIQUE + FK
- ✅ `stores.owner_id` → `user_profiles(id)` NOT NULL + FK
- ✅ `products.store_id` → `stores(id)` NOT NULL + FK
- ✅ جميع Cascades مضبوطة

### 5.6 Flutter App Structure

```
lib/
  core/
    services/
      api_service.dart          ← HTTP client (http package)
  features/
    products/
      data/
        products_repository.dart  ← يستخدم ApiService فقط
```

**✅ الواقع:**
- لا يوجد `supabase_flutter` في `pubspec.yaml`
- لا يوجد `Supabase.instance` في أي ملف
- جميع الطلبات تمر عبر `ApiService` → Cloudflare Worker

### 5.7 Testing Commands

**فحص الربط بين الجداول:**
```sql
-- فحص user → profile → store → product
SELECT 
  mu.id as mbuy_user_id,
  mu.email,
  up.id as profile_id,
  up.role,
  s.id as store_id,
  s.name as store_name,
  s.status as store_status,
  COUNT(p.id) as products_count
FROM mbuy_users mu
LEFT JOIN user_profiles up ON mu.id = up.mbuy_user_id
LEFT JOIN stores s ON up.id = s.owner_id
LEFT JOIN products p ON s.id = p.store_id
WHERE mu.email = 'merchant@example.com'
GROUP BY mu.id, up.id, s.id;
```

**فحص RLS Policies:**
```sql
-- عرض جميع Policies
SELECT 
  tablename,
  policyname,
  cmd,
  roles,
  permissive
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, cmd, policyname;
```

---

## 📌 خلاصة سريعة

### البنية العامة

```
Flutter App (Dart)
  ↓ HTTP (Bearer JWT)
  ↓
Cloudflare Worker (TypeScript)
  ↓ SERVICE_ROLE_KEY
  ↓
Supabase PostgreSQL
  ├─ mbuy_users (Custom Auth)
  ├─ user_profiles (Profiles)
  ├─ stores (Merchants)
  └─ products (Items)
```

### المفاتيح الأساسية

- **JWT:** Custom من `mbuy_users`, موقّع بـ `JWT_SECRET`
- **Worker Key:** `SERVICE_ROLE_KEY` (يتجاوز RLS)
- **Profile ID:** `user_profiles.id` (يُستخدم في `stores.owner_id`)
- **Store ID:** يُضاف تلقائياً من Worker في `products.store_id`

### القواعد الصارمة

1. ✅ **لا اتصال مباشر** بين Flutter و Supabase
2. ✅ **Worker هو الوسيط الوحيد** بين Flutter و Database
3. ✅ **Custom JWT** من `mbuy_users` (ليس Supabase Auth)
4. ✅ **RLS موجود** لكن Worker يتجاوزه بـ `SERVICE_ROLE_KEY`
5. ✅ **التحقق اليدوي** من الصلاحيات في Worker code

---

**آخر تحديث:** ديسمبر 2025  
**المرجع:** هذا الملف هو المصدر الوحيد للحقيقة (Single Source of Truth)  
**خطة Migration:** راجع `SUPABASE_AUTH_MIGRATION_PLAN.md` للتفاصيل الكاملة

---

## 6. المعمارية الهدف (Target)

> **🎯 هذا القسم يصف المعمارية النهائية بعد اكتمال Migration إلى Supabase Auth**

### 6.1 النظرة الشاملة

```
┌─────────────────────────────┐
│      Flutter App            │
│   + supabase_flutter SDK    │
│                             │
│  Supabase.instance.client   │
└──────────────┬──────────────┘
               │
               ├─────────────────────────────┐
               │                             │
               ↓                             ↓
    ┌──────────────────┐          ┌──────────────────┐
    │  Supabase Auth   │          │ Cloudflare Worker│
    │  (auth.users)    │          │   (Optional)     │
    │                  │          │                  │
    │  - signUp        │          │  - userClient    │
    │  - signIn        │          │  - adminClient   │
    │  - JWT issuer    │          │                  │
    └────────┬─────────┘          └────────┬─────────┘
             │                             │
             │  Supabase JWT               │
             │  + ANON_KEY                 │
             └─────────┬───────────────────┘
                       │
                       ↓
            ┌──────────────────────┐
            │ Supabase PostgreSQL  │
            │                      │
            │ • auth.users         │ ← Supabase Built-in
            │ • user_profiles      │ ← id = auth.users.id
            │ • stores             │
            │ • products           │
            │ • ...                │
            │                      │
            │ RLS: ✅ Active       │
            │ auth.uid(): ✅ Works │
            └──────────────────────┘
```

### 6.2 Auth Flow (النهائي)

**1. Registration (التسجيل):**
```dart
// Flutter
await Supabase.instance.client.auth.signUp(
  email: 'user@example.com',
  password: 'password123',
  data: {'full_name': 'User Name'},
);

// PostgreSQL (Trigger automatic)
// → auth.users record created
// → user_profiles record created (via handle_new_auth_user trigger)
```

**2. Login (تسجيل الدخول):**
```dart
// Flutter
final response = await Supabase.instance.client.auth.signInWithPassword(
  email: 'user@example.com',
  password: 'password123',
);

// Returns:
// - JWT token (stored automatically)
// - User object
// - Session object
```

**3. Authenticated Request:**
```dart
// Flutter → Direct Supabase (Simple queries)
final products = await Supabase.instance.client
  .from('products')
  .select('*, stores(*)')
  .eq('status', 'active');
// RLS automatically checks permissions

// Flutter → Worker (Complex operations)
final token = Supabase.instance.client.auth.currentSession?.accessToken;
await http.post(
  Uri.parse('https://worker.com/complex-operation'),
  headers: {'Authorization': 'Bearer $token'},
);
```

### 6.3 Database Schema (النهائي)

```sql
-- auth.users (Supabase Built-in)
-- لا نعدّل هذا الجدول مباشرة

-- user_profiles (Custom)
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'customer' 
    CHECK (role IN ('customer', 'merchant', 'admin')),
  avatar_url TEXT,
  phone TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- stores (unchanged structure)
CREATE TABLE stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  status TEXT DEFAULT 'active',
  -- ...
);

-- products (unchanged structure)
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  price DECIMAL(12, 2) NOT NULL,
  -- ...
);
```

### 6.4 RLS Policies (النهائي)

**user_profiles:**
```sql
-- ✅ auth.uid() يعمل بشكل كامل
CREATE POLICY "users_view_own_profile" ON user_profiles
FOR SELECT TO authenticated
USING (id = auth.uid());

CREATE POLICY "users_update_own_profile" ON user_profiles
FOR UPDATE TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

CREATE POLICY "public_view_merchants" ON user_profiles
FOR SELECT TO anon, authenticated
USING (role = 'merchant');
```

**stores:**
```sql
-- Merchants can manage their stores
CREATE POLICY "merchants_manage_stores" ON stores
FOR ALL TO authenticated
USING (owner_id = auth.uid())
WITH CHECK (owner_id = auth.uid());

-- Public can view active stores
CREATE POLICY "public_view_active_stores" ON stores
FOR SELECT TO anon, authenticated
USING (status = 'active');
```

**products:**
```sql
-- Merchants can manage their products
CREATE POLICY "merchants_manage_products" ON products
FOR ALL TO authenticated
USING (
  store_id IN (
    SELECT id FROM stores WHERE owner_id = auth.uid()
  )
)
WITH CHECK (
  store_id IN (
    SELECT id FROM stores WHERE owner_id = auth.uid()
  )
);

-- Public can view active products
CREATE POLICY "public_view_products" ON products
FOR SELECT TO anon, authenticated
USING (status = 'active');
```

### 6.5 Worker Structure (النهائي)

```typescript
// src/utils/supabaseUser.ts
export function createUserSupabaseClient(env: Env, userJwt: string) {
  return createClient(
    env.SUPABASE_URL,
    env.SUPABASE_ANON_KEY,  // ✅ RLS active
    {
      global: {
        headers: { Authorization: `Bearer ${userJwt}` }
      }
    }
  );
}

// src/utils/supabaseAdmin.ts
export function createAdminSupabaseClient(env: Env) {
  return createClient(
    env.SUPABASE_URL,
    env.SUPABASE_SERVICE_ROLE_KEY,  // ✅ Bypasses RLS
  );
}

// src/middleware/authMiddleware.ts
export async function authMiddleware(c: Context, next: Next) {
  const token = extractToken(c);
  const userClient = createUserSupabaseClient(c.env, token);
  
  const { data: { user }, error } = await userClient.auth.getUser(token);
  if (error) return c.json({ error: 'unauthorized' }, 401);
  
  const { data: profile } = await userClient
    .from('user_profiles')
    .select('id, role')
    .eq('id', user.id)
    .single();
  
  c.set('userId', user.id);
  c.set('userRole', profile.role);
  c.set('userClient', userClient);
  
  await next();
}

// src/endpoints/products.ts
app.post('/products', authMiddleware, async (c) => {
  const userClient = c.get('userClient');  // ✅ RLS active
  const userId = c.get('userId');
  
  // Get store (RLS checks ownership)
  const { data: store } = await userClient
    .from('stores')
    .select('id')
    .eq('owner_id', userId)
    .single();
  
  // Create product (RLS checks ownership)
  const { data, error } = await userClient
    .from('products')
    .insert({ store_id: store.id, ...body })
    .select()
    .single();
  
  return c.json({ product: data });
});
```

### 6.6 Flutter Structure (النهائي)

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://xxx.supabase.co',
    anonKey: 'your-anon-key',
  );
  
  runApp(MyApp());
}

// lib/core/services/auth_service.dart
class AuthService {
  final _supabase = Supabase.instance.client;
  
  Future<void> signUp(String email, String password, String fullName) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }
  
  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
  
  User? get currentUser => _supabase.auth.currentUser;
  
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}

// lib/core/services/products_service.dart
class ProductsService {
  final _supabase = Supabase.instance.client;
  
  Future<List<Product>> getProducts() async {
    final response = await _supabase
      .from('products')
      .select('*, stores(*)') 
      .eq('status', 'active');
    
    return response.map((json) => Product.fromJson(json)).toList();
  }
  
  Future<Product> createProduct(Product product) async {
    final response = await _supabase
      .from('products')
      .insert(product.toJson())
      .select()
      .single();
    
    return Product.fromJson(response);
  }
}
```

### 6.7 الفوائد النهائية

**الأمان:**
- ✅ RLS فعّال على جميع الجداول
- ✅ `auth.uid()` يعمل بشكل صحيح
- ✅ تحقق تلقائي من الصلاحيات
- ✅ لا حاجة للتحقق اليدوي في الكود

**الوظائف:**
- ✅ OAuth (Google, Apple, GitHub, etc.)
- ✅ Multi-Factor Authentication (MFA)
- ✅ Email verification
- ✅ Password reset
- ✅ Realtime subscriptions
- ✅ Presence (online/offline status)

**التطوير:**
- ✅ أقل Custom code
- ✅ أسهل في الصيانة
- ✅ Best practices
- ✅ Community support
- ✅ Built-in features

**الأداء:**
- ✅ Worker → Supabase with proper RLS
- ✅ Worker للعمليات المعقدة والـ business logic
- ✅ Indexes محسّنة
- ✅ Connection pooling

---

## 7. Legacy Tables - للمرجعية فقط

> **⚠️ تحذير:** هذا القسم للمرجعية فقط. لا تستخدم هذه الجداول في أي كود جديد.

### 7.1 الجداول القديمة (غير مستخدمة)

#### `mbuy_users` - ⚠️ Legacy - لا يُستخدم

**الحالة:** موجود في قاعدة البيانات للبيانات القديمة فقط

**الاستخدام الممنوع:**
- ❌ لا يُستخدم كمصدر هوية
- ❌ لا يُستخدم في Auth
- ❌ لا يُستخدم في RLS Policies
- ❌ لا Custom JWT منه

**الخطة المستقبلية:**
- سيتم أرشفته بعد ترحيل جميع البيانات
- سيتم حذفه بعد 3-6 أشهر من الأرشفة

#### `mbuy_sessions` - ⚠️ Legacy - لا يُستخدم

**الحالة:** موجود في قاعدة البيانات للبيانات القديمة فقط

**الاستخدام الممنوع:**
- ❌ لا يُستخدم لإدارة الجلسات
- ❌ Supabase Auth يدير الجلسات

**الخطة المستقبلية:**
- سيتم أرشفته بعد ترحيل جميع البيانات
- سيتم حذفه مع `mbuy_users`

#### `profiles` - ❌ لا يوجد

**الملاحظة:** هذا الجدول لم يكن موجوداً أساساً. نستخدم `user_profiles`.

#### `merchants` - ❌ لا يوجد

**الملاحظة:** لا نستخدم جدول منفصل للـ merchants. نستخدم `user_profiles.role = 'merchant'`.

### 7.2 الحقول القديمة في `user_profiles`

#### `mbuy_user_id` - ⚠️ Legacy Column

**الحالة:** موجود في `user_profiles` للتوافقية فقط

```sql
ALTER TABLE user_profiles
DROP COLUMN mbuy_user_id;  -- سيتم لاحقاً
```

**الاستخدام الممنوع:**
- ❌ لا يُستخدم في أي queries جديدة
- ❌ لا يُستخدم في RLS
- ❌ nullable فقط

**المسار الصحيح:**
```
auth.users.id → user_profiles.auth_user_id (المستخدم حالياً)
```

### 7.3 الملفات المحذوفة من Worker

**تم حذف الملفات التالية نهائياً:**

1. ❌ `mbuy-worker/src/endpoints/auth.ts`
   - Custom JWT Auth system
   - registerHandler, loginHandler, meHandler, logoutHandler, refreshHandler
   - كان يستخدم `mbuy_users` و `mbuy_sessions`

2. ❌ `mbuy-worker/src/middleware/authMiddleware.ts`
   - Legacy auth middleware
   - كان يتحقق من Custom JWT

3. ❌ `mbuy-worker/src/middleware/roleMiddleware.ts`
   - Legacy role checking
   - كان يعتمد على `mbuy_users`

4. ❌ `mbuy-worker/src/utils/jwtHelper.ts`
   - Custom JWT generation utilities
   - كان ينشئ JWT من `mbuy_users`

5. ❌ `mbuy-worker/src/utils/userMapping.ts`
   - Mapping between mbuy_users.id and user_profiles.id
   - لم يعد ضرورياً

**الملفات المستخدمة حالياً:**
- ✅ `mbuy-worker/src/endpoints/supabaseAuth.ts` - Supabase Auth handlers
- ✅ `mbuy-worker/src/middleware/supabaseAuthMiddleware.ts` - JWT verification

### 7.4 قاعدة بسيطة

```
إذا رأيت في أي كود:
- mbuy_users → ❌ خطأ، استخدم auth.users → user_profiles
- mbuy_sessions → ❌ خطأ، استخدم Supabase Auth
- profiles → ❌ خطأ، استخدم user_profiles
- merchants → ❌ خطأ، استخدم user_profiles.role
- mbuy_user_id → ❌ خطأ، استخدم auth_user_id
```

---

## 8. الخلاصة النهائية

### الخطة الذهبية - النقاط الرئيسية

1. **Auth:** Supabase Auth (`auth.users`) فقط ✅
2. **Identity Chain:** `auth.users → user_profiles → stores → products` ✅
3. **Communication:** `Flutter → Worker → Supabase` ✅
4. **Worker Clients:** `userClient (RLS)` + `adminClient (admin)` ✅
5. **Flutter:** HTTP only، لا `supabase_flutter` ✅

**تم التنظيف:**
- ✅ حذف 5 ملفات Legacy Auth من Worker
- ✅ Legacy endpoints تعيد 410 Gone
- ✅ لا استخدام لـ `mbuy_users` في Auth
- ✅ لا استخدام لـ `mbuy_sessions`
- ✅ Flutter لا يستخدم `supabase_flutter`

**المسار الوحيد المعتمد:**
```
auth.users.id → user_profiles.auth_user_id → stores.owner_id → products.store_id
```

**لا تخالف الخطة الذهبية.**
- ❌ `user_profiles.auth_provider` - محذوف

**Worker Files:**
- ❌ `src/middleware/mbuyAuthMiddleware.ts`
- ❌ `src/utils/jwt.ts`
- ❌ `src/endpoints/auth.ts` (custom auth endpoints)

**Environment Variables:**
- ❌ `JWT_SECRET`

**Flutter:**
- ❌ Custom JWT logic
- ❌ Manual token storage
- ❌ Custom auth endpoints

### 6.9 Migration Status

| المرحلة | الحالة | الوصف |
|---------|-------|-------|
| **Phase 1** | ⏳ Pending | Setup & Preparation |
| **Phase 2** | ⏳ Pending | Dual System Support |
| **Phase 3** | ⏳ Pending | User Migration |
| **Phase 4** | ⏳ Pending | Full Supabase Auth |
| **Phase 5** | ⏳ Pending | Cleanup & Optimization |

**للبدء في Migration:** راجع `SUPABASE_AUTH_MIGRATION_PLAN.md`
