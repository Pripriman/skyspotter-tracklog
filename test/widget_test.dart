import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tracklog/domain/aircraft_types.dart';
import 'package:tracklog/widgets/aircraft_silhouette.dart';

void main() {
  testWidgets('AircraftSilhouette renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: AircraftSilhouette(size: 80)),
        ),
      ),
    );
    expect(find.byType(AircraftSilhouette), findsOneWidget);
  });

  test('aircraft catalog covers common types', () {
    expect(AircraftCatalog.byId('a320').manufacturer, 'Airbus');
    expect(AircraftCatalog.byId('b738').family, '737 NG');
    expect(AircraftCatalog.byId('e190').manufacturer, 'Embraer');
  });
}
