/// Presentation: Color Cube Matrix — colour-coded matrix inputs
/// with add, subtract, multiply, transpose and determinant.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatting.dart';
import '../application/matrix_notifier.dart';

class ColorCubeMatrixPage extends ConsumerStatefulWidget {
  const ColorCubeMatrixPage({super.key});

  @override
  ConsumerState<ColorCubeMatrixPage> createState() =>
      _ColorCubeMatrixPageState();
}

class _ColorCubeMatrixPageState extends ConsumerState<ColorCubeMatrixPage> {
  late final List<TextEditingController> aCtrl;
  late final List<TextEditingController> bCtrl;

  @override
  void initState() {
    super.initState();
    const aVals = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    const bVals = [9, 8, 7, 6, 5, 4, 3, 2, 1];
    aCtrl = [for (final v in aVals) TextEditingController(text: '$v')];
    bCtrl = [for (final v in bVals) TextEditingController(text: '$v')];
  }

  @override
  void dispose() {
    for (final c in aCtrl) {
      c.dispose();
    }
    for (final c in bCtrl) {
      c.dispose();
    }
    super.dispose();
  }

  List<double> _readFlat(List<TextEditingController> ctrls) => [
        for (final c in ctrls) double.tryParse(c.text.trim()) ?? 0,
      ];

  void _compute(String op) {
    ref.read(matrixProvider.notifier).compute(
          op,
          _readFlat(aCtrl),
          _readFlat(bCtrl),
        );
  }

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : fmtNum(v);

  Widget _matrix(
      String name, Color color, List<TextEditingController> ctrls, int n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Matrix $name',
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 6),
        for (var i = 0; i < n; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                for (var j = 0; j < n; j++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: TextField(
                        controller: ctrls[i * 3 + j],
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: color.withValues(alpha: 0.12),
                          border: const OutlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(matrixProvider);
    final n = state.n;

    return Scaffold(
      appBar: AppBar(title: const Text('Color Cube Matrix')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 2, label: Text('2 x 2')),
                ButtonSegment(value: 3, label: Text('3 x 3')),
              ],
              selected: {n},
              onSelectionChanged: (sel) =>
                  ref.read(matrixProvider.notifier).setSize(sel.first),
            ),
            const SizedBox(height: 16),
            _matrix('A', Colors.blue, aCtrl, n),
            const SizedBox(height: 8),
            _matrix('B', Colors.green, bCtrl, n),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                    onPressed: () => _compute('add'),
                    child: const Text('A + B')),
                FilledButton(
                    onPressed: () => _compute('sub'),
                    child: const Text('A − B')),
                FilledButton(
                    onPressed: () => _compute('mul'),
                    child: const Text('A × B')),
                OutlinedButton(
                    onPressed: () => _compute('transpose'),
                    child: const Text('Transpose A')),
                OutlinedButton(
                    onPressed: () => _compute('det'),
                    child: const Text('det(A)')),
              ],
            ),
            const SizedBox(height: 16),
            if (state.detValue != null)
              Text('det(A) = ${_fmt(state.detValue!)}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            if (state.result != null) ...[
              Text(state.resultLabel,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              for (var i = 0; i < n; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      for (var j = 0; j < n; j++)
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange),
                            ),
                            child: Text(_fmt(state.result![i][j]),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
