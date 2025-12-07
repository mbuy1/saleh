# 📝 دليل النشر خطوة بخطوة - Pre-Launch v1

**اتبع هذه الخطوات بالترتيب**

---

## ✅ الخطوة 1: تطبيق Migration في Supabase

### 1.1 فتح Supabase Dashboard
1. اذهب إلى [Supabase Dashboard](https://app.supabase.com)
2. اختر المشروع الخاص بك
3. من القائمة الجانبية، اضغط على **SQL Editor**

### 1.2 نسخ Migration
1. افتح الملف: `APPLY_THIS_MIGRATION.sql`
2. انسخ المحتوى بالكامل (Ctrl+A ثم Ctrl+C)

### 1.3 تطبيق Migration
1. في SQL Editor، الصق المحتوى (Ctrl+V)
2. اضغط **Run** أو **Ctrl+Enter**
3. انتظر حتى يكتمل التنفيذ

### 1.4 التحقق من النتيجة
```sql
-- انسخ والصق هذا في SQL Editor للتحقق
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('products', 'stores', 'orders', 'user_profiles', 'mbuy_users', 'mbuy_sessions')
ORDER BY tablename;
```

**النتيجة المتوقعة:** جميع الجداول يجب أن يكون `rowsecurity = true`

**✅ إذا كانت النتيجة صحيحة، انتقل للخطوة 2**

---

## ✅ الخطوة 2: إعداد Worker Secrets في Cloudflare

### 2.1 الحصول على المفاتيح من Supabase
1. في Supabase Dashboard، اذهب إلى **Settings** → **API**
2. انسخ القيم التالية:
   - **Project URL** → هذا هو `SUPABASE_URL`
   - **anon public** → هذا هو `SUPABASE_ANON_KEY`
   - **service_role secret** → هذا هو `SUPABASE_SERVICE_ROLE_KEY` ⚠️ حساس جداً

### 2.2 إنشاء JWT Secret
```bash
# في Terminal (Windows PowerShell)
# أو استخدم أي مولد عشوائي
# يجب أن يكون 32+ حرف
```

**أو استخدم:**
- [Random.org](https://www.random.org/strings/)
- طول: 64 حرف
- نوع: Hexadecimal

### 2.3 إضافة Secrets إلى Cloudflare Worker

**الطريقة 1: عبر Terminal (مستحسن)**
```bash
# الانتقال إلى مجلد Worker
cd mbuy-worker

# إضافة كل Secret (سيطلب منك إدخال القيمة)
wrangler secret put SUPABASE_URL
# الصق: Project URL من Supabase

wrangler secret put SUPABASE_SERVICE_ROLE_KEY
# الصق: service_role secret من Supabase

wrangler secret put SUPABASE_ANON_KEY
# الصق: anon public من Supabase

wrangler secret put JWT_SECRET
# الصق: المفتاح العشوائي الذي أنشأته

wrangler secret put PASSWORD_HASH_ROUNDS
# أدخل: 100000
```

**الطريقة 2: عبر Cloudflare Dashboard**
1. اذهب إلى [Cloudflare Dashboard](https://dash.cloudflare.com)
2. Workers & Pages → اختر Worker الخاص بك
3. Settings → Secrets
4. أضف كل Secret:
   - `SUPABASE_URL`
   - `SUPABASE_SERVICE_ROLE_KEY`
   - `SUPABASE_ANON_KEY`
   - `JWT_SECRET`
   - `PASSWORD_HASH_ROUNDS` (اختياري، افتراضي: 100000)

**✅ إذا تمت إضافة جميع Secrets، انتقل للخطوة 3**

---

## ✅ الخطوة 3: نشر Cloudflare Worker

### 3.1 التحقق من wrangler.toml
```bash
cd mbuy-worker
cat wrangler.toml
# أو افتح الملف في محرر النصوص
```

**تأكد من:**
- `name` موجود
- `compatibility_date` موجود

### 3.2 نشر Worker
```bash
cd mbuy-worker
wrangler deploy
```

**النتيجة المتوقعة:**
```
✨  Deployed successfully!
🌍  https://your-worker.your-subdomain.workers.dev
```

**احفظ Worker URL في مكان آمن!**

### 3.3 التحقق من Worker
1. افتح Worker URL في المتصفح
2. يجب أن ترى استجابة JSON (قد تكون رسالة خطأ، هذا طبيعي)
3. اختبر endpoint: `https://your-worker.workers.dev/public/categories`

**✅ إذا كان Worker يستجيب، انتقل للخطوة 4**

---

## ✅ الخطوة 4: تحديث Flutter App

### 4.1 تحديث Worker URL
1. افتح: `saleh/lib/core/services/api_service.dart`
2. ابحث عن:
   ```dart
   static const String baseUrl = 'https://misty-mode-b68b.baharista1.workers.dev';
   ```
3. استبدله بـ Worker URL الجديد:
   ```dart
   static const String baseUrl = 'https://YOUR-WORKER-URL.workers.dev';
   ```

### 4.2 التحقق من التغييرات
```bash
cd saleh
flutter analyze
# يجب أن يكون بدون أخطاء
```

**✅ إذا كان بدون أخطاء، انتقل للخطوة 5**

---

## ✅ الخطوة 5: بناء Flutter App

### 5.1 بناء Android APK
```bash
cd saleh
flutter build apk --release
```

**الملف الناتج:**
- `build/app/outputs/flutter-apk/app-release.apk`

### 5.2 بناء iOS (إن كان متوفر)
```bash
cd saleh
flutter build ios --release
```

**✅ إذا تم البناء بنجاح، انتقل للخطوة 6**

---

## ✅ الخطوة 6: نشر Merchant Web Store (اختياري)

### 6.1 نشر على Cloudflare Pages
```bash
cd merchant-web-store
wrangler pages deploy public
```

**أو عبر Git:**
1. ادفع الكود إلى GitHub
2. في Cloudflare Dashboard → Pages
3. Connect to Git
4. اختر Repository
5. Build output directory: `public`

**✅ إذا تم النشر، انتقل للخطوة 7**

---

## ✅ الخطوة 7: الاختبار الشامل

### 7.1 اختبار Authentication
- [ ] تسجيل الدخول كـ Customer
- [ ] تسجيل الدخول كـ Merchant
- [ ] إنشاء حساب جديد
- [ ] تسجيل الخروج

### 7.2 اختبار الصفحات الرئيسية
- [ ] Home Page
- [ ] Stores Page
- [ ] Explore Page
- [ ] Map Page
- [ ] Cart Page

### 7.3 اختبار Dashboards
- [ ] Customer Dashboard
- [ ] Merchant Dashboard
- [ ] Admin Dashboard (إن كان admin)

### 7.4 اختبار الميزات
- [ ] عرض المنتجات
- [ ] البحث
- [ ] إضافة للسلة
- [ ] إنشاء طلب

**راجع `TESTING_CHECKLIST.md` للقائمة الكاملة**

---

## ✅ الخطوة 8: التحقق النهائي

### 8.1 قائمة التحقق
- [ ] Migration مطبقة في Supabase
- [ ] RLS مفعّل على جميع الجداول
- [ ] Worker Secrets مضافة
- [ ] Worker منشور ويعمل
- [ ] Flutter App محدث
- [ ] Flutter App مبني
- [ ] الاختبارات مكتملة

### 8.2 النتيجة
**🎉 المشروع جاهز للـ Pre-Launch v1!**

---

## 🆘 استكشاف الأخطاء

### مشكلة: Migration فشلت
**الحل:**
- تحقق من أن الجداول موجودة
- تحقق من رسائل الخطأ
- راجع `APPLY_MIGRATION_GUIDE.md`

### مشكلة: Worker لا يستجيب
**الحل:**
- تحقق من Secrets
- تحقق من Logs في Cloudflare Dashboard
- راجع `DEPLOYMENT_GUIDE.md`

### مشكلة: Flutter لا يتصل بالـ Worker
**الحل:**
- تحقق من `baseUrl` في `api_service.dart`
- تحقق من CORS في Worker
- تحقق من Logs في Flutter

---

**تاريخ الإنشاء:** 2025-01-07  
**آخر تحديث:** 2025-01-07

