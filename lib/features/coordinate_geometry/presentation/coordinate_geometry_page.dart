/// Presentation: Coordinate Geometry — place two points on a plane
/// and read off distance, midpoint, slope and the line equation.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatting.dart';
import '../application/coordinate_geometry_notifier.dart';

class CoordinateGeometryPage extends ConsumerWidget {
  const CoordinateGeometryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(coordinateGeometryProvider);
    final notifier = ref.read(coordinateGeometryProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Coordinate Geometry')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                const Text('Move point:'),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('A'),
                  selected: s.selected == 'A',
                  onSelected: (_) => notifier.setSelected('A'),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('B'),
                  selected: s.selected == 'B',
                  onSelected: (_) => notifier.setSelected('B'),
                ),
                const Spacer(),
                const Text('tap or drag on the plane',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size =
                    Size(constraints.maxWidth, constraints.maxHeight);
                return GestureDetector(
                  onTapDown: (d) => notifier.movePoint(d.localPosition, size),
                  onPanUpdate: (d) => notifier.movePoint(d.localPosition, size),
                  child: CustomPaint(
                    size: size,
                    painter: _PlanePainter(a: s.a, b: s.b),
                  ),
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'A = (${fmtNum(s.a.dx)}, ${fmtNum(s.a.dy)})    B = (${fmtNum(s.b.dx)}, ${fmtNum(s.b.dy)})',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Distance AB = ${fmtNum(s.dist)}'),
                  Text(
                      'Midpoint = (${fmtNum(s.mid.dx)}, ${fmtNum(s.mid.dy)})'),
                  Text('Slope = ${s.slopeText}'),
                  Text('Equation of line AB: ${s.equationText}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanePainter extends CustomPainter {
  final Offset a;
  final Offset b;

  _PlanePainter({required this.a, required this.b});

  @override
  void paint(Canvas canvas, Size size) {
    const range = CoordinateGeometryNotifier.range;
    final unit = math.min(size.width, size.height) / (range * 2);
    final origin = Offset(size.width / 2, size.height / 2);
    Offset toCanvas(Offset p) =>
        Offset(origin.dx + p.dx * unit, origin.dy - p.dy * unit);

    final grid = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;
    for (var i = -range.toInt(); i <= range.toInt(); i++) {
      canvas.drawLine(toCanvas(Offset(i.toDouble(), -range)),
          toCanvas(Offset(i.toDouble(), range)), grid);
      canvas.drawLine(toCanvas(Offset(-range, i.toDouble())),
          toCanvas(Offset(range, i.toDouble())), grid);
    }
    final axis = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 1.6;
    canvas.drawLine(toCanvas(const Offset(-range, 0)),
        toCanvas(const Offset(range, 0)), axis);
    canvas.drawLine(toCanvas(const Offset(0, -range)),
        toCanvas(const Offset(0, range)), axis);

    if (a != b) {
      final dir = b - a;
      final line = Paint()
        ..color = Colors.deepPurple.shade300
        ..strokeWidth = 2;
      canvas.drawLine(toCanvas(a - dir * 10), toCanvas(a + dir * 10), line);
    }

    void drawPoint(Offset p, Color color, String label) {
      canvas.drawCircle(toCanvas(p), 7, Paint()..color = color);
      final tp = TextPainter(
        text: TextSpan(
            text: label,
            style: TextStyle(
                color: color, fontSize: 15, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, toCanvas(p) + const Offset(10, -20));
    }

    drawPoint(a, Colors.blue, 'A');
    drawPoint(b, Colors.green, 'B');
  }

  @override
  bool shouldRepaint(covariant _PlanePainter old) => old.a != a || old.b != b;
}
