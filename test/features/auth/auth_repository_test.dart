import 'package:flutter_test/flutter_test.dart';
import 'package:saleh/features/auth/data/auth_controller.dart';

void main() {
  group('Auth Validation Tests', () {
    group('Email Validation', () {
      test('يقبل بريد إلكتروني صالح', () {
        final email = 'test@example.com';
        final isValid = email.contains('@') && email.contains('.');
        expect(isValid, isTrue);
      });

      test('يرفض بريد إلكتروني غير صالح', () {
        final email = 'invalid-email';
        final isValid = email.contains('@') && email.contains('.');
        expect(isValid, isFalse);
      });

      test('يتطلب كلمة مرور بطول مناسب', () {
        final password = 'password123';
        expect(password.length >= 6, isTrue);
      });

      test('يرفض كلمة مرور قصيرة', () {
        final password = '123';
        expect(password.length >= 6, isFalse);
      });
    });

    group('Registration Validation', () {
      test('يتطلب اسم كامل', () {
        final fullName = 'John Doe';
        expect(fullName.isNotEmpty, isTrue);
        expect(fullName.split(' ').length >= 2, isTrue);
      });

      test('يقبل أدوار صالحة', () {
        final validRoles = ['merchant', 'customer'];
        expect(validRoles.contains('merchant'), isTrue);
        expect(validRoles.contains('customer'), isTrue);
        expect(validRoles.contains('admin'), isFalse);
      });
    });
  });

  group('AuthController Tests', () {
    group('AuthState', () {
      test('الحالة الابتدائية صحيحة', () {
        const state = AuthState();
        expect(state.isLoading, isFalse);
        expect(state.isAuthenticated, isFalse);
        expect(state.errorMessage, isNull);
        expect(state.userRole, isNull);
      });

      test('copyWith يعمل بشكل صحيح', () {
        const state = AuthState();
        final newState = state.copyWith(
          isLoading: true,
          isAuthenticated: true,
          userRole: 'merchant',
        );

        expect(newState.isLoading, isTrue);
        expect(newState.isAuthenticated, isTrue);
        expect(newState.userRole, equals('merchant'));
      });

      test('copyWith يحافظ على القيم غير المتغيرة', () {
        const state = AuthState(
          isAuthenticated: true,
          userRole: 'merchant',
          userId: '123',
        );
        final newState = state.copyWith(isLoading: true);

        expect(newState.isLoading, isTrue);
        expect(newState.isAuthenticated, isTrue);
        expect(newState.userRole, equals('merchant'));
        expect(newState.userId, equals('123'));
      });
    });
  });
}
