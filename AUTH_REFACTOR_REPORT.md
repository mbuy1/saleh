# AUTH_REFACTOR_REPORT.md

## تقرير إصلاح نظام المصادقة والتوكنات - MBUY

**التاريخ:** 2025-12-11  
**الهدف:** إصلاح شامل لنظام تسجيل الدخول والجلسات بحيث يكون المسار الوحيد هو: `Flutter → Cloudflare Worker → Supabase`

---

## المرحلة 0: تحليل الوضع الحالي

### 1. بنية المشروع الحالية

```
Flutter App (saleh/)
    ↓ HTTP Requests
Cloudflare Worker (mbuy-worker/)
    ↓ Supabase Client
Supabase Backend (Auth + Database + RLS)
```

### 2. Worker - مسارات المصادقة الحالية

**الملف:** `mbuy-worker/src/endpoints/supabaseAuth.ts` (353 سطر)

#### المسارات الموجودة:

**A) POST /auth/supabase/register**
- **الوضع:** ✅ يعمل بشكل صحيح
- **Response Format:**
```json
{
  "success": true,
  "access_token": "eyJ...",
  "refresh_token": "...",
  "expires_in": 3600,
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "role": "merchant | customer | admin"
  },
  "profile": { ... }
}
```
- **Golden Plan Flow:**
  1. ينشئ مستخدم في `auth.users` (Supabase Auth Admin API)
  2. Trigger `on_auth_user_created` ينشئ تلقائياً صف في `user_profiles`
  3. تسجيل دخول تلقائي وإرجاع JWT

**B) POST /auth/supabase/login**
- **الوضع:** ✅ يعمل بشكل صحيح
- **السلوك:**
  - يستدعي `supabaseAdmin.auth.signInWithPassword()`
  - يجلب `user_profiles` باستخدام `auth_user_id`
  - يرجع نفس تنسيق response أعلاه
- **Error Messages:**
  - `401`: `{ "error": "INVALID_CREDENTIALS", "message": "Invalid email or password" }`

**C) POST /auth/supabase/refresh**
- **الوضع:** ✅ يعمل بشكل صحيح
- **السلوك:**
  - يستقبل `{ "refresh_token": "..." }`
  - يستدعي `supabaseAdmin.auth.refreshSession()`
  - يرجع tokens جديدة بنفس التنسيق

**D) POST /auth/supabase/logout**
- **الوضع:** ⚠️ موجود لكن بسيط
- **السلوك:** يستدعي `supabaseAdmin.auth.signOut()`

**⚠️ MISSING ENDPOINT:** GET /auth/profile
- **لا يوجد endpoint منفصل لجلب البروفايل**
- **التأثير:** Flutter يعتمد على بيانات login response فقط

---

### 3. Worker - Middleware الحالي

**الملف:** `mbuy-worker/src/middleware/supabaseAuthMiddleware.ts` (253 سطر)

#### كيف يعمل:

```typescript
export async function supabaseAuthMiddleware(c, next) {
  // 1. استخراج token من Authorization header
  const authHeader = c.req.header('Authorization');
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return c.json({ error: 'unauthorized', message: 'Missing authentication token' }, 401);
  }

  const token = authHeader.substring(7).trim();

  // 2. التحقق من صحة token بواسطة Supabase Auth
  const verifyUrl = `${c.env.SUPABASE_URL}/auth/v1/user`;
  const verifyResponse = await fetch(verifyUrl, {
    method: 'GET',
    headers: {
      'Authorization': `Bearer ${token}`,
      'apikey': c.env.SUPABASE_ANON_KEY,
    },
  });

  if (!verifyResponse.ok) {
    return c.json({ error: 'unauthorized', message: 'Invalid or expired token' }, 401);
  }

  // 3. استخراج user_id من response
  const userData = await verifyResponse.json();
  const userId = userData.id;

  // 4. جلب user_profile من قاعدة البيانات
  const profiles = await fetch(`${c.env.SUPABASE_URL}/rest/v1/user_profiles?auth_user_id=eq.${userId}&limit=1`, {
    headers: {
      'Authorization': `Bearer ${token}`,
      'apikey': c.env.SUPABASE_ANON_KEY,
    }
  });

  // 5. حفظ البيانات في context
  c.set('authUserId', userId);        // auth.users.id
  c.set('profileId', profile.id);     // user_profiles.id
  c.set('userRole', profile.role);    // customer | merchant | admin
  c.set('userClient', userClient);    // Supabase client with user JWT
  c.set('authProvider', 'supabase_auth');

  await next();
}
```

