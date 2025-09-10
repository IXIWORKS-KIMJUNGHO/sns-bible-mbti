// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biblical_mbti_app/main.dart';

void main() {
  testWidgets('App launches correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: BiblicalMbtiApp()));

    // Verify that the onboarding screen is shown.
    expect(find.text('성경 인물 MBTI'), findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
  });
}
