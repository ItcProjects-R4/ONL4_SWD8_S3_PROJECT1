import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipes/main.dart';

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
   
    await tester.pumpWidget(const MyApp(seenOnboarding: false, isLoggedIn: false));

   
    expect(find.text('إنشاء حساب'), findsWidgets);
  });
}