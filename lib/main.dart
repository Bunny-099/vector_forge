/// Vector Forge — entry point.
/// The whole app state lives in Riverpod, so the root is wrapped
/// in a ProviderScope.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() => runApp(const ProviderScope(child: VectorForgeApp()));
