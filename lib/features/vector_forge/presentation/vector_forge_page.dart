/// Presentation layer: the Vector Forge screen.
/// Owns only local UI resources (text controllers);
/// all app state is watched from the Riverpod Notifier.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/derived_providers.dart';
import '../application/vector_forge_notifier.dart';
import 'painters/plane_2d_painter.dart';
import 'painters/plane_3d_painter.dart';
import 'widgets/control_panel.dart';

// ---- Page ----

class VectorForgePage extends ConsumerStatefulWidget {
  const VectorForgePage({super.key});

  @override
  ConsumerState<VectorForgePage> createState() => _VectorForgePageState();
}

class _VectorForgePageState extends ConsumerState<VectorForgePage> {
  static const double range = VectorForgeNotifier.range;
  static const double snap = 0.5;

  late final TextEditingController axCtrl;
  late final TextEditingController ayCtrl;
  late final TextEditingController azCtrl;
  late final TextEditingController bxCtrl;
  late final TextEditingController byCtrl;
  late final TextEditingController bzCtrl;

  @override
  void initState() {
    super.initState();
    final s = ref.read(vectorForgeProvider);
    axCtrl = TextEditingController(text: _trim(s.a.x));
    ayCtrl = TextEditingController(text: _trim(s.a.y));
    azCtrl = TextEditingController(text: _trim(s.a.z));
    bxCtrl = TextEditingController(text: _trim(s.b.x));
    byCtrl = TextEditingController(text: _trim(s.b.y));
    bzCtrl = TextEditingController(text: _trim(s.b.z));
  }

  @override
  void dispose() {
    axCtrl.dispose();
    ayCtrl.dispose();
    azCtrl.dispose();
    bxCtrl.dispose();
    byCtrl.dispose();
    bzCtrl.dispose();
    super.dispose();
  }

  /// After drag / reset the fields must show the state values again.
  /// (While typing we never rewrite the controllers, so the cursor is safe.)
  void _syncControllers() {
    final s = ref.read(vectorForgeProvider);
    axCtrl.text = _trim(s.a.x);
    ayCtrl.text = _trim(s.a.y);
    azCtrl.text = _trim(s.a.z);
    bxCtrl.text = _trim(s.b.x);
    byCtrl.text = _trim(s.b.y);
    bzCtrl.text = _trim(s.b.z);
  }

  static String _trim(double v) {
    var s = v.toStringAsFixed(2);
    if (s.contains('.')) {
      s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return s.isEmpty ? '0' : s;
  }

  Offset _toMath(Offset local, Size size) {
    final scale = math.min(size.width, size.height) / (range * 2 + 2);
    final x = (local.dx - size.width / 2) / scale;
    final y = (size.height / 2 - local.dy) / scale;
    return Offset((x / snap).round() * snap, (y / snap).round() * snap);
  }

  void _moveDragged(Offset p) {
    final s = ref.read(vectorForgeProvider);
    final notifier = ref.read(vectorForgeProvider.notifier);
    if (s.dragging == 1) notifier.dragA(p.dx, p.dy);
    if (s.dragging == 2) notifier.dragB(p.dx, p.dy);
    _syncControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vector Forge')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 700;
          final plane = _buildPlane();
          final panel = ControlPanel(
            aControllers: [axCtrl, ayCtrl, azCtrl],
            bControllers: [bxCtrl, byCtrl, bzCtrl],
            onReset: _syncControllers,
          );
          if (wide) {
            return Row(
              children: [
                Expanded(flex: 3, child: plane),
                Expanded(flex: 2, child: SingleChildScrollView(child: panel)),
              ],
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: constraints.maxWidth, child: plane),
                panel,
              ],
            )
          );
        },
      ),
    );
  }

  Widget _buildPlane() {
    final s = ref.watch(vectorForgeProvider);
    final r = ref.watch(resultProvider);
    final notifier = ref.read(vectorForgeProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          onPanStart: (d) {
            if (s.mode3D) return;
            final box = context.findRenderObject() as RenderBox;
            final p = _toMath(box.globalToLocal(d.globalPosition), size);
            final da = math.sqrt(math.pow(p.dx - s.a.x, 2) + math.pow(p.dy - s.a.y, 2));
            final db = math.sqrt(math.pow(p.dx - s.b.x, 2) + math.pow(p.dy - s.b.y, 2));
            notifier.setDragging(da <= db ? 1 : 2);
            _moveDragged(p);
          },
          onPanUpdate: (d) {
            if (s.mode3D) {
              notifier.rotate(d.delta.dx * 0.01, d.delta.dy * 0.01);
              return;
            }
            if (s.dragging == 0) return;
            final box = context.findRenderObject() as RenderBox;
            _moveDragged(_toMath(box.globalToLocal(d.globalPosition), size));
          },
          onPanEnd: (_) => notifier.setDragging(0),
          child: s.mode3D
              ? CustomPaint(
                  size: size,
                  painter: Plane3DPainter(
                    a: s.a,
                    b: s.b,
                    result: r,
                    yaw: s.yaw,
                    pitch: s.pitch,
                    showComponents: s.showComponents,
                  ),
                )
              : CustomPaint(
                  size: size,
                  painter: Plane2DPainter(
                    a: s.a,
                    b: s.b,
                    result: r,
                    op: s.op,
                    range: range,
                    showComponents: s.showComponents,
                    showArc: s.showArc,
                  ),
                ),
        );
      },
    );
  }
}
