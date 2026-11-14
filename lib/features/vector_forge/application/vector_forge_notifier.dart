/// Application layer (Riverpod): the single Notifier that owns
/// Vector Forge state, plus its provider. Widgets call these methods;
/// they never mutate state directly.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/math/vec3.dart';
import '../domain/vector_forge_state.dart';
import '../domain/vector_op.dart';

class VectorForgeNotifier extends Notifier<VectorForgeState> {
  static const double range = 10; // values clamp to -10..10

  @override
  VectorForgeState build() => const VectorForgeState();

  void setAComponent(int i, double v) =>
      state = state.copyWith(a: state.a.withComponent(i, clampDouble(v, -range, range)));

  void setBComponent(int i, double v) =>
      state = state.copyWith(b: state.b.withComponent(i, clampDouble(v, -range, range)));

  /// Used by 2D tip-dragging: x/y change, z stays.
  void dragA(double x, double y) => state =
      state.copyWith(a: Vec3(clampDouble(x, -range, range), clampDouble(y, -range, range), state.a.z));

  void dragB(double x, double y) => state =
      state.copyWith(b: Vec3(clampDouble(x, -range, range), clampDouble(y, -range, range), state.b.z));

  void setOp(VectorOp op) => state = state.copyWith(op: op);
  void setMode3D(bool v) => state = state.copyWith(mode3D: v);
  void setShowComponents(bool v) => state = state.copyWith(showComponents: v);
  void setShowArc(bool v) => state = state.copyWith(showArc: v);

  void rotate(double dYaw, double dPitch) => state = state.copyWith(
        yaw: state.yaw + dYaw,
        pitch: clampDouble(state.pitch + dPitch, -1.2, 1.2),
      );

  void reset() => state = state.copyWith(
        a: const Vec3(3, 4, 0),
        b: const Vec3(-2, 1.5, 0),
        op: VectorOp.add,
      );
}

final vectorForgeProvider =
    NotifierProvider<VectorForgeNotifier, VectorForgeState>(VectorForgeNotifier.new);
