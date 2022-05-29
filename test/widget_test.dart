import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:red_hosen/login.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final instance = FakeFirebaseFirestore();
  await instance
      .collection('users')
      .doc("Therapist")
      .collection("Therapist")
      .add({
    'username': 'Bob',
  });
  final snapshot = await instance
      .collection('users')
      .doc("Therapist")
      .collection("Therapist")
      .get();
  print(snapshot.docs.length);

  testWidgets('TestTitle', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    final titleFinder = find.text('כניסה למערכת');
    expect(titleFinder, findsOneWidget);
  });

  group("LoginPage", () {
    testWidgets('TestEmail', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));
      final email = find.byKey(const Key("Email"));
      await tester.enterText(email, "");
      final loginButton = find.byKey(const Key("LoginButton"));
      await tester.tap(loginButton);
      await tester.pump();
      final res = find.text("אימייל לא תקין");
      expect(res, findsOneWidget);
    });

    testWidgets('TestPassword', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));
      final email = find.byKey(const Key("Email"));
      await tester.enterText(email, "test@test.com");
      final loginButton = find.byKey(const Key("LoginButton"));
      await tester.tap(loginButton);
      await tester.pump();
      final res = find.text("סיסמה לא תקינה");
      expect(res, findsOneWidget);
    });
  });

  group("LoginPage", () {
    testWidgets('TestEmail', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    });
  });
}
