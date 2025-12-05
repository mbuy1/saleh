import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// خدمة رفع الصور إلى Cloudflare Images
class CloudflareImagesService {
  static String? _accountId;
  static String? _apiToken;
  static String? _baseUrl;

  /// تهيئة الخدمة (يجب استدعاؤها مرة واحدة في بداية التطبيق)
  static Future<void> initialize() async {
    _accountId = dotenv.env['CF_ACCOUNT_ID'];
    _apiToken = dotenv.env['CLOUDFLARE_IMAGES_TOKEN'];
    _baseUrl = dotenv.env['CLOUDFLARE_IMAGES_BASE_URL'];

    if (_accountId == null || _accountId!.isEmpty) {
      throw Exception('CF_ACCOUNT_ID غير موجود في ملف .env');
    }

    if (_apiToken == null || _apiToken!.isEmpty) {
      throw Exception('CLOUDFLARE_IMAGES_TOKEN غير موجود في ملف .env');
    }

    if (_baseUrl == null || _baseUrl!.isEmpty) {
      throw Exception('CLOUDFLARE_IMAGES_BASE_URL غير موجود في ملف .env');
    }
  }

  /// رفع صورة إلى Cloudflare Images
  ///
  /// [file]: ملف الصورة المراد رفعه
  /// [folder]: مجلد الصورة (مثل 'stores' أو 'products')
  ///
  /// Returns: URL الصورة النهائي
  /// Throws: Exception في حالة الفشل
  static Future<String> uploadImage(File file, {required String folder}) async {
    // التحقق من التهيئة
    if (_accountId == null || _apiToken == null || _baseUrl == null) {
      await initialize();
    }

    if (!await file.exists()) {
      throw Exception('الملف غير موجود');
    }

    try {
      // إنشاء URI للرفع
      final uploadUrl = Uri.parse(
        'https://api.cloudflare.com/client/v4/accounts/$_accountId/images/v1',
      );

      // إنشاء multipart request
      final request = http.MultipartRequest('POST', uploadUrl);

      // إضافة headers
      request.headers['Authorization'] = 'Bearer $_apiToken';

      // إضافة الصورة
      final fileStream = file.openRead();
      final fileLength = await file.length();
      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: file.path.split('/').last,
      );
      request.files.add(multipartFile);

      // إضافة metadata (folder)
      request.fields['metadata'] = jsonEncode({'folder': folder});

      // إرسال الطلب
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        final errorBody = jsonDecode(response.body);
        throw Exception(
          'فشل رفع الصورة: ${errorBody['errors']?[0]?['message'] ?? response.statusCode}',
        );
      }

      // تحليل الاستجابة
      final responseData = jsonDecode(response.body);
      final imageId = responseData['result']?['id'] as String?;

      if (imageId == null) {
        throw Exception('لم يتم الحصول على معرف الصورة من Cloudflare');
      }

      // بناء URL الصورة النهائي
      // Cloudflare Images يعيد URL بالصيغة: baseUrl/imageId/variant
      // variant يمكن أن يكون: public, thumbnail, avatar, etc.
      final imageUrl = '$_baseUrl$imageId/public';

      return imageUrl;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('خطأ في رفع الصورة: ${e.toString()}');
    }
  }

  /// التحقق من صحة الإعدادات
  static bool isConfigured() {
    return _accountId != null &&
        _apiToken != null &&
        _baseUrl != null &&
        _accountId!.isNotEmpty &&
        _apiToken!.isNotEmpty &&
        _baseUrl!.isNotEmpty;
  }
}
