import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Helper functions لاستخدام Cloudflare Images/Stream/R2
class CloudflareHelper {
  /// الحصول على Base URL لـ Cloudflare Images
  static String? get imagesBaseUrl {
    return dotenv.env['CLOUDFLARE_IMAGES_BASE_URL'] ??
        dotenv.env['CF_IMAGES_BASE_URL'];
  }

  /// الحصول على Account ID
  static String? get accountId {
    return dotenv.env['CLOUDFLARE_ACCOUNT_ID'] ??
        dotenv.env['CF_ACCOUNT_ID'] ??
        dotenv.env['CF_IMAGES_ACCOUNT_ID'];
  }

  /// الحصول على Base URL لـ Cloudflare Stream
  static String? get streamBaseUrl {
    return dotenv.env['CLOUDFLARE_STREAM_BASE_URL'] ??
        dotenv.env['CF_STREAM_BASE_URL'];
  }

  /// الحصول على Base URL لـ Cloudflare R2
  static String? get r2BaseUrl {
    return dotenv.env['CLOUDFLARE_R2_BASE_URL'] ??
        dotenv.env['CF_R2_BASE_URL'];
  }

  /// بناء URL لصورة من Cloudflare Images
  /// 
  /// [imageId]: معرف الصورة في Cloudflare Images
  /// [variant]: نوع الصورة (public, thumbnail, avatar, etc.) - افتراضي: public
  /// [width]: عرض الصورة (اختياري)
  /// [height]: ارتفاع الصورة (اختياري)
  /// [fit]: طريقة التكيف (scale-down, contain, cover, crop, pad) - افتراضي: cover
  static String? buildImageUrl(
    String imageId, {
    String variant = 'public',
    int? width,
    int? height,
    String fit = 'cover',
  }) {
    final baseUrl = imagesBaseUrl;
    if (baseUrl == null || baseUrl.isEmpty) {
      return null;
    }

    // إزالة / من نهاية baseUrl إذا كان موجوداً
    final cleanBaseUrl = baseUrl.endsWith('/') 
        ? baseUrl.substring(0, baseUrl.length - 1) 
        : baseUrl;

    // بناء URL الأساسي
    var url = '$cleanBaseUrl/$imageId/$variant';

    // إضافة معاملات التحويل (transformations)
    final params = <String>[];
    if (width != null) params.add('w=$width');
    if (height != null) params.add('h=$height');
    if (fit.isNotEmpty) params.add('fit=$fit');

    if (params.isNotEmpty) {
      url += '?${params.join('&')}';
    }

    return url;
  }

  /// بناء URL لفيديو من Cloudflare Stream
  /// 
  /// [videoId]: معرف الفيديو في Cloudflare Stream
  /// [thumbnailTime]: وقت الصورة المصغرة بالثواني (اختياري)
  static String? buildStreamUrl(
    String videoId, {
    int? thumbnailTime,
  }) {
    final baseUrl = streamBaseUrl;
    if (baseUrl == null || baseUrl.isEmpty) {
      return null;
    }

    final cleanBaseUrl = baseUrl.endsWith('/') 
        ? baseUrl.substring(0, baseUrl.length - 1) 
        : baseUrl;

    if (thumbnailTime != null) {
      return '$cleanBaseUrl/$videoId/thumbnails/thumbnail.jpg?time=${thumbnailTime}s';
    }

    return '$cleanBaseUrl/$videoId/manifest/video.m3u8';
  }

  /// بناء URL لملف من Cloudflare R2
  /// 
  /// [filePath]: مسار الملف في R2
  static String? buildR2Url(String filePath) {
    final baseUrl = r2BaseUrl;
    if (baseUrl == null || baseUrl.isEmpty) {
      return null;
    }

    final cleanBaseUrl = baseUrl.endsWith('/') 
        ? baseUrl.substring(0, baseUrl.length - 1) 
        : baseUrl;

    final cleanFilePath = filePath.startsWith('/') 
        ? filePath.substring(1) 
        : filePath;

    return '$cleanBaseUrl/$cleanFilePath';
  }

  /// التحقق من أن Cloudflare Images مُعد بشكل صحيح
  static bool isImagesConfigured() {
    return imagesBaseUrl != null && 
           imagesBaseUrl!.isNotEmpty &&
           accountId != null &&
           accountId!.isNotEmpty;
  }

  /// التحقق من أن Cloudflare Stream مُعد بشكل صحيح
  static bool isStreamConfigured() {
    return streamBaseUrl != null && streamBaseUrl!.isNotEmpty;
  }

  /// التحقق من أن Cloudflare R2 مُعد بشكل صحيح
  static bool isR2Configured() {
    return r2BaseUrl != null && r2BaseUrl!.isNotEmpty;
  }

  /// الحصول على صورة افتراضية في حالة عدم توفر الصورة
  /// يمكن استخدامها كـ placeholder
  static String? getDefaultPlaceholderImage({
    int width = 400,
    int height = 300,
    String text = '',
  }) {
    // إذا كان Cloudflare Images مُعد، يمكن استخدام صورة افتراضية من Cloudflare
    if (isImagesConfigured()) {
      // يمكنك إضافة معرف صورة افتراضية هنا
      // return buildImageUrl('default-placeholder', width: width, height: height);
    }

    // استخدام placeholder بسيط
    return 'https://via.placeholder.com/${width}x$height?text=${Uri.encodeComponent(text)}';
  }
}

