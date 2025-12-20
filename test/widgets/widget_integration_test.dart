import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saleh/shared/widgets/shared_widgets.dart';

/// ============================================================================
/// Widget Integration Tests - اختبارات تكامل الـ Widgets
/// ============================================================================

void main() {
  group('MbuyPrimaryButton Widget Tests', () {
    testWidgets('يعرض النص بشكل صحيح', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MbuyPrimaryButton(label: 'اضغط هنا')),
        ),
      );

      expect(find.text('اضغط هنا'), findsOneWidget);
    });

    testWidgets('يستدعي onPressed عند الضغط', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MbuyPrimaryButton(
              label: 'اضغط',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(MbuyPrimaryButton));
      await tester.pump();

      expect(wasPressed, isTrue);
    });

    testWidgets('يعرض مؤشر التحميل عند isLoading', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MbuyPrimaryButton(label: 'جاري التحميل', isLoading: true),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('معطل عندما onPressed = null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MbuyPrimaryButton(label: 'معطل', onPressed: null),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });

  group('MbuyTextField Widget Tests', () {
    testWidgets('يقبل الإدخال', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MbuyTextField(label: 'الاسم', controller: controller),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'محمد');
      expect(controller.text, equals('محمد'));
    });

    testWidgets('يعرض العنوان', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MbuyTextField(label: 'البريد الإلكتروني')),
        ),
      );

      expect(find.text('البريد الإلكتروني'), findsOneWidget);
    });
  });

  group('MbuyEmptyState Widget Tests', () {
    testWidgets('يعرض الأيقونة والعنوان', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MbuyEmptyState(icon: Icons.inbox, title: 'لا توجد منتجات'),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('لا توجد منتجات'), findsOneWidget);
    });

    testWidgets('يعرض الوصف إذا وجد', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MbuyEmptyState(
              icon: Icons.inbox,
              title: 'لا توجد منتجات',
              subtitle: 'أضف منتجات جديدة للبدء',
            ),
          ),
        ),
      );

      expect(find.text('أضف منتجات جديدة للبدء'), findsOneWidget);
    });

    testWidgets('يعرض الزر إذا وجد', (WidgetTester tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MbuyEmptyState(
              icon: Icons.inbox,
              title: 'لا توجد منتجات',
              buttonLabel: 'إضافة منتج',
              onButtonPressed: () => buttonPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('إضافة منتج'), findsOneWidget);

      await tester.tap(find.text('إضافة منتج'));
      await tester.pump();

      expect(buttonPressed, isTrue);
    });
  });

  group('MbuyScaffold Widget Tests', () {
    testWidgets('يعرض الـ AppBar مع العنوان', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MbuyScaffold(
            title: 'صفحتي',
            body: Center(child: Text('المحتوى')),
          ),
        ),
      );

      expect(find.text('صفحتي'), findsOneWidget);
      expect(find.text('المحتوى'), findsOneWidget);
    });

    testWidgets('يخفي AppBar عند showAppBar = false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MbuyScaffold(
            title: 'صفحتي',
            showAppBar: false,
            body: Center(child: Text('المحتوى')),
          ),
        ),
      );

      expect(find.byType(AppBar), findsNothing);
    });
  });

  group('MbuyLoadingIndicator Widget Tests', () {
    testWidgets('يعرض مؤشر التحميل', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MbuyLoadingIndicator())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('MbuyBadge Widget Tests', () {
    testWidgets('يعرض الرقم', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MbuyBadge(label: '5')),
        ),
      );

      expect(find.text('5'), findsOneWidget);
    });
  });

  group('Form Validation Integration Tests', () {
    testWidgets('Form يتحقق من الحقول الفارغة', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'هذا الحقل مطلوب';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState?.validate();
                    },
                    child: const Text('تحقق'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // اضغط على الزر للتحقق
      await tester.tap(find.text('تحقق'));
      await tester.pump();

      // يجب أن تظهر رسالة الخطأ
      expect(find.text('هذا الحقل مطلوب'), findsOneWidget);
    });

    testWidgets('Form يمرر عند ملء الحقول', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      bool isValid = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'هذا الحقل مطلوب';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      isValid = formKey.currentState?.validate() ?? false;
                    },
                    child: const Text('تحقق'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // ادخل نص في الحقل
      await tester.enterText(find.byType(TextFormField), 'نص تجريبي');
      await tester.pump();

      // اضغط على الزر للتحقق
      await tester.tap(find.text('تحقق'));
      await tester.pump();

      // يجب أن يكون صالحاً
      expect(isValid, isTrue);
    });
  });
}
