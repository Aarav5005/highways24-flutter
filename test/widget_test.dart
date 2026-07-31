import 'package:flutter_test/flutter_test.dart';
import 'package:highways24_flutter/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HighwaySetuApp());
    expect(find.byType(HighwaySetuApp), findsOneWidget);
  });
}
