/// Shared number formatting for the UI layer.
library;

/// Fixed 2-decimal display used across result values; NaN shows a dash.
String fmtNum(double v) => v.isNaN ? '—' : v.toStringAsFixed(2);
