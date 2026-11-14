/// Domain layer: state model for Geometry Sandbox.
library;

import 'dart:math' as math;

class GeometrySandboxState {
  final String shape;
  final double d1;
  final double d2;

  const GeometrySandboxState({
    this.shape = 'Square',
    this.d1 = 4,
    this.d2 = 3,
  });

  String get d1Label => switch (shape) {
        'Circle' => 'Radius',
        'Triangle' => 'Base',
        'Rectangle' => 'Width',
        _ => 'Side',
      };

  bool get needsD2 => shape == 'Rectangle' || shape == 'Triangle';

  ({double area, double perimeter, String formula}) get results {
    switch (shape) {
      case 'Circle':
        return (
          area: math.pi * d1 * d1,
          perimeter: 2 * math.pi * d1,
          formula: 'Area = πr², Circumference = 2πr',
        );
      case 'Rectangle':
        return (
          area: d1 * d2,
          perimeter: 2 * (d1 + d2),
          formula: 'Area = w × h, Perimeter = 2(w + h)',
        );
      case 'Triangle':
        final side = math.sqrt(math.pow(d1 / 2, 2) + math.pow(d2, 2));
        return (
          area: 0.5 * d1 * d2,
          perimeter: d1 + 2 * side,
          formula: 'Area = ½ × base × height (isosceles)',
        );
      default:
        return (
          area: d1 * d1,
          perimeter: 4 * d1,
          formula: 'Area = s², Perimeter = 4s',
        );
    }
  }

  GeometrySandboxState copyWith({
    String? shape,
    double? d1,
    double? d2,
  }) {
    return GeometrySandboxState(
      shape: shape ?? this.shape,
      d1: d1 ?? this.d1,
      d2: d2 ?? this.d2,
    );
  }
}
