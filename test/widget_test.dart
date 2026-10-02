// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anime_verse/screens/home_screen.dart';
import 'package:anime_verse/main.dart';
import 'package:anime_verse/widgets/auth_content_width.dart';

void main() {
  test('Auth content width stays positive during initial zero-width frame', () {
    expect(resolveAuthContentWidth(0), 360);
    expect(resolveAuthContentWidth(390), 390);
    expect(resolveAuthContentWidth(800), 400);
  });

  testWidgets('App starts on the sign-in screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('Sign-in rejects empty and malformed credentials', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
    await tester.ensureVisible(signInButton);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);
    expect(find.text('Welcome Back!'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
    await tester.enterText(find.byType(TextFormField).last, '123');
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    expect(find.text('Masukkan email yang valid'), findsOneWidget);
    expect(find.text('Password minimal 6 karakter'), findsOneWidget);
    expect(find.text('Welcome Back!'), findsOneWidget);
  });

  testWidgets('Valid sign-in form opens the home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).first,
      'demo@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'demo123');
    final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
    await tester.ensureVisible(signInButton);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    expect(find.text('AnimeVerse'), findsOneWidget);
    expect(find.text('Black Clover'), findsOneWidget);
  });

  testWidgets('Sign-up rejects empty credentials', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);
    expect(find.text('Join AnimeVerse!'), findsOneWidget);
  });

  testWidgets('Selected anime opens correct details and favorites', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2436);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).first,
      'demo@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'demo123');
    final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
    await tester.ensureVisible(signInButton);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Koe no Katachi');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Koe no Katachi').last);
    await tester.pumpAndSettle();
    expect(find.text('Koe no Katachi'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Add to Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('Remove Favorite'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.favorite_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Koe no Katachi'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove from favorites'));
    await tester.pumpAndSettle();
    expect(find.text('No favorite anime yet'), findsOneWidget);
  });

  testWidgets('Home search and genre filters update the anime list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Black Clover'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'not-in-the-catalog');
    await tester.pumpAndSettle();
    expect(find.text('No anime matches your filters'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'hunter');
    await tester.pumpAndSettle();
    expect(find.text('Hunter x Hunter'), findsOneWidget);
    expect(find.text('Black Clover'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Drama'));
    await tester.tap(find.text('Drama'));
    await tester.pumpAndSettle();

    expect(find.text('Koe no Katachi'), findsOneWidget);
    expect(find.text('Black Clover'), findsNothing);
  });
}
