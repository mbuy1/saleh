# 🔐 MBUY Worker - Golden Plan Auth Flow

## 📋 Overview

This document describes the complete authentication architecture for MBUY Worker following the **Golden Plan**.

**Last Updated:** December 11, 2025  
**Architecture:** Golden Plan (Supabase Auth Only)  
**Status:** ✅ Production Ready

---

## 🎯 Golden Plan Principles

### ✅ Single Source of Truth
- **Auth System:** Supabase Auth (`auth.users`) ONLY
- **NO Custom JWT:** All Legacy JWT code removed
- **NO mbuy_users:** Deprecated table (for reference only)
- **NO supabase_flutter:** Flutter uses HTTP + Worker (BFF pattern)

### ✅ Identity Chain
```
auth.users.id (Supabase Auth)
    ↓ (CASCADE DELETE)
user_profiles.auth_user_id (Application Profile)
    ↓ (CASCADE DELETE)
stores.owner_id (Merchant Store)
    ↓ (CASCADE DELETE)
products.store_id (Store Products)
```

### ✅ Communication Flow
```
Flutter (HTTP Client)
    ↓ Authorization: Bearer <Supabase JWT>
Worker (BFF - Backend for Frontend)
    ↓ Uses two Supabase clients:
    ├─ userClient: ANON_KEY + User JWT (RLS active)
    └─ adminClient: SERVICE_ROLE_KEY (admin ops only)
    ↓
Supabase Database (PostgreSQL + RLS)
```

---

## 🔑 Auth Endpoints

### 1️⃣ POST `/auth/supabase/register`

**Purpose:** Register new user via Supabase Auth

**Flow:**
```
1. Client sends: { email, password, full_name, role }
2. Worker validates input
3. Worker calls Supabase Auth Admin API: createUser()
4. Supabase creates auth.users row
5. Trigger (handle_new_auth_user) auto-creates user_profiles row
6. Worker waits 100ms for trigger to complete
7. Worker logs user in: signInWithPassword()
8. Worker returns JWT + profile data
```

**Request:**
```json
POST /auth/supabase/register
Content-Type: application/json

{
  "email": "merchant@example.com",
  "password": "secure_password_123",
  "full_name": "John Merchant",
  "role": "merchant"  // Optional: 'customer' (default), 'merchant', 'admin'
}
```

**Response (Success):**
```json
{
  "success": true,
  "message": "Registration successful",
  "access_token": "eyJhbG...",
  "refresh_token": "v1.Mn...",
  "expires_in": 3600,
  "user": {
    "id": "uuid-auth-users-id",
    "email": "merchant@example.com",
    "created_at": "2025-12-11T12:00:00Z"
  },
  "profile": {
    "id": "uuid-profile-id",
    "auth_user_id": "uuid-auth-users-id",
    "role": "merchant",
    "display_name": "John Merchant",
    "avatar_url": null,
    "phone": null
  }
}
```

**Response (Error - Email Exists):**
```json
{
  "error": "EMAIL_EXISTS",
  "message": "Email already registered"
}
```

**File:** `src/endpoints/supabaseAuth.ts:supabaseRegisterHandler()`

---

### 2️⃣ POST `/auth/supabase/login`

**Purpose:** Login user and get JWT

**Flow:**
```
1. Client sends: { email, password }
2. Worker validates input
3. Worker calls Supabase Auth: signInWithPassword()
4. Supabase verifies credentials
5. Worker fetches user_profiles using auth_user_id
6. Worker returns JWT + profile data
```

**Request:**
```json
POST /auth/supabase/login
Content-Type: application/json

{
  "email": "merchant@example.com",
  "password": "secure_password_123"
}
```

**Response (Success):**
```json
{
  "access_token": "eyJhbG...",
  "refresh_token": "v1.Mn...",
  "expires_in": 3600,
  "user": {
    "id": "uuid-auth-users-id",
    "email": "merchant@example.com",
    "created_at": "2025-12-11T12:00:00Z"
  },
  "profile": {
    "id": "uuid-profile-id",
    "auth_user_id": "uuid-auth-users-id",
    "role": "merchant",
    "display_name": "John Merchant"
  }
}
```

**Response (Error - Invalid Credentials):**
```json
{
  "error": "INVALID_CREDENTIALS",
  "message": "Invalid email or password"
}
```

**File:** `src/endpoints/supabaseAuth.ts:supabaseLoginHandler()`

---

### 3️⃣ POST `/auth/supabase/logout`

**Purpose:** Revoke user's JWT token

