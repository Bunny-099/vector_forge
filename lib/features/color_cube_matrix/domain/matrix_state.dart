/// Domain layer: state model for Color Cube Matrix operations.
library;

class MatrixState {
  final int n;
  final String resultLabel;
  final List<List<double>>? result;
  final double? detValue;

  const MatrixState({
    this.n = 2,
    this.resultLabel = '',
    this.result,
    this.detValue,
  });

  MatrixState copyWith({
    int? n,
    String? resultLabel,
    List<List<double>>? result,
    bool clearResult = false,
    double? detValue,
    bool clearDetValue = false,
  }) {
    return MatrixState(
      n: n ?? this.n,
      resultLabel: resultLabel ?? this.resultLabel,
      result: clearResult ? null : (result ?? this.result),
      detValue: clearDetValue ? null : (detValue ?? this.detValue),
    );
  }
}
