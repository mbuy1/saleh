import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// خدمة رفع الصور إلى Cloudflare Images (عبر Worker API)
/// ⚠️ تم تحديثها لاستخدام Worker بدلاً من الاتصال المباشر
class CloudflareImagesService {
  static String? _workerUrl;
  static String? _baseUrl;

  /// تهيئة الخدمة (يجب استدعاؤها مرة واحدة في بداية التطبيق)
  static Future<void> initialize() async {
    _workerUrl = dotenv.env['CF_WORKER_URL'];
    _baseUrl = dotenv.env['CLOUDFLARE_IMAGES_BASE_URL'];

    if (_workerUrl == null || _workerUrl!.isEmpty) {
      throw Exception('CF_WORKER_URL غير موجود في ملف .env');
    }

    if (_baseUrl == null || _baseUrl!.isEmpty) {
      throw Exception('CLOUDFLARE_IMAGES_BASE_URL غير موجود في ملف .env');
    }

    debugPrint('✅ تم تهيئة Cloudflare Images عبر Worker بنجاح');
  }

  /// رفع صورة إلى Cloudflare Images عبر Worker API
  ///
  /// [file]: ملف الصورة المراد رفعه
  /// [folder]: مجلد الصورة (مثل 'stores' أو 'products') - غير مستخدم حالياً
  ///
  /// Returns: URL الصورة النهائي
  /// Throws: Exception في حالة الفشل
  static Future<String> uploadImage(File file, {required String folder}) async {
    // التحقق من التهيئة
    if (_workerUrl == null || _baseUrl == null) {
      await initialize();
    }

    if (!await file.exists()) {
      throw Exception('الملف غير موجود');
    }

    try {
      debugPrint('📤 بدء رفع الصورة عبر Worker API...');

      // 1. الحصول على Upload URL من Worker
      final uploadDataResponse = await http.post(
        Uri.parse('$_workerUrl/media/image'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'filename': file.path.split(Platform.pathSeparator).last,
        }),
      );

      if (uploadDataResponse.statusCode != 200) {
        final error = jsonDecode(uploadDataResponse.body);
        throw Exception(
          'فشل الحصول على URL الرفع: ${error['error'] ?? uploadDataResponse.statusCode}',
        );
      }

      final uploadData = jsonDecode(uploadDataResponse.body);
      final uploadUrl = uploadData['uploadURL'] as String?;
      final viewUrl = uploadData['viewURL'] as String?;

      if (uploadUrl == null || viewUrl == null) {
        throw Exception('لم يتم الحصول على URL الرفع من Worker');
      }

      debugPrint('✅ تم الحصول على URL الرفع');

      // 2. رفع الصورة إلى Cloudflare Images مباشرة
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      final fileStream = file.openRead();
      final fileLength = await file.length();
      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: file.path.split(Platform.pathSeparator).last,
      );
      request.files.add(multipartFile);

      debugPrint('📤 جاري رفع الصورة إلى Cloudflare Images...');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('فشل رفع الصورة: ${response.statusCode}');
      }

      debugPrint('✅ تم رفع الصورة بنجاح: $viewUrl');

      return viewUrl;
    } catch (e) {
      debugPrint('❌ خطأ في رفع الصورة: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('خطأ في رفع الصورة: ${e.toString()}');
    }
  }

  /// التحقق من صحة الإعدادات
  static bool isConfigured() {
    return _workerUrl != null &&
        _baseUrl != null &&
        _workerUrl!.isNotEmpty &&
        _baseUrl!.isNotEmpty;
  }
}
