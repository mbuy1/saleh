import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Helper functions لاستخدام Cloudflare Images/Stream/R2
class CloudflareHelper {
  /// الحصول على Base URL لـ Cloudflare Images
  /// Cloudflare Images Base URL format: https://imagedelivery.net/{account_hash}/{image_id}/{variant}
  static String? get imagesBaseUrl {
    final accountId =
        dotenv.env['CF_IMAGES_ACCOUNT_ID'] ??
        dotenv.env['CLOUDFLARE_ACCOUNT_ID'] ??
        dotenv.env['CF_ACCOUNT_ID'];

    if (accountId != null && accountId.isNotEmpty) {
      // بناء Base URL من Account ID
      return 'https://imagedelivery.net/$accountId';
    }

    // محاولة الحصول من متغير مباشر
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
    // محاولة بناء R2 URL من S3 Endpoint
    final s3Endpoint = dotenv.env['R2_S3_ENDPOINT'];
    if (s3Endpoint != null && s3Endpoint.isNotEmpty) {
      // R2 S3 Endpoint يمكن استخدامه مباشرة
      return s3Endpoint;
    }

    return dotenv.env['CLOUDFLARE_R2_BASE_URL'] ?? dotenv.env['CF_R2_BASE_URL'];
  }

  /// بناء URL لصورة من Cloudflare Images
  ///
  /// [imageId]: معرف الصورة في Cloudflare Images (hash)
  /// [variant]: نوع الصورة (public, thumbnail, avatar, etc.) - افتراضي: public
  /// [width]: عرض الصورة (اختياري)
  /// [height]: ارتفاع الصورة (اختياري)
  /// [fit]: طريقة التكيف (scale-down, contain, cover, crop, pad) - افتراضي: cover
  ///
  /// Cloudflare Images URL format: https://imagedelivery.net/{account_hash}/{image_id}/{variant}?w={width}&h={height}&fit={fit}
  static String? buildImageUrl(
    String imageId, {
    String variant = 'public',
    int? width,
    int? height,
    String fit = 'cover',
  }) {
    final baseUrl = imagesBaseUrl;
    if (baseUrl == null || baseUrl.isEmpty || imageId.isEmpty) {
      return null;
    }

    // إزالة / من نهاية baseUrl إذا كان موجوداً
    final cleanBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    // بناء URL الأساسي: {baseUrl}/{imageId}/{variant}
    var url = '$cleanBaseUrl/$imageId/$variant';

    // إضافة معاملات التحويل (transformations)
    final params = <String>[];
    if (width != null) params.add('w=$width');
    if (height != null) params.add('h=$height');
    if (fit.isNotEmpty && fit != 'cover') params.add('fit=$fit');

    if (params.isNotEmpty) {
      url += '?${params.join('&')}';
    }

    return url;
  }

  /// بناء URL لفيديو من Cloudflare Stream
  ///
  /// [videoId]: معرف الفيديو في Cloudflare Stream
  /// [thumbnailTime]: وقت الصورة المصغرة بالثواني (اختياري)
  static String? buildStreamUrl(String videoId, {int? thumbnailTime}) {
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
  ///
  /// إذا كان Cloudflare Images مُعد، سيحاول استخدام صورة افتراضية من Cloudflare
  /// وإلا سيعيد null لاستخدام PlaceholderImage widget
  static String? getDefaultPlaceholderImage({
    int width = 400,
    int height = 300,
    String text = '',
    String? cloudflareImageId,
  }) {
    // إذا كان Cloudflare Images مُعد وكان هناك معرف صورة محدد
    if (isImagesConfigured() &&
        cloudflareImageId != null &&
        cloudflareImageId.isNotEmpty) {
      final cloudflareUrl = buildImageUrl(
        cloudflareImageId,
        width: width,
        height: height,
      );
      if (cloudflareUrl != null) {
        return cloudflareUrl;
      }
    }

    // إرجاع null لاستخدام PlaceholderImage widget المحلي
    return null;
  }

  /// بناء URL لصورة من R2 إذا كانت موجودة
  /// [filePath]: مسار الملف في R2 (مثل: categories/icons/category-1.png)
  static String? buildR2ImageUrl(String filePath, {int? width, int? height}) {
    final r2Url = buildR2Url(filePath);
    if (r2Url == null) return null;

    // يمكن إضافة معاملات التحويل هنا إذا كان R2 يدعمها
    return r2Url;
  }
}
