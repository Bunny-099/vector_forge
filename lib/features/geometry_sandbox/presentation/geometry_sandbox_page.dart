/// Presentation: Geometry Sandbox — pick a shape, slide its
/// dimensions and watch area and perimeter update live.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatting.dart';
import '../application/geometry_sandbox_notifier.dart';

class GeometrySandboxPage extends ConsumerWidget {
  const GeometrySandboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(geometrySandboxProvider);
    final notifier = ref.read(geometrySandboxProvider.notifier);
    final r = s.results;

    return Scaffold(
      appBar: AppBar(title: const Text('Geometry Sandbox')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              children: [
                for (final shape in ['Square', 'Rectangle', 'Circle', 'Triangle'])
                  ChoiceChip(
                    label: Text(shape),
                    selected: s.shape == shape,
                    onSelected: (_) => notifier.setShape(shape),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomPaint(
                painter: _ShapePainter(shape: s.shape, d1: s.d1, d2: s.d2),
                child: const SizedBox.expand(),
              ),
            ),
            const SizedBox(height: 16),
            Text('${s.d1Label}: ${fmtNum(s.d1)}'),
            Slider(
              value: s.d1,
              min: 1,
              max: 10,
              divisions: 36,
              label: fmtNum(s.d1),
              onChanged: notifier.setD1,
            ),
            if (s.needsD2) ...[
              Text('${s.shape == 'Triangle' ? 'Height' : 'Length'}: ${fmtNum(s.d2)}'),
              Slider(
                value: s.d2,
                min: 1,
                max: 10,
                divisions: 36,
                label: fmtNum(s.d2),
                onChanged: notifier.setD2,
              ),
            ],
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Area = ${fmtNum(r.area)}',
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    Text(
                        '${s.shape == 'Circle' ? 'Circumference' : 'Perimeter'} = ${fmtNum(r.perimeter)}',
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(r.formula,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final String shape;
  final double d1;
  final double d2;

  _ShapePainter({required this.shape, required this.d1, required this.d2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurple.shade200
      ..style = PaintingStyle.fill;
    final border = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final center = Offset(size.width / 2, size.height / 2);
    final maxDim = math.max(d1, _needsD2 ? d2 : d1);
    final s = math.min(size.width, size.height) * 0.8;
    final w = s * d1 / maxDim;
    final h = s * (shape == 'Square' || shape == 'Circle' ? d1 : d2) / maxDim;
    switch (shape) {
      case 'Circle':
        canvas.drawCircle(center, w / 2, paint);
        canvas.drawCircle(center, w / 2, border);
        break;
      case 'Triangle':
        final path = Path()
          ..moveTo(center.dx, center.dy - h / 2)
          ..lineTo(center.dx - w / 2, center.dy + h / 2)
          ..lineTo(center.dx + w / 2, center.dy + h / 2)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawPath(path, border);
        break;
      default:
        final rect = Rect.fromCenter(center: center, width: w, height: h);
        canvas.drawRect(rect, paint);
        canvas.drawRect(rect, border);
        break;
    }
  }

  bool get _needsD2 => shape == 'Rectangle' || shape == 'Triangle';

  @override
  bool shouldRepaint(covariant _ShapePainter old) =>
      old.shape != shape || old.d1 != d1 || old.d2 != d2;
}
