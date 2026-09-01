import 'package:fe_assessment_earnex/features/portfolio/domain/trader.dart';

class FilterState {
  const FilterState({
    this.tags = const {},
    this.pnlMin = 0,
    this.pnlMax = 500000,
    this.roiThreshold,
    this.apiOnly = false,
  });

  final Set<String> tags;
  final double pnlMin;
  final double pnlMax;
  final double? roiThreshold;
  final bool apiOnly;

  bool get isEmpty =>
      tags.isEmpty &&
      pnlMin == 0 &&
      pnlMax == 500000 &&
      roiThreshold == null &&
      !apiOnly;
  bool matches(Trader t) =>
      tags.isEmpty || t.tags.any(tags.contains); // OR within group

  FilterState copyWith({
    Set<String>? tags,
    double? pnlMin,
    double? pnlMax,
    bool? apiOnly,
  }) =>
      FilterState(
        tags: tags ?? this.tags,
        pnlMin: pnlMin ?? this.pnlMin,
        pnlMax: pnlMax ?? this.pnlMax,
        roiThreshold: roiThreshold,
        apiOnly: apiOnly ?? this.apiOnly,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterState &&
        _setsEqual(tags, other.tags) &&
        pnlMin == other.pnlMin &&
        pnlMax == other.pnlMax &&
        roiThreshold == other.roiThreshold &&
        apiOnly == other.apiOnly;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(tags.toList()..sort()),
        pnlMin,
        pnlMax,
        roiThreshold,
        apiOnly,
      );

  // Helper method to compare sets for equality
  bool _setsEqual(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    return a.every(b.contains);
  }
}