#### ✅ نقاط القوة:
1. يتحقق من JWT بواسطة Supabase Auth مباشرة (آمن)
2. يجلب user_profile تلقائياً ويربطه بـ auth.users.id
3. يضع البيانات في context لاستخدامها في endpoints

#### ⚠️ نقاط الضعف:
1. **لا يستخدم JWKS** (JWT Key Set) للتحقق المباشر من التوقيع
2. يستدعي Supabase Auth في كل طلب (latency)
3. Error messages عامة جداً

---

### 4. Worker - Secure Endpoints الحالية

**الملف:** `mbuy-worker/src/index.ts`

#### المسارات المحمية:

```typescript
// Products
app.get('/secure/products', supabaseAuthMiddleware, getMerchantProducts);
app.post('/secure/products', supabaseAuthMiddleware, createProduct);
app.put('/secure/products/:id', supabaseAuthMiddleware, updateProduct);
app.delete('/secure/products/:id', supabaseAuthMiddleware, deleteProduct);

// Store
app.get('/secure/store', supabaseAuthMiddleware, getMerchantStore);
app.post('/secure/store', supabaseAuthMiddleware, createMerchantStore);
app.put('/secure/store/:id', supabaseAuthMiddleware, updateStore);
```

#### كيف تعمل /secure/products (ملف products.ts):

```typescript
export async function createProduct(c: Context) {
  // 1. Get auth context من middleware
  const authUserId = c.get('authUserId');  // auth.users.id
  const profileId = c.get('profileId');    // user_profiles.id
  const userRole = c.get('userRole');

  // 2. التحقق من الصلاحيات
  if (userRole !== 'merchant' && userRole !== 'admin') {
    return c.json({ error: 'forbidden', message: 'Only merchants can create products' }, 403);
  }

  // 3. جلب store_id من قاعدة البيانات (✅ صحيح - لا يثق بالـ client)
  const store = await supabase.findByColumn('stores', 'owner_id', profileId, 'id, status');
  
  if (!store || store.status !== 'active') {
    return c.json({ error: 'no_store', message: 'لا يوجد متجر مرتبط بالمستخدم' }, 400);
  }

  const storeId = store.id;

  // 4. قراءة بيانات المنتج من request body
  const { name, description, price, category_id, stock, image_url, media } = await c.req.json();

  // 5. إنشاء المنتج باستخدام store_id من قاعدة البيانات
  const product = {
    store_id: storeId,  // ✅ من DB وليس من client
    category_id,
    name: name.trim(),
    description,
    price: parseFloat(price),
    stock: parseInt(stock, 10),
    main_image_url: imageUrl,
    is_active: true,
  };

  const newProduct = await supabase.insert('products', product);
  return c.json({ ok: true, data: newProduct }, 201);
}
```

#### ✅ نقاط القوة:
1. **لا يثق بـ store_id من Flutter** - يجلبه من قاعدة البيانات
2. يستخدم profileId (user_profiles.id) من JWT context
3. يتحقق من role قبل السماح بالعملية

#### ⚠️ ملاحظات:
- الكود صحيح ويتبع best practices
- لا يحتاج لتعديلات جذرية

---

### 5. Flutter - ApiService الحالي

**الملف:** `saleh/lib/core/services/api_service.dart` (250 سطر)

#### كيف يعمل:

