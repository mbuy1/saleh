# خطة الانتقال إلى Supabase Auth - Migration Plan

> **📅 تاريخ الإنشاء:** ديسمبر 2025  
> **🎯 الهدف:** الانتقال التدريجي من Custom JWT (mbuy_users) إلى Supabase Auth (auth.users)  
> **⚠️ الحالة:** Pre-Production (لا يوجد مستخدمون حقيقيون)

---

## 📋 جدول المحتويات

1. [نظرة عامة](#1-نظرة-عامة)
2. [المعمارية الحالية vs الهدف](#2-المعمارية-الحالية-vs-الهدف)
3. [المراحل التفصيلية](#3-المراحل-التفصيلية)
4. [التفاصيل التقنية](#4-التفاصيل-التقنية)
5. [خطة التنفيذ](#5-خطة-التنفيذ)
6. [المخاطر والتخفيف](#6-المخاطر-والتخفيف)

---

## 1. نظرة عامة

### 1.1 السبب وراء Migration

**المشاكل الحالية:**
- ✅ Custom JWT يعمل لكنه يتطلب صيانة مستمرة
- ✅ Worker يستخدم `SERVICE_ROLE_KEY` لجميع العمليات (bypasses RLS)
- ✅ RLS Policies موجودة لكن غير فعّالة
- ✅ لا يمكن استخدام Supabase Realtime subscriptions
- ✅ صعوبة في إضافة ميزات مثل OAuth, MFA, Email verification

**الفوائد المتوقعة:**
- 🎯 استخدام Supabase Auth كـ Industry Best Practice
- 🎯 RLS فعّال بناءً على `auth.uid()`
- 🎯 دعم OAuth (Google, Apple, etc.) مجاناً
- 🎯 MFA, Email verification, Password reset جاهزة
- 🎯 تقليل الكود المخصص في Worker
- 🎯 حماية أفضل مع Row Level Security

### 1.2 الاستراتيجية

**نهج التنفيذ:** Migration تدريجية (Gradual Migration)

```
Phase 1: Setup ────→ Phase 2: Dual System ────→ Phase 3: Migration ────→ Phase 4: Cleanup
  (1 يوم)              (2-3 أيام)                 (1 يوم)                (1 يوم)
```

**المبادئ الأساسية:**
1. ✅ لا Big Bang - كل مرحلة قابلة للاختبار بشكل مستقل
2. ✅ Backward Compatibility - الموجود يستمر بالعمل خلال Migration
3. ✅ Rollback Plan - إمكانية العودة في أي مرحلة
4. ✅ Zero Data Loss - جميع البيانات محفوظة

---

## 2. المعمارية الحالية vs الهدف

### 2.1 المعمارية الحالية (Current)

```
┌─────────────────────┐
│   Flutter App       │
│   (Dart)            │
└──────────┬──────────┘
           │ HTTP + Custom JWT
           │ Authorization: Bearer <custom-jwt>
           ↓
┌─────────────────────┐
│ Cloudflare Worker   │
│ (TypeScript)        │
│                     │
│ • mbuyAuthMiddleware│ ← يتحقق من Custom JWT
│ • extractAuthContext│ ← يستخرج userId من JWT.sub
│ • supabase.ts       │ ← يستخدم SERVICE_ROLE_KEY فقط
└──────────┬──────────┘
           │ SERVICE_ROLE_KEY
           │ (bypasses RLS)
           ↓
┌─────────────────────┐
│ Supabase PostgreSQL │
│                     │
│ • mbuy_users        │ ← Custom Auth Table
│ • user_profiles     │ ← mbuy_user_id FK
│ • stores            │
│ • products          │
│ • ...               │
│                     │
│ RLS: Enabled ✅     │
│ RLS: Effective ❌   │ ← SERVICE_ROLE bypasses
└─────────────────────┘
```

**JWT Structure (Custom):**
```json
{
  "sub": "mbuy_users.id (UUID)",
  "email": "user@example.com",
  "type": "access_token",
  "iat": 1234567890,
  "exp": 1234567890
}
```

**Auth Flow:**
1. User → Flutter: Login with email/password
2. Flutter → Worker: `POST /auth/login`
3. Worker: يتحقق من `mbuy_users` table
4. Worker: يولّد Custom JWT موقّع بـ `JWT_SECRET`
5. Flutter: يحفظ JWT في Local Storage
6. Flutter: يرسل JWT في كل Request
7. Worker: يتحقق من JWT ويستخرج `userId`

### 2.2 المعمارية الهدف (Target)

```
┌─────────────────────┐
│   Flutter App       │
│   (Dart)            │
│   + supabase_flutter│ ← NEW
└──────────┬──────────┘
           │ Supabase Auth JWT
           │ Authorization: Bearer <supabase-jwt>
           ↓
┌─────────────────────┐
│ Cloudflare Worker   │
│ (TypeScript)        │
│                     │
│ • supabaseAuth      │ ← NEW: يتحقق من Supabase JWT
│ • userClient        │ ← NEW: ANON_KEY + User JWT
│ • adminClient       │ ← SERVICE_ROLE_KEY (admin only)
└──────────┬──────────┘
           │ ANON_KEY (للمستخدمين)
           │ + User JWT in Authorization header
           │ (RLS Active ✅)
           ↓
┌─────────────────────┐
│ Supabase PostgreSQL │
│                     │
│ • auth.users        │ ← NEW: Supabase Auth
│ • user_profiles     │ ← id = auth.users.id (PK)
│ • stores            │
│ • products          │
│ • ...               │
│                     │
│ RLS: Enabled ✅     │
│ RLS: Effective ✅   │ ← auth.uid() works
└─────────────────────┘
```

**JWT Structure (Supabase):**
```json
{
  "sub": "auth.users.id (UUID)",
  "email": "user@example.com",
  "role": "authenticated",
  "aud": "authenticated",
  "app_metadata": {
    "provider": "email"
  },
  "user_metadata": {
    "full_name": "User Name"
  },
  "iat": 1234567890,
  "exp": 1234567890
}
```

**Auth Flow (New):**
1. User → Flutter: Login with email/password
2. Flutter → Supabase Auth: `signInWithPassword()`
3. Supabase Auth: يتحقق ويصدر JWT
4. Flutter: يحفظ JWT تلقائياً في `supabase_flutter`
5. Flutter → Worker: يرسل Supabase JWT
6. Worker: يستخدم `userClient` (ANON_KEY + JWT)
7. Supabase: RLS يتحقق من `auth.uid()` تلقائياً

### 2.3 الفروقات الأساسية

| الجانب | الحالي (Custom) | الهدف (Supabase Auth) |
|--------|-----------------|------------------------|
| **Auth Provider** | `mbuy_users` table | `auth.users` (Supabase) |
| **JWT Issuer** | Worker (Custom) | Supabase Auth |
| **JWT Secret** | `JWT_SECRET` (custom) | Supabase internal key |
| **Worker Key** | `SERVICE_ROLE_KEY` فقط | `ANON_KEY` (users) + `SERVICE_ROLE` (admin) |
| **RLS Status** | Bypassed | Active & Effective |
| **auth.uid()** | لا يعمل ❌ | يعمل ✅ |
| **Flutter SDK** | `http` package | `supabase_flutter` |
| **user_profiles.id** | UUID عشوائي | `= auth.users.id` |
| **Password Reset** | Manual implementation | Built-in |
| **Email Verification** | Manual | Built-in |
| **OAuth** | Manual | Built-in |
| **MFA** | لا يوجد | Built-in |

---

## 3. المراحل التفصيلية

### Phase 1: Setup & Preparation (يوم 1)

**الهدف:** تجهيز البنية التحتية لـ Supabase Auth بدون كسر الموجود

#### 1.1 Database Changes

**A. تفعيل Supabase Auth:**
```sql
-- Supabase Auth مفعّل تلقائياً، لكن نتأكد من الإعدادات
-- في Supabase Dashboard → Authentication → Settings:
-- ✅ Enable Email provider
-- ✅ Disable Email confirmation (للاختبار فقط)
-- ✅ Site URL: https://your-worker.workers.dev
```

**B. تعديل `user_profiles` لدعم كلا النظامين:**
```sql
-- Migration: 20250112000001_prepare_dual_auth.sql

-- 1. إضافة عمود auth_user_id (اختياري مؤقتاً)
ALTER TABLE user_profiles
ADD COLUMN auth_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

-- 2. إضافة index للأداء
CREATE INDEX idx_user_profiles_auth_user_id ON user_profiles(auth_user_id);

-- 3. إنشاء constraint للتأكد من وجود واحد من الاثنين
ALTER TABLE user_profiles
ADD CONSTRAINT check_has_auth_source 
CHECK (
  mbuy_user_id IS NOT NULL OR auth_user_id IS NOT NULL
);

-- 4. إضافة عمود لتتبع مصدر Auth
ALTER TABLE user_profiles
ADD COLUMN auth_provider VARCHAR(20) DEFAULT 'mbuy_custom'
CHECK (auth_provider IN ('mbuy_custom', 'supabase_auth'));

COMMENT ON COLUMN user_profiles.auth_provider IS 
'Tracks which auth system created this profile: mbuy_custom or supabase_auth';
```

**C. إنشاء Function لمزامنة Users:**
```sql
-- Function: تلقائياً ينشئ user_profile عند إنشاء auth.user
CREATE OR REPLACE FUNCTION public.handle_new_auth_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (
    id,
    auth_user_id,
    auth_provider,
    display_name,
    role,
    created_at,
    updated_at
  ) VALUES (
    NEW.id,  -- user_profiles.id = auth.users.id
    NEW.id,  -- auth_user_id redundant لكن للوضوح
    'supabase_auth',
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
    'customer',  -- Default role
    NOW(),
    NOW()
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger: يشتغل عند إنشاء user جديد في auth.users
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_auth_user();
```

**D. Migration للمستخدمين الموجودين (إن وجدوا):**
```sql
-- Script لنقل المستخدمين من mbuy_users إلى auth.users
-- ملاحظة: يجب تشغيله يدوياً لأنه يحتاج بيانات حساسة

-- للاختبار فقط: إنشاء test users في auth.users
-- في Production: استخدام Supabase Admin API
```

#### 1.2 Worker Changes

**A. إنشاء `supabaseUser.ts` (User Client):**
```typescript
// src/utils/supabaseUser.ts
import { createClient } from '@supabase/supabase-js';
import type { Env } from '../types';

export function createUserSupabaseClient(env: Env, userJwt?: string) {
  const supabase = createClient(
    env.SUPABASE_URL,
    env.SUPABASE_ANON_KEY,  // ← ANON_KEY (RLS active)
    {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
        detectSessionInUrl: false,
      },
      global: {
        headers: userJwt ? {
          Authorization: `Bearer ${userJwt}`
        } : {}
      }
    }
  );

  return supabase;
}
```

**B. تحديث `supabase.ts` (Admin Client):**
```typescript
// src/utils/supabase.ts
import { createClient } from '@supabase/supabase-js';
import type { Env } from '../types';

// Admin Client - SERVICE_ROLE_KEY (bypasses RLS)
export function createAdminSupabaseClient(env: Env) {
  return createClient(
    env.SUPABASE_URL,
    env.SUPABASE_SERVICE_ROLE_KEY,  // ← SERVICE_ROLE
    {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      }
    }
  );
}
```

**C. إنشاء Middleware جديد:**
```typescript
// src/middleware/supabaseAuthMiddleware.ts
import { Context, Next } from 'hono';
import { Env } from '../types';
import { createUserSupabaseClient } from '../utils/supabaseUser';

export async function supabaseAuthMiddleware(c: Context<{ Bindings: Env }>, next: Next) {
  const authHeader = c.req.header('Authorization');
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return c.json({ error: 'unauthorized', message: 'Missing token' }, 401);
  }

  const token = authHeader.substring(7);
  const userClient = createUserSupabaseClient(c.env, token);

  try {
    // Verify token with Supabase Auth
    const { data: { user }, error } = await userClient.auth.getUser(token);

    if (error || !user) {
      return c.json({ error: 'unauthorized', message: 'Invalid token' }, 401);
    }

    // Fetch user profile
    const { data: profile, error: profileError } = await userClient
      .from('user_profiles')
      .select('id, role, display_name, auth_provider')
      .eq('auth_user_id', user.id)
      .single();

    if (profileError || !profile) {
      return c.json({ error: 'profile_not_found' }, 404);
    }

    // Set context
    c.set('authUserId', user.id);           // auth.users.id
    c.set('profileId', profile.id);         // user_profiles.id
    c.set('userRole', profile.role);
    c.set('userClient', userClient);        // للاستخدام في endpoints

    await next();
  } catch (err) {
    console.error('Auth error:', err);
    return c.json({ error: 'auth_failed' }, 500);
  }
}
```

#### 1.3 Flutter Changes (Setup Only)

**A. إضافة Supabase SDK:**
```yaml
# pubspec.yaml
dependencies:
  supabase_flutter: ^2.3.0
  # keep existing http package للمرحلة الانتقالية
```

**B. تهيئة Supabase في Flutter:**
```dart
// lib/core/config/supabase_config.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'YOUR_SUPABASE_URL',
      anonKey: 'YOUR_ANON_KEY',
      authOptions: FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}
```

**C. تحديث `main.dart`:**
```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase (جديد)
  await SupabaseConfig.initialize();
  
  runApp(MyApp());
}
```

**Status after Phase 1:**
- ✅ Database جاهز لكلا النظامين
- ✅ Worker فيه كلا Clients (user + admin)
- ✅ Flutter فيه Supabase SDK
- ✅ النظام القديم يعمل 100%
- ⏳ لم نبدأ Migration بعد

---

### Phase 2: Dual System Support (يوم 2-3)

**الهدف:** دعم كلا نظامي Auth بشكل متوازي

#### 2.1 Worker: Unified Auth Middleware

**إنشاء Middleware موحّد يدعم كلا النظامين:**

```typescript
// src/middleware/unifiedAuthMiddleware.ts
import { Context, Next } from 'hono';
import { Env } from '../types';
import { verifyMbuyJWT } from '../utils/jwt';
import { createUserSupabaseClient } from '../utils/supabaseUser';
import { createAdminSupabaseClient } from '../utils/supabase';

export async function unifiedAuthMiddleware(c: Context<{ Bindings: Env }>, next: Next) {
  const authHeader = c.req.header('Authorization');
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return c.json({ error: 'unauthorized' }, 401);
  }

  const token = authHeader.substring(7);

  // Try Supabase Auth first
  try {
    const userClient = createUserSupabaseClient(c.env, token);
    const { data: { user }, error } = await userClient.auth.getUser(token);

    if (!error && user) {
      // ✅ Supabase Auth Token
      const { data: profile } = await userClient
        .from('user_profiles')
        .select('id, role, auth_provider')
        .eq('auth_user_id', user.id)
        .single();

      if (profile) {
        c.set('authUserId', user.id);
        c.set('profileId', profile.id);
        c.set('userRole', profile.role);
        c.set('authProvider', 'supabase');
        c.set('userClient', userClient);
        await next();
        return;
      }
    }
  } catch (err) {
    // Not a Supabase token, try Custom JWT
  }

  // Try Custom JWT (fallback)
  try {
    const payload = await verifyMbuyJWT(token, c.env.JWT_SECRET);
    const mbuyUserId = payload.sub;

    const adminClient = createAdminSupabaseClient(c.env);
    const { data: profile } = await adminClient
      .from('user_profiles')
      .select('id, role, auth_provider')
      .eq('mbuy_user_id', mbuyUserId)
      .single();

    if (profile) {
      // ✅ Custom JWT Token
      c.set('authUserId', mbuyUserId);
      c.set('profileId', profile.id);
      c.set('userRole', profile.role);
      c.set('authProvider', 'mbuy_custom');
      c.set('adminClient', adminClient);
      await next();
      return;
    }
  } catch (err) {
    console.error('Auth failed:', err);
  }

  // Both failed
  return c.json({ error: 'unauthorized' }, 401);
}
```

#### 2.2 Worker: تحديث Endpoints

**A. تحديث Products Endpoint:**

```typescript
// src/endpoints/products.ts
import { Hono } from 'hono';
import { Env } from '../types';
import { unifiedAuthMiddleware } from '../middleware/unifiedAuthMiddleware';

const app = new Hono<{ Bindings: Env }>();

// استخدام Unified Middleware
app.use('/secure/*', unifiedAuthMiddleware);

app.post('/secure/products', async (c) => {
  const profileId = c.get('profileId');
  const role = c.get('userRole');
  const authProvider = c.get('authProvider');

  if (role !== 'merchant' && role !== 'admin') {
    return c.json({ error: 'forbidden' }, 403);
  }

  // اختيار الـ client المناسب
  const client = authProvider === 'supabase' 
    ? c.get('userClient')  // User Client (RLS active)
    : c.get('adminClient'); // Admin Client (RLS bypass)

  // جلب المتجر
  const { data: store } = await client
    .from('stores')
    .select('id, status')
    .eq('owner_id', profileId)
    .single();

  if (!store) {
    return c.json({ error: 'no_store' }, 400);
  }

  const body = await c.req.json();

  // إنشاء المنتج
  const { data, error } = await client
    .from('products')
    .insert({
      store_id: store.id,
      name: body.name,
      price: body.price,
      stock: body.stock,
      // ...
    })
    .select()
    .single();

  if (error) {
    return c.json({ error: error.message }, 500);
  }

  return c.json({ product: data }, 201);
});

export default app;
```

**B. تحديث باقي Endpoints بنفس النمط**

#### 2.3 Flutter: Dual Auth Service

**إنشاء AuthService موحّد:**

```dart
// lib/core/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';
import 'api_service.dart';

enum AuthProvider { mbuyCustom, supabase }

class AuthService {
  final _supabase = Supabase.instance.client;
  final _apiService = ApiService();
  
  AuthProvider _currentProvider = AuthProvider.mbuyCustom;
  
  // Login with Custom JWT (Old System)
  Future<void> loginWithCustomAuth(String email, String password) async {
    final response = await _apiService.post('/auth/login', body: {
      'email': email,
      'password': password,
    });
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data['access_token']);
      _currentProvider = AuthProvider.mbuyCustom;
    }
  }
  
  // Login with Supabase Auth (New System)
  Future<void> loginWithSupabase(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    
    if (response.session != null) {
      _currentProvider = AuthProvider.supabase;
    }
  }
  
  // Get current token
  Future<String?> getToken() async {
    if (_currentProvider == AuthProvider.supabase) {
      final session = _supabase.auth.currentSession;
      return session?.accessToken;
    } else {
      // Get from local storage (custom JWT)
      return await _getStoredToken();
    }
  }
  
  // Check if user is authenticated
  bool get isAuthenticated {
    if (_currentProvider == AuthProvider.supabase) {
      return _supabase.auth.currentSession != null;
    } else {
      return _hasStoredToken();
    }
  }
}
```

**Status after Phase 2:**
- ✅ Worker يدعم كلا Token types
- ✅ Flutter يدعم كلا Auth systems
- ✅ يمكن اختبار Supabase Auth بدون كسر القديم
- ✅ RLS يعمل مع Supabase tokens
- ⏳ المستخدمون القدامى يستخدمون Custom JWT
- ⏳ المستخدمون الجدد يمكنهم استخدام Supabase Auth

---

### Phase 3: User Migration (يوم 4)

**الهدف:** نقل المستخدمين من `mbuy_users` إلى `auth.users`

#### 3.1 تحضير Migration Script

**A. SQL Script لنقل المستخدمين:**

```sql
-- Migration: 20250113000001_migrate_users_to_auth.sql
-- ⚠️ هذا Script يحتاج تشغيل من Supabase Admin API

-- لا يمكن نقل الـ passwords مباشرة (hashed بطريقة مختلفة)
-- الحلول:
-- 1. Reset password للجميع
-- 2. Migration API باستخدام Supabase Admin SDK
-- 3. Gradual migration عند أول login

-- Approach: Gradual Migration on First Login
-- نضيف flag في mbuy_users لتتبع Migration
ALTER TABLE mbuy_users
ADD COLUMN migrated_to_auth BOOLEAN DEFAULT false;
```

**B. Worker Endpoint للـ Migration:**

```typescript
// src/endpoints/auth.ts - إضافة endpoint

app.post('/auth/migrate-login', async (c) => {
  const { email, password } = await c.req.json();
  const adminClient = createAdminSupabaseClient(c.env);

  // 1. التحقق من mbuy_users
  const { data: mbuyUser } = await adminClient
    .from('mbuy_users')
    .select('id, email, password_hash, full_name, migrated_to_auth')
    .eq('email', email)
    .single();

  if (!mbuyUser) {
    return c.json({ error: 'invalid_credentials' }, 401);
  }

  // 2. التحقق من Password
  const isValid = await verifyPassword(password, mbuyUser.password_hash);
  if (!isValid) {
    return c.json({ error: 'invalid_credentials' }, 401);
  }

  // 3. إذا لم يتم Migration بعد، ننشئ في auth.users
  if (!mbuyUser.migrated_to_auth) {
    try {
      // استخدام Supabase Admin API لإنشاء user
      const { data: authUser, error } = await adminClient.auth.admin.createUser({
        email: mbuyUser.email,
        password: password,  // نفس الـ password
        email_confirm: true,  // تأكيد البريد تلقائياً
        user_metadata: {
          full_name: mbuyUser.full_name,
        }
      });

      if (error) throw error;

      // 4. تحديث user_profile
      await adminClient
        .from('user_profiles')
        .update({
          auth_user_id: authUser.user.id,
          auth_provider: 'supabase_auth',
          id: authUser.user.id,  // تحديث PK
        })
        .eq('mbuy_user_id', mbuyUser.id);

      // 5. تحديث mbuy_users flag
      await adminClient
        .from('mbuy_users')
        .update({ migrated_to_auth: true })
        .eq('id', mbuyUser.id);

      // 6. تسجيل الدخول بـ Supabase Auth
      const { data: session } = await adminClient.auth.signInWithPassword({
        email,
        password,
      });

      return c.json({
        message: 'migrated',
        access_token: session.session.access_token,
        refresh_token: session.session.refresh_token,
        provider: 'supabase',
      }, 200);

    } catch (err) {
      console.error('Migration failed:', err);
      
      // Fallback: إصدار Custom JWT
      const customToken = await generateMbuyJWT(mbuyUser.id, c.env.JWT_SECRET);
      return c.json({
        message: 'migration_failed_using_fallback',
        access_token: customToken,
        provider: 'mbuy_custom',
      }, 200);
    }
  }

  // 4. إذا تم Migration مسبقاً، نستخدم Supabase Auth
  const { data: session, error } = await adminClient.auth.signInWithPassword({
    email,
    password,
  });

  if (error) {
    return c.json({ error: error.message }, 401);
  }

  return c.json({
    message: 'success',
    access_token: session.session.access_token,
    refresh_token: session.session.refresh_token,
    provider: 'supabase',
  }, 200);
});
```

#### 3.2 Flutter: استخدام Migration Endpoint

```dart
// lib/core/services/auth_service.dart

Future<void> login(String email, String password) async {
  // استخدام migrate-login endpoint
  final response = await _apiService.post('/auth/migrate-login', body: {
    'email': email,
    'password': password,
  });

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    
    if (data['provider'] == 'supabase') {
      // استخدام Supabase session
      await _supabase.auth.setSession(data['access_token']);
      _currentProvider = AuthProvider.supabase;
    } else {
      // Fallback to custom JWT
      await _saveToken(data['access_token']);
      _currentProvider = AuthProvider.mbuyCustom;
    }
  }
}
```

**Status after Phase 3:**
- ✅ المستخدمون القدامى يتم Migration تلقائياً عند Login
- ✅ لا Data Loss
- ✅ Passwords تبقى نفسها
- ✅ Fallback للنظام القديم إذا فشل Migration
- ⏳ بعض المستخدمين قد يكونون على النظام القديم (حتى يسجلوا دخول)

---

### Phase 4: Full Supabase Auth (يوم 5)

**الهدف:** إزالة Custom JWT تماماً

#### 4.1 Database: تنظيف الجداول

```sql
-- Migration: 20250114000001_finalize_auth_migration.sql

-- 1. التأكد من migration جميع المستخدمين
SELECT COUNT(*) FROM mbuy_users WHERE migrated_to_auth = false;
-- إذا كان العدد > 0، انتظر أو force migrate

-- 2. تحديث user_profiles.id ليكون auth.users.id
-- ⚠️ خطوة حساسة جداً - تحتاج backup

-- 2a. إنشاء جدول مؤقت
CREATE TABLE user_profiles_new (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  role TEXT DEFAULT 'customer',
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  -- حذف mbuy_user_id و auth_user_id
  -- حذف auth_provider
  CONSTRAINT valid_role CHECK (role IN ('customer', 'merchant', 'admin'))
);

-- 2b. نقل البيانات
INSERT INTO user_profiles_new (id, display_name, role, avatar_url, created_at, updated_at)
SELECT 
  COALESCE(auth_user_id, id) as id,  -- استخدام auth_user_id أو id
  display_name,
  role,
  avatar_url,
  created_at,
  updated_at
FROM user_profiles
WHERE auth_user_id IS NOT NULL;  -- فقط المستخدمين الذين تم Migration

-- 2c. تحديث Foreign Keys في stores
ALTER TABLE stores DROP CONSTRAINT stores_owner_id_fkey;
ALTER TABLE stores ADD CONSTRAINT stores_owner_id_fkey 
  FOREIGN KEY (owner_id) REFERENCES user_profiles_new(id) ON DELETE CASCADE;

-- 2d. استبدال الجداول
DROP TABLE user_profiles CASCADE;
ALTER TABLE user_profiles_new RENAME TO user_profiles;

-- 3. حذف mbuy_users (اختياري - يمكن الاحتفاظ كـ backup)
-- ALTER TABLE mbuy_users RENAME TO mbuy_users_backup;
DROP TABLE mbuy_users;
DROP TABLE mbuy_sessions;

-- 4. تحديث RLS Policies
-- (راجع القسم التالي)
```

#### 4.2 تحديث RLS Policies

```sql
-- Migration: 20250114000002_update_rls_for_auth.sql

-- user_profiles policies
DROP POLICY IF EXISTS "users_view_own_profile" ON user_profiles;
CREATE POLICY "users_view_own_profile"
ON user_profiles
FOR SELECT
TO authenticated
USING (id = auth.uid());  -- ✅ يعمل الآن

DROP POLICY IF EXISTS "users_update_own_profile" ON user_profiles;
CREATE POLICY "users_update_own_profile"
ON user_profiles
FOR UPDATE
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- stores policies
DROP POLICY IF EXISTS "merchants_view_own_store" ON stores;
CREATE POLICY "merchants_view_own_store"
ON stores
FOR SELECT
TO authenticated
USING (
  owner_id = auth.uid()  -- ✅ مباشر بدون subquery
);

DROP POLICY IF EXISTS "merchants_insert_store" ON stores;
CREATE POLICY "merchants_insert_store"
ON stores
FOR INSERT
TO authenticated
WITH CHECK (
  owner_id = auth.uid()
  AND owner_id IN (
    SELECT id FROM user_profiles 
    WHERE id = auth.uid()
    AND role IN ('merchant', 'admin')
  )
);

-- products policies (مثال)
DROP POLICY IF EXISTS "merchants_insert_own_products" ON products;
CREATE POLICY "merchants_insert_own_products"
ON products
FOR INSERT
TO authenticated
WITH CHECK (
  store_id IN (
    SELECT id FROM stores WHERE owner_id = auth.uid()
  )
);

-- باقي Policies بنفس النمط...
```

#### 4.3 Worker: إزالة Custom JWT Support

```typescript
// src/middleware/authMiddleware.ts - النسخة النهائية

export async function authMiddleware(c: Context<{ Bindings: Env }>, next: Next) {
  const authHeader = c.req.header('Authorization');
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return c.json({ error: 'unauthorized' }, 401);
  }

  const token = authHeader.substring(7);
  const userClient = createUserSupabaseClient(c.env, token);

  try {
    const { data: { user }, error } = await userClient.auth.getUser(token);

    if (error || !user) {
      return c.json({ error: 'unauthorized' }, 401);
    }

    const { data: profile } = await userClient
      .from('user_profiles')
      .select('id, role, display_name')
      .eq('id', user.id)  // ✅ مباشر
      .single();

    if (!profile) {
      return c.json({ error: 'profile_not_found' }, 404);
    }

    c.set('userId', user.id);
    c.set('profileId', profile.id);  // نفس القيمة
    c.set('userRole', profile.role);
    c.set('userClient', userClient);

    await next();
  } catch (err) {
    return c.json({ error: 'auth_failed' }, 500);
  }
}

// حذف:
// - mbuyAuthMiddleware.ts
// - unifiedAuthMiddleware.ts
// - utils/jwt.ts (Custom JWT logic)
```

#### 4.4 Worker: تحديث Endpoints

```typescript
// src/endpoints/products.ts - النسخة النهائية

app.post('/secure/products', async (c) => {
  const userId = c.get('userId');  // auth.users.id
  const role = c.get('userRole');
  const userClient = c.get('userClient');  // ✅ دائماً User Client

  if (role !== 'merchant' && role !== 'admin') {
    return c.json({ error: 'forbidden' }, 403);
  }

  // جلب المتجر - RLS يتحقق تلقائياً
  const { data: store, error: storeError } = await userClient
    .from('stores')
    .select('id, status')
    .eq('owner_id', userId)  // ✅ RLS يتحقق من auth.uid()
    .single();

  if (storeError || !store) {
    return c.json({ error: 'no_store' }, 400);
  }

  const body = await c.req.json();

  // إنشاء المنتج - RLS يتحقق تلقائياً
  const { data, error } = await userClient
    .from('products')
    .insert({
      store_id: store.id,
      name: body.name,
      // ...
    })
    .select()
    .single();

  if (error) {
    return c.json({ error: error.message }, 500);
  }

  return c.json({ product: data }, 201);
});
```

#### 4.5 Flutter: Full Supabase Auth

```dart
// lib/core/services/auth_service.dart - النسخة النهائية

class AuthService {
  final _supabase = Supabase.instance.client;
  
  // Login
  Future<void> login(String email, String password) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  // Register
  Future<void> register(String email, String password, String fullName) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }
  
  // Logout
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
  
  // Get current user
  User? get currentUser => _supabase.auth.currentUser;
  
  // Get token
  String? get token => _supabase.auth.currentSession?.accessToken;
  
  // Listen to auth changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}

// حذف:
// - Custom JWT logic
// - api_service.dart (auth endpoints)
// - Dual auth support
```

**Status after Phase 4:**
- ✅ Custom JWT محذوف بالكامل
- ✅ Supabase Auth هو النظام الوحيد
- ✅ RLS فعّال وشغال
- ✅ Worker يستخدم ANON_KEY للمستخدمين
- ✅ Flutter يستخدم supabase_flutter
- ✅ `user_profiles.id = auth.users.id`

---

### Phase 5: Cleanup & Optimization (يوم 6)

**الهدف:** تنظيف الكود القديم وتحسين الأداء

#### 5.1 إزالة الملفات القديمة

**Worker:**
- ❌ `src/middleware/mbuyAuthMiddleware.ts`
- ❌ `src/middleware/unifiedAuthMiddleware.ts`
- ❌ `src/utils/jwt.ts`
- ❌ `src/endpoints/auth.ts` (custom auth endpoints)
- ❌ `src/utils/supabase.ts` → دمج في `supabaseUser.ts`

**Flutter:**
- ❌ Custom JWT logic من `AuthService`
- ❌ `api_service.dart` auth endpoints
- تبسيط `AuthService` ليستخدم Supabase فقط

#### 5.2 تحسين RLS Policies

```sql
-- إضافة indexes للأداء
CREATE INDEX IF NOT EXISTS idx_stores_owner_id ON stores(owner_id);
CREATE INDEX IF NOT EXISTS idx_products_store_id ON products(store_id);
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_store_id ON orders(store_id);

-- تحسين Policies باستخدام SECURITY INVOKER
-- (راجع Supabase docs)
```

#### 5.3 تحديث Environment Variables

```bash
# Worker: wrangler.toml
[vars]
SUPABASE_URL = "https://xxx.supabase.co"
SUPABASE_ANON_KEY = "eyJ..."  # ✅ مستخدم
SUPABASE_SERVICE_ROLE_KEY = "eyJ..."  # ✅ للـ admin endpoints فقط

# حذف:
# JWT_SECRET  # ❌ لم نعد نحتاجه
```

```dart
// Flutter: .env أو app_config.dart
const String supabaseUrl = 'https://xxx.supabase.co';
const String supabaseAnonKey = 'eyJ...';

// حذف:
// const String apiBaseUrl  # ❌ نستخدم Supabase مباشرة
```

---

## 4. التفاصيل التقنية

### 4.1 User Profiles Structure (Final)

```sql
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

-- Trigger لتحديث updated_at
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON user_profiles
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
```

### 4.2 RLS Policies (Complete List)

**user_profiles:**
```sql
-- View own profile
CREATE POLICY "users_view_own_profile" ON user_profiles
FOR SELECT TO authenticated
USING (id = auth.uid());

-- Update own profile
CREATE POLICY "users_update_own_profile" ON user_profiles
FOR UPDATE TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Public view merchant profiles
CREATE POLICY "public_view_merchants" ON user_profiles
FOR SELECT TO anon, authenticated
USING (role = 'merchant');
```

**stores:**
```sql
-- Merchants insert own store
CREATE POLICY "merchants_insert_store" ON stores
FOR INSERT TO authenticated
WITH CHECK (
  owner_id = auth.uid()
  AND EXISTS (
    SELECT 1 FROM user_profiles
    WHERE id = auth.uid() AND role IN ('merchant', 'admin')
  )
);

-- View own store
CREATE POLICY "merchants_view_own_store" ON stores
FOR SELECT TO authenticated
USING (owner_id = auth.uid());

-- Update own store
CREATE POLICY "merchants_update_own_store" ON stores
FOR UPDATE TO authenticated
USING (owner_id = auth.uid())
WITH CHECK (owner_id = auth.uid());

-- Delete own store
CREATE POLICY "merchants_delete_own_store" ON stores
FOR DELETE TO authenticated
USING (owner_id = auth.uid());

-- Public view active stores
CREATE POLICY "public_view_active_stores" ON stores
FOR SELECT TO anon, authenticated
USING (status = 'active');
```

**products:**
```sql
-- Merchants insert own products
CREATE POLICY "merchants_insert_own_products" ON products
FOR INSERT TO authenticated
WITH CHECK (
  store_id IN (
    SELECT id FROM stores WHERE owner_id = auth.uid()
  )
);

-- View own products
CREATE POLICY "merchants_view_own_products" ON products
FOR SELECT TO authenticated
USING (
  store_id IN (
    SELECT id FROM stores WHERE owner_id = auth.uid()
  )
);

-- Update own products
CREATE POLICY "merchants_update_own_products" ON products
FOR UPDATE TO authenticated
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

-- Delete own products
CREATE POLICY "merchants_delete_own_products" ON products
FOR DELETE TO authenticated
USING (
  store_id IN (
    SELECT id FROM stores WHERE owner_id = auth.uid()
  )
);

-- Public view active products
CREATE POLICY "public_view_active_products" ON products
FOR SELECT TO anon, authenticated
USING (status = 'active');
```

### 4.3 Worker Client Selection Logic

```typescript
// في كل endpoint:

// للمستخدمين العاديين - استخدم userClient
const userClient = c.get('userClient');  // ANON_KEY + JWT (RLS active)

// للعمليات الإدارية فقط
const adminClient = createAdminSupabaseClient(c.env);  // SERVICE_ROLE (bypasses RLS)

// مثال: Create Product
app.post('/secure/products', async (c) => {
  const userClient = c.get('userClient');  // ✅ RLS checks permissions
  
  // RLS يتحقق تلقائياً أن المستخدم owner للمتجر
  const { data, error } = await userClient
    .from('products')
    .insert({ ... });
});

// مثال: Admin - Delete Any Product
app.delete('/admin/products/:id', async (c) => {
  const adminClient = createAdminSupabaseClient(c.env);  // ✅ Bypasses RLS
  
  // يمكن حذف أي منتج
  const { error } = await adminClient
    .from('products')
    .delete()
    .eq('id', c.req.param('id'));
});
```

### 4.4 Flutter API Service (Final)

```dart
// lib/core/services/api_service.dart

class ApiService {
  final _supabase = Supabase.instance.client;
  
  // Products
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
  
  // Stores
  Future<Store?> getMyStore() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;
    
    final response = await _supabase
      .from('stores')
      .select()
      .eq('owner_id', userId)
      .maybeSingle();
    
    return response != null ? Store.fromJson(response) : null;
  }
}
```

---

## 5. خطة التنفيذ

### Timeline

| المرحلة | المدة | المهام الرئيسية | المخرجات |
|---------|------|------------------|-----------|
| **Phase 1** | 1 يوم | Database setup, Worker clients, Flutter SDK | البنية التحتية جاهزة |
| **Phase 2** | 2-3 أيام | Unified middleware, Dual auth support | كلا النظامين يعملان |
| **Phase 3** | 1 يوم | User migration script, Migrate endpoint | المستخدمون منقولون |
| **Phase 4** | 1 يوم | Remove custom JWT, Update RLS, Final Worker | Supabase Auth فقط |
| **Phase 5** | 1 يوم | Cleanup, Optimization, Documentation | إكمال وتوثيق |
| **Testing** | 2 أيام | شامل لجميع Features | نظام مستقر |

**Total:** ~7-9 أيام عمل

### Rollback Plan

**في أي مرحلة يمكن العودة:**

**Phase 1-2:**
- ✅ سهل جداً: تعطيل الكود الجديد
- ✅ Database لم يتغير (فقط إضافات)
- ✅ النظام القديم يعمل 100%

**Phase 3:**
- ⚠️ متوسط: بعض المستخدمين migrated
- ✅ يمكن العودة لـ Custom JWT
- ✅ `mbuy_users` لا يزال موجود

**Phase 4:**
- ❌ صعب: `mbuy_users` محذوف
- ⚠️ يحتاج restore من backup
- ✅ ممكن إذا كان هناك backup

**Recommendation:** اختبر كل مرحلة جيداً قبل الانتقال للتالية

---

## 6. المخاطر والتخفيف

### 6.1 مخاطر تقنية

| المخاطرة | الاحتمالية | التأثير | التخفيف |
|----------|------------|---------|----------|
| فقدان بيانات المستخدمين | منخفض | حاد | Backup كامل قبل كل مرحلة |
| فشل Migration | متوسط | متوسط | Fallback للنظام القديم |
| RLS غير صحيح | متوسط | حاد | اختبار شامل، Review |
| Performance issues | منخفض | متوسط | Indexes، Monitoring |
| JWT conflicts | منخفض | متوسط | Unified middleware |

### 6.2 خطة Backup

**قبل كل مرحلة:**

1. **Database Backup:**
```bash
# من Supabase Dashboard
# Settings → Database → Backups → Create Backup
```

2. **Code Backup:**
```bash
git checkout -b migration-phase-1
git commit -am "Before Phase 1"
git push origin migration-phase-1
```

3. **Environment Variables Backup:**
```bash
# حفظ wrangler.toml
# حفظ Supabase secrets
```

### 6.3 Testing Checklist

**بعد كل مرحلة:**

- [ ] User Login يعمل
- [ ] User Registration يعمل
- [ ] Create Product يعمل
- [ ] List Products يعمل
- [ ] Update Product يعمل
- [ ] Delete Product يعمل
- [ ] RLS يحمي البيانات
- [ ] Merchant يرى منتجاته فقط
- [ ] Customer يرى المنتجات النشطة
- [ ] Admin يرى كل شيء

---

## 7. الخطوات التالية

### الآن (قبل البدء)

1. ✅ مراجعة هذه الخطة
2. ✅ توضيح أي استفسارات
3. ✅ التأكد من فهم المخاطر
4. ✅ عمل Backup كامل

### بعد الموافقة

1. 🔨 البدء بـ Phase 1
2. 🔨 اختبار Phase 1
3. 🔨 مراجعة ومتابعة
4. 🔨 الانتقال لـ Phase 2
5. ... وهكذا

---

## 📝 الملاحظات النهائية

### ما لن يتغير

- ✅ Database schema (معظمه)
- ✅ Business logic
- ✅ Flutter UI
- ✅ Worker endpoints (فقط implementation)

### ما سيتغير

- 🔄 Auth system (Custom → Supabase)
- 🔄 JWT format
- 🔄 Worker client usage
- 🔄 RLS effectiveness
- 🔄 user_profiles.id (foreign key)

### الفوائد الطويلة المدى

- 📈 أسهل في الصيانة
- 📈 أكثر أماناً (RLS فعّال)
- 📈 دعم OAuth, MFA مجاناً
- 📈 Realtime subscriptions ممكنة
- 📈 أقل Custom code
- 📈 Best practices compliance

---

**آخر تحديث:** ديسمبر 2025  
**الحالة:** جاهز للمراجعة والموافقة  
**التواصل:** راجع مع الفريق قبل البدء
