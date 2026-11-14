/// Presentation widget: the results card.
/// Reads the state and the derived providers — no maths happens here.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/math/vec3.dart';
import '../../../../core/utils/formatting.dart';
import '../../application/derived_providers.dart';
import '../../application/vector_forge_notifier.dart';
import '../../domain/vector_op.dart';

class ResultCard extends ConsumerWidget {
  const ResultCard({super.key});

  Widget _angleLine(String name, Vec3 v) {
    final d = v.directionAnglesDeg();
    return Text(
        '$name: α=${fmtNum(d[0])}°  β=${fmtNum(d[1])}°  γ=${fmtNum(d[2])}°');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(vectorForgeProvider);
    final r = ref.watch(resultProvider);
    final dot = ref.watch(dotProductProvider);
    final cross = ref.watch(crossProductProvider);
    final theta = ref.watch(angleBetweenProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (s.op == VectorOp.dot)
              Text('A · B = ${fmtNum(dot)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))
            else
              Text(
                  'R = A ${s.opSymbol} B = (${fmtNum(r!.x)}, ${fmtNum(r.y)}, ${fmtNum(r.z)})',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text('|A| = ${fmtNum(s.a.magnitude)}    |B| = ${fmtNum(s.b.magnitude)}'
                '${r != null ? '    |R| = ${fmtNum(r.magnitude)}' : ''}'),
            Text('θ between A and B = ${fmtNum(theta)}°'),
            const SizedBox(height: 4),
            const Text('Direction angles:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            _angleLine('A', s.a),
            _angleLine('B', s.b),
            if (r != null) _angleLine('R', r),
            if (s.op != VectorOp.cross) ...[
              const SizedBox(height: 4),
              Text(
                  'A × B = (${fmtNum(cross.x)}, ${fmtNum(cross.y)}, ${fmtNum(cross.z)})'),
            ],
          ],
        ),
      ),
    );
  }
}
