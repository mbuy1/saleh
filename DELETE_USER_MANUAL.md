# 🗑️ حذف مستخدم baharista1@gmail.com

**التاريخ:** ديسمبر 2025

---

## 📋 الخطوات

### 1. **البحث عن المستخدم:**

افتح Supabase Dashboard → SQL Editor وانسخ والصق:

```sql
-- البحث في auth.users
SELECT id, email, created_at 
FROM auth.users 
WHERE email ILIKE '%baharista%';

-- البحث في user_profiles
SELECT id, email, role, display_name 
FROM user_profiles 
WHERE email ILIKE '%baharista%';
```

### 2. **حذف المستخدم:**

بعد الحصول على `id` من النتائج أعلاه، استخدم:

```sql
-- حذف المستخدم (استبدل USER_ID_HERE بـ ID المستخدم)
DELETE FROM auth.users WHERE id = 'USER_ID_HERE';
```

**ملاحظة:** حذف المستخدم من `auth.users` سيحذف تلقائياً جميع السجلات المرتبطة بسبب CASCADE:
- ✅ user_profiles
- ✅ stores (إذا كان تاجر)
- ✅ carts
- ✅ cart_items
- ✅ orders
- ✅ order_items
- ✅ wallets
- ✅ wallet_transactions
- ✅ points_accounts
- ✅ points_transactions
- ✅ story_views
- ✅ story_likes
- ✅ user_fcm_tokens
- ✅ favorites
- ✅ coupons_used
- ✅ وغيرها...

---

## ✅ النتيجة

تم إنشاء migration لكن المستخدم غير موجود حالياً في قاعدة البيانات.

إذا كان المستخدم موجوداً، استخدم SQL أعلاه في Supabase Dashboard.

---

**آخر تحديث:** ديسمبر 2025

