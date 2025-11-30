# إعداد متغيرات Cloudflare Images في .env

## المتغيرات المطلوبة

أضف المتغيرات التالية إلى ملف `.env` في جذر المشروع:

```env
# Cloudflare Images
CLOUDFLARE_ACCOUNT_ID=your_account_id_here
CLOUDFLARE_IMAGES_TOKEN=your_api_token_here
CLOUDFLARE_IMAGES_BASE_URL=https://imagedelivery.net/your_hash_here/
```

## كيفية الحصول على القيم

### 1. CLOUDFLARE_ACCOUNT_ID
- سجل الدخول إلى [Cloudflare Dashboard](https://dash.cloudflare.com/)
- انتقل إلى **Images** > **Overview**
- Account ID موجود في أعلى الصفحة

### 2. CLOUDFLARE_IMAGES_TOKEN
- في Cloudflare Dashboard، انتقل إلى **My Profile** > **API Tokens**
- أنشئ token جديد مع الصلاحيات التالية:
  - **Account** > **Cloudflare Images** > **Edit**
- انسخ الـ token بعد إنشائه

### 3. CLOUDFLARE_IMAGES_BASE_URL
- في Cloudflare Dashboard، انتقل إلى **Images** > **Overview**
- Base URL يكون بالصيغة: `https://imagedelivery.net/<hash>/`
- يمكنك العثور عليه في إعدادات Images

## ملاحظات

- لا تشارك ملف `.env` في git (يجب أن يكون في `.gitignore`)
- تأكد من إضافة `.env` إلى `pubspec.yaml` في قسم `assets`
- بعد إضافة المتغيرات، أعد تشغيل التطبيق

