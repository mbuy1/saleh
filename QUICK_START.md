# 🚀 MBUY Quick Start Guide

## البنية المعمارية

```
Flutter App (baharista1@gmail.com)
    ↓ (JWT Token)
Cloudflare Worker (API Gateway)
    ↓ (x-internal-key)
Supabase Edge Functions
    ↓ (SB_SERVICE_ROLE_KEY)
Supabase Database
```

---

## 📡 API Endpoints

**Base URL:** `https://misty-mode-b68b.baharista1.workers.dev`

### 🔓 Public
- `POST /public/register` - تسجيل تاجر

### 🖼️ Media
- `POST /media/image` - رفع صورة
- `POST /media/video` - رفع فيديو

### 🔒 Secure (JWT Required)
- `POST /secure/wallet/add` - إضافة رصيد
- `GET /secure/wallet` - رصيد المحفظة
- `POST /secure/points/add` - نقاط
- `GET /secure/points` - رصيد النقاط
- `POST /secure/orders/create` - طلب جديد
- `GET /secure/products` - المنتجات
- `POST /secure/products` - منتج جديد
- `PUT /secure/products/:id` - تحديث
- `DELETE /secure/products/:id` - حذف
- `GET /secure/stores/:id` - متجر
- `PUT /secure/stores/:id` - تحديث متجر

---

## 🔐 المفاتيح

### Cloudflare Worker
```bash
wrangler secret put CF_IMAGES_API_TOKEN
wrangler secret put CF_STREAM_API_TOKEN
wrangler secret put SUPABASE_ANON_KEY
wrangler secret put EDGE_INTERNAL_KEY
```

### Supabase Secrets
```
SB_URL
SB_SERVICE_ROLE_KEY
EDGE_INTERNAL_KEY
FIREBASE_SERVER_KEY (optional)
```

---

## 🚀 النشر

### Worker
```bash
cd cloudflare
wrangler deploy
```

### Edge Functions
```bash
supabase functions deploy wallet_add
supabase functions deploy points_add
supabase functions deploy merchant_register
supabase functions deploy create_order
supabase functions deploy products_list
supabase functions deploy product_create
supabase functions deploy product_update
supabase functions deploy product_delete
supabase functions deploy store_update
```

---

## 📚 التوثيق الكامل

راجع: `MBUY_API_DOCUMENTATION.md`

---

## ✅ الحالة

- ✅ Worker جاهز
- ✅ 9 Edge Functions
- ✅ FCM Notifications
- ✅ Products & Stores CRUD
- ✅ Orders مع دفع
- ✅ Media Upload

**الحالة:** جاهز للإنتاج 🎉
