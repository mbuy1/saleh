import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_config.dart';
import '../../../../core/session/store_session.dart';
import '../../../../core/services/api_service.dart';
import '../../../auth/data/auth_repository.dart';
import 'merchant_dashboard_screen.dart';

class MerchantHomeScreen extends StatefulWidget {
  final AppModeProvider appModeProvider;

  const MerchantHomeScreen({super.key, required this.appModeProvider});

  @override
  State<MerchantHomeScreen> createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends State<MerchantHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // جلب store_id بعد أن يصبح context متاحاً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStoreId();
    });
  }

  /// جلب store_id من API وحفظه في StoreSession
  Future<void> _loadStoreId() async {
    try {
      final storeSession = context.read<StoreSession>();

      // جلب معلومات المستخدم الحالي من MBUY Auth
      final userId = await AuthRepository.getUserId();
      final userEmail = await AuthRepository.getUserEmail();

      debugPrint('🔍 [MerchantHome] بدء جلب معلومات المتجر...');
      debugPrint('🔍 [MerchantHome] User ID من Flutter: $userId');
      debugPrint('🔍 [MerchantHome] User Email: ${userEmail ?? "N/A"}');
      debugPrint(
        '🔍 [MerchantHome] Timestamp: ${DateTime.now().toIso8601String()}',
      );

      // إذا كان store_id محفوظاً بالفعل، لا حاجة لإعادة الجلب
      if (storeSession.hasStore) {
        debugPrint(
          '✅ [MerchantHome] Store ID موجود بالفعل: ${storeSession.storeId}',
        );
        return;
      }

      debugPrint('🔄 [MerchantHome] جاري جلب معلومات المتجر عبر Worker API...');

      // جلب المتجر عبر Worker API
      final result = await ApiService.get('/secure/merchant/store');

      debugPrint(
        '📥 [MerchantHome] استجابة API: ok=${result['ok']}, hasData=${result['data'] != null}, error=${result['error']}',
      );

      if (result['ok'] == true && result['data'] != null) {
        final store = result['data'] as Map<String, dynamic>;
        final storeId = store['id'] as String?;
        final ownerId = store['owner_id'] as String?;
        final storeName = store['name'] as String?;

        debugPrint(
          '📦 [MerchantHome] بيانات المتجر: storeId=$storeId, storeName=$storeName, ownerId=$ownerId, userId=$userId, userIdMatches=${ownerId == userId}',
        );

        if (storeId != null && storeId.isNotEmpty) {
          storeSession.setStoreId(storeId);
          debugPrint('✅ [MerchantHome] تم حفظ Store ID: $storeId');
          debugPrint('✅ [MerchantHome] Store Name: ${storeName ?? "N/A"}');
          debugPrint('✅ [MerchantHome] Owner ID من DB: $ownerId');
          debugPrint('✅ [MerchantHome] User ID من Flutter: $userId');
          if (ownerId != null && userId != null) {
            debugPrint(
              '${ownerId == userId ? "✅" : "⚠️"} [MerchantHome] تطابق User ID: ${ownerId == userId}',
            );
          }
        } else {
          debugPrint('⚠️ [MerchantHome] المتجر موجود لكن بدون ID');
          storeSession.clear();
        }
      } else {
        debugPrint('⚠️ [MerchantHome] لم يتم العثور على متجر لهذا الحساب');
        debugPrint('⚠️ [MerchantHome] Response: $result');
        storeSession.clear();
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [MerchantHome] خطأ في جلب Store ID: $e');
      debugPrint('❌ [MerchantHome] Stack trace: $stackTrace');
      // في حالة الخطأ، لا ننظف الـ session الموجود
    }
  }

  @override
  Widget build(BuildContext context) {
    // الصفحة الرئيسية للتاجر هي لوحة التحكم مباشرة
    return MerchantDashboardScreen(appModeProvider: widget.appModeProvider);
  }
}
