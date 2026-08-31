import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/models/filter_state.dart';

class AppliedFilterNotifier extends Notifier<FilterState> {
  @override
  FilterState build() {
    return const FilterState();
  }

  void applyFrom(FilterState draft) {
    state = draft;
  }
}

final appliedFilterProvider =
    NotifierProvider<AppliedFilterNotifier, FilterState>(
  AppliedFilterNotifier.new,
);
