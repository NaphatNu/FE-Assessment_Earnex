import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fe_assessment_earnex/src/domain/trader.dart';

abstract class TradersRepository {
  Future<List<Trader>> fetchTraders();
}

class AssetTradersRepository implements TradersRepository {
  @override
  Future<List<Trader>> fetchTraders() async {
    final jsonString =
        await rootBundle.loadString('assets/data/mock_data.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List;
    return jsonList
        .map((json) => Trader.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
