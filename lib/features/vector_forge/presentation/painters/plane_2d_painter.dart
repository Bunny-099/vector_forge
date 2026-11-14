/// Presentation: the flat 2D grid painter (grid, axes, components,
/// construction lines, angle arc, vectors).
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/math/vec3.dart';
import '../../domain/vector_op.dart';


class Plane2DPainter extends CustomPainter {
  final Vec3 a, b;
  final Vec3? result;
  final VectorOp op;
  final double range;
  final bool showComponents;
  final bool showArc;

  Plane2DPainter({
    required this.a,
    required this.b,
    required this.result,
    required this.op,
    required this.range,
    required this.showComponents,
    required this.showArc,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width, size.height) / (range * 2 + 2);
    final origin = Offset(size.width / 2, size.height / 2);
    Offset toScreen(double x, double y) =>
        Offset(origin.dx + x * scale, origin.dy - y * scale);

    // Grid + axes.
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;
    for (double i = -range; i <= range; i++) {
      canvas.drawLine(toScreen(i, -range), toScreen(i, range), gridPaint);
      canvas.drawLine(toScreen(-range, i), toScreen(range, i), gridPaint);
    }
    final axisPaint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 1.5;
    canvas.drawLine(toScreen(-range, 0), toScreen(range, 0), axisPaint);
    canvas.drawLine(toScreen(0, -range), toScreen(0, range), axisPaint);

    if (showComponents) {
      _components(canvas, toScreen, a);
      _components(canvas, toScreen, b);
    }

    // Construction lines: parallelogram for ADD, -B leg for SUB.
    final r = result;
    if (r != null && (op == VectorOp.add || op == VectorOp.subtract)) {
      final guide = Paint()
        ..color = Colors.grey
        ..strokeWidth = 1.5;
      _dashed(canvas, toScreen(a.x, a.y), toScreen(r.x, r.y), guide);
      if (op == VectorOp.add) {
        _dashed(canvas, toScreen(b.x, b.y), toScreen(r.x, r.y), guide);
      }
    }

    // Angle arc between A and B (2D directions).
    if (showArc) _arc(canvas, toScreen, scale);

    _vector(canvas, toScreen, a, Colors.blue, 'A');
    _vector(canvas, toScreen, b, Colors.green.shade700, 'B');
    if (r != null) {
      final rLen2D = math.sqrt(r.x * r.x + r.y * r.y);
      if (rLen2D > 0.05) {
        _vector(canvas, toScreen, r, Colors.deepOrange, 'R');
      } else if (r.z.abs() > 0.001) {
        // Pure-Z resultant (typical for CROSS of two flat vectors):
        // draw it as a ring on the origin, pointing out of the plane.
        final o = toScreen(0, 0);
        final ring = Paint()
          ..color = Colors.deepOrange
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(o, 10, ring);
        canvas.drawCircle(o, 3, Paint()..color = Colors.deepOrange);
        _label(canvas, 'R (Z)', o + const Offset(14, -8), Colors.deepOrange);
      }
    }
  }

  void _arc(Canvas canvas, Offset Function(double, double) ts, double scale) {
    final la = math.sqrt(a.x * a.x + a.y * a.y);
    final lb = math.sqrt(b.x * b.x + b.y * b.y);
    if (la == 0 || lb == 0) return;
    final angA = math.atan2(a.y, a.x);
    var diff = math.atan2(b.y, b.x) - angA;
    while (diff > math.pi) diff -= 2 * math.pi;
    while (diff < -math.pi) diff += 2 * math.pi;
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    // Screen y is flipped, so both angles change sign.
    canvas.drawArc(
      Rect.fromCircle(center: ts(0, 0), radius: 1.5 * scale),
      -angA,
      -diff,
      false,
      paint,
    );
  }

  void _components(Canvas canvas, Offset Function(double, double) ts, Vec3 v) {
    if (v.x == 0 && v.y == 0) return;
    final paint = Paint()
      ..color = Colors.grey.shade500
      ..strokeWidth = 1;
    _dashed(canvas, ts(v.x, v.y), ts(v.x, 0), paint);
    _dashed(canvas, ts(v.x, v.y), ts(0, v.y), paint);
  }

  void _vector(Canvas canvas, Offset Function(double, double) ts, Vec3 v, Color color, String label) {
    final start = ts(0, 0);
    final end = ts(v.x, v.y);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, paint);
    if ((end - start).distance > 4) {
      final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);
      const headLen = 12.0;
      const headAngle = 0.45;
      final p1 = end - Offset(math.cos(angle - headAngle), math.sin(angle - headAngle)) * headLen;
      final p2 = end - Offset(math.cos(angle + headAngle), math.sin(angle + headAngle)) * headLen;
      canvas.drawLine(end, p1, paint);
      canvas.drawLine(end, p2, paint);
    }
    canvas.drawCircle(end, 8, Paint()..color = color);
    _label(canvas, label, end + const Offset(12, -22), color);
  }

  void _label(Canvas canvas, String text, Offset at, Color color) {
    final tp = TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, at);
  }

  void _dashed(Canvas canvas, Offset p, Offset q, Paint paint) {
    const dash = 7.0, gap = 5.0;
    final total = (q - p).distance;
    if (total == 0) return;
    final dir = (q - p) / total;
    double drawn = 0;
    while (drawn < total) {
      final end = math.min(drawn + dash, total);
      canvas.drawLine(p + dir * drawn, p + dir * end, paint);
      drawn = end + gap;
    }
  }

  @override
  bool shouldRepaint(covariant Plane2DPainter old) =>
      old.a != a ||
      old.b != b ||
      old.result != result ||
      old.op != op ||
      old.showComponents != showComponents ||
      old.showArc != showArc;
}
