/// Presentation: Coordinate Geometry — place two points on a plane
/// and read off distance, midpoint, slope and the line equation.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/utils/formatting.dart';

class CoordinateGeometryPage extends StatefulWidget {
  const CoordinateGeometryPage({super.key});

  @override
  State<CoordinateGeometryPage> createState() =>
      _CoordinateGeometryPageState();
}

class _CoordinateGeometryPageState extends State<CoordinateGeometryPage> {
  Offset a = const Offset(2, 3);
  Offset b = const Offset(-3, -1);
  String selected = 'A';

  static const double range = 7;

  Offset _toMath(Offset local, Size size) {
    final unit = math.min(size.width, size.height) / (range * 2);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final x = ((local.dx - cx) / unit).roundToDouble();
    final y = (-(local.dy - cy) / unit).roundToDouble();
    return Offset(
      x.clamp(-range, range).toDouble(),
      y.clamp(-range, range).toDouble(),
    );
  }

  void _move(Offset local, Size size) {
    final p = _toMath(local, size);
    setState(() {
      if (selected == 'A') {
        a = p;
      } else {
        b = p;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    final dist = math.sqrt(dx * dx + dy * dy);
    final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
    final String slopeText;
    final String equationText;
    if (dx == 0) {
      slopeText = 'undefined (vertical line)';
      equationText = 'x = ${fmtNum(a.dx)}';
    } else {
      final m = dy / dx;
      final c = a.dy - m * a.dx;
      slopeText = fmtNum(m);
      equationText =
          'y = ${fmtNum(m)}x ${c >= 0 ? '+' : '−'} ${fmtNum(c.abs())}';
    }
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
                  selected: selected == 'A',
                  onSelected: (_) => setState(() => selected = 'A'),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('B'),
                  selected: selected == 'B',
                  onSelected: (_) => setState(() => selected = 'B'),
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
                  onTapDown: (d) => _move(d.localPosition, size),
                  onPanUpdate: (d) => _move(d.localPosition, size),
                  child: CustomPaint(
                    size: size,
                    painter: _PlanePainter(a: a, b: b),
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
                      'A = (${fmtNum(a.dx)}, ${fmtNum(a.dy)})    B = (${fmtNum(b.dx)}, ${fmtNum(b.dy)})',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Distance AB = ${fmtNum(dist)}'),
                  Text('Midpoint = (${fmtNum(mid.dx)}, ${fmtNum(mid.dy)})'),
                  Text('Slope = $slopeText'),
                  Text('Equation of line AB: $equationText'),
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
    const range = _CoordinateGeometryPageState.range;
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
