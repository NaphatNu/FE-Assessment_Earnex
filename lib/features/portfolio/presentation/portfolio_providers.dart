import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/features/portfolio/domain/filter_state.dart';
import 'package:fe_assessment_earnex/features/portfolio/domain/trader.dart';
import 'package:fe_assessment_earnex/data/traders_repository.dart';

final tradersRepositoryProvider = Provider<TradersRepository>((ref) {
  return AssetTradersRepository();
});

final tradersProvider = FutureProvider<List<Trader>>((ref) {
  return ref.watch(tradersRepositoryProvider).fetchTraders();
});

class AppliedFilterNotifier extends Notifier<FilterState> {
  @override
  FilterState build() {
    return const FilterState();
  }

  void apply(FilterState next) {
    state = next;
  }

  void clear() {
    state = const FilterState();
  }
}

final appliedFilterProvider =
    NotifierProvider<AppliedFilterNotifier, FilterState>(
  AppliedFilterNotifier.new,
);

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

final filteredTradersProvider = Provider<AsyncValue<List<Trader>>>((ref) {
  final traders = ref.watch(tradersProvider);
  final filter = ref.watch(appliedFilterProvider);

  return traders.whenData((all) => all.where(filter.matches).toList());
});

final filteredCountProvider = Provider<int?>((ref) {
  return ref.watch(filteredTradersProvider).valueOrNull?.length;
});
