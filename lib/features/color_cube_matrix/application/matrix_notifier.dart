/// Application layer (Riverpod): Notifier for matrix operations.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/matrix_state.dart';

class MatrixNotifier extends Notifier<MatrixState> {
  @override
  MatrixState build() => const MatrixState();

  void setSize(int newN) {
    state = MatrixState(n: newN);
  }

  void compute(String op, List<double> aVals, List<double> bVals) {
    final n = state.n;
    List<List<double>> readMatrix(List<double> vals) {
      return [
        for (var i = 0; i < n; i++)
          [for (var j = 0; j < n; j++) vals[i * 3 + j]]
      ];
    }

    final a = readMatrix(aVals);
    final b = readMatrix(bVals);

    switch (op) {
      case 'add':
        final res = [
          for (var i = 0; i < n; i++)
            [for (var j = 0; j < n; j++) a[i][j] + b[i][j]]
        ];
        state = MatrixState(
          n: n,
          resultLabel: 'A + B',
          result: res,
          detValue: null,
        );
        break;

      case 'sub':
        final res = [
          for (var i = 0; i < n; i++)
            [for (var j = 0; j < n; j++) a[i][j] - b[i][j]]
        ];
        state = MatrixState(
          n: n,
          resultLabel: 'A − B',
          result: res,
          detValue: null,
        );
        break;

      case 'mul':
        final res = [
          for (var i = 0; i < n; i++)
            [
              for (var j = 0; j < n; j++)
                [for (var k = 0; k < n; k++) a[i][k] * b[k][j]]
                    .fold<double>(0, (s, v) => s + v)
            ]
        ];
        state = MatrixState(
          n: n,
          resultLabel: 'A × B',
          result: res,
          detValue: null,
        );
        break;

      case 'transpose':
        final res = [
          for (var i = 0; i < n; i++)
            [for (var j = 0; j < n; j++) a[j][i]]
        ];
        state = MatrixState(
          n: n,
          resultLabel: 'Transpose of A',
          result: res,
          detValue: null,
        );
        break;

      case 'det':
        double det;
        if (n == 2) {
          det = a[0][0] * a[1][1] - a[0][1] * a[1][0];
        } else {
          det = a[0][0] * (a[1][1] * a[2][2] - a[1][2] * a[2][1]) -
              a[0][1] * (a[1][0] * a[2][2] - a[1][2] * a[2][0]) +
              a[0][2] * (a[1][0] * a[2][1] - a[1][1] * a[2][0]);
        }
        state = MatrixState(
          n: n,
          resultLabel: 'det(A)',
          result: null,
          detValue: det,
        );
        break;
    }
  }
}

final matrixProvider =
    NotifierProvider<MatrixNotifier, MatrixState>(MatrixNotifier.new);
