class Trader {
  final String id;
  final String name;
  final String avatarUrl;
  final int copierCount;
  final int copierLimit;
  final bool isAPI;
  final List<String> tags;
  final double pnl30d;
  final double roi30d;
  final double aum;
  final double mdd30d;
  final double sharpeRatio;

  const Trader({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.copierCount,
    required this.copierLimit,
    required this.isAPI,
    required this.tags,
    required this.pnl30d,
    required this.roi30d,
    required this.aum,
    required this.mdd30d,
    required this.sharpeRatio,
  });

  factory Trader.fromJson(Map<String, dynamic> json) {
    return Trader(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      copierCount: json['copierCount'] as int,
      copierLimit: json['copierLimit'] as int,
      isAPI: json['isAPI'] as bool,
      tags: List<String>.from(json['tags'] as List),
      pnl30d: json['pnl30d'] as double,
      roi30d: json['roi30d'] as double,
      aum: json['aum'] as double,
      mdd30d: json['mdd30d'] as double,
      sharpeRatio: json['sharpeRatio'] as double,
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
