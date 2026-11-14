/// Presentation: home screen listing all six BrainyCube modules.
library;

import 'package:flutter/material.dart';

import '../../arithmetic_forge/presentation/arithmetic_forge_page.dart';
import '../../color_cube_matrix/presentation/color_cube_matrix_page.dart';
import '../../coordinate_geometry/presentation/coordinate_geometry_page.dart';
import '../../geometry_sandbox/presentation/geometry_sandbox_page.dart';
import '../../math_arcade/presentation/math_arcade_page.dart';
import '../../vector_forge/presentation/vector_forge_page.dart';

class _Module {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget page;

  const _Module(this.title, this.subtitle, this.icon, this.color, this.page);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<_Module> _modules = [
    _Module('Math Arcade', 'Timed quiz game', Icons.sports_esports,
        Colors.orange, MathArcadePage()),
    _Module('Arithmetic Forge', 'Practice + − × ÷', Icons.calculate,
        Colors.teal, ArithmeticForgePage()),
    _Module('Coordinate Geometry', 'Points, lines, slope', Icons.grid_on,
        Colors.indigo, CoordinateGeometryPage()),
    _Module('Geometry Sandbox', 'Shapes, area, perimeter', Icons.category,
        Colors.pink, GeometrySandboxPage()),
    _Module('Vector Forge', 'Vectors in 2D and 3D', Icons.arrow_outward,
        Colors.deepPurple, VectorForgePage()),
    _Module('Color Cube Matrix', 'Matrix operations', Icons.grid_view,
        Colors.blue, ColorCubeMatrixPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BrainyCube: Math & Calculus')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.95,
        ),
        itemCount: _modules.length,
        itemBuilder: (context, i) {
          final m = _modules[i];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => m.page),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(m.icon, size: 44, color: m.color),
                    const SizedBox(height: 10),
                    Text(m.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(m.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