**Request:**
```json
POST /auth/supabase/logout
Authorization: Bearer <JWT>
```

**Response:**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

**File:** `src/endpoints/supabaseAuth.ts:supabaseLogoutHandler()`

---

### 4️⃣ POST `/auth/supabase/refresh`

**Purpose:** Refresh expired access token

**Request:**
```json
POST /auth/supabase/refresh
Content-Type: application/json

{
  "refresh_token": "v1.Mn..."
}
```

**Response:**
```json
{
  "access_token": "eyJhbG...",
  "refresh_token": "v1.Mn...",
  "expires_in": 3600
}
```

**File:** `src/endpoints/supabaseAuth.ts:supabaseRefreshHandler()`

---

## 🛡️ Auth Middleware

### `supabaseAuthMiddleware`

**Purpose:** Verify JWT and extract user context

**Flow:**
```
1. Extract JWT from Authorization: Bearer <token>
2. Verify JWT with Supabase Auth (/auth/v1/user)
3. Fetch user_profiles using auth_user_id
4. Set context variables:
   - authUserId (auth.users.id)
   - profileId (user_profiles.id)
   - userRole ('customer' | 'merchant' | 'admin')
   - userClient (Supabase client with user JWT)
   - authProvider ('supabase_auth')
5. Pass to next middleware/endpoint
```

**Usage in Routes:**
```typescript
import { supabaseAuthMiddleware } from './middleware/supabaseAuthMiddleware';

// Protect route with auth
app.post('/secure/products', supabaseAuthMiddleware, createProduct);
```

**Context Access in Endpoints:**
```typescript
export async function createProduct(
  c: Context<{ Bindings: Env; Variables: SupabaseAuthContext }>
) {
  // Get auth context set by middleware
  const authUserId = c.get('authUserId');   // auth.users.id
  const profileId = c.get('profileId');     // user_profiles.id
  const userRole = c.get('userRole');       // role
  const userClient = c.get('userClient');   // Supabase client with JWT
  
  // Use userClient for RLS-protected queries
  const { data } = await userClient.query('stores', {
    filters: { owner_id: profileId }
  });
}
```

**File:** `src/middleware/supabaseAuthMiddleware.ts`

---

### `requireRole(['merchant', 'admin'])`

**Purpose:** Check user has specific role(s)

**Usage:**
```typescript
import { supabaseAuthMiddleware, requireRole } from './middleware/supabaseAuthMiddleware';

// Only merchants can create products
app.post('/secure/products', 
  supabaseAuthMiddleware,
  requireRole(['merchant', 'admin']),
  createProduct
);
```

**File:** `src/middleware/supabaseAuthMiddleware.ts:requireRole()`

---

## 🔌 Supabase Clients

### 📘 userClient (RLS Active)

**Purpose:** User-scoped operations respecting RLS policies

**Configuration:**
```typescript
// src/utils/supabaseUser.ts
export function createUserSupabaseClient(env: Env, userJwt: string) {
  return {
    url: env.SUPABASE_URL,
    key: env.SUPABASE_ANON_KEY,      // ✅ ANON key
    headers: {
      'Authorization': `Bearer ${userJwt}`,  // ✅ User's JWT
      'apikey': env.SUPABASE_ANON_KEY
    }
  };
}
```

**Usage:**
```typescript
// In middleware: create and set in context
const userClient = createUserSupabaseClient(c.env, token);
c.set('userClient', userClient);

// In endpoint: retrieve from context
const userClient = c.get('userClient');

// Query with RLS
const { data } = await userClient.query('user_profiles', {
  method: 'GET',
  filters: { auth_user_id: authUserId }
});
// RLS ensures user can only see their own profile
```

**RLS Behavior:**
- ✅ Users can view/update their own `user_profiles`
- ✅ Merchants can view/manage their own `stores`
- ✅ Merchants can view/manage products in their `stores`
- ❌ Users CANNOT see other users' data
- ❌ Customers CANNOT create stores (role check in RLS)

**File:** `src/utils/supabaseUser.ts`

---

### 🔴 adminClient (RLS Bypassed)

**Purpose:** System-wide operations (admin only)

**Configuration:**
```typescript
// src/utils/supabaseAdmin.ts
export function createAdminSupabaseClient(env: Env) {
  return {
    url: env.SUPABASE_URL,
    key: env.SUPABASE_SERVICE_ROLE_KEY,  // ⚠️ SERVICE_ROLE key
    headers: {
      'Authorization': `Bearer ${env.SUPABASE_SERVICE_ROLE_KEY}`,
      'apikey': env.SUPABASE_SERVICE_ROLE_KEY
    }
  };
}
```

