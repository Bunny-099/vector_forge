/// Application layer (Riverpod): Math Arcade game state.
/// A 60-second timed quiz — score, streaks and question generation
/// all live here; the page only renders and forwards taps/ticks.
library;

import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArcadeState {
  final bool playing;
  final bool gameOver;
  final int score;
  final int streak;
  final int bestStreak;
  final int answered;
  final int correctCount;
  final int timeLeft;
  final int a;
  final int b;
  final String symbol;
  final int answer;
  final List<int> options;
  final int? lastPick;
  final bool? lastCorrect;

  const ArcadeState({
    required this.playing,
    required this.gameOver,
    required this.score,
    required this.streak,
    required this.bestStreak,
    required this.answered,
    required this.correctCount,
    required this.timeLeft,
    required this.a,
    required this.b,
    required this.symbol,
    required this.answer,
    required this.options,
    required this.lastPick,
    required this.lastCorrect,
  });

  factory ArcadeState.idle() => const ArcadeState(
        playing: false,
        gameOver: false,
        score: 0,
        streak: 0,
        bestStreak: 0,
        answered: 0,
        correctCount: 0,
        timeLeft: 60,
        a: 0,
        b: 0,
        symbol: '+',
        answer: 0,
        options: <int>[],
        lastPick: null,
        lastCorrect: null,
      );

  ArcadeState copyWith({
    bool? playing,
    bool? gameOver,
    int? score,
    int? streak,
    int? bestStreak,
    int? answered,
    int? correctCount,
    int? timeLeft,
    int? lastPick,
    bool? lastCorrect,
  }) {
    return ArcadeState(
      playing: playing ?? this.playing,
      gameOver: gameOver ?? this.gameOver,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      bestStreak: bestStreak ?? this.bestStreak,
      answered: answered ?? this.answered,
      correctCount: correctCount ?? this.correctCount,
      timeLeft: timeLeft ?? this.timeLeft,
      a: a,
      b: b,
      symbol: symbol,
      answer: answer,
      options: options,
      lastPick: lastPick ?? this.lastPick,
      lastCorrect: lastCorrect ?? this.lastCorrect,
    );
  }
}

class MathArcadeNotifier extends Notifier<ArcadeState> {
  final math.Random _rng = math.Random();

  @override
  ArcadeState build() => ArcadeState.idle();

  void start() {
    state = _withQuestion(const ArcadeState(
      playing: true,
      gameOver: false,
      score: 0,
      streak: 0,
      bestStreak: 0,
      answered: 0,
      correctCount: 0,
      timeLeft: 60,
      a: 0,
      b: 0,
      symbol: '+',
      answer: 0,
      options: <int>[],
      lastPick: null,
      lastCorrect: null,
    ));
  }

  ArcadeState _withQuestion(ArcadeState base) {
    final op = _rng.nextInt(4);
    int a, b, ans;
    String sym;
    switch (op) {
      case 0:
        a = 2 + _rng.nextInt(48);
        b = 2 + _rng.nextInt(48);
        ans = a + b;
        sym = '+';
        break;
      case 1:
        a = 10 + _rng.nextInt(50);
        b = _rng.nextInt(a + 1);
        ans = a - b;
        sym = '−';
        break;
      case 2:
        a = 2 + _rng.nextInt(11);
        b = 2 + _rng.nextInt(8);
        ans = a * b;
        sym = '×';
        break;
      default:
        b = 2 + _rng.nextInt(8);
        ans = 2 + _rng.nextInt(11);
        a = b * ans;
        sym = '÷';
        break;
    }
    final opts = <int>{ans};
    while (opts.length < 4) {
      final d = ans + _rng.nextInt(21) - 10;
      if (d >= 0) opts.add(d);
    }
    final list = opts.toList()..shuffle(_rng);
    return ArcadeState(
      playing: base.playing,
      gameOver: base.gameOver,
      score: base.score,
      streak: base.streak,
      bestStreak: base.bestStreak,
      answered: base.answered,
      correctCount: base.correctCount,
      timeLeft: base.timeLeft,
      a: a,
      b: b,
      symbol: sym,
      answer: ans,
      options: list,
      lastPick: null,
      lastCorrect: null,
    );
  }

  void pick(int v) {
    if (!state.playing || state.lastPick != null) return;
    final ok = v == state.answer;
    final streak = ok ? state.streak + 1 : 0;
    state = state.copyWith(
      score: state.score + (ok ? 10 + (streak > 1 ? 2 * (streak - 1) : 0) : 0),
      streak: streak,
      bestStreak: math.max(state.bestStreak, streak),
      answered: state.answered + 1,
      correctCount: state.correctCount + (ok ? 1 : 0),
      lastPick: v,
      lastCorrect: ok,
    );
  }

  void next() {
    if (!state.playing) return;
    state = _withQuestion(state);
  }

  void tick() {
    if (!state.playing || state.gameOver) return;
    final t = state.timeLeft - 1;
    if (t <= 0) {
      state = state.copyWith(timeLeft: 0, playing: false, gameOver: true);
    } else {
      state = state.copyWith(timeLeft: t);
    }
  }
}

final mathArcadeProvider =
    NotifierProvider<MathArcadeNotifier, ArcadeState>(MathArcadeNotifier.new);
