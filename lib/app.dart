/// App root widget: theme + home page wiring.
library;

import 'package:flutter/material.dart';

import 'features/home/presentation/home_page.dart';

class VectorForgeApp extends StatelessWidget {
  const VectorForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainyCube: Math & Calculus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
