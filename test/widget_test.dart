import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:susru_app/main.dart';

void main() {
  testWidgets('App launches to the home dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const SusruApp());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.mic), findsOneWidget);
  });
}
