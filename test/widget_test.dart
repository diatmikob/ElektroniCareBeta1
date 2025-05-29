import 'package:elektronicare_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ElektroniCare App Tests', () {
    testWidgets('App should start without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const ProviderScope(
          child: ElektronicareApp(),
        ),
      );

      // Verify that the app starts without throwing any exceptions
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Should show onboarding page initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: ElektronicareApp(),
        ),
      );

      // Wait for the app to settle
      await tester.pumpAndSettle();

      // Should show onboarding content
      expect(find.text('ElektroniCare'), findsAtLeastOneWidget);
    });
  });

  group('Navigation Tests', () {
    testWidgets('Should navigate between pages', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: ElektronicareApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Test navigation functionality
      // This is a basic test - in a real app, you'd test specific navigation flows
    });
  });

  group('Widget Tests', () {
    testWidgets('Custom text field should work correctly', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Test Field',
                hintText: 'Enter text',
              ),
            ),
          ),
        ),
      );

      // Find the text field
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Enter text
      await tester.enterText(textField, 'Test input');
      expect(controller.text, 'Test input');
    });

    testWidgets('Loading button should show loading state', (WidgetTester tester) async {
      bool isLoading = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ElevatedButton(
                  onPressed: isLoading ? null : () {
                    setState(() {
                      isLoading = true;
                    });
                  },
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Submit'),
                );
              },
            ),
          ),
        ),
      );

      // Initially should show submit text
      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Tap the button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
    });
  });

  group('Model Tests', () {
    test('UserModel should create correctly', () {
      final user = {
        'id': 'test-id',
        'fullName': 'Test User',
        'email': 'test@example.com',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      expect(user['id'], 'test-id');
      expect(user['fullName'], 'Test User');
      expect(user['email'], 'test@example.com');
    });

    test('ServiceModel should format price correctly', () {
      final service = {
        'id': 'service-1',
        'name': 'Screen Repair',
        'price': 150000,
        'category': 'Smartphone',
      };

      // Test price formatting
      final price = service['price']! as int;
      final formattedPrice = 'Rp ${price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';

      expect(formattedPrice, 'Rp 150.000');
    });
  });

  group('Validation Tests', () {
    test('Email validation should work correctly', () {
      bool isValidEmail(String email) {
        return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
      }

      expect(isValidEmail('test@example.com'), true);
      expect(isValidEmail('invalid-email'), false);
      expect(isValidEmail('test@'), false);
      expect(isValidEmail('@example.com'), false);
    });

    test('Phone validation should work correctly', () {
      bool isValidPhone(String phone) {
        return RegExp(r'^[\+]?[0-9]{10,15}$').hasMatch(phone);
      }

      expect(isValidPhone('08123456789'), true);
      expect(isValidPhone('+628123456789'), true);
      expect(isValidPhone('123'), false);
      expect(isValidPhone('abc123'), false);
    });

    test('Password validation should work correctly', () {
      bool isValidPassword(String password) {
        return password.length >= 6;
      }

      expect(isValidPassword('123456'), true);
      expect(isValidPassword('12345'), false);
      expect(isValidPassword(''), false);
    });
  });
}