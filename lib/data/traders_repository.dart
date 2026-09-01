import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fe_assessment_earnex/features/portfolio/domain/trader.dart';

abstract interface class TradersRepository {
  Future<List<Trader>> fetchTraders();
}

class AssetTradersRepository implements TradersRepository {
  AssetTradersRepository({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  @override
  Future<List<Trader>> fetchTraders() async {
    final jsonString = await _bundle.loadString('assets/mock/traders.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List;
    return jsonList
        .map((json) => Trader.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
