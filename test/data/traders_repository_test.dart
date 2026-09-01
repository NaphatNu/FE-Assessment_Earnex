import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fe_assessment_earnex/data/traders_repository.dart';

class _FakeAssetBundle extends AssetBundle {
  _FakeAssetBundle(this.contents);
  final String contents;

  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(Uint8List.fromList(utf8.encode(contents)));
}

void main() {
  group('AssetTradersRepository', () {
    test('fetches traders correctly with injected bundle', () async {
      const jsonString = '''[
        {
          "id": "test001",
          "name": "Test Trader",
          "avatarUrl": "https://example.com/avatar.jpg",
          "copiers": 100,
          "copiersMax": 200,
          "isApi": true,
          "tags": ["Top Performer", "Money Maker"],
          "pnl30d": 50000.0,
          "roi": 15.0,
          "aum": 200000.0,
          "mdd30d": 2.0,
          "sharpe": 2.0
        }
      ]''';

      final repository =
          AssetTradersRepository(bundle: _FakeAssetBundle(jsonString));
      final traders = await repository.fetchTraders();

      expect(traders, hasLength(1));
      final trader = traders.first;
      expect(trader.id, 'test001');
      expect(trader.name, 'Test Trader');
      expect(trader.avatarUrl, 'https://example.com/avatar.jpg');
      expect(trader.copiers, 100);
      expect(trader.copiersMax, 200);
      expect(trader.isApi, isTrue);
      expect(trader.tags, ['Top Performer', 'Money Maker']);
      expect(trader.pnl30d, 50000.0);
      expect(trader.roi, 15.0);
      expect(trader.aum, 200000.0);
      expect(trader.mdd30d, 2.0);
      expect(trader.sharpe, 2.0);
    });

    test('throws error when JSON is malformed', () async {
      const malformedJson = 'not json';

      final repository =
          AssetTradersRepository(bundle: _FakeAssetBundle(malformedJson));

      await expectLater(
        repository.fetchTraders(),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
