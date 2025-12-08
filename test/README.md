# 🧪 MBUY Flutter Tests

## 📋 نظرة عامة

Tests شاملة لمشروع MBUY Flutter.

---

## 🚀 التشغيل

### تشغيل جميع Tests

```bash
flutter test
```

### تشغيل test معين

```bash
flutter test test/features/auth/auth_repository_test.dart
```

### Coverage Report

```bash
flutter test --coverage
```

---

## 📁 هيكل Tests

```
test/
├── core/
│   └── services/
│       └── api_service_test.dart
├── features/
│   ├── auth/
│   │   └── auth_repository_test.dart
│   └── shared/
│       └── services/
│           └── order_status_service_test.dart
└── README.md
```

---

## ✅ Tests Coverage

### Core Services:
- 🔄 `ApiService` - HTTP client tests (placeholder)

### Auth:
- 🔄 `AuthRepository` - Authentication tests (placeholder)

### Order Management:
- 🔄 `OrderStatusService` - Order status tests (placeholder)

---

## 📝 إضافة Tests جديدة

### Unit Test Example

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyService Tests', () {
    test('should do something', () {
      // Arrange
      final input = 'test';
      
      // Act
      final result = myFunction(input);
      
      // Assert
      expect(result, equals('expected'));
    });
  });
}
```

### Widget Test Example

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('MyWidget should display text', (WidgetTester tester) async {
    // Build widget
    await tester.pumpWidget(
      MaterialApp(home: MyWidget()),
    );
    
    // Verify
    expect(find.text('Hello'), findsOneWidget);
  });
}
```

---

## 🔧 Mocking

### استخدام Mockito

```yaml
dev_dependencies:
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

```dart
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([ApiService])
void main() {
  test('should use mocked service', () {
    final mockApiService = MockApiService();
    when(mockApiService.get(any)).thenAnswer((_) async => {'ok': true});
    
    // Use mock in tests
  });
}
```

---

## 📊 Best Practices

1. **Arrange-Act-Assert Pattern**
   ```dart
   // Arrange: Setup
   final input = 'test';
   
   // Act: Execute
   final result = function(input);
   
   // Assert: Verify
   expect(result, expected);
   ```

2. **Test Naming**
   ```dart
   test('should return user when login is successful', () {});
   test('should throw error when credentials are invalid', () {});
   ```

3. **Group Related Tests**
   ```dart
   group('Login Tests', () {
     test('success case', () {});
     test('failure case', () {});
   });
   ```

---

## 🎯 التوصيات

1. ✅ كتابة tests لكل feature جديدة
2. ✅ استخدام mocks للـ external dependencies
3. ✅ Coverage > 80%
4. ✅ تشغيل tests قبل كل commit

---

