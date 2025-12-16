import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// مستودع بيانات الـ Onboarding
/// يدير حالة عرض الـ Onboarding وFeature Tooltips
class OnboardingRepository {
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _featureTooltipsKey = 'seen_feature_tooltips';
  static const String _appVersionKey = 'last_seen_app_version';
  static const String _currentAppVersion = '2.0.0';

  /// التحقق إذا تم إكمال الـ Onboarding
  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  /// تعيين الـ Onboarding كمكتمل
  Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
    await prefs.setString(_appVersionKey, _currentAppVersion);
  }

  /// إعادة تعيين الـ Onboarding (للاختبار)
  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, false);
    await prefs.remove(_featureTooltipsKey);
  }

  /// التحقق إذا تم عرض tooltip معين
  Future<bool> hasSeenFeatureTooltip(String featureId) async {
    final prefs = await SharedPreferences.getInstance();
    final seenTooltips = prefs.getStringList(_featureTooltipsKey) ?? [];
    return seenTooltips.contains(featureId);
  }

  /// تعيين tooltip كمعروض
  Future<void> markFeatureTooltipSeen(String featureId) async {
    final prefs = await SharedPreferences.getInstance();
    final seenTooltips = prefs.getStringList(_featureTooltipsKey) ?? [];
    if (!seenTooltips.contains(featureId)) {
      seenTooltips.add(featureId);
      await prefs.setStringList(_featureTooltipsKey, seenTooltips);
    }
  }

  /// التحقق إذا كان هناك تحديث جديد للتطبيق
  Future<bool> hasNewAppVersion() async {
    final prefs = await SharedPreferences.getInstance();
    final lastVersion = prefs.getString(_appVersionKey);
    return lastVersion != _currentAppVersion;
  }

  /// الحصول على قائمة الميزات الجديدة في هذا الإصدار
  List<NewFeature> getNewFeatures() {
    return [
      const NewFeature(
        id: 'global_search',
        title: 'البحث السريع',
        description: 'ابحث في جميع ميزات التطبيق بنقرة واحدة',
        icon: 'search',
      ),
      const NewFeature(
        id: 'shortcuts',
        title: 'اختصاراتي',
        description: 'أضف اختصارات للميزات التي تستخدمها كثيراً',
        icon: 'shortcuts',
      ),
      const NewFeature(
        id: 'ai_tools',
        title: 'أدوات الذكاء الاصطناعي',
        description: 'استخدم AI لتوليد المحتوى وتحسين متجرك',
        icon: 'bot',
      ),
    ];
  }
}

/// نموذج ميزة جديدة
class NewFeature {
  final String id;
  final String title;
  final String description;
  final String icon;

  const NewFeature({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });
}

/// Provider للـ OnboardingRepository
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository();
});

/// Provider لحالة الـ Onboarding
final onboardingStateProvider = FutureProvider<bool>((ref) async {
  final repository = ref.read(onboardingRepositoryProvider);
  return repository.isOnboardingComplete();
});
