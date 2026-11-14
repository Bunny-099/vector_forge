import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_forge/app.dart';

void main() {
  testWidgets('Home screen lists all six modules', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: VectorForgeApp()));
    await tester.pumpAndSettle();
    expect(find.text('Vector Forge'), findsOneWidget);
    expect(find.text('Math Arcade'), findsOneWidget);
  });
}
