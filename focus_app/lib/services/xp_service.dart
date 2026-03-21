import '../models/session.dart';

/// Immutable breakdown of XP earned in one session.
///
/// Separating the components lets the UI show a reward breakdown and lets
/// future AI scoring inspect each piece independently.
class XpCalculation {
  /// Minutes × all multipliers, floored to a whole number.
  final int baseXp;

  /// Flat bonus for writing a reflection. 0 if no reflection was written.
  final int reflectionBonus;

  /// baseXp + reflectionBonus. Written to Session.xpEarned.
  final int totalXp;

  const XpCalculation({
    required this.baseXp,
    required this.reflectionBonus,
    required this.totalXp,
  });
}

/// Calculates XP earned for a session and converts XP to unlock minutes.
///
/// Stateless — all inputs are passed per call so the same instance can be
/// used for any session without resetting.
class XpService {
  const XpService();

  /// Calculates XP earned for one completed session.
  ///
  /// Base rule: 1 minute = 1 XP.
  ///
  /// Multipliers are applied to the base before the reflection bonus:
  /// - Generic sessions apply [genericSessionMultiplier] (default 0.85).
  /// - [scoringMultiplier] is reserved for a future AI confidence score
  ///   (0.0–1.0 range, default 1.0 = no adjustment). When the AI layer
  ///   is added, pass the confidence score here; everything else composes
  ///   automatically.
  ///
  /// Reflection bonus ([reflectionBonusXp], default 5) is additive after
  /// all multipliers so it rewards the act of reflecting regardless of
  /// session type.
  XpCalculation calculateSessionXp({
    required int actualMinutes,
    required SessionType sessionType,
    required bool hasReflection,
    int reflectionBonusXp = 5,
    double genericSessionMultiplier = 0.85,
    double scoringMultiplier = 1.0,
  }) {
    final effectiveMultiplier = sessionType == SessionType.generic
        ? genericSessionMultiplier * scoringMultiplier
        : scoringMultiplier;

    final baseXp = (actualMinutes * effectiveMultiplier).floor();
    final reflectionBonus = hasReflection ? reflectionBonusXp : 0;

    return XpCalculation(
      baseXp: baseXp,
      reflectionBonus: reflectionBonus,
      totalXp: baseXp + reflectionBonus,
    );
  }

  /// Converts an XP amount into unlock minutes.
  ///
  /// Rule: [xpToUnlockMinuteRatio] XP = 1 unlock minute (default 2).
  /// Fractional minutes are discarded — partial XP does not grant unlock time.
  int calculateUnlockMinutes({
    required int xpEarned,
    int xpToUnlockMinuteRatio = 2,
  }) {
    if (xpToUnlockMinuteRatio <= 0) return 0;
    return xpEarned ~/ xpToUnlockMinuteRatio;
  }
}
