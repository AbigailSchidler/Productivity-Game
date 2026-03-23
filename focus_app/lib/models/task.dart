/// User-perceived difficulty of a task.
///
/// Multipliers reward tackling harder or dreaded tasks with more XP.
/// Bounded range: 0.9 (easy) – 1.5 (dreaded).
enum TaskDifficulty {
  easy,
  normal,
  hard,
  dreaded;

  String get label => switch (this) {
        easy => 'Easy',
        normal => 'Normal',
        hard => 'Hard',
        dreaded => 'Dreaded',
      };

  /// XP multiplier applied to task sessions with this difficulty.
  double get multiplier => switch (this) {
        easy => 0.9,
        normal => 1.0,
        hard => 1.25,
        dreaded => 1.5,
      };

  String get multiplierLabel => switch (this) {
        easy => '0.9×',
        normal => '1.0×',
        hard => '1.25×',
        dreaded => '1.5×',
      };
}

class Task {
  final String id;
  final String title;
  final String category;
  final int defaultDurationMinutes;
  final bool isRecurring;
  final bool isArchived;
  final TaskDifficulty difficulty;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    required this.category,
    required this.defaultDurationMinutes,
    this.isRecurring = false,
    this.isArchived = false,
    this.difficulty = TaskDifficulty.normal,
    required this.createdAt,
    required this.updatedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? category,
    int? defaultDurationMinutes,
    bool? isRecurring,
    bool? isArchived,
    TaskDifficulty? difficulty,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      defaultDurationMinutes:
          defaultDurationMinutes ?? this.defaultDurationMinutes,
      isRecurring: isRecurring ?? this.isRecurring,
      isArchived: isArchived ?? this.isArchived,
      difficulty: difficulty ?? this.difficulty,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'defaultDurationMinutes': defaultDurationMinutes,
        'isRecurring': isRecurring,
        'isArchived': isArchived,
        'difficulty': difficulty.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        title: json['title'] as String,
        category: json['category'] as String,
        defaultDurationMinutes: json['defaultDurationMinutes'] as int,
        isRecurring: json['isRecurring'] as bool,
        isArchived: json['isArchived'] as bool,
        // Null-safe default so tasks saved before this field was added still load.
        difficulty: json['difficulty'] != null
            ? TaskDifficulty.values.byName(json['difficulty'] as String)
            : TaskDifficulty.normal,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
