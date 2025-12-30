import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/api_service.dart';

/// خدمة إدارة إعدادات بوابات الدفع للتاجر
class MerchantPaymentSettingsService {
  final ApiService _apiService;

  MerchantPaymentSettingsService({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  /// الحصول على البوابات المتاحة للإضافة
  Future<List<PaymentGatewayConfig>> getAvailableGateways() async {
    try {
      final response = await _apiService.get(
        '/secure/merchant/payments/gateways',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          final gateways = data['data'] as List;
          return gateways.map((g) => PaymentGatewayConfig.fromJson(g)).toList();
        }
      }

      throw Exception('فشل في جلب البوابات المتاحة');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ: ${e.toString()}');
    }
  }

  /// الحصول على بوابات الدفع المفعلة للمتجر
  Future<List<MerchantPaymentMethod>> getPaymentMethods() async {
    try {
      final response = await _apiService.get(
        '/secure/merchant/payments/settings',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          final methods = data['data'] as List;
          return methods.map((m) => MerchantPaymentMethod.fromJson(m)).toList();
        }
      }

      throw Exception('فشل في جلب إعدادات الدفع');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ: ${e.toString()}');
    }
  }

  /// إضافة بوابة دفع جديدة
  Future<MerchantPaymentMethod> addPaymentMethod({
    required String provider,
    String? displayName,
    String? apiKey,
    required String apiSecret,
    String? webhookSecret,
    bool isLiveMode = false,
    List<String> supportedMethods = const [],
    Map<String, dynamic>? extraData,
  }) async {
    try {
      final body = {
        'provider': provider,
        if (displayName != null) 'display_name': displayName,
        if (apiKey != null) 'api_key': apiKey,
        'api_secret': apiSecret,
        if (webhookSecret != null) 'webhook_secret': webhookSecret,
        'is_live_mode': isLiveMode,
        'supported_methods': supportedMethods,
        if (extraData != null) 'extra_data': extraData,
      };

      final response = await _apiService.post(
        '/secure/merchant/payments/settings',
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          return MerchantPaymentMethod.fromJson(data['data']);
        }

        throw Exception(data['error'] ?? 'فشل في إضافة البوابة');
      }

      final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
      throw Exception(errorData?['error'] ?? 'فشل في إضافة بوابة الدفع');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ أثناء الإضافة');
    }
  }

  /// تحديث إعدادات بوابة دفع
  Future<MerchantPaymentMethod> updatePaymentMethod({
    required String id,
    String? displayName,
    String? apiKey,
    String? apiSecret,
    String? webhookSecret,
    bool? isActive,
    bool? isDefault,
    bool? isLiveMode,
    List<String>? supportedMethods,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (displayName != null) body['display_name'] = displayName;
      if (apiKey != null) body['api_key'] = apiKey;
      if (apiSecret != null) body['api_secret'] = apiSecret;
      if (webhookSecret != null) body['webhook_secret'] = webhookSecret;
      if (isActive != null) body['is_active'] = isActive;
      if (isDefault != null) body['is_default'] = isDefault;
      if (isLiveMode != null) body['is_live_mode'] = isLiveMode;
      if (supportedMethods != null) {
        body['supported_methods'] = supportedMethods;
      }
      if (extraData != null) body['extra_data'] = extraData;

      final response = await _apiService.put(
        '/secure/merchant/payments/settings/$id',
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          return MerchantPaymentMethod.fromJson(data['data']);
        }

        throw Exception(data['error'] ?? 'فشل في التحديث');
      }

      final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
      throw Exception(errorData?['error'] ?? 'فشل في تحديث البوابة');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ أثناء التحديث');
    }
  }

  /// حذف بوابة دفع
  Future<void> deletePaymentMethod(String id) async {
    try {
      final response = await _apiService.delete(
        '/secure/merchant/payments/settings/$id',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          return;
        }

        throw Exception(data['error'] ?? 'فشل في الحذف');
      }

      final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
      throw Exception(errorData?['error'] ?? 'فشل في حذف البوابة');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ أثناء الحذف');
    }
  }

  /// اختبار الاتصال ببوابة الدفع
  Future<bool> testConnection(String id) async {
    try {
      final response = await _apiService.post(
        '/secure/merchant/payments/settings/$id/test',
        body: {},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['success'] == true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }
}

// ============================================================================
// Models
// ============================================================================

/// إعدادات بوابة دفع مفعلة للتاجر
class MerchantPaymentMethod {
  final String id;
  final String provider;
  final String? displayName;
  final bool isActive;
  final bool isDefault;
  final bool isLiveMode;
  final List<String> supportedMethods;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final PaymentGatewayConfig? gatewayInfo;

  MerchantPaymentMethod({
    required this.id,
    required this.provider,
    this.displayName,
    required this.isActive,
    required this.isDefault,
    required this.isLiveMode,
    required this.supportedMethods,
    required this.createdAt,
    this.updatedAt,
    this.gatewayInfo,
  });

  factory MerchantPaymentMethod.fromJson(Map<String, dynamic> json) {
    return MerchantPaymentMethod(
      id: json['id'] as String,
      provider: json['provider'] as String,
      displayName: json['display_name'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isDefault: json['is_default'] as bool? ?? false,
      isLiveMode: json['is_live_mode'] as bool? ?? false,
      supportedMethods:
          (json['supported_methods'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      gatewayInfo: json['gateway_info'] != null
          ? PaymentGatewayConfig.fromJson(json['gateway_info'])
          : null,
    );
  }

  String get displayNameOrDefault =>
      displayName ?? gatewayInfo?.nameAr ?? provider;
}

/// معلومات بوابة دفع متاحة
class PaymentGatewayConfig {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String website;
  final List<String> supportedMethods;
  final List<String> countries;
  final GatewayRequiredFields? requiredFields;

  PaymentGatewayConfig({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.website,
    required this.supportedMethods,
    required this.countries,
    this.requiredFields,
  });

  factory PaymentGatewayConfig.fromJson(Map<String, dynamic> json) {
    return PaymentGatewayConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
      description: json['description'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String? ?? '',
      website: json['website'] as String? ?? '',
      supportedMethods:
          (json['supportedMethods'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      countries:
          (json['countries'] as List?)?.map((e) => e as String).toList() ?? [],
      requiredFields: json['requiredFields'] != null
          ? GatewayRequiredFields.fromJson(json['requiredFields'])
          : null,
    );
  }

  /// أيقونة البوابة
  IconData get icon {
    switch (id) {
      case 'moyasar':
        return Icons.payment;
      case 'tap':
        return Icons.touch_app;
      case 'paytabs':
        return Icons.tab;
      case 'hyperpay':
        return Icons.flash_on;
      default:
        return Icons.credit_card;
    }
  }
}

/// الحقول المطلوبة لكل بوابة
class GatewayRequiredFields {
  final FieldConfig apiKey;
  final FieldConfig apiSecret;
  final FieldConfig webhookSecret;
  final Map<String, FieldConfig>? extra;

  GatewayRequiredFields({
    required this.apiKey,
    required this.apiSecret,
    required this.webhookSecret,
    this.extra,
  });

  factory GatewayRequiredFields.fromJson(Map<String, dynamic> json) {
    return GatewayRequiredFields(
      apiKey: FieldConfig.fromJson(json['api_key']),
      apiSecret: FieldConfig.fromJson(json['api_secret']),
      webhookSecret: FieldConfig.fromJson(json['webhook_secret']),
      extra: json['extra'] != null
          ? (json['extra'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, FieldConfig.fromJson(value)),
            )
          : null,
    );
  }
}

class FieldConfig {
  final bool required;
  final String label;
  final String labelAr;
  final String placeholder;

  FieldConfig({
    required this.required,
    required this.label,
    required this.labelAr,
    required this.placeholder,
  });

  factory FieldConfig.fromJson(Map<String, dynamic> json) {
    return FieldConfig(
      required: json['required'] as bool? ?? false,
      label: json['label'] as String? ?? '',
      labelAr: json['labelAr'] as String? ?? '',
      placeholder: json['placeholder'] as String? ?? '',
    );
  }
}

// ============================================================================
// Providers
// ============================================================================

final merchantPaymentSettingsServiceProvider =
    Provider<MerchantPaymentSettingsService>((ref) {
      return MerchantPaymentSettingsService();
    });

final availablePaymentGatewaysProvider =
    FutureProvider<List<PaymentGatewayConfig>>((ref) async {
      final service = ref.read(merchantPaymentSettingsServiceProvider);
      return service.getAvailableGateways();
    });

final merchantPaymentMethodsProvider =
    FutureProvider<List<MerchantPaymentMethod>>((ref) async {
      final service = ref.read(merchantPaymentSettingsServiceProvider);
      return service.getPaymentMethods();
    });

/// Notifier لتحديث قائمة طرق الدفع
class PaymentMethodsRefreshNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void refresh() {
    state++;
  }
}

final paymentMethodsRefreshProvider =
    NotifierProvider<PaymentMethodsRefreshNotifier, int>(
      PaymentMethodsRefreshNotifier.new,
    );

/// Provider محدث يعيد جلب البيانات عند التحديث
final refreshablePaymentMethodsProvider =
    FutureProvider<List<MerchantPaymentMethod>>((ref) async {
      ref.watch(paymentMethodsRefreshProvider); // يعيد الجلب عند تغيير القيمة
      final service = ref.read(merchantPaymentSettingsServiceProvider);
      return service.getPaymentMethods();
    });
