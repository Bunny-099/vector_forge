/// Application layer (Riverpod): Notifier for Coordinate Geometry plane.
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/coordinate_geometry_state.dart';

class CoordinateGeometryNotifier extends Notifier<CoordinateGeometryState> {
  static const double range = 7;

  @override
  CoordinateGeometryState build() => const CoordinateGeometryState();

  void setSelected(String point) {
    state = state.copyWith(selected: point);
  }

  Offset _toMath(Offset local, Size size) {
    final unit = math.min(size.width, size.height) / (range * 2);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final x = ((local.dx - cx) / unit).roundToDouble();
    final y = (-(local.dy - cy) / unit).roundToDouble();
    return Offset(
      x.clamp(-range, range).toDouble(),
      y.clamp(-range, range).toDouble(),
    );
  }

  void movePoint(Offset local, Size size) {
    final p = _toMath(local, size);
    if (state.selected == 'A') {
      state = state.copyWith(a: p);
    } else {
      state = state.copyWith(b: p);
    }
  }
}

final coordinateGeometryProvider =
    NotifierProvider<CoordinateGeometryNotifier, CoordinateGeometryState>(
        CoordinateGeometryNotifier.new);
