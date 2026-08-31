import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/models/filter_state.dart';
import 'package:fe_assessment_earnex/providers/applied_filter_provider.dart';

class DraftFilterNotifier extends AutoDisposeNotifier<FilterState> {
  @override
  FilterState build() {
    // One-time read of the applied filter as initial value
    return ref.read(appliedFilterProvider);
  }

  void toggleTag(String tag) {
    final currentTags = Set<String>.from(state.tags);
    if (currentTags.contains(tag)) {
      currentTags.remove(tag);
    } else {
      currentTags.add(tag);
    }
    state = state.copyWith(tags: currentTags);
  }

  void reset() {
    state = const FilterState();
  }
}

final draftFilterProvider =
    NotifierProvider.autoDispose<DraftFilterNotifier, FilterState>(
  DraftFilterNotifier.new,
);
