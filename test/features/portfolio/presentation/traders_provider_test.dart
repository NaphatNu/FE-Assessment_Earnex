import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/portfolio_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('tradersProvider', () {
    test('loads and parses the mock data correctly', () async {
      // This test will load the real asset file
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Wait for the provider to load
      await container.read(tradersProvider.future);

      final tradersAsync = container.read(tradersProvider);

      // Verify we have the correct number of traders
      expect(tradersAsync.value, hasLength(18));

      // Verify the first trader has the correct data
      final firstTrader = tradersAsync.value?.first;
      expect(firstTrader?.id, 't001');
      expect(firstTrader?.name, 'CRYPTO 加密');
      expect(firstTrader?.avatarUrl, 'https://i.pravatar.cc/150?img=1');
      expect(firstTrader?.copiers, 0);
      expect(firstTrader?.copiersMax, 300);
      expect(firstTrader?.isApi, isTrue);
      expect(firstTrader?.tags, containsAll(['Top Performer', 'Money Maker']));
      expect(firstTrader?.pnl30d, 56592.5);
      expect(firstTrader?.roi, 17.07);
      expect(firstTrader?.aum, 388038.47);
      expect(firstTrader?.mdd30d, 2.54);
      expect(firstTrader?.sharpe, 2.15);
    });
  });
}
