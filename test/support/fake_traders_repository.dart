import 'package:fe_assessment_earnex/data/traders_repository.dart';
import 'package:fe_assessment_earnex/features/portfolio/domain/trader.dart';

class FakeTradersRepository implements TradersRepository {
  @override
  Future<List<Trader>> fetchTraders() async {
    return [
      Trader(
        id: '1',
        name: 'Top Performer Trader',
        avatarUrl: 'https://example.com/avatar1.jpg',
        copierCount: 0,
        copierLimit: 100,
        isAPI: true,
        tags: ['Top Performer'],
        pnl30d: 1000.0,
        roi30d: 5.0,
        aum: 10000.0,
        mdd30d: 1.0,
        sharpeRatio: 1.5,
      ),
      Trader(
        id: '2',
        name: 'Money Maker Trader',
        avatarUrl: 'https://example.com/avatar2.jpg',
        copierCount: 0,
        copierLimit: 100,
        isAPI: true,
        tags: ['Money Maker'],
        pnl30d: 2000.0,
        roi30d: 6.0,
        aum: 20000.0,
        mdd30d: 2.0,
        sharpeRatio: 1.6,
      ),
      Trader(
        id: '3',
        name: 'Both Tags Trader',
        avatarUrl: 'https://example.com/avatar3.jpg',
        copierCount: 0,
        copierLimit: 100,
        isAPI: true,
        tags: ['Top Performer', 'Money Maker'],
        pnl30d: 3000.0,
        roi30d: 7.0,
        aum: 30000.0,
        mdd30d: 3.0,
        sharpeRatio: 1.7,
      ),
    ];
  }
}
