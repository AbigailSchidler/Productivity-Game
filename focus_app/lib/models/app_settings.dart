enum LockMode { light, balanced, strict }

class AppSettings {
  final int focusWindowStartHour;
  final int focusWindowStartMinute;
  final int focusWindowEndHour;
  final int focusWindowEndMinute;
  final List<int> restDays;
  final LockMode lockMode;
  final int reflectionBonusXp;
  final int xpToUnlockMinuteRatio;
  final double genericSessionMultiplier;
  final double carryoverPercentage;
  final int minimumNextDayXpFloor;
  final bool warningEnabled;
  final int warningLeadMinutes;

  const AppSettings({
    this.focusWindowStartHour = 10,
    this.focusWindowStartMinute = 0,
    this.focusWindowEndHour = 21,
    this.focusWindowEndMinute = 0,
    this.restDays = const [6, 7],
    this.lockMode = LockMode.balanced,
    this.reflectionBonusXp = 5,
    this.xpToUnlockMinuteRatio = 2,
    this.genericSessionMultiplier = 0.85,
    this.carryoverPercentage = 0.5,
    this.minimumNextDayXpFloor = 10,
    this.warningEnabled = true,
    this.warningLeadMinutes = 5,
  });

  AppSettings copyWith({
    int? focusWindowStartHour,
    int? focusWindowStartMinute,
    int? focusWindowEndHour,
    int? focusWindowEndMinute,
    List<int>? restDays,
    LockMode? lockMode,
    int? reflectionBonusXp,
    int? xpToUnlockMinuteRatio,
    double? genericSessionMultiplier,
    double? carryoverPercentage,
    int? minimumNextDayXpFloor,
    bool? warningEnabled,
    int? warningLeadMinutes,
  }) {
    return AppSettings(
      focusWindowStartHour: focusWindowStartHour ?? this.focusWindowStartHour,
      focusWindowStartMinute:
          focusWindowStartMinute ?? this.focusWindowStartMinute,
      focusWindowEndHour: focusWindowEndHour ?? this.focusWindowEndHour,
      focusWindowEndMinute: focusWindowEndMinute ?? this.focusWindowEndMinute,
      restDays: restDays ?? this.restDays,
      lockMode: lockMode ?? this.lockMode,
      reflectionBonusXp: reflectionBonusXp ?? this.reflectionBonusXp,
      xpToUnlockMinuteRatio:
          xpToUnlockMinuteRatio ?? this.xpToUnlockMinuteRatio,
      genericSessionMultiplier:
          genericSessionMultiplier ?? this.genericSessionMultiplier,
      carryoverPercentage: carryoverPercentage ?? this.carryoverPercentage,
      minimumNextDayXpFloor:
          minimumNextDayXpFloor ?? this.minimumNextDayXpFloor,
      warningEnabled: warningEnabled ?? this.warningEnabled,
      warningLeadMinutes: warningLeadMinutes ?? this.warningLeadMinutes,
    );
  }

  Map<String, dynamic> toJson() => {
        'focusWindowStartHour': focusWindowStartHour,
        'focusWindowStartMinute': focusWindowStartMinute,
        'focusWindowEndHour': focusWindowEndHour,
        'focusWindowEndMinute': focusWindowEndMinute,
        'restDays': restDays,
        'lockMode': lockMode.name,
        'reflectionBonusXp': reflectionBonusXp,
        'xpToUnlockMinuteRatio': xpToUnlockMinuteRatio,
        'genericSessionMultiplier': genericSessionMultiplier,
        'carryoverPercentage': carryoverPercentage,
        'minimumNextDayXpFloor': minimumNextDayXpFloor,
        'warningEnabled': warningEnabled,
        'warningLeadMinutes': warningLeadMinutes,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        focusWindowStartHour: json['focusWindowStartHour'] as int,
        focusWindowStartMinute: json['focusWindowStartMinute'] as int,
        focusWindowEndHour: json['focusWindowEndHour'] as int,
        focusWindowEndMinute: json['focusWindowEndMinute'] as int,
        restDays: List<int>.from(json['restDays'] as List),
        lockMode: LockMode.values.byName(json['lockMode'] as String),
        reflectionBonusXp: json['reflectionBonusXp'] as int,
        xpToUnlockMinuteRatio: json['xpToUnlockMinuteRatio'] as int,
        genericSessionMultiplier: json['genericSessionMultiplier'] as double,
        carryoverPercentage: json['carryoverPercentage'] as double,
        minimumNextDayXpFloor: json['minimumNextDayXpFloor'] as int,
        warningEnabled: json['warningEnabled'] as bool,
        warningLeadMinutes: json['warningLeadMinutes'] as int,
      );
}
