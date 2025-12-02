# 📋 دليل تنفيذ الجداول الناقصة

## ✅ الطريقة 1: عبر Supabase Dashboard (الأسهل)

### الخطوات:

1. **افتح Supabase Dashboard:**
   - اذهب إلى: https://supabase.com/dashboard/project/hswpdpoghbwzwnxbdbrg

2. **انتقل إلى SQL Editor:**
   - من القائمة الجانبية، اضغط على **SQL Editor**

3. **افتح ملف SQL:**
   - اضغط على **New query**
   - انسخ محتوى الملف `scripts/missing_tables.sql` بالكامل
   - الصق المحتوى في المحرر

4. **نفّذ الـ SQL:**
   - اضغط على زر **RUN** أو استخدم `Ctrl + Enter`
   - انتظر حتى يكتمل التنفيذ

5. **تحقق من النجاح:**
   - انتقل إلى **Table Editor**
   - تحقق من ظهور الجداول الجديدة:
     - ✅ categories
     - ✅ product_categories
     - ✅ stories
     - ✅ product_media
     - ✅ store_followers
     - ✅ conversations
     - ✅ messages
     - ✅ device_tokens
     - ✅ packages
     - ✅ package_subscriptions

---

## ✅ الطريقة 2: عبر Supabase CLI (للمتقدمين)

### المتطلبات:
- تثبيت PostgreSQL وأدوات psql

### الخطوات:

```bash
# 1. تعيين كلمة المرور
$env:PGPASSWORD="N0N&W=Xu9ZVe6=eI"

# 2. تنفيذ SQL
psql -h aws-0-eu-central-1.pooler.supabase.com `
     -p 6543 `
     -U postgres.hswpdpoghbwzwnxbdbrg `
     -d postgres `
     -f scripts/missing_tables.sql
```

---

## ✅ الطريقة 3: عبر API (برمجياً)

يمكنك استخدام Supabase Management API لتنفيذ SQL برمجياً:

```bash
# استخدم Access Token الخاص بك
curl -X POST "https://api.supabase.com/v1/projects/hswpdpoghbwzwnxbdbrg/database/query" `
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" `
  -H "Content-Type: application/json" `
  -d '{"query": "SQL_CONTENT_HERE"}'
```

---

## 📊 الجداول التي سيتم إنشاؤها

### 1. **categories** - الفئات
- الفئات الرئيسية والفرعية
- دعم التسلسل الهرمي (parent_id)
- 10 فئات رئيسية مع 10 فئات فرعية

### 2. **product_categories** - ربط المنتجات بالفئات
- علاقة many-to-many
- منتج واحد يمكن أن يكون في فئات متعددة

### 3. **stories** - قصص المتاجر
- تنتهي بعد 24 ساعة
- دعم التثبيت (is_pinned)
- عداد المشاهدات والنقرات

### 4. **product_media** - صور وفيديوهات المنتجات
- صور إضافية للمنتج
- دعم الفيديو
- ترتيب العرض

### 5. **store_followers** - متابعي المتاجر
- تتبع من يتابع أي متجر

### 6. **conversations** - المحادثات
- بين العملاء والتجار

### 7. **messages** - الرسائل
- داخل المحادثات
- دعم النصوص والملفات

### 8. **device_tokens** - رموز FCM
- لإرسال الإشعارات Push

### 9. **packages** - باقات الاشتراك
- للتجار

### 10. **package_subscriptions** - اشتراكات الباقات
- تتبع اشتراكات التجار

---

## ✅ التحقق من النجاح

بعد تنفيذ SQL، تحقق من:

1. **عدد الجداول:**
```sql
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'public';
```

2. **قائمة الجداول الجديدة:**
```sql
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN (
  'categories', 'product_categories', 'stories', 
  'product_media', 'store_followers', 'conversations', 
  'messages', 'device_tokens', 'packages', 
  'package_subscriptions'
);
```

3. **عدد الفئات المدرجة:**
```sql
SELECT COUNT(*) FROM categories;
-- يجب أن يكون: 20 (10 رئيسية + 10 فرعية)
```

---

## ⚠️ ملاحظات مهمة

1. **RLS معطل:** جميع الجداول بدون Row Level Security حالياً
2. **الصلاحيات:** تم منح جميع الصلاحيات لـ anon, authenticated, service_role
3. **البيانات الأولية:** تم إدراج 20 فئة تلقائياً
4. **Foreign Keys:** تأكد من وجود الجداول المرجعية:
   - ✅ products
   - ✅ stores
   - ✅ user_profiles

---

## 🚀 الخطوات التالية

بعد إنشاء الجداول:

1. **تحديث Flutter Services:**
   - إنشاء CategoryService
   - إنشاء StoryService
   - إنشاء ConversationService
   - إنشاء DeviceTokenService

2. **ربط الشاشات بالجداول:**
   - ExploreScreen → stories
   - HomeScreen → categories, products
   - StoresScreen → store_followers

3. **تفعيل FCM:**
   - حفظ Device Tokens في جدول device_tokens
   - إرسال إشعارات عبر Firebase

4. **تفعيل RLS (مهم للإنتاج):**
   - إنشاء سياسات أمان لكل جدول

---

**تم إنشاء هذا الملف في:** ديسمبر 2025
