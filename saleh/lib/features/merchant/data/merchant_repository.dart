import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/auth_token_storage.dart';
import '../domain/models/store.dart';

/// Store Repository
/// يتعامل مع جميع عمليات API الخاصة بالمتجر
///
/// المسارات الحقيقية من Cloudflare Worker:
/// - GET /secure/merchant/store -> جلب المتجر الحالي (يرجع null إذا لم يوجد)
/// - POST /secure/merchant/store -> إنشاء متجر جديد
/// - PUT /secure/stores/:id -> تحديث معلومات المتجر
///
/// Response format من Worker:
/// Success: { ok: true, data: { id, owner_id, name, status, is_active, ... } }
/// No Store: { ok: true, data: null }
/// Error: { ok: false, error: "...", detail: "..." }
class MerchantRepository {
  final ApiService _apiService;
  final AuthTokenStorage _tokenStorage;

  MerchantRepository(this._apiService, this._tokenStorage);

  /// جلب متجر التاجر الحالي
  /// المسار: GET /secure/merchant/store
  /// يرجع null إذا لم يكن لدى التاجر متجر (وليس Exception)
  Future<Store?> getMerchantStore() async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('لا يوجد رمز وصول - يجب تسجيل الدخول');
      }

      final response = await _apiService.get(
        '/secure/merchant/store',
        headers: {'Authorization': 'Bearer $token'},
      );

      // Worker يرجع دائماً 200 حتى لو لا يوجد متجر
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['ok'] == true) {
          // إذا كانت data['data'] هي null، يعني التاجر ليس لديه متجر
          if (data['data'] == null) {
            return null;
          }
          return Store.fromJson(data['data'] as Map<String, dynamic>);
        }
      }

      // أي حالة أخرى تعتبر خطأ
      final data = jsonDecode(response.body);
      throw Exception(
        data['error'] ?? data['detail'] ?? 'فشل جلب بيانات المتجر',
      );
    } catch (e) {
      if (e.toString().contains('لا يوجد رمز وصول')) {
        rethrow;
      }
      throw Exception('خطأ في جلب بيانات المتجر: $e');
    }
  }

  /// إنشاء متجر جديد للتاجر
  /// المسار: POST /secure/merchant/store
  /// Body: { name, description?, city?, status? }
  /// Response 201: { ok: true, data: { id, owner_id, name, status, is_active } }
  /// Response 409: { ok: false, error: "Conflict", detail: "User already has a store" }
  Future<Store> createStore({
    required String name,
    String? description,
    String? city,
    String? status,
  }) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('لا يوجد رمز وصول - يجب تسجيل الدخول');
      }

      final response = await _apiService.post(
        '/secure/merchant/store',
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'name': name,
          if (description != null && description.isNotEmpty)
            'description': description,
          if (city != null && city.isNotEmpty) 'city': city,
          if (status != null) 'status': status,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['ok'] == true) {
        return Store.fromJson(data['data'] as Map<String, dynamic>);
      } else if (response.statusCode == 409) {
        // المستخدم لديه متجر بالفعل
        throw Exception('لديك متجر بالفعل');
      } else {
        // رسالة خطأ واضحة من Worker
        final errorMsg = data['detail'] ?? data['error'] ?? 'فشل إنشاء المتجر';
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('خطأ في الاتصال بالخادم: $e');
    }
  }

  /// تحديث معلومات المتجر
  /// المسار: PUT /secure/stores/:id
  /// Body: { name?, description?, city?, status?, store_settings? }
  Future<Store> updateStore({
    required String storeId,
    String? name,
    String? description,
    String? city,
    String? status,
    Map<String, dynamic>? settings,
  }) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('لا يوجد رمز وصول - يجب تسجيل الدخول');
      }

      // المسار الصحيح من Worker هو /secure/stores/:id وليس /secure/merchant/store/:id
      final response = await _apiService.put(
        '/secure/stores/$storeId',
        headers: {'Authorization': 'Bearer $token'},
        body: {
          if (name != null && name.isNotEmpty) 'name': name,
          if (description != null && description.isNotEmpty)
            'description': description,
          if (city != null && city.isNotEmpty) 'city': city,
          if (status != null) 'status': status,
          if (settings != null) 'store_settings': settings,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['ok'] == true) {
        return Store.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        final errorMsg = data['detail'] ?? data['error'] ?? 'فشل تحديث المتجر';
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('خطأ في الاتصال بالخادم: $e');
    }
  }
}

/// Provider للـ MerchantRepository
final merchantRepositoryProvider = Provider<MerchantRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final tokenStorage = ref.watch(authTokenStorageProvider);
  return MerchantRepository(apiService, tokenStorage);
});
