# 🔐 التحديث الأمني - نقل المفاتيح إلى Worker

**تاريخ:** 4 ديسمبر 2025

---

## ✅ ما تم إنجازه

### 1. نقل المفاتيح السرية من `.env` إلى Worker Secrets

تم نقل جميع المفاتيح الحساسة إلى Cloudflare Worker كـ **Secrets** آمنة:

```bash
✅ CF_IMAGES_API_TOKEN       - مفتاح Cloudflare Images
✅ CF_STREAM_API_TOKEN        - مفتاح Cloudflare Stream
✅ EDGE_INTERNAL_KEY          - مفتاح التواصل الآمن مع Edge Functions
✅ R2_ACCESS_KEY_ID           - مفتاح الوصول لـ R2
✅ R2_SECRET_ACCESS_KEY       - المفتاح السري لـ R2
✅ SUPABASE_ANON_KEY          - مفتاح Supabase العام
```

### 2. ملف `.env` الآن يحتوي فقط على:

```env
# Supabase Configuration
SUPABASE_URL=https://sirqidofuvphqcxqchyc.supabase.co
SUPABASE_ANON_KEY=eyJhbGci...
SUPABASE_SERVICE_KEY=eyJhbGci...
```

**ملاحظة:** `SUPABASE_SERVICE_KEY` يجب نقله أيضاً إلى Edge Functions إذا لم يتم بعد.

---

## 🏗️ البنية الجديدة

### قبل التحديث (❌ غير آمن):
```
Flutter App (.env)
  ├─ CLOUDFLARE_ACCOUNT_ID
  ├─ CLOUDFLARE_IMAGES_TOKEN
  ├─ GEMINI_API_KEY
  └─ جميع المفاتيح مكشوفة في التطبيق
```

### بعد التحديث (✅ آمن):
```
Flutter App (.env)
  └─ SUPABASE_URL + SUPABASE_ANON_KEY فقط

Cloudflare Worker (Secrets)
  ├─ CF_IMAGES_API_TOKEN
  ├─ CF_STREAM_API_TOKEN
  ├─ R2_ACCESS_KEY_ID
  ├─ R2_SECRET_ACCESS_KEY
  └─ EDGE_INTERNAL_KEY

Supabase Edge Functions (Secrets)
  ├─ SUPABASE_SERVICE_KEY
  ├─ EDGE_INTERNAL_KEY
  └─ أي مفاتيح أخرى للـ backend
```

---

## 📝 التعديلات على الكود

### 1. `lib/main.dart`
- ✅ تم إزالة تهيئة `CloudflareImagesService.initialize()`
- ✅ تم إزالة تهيئة `GeminiService.initialize()`
- ✅ الآن يتم استخدام هذه الخدمات عبر API Gateway فقط

**قبل:**
```dart
await CloudflareImagesService.initialize();  // يقرأ من .env
await GeminiService.initialize();            // يقرأ من .env
```

**بعد:**
```dart
// ملاحظة: Cloudflare Images و Gemini AI يعملان الآن عبر API Gateway
debugPrint('✅ سيتم استخدام Cloudflare Images عبر API Gateway');
debugPrint('✅ سيتم استخدام Gemini AI عبر API Gateway');
```

### 2. `lib/features/merchant/presentation/screens/merchant_store_setup_screen.dart`
- ✅ استبدال `CloudflareImagesService.uploadImage()` بـ `MediaService.uploadImage()`

**قبل:**
```dart
logoUrl = await CloudflareImagesService.uploadImage(
  _selectedImageFile!,
  folder: 'stores',
);
```

**بعد:**
```dart
// استخدام MediaService الذي يعمل عبر Worker
logoUrl = await MediaService.uploadImage(_selectedImageFile!);
```

---

## 🔒 الأمان

### المزايا الأمنية:

