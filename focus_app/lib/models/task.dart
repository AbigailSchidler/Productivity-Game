class Task {
  final String id;
  final String title;
  final String category;
  final int defaultDurationMinutes;
  final bool isRecurring;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    required this.category,
    required this.defaultDurationMinutes,
    this.isRecurring = false,
    this.isArchived = false,
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
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
