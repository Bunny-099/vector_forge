/// Application layer (Riverpod): derived providers.
/// Every computed result the UI shows comes from here, so widgets
/// stay dumb and the maths has exactly one home.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/math/vec3.dart';
import 'vector_forge_notifier.dart';

final resultProvider = Provider<Vec3?>((ref) => ref.watch(vectorForgeProvider).result);

final dotProductProvider = Provider<double>((ref) {
  final s = ref.watch(vectorForgeProvider);
  return s.a.dot(s.b);
});

final crossProductProvider = Provider<Vec3>((ref) {
  final s = ref.watch(vectorForgeProvider);
  return s.a.cross(s.b);
});

final angleBetweenProvider = Provider<double>((ref) {
  final s = ref.watch(vectorForgeProvider);
  return s.a.angleBetweenDeg(s.b);
});
