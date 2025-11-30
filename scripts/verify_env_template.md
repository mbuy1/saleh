# قالب التحقق من متغيرات .env

## استخدم هذا القالب للتحقق من ملف .env

انسخ والصق في ملف `.env` وتأكد من استبدال القيم:

```env
# ============================================
# Supabase Configuration
# ============================================
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here

# ============================================
# Cloudflare Images Configuration
# ============================================
# Account ID من Cloudflare Dashboard > Images > Overview
CLOUDFLARE_ACCOUNT_ID=

# API Token من Cloudflare Dashboard > My Profile > API Tokens
# يجب أن يكون له صلاحيات: Account > Cloudflare Images > Edit
CLOUDFLARE_IMAGES_TOKEN=

# Base URL من Cloudflare Dashboard > Images > Overview
# الصيغة: https://imagedelivery.net/<hash>/
# تأكد من وجود / في النهاية
CLOUDFLARE_IMAGES_BASE_URL=
```

## ✅ بعد إضافة القيم:

1. تأكد من عدم وجود مسافات قبل أو بعد `=`
2. تأكد من عدم وجود علامات اقتباس حول القيم
3. تأكد من أن `CLOUDFLARE_IMAGES_BASE_URL` ينتهي بـ `/`
4. احفظ الملف
5. أعد تشغيل التطبيق

