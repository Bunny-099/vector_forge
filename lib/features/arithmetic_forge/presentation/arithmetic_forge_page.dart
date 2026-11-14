/// Presentation: Arithmetic Forge — focused arithmetic practice.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/arithmetic_forge_notifier.dart';

class ArithmeticForgePage extends ConsumerStatefulWidget {
  const ArithmeticForgePage({super.key});

  @override
  ConsumerState<ArithmeticForgePage> createState() =>
      _ArithmeticForgePageState();
}

class _ArithmeticForgePageState extends ConsumerState<ArithmeticForgePage> {
  final TextEditingController _answerCtrl = TextEditingController();

  @override
  void dispose() {
    _answerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(arithmeticForgeProvider);
    final notifier = ref.read(arithmeticForgeProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Arithmetic Forge')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              children: [
                for (final entry in const {
                  'mixed': 'Mixed',
                  'add': '+',
                  'sub': '−',
                  'mul': '×',
                  'div': '÷',
                }.entries)
                  ChoiceChip(
                    label: Text(entry.value),
                    selected: s.op == entry.key,
                    onSelected: (_) => notifier.setOp(entry.key),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final lvl in [1, 2, 3])
                  ChoiceChip(
                    label: Text('Level $lvl'),
                    selected: s.level == lvl,
                    onSelected: (_) => notifier.setLevel(lvl),
                  ),
              ],
            ),
            const SizedBox(height: 32),
            Text('${s.a} ${s.symbol} ${s.b} = ?',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: _answerCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(signed: true),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
              decoration: const InputDecoration(
                  labelText: 'Your answer',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            if (s.status == ForgeStatus.correct)
              const Text('Correct! Forged.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold))
            else if (s.status == ForgeStatus.wrong)
              const Text('Not quite — try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () =>
                        notifier.check(int.tryParse(_answerCtrl.text.trim())),
                    child: const Text('Check'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _answerCtrl.clear();
                      notifier.next();
                    },
                    child: const Text('Next problem'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Forged (correct): ${s.correct}   Attempted: ${s.attempted}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
