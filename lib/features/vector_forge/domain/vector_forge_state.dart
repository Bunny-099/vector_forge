/// Domain layer: the immutable screen state for Vector Forge.
/// Holds only data and pure derivations — no Flutter, no Riverpod.
library;

import '../../../core/math/vec3.dart';
import 'vector_op.dart';

/// The whole screen state, held by the Riverpod Notifier below.
class VectorForgeState {
  final Vec3 a;
  final Vec3 b;
  final VectorOp op;
  final bool mode3D;
  final bool showComponents;
  final bool showArc;
  final double yaw;
  final double pitch;

  const VectorForgeState({
    this.a = const Vec3(3, 4, 0),
    this.b = const Vec3(-2, 1.5, 0),
    this.op = VectorOp.add,
    this.mode3D = false,
    this.showComponents = true,
    this.showArc = true,
    this.yaw = -0.6,
    this.pitch = 0.45,
  });

  /// Resultant for ADD / SUB / CROSS; null for DOT (scalar result).
  Vec3? get result {
    switch (op) {
      case VectorOp.add:
        return a + b;
      case VectorOp.subtract:
        return a - b;
      case VectorOp.cross:
        return a.cross(b);
      case VectorOp.dot:
        return null;
    }
  }

  String get opSymbol {
    switch (op) {
      case VectorOp.add:
        return '+';
      case VectorOp.subtract:
        return '−';
      case VectorOp.dot:
        return '·';
      case VectorOp.cross:
        return '×';
    }
  }

  VectorForgeState copyWith({
    Vec3? a,
    Vec3? b,
    VectorOp? op,
    bool? mode3D,
    bool? showComponents,
    bool? showArc,
    double? yaw,
    double? pitch,
  }) {
    return VectorForgeState(
      a: a ?? this.a,
      b: b ?? this.b,
      op: op ?? this.op,
      mode3D: mode3D ?? this.mode3D,
      showComponents: showComponents ?? this.showComponents,
      showArc: showArc ?? this.showArc,
      yaw: yaw ?? this.yaw,
      pitch: pitch ?? this.pitch,
    );
  }
}
