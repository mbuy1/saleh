import 'package:flutter/foundation.dart';
import 'api_service.dart';

/// خدمة الشحن والتوصيل
/// TODO: إكمال التنفيذ عند الحاجة
/// المفاتيح السرية يجب أن تكون في Worker Secrets، وليس هنا
class ShippingService {
  /// حساب تكلفة الشحن
  /// 
  /// Parameters:
  /// - address: عنوان التوصيل
  /// - city: المدينة
  /// - weight: وزن الطرد (كجم)
  /// - dimensions: أبعاد الطرد (سم)
  /// 
  /// Returns: Map with shipping cost and estimated delivery time
  static Future<Map<String, dynamic>> calculateShippingCost({
    required String address,
    required String city,
    double? weight,
    Map<String, double>? dimensions, // {width, height, length}
  }) async {
    try {
      debugPrint('[ShippingService] Calculating shipping cost for: $city');
      
      final response = await ApiService.post(
        '/secure/shipping/calculate',
        data: {
          'address': address,
          'city': city,
          if (weight != null) 'weight': weight,
          if (dimensions != null) 'dimensions': dimensions,
        },
      );

      if (response['ok'] == true) {
        return {
          'cost': response['data']?['cost'] ?? 0.0,
          'estimated_days': response['data']?['estimated_days'] ?? 3,
          'provider': response['data']?['provider'] ?? 'default',
          'tracking_number': response['data']?['tracking_number'],
        };
      } else {
        throw Exception(response['message'] ?? 'فشل حساب تكلفة الشحن');
      }
    } catch (e) {
      debugPrint('[ShippingService] Error calculating shipping cost: $e');
      rethrow;
    }
  }

  /// إنشاء شحنة جديدة
  /// 
  /// Parameters:
  /// - orderId: رقم الطلب
  /// - address: عنوان التوصيل
  /// - city: المدينة
  /// - phone: رقم الهاتف
  /// 
  /// Returns: Map with shipping details and tracking number
  static Future<Map<String, dynamic>> createShipment({
    required String orderId,
    required String address,
    required String city,
    required String phone,
  }) async {
    try {
      debugPrint('[ShippingService] Creating shipment for order: $orderId');
      
      final response = await ApiService.post(
        '/secure/shipping/create',
        data: {
          'order_id': orderId,
          'address': address,
          'city': city,
          'phone': phone,
        },
      );

      if (response['ok'] == true) {
        return {
          'shipment_id': response['data']?['shipment_id'],
          'tracking_number': response['data']?['tracking_number'],
          'estimated_delivery': response['data']?['estimated_delivery'],
          'provider': response['data']?['provider'],
        };
      } else {
        throw Exception(response['message'] ?? 'فشل إنشاء الشحنة');
      }
    } catch (e) {
      debugPrint('[ShippingService] Error creating shipment: $e');
      rethrow;
    }
  }

  /// تتبع الشحنة
  /// 
  /// Parameters:
  /// - trackingNumber: رقم التتبع
  /// 
  /// Returns: Map with tracking status and updates
  static Future<Map<String, dynamic>> trackShipment({
    required String trackingNumber,
  }) async {
    try {
      debugPrint('[ShippingService] Tracking shipment: $trackingNumber');
      
      final response = await ApiService.get(
        '/secure/shipping/track/$trackingNumber',
      );

      if (response['ok'] == true) {
        return {
          'status': response['data']?['status'],
          'current_location': response['data']?['current_location'],
          'updates': response['data']?['updates'] ?? [],
          'estimated_delivery': response['data']?['estimated_delivery'],
        };
      } else {
        throw Exception(response['message'] ?? 'فشل تتبع الشحنة');
      }
    } catch (e) {
      debugPrint('[ShippingService] Error tracking shipment: $e');
      rethrow;
    }
  }

  /// جلب مقدمي خدمة الشحن المتاحين
  /// 
  /// Returns: List of available shipping providers
  static Future<List<Map<String, dynamic>>> getAvailableProviders() async {
    try {
      debugPrint('[ShippingService] Fetching available providers');
      
      final response = await ApiService.get(
        '/public/shipping/providers',
        requireAuth: false,
      );

      if (response['ok'] == true) {
        return List<Map<String, dynamic>>.from(
          response['data']?['providers'] ?? [],
        );
      } else {
        throw Exception(response['message'] ?? 'فشل جلب مقدمي الخدمة');
      }
    } catch (e) {
      debugPrint('[ShippingService] Error fetching providers: $e');
      rethrow;
    }
  }
}

