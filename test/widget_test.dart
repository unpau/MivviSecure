import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mivvi_secure/main.dart';

void main() {
  testWidgets('welcome leads to dashboard and scanner', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MivviApp());
    expect(find.text('Lebih cermat sebelum klik.'), findsOneWidget);
    await tester.tap(find.text('Mulai demo Mivvi Secure'));
    await tester.pumpAndSettle();
    expect(find.text('Kenali risiko.\nJaga keamananmu.'), findsOneWidget);
    await tester.tap(find.text('Periksa', skipOffstage: false).last);
    await tester.pumpAndSettle();
    expect(find.text('Periksa pesan'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
