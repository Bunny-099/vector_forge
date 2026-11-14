/// Presentation widget: one vector's X / Y / Z typed input fields.
library;

import 'package:flutter/material.dart';

class VectorInputRow extends StatelessWidget {
  final String name;
  final Color color;
  final List<TextEditingController> controllers;
  final void Function(int index, double value) onComponent;

  const VectorInputRow({
    super.key,
    required this.name,
    required this.color,
    required this.controllers,
    required this.onComponent,
  });

  Widget _field(String label, TextEditingController ctrl, int index) {
    return Expanded(
      child: TextField(
        controller: ctrl,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        decoration:
            InputDecoration(labelText: label, border: const OutlineInputBorder()),
        onChanged: (text) {
          final v = double.tryParse(text);
          if (v != null) onComponent(index, v);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vector $name',
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 6),
        Row(
          children: [
            _field('$name.x', controllers[0], 0),
            const SizedBox(width: 8),
            _field('$name.y', controllers[1], 1),
            const SizedBox(width: 8),
            _field('$name.z', controllers[2], 2),
          ],
        ),
      ],
    );
  }
}
