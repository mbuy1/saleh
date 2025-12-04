import 'dart:io';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

/// Media Service
/// Handles image and video uploads to Cloudflare
class MediaService {
  /// Upload image to Cloudflare Images
  static Future<String?> uploadImage(File imageFile) async {
    try {
      final url = await ApiService.uploadImage(imageFile.path);
      return url;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  /// Upload multiple images
  static Future<List<String>> uploadImages(List<File> imageFiles) async {
    final urls = <String>[];

    for (final file in imageFiles) {
      final url = await uploadImage(file);
      if (url != null) {
        urls.add(url);
      }
    }

    return urls;
  }

  /// Get image upload URL (for manual upload)
  static Future<Map<String, dynamic>?> getImageUploadUrl(
    String filename,
  ) async {
    try {
      return await ApiService.getImageUploadUrl(filename);
    } catch (e) {
      debugPrint('Error getting image upload URL: $e');
      return null;
    }
  }

  /// Get video upload URL
  static Future<Map<String, dynamic>?> getVideoUploadUrl(
    String filename,
  ) async {
    try {
      return await ApiService.getVideoUploadUrl(filename);
    } catch (e) {
      debugPrint('Error getting video upload URL: $e');
      return null;
    }
  }
}
