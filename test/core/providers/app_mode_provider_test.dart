import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saleh/core/providers/app_mode_provider.dart';

void main() {
  group('AppModeController Tests', () {
    late ProviderContainer container;
    late AppModeController controller;

    setUp(() {
      container = ProviderContainer();
      controller = container.read(appModeProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('الحالة الأولية يجب أن تكون merchant', () {
      final state = container.read(appModeProvider);
      expect(state.currentMode, AppMode.merchant);
      expect(state.isMerchant, true);
    });

    test('switchToCustomer يجب أن يغير إلى وضع العميل', () {
      controller.switchToCustomer();
      final state = container.read(appModeProvider);

      expect(state.currentMode, AppMode.customer);
      expect(state.isCustomer, true);
      expect(state.isMerchant, false);
    });

    test('switchToMerchant يجب أن يغير إلى وضع التاجر', () {
      controller.switchToCustomer();
      controller.switchToMerchant();
      final state = container.read(appModeProvider);

      expect(state.currentMode, AppMode.merchant);
      expect(state.isMerchant, true);
    });

    test('toggleMode يجب أن يبدل بين الأوضاع', () {
      // من merchant إلى customer
      controller.toggleMode();
      expect(container.read(appModeProvider).isCustomer, true);

      // من customer إلى merchant
      controller.toggleMode();
      expect(container.read(appModeProvider).isMerchant, true);
    });

    test('setMode يجب أن يعين الوضع مباشرة', () {
      controller.setMode(AppMode.customer);
      expect(container.read(appModeProvider).currentMode, AppMode.customer);

      controller.setMode(AppMode.merchant);
      expect(container.read(appModeProvider).currentMode, AppMode.merchant);
    });
  });

  group('AppMode Providers Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('currentAppModeProvider يجب أن يرجع الوضع الحالي', () {
      expect(container.read(currentAppModeProvider), AppMode.merchant);
    });

    test('isMerchantModeProvider يجب أن يرجع true للتاجر', () {
      expect(container.read(isMerchantModeProvider), true);
    });

    test('isCustomerModeProvider يجب أن يرجع false للتاجر', () {
      expect(container.read(isCustomerModeProvider), false);
    });
  });
}