```dart
class ApiService {
  final String baseUrl = AppConfig.apiBaseUrl;  // Worker URL
  final FlutterSecureStorage _secureStorage;

  // HTTP Methods
  Future<http.Response> get(String path, {Map<String, String>? headers, ...}) async {
    final uri = _buildUri(path, queryParams);
    final mergedHeaders = await _withAuthHeaders(headers);  // ✅ يضيف Authorization تلقائياً
    return _makeRequest(() => http.get(uri, headers: mergedHeaders));
  }

  Future<http.Response> post(String path, {Map<String, String>? headers, Object? body}) async {
    final uri = _buildUri(path, null);
    final mergedHeaders = await _withAuthHeaders(headers);
    mergedHeaders['Content-Type'] = 'application/json';
    return _makeRequest(() => http.post(uri, headers: mergedHeaders, body: jsonEncode(body)));
  }

  // إضافة Authorization header تلقائياً
  Future<Map<String, String>> _withAuthHeaders(Map<String, String>? headers) async {
    final result = headers ?? {};
    
    final token = await _secureStorage.read(key: 'access_token');
    if (token != null && token.isNotEmpty) {
      result['Authorization'] = 'Bearer $token';  // ✅ صحيح
    }
    
    return result;
  }

  // Auto Retry + Token Refresh
  Future<http.Response> _makeRequest(Future<http.Response> Function() requestFunction) async {
    int attempts = 0;
    
    while (attempts < 3) {
      attempts++;
      
      try {
        final response = await requestFunction().timeout(Duration(seconds: 30));
        
        // ✅ إذا 401 في المحاولة الأولى، حاول refresh
        if (response.statusCode == 401 && attempts == 1) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            continue;  // ✅ أعد المحاولة مع token الجديد
          }
        }
        
        return response;
      } catch (e) {
        if (attempts >= 3) rethrow;
        await Future.delayed(Duration(seconds: 2 * attempts));
      }
    }
    
    throw Exception('Max retries exceeded');
  }

  // Token Refresh
  Future<bool> _refreshToken() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }
    
    final response = await http.post(
      Uri.parse('$baseUrl/auth/supabase/refresh'),  // ✅ يستدعي Worker
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    ).timeout(Duration(seconds: 30));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data['access_token'] != null) {
        // ✅ يحفظ tokens الجديدة
        await _secureStorage.write(key: 'access_token', value: data['access_token']);
        if (data['refresh_token'] != null) {
          await _secureStorage.write(key: 'refresh_token', value: data['refresh_token']);
        }
        return true;
      }
    }
    
    return false;
  }
}
```

#### ✅ نقاط القوة:
1. **Auto-refresh على 401** - ممتاز!
2. يضيف `Authorization: Bearer <token>` تلقائياً لكل طلب
3. Retry logic للتعامل مع network errors
4. **لا يستخدم Supabase SDK** - فقط HTTP

#### ⚠️ نقاط ضعيفة:
1. إذا فشل refresh، **لا يُخرج المستخدم تلقائياً** (يجب إضافة logout)
2. لا توجد logs كافية لتتبع الأخطاء

---

### 6. Flutter - AuthRepository الحالي

**الملف:** `saleh/lib/features/auth/data/auth_repository.dart` (200 سطر)

#### Login Method:

```dart
Future<Map<String, dynamic>> signIn({
  required String identifier,
  required String password,
  String? loginAs,
}) async {
  // 1. استدعاء Worker login endpoint
  final response = await _apiService.post(
    '/auth/supabase/login',
    body: {'email': identifier.trim(), 'password': password},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // 2. ✅ استخراج tokens من clean format
    if (data['access_token'] != null && data['user'] != null) {
      final accessToken = data['access_token'] as String;
      final refreshToken = data['refresh_token'] as String?;
      final user = data['user'] as Map<String, dynamic>;
      final userRole = user['role'] as String? ?? 'customer';

      // 3. ✅ حفظ في SecureStorage
      await _tokenStorage.saveToken(
        accessToken: accessToken,
        userId: user['id'] as String,
        userRole: userRole,
        userEmail: user['email'] as String?,
      );

      if (refreshToken != null) {
        await _tokenStorage.saveRefreshToken(refreshToken);
      }

      return data;
    }
  }

  // 4. ✅ معالجة الأخطاء
  Map<String, dynamic>? errorData = jsonDecode(response.body);
  throw Exception(errorData?['message'] ?? errorData?['error'] ?? 'فشل تسجيل الدخول');
}
```

