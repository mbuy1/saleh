# 🔐 Auth Design Document - MBUY Platform

## نظرة عامة

نظام مصادقة مخصص باستخدام JWT من Worker (بدون Supabase Auth).

---

## 1. أنواع المستخدمين (UserType)

| النوع | الجدول | الوصف |
|-------|--------|-------|
| `customer` | `customers` | العملاء/المشترون |
| `merchant` | `merchants` | أصحاب المتاجر |
| `merchant_user` | `merchant_users` | موظفو المتجر |
| `admin` | `admin_staff` | مدراء النظام |
| `support` | `admin_staff` | دعم فني |
| `moderator` | `admin_staff` | مشرفون |
| `owner` | `admin_staff` | المالك (صلاحيات كاملة) |

---

## 2. JWT Payload Structure

```typescript
interface JWTPayload {
  userId: string;          // UUID من الجدول المعني
  userType: UserType;      // نوع المستخدم
  email: string;           // البريد الإلكتروني
  merchantId?: string;     // للتجار وموظفيهم فقط
  permissions?: string[];  // صلاحيات إضافية
  iat: number;             // وقت الإصدار
  exp: number;             // وقت الانتهاء
}
```

---

## 3. سلسلة الهوية (Identity Chain)

```
JWT Token
    ↓
AuthMiddleware (يفك الـ JWT)
    ↓
Context Variables:
  - userId
  - userType  
  - merchantId (للتجار)
    ↓
RoleMiddleware (يتحقق من الصلاحيات)
    ↓
Endpoint Handler
```

---

## 4. الصلاحيات (Permissions)

### 4.1 صلاحيات التاجر (Merchant)
- `products:read` - عرض المنتجات
- `products:write` - إضافة/تعديل المنتجات
- `products:delete` - حذف المنتجات
- `orders:read` - عرض الطلبات
- `orders:update` - تحديث حالة الطلبات
- `customers:read` - عرض العملاء
- `inventory:read` - عرض المخزون
- `inventory:write` - تعديل المخزون
- `reports:read` - عرض التقارير
- `settings:read` - عرض الإعدادات
- `settings:write` - تعديل الإعدادات
- `users:read` - عرض الموظفين
- `users:write` - إدارة الموظفين

### 4.2 صلاحيات موظف المتجر (MerchantUser)
تُحدد عند إضافة الموظف من قبل صاحب المتجر.

### 4.3 صلاحيات الإدارة (Admin)
- `platform:read` - عرض بيانات المنصة
- `platform:write` - تعديل إعدادات المنصة
- `merchants:read` - عرض التجار
- `merchants:write` - إدارة التجار
- `merchants:approve` - الموافقة على التجار
- `customers:manage` - إدارة العملاء
- `support:read` - عرض التذاكر
- `support:write` - الرد على التذاكر

---

## 5. Middleware Stack

```
Request
    ↓
[1] rateLimiter         - حماية من الطلبات الزائدة
    ↓
[2] requestLogger       - تسجيل الطلبات
    ↓
[3] authMiddleware      - فك JWT وتحديد المستخدم
    ↓
[4] roleMiddleware      - التحقق من الصلاحيات ← جديد
    ↓
[5] Endpoint Handler
```

---

## 6. Role Middleware Design

### 6.1 الاستخدام المتوقع

```typescript
// أي مستخدم مسجل
app.get('/secure/profile', authMiddleware, handler);

// تاجر فقط
app.get('/secure/merchant/*', authMiddleware, requireRole(['merchant']), handler);

// تاجر أو موظف
app.get('/secure/products', authMiddleware, requireRole(['merchant', 'merchant_user']), handler);

// مع صلاحية محددة
app.post('/secure/products', authMiddleware, requirePermission('products:write'), handler);

// أدمن فقط
app.get('/admin/*', authMiddleware, requireRole(['admin', 'owner']), handler);
```

### 6.2 الدوال المطلوبة

```typescript
// التحقق من نوع المستخدم
function requireRole(allowedRoles: UserType[]): MiddlewareHandler

// التحقق من صلاحية محددة
function requirePermission(permission: string): MiddlewareHandler

// التحقق من عدة صلاحيات (AND)
function requireAllPermissions(permissions: string[]): MiddlewareHandler

// التحقق من إحدى الصلاحيات (OR)
function requireAnyPermission(permissions: string[]): MiddlewareHandler

// التحقق من ملكية المورد
function requireOwnership(resourceType: string): MiddlewareHandler
```

---

## 7. Routes Protection Map

| المسار | الصلاحية المطلوبة |
|--------|-------------------|
| `/auth/*` | عام (بدون JWT) |
| `/public/*` | عام (بدون JWT) |
| `/secure/profile` | أي مستخدم مسجل |
| `/secure/merchant/*` | `merchant` أو `merchant_user` |
| `/secure/products/*` | `merchant` أو `merchant_user` مع صلاحيات |
| `/secure/orders/*` | `merchant` أو `merchant_user` أو `customer` (طلباته فقط) |
| `/secure/customers/*` | `customer` (بياناته فقط) |
| `/admin/*` | `admin` أو `owner` |
| `/internal/*` | `EDGE_INTERNAL_KEY` header |

---

## 8. Error Responses

```typescript
// 401 Unauthorized - لا يوجد JWT أو منتهي
{
  "error": "unauthorized",
  "message": "Missing or invalid authentication token"
}

// 403 Forbidden - JWT صحيح لكن لا يملك الصلاحية
{
  "error": "forbidden", 
  "message": "Insufficient permissions",
  "required": "products:write"
}
```

---

## 9. ملخص التنفيذ

### الموجود (تم تنفيذه):
- ✅ `authMiddleware.ts` - فك JWT
- ✅ `generateJWT()` - إنشاء JWT
- ✅ `hashPassword()` / `verifyPassword()` - تشفير كلمات المرور
- ✅ `AuthContext` interface
- ✅ `UserType` type

### المطلوب (الخطوة 6):
- ⬜ `roleMiddleware.ts` - التحقق من الأدوار والصلاحيات
- ⬜ `requireRole()` function
- ⬜ `requirePermission()` function
- ⬜ `requireOwnership()` function

---

## 10. أمثلة الاستخدام

### تسجيل الدخول:
```
POST /auth/login
Body: { email, password }
Response: { access_token, user: { id, email, user_type } }
```

### طلب محمي:
```
GET /secure/merchant/products
Headers: Authorization: Bearer <token>
```

### التحقق في الـ Endpoint:
```typescript
export async function handler(c: Context) {
  const userId = c.get('userId');
  const merchantId = c.get('merchantId');
  const permissions = c.get('permissions');
  
  // الآن يمكن استخدام هذه القيم
}
```
