# 🔗 تكامل Cloudflare Images/Stream/R2

## 📋 المتغيرات المطلوبة في ملف `.env`

```env
# Cloudflare Account ID
CF_IMAGES_ACCOUNT_ID=your_account_id
# أو
CLOUDFLARE_ACCOUNT_ID=your_account_id

# Cloudflare Images Base URL
CLOUDFLARE_IMAGES_BASE_URL=https://imagedelivery.net/your_account_hash
# أو
CF_IMAGES_BASE_URL=https://imagedelivery.net/your_account_hash

# Cloudflare Images API Token (لرفع الصور)
CLOUDFLARE_IMAGES_TOKEN=your_api_token

# Cloudflare Stream Base URL (اختياري)
CLOUDFLARE_STREAM_BASE_URL=https://customer-xxxxx.cloudflarestream.com
# أو
CF_STREAM_BASE_URL=https://customer-xxxxx.cloudflarestream.com

# Cloudflare R2 Base URL (اختياري)
CLOUDFLARE_R2_BASE_URL=https://your-bucket.r2.cloudflarestorage.com
# أو
CF_R2_BASE_URL=https://your-bucket.r2.cloudflarestorage.com
```

## 🚀 الاستخدام

### 1. بناء URL لصورة من Cloudflare Images

```dart
import 'package:your_app/core/services/cloudflare_helper.dart';

// صورة أساسية
final imageUrl = CloudflareHelper.buildImageUrl('image-id-123');

// صورة بحجم محدد
final thumbnailUrl = CloudflareHelper.buildImageUrl(
  'image-id-123',
  variant: 'thumbnail',
  width: 200,
  height: 200,
  fit: 'cover',
);
```

### 2. بناء URL لفيديو من Cloudflare Stream

```dart
// URL الفيديو
final videoUrl = CloudflareHelper.buildStreamUrl('video-id-123');

// URL الصورة المصغرة
final thumbnailUrl = CloudflareHelper.buildStreamUrl(
  'video-id-123',
  thumbnailTime: 5, // ثانية 5
);
```

### 3. بناء URL لملف من Cloudflare R2

```dart
final fileUrl = CloudflareHelper.buildR2Url('path/to/file.pdf');
```

### 4. التحقق من الإعدادات

```dart
if (CloudflareHelper.isImagesConfigured()) {
  // Cloudflare Images جاهز للاستخدام
}

if (CloudflareHelper.isStreamConfigured()) {
  // Cloudflare Stream جاهز للاستخدام
}

if (CloudflareHelper.isR2Configured()) {
  // Cloudflare R2 جاهز للاستخدام
}
```

## 📝 ملاحظات

1. **Cloudflare Images**: يدعم تحويلات الصور (resize, crop, etc.) عبر URL parameters
2. **Cloudflare Stream**: يدعم HLS streaming و thumbnails
3. **Cloudflare R2**: يدعم تخزين الملفات بشكل مباشر

## 🔧 التكامل مع قاعدة البيانات

عند حفظ معرفات الصور/الفيديوهات في Supabase، استخدم `CloudflareHelper` لبناء URLs:

```dart
// في Product model
String? get imageUrl {
  if (cloudflareImageId != null) {
    return CloudflareHelper.buildImageUrl(
      cloudflareImageId!,
      width: 400,
      height: 400,
    );
  }
  return null;
}
```