**⚠️ CRITICAL WARNING:**
- Bypasses ALL RLS policies
- Full database access
- ONLY use for:
  - Auth operations (register, login)
  - Admin reports
  - System cleanup tasks
  - Internal/cron endpoints
- NEVER use for user-facing endpoints

**Usage:**
```typescript
// ONLY in auth endpoints or admin routes
const adminClient = createAdminSupabaseClient(c.env);

// Create user (bypasses RLS)
const { data } = await adminClient.auth.admin.createUser({
  email, password
});
```

**File:** `src/utils/supabaseAdmin.ts`

---

## 📊 Complete Request Flow Examples

### Example 1: User Registration

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Flutter sends POST /auth/supabase/register              │
│    Body: { email, password, full_name, role: 'merchant' }  │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. Worker validates input                                   │
│    - Email format                                           │
│    - Password strength (min 6 chars)                        │
│    - Role valid ('customer', 'merchant', 'admin')           │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. Worker creates adminClient (SERVICE_ROLE_KEY)            │
│    Calls: supabaseAdmin.auth.admin.createUser()             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. Supabase Auth creates row in auth.users                  │
│    auth.users:                                              │
│    - id: uuid-generated                                     │
│    - email: merchant@example.com                            │
│    - encrypted_password: bcrypt hash                        │
│    - raw_user_meta_data: { full_name, role }                │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. Trigger: handle_new_auth_user() fires (AFTER INSERT)    │
│    Creates user_profiles row:                               │
│    - id: new uuid                                           │
│    - auth_user_id: auth.users.id                            │
│    - email: merchant@example.com                            │
│    - display_name: John Merchant                            │
│    - role: 'merchant' (from metadata)                       │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 6. Worker waits 100ms for trigger to complete               │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 7. Worker auto-logs in user:                                │
│    supabaseAdmin.auth.signInWithPassword()                  │
│    Returns: access_token, refresh_token                     │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 8. Worker fetches user_profiles:                            │
│    SELECT * FROM user_profiles                              │
│    WHERE auth_user_id = 'uuid-from-auth-users'              │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 9. Worker returns to Flutter:                               │
│    {                                                        │
│      access_token: "eyJhbG...",                             │
│      user: { id, email },                                   │
│      profile: { id, role, display_name }                    │
│    }                                                        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 10. Flutter stores JWT in secure storage                    │
│     All future requests include:                            │
│     Authorization: Bearer <JWT>                             │
└─────────────────────────────────────────────────────────────┘
```

---

### Example 2: Create Store (Merchant)

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Flutter sends POST /secure/merchant/store               │
│    Authorization: Bearer eyJhbG...                          │
│    Body: { name, description, city }                        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. Worker: supabaseAuthMiddleware extracts JWT              │
│    - Calls Supabase: GET /auth/v1/user                      │
│    - Verifies JWT signature and expiration                  │
│    - Extracts: id = auth.users.id                           │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. Middleware fetches user_profiles:                        │
│    SELECT id, role FROM user_profiles                       │
│    WHERE auth_user_id = 'uuid-from-jwt'                     │
│                                                             │
│    Result:                                                  │
│    - profileId: uuid-profile-id                             │
│    - role: 'merchant'                                       │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. Middleware sets context:                                 │
│    c.set('authUserId', 'uuid-auth-users-id')                │
│    c.set('profileId', 'uuid-profile-id')                    │
│    c.set('userRole', 'merchant')                            │
│    c.set('userClient', userClient)                          │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. Endpoint: createMerchantStore()                          │
│    Gets context:                                            │
│    - profileId = c.get('profileId')                         │
│    - userRole = c.get('userRole')                           │
│    - userClient = c.get('userClient')                       │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 6. Endpoint validates:                                      │
│    - userRole === 'merchant' ✅                             │
│    - No existing store for this profileId                   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 7. Endpoint creates store using userClient:                 │
│    INSERT INTO stores (owner_id, name, description)         │
│    VALUES ('uuid-profile-id', 'Store Name', '...')          │
│                                                             │
│    RLS Policy checks:                                       │
│    - owner_id matches authenticated user's profileId ✅     │
│    - userRole is 'merchant' or 'admin' ✅                   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 8. Database creates store row:                              │
│    stores:                                                  │
│    - id: new uuid (store_id)                                │
│    - owner_id: uuid-profile-id (FK to user_profiles)        │
│    - name: 'Store Name'                                     │
│    - is_active: true                                        │
│    - created_at: NOW()                                      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 9. Worker returns to Flutter:                               │
│    {                                                        │
│      ok: true,                                              │
│      store: {                                               │
│        id: "uuid-store-id",                                 │
│        name: "Store Name",                                  │
│        owner_id: "uuid-profile-id"                          │
│      }                                                      │
│    }                                                        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ Identity Chain Complete:                                    │
│                                                             │
│ auth.users.id (UUID-1)                                      │
│        ↓                                                    │
│ user_profiles.auth_user_id = UUID-1                         │
│ user_profiles.id = UUID-2                                   │
│        ↓                                                    │
│ stores.owner_id = UUID-2                                    │
│ stores.id = UUID-3                                          │
│        ↓                                                    │
│ products.store_id = UUID-3 (future)                         │
└─────────────────────────────────────────────────────────────┘
```

