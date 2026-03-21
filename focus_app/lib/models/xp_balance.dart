class XPBalance {
  final int dailyXp;
  final int lifetimeXp;
  final int carryoverXp;
  final DateTime lastResetDate;
  final int totalSpentXp;

  const XPBalance({
    this.dailyXp = 0,
    this.lifetimeXp = 0,
    this.carryoverXp = 0,
    required this.lastResetDate,
    this.totalSpentXp = 0,
  });

  XPBalance copyWith({
    int? dailyXp,
    int? lifetimeXp,
    int? carryoverXp,
    DateTime? lastResetDate,
    int? totalSpentXp,
  }) {
    return XPBalance(
      dailyXp: dailyXp ?? this.dailyXp,
      lifetimeXp: lifetimeXp ?? this.lifetimeXp,
      carryoverXp: carryoverXp ?? this.carryoverXp,
      lastResetDate: lastResetDate ?? this.lastResetDate,
      totalSpentXp: totalSpentXp ?? this.totalSpentXp,
    );
  }

  Map<String, dynamic> toJson() => {
        'dailyXp': dailyXp,
        'lifetimeXp': lifetimeXp,
        'carryoverXp': carryoverXp,
        'lastResetDate': lastResetDate.toIso8601String(),
        'totalSpentXp': totalSpentXp,
      };

  factory XPBalance.fromJson(Map<String, dynamic> json) => XPBalance(
        dailyXp: json['dailyXp'] as int,
        lifetimeXp: json['lifetimeXp'] as int,
        carryoverXp: json['carryoverXp'] as int,
        lastResetDate: DateTime.parse(json['lastResetDate'] as String),
        totalSpentXp: json['totalSpentXp'] as int,
      );

  factory XPBalance.initial() => XPBalance(
        lastResetDate: DateTime.now(),
      );
}
