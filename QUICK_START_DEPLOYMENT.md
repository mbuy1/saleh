# ⚡ دليل النشر السريع - Pre-Launch v1

**للبدء السريع في النشر**

---

## 🚀 الخطوات السريعة (5 دقائق)

### 1️⃣ تطبيق Migration (2 دقيقة)

```bash
# 1. افتح Supabase Dashboard → SQL Editor
# 2. انسخ محتوى: mbuy-backend/migrations/20250107000002_finalize_rls_security.sql
# 3. الصق و Run
```

**✅ التحقق:**
```sql
SELECT tablename, rowsecurity FROM pg_tables 
WHERE schemaname = 'public' AND tablename = 'products';
-- يجب أن يكون rowsecurity = true
```

---

### 2️⃣ إعداد Worker Secrets (1 دقيقة)

```bash
cd mbuy-worker

# من Supabase Dashboard → Settings → API
wrangler secret put SUPABASE_URL
wrangler secret put SUPABASE_SERVICE_ROLE_KEY
wrangler secret put SUPABASE_ANON_KEY

# إنشاء JWT Secret
wrangler secret put JWT_SECRET
# أدخل: openssl rand -hex 32 (أو أي مفتاح عشوائي قوي)
```

---

### 3️⃣ نشر Worker (1 دقيقة)

```bash
cd mbuy-worker
wrangler deploy
```

**✅ التحقق:**
- افتح Worker URL في المتصفح
- يجب أن ترى استجابة JSON

---

### 4️⃣ تحديث Flutter (30 ثانية)

```dart
// saleh/lib/core/services/api_service.dart
static const String baseUrl = 'https://YOUR-WORKER-URL.workers.dev';
```

---

### 5️⃣ بناء Flutter App (1 دقيقة)

```bash
cd saleh
flutter build apk --release  # Android
# أو
flutter build ios --release   # iOS
```

---

## ✅ انتهى!

**المشروع جاهز للنشر! 🎉**

---

## 📝 ملاحظات

- **Worker URL:** احفظه في مكان آمن
- **JWT Secret:** لا تشاركه أبداً
- **Service Role Key:** حساس جداً، لا تضعه في Flutter

---

**للتفاصيل الكاملة:** راجع `DEPLOYMENT_GUIDE.md`

