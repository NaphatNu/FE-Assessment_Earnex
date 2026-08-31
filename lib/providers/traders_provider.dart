import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/models/trader.dart';

final tradersProvider = FutureProvider<List<Trader>>((ref) async {
  final jsonString = await rootBundle.loadString('assets/data/mock_data.json');
  final List<dynamic> jsonList = json.decode(jsonString) as List;
  return jsonList
      .map((json) => Trader.fromJson(json as Map<String, dynamic>))
      .toList();
});
