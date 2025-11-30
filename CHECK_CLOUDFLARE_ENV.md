# ✅ التحقق من متغيرات Cloudflare في .env

## المتغيرات المطلوبة

تأكد من وجود المتغيرات التالية في ملف `.env` في جذر المشروع:

```env
# Cloudflare Images
CLOUDFLARE_ACCOUNT_ID=your_account_id_here
CLOUDFLARE_IMAGES_TOKEN=your_api_token_here
CLOUDFLARE_IMAGES_BASE_URL=https://imagedelivery.net/your_hash_here/
```

## ✅ قائمة التحقق

افتح ملف `.env` وتأكد من:

- [ ] `CLOUDFLARE_ACCOUNT_ID` موجود وله قيمة (ليست `your_account_id_here`)
- [ ] `CLOUDFLARE_IMAGES_TOKEN` موجود وله قيمة (ليست `your_api_token_here`)
- [ ] `CLOUDFLARE_IMAGES_BASE_URL` موجود وله قيمة (ليست `your_hash_here`)
- [ ] جميع القيم لا تحتوي على مسافات إضافية
- [ ] لا توجد علامات اقتباس حول القيم (مثل `"value"` أو `'value'`)

## 🔍 كيفية التحقق برمجياً

يمكنك التحقق من خلال تشغيل التطبيق:

1. شغّل التطبيق: `flutter run`
2. إذا ظهرت رسالة خطأ مثل:
   - `CLOUDFLARE_ACCOUNT_ID غير موجود في ملف .env`
   - `CLOUDFLARE_IMAGES_TOKEN غير موجود في ملف .env`
   - `CLOUDFLARE_IMAGES_BASE_URL غير موجود في ملف .env`
   
   فهذا يعني أن المتغير مفقود أو فارغ.

## 📝 مثال على ملف .env صحيح

```env
# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here

# Cloudflare Images
CLOUDFLARE_ACCOUNT_ID=abc123def456
CLOUDFLARE_IMAGES_TOKEN=abc123def456ghi789jkl012mno345pqr678stu901vwx234yz
CLOUDFLARE_IMAGES_BASE_URL=https://imagedelivery.net/abc123def456/
```

## ⚠️ ملاحظات مهمة

1. **لا تشارك ملف .env**: تأكد من أن `.env` موجود في `.gitignore`
2. **لا تستخدم قيم placeholder**: استبدل `your_account_id_here` بقيم حقيقية
3. **تأكد من الصيغة**: `CLOUDFLARE_IMAGES_BASE_URL` يجب أن ينتهي بـ `/`
4. **أعد تشغيل التطبيق**: بعد تعديل `.env`، أعد تشغيل التطبيق

## 🔗 روابط مفيدة

- [Cloudflare Dashboard](https://dash.cloudflare.com/)
- [Cloudflare Images Documentation](https://developers.cloudflare.com/images/)
- راجع `CLOUDFLARE_ENV_SETUP.md` للتعليمات التفصيلية

