# 🚀 دليل النشر - Pre-Launch v1

**التاريخ:** 2025-01-07  
**الحالة:** ✅ جاهز للنشر

---

## 📋 الخطوات المطلوبة قبل النشر

### 1. تطبيق Migration في Supabase (RLS Security)

**الملف:** `mbuy-backend/migrations/20250107000002_finalize_rls_security.sql`

**الخطوات:**
1. افتح Supabase Dashboard
2. اذهب إلى SQL Editor
3. انسخ محتوى الملف `20250107000002_finalize_rls_security.sql`
4. الصق في SQL Editor
5. اضغط Run لتنفيذ Migration
6. تأكد من عدم وجود أخطاء

**التحقق:**
```sql
-- التحقق من تفعيل RLS
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('products', 'stores', 'orders', 'user_profiles', 'mbuy_users', 'mbuy_sessions');
```

**النتيجة المتوقعة:** جميع الجداول يجب أن يكون `rowsecurity = true`

---

### 2. إعداد Worker Secrets في Cloudflare

**المفاتيح المطلوبة:**

1. **SUPABASE_URL**
   - من Supabase Dashboard → Settings → API
   - مثال: `https://xxxxx.supabase.co`

2. **SUPABASE_SERVICE_ROLE_KEY**
   - من Supabase Dashboard → Settings → API
   - **⚠️ مهم جداً:** هذا المفتاح حساس، لا تشاركه أبداً

3. **SUPABASE_ANON_KEY**
   - من Supabase Dashboard → Settings → API
   - للوصول العام (Public endpoints)

4. **JWT_SECRET**
   - مفتاح سري عشوائي قوي (32+ حرف)
   - مثال: `openssl rand -hex 32`

5. **PASSWORD_HASH_ROUNDS** (اختياري)
   - افتراضي: `100000`

**الخطوات:**
```bash
# الانتقال إلى مجلد Worker
cd mbuy-worker

# إضافة Secrets
wrangler secret put SUPABASE_URL
wrangler secret put SUPABASE_SERVICE_ROLE_KEY
wrangler secret put SUPABASE_ANON_KEY
wrangler secret put JWT_SECRET
wrangler secret put PASSWORD_HASH_ROUNDS
```

**أو عبر Cloudflare Dashboard:**
1. اذهب إلى Workers & Pages
2. اختر Worker الخاص بك
3. Settings → Secrets
4. أضف كل Secret

---

### 3. نشر Cloudflare Worker

**الخطوات:**
```bash
# الانتقال إلى مجلد Worker
cd mbuy-worker

# التحقق من wrangler.toml
cat wrangler.toml

# نشر Worker
wrangler deploy

# أو للنشر مع متغيرات بيئة
wrangler deploy --env production
```

**التحقق:**
- افتح Worker URL في المتصفح
- يجب أن ترى استجابة JSON
- اختبر endpoint: `GET /public/health` (إن وجد)

---

### 4. إعداد Flutter App

**الملفات المطلوبة:**
- `saleh/lib/core/services/api_service.dart` - يجب أن يحتوي على Worker URL الصحيح

**الخطوات:**
1. افتح `saleh/lib/core/services/api_service.dart`
2. تأكد من أن `baseUrl` يشير إلى Worker URL الصحيح:
   ```dart
   static const String baseUrl = 'https://your-worker.your-subdomain.workers.dev';
   ```

3. بناء التطبيق:
   ```bash
   cd saleh
   flutter build apk --release  # للـ Android
   flutter build ios --release   # للـ iOS
   ```

---

### 5. نشر Merchant Web Store على Cloudflare Pages

**الخطوات:**
```bash
# الانتقال إلى مجلد Web Store
cd merchant-web-store

# التحقق من wrangler.toml
cat wrangler.toml

# نشر على Cloudflare Pages
wrangler pages deploy public

# أو عبر Git:
# 1. ادفع الكود إلى GitHub
# 2. في Cloudflare Dashboard → Pages
# 3. Connect to Git
# 4. اختر Repository
# 5. Build command: (لا حاجة)
# 6. Build output directory: public
```

**التحقق:**
- افتح Web Store URL
- يجب أن يظهر المتجر بشكل صحيح
- اختبر البحث والتنقل

---

## ✅ قائمة التحقق النهائية

### قبل النشر:
- [ ] Migration مطبقة في Supabase
- [ ] RLS مفعّل على جميع الجداول
- [ ] Worker Secrets مضافة في Cloudflare
- [ ] Worker منشور ويعمل
- [ ] Flutter App يشير إلى Worker URL الصحيح
- [ ] Merchant Web Store منشور

### بعد النشر:
- [ ] Worker يستجيب للطلبات
- [ ] Flutter App يتصل بالـ Worker بنجاح
- [ ] تسجيل الدخول يعمل
- [ ] عرض المنتجات يعمل
- [ ] Merchant Dashboard يعمل
- [ ] Customer Dashboard يعمل
- [ ] Web Store يعمل

---

## 🔧 استكشاف الأخطاء

### مشكلة: Worker لا يستجيب
**الحل:**
1. تحقق من Secrets في Cloudflare
2. تحقق من Logs في Cloudflare Dashboard
3. تأكد من أن Worker URL صحيح

### مشكلة: RLS يمنع الوصول
**الحل:**
1. تأكد من تطبيق Migration
2. تحقق من أن Worker يستخدم `SUPABASE_SERVICE_ROLE_KEY`
3. تحقق من Policies في Supabase

### مشكلة: Flutter لا يتصل بالـ Worker
**الحل:**
1. تحقق من `baseUrl` في `api_service.dart`
2. تحقق من CORS في Worker
3. تحقق من Logs في Flutter

---

## 📝 ملاحظات مهمة

1. **المفاتيح السرية:**
   - لا تضع أي مفاتيح سرية في Flutter
   - جميع المفاتيح في Worker Secrets فقط

2. **RLS:**
   - Worker يتجاوز RLS باستخدام `SUPABASE_SERVICE_ROLE_KEY`
   - Flutter لا يصل للقاعدة مباشرة

3. **CORS:**
   - تأكد من إعداد CORS في Worker بشكل صحيح
   - أضف Flutter app origins إلى CORS allowed origins

4. **النسخ الاحتياطي:**
   - احفظ نسخة من جميع المفاتيح في مكان آمن
   - احفظ نسخة من Migration files

---

**تاريخ الإنشاء:** 2025-01-07  
**آخر تحديث:** 2025-01-07

