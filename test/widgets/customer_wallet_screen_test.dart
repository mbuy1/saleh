import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saleh/features/customer/presentation/screens/customer_wallet_screen.dart';

void main() {
  group('CustomerWalletScreen Widget Tests', () {
    testWidgets('should display loading indicator initially', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: CustomerWalletScreen(),
        ),
      );

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display app bar with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CustomerWalletScreen(),
        ),
      );

      // Wait for initial load
      await tester.pump();

      // Verify app bar title
      expect(find.text('محفظتي'), findsOneWidget);
    });

    testWidgets('should have refresh button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CustomerWalletScreen(),
        ),
      );

      await tester.pump();

      // Verify refresh button exists
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
  });
}

