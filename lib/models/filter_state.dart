import 'package:fe_assessment_earnex/models/trader.dart';

class FilterState {
  const FilterState({this.tags = const {}});

  final Set<String> tags;

  bool get isEmpty => tags.isEmpty;

  bool matches(Trader t) => tags.isEmpty || t.tags.any(tags.contains);

  FilterState copyWith({Set<String>? tags}) =>
      FilterState(tags: tags ?? this.tags);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterState && _setsEqual(tags, other.tags);
  }

  @override
  int get hashCode => Object.hashAll(tags.toList()..sort());

  // Helper method to compare sets for equality
  bool _setsEqual(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    return a.every(b.contains);
  }
}
