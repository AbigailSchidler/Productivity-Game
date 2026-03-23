class StreakRecord {
  final int currentStreak;
  final int longestStreak;

  /// The calendar date (time component ignored) of the last session that
  /// counted toward the streak. Null if no session has ever been completed.
  final DateTime? lastSessionDate;

  const StreakRecord({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastSessionDate,
  });

  StreakRecord copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastSessionDate,
  }) {
    return StreakRecord(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
    );
  }

  Map<String, dynamic> toJson() => {
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastSessionDate': lastSessionDate?.toIso8601String(),
      };

  factory StreakRecord.fromJson(Map<String, dynamic> json) => StreakRecord(
        currentStreak: json['currentStreak'] as int,
        longestStreak: json['longestStreak'] as int,
        lastSessionDate: json['lastSessionDate'] != null
            ? DateTime.parse(json['lastSessionDate'] as String)
            : null,
      );

  factory StreakRecord.initial() => const StreakRecord();
}
