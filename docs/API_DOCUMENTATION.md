# MBUY API Documentation
# توثيق واجهات برمجة التطبيقات

## نظرة عامة
هذا المستند يوثق جميع واجهات API المستخدمة في تطبيق MBUY للتجار.

---

## 🔐 المصادقة (Authentication)

### تسجيل الدخول
```http
POST /auth/supabase/login
Content-Type: application/json
```

**الجسم (Body):**
```json
{
  "email": "merchant@example.com",
  "password": "securepassword123"
}
```

**الاستجابة الناجحة (200):**
```json
{
  "session": {
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "refresh_token": "refresh_token_here",
    "expires_in": 3600,
    "token_type": "bearer"
  },
  "user": {
    "id": "auth-user-uuid",
    "email": "merchant@example.com",
    "user_metadata": {
      "full_name": "اسم التاجر",
      "role": "merchant"
    }
  },
  "profile": {
    "id": "profile-uuid",
    "auth_user_id": "auth-user-uuid",
    "role": "merchant",
    "display_name": "اسم العرض",
    "email": "merchant@example.com",
    "avatar_url": null
  }
}
```

**الاستجابة الفاشلة (401):**
```json
{
  "error": "INVALID_CREDENTIALS",
  "message": "البريد الإلكتروني أو كلمة المرور غير صحيحة"
}
```

---

### تسجيل حساب جديد
```http
POST /auth/supabase/register
Content-Type: application/json
```

**الجسم (Body):**
```json
{
  "email": "newmerchant@example.com",
  "password": "securepassword123",
  "full_name": "اسم التاجر الجديد",
  "role": "merchant"
}
```

**الاستجابة الناجحة (201):**
```json
{
  "session": { ... },
  "user": { ... },
  "profile": { ... }
}
```

---

### تحديث التوكن
```http
POST /auth/supabase/refresh
Content-Type: application/json
```

**الجسم (Body):**
```json
{
  "refresh_token": "refresh_token_here"
}
```

---

### تسجيل الخروج
```http
POST /auth/supabase/logout
Authorization: Bearer <access_token>
```

---

## 📦 المنتجات (Products)

