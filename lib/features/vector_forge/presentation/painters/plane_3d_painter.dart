/// Presentation: the pseudo-3D painter (rotate, then orthographic
/// projection; floor grid on the XZ plane).
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/math/vec3.dart';


class Plane3DPainter extends CustomPainter {
  final Vec3 a, b;
  final Vec3? result;
  final double yaw, pitch;
  final bool showComponents;

  Plane3DPainter({
    required this.a,
    required this.b,
    required this.result,
    required this.yaw,
    required this.pitch,
    required this.showComponents,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width, size.height) / 16;
    final origin = Offset(size.width / 2, size.height / 2);
    final cy = math.cos(yaw), sy = math.sin(yaw);
    final cp = math.cos(pitch), sp = math.sin(pitch);

    Offset project(Vec3 v) {
      final x1 = v.x * cy + v.z * sy;
      final z1 = -v.x * sy + v.z * cy;
      final y2 = v.y * cp - z1 * sp;
      return Offset(origin.dx + x1 * scale, origin.dy - y2 * scale);
    }

    // Floor grid on the XZ plane (y = 0).
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;
    for (double i = -6; i <= 6; i += 2) {
      canvas.drawLine(project(Vec3(i, 0, -6)), project(Vec3(i, 0, 6)), gridPaint);
      canvas.drawLine(project(Vec3(-6, 0, i)), project(Vec3(6, 0, i)), gridPaint);
    }

    // Axes.
    final axisPaint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 1.5;
    canvas.drawLine(project(const Vec3(-6, 0, 0)), project(const Vec3(6, 0, 0)), axisPaint);
    canvas.drawLine(project(const Vec3(0, -6, 0)), project(const Vec3(0, 6, 0)), axisPaint);
    canvas.drawLine(project(const Vec3(0, 0, -6)), project(const Vec3(0, 0, 6)), axisPaint);
    _label(canvas, 'X', project(const Vec3(6.6, 0, 0)), Colors.black87);
    _label(canvas, 'Y', project(const Vec3(0, 6.6, 0)), Colors.black87);
    _label(canvas, 'Z', project(const Vec3(0, 0, 6.6)), Colors.black87);

    if (showComponents) {
      _components3D(canvas, project, a);
      _components3D(canvas, project, b);
    }

    _vector3D(canvas, project, a, Colors.blue, 'A');
    _vector3D(canvas, project, b, Colors.green.shade700, 'B');
    final r = result;
    if (r != null && r.magnitude > 0.001) {
      _vector3D(canvas, project, r, Colors.deepOrange, 'R');
    }
  }

  void _components3D(Canvas canvas, Offset Function(Vec3) project, Vec3 v) {
    final paint = Paint()
      ..color = Colors.grey.shade500
      ..strokeWidth = 1;
    final foot = Vec3(v.x, 0, v.z);
    canvas.drawLine(project(v), project(foot), paint);
    canvas.drawLine(project(foot), project(Vec3(v.x, 0, 0)), paint);
    canvas.drawLine(project(foot), project(Vec3(0, 0, v.z)), paint);
  }

  void _vector3D(Canvas canvas, Offset Function(Vec3) project, Vec3 v, Color color, String label) {
    final start = project(const Vec3(0, 0, 0));
    final end = project(v);
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
    canvas.drawCircle(end, 7, Paint()..color = color);
    _label(canvas, label, end + const Offset(10, -20), color);
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

  @override
  bool shouldRepaint(covariant Plane3DPainter old) =>
      old.a != a ||
      old.b != b ||
      old.result != result ||
      old.yaw != yaw ||
      old.pitch != pitch ||
      old.showComponents != showComponents;
}