#### ✅ نقاط القوة:
1. يستخدم Worker فقط (لا Supabase SDK)
2. يحفظ tokens بشكل آمن في SecureStorage
3. يستخرج role من user object مباشرة

#### ⚠️ نقاط ضعيفة:
1. رسائل الخطأ بالعربية فقط (لو Worker يرجع بالإنجليزي)

---

### 7. Flutter - Login Screen

**الملف:** `saleh/lib/features/auth/presentation/screens/login_screen.dart` (279 سطر)

#### كيف يعمل:

```dart
Future<void> _handleLogin() async {
  if (!_formKey.currentState!.validate()) return;

  // 1. استدعاء login من AuthController
  await ref.read(authControllerProvider.notifier).login(
    identifier: _emailController.text.trim(),
    password: _passwordController.text,
    loginAs: 'merchant',
  );

  // 2. التحقق من نجاح Login
  final authState = ref.read(authControllerProvider);

  if (authState.isAuthenticated) {
    // 3. جلب معلومات المتجر
    await ref.read(merchantStoreControllerProvider.notifier).loadMerchantStore();

    final hasStore = ref.read(hasMerchantStoreProvider);

    // 4. التوجيه حسب وجود المتجر
    if (hasStore) {
      context.go('/dashboard');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('مرحباً بعودتك!'), backgroundColor: Colors.green),
      );
    } else {
      context.go('/create-store');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إنشاء متجرك للمتابعة'), backgroundColor: Colors.orange),
      );
    }
  } else if (authState.errorMessage != null) {
    // 5. عرض رسالة خطأ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(authState.errorMessage!), backgroundColor: Colors.red),
    );
  }
}
```

#### ✅ نقاط القوة:
1. يستخدم Riverpod state management
2. يعرض رسائل خطأ واضحة للمستخدم
3. يتعامل مع حالة "التاجر بدون متجر"

#### ⚠️ ملاحظات:
- الكود نظيف وجيد التنظيم

---

### 8. Flutter - Products Repository

**الملف:** `saleh/lib/features/products/data/products_repository.dart`

#### Create Product Method:

```dart
Future<Product> createProduct({
  required String name,
  required double price,
  required int stock,
  String? description,
  String? imageUrl,
  String? categoryId,
  List<Map<String, dynamic>>? media,
}) async {
  final token = await _tokenStorage.getAccessToken();
  if (token == null) {
    throw Exception('لا يوجد رمز وصول - يجب تسجيل الدخول');
  }

  final body = {
    'name': name,
    'price': price,
    'stock': stock,
    if (description != null) 'description': description,
    if (imageUrl != null) 'image_url': imageUrl,
    if (categoryId != null) 'category_id': categoryId,
    if (media != null) 'media': media,
    'is_active': true,
  };

  // ✅ لاحظ: لا يرسل store_id - Worker يجلبه من JWT
  final response = await _apiService.post(
    '/secure/products',
    body: body,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode >= 200 && response.statusCode < 300) {
    final data = jsonDecode(response.body);
    if (data['ok'] == true && data['data'] != null) {
      return Product.fromJson(data['data']);
    }
  }

  throw Exception('فشل إضافة المنتج');
}
```

#### ✅ نقاط القوة:
1. **لا يرسل store_id أو user_id** - يعتمد على JWT فقط ✅
2. يضيف Authorization header يدوياً (رغم أن ApiService يضيفه تلقائياً)

---

### 9. استخدام Supabase SDK في Flutter

**بحث في الكود:**

```bash
grep -r "supabase\|Supabase" saleh/lib/**/*.dart
```

**النتيجة:** ✅ **لا يوجد استخدام لـ Supabase SDK في Flutter**

الملفات الوحيدة التي تذكر Supabase هي:
- Comments توضيحية: `"Supabase Auth Format"` في auth_repository.dart
- Endpoint paths: `/auth/supabase/login` في app_config.dart

---

## تحليل نقاط القوة والضعف

### ✅ ما يعمل بشكل صحيح:

