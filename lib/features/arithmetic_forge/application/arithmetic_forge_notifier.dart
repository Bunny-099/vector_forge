/// Application layer (Riverpod): Arithmetic Forge practice state.
/// Generates problems by operation and difficulty, checks typed
/// answers and tracks how many were forged (answered correctly).
library;

import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ForgeStatus { none, correct, wrong }

class ForgeState {
  final String op; // add | sub | mul | div | mixed
  final int level; // 1..3
  final int a;
  final int b;
  final String symbol;
  final int answer;
  final ForgeStatus status;
  final int correct;
  final int attempted;

  const ForgeState({
    required this.op,
    required this.level,
    required this.a,
    required this.b,
    required this.symbol,
    required this.answer,
    required this.status,
    required this.correct,
    required this.attempted,
  });
}

class ArithmeticForgeNotifier extends Notifier<ForgeState> {
  final math.Random _rng = math.Random();

  @override
  ForgeState build() => _gen(const ForgeState(
        op: 'mixed',
        level: 1,
        a: 0,
        b: 0,
        symbol: '+',
        answer: 0,
        status: ForgeStatus.none,
        correct: 0,
        attempted: 0,
      ));

  ForgeState _gen(ForgeState base) {
    const ops = ['add', 'sub', 'mul', 'div'];
    final op = base.op == 'mixed' ? ops[_rng.nextInt(4)] : base.op;
    int a, b, ans;
    String sym;
    final lvl = base.level;
    switch (op) {
      case 'add':
        final max = 20 * lvl + 10;
        a = 2 + _rng.nextInt(max);
        b = 2 + _rng.nextInt(max);
        ans = a + b;
        sym = '+';
        break;
      case 'sub':
        final max = 20 * lvl + 10;
        a = 10 + _rng.nextInt(max);
        b = _rng.nextInt(a + 1);
        ans = a - b;
        sym = '−';
        break;
      case 'mul':
        a = 2 + _rng.nextInt(4 + 3 * lvl);
        b = 2 + _rng.nextInt(8);
        ans = a * b;
        sym = '×';
        break;
      default:
        b = 2 + _rng.nextInt(8);
        ans = 2 + _rng.nextInt(4 + 3 * lvl);
        a = b * ans;
        sym = '÷';
        break;
    }
    return ForgeState(
      op: base.op,
      level: base.level,
      a: a,
      b: b,
      symbol: sym,
      answer: ans,
      status: ForgeStatus.none,
      correct: base.correct,
      attempted: base.attempted,
    );
  }

  ForgeState _withSettings(String op, int level) => ForgeState(
        op: op,
        level: level,
        a: state.a,
        b: state.b,
        symbol: state.symbol,
        answer: state.answer,
        status: ForgeStatus.none,
        correct: state.correct,
        attempted: state.attempted,
      );

  void setOp(String op) => state = _gen(_withSettings(op, state.level));

  void setLevel(int level) => state = _gen(_withSettings(state.op, level));

  void check(int? v) {
    if (v == null || state.status == ForgeStatus.correct) return;
    final ok = v == state.answer;
    state = ForgeState(
      op: state.op,
      level: state.level,
      a: state.a,
      b: state.b,
      symbol: state.symbol,
      answer: state.answer,
      status: ok ? ForgeStatus.correct : ForgeStatus.wrong,
      correct: state.correct + (ok ? 1 : 0),
      attempted: state.attempted + 1,
    );
  }

  void next() => state = _gen(state);
}

final arithmeticForgeProvider =
    NotifierProvider<ArithmeticForgeNotifier, ForgeState>(
        ArithmeticForgeNotifier.new);