---

### Example 3: Get Merchant Products

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Flutter sends GET /secure/products                       │
│    Authorization: Bearer eyJhbG...                          │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. supabaseAuthMiddleware verifies JWT                      │
│    Sets context: authUserId, profileId, userRole            │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. getMerchantProducts() endpoint:                          │
│    profileId = c.get('profileId')                           │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. Query stores to get storeId:                             │
│    SELECT id FROM stores WHERE owner_id = profileId         │
│    RLS: Only returns stores owned by authenticated user     │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. Query products:                                          │
│    SELECT * FROM products WHERE store_id = storeId          │
│    RLS: Only returns products from user's store             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 6. Return products list to Flutter                          │
└─────────────────────────────────────────────────────────────┘
```

---

## 📁 File Structure

```
mbuy-worker/src/
├── middleware/
│   └── supabaseAuthMiddleware.ts      # JWT verification + context setup
├── endpoints/
│   ├── supabaseAuth.ts                # Auth endpoints (register, login, logout)
│   ├── store.ts                       # Store management
│   └── products.ts                    # Product management
├── utils/
│   ├── supabaseUser.ts                # userClient (RLS active)
│   └── supabaseAdmin.ts               # adminClient (admin only)
├── types.ts                           # TypeScript interfaces
└── index.ts                           # Route definitions
```

---

## 🔒 Security Best Practices

### ✅ DO:
1. **Always use supabaseAuthMiddleware** for protected routes
2. **Use userClient** for user-scoped operations
3. **Verify role** before sensitive operations (requireRole middleware)
4. **Return minimal data** in responses (don't expose internal IDs unnecessarily)
5. **Log auth failures** for security monitoring

### ❌ DON'T:
1. **Never bypass middleware** for authenticated routes
2. **Never use adminClient** for user operations
3. **Never trust client-provided IDs** (always use profileId from context)
4. **Never expose SERVICE_ROLE_KEY** to client
5. **Never store JWT in localStorage** (Flutter: use secure storage)

---

## 🧪 Testing

### Test Registration:
```bash
curl -X POST https://worker-url/auth/supabase/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@mbuy.com",
    "password": "test123456",
    "full_name": "Test User",
    "role": "merchant"
  }'
```

### Test Login:
```bash
curl -X POST https://worker-url/auth/supabase/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@mbuy.com",
    "password": "test123456"
  }'
```

### Test Protected Route:
```bash
JWT="eyJhbG..." # From login response

curl -X GET https://worker-url/secure/users/me \
  -H "Authorization: Bearer $JWT"
```

---

## 📚 Related Documentation

- **Golden Plan:** `docs/MBUY_ARCHITECTURE_REFERENCE.md`
- **Database Migrations:** `mbuy-backend/supabase/migrations/MIGRATION_README.md`
- **RLS Policies:** `mbuy-backend/supabase/migrations/20251211120003_rls_policies.sql`
- **Cleanup Report:** `docs/GOLDEN_PLAN_CLEANUP_REPORT.md`

---

## ✅ Checklist: Is My Endpoint Golden Plan Compliant?

- [ ] Uses `supabaseAuthMiddleware` (not legacy middleware)
- [ ] Gets `profileId` from context (not from request body)
- [ ] Uses `userClient` for database operations (RLS active)
- [ ] Verifies `userRole` before role-specific operations
- [ ] NO references to `mbuy_users`, `mbuy_sessions`, `profiles`, `merchants`
- [ ] Uses identity chain: `auth.users → user_profiles → stores → products`
- [ ] Returns appropriate error codes (401 for auth, 403 for role, 404 for not found)

---

**🎯 This is the definitive Auth flow for MBUY Worker. All endpoints must follow this pattern.**
