enum SessionType { task, generic }

class Session {
  final String id;
  final SessionType sessionType;
  final String? taskId;
  final String title;
  final int plannedMinutes;
  final int actualMinutes;
  final DateTime startTime;
  final DateTime? endTime;
  final String? reflectionText;
  final int xpEarned;
  final int unlockMinutesGranted;
  final int pauseCount;
  final bool wasCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Session({
    required this.id,
    required this.sessionType,
    this.taskId,
    required this.title,
    required this.plannedMinutes,
    this.actualMinutes = 0,
    required this.startTime,
    this.endTime,
    this.reflectionText,
    this.xpEarned = 0,
    this.unlockMinutesGranted = 0,
    this.pauseCount = 0,
    this.wasCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Session copyWith({
    String? id,
    SessionType? sessionType,
    String? taskId,
    String? title,
    int? plannedMinutes,
    int? actualMinutes,
    DateTime? startTime,
    DateTime? endTime,
    String? reflectionText,
    int? xpEarned,
    int? unlockMinutesGranted,
    int? pauseCount,
    bool? wasCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Session(
      id: id ?? this.id,
      sessionType: sessionType ?? this.sessionType,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reflectionText: reflectionText ?? this.reflectionText,
      xpEarned: xpEarned ?? this.xpEarned,
      unlockMinutesGranted: unlockMinutesGranted ?? this.unlockMinutesGranted,
      pauseCount: pauseCount ?? this.pauseCount,
      wasCompleted: wasCompleted ?? this.wasCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sessionType': sessionType.name,
        'taskId': taskId,
        'title': title,
        'plannedMinutes': plannedMinutes,
        'actualMinutes': actualMinutes,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'reflectionText': reflectionText,
        'xpEarned': xpEarned,
        'unlockMinutesGranted': unlockMinutesGranted,
        'pauseCount': pauseCount,
        'wasCompleted': wasCompleted,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'] as String,
        sessionType: SessionType.values.byName(json['sessionType'] as String),
        taskId: json['taskId'] as String?,
        title: json['title'] as String,
        plannedMinutes: json['plannedMinutes'] as int,
        actualMinutes: json['actualMinutes'] as int,
        startTime: DateTime.parse(json['startTime'] as String),
        endTime: json['endTime'] != null
            ? DateTime.parse(json['endTime'] as String)
            : null,
        reflectionText: json['reflectionText'] as String?,
        xpEarned: json['xpEarned'] as int,
        unlockMinutesGranted: json['unlockMinutesGranted'] as int,
        pauseCount: json['pauseCount'] as int,
        wasCompleted: json['wasCompleted'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
