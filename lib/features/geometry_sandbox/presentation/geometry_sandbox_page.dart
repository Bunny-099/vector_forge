/// Presentation: Geometry Sandbox — pick a shape, slide its
/// dimensions and watch area and perimeter update live.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/utils/formatting.dart';

class GeometrySandboxPage extends StatefulWidget {
  const GeometrySandboxPage({super.key});

  @override
  State<GeometrySandboxPage> createState() => _GeometrySandboxPageState();
}

class _GeometrySandboxPageState extends State<GeometrySandboxPage> {
  String shape = 'Square';
  double d1 = 4; // side / width / radius / base
  double d2 = 3; // height / length (rectangle, triangle)

  String get _d1Label => switch (shape) {
        'Circle' => 'Radius',
        'Triangle' => 'Base',
        'Rectangle' => 'Width',
        _ => 'Side',
      };

  bool get _needsD2 => shape == 'Rectangle' || shape == 'Triangle';

  ({double area, double perimeter, String formula}) get _results {
    switch (shape) {
      case 'Circle':
        return (
          area: math.pi * d1 * d1,
          perimeter: 2 * math.pi * d1,
          formula: 'Area = πr², Circumference = 2πr',
        );
      case 'Rectangle':
        return (
          area: d1 * d2,
          perimeter: 2 * (d1 + d2),
          formula: 'Area = w × h, Perimeter = 2(w + h)',
        );
      case 'Triangle':
        final side = math.sqrt(math.pow(d1 / 2, 2) + math.pow(d2, 2));
        return (
          area: 0.5 * d1 * d2,
          perimeter: d1 + 2 * side,
          formula: 'Area = ½ × base × height (isosceles)',
        );
      default:
        return (
          area: d1 * d1,
          perimeter: 4 * d1,
          formula: 'Area = s², Perimeter = 4s',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = _results;
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
                for (final s in ['Square', 'Rectangle', 'Circle', 'Triangle'])
                  ChoiceChip(
                    label: Text(s),
                    selected: shape == s,
                    onSelected: (_) => setState(() => shape = s),
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
                painter: _ShapePainter(shape: shape, d1: d1, d2: d2),
                child: const SizedBox.expand(),
              ),
            ),
            const SizedBox(height: 16),
            Text('$_d1Label: ${fmtNum(d1)}'),
            Slider(
              value: d1,
              min: 1,
              max: 10,
              divisions: 36,
              label: fmtNum(d1),
              onChanged: (v) => setState(() => d1 = v),
            ),
            if (_needsD2) ...[
              Text('${shape == 'Triangle' ? 'Height' : 'Length'}: ${fmtNum(d2)}'),
              Slider(
                value: d2,
                min: 1,
                max: 10,
                divisions: 36,
                label: fmtNum(d2),
                onChanged: (v) => setState(() => d2 = v),
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
                        '${shape == 'Circle' ? 'Circumference' : 'Perimeter'} = ${fmtNum(r.perimeter)}',
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
