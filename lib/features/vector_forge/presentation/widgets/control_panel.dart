/// Presentation widget: everything under the canvas — mode toggle,
/// vector inputs, operation selector, display toggles, results, reset.
/// Sends every change to the Riverpod Notifier; holds no state itself.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/vector_forge_notifier.dart';
import '../../domain/vector_op.dart';
import 'result_card.dart';
import 'vector_input_row.dart';

class ControlPanel extends ConsumerWidget {
  final List<TextEditingController> aControllers;
  final List<TextEditingController> bControllers;

  /// Called after a reset so the page can re-sync its text fields.
  final VoidCallback onReset;

  const ControlPanel({
    super.key,
    required this.aControllers,
    required this.bControllers,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(vectorForgeProvider);
    final notifier = ref.read(vectorForgeProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('2D')),
              ButtonSegment(value: true, label: Text('3D')),
            ],
            selected: {s.mode3D},
            onSelectionChanged: (sel) => notifier.setMode3D(sel.first),
          ),
          const SizedBox(height: 6),
          Text(
            s.mode3D
                ? '3D mode: drag the canvas to rotate the view.'
                : 'Type exact values, or drag the arrow tips on the plane.',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          VectorInputRow(
            name: 'A',
            color: Colors.blue,
            controllers: aControllers,
            onComponent: notifier.setAComponent,
          ),
          const SizedBox(height: 12),
          VectorInputRow(
            name: 'B',
            color: Colors.green,
            controllers: bControllers,
            onComponent: notifier.setBComponent,
          ),
          const SizedBox(height: 12),
          SegmentedButton<VectorOp>(
            segments: const [
              ButtonSegment(value: VectorOp.add, label: Text('ADD')),
              ButtonSegment(value: VectorOp.subtract, label: Text('SUB')),
              ButtonSegment(value: VectorOp.dot, label: Text('DOT')),
              ButtonSegment(value: VectorOp.cross, label: Text('CROSS')),
            ],
            selected: {s.op},
            onSelectionChanged: (sel) => notifier.setOp(sel.first),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Expanded(child: Text('Components')),
              Switch(
                value: s.showComponents,
                onChanged: notifier.setShowComponents,
              ),
              const Expanded(child: Text('Angle arc')),
              Switch(
                value: s.showArc,
                onChanged: notifier.setShowArc,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const ResultCard(),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              notifier.reset();
              onReset();
            },
            child: const Text('Reset to A (3, 4, 0) and B (−2, 1.5, 0)'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hand checks: A=(3,4,0) → |A|=5.00, α=53.13° β=36.87° γ=90.00°.\n'
            'A=(5,4,0), B=(−2,1.5,0) → A·B=−4.00, θ=104.47°.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