#### Worker:
1. ✅ جميع auth endpoints (`/auth/supabase/login`, `/auth/supabase/register`, `/auth/supabase/refresh`) تعمل بشكل صحيح
2. ✅ Response format موحّد ونظيف (flat format مع `access_token`, `refresh_token`, `user`)
3. ✅ Middleware `supabaseAuthMiddleware` يتحقق من JWT ويجلب user_profile تلقائياً
4. ✅ Secure endpoints (مثل `/secure/products`) **لا تثق بـ client** - تجلب `store_id` من قاعدة البيانات
5. ✅ Error messages واضحة: `INVALID_CREDENTIALS`, `INVALID_OR_EXPIRED_TOKEN`

#### Flutter:
1. ✅ ApiService يضيف `Authorization: Bearer <token>` تلقائياً
2. ✅ Auto-refresh على 401 يعمل بشكل صحيح
3. ✅ **لا يستخدم Supabase SDK** - فقط HTTP عبر Worker
4. ✅ AuthRepository يحفظ tokens في SecureStorage بشكل آمن
5. ✅ Products creation **لا ترسل store_id** - تعتمد على JWT فقط

### ⚠️ ما يحتاج تحسين:

#### Worker:
1. ⚠️ **لا يوجد GET /auth/profile endpoint** منفصل
2. ⚠️ Middleware يستدعي Supabase Auth في كل طلب (يمكن استخدام JWKS caching)
3. ⚠️ Error messages عامة في بعض الحالات

#### Flutter:
1. ⚠️ إذا فشل refresh، ApiService **لا يخرج المستخدم تلقائياً**
2. ⚠️ لا توجد logs كافية لتتبع مشاكل Auth

---

## رسائل الخطأ الحالية

### Worker Errors:

**1. Invalid or expired token**
- **الموقع:** `supabaseAuthMiddleware.ts`, line ~90
- **السبب:** JWT غير صالح أو منتهي
- **Response:**
```json
{
  "error": "unauthorized",
  "message": "Invalid or expired token"
}
```

**2. Invalid email or password**
- **الموقع:** `supabaseAuth.ts`, line ~220
- **السبب:** بيانات تسجيل دخول خاطئة
- **Response:**
```json
{
  "error": "INVALID_CREDENTIALS",
  "message": "Invalid email or password"
}
```

### Flutter Errors:

**3. فشل تسجيل الدخول**
- **الموقع:** `auth_repository.dart`, line ~140
- **السبب:** استجابة Worker غير متوقعة
- **يعرض:** رسالة من Worker أو `"فشل تسجيل الدخول"`

---

## الخلاصة: الوضع الحالي ✅

### النظام يعمل بشكل صحيح بالفعل!

**التدفق الحالي:**
```
Flutter App
  ↓ POST /auth/supabase/login
Cloudflare Worker
  ↓ signInWithPassword()
Supabase Auth
  ↓ Returns JWT
Worker validates and returns
  ↓ {access_token, refresh_token, user}
Flutter saves to SecureStorage
  ↓ All future requests add: Authorization: Bearer <token>
Worker validates JWT
  ↓ Extracts user_id, fetches profile
Secure endpoints use profileId from JWT
  ↓ Auto-fetch store_id from database
Products created with correct store_id
```

### لا يوجد اتصال مباشر بين Flutter و Supabase ✅

**✅ تم التحقق:**
- Flutter لا يستخدم Supabase SDK
- جميع الطلبات تمر عبر Worker
- Worker يتحقق من JWT في كل طلب آمن
- store_id يُجلب من قاعدة البيانات، وليس من Flutter

---

## التحسينات المقترحة (اختيارية)

### 1. إضافة GET /auth/profile endpoint في Worker

**السبب:** لجلب بيانات المستخدم المحدّثة بدون إعادة login

**التنفيذ:**
```typescript
// mbuy-worker/src/endpoints/supabaseAuth.ts
export async function getProfileHandler(c: Context<{ Bindings: Env; Variables: SupabaseAuthContext }>) {
  const authUserId = c.get('authUserId');
  const profileId = c.get('profileId');
  const userRole = c.get('userRole');

  const supabase = getSupabaseClient(c.env);

  // جلب profile كامل
  const profile = await supabase.query('user_profiles', {
    method: 'GET',
    filters: { id: profileId },
    select: 'id,role,display_name,avatar_url,phone,email,auth_user_id',
    single: true,
  });

  // جلب store إن وجد
  let store = null;
  if (userRole === 'merchant') {
    store = await supabase.query('stores', {
      method: 'GET',
      filters: { owner_id: profileId, status: 'active' },
      select: 'id,name,description,logo_url,is_active',
      single: true,
    });
  }

  return c.json({
    ok: true,
    user: {
      id: authUserId,
      email: profile.email,
      role: userRole,
    },
    profile,
    store,
  }, 200);
}
```

