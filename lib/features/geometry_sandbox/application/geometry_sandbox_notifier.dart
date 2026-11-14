/// Application layer (Riverpod): Notifier for Geometry Sandbox shapes.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/geometry_sandbox_state.dart';

class GeometrySandboxNotifier extends Notifier<GeometrySandboxState> {
  @override
  GeometrySandboxState build() => const GeometrySandboxState();

  void setShape(String shape) {
    state = state.copyWith(shape: shape);
  }

  void setD1(double v) {
    state = state.copyWith(d1: v);
  }

  void setD2(double v) {
    state = state.copyWith(d2: v);
  }
}

final geometrySandboxProvider =
    NotifierProvider<GeometrySandboxNotifier, GeometrySandboxState>(
        GeometrySandboxNotifier.new);
