/// Core maths: an immutable 3D vector and a small clamp helper.
/// Pure Dart — no Flutter imports, so this layer is trivially testable.
library;

import 'dart:math' as math;

/// Simple immutable 3D vector with the maths the brief asks for.
class Vec3 {
  final double x, y, z;
  const Vec3(this.x, this.y, this.z);

  Vec3 operator +(Vec3 o) => Vec3(x + o.x, y + o.y, z + o.z);
  Vec3 operator -(Vec3 o) => Vec3(x - o.x, y - o.y, z - o.z);

  Vec3 withComponent(int i, double v) =>
      i == 0 ? Vec3(v, y, z) : (i == 1 ? Vec3(x, v, z) : Vec3(x, y, v));

  double get magnitude => math.sqrt(x * x + y * y + z * z);

  double dot(Vec3 o) => x * o.x + y * o.y + z * o.z;

  Vec3 cross(Vec3 o) => Vec3(
        y * o.z - z * o.y,
        z * o.x - x * o.z,
        x * o.y - y * o.x,
      );

  double angleBetweenDeg(Vec3 o) {
    final m = magnitude * o.magnitude;
    if (m == 0) return double.nan;
    final c = clampDouble(dot(o) / m, -1.0, 1.0);
    return math.acos(c) * 180 / math.pi;
  }

  /// Direction angles in degrees: [alpha (to +X), beta (to +Y), gamma (to +Z)].
  List<double> directionAnglesDeg() {
    final m = magnitude;
    if (m == 0) return const [double.nan, double.nan, double.nan];
    double ang(double comp) =>
        math.acos(clampDouble(comp / m, -1.0, 1.0)) * 180 / math.pi;
    return [ang(x), ang(y), ang(z)];
  }

  @override
  bool operator ==(Object other) =>
      other is Vec3 && other.x == x && other.y == y && other.z == z;

  @override
  int get hashCode => Object.hash(x, y, z);
}

/// Clamps [v] into [lo, hi] without the num/double typing friction
/// of the SDK's clamp.
double clampDouble(double v, double lo, double hi) =>
    v < lo ? lo : (v > hi ? hi : v);
