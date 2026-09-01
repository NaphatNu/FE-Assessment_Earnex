class Trader {
  final String id;
  final String name;
  final String avatarUrl;
  final int copiers;
  final int copiersMax;
  final bool isApi;
  final List<String> tags;
  final double pnl30d;
  final double roi;
  final double aum;
  final double mdd30d;
  final double sharpe;

  const Trader({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.copiers,
    required this.copiersMax,
    required this.isApi,
    required this.tags,
    required this.pnl30d,
    required this.roi,
    required this.aum,
    required this.mdd30d,
    required this.sharpe,
  });

  factory Trader.fromJson(Map<String, dynamic> json) {
    return Trader(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      copiers: json['copiers'] as int,
      copiersMax: json['copiersMax'] as int,
      isApi: json['isApi'] as bool,
      tags: List<String>.from(json['tags'] as List),
      pnl30d: json['pnl30d'] as double,
      roi: json['roi'] as double,
      aum: json['aum'] as double,
      mdd30d: json['mdd30d'] as double,
      sharpe: json['sharpe'] as double,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Trader && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
