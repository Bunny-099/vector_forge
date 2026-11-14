# BrainyCube: Math & Calculus (Flutter + Riverpod)

Recreation of the BrainyCube app: a home screen with all six modules.
Vector Forge (the assessed section) is fully built out; the other five
modules are working bonus implementations.

## Modules

- Math Arcade - 60-second timed arithmetic quiz (score + streaks)
- Arithmetic Forge - operation/difficulty practice with typed answers
- Coordinate Geometry - two points on a plane: distance, midpoint,
  slope and line equation
- Geometry Sandbox - square/rectangle/circle/triangle area & perimeter
- Vector Forge - 2D/3D vectors: ADD / SUB / DOT / CROSS, magnitudes,
  angle between vectors, direction angles, components and angle arc
- Color Cube Matrix - 2x2/3x3 matrix add, subtract, multiply,
  transpose and determinant with colour-coded grids

## Structure

Feature-first layers under lib/features/<module>/ with
domain / application / presentation separation, plus lib/core for
shared maths. Feature state lives in Riverpod Notifiers (Vector Forge,
Math Arcade, Arithmetic Forge); simple tool screens keep only local
view state. lib/main.dart is just the entry point (ProviderScope).

See RUN_STEPS.txt for setup, run and APK build steps.