### جلب جميع المنتجات
```http
GET /products
Authorization: Bearer <access_token>
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| page | number | No | رقم الصفحة (افتراضي: 1) |
| limit | number | No | عدد العناصر (افتراضي: 20) |
| category_id | string | No | تصفية حسب التصنيف |
| search | string | No | البحث في الاسم والوصف |
| is_active | boolean | No | المنتجات النشطة فقط |

**الاستجابة الناجحة (200):**
```json
{
  "data": [
    {
      "id": "product-uuid",
      "name": "اسم المنتج",
      "description": "وصف المنتج",
      "price": 99.99,
      "stock": 50,
      "image_url": "https://...",
      "category_id": "category-uuid",
      "store_id": "store-uuid",
      "is_active": true,
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z",
      "media": [
        {
          "id": "media-uuid",
          "product_id": "product-uuid",
          "media_type": "image",
          "url": "https://...",
          "sort_order": 0,
          "is_main": true
        }
      ]
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "total_pages": 5
  }
}
```

---

### جلب منتج واحد
```http
GET /products/{id}
Authorization: Bearer <access_token>
```

---

### إنشاء منتج جديد
```http
POST /products
Authorization: Bearer <access_token>
Content-Type: application/json
```

**الجسم (Body):**
```json
{
  "name": "اسم المنتج الجديد",
  "description": "وصف تفصيلي للمنتج",
  "price": 149.99,
  "cost_price": 100.00,
  "stock": 100,
  "category_id": "category-uuid",
  "product_type": "physical",
  "weight": 0.5,
  "sku": "PROD-001",
  "barcode": "1234567890123",
  "low_stock_alert": 10,
  "show_in_store": true,
  "show_in_mbuy_app": true,
  "show_in_dropshipping": false,
  "seo_keywords": ["كلمة1", "كلمة2"]
}
```

---

### تحديث منتج
```http
PUT /products/{id}
Authorization: Bearer <access_token>
Content-Type: application/json
```

---

### حذف منتج
```http
DELETE /products/{id}
Authorization: Bearer <access_token>
```

---

### رفع صورة منتج
```http
POST /products/{id}/media
Authorization: Bearer <access_token>
Content-Type: multipart/form-data
```

**Form Data:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| file | File | Yes | ملف الصورة |
| media_type | string | No | نوع الوسائط (image/video) |
| is_main | boolean | No | هل هي الصورة الرئيسية |

---

## 📂 التصنيفات (Categories)

### جلب جميع التصنيفات
```http
GET /categories
Authorization: Bearer <access_token>
```

### إنشاء تصنيف
```http
POST /categories
Authorization: Bearer <access_token>
Content-Type: application/json
```

**الجسم (Body):**
```json
{
  "name": "اسم التصنيف",
  "description": "وصف التصنيف",
  "parent_id": null,
  "sort_order": 0
}
```

---

## 🛒 الطلبات (Orders)

### جلب جميع الطلبات
```http
GET /orders
Authorization: Bearer <access_token>
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| status | string | No | تصفية حسب الحالة |
| date_from | string | No | من تاريخ (ISO 8601) |
| date_to | string | No | إلى تاريخ (ISO 8601) |

**الاستجابة الناجحة (200):**
```json
{
  "data": [
    {
      "id": "order-uuid",
      "order_number": "ORD-2024-0001",
      "customer_name": "اسم العميل",
      "customer_phone": "+966501234567",
      "customer_email": "customer@example.com",
      "status": "pending",
      "subtotal": 299.99,
      "shipping_cost": 25.00,
      "discount": 10.00,
      "total": 314.99,
      "items": [
        {
          "product_id": "product-uuid",
          "product_name": "اسم المنتج",
          "quantity": 2,
          "unit_price": 149.99,
          "total": 299.98
        }
      ],
      "shipping_address": {
        "city": "الرياض",
        "district": "العليا",
        "street": "شارع الملك فهد",
        "building": "123"
      },
      "created_at": "2024-01-15T10:30:00Z"
    }
  ]
}
```

### تحديث حالة الطلب
```http
PATCH /orders/{id}/status
Authorization: Bearer <access_token>
Content-Type: application/json
```

**الجسم (Body):**
```json
{
  "status": "processing"
}
```

**حالات الطلب المتاحة:**
- `pending` - قيد الانتظار
- `processing` - قيد المعالجة
- `shipped` - تم الشحن
- `delivered` - تم التسليم
- `cancelled` - ملغي
- `refunded` - مسترد

---

## 🏪 المتجر (Store)

### جلب معلومات المتجر
```http
GET /stores/me
Authorization: Bearer <access_token>
```

**الاستجابة الناجحة (200):**
```json
{
  "id": "store-uuid",
  "name": "اسم المتجر",
  "description": "وصف المتجر",
  "logo_url": "https://...",
  "cover_url": "https://...",
  "phone": "+966501234567",
  "email": "store@example.com",
  "address": {
    "city": "الرياض",
    "district": "العليا",
    "street": "شارع الملك فهد"
  },
  "social_links": {
    "instagram": "@storename",
    "twitter": "@storename",
    "whatsapp": "+966501234567"
  },
  "settings": {
    "currency": "SAR",
    "language": "ar",
    "timezone": "Asia/Riyadh"
  },
  "created_at": "2024-01-01T00:00:00Z"
}
```

### تحديث معلومات المتجر
```http
PUT /stores/me
Authorization: Bearer <access_token>
Content-Type: application/json
```

---

## 📊 الإحصائيات (Analytics)

### إحصائيات لوحة التحكم
```http
GET /analytics/dashboard
Authorization: Bearer <access_token>
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| period | string | No | الفترة (today, week, month, year) |

**الاستجابة الناجحة (200):**
```json
{
  "sales": {
    "total": 15000.00,
    "count": 45,
    "average": 333.33,
    "growth": 12.5
  },
  "orders": {
    "total": 50,
    "pending": 5,
    "processing": 10,
    "completed": 35
  },
  "products": {
    "total": 100,
    "active": 85,
    "out_of_stock": 5
  },
  "customers": {
    "total": 200,
    "new": 15
  },
  "top_products": [
    {
      "id": "product-uuid",
      "name": "اسم المنتج",
      "sales": 5000.00,
      "quantity": 25
    }
  ]
}
```

---

## 🔔 الإشعارات (Notifications)

### جلب الإشعارات
```http
GET /notifications
Authorization: Bearer <access_token>
```

### تحديد إشعار كمقروء
```http
PATCH /notifications/{id}/read
Authorization: Bearer <access_token>
```

---

## ⚠️ رموز الأخطاء

| رمز الخطأ | الوصف |
|-----------|-------|
| `UNAUTHORIZED` | غير مصرح - التوكن منتهي أو غير صالح |
| `FORBIDDEN` | ممنوع - ليس لديك صلاحية |
| `NOT_FOUND` | غير موجود |
| `VALIDATION_ERROR` | خطأ في التحقق من البيانات |
| `INVALID_CREDENTIALS` | بيانات الدخول غير صحيحة |
| `DUPLICATE_ENTRY` | السجل موجود مسبقاً |
| `SERVER_ERROR` | خطأ في الخادم |

---

## 📝 ملاحظات للمطورين

### Headers المطلوبة
```http
Authorization: Bearer <access_token>
Content-Type: application/json
Accept: application/json
X-Client-Version: 1.0.0
X-Platform: android|ios|web
```

### Rate Limiting
- 100 طلب/دقيقة للمستخدم المصادق
- 20 طلب/دقيقة للمستخدم غير المصادق

### Pagination
جميع الـ endpoints التي ترجع قوائم تدعم pagination:
- `page`: رقم الصفحة (افتراضي: 1)
- `limit`: عدد العناصر (افتراضي: 20، أقصى: 100)

### الاستجابة العامة للأخطاء
```json
{
  "error": "ERROR_CODE",
  "message": "وصف الخطأ",
  "details": {
    "field_name": ["رسالة الخطأ للحقل"]
  }
}
```
