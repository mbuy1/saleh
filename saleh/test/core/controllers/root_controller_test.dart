import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saleh/core/controllers/root_controller.dart';

void main() {
  group('RootController Tests', () {
    late ProviderContainer container;
    late RootController controller;

    setUp(() {
      container = ProviderContainer();
      controller = container.read(rootControllerProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('الحالة الأولية يجب أن تكون none', () {
      final state = container.read(rootControllerProvider);
      expect(state.currentApp, CurrentApp.none);
      expect(state.isInitialized, false);
    });

    test('switchToMerchantApp يجب أن يغير إلى تطبيق التاجر', () {
      controller.switchToMerchantApp();
      final state = container.read(rootControllerProvider);

      expect(state.currentApp, CurrentApp.merchant);
      expect(state.isMerchantApp, true);
      expect(state.isInitialized, true);
    });

    test('reset يجب أن يعيد الحالة للقيم الافتراضية', () {
      controller.switchToMerchantApp();
      controller.reset();
      final state = container.read(rootControllerProvider);

      expect(state.currentApp, CurrentApp.none);
      expect(state.isInitialized, false);
    });

    test('setLoginIntent يجب أن يحفظ نية تسجيل الدخول', () {
      controller.setLoginIntent(LoginIntent.merchant);
      final state = container.read(rootControllerProvider);

      expect(state.loginIntent, LoginIntent.merchant);
    });

    test('clearLoginIntent يجب أن يمسح نية تسجيل الدخول', () {
      controller.setLoginIntent(LoginIntent.merchant);
      controller.clearLoginIntent();
      final state = container.read(rootControllerProvider);

      expect(state.loginIntent, null);
    });

    test('initializeAfterLogin يجب أن ينتقل لتطبيق التاجر', () {
      controller.initializeAfterLogin();
      final state = container.read(rootControllerProvider);

      expect(state.isMerchantApp, true);
      expect(state.isInitialized, true);
    });
  });
}
