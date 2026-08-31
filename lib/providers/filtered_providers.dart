import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/models/trader.dart';
import 'package:fe_assessment_earnex/providers/traders_provider.dart';
import 'package:fe_assessment_earnex/providers/applied_filter_provider.dart';

final filteredTradersProvider = Provider<AsyncValue<List<Trader>>>((ref) {
  final traders = ref.watch(tradersProvider);
  final filter = ref.watch(appliedFilterProvider);

  return traders.whenData((all) => all.where(filter.matches).toList());
});

final filteredCountProvider = Provider<int?>((ref) {
  return ref.watch(filteredTradersProvider).valueOrNull?.length;
});