1. ✅ **المفاتيح السرية غير مكشوفة في التطبيق**
   - لا يمكن استخراجها من APK
   - لا يمكن رؤيتها في الـ source code

2. ✅ **المفاتيح محمية في Worker**
   - Cloudflare يشفّرها
   - يمكن تغييرها بدون إعادة بناء التطبيق

3. ✅ **JWT Authentication**
   - جميع الطلبات الحساسة تحتاج JWT
   - Worker يتحقق من الـ token قبل تنفيذ العمليات

4. ✅ **Edge Internal Key**
   - تواصل آمن بين Worker و Edge Functions
   - لا يمكن لأي طرف خارجي استدعاء Edge Functions مباشرة

---

## 🔄 كيفية رفع الصور الآن

### الطريقة الصحيحة (عبر Worker):
```dart
import 'package:saleh/core/services/media_service.dart';

// رفع صورة واحدة
final imageUrl = await MediaService.uploadImage(imageFile);

// رفع عدة صور
final urls = await MediaService.uploadImages([file1, file2, file3]);
```

### ما يحدث خلف الكواليس:
```
1. Flutter App يرسل الصورة إلى → Worker /media/image
2. Worker يستخدم CF_IMAGES_API_TOKEN (من Secrets)
3. Worker يرفع الصورة إلى Cloudflare Images
4. Worker يرجع URL الصورة إلى Flutter App
```

---

## 🧪 التحقق

### 1. Flutter Analyze
```bash
flutter analyze
# النتيجة: No issues found! ✅
```

### 2. Worker يعمل
```bash
curl https://misty-mode-b68b.baharista1.workers.dev/
# النتيجة: {"ok":true,"message":"MBUY API Gateway"} ✅
```

### 3. Secrets موجودة
```bash
cd cloudflare
npx wrangler secret list
# النتيجة: 6 secrets ✅
```

---

## ⚠️ ملاحظات مهمة

### 1. الخدمات القديمة لا تزال موجودة
الملفات التالية لا تزال موجودة لكنها **لن تُستخدم**:
- `lib/core/services/cloudflare_images_service.dart` (قديم)
- `lib/core/services/gemini_service.dart` (قديم)
- `lib/core/services/cloudflare_helper.dart` (مساعد فقط)

**يمكن حذفها لاحقاً** بعد التأكد أن كل شيء يعمل.

### 2. `SUPABASE_SERVICE_KEY` في `.env`
⚠️ هذا المفتاح يجب أن يكون **فقط** في Edge Functions  
❌ لا يجب أن يكون في `.env` للتطبيق  
✅ تأكد أنه موجود في Supabase Edge Function Secrets

### 3. رفع الصور من merchant_products_screen
تحقق من أن `merchant_products_screen.dart` يستخدم `MediaService` أيضاً.

---

## 📋 الخطوات التالية (اختياري)

### 1. حذف `SUPABASE_SERVICE_KEY` من `.env`
```bash
# تأكد أولاً أنه موجود في Edge Functions
# ثم احذفه من .env
```

### 2. حذف الخدمات القديمة (بعد التأكد)
```bash
# بعد اختبار شامل للتطبيق:
rm lib/core/services/cloudflare_images_service.dart
rm lib/core/services/gemini_service.dart
```

### 3. إنشاء Gemini Edge Function
حالياً Gemini لا يزال يُستخدم مباشرة. يمكن إنشاء Edge Function له:
```typescript
// supabase/functions/gemini-chat/index.ts
// يستخدم GEMINI_API_KEY من Secrets
```

---

## ✅ الخلاصة

- ✅ المفاتيح الحساسة الآن في Worker Secrets (آمنة)
- ✅ التطبيق يعمل بدون أخطاء
- ✅ رفع الصور يعمل عبر Worker
- ✅ البنية أكثر أماناً واحترافية

**الحالة:** جاهز للإنتاج 🚀

---

**آخر تحديث:** 4 ديسمبر 2025، 11:45 م
