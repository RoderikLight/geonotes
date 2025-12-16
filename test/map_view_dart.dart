import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geonotes/features/notes/presentation/views/map_view.dart';

void main() {
  testWidgets('MapView muestra loader inicialmente', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MapView(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('MapView contiene AppBar y FAB', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MapView(),
      ),
    );

    // Avanza un frame (no esperamos GPS)
    await tester.pump();

    expect(find.text('Mapa de Notas'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