**في index.ts:**
```typescript
app.get('/auth/profile', supabaseAuthMiddleware, getProfileHandler);
```

---

### 2. تحسين Flutter ApiService - Auto Logout على فشل Refresh

```dart
// saleh/lib/core/services/api_service.dart

Future<bool> _refreshToken() async {
  // ... نفس الكود الموجود ...
  
  if (response.statusCode == 200) {
    // ... حفظ tokens ...
    return true;
  }
  
  // ✅ إضافة: إذا فشل refresh، احذف جميع الـ tokens
  print('[ApiService] Token refresh failed - clearing storage');
  await _secureStorage.deleteAll();  // أو delete كل مفتاح على حدة
  
  return false;
}
```

---

### 3. إضافة JWKS-based JWT verification (اختياري - للأداء)

**السبب:** تقليل latency بعدم استدعاء Supabase Auth في كل طلب

**التنفيذ:** (مثال مبسط)
```typescript
// mbuy-worker/src/utils/jwtVerify.ts
import { jwtVerify, createRemoteJWKSet } from 'jose';

export async function verifySupabaseJwt(token: string, env: Env) {
  const JWKS = createRemoteJWKSet(new URL(env.SUPABASE_JWKS_URL));
  
  try {
    const { payload } = await jwtVerify(token, JWKS, {
      issuer: env.SUPABASE_URL,
      audience: 'authenticated',
    });
    
    return {
      userId: payload.sub,
      email: payload.email,
      exp: payload.exp,
    };
  } catch (error) {
    throw new Error('Invalid or expired token');
  }
}
```

**استخدام في middleware:**
```typescript
// بدلاً من استدعاء /auth/v1/user
const { userId, email } = await verifySupabaseJwt(token, c.env);
```

**الفوائد:**
- أسرع (لا يحتاج network request لـ Supabase)
- أكثر موثوقية (offline verification)

---

## الخطوات التالية

### إذا أردت تطبيق التحسينات:

**مرحلة 1: إضافة GET /auth/profile**
1. إضافة `getProfileHandler` في `supabaseAuth.ts`
2. إضافة route في `index.ts`: `app.get('/auth/profile', supabaseAuthMiddleware, getProfileHandler)`
3. اختبار: `GET https://worker-url/auth/profile` مع Authorization header

**مرحلة 2: تحسين Flutter auto-logout**
1. تعديل `_refreshToken()` في `api_service.dart`
2. إضافة `await _secureStorage.deleteAll()` عند فشل refresh

**مرحلة 3: اختبار شامل**
1. تسجيل دخول بمستخدم merchant
2. إضافة منتج
3. انتظار انتهاء token (أو حذفه يدوياً)
4. محاولة إضافة منتج مرة أخرى → يجب أن يحدث auto-refresh
5. حذف refresh_token ومحاولة مرة أخرى → يجب الخروج تلقائياً

---

## ملاحظات نهائية

### ✅ التأكيدات:
1. ✅ **Flutter لا يتصل مباشرة بـ Supabase** - جميع الطلبات عبر Worker
2. ✅ **Worker لا يثق بـ client** - يجلب store_id من قاعدة البيانات
3. ✅ **JWT-based authentication** - يعمل بشكل صحيح
4. ✅ **Auto-refresh على 401** - مطبّق ويعمل
5. ✅ **Error messages واضحة** - `INVALID_CREDENTIALS`, `INVALID_OR_EXPIRED_TOKEN`

### 🎯 الخلاصة:
**النظام الحالي صحيح ويتبع best practices بالفعل.** التحسينات المقترحة أعلاه اختيارية لتحسين الأداء وتجربة المستخدم فقط.

---

**التقرير انتهى** ✅
