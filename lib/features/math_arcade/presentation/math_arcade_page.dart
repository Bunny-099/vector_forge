/// Presentation: Math Arcade — timed arithmetic quiz screen.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/math_arcade_notifier.dart';

class MathArcadePage extends ConsumerStatefulWidget {
  const MathArcadePage({super.key});

  @override
  ConsumerState<MathArcadePage> createState() => _MathArcadePageState();
}

class _MathArcadePageState extends ConsumerState<MathArcadePage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) ref.read(mathArcadeProvider.notifier).tick();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(mathArcadeProvider);
    final notifier = ref.read(mathArcadeProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Math Arcade')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(label: Text('Score: ${s.score}')),
                Chip(label: Text('Streak: ${s.streak}')),
                Chip(
                  label: Text('Time: ${s.timeLeft}s'),
                  backgroundColor: s.timeLeft <= 10 && s.playing
                      ? Colors.red.shade100
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (s.gameOver) ...[
              const Text('Time up!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                  'Final score: ${s.score}\n'
                  'Correct: ${s.correctCount} / ${s.answered}\n'
                  'Best streak: ${s.bestStreak}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, height: 1.6)),
              const SizedBox(height: 24),
              FilledButton(
                  onPressed: notifier.start,
                  child: const Text('Play again')),
            ] else if (!s.playing) ...[
              const Text('60 seconds. How many can you solve?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              FilledButton(
                  onPressed: notifier.start, child: const Text('Start game')),
            ] else ...[
              Text('${s.a} ${s.symbol} ${s.b} = ?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.4,
                  children: [
                    for (final opt in s.options)
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: s.lastPick == null
                              ? null
                              : opt == s.answer
                                  ? Colors.green
                                  : opt == s.lastPick
                                      ? Colors.red
                                      : Colors.grey.shade400,
                        ),
                        onPressed: () => notifier.pick(opt),
                        child: Text('$opt',
                            style: const TextStyle(fontSize: 22)),
                      ),
                  ],
                ),
              ),
              if (s.lastPick != null)
                FilledButton(
                    onPressed: notifier.next, child: const Text('Next')),
            ],
          ],
        ),
      ),
    );
  }
}
