import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_module/main.dart';

void main() {
  const authChannel = MethodChannel('com.empresa.flutter_sdk/auth');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(authChannel, (call) async {
          if (call.method == 'getAuthToken') {
            return 'ios-demo-token-1234567890';
          }

          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(authChannel, null);
  });

  testWidgets('SDK home renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('SDK Flutter'), findsOneWidget);
    expect(find.text('Modulo Flutter carregado'), findsOneWidget);
    expect(find.text('ios-...7890'), findsOneWidget);
  });
}
