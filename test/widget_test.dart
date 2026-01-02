import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_keyboard_app/app.dart';

void main() {
  testWidgets('Smart Keyboard app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: SmartKeyboardApp(),
      ),
    );

    // Verify the splash screen appears
    expect(find.text('Smart Keyboard'), findsOneWidget);
  });
}
