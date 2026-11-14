/// Domain layer: state model for Coordinate Geometry.
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/utils/formatting.dart';

class CoordinateGeometryState {
  final Offset a;
  final Offset b;
  final String selected;

  const CoordinateGeometryState({
    this.a = const Offset(2, 3),
    this.b = const Offset(-3, -1),
    this.selected = 'A',
  });

  double get dx => b.dx - a.dx;
  double get dy => b.dy - a.dy;
  double get dist => math.sqrt(dx * dx + dy * dy);
  Offset get mid => Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);

  String get slopeText {
    if (dx == 0) {
      return 'undefined (vertical line)';
    }
    return fmtNum(dy / dx);
  }

  String get equationText {
    if (dx == 0) {
      return 'x = ${fmtNum(a.dx)}';
    }
    final m = dy / dx;
    final c = a.dy - m * a.dx;
    return 'y = ${fmtNum(m)}x ${c >= 0 ? '+' : '−'} ${fmtNum(c.abs())}';
  }

  CoordinateGeometryState copyWith({
    Offset? a,
    Offset? b,
    String? selected,
  }) {
    return CoordinateGeometryState(
      a: a ?? this.a,
      b: b ?? this.b,
      selected: selected ?? this.selected,
    );
  }
}
