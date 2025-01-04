import '../constants/todo_constants.dart';

class TodoItem {
  final int? id;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final bool isPaused;
  final int? timeLimit;

  TodoItem({
    this.id,
    required this.title,
    required this.description,
    String? status,
    DateTime? createdAt,
    this.startedAt,
    this.completedAt,
    this.isPaused = false,
    this.timeLimit,
  })  : status = status ?? TodoStatus.todo.value,
        createdAt = createdAt ?? DateTime.now(),
        assert(
          timeLimit == null || timeLimit <= TodoConstants.maxTimeLimit,
          'Time limit cannot exceed ${TodoConstants.maxTimeLimit} seconds',
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isPaused': isPaused ? 1 : 0,
      'timeLimit': timeLimit,
    };
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
      startedAt:
          map['startedAt'] != null ? DateTime.parse(map['startedAt']) : null,
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      isPaused: map['isPaused'] == 1,
      timeLimit: map['timeLimit'],
    );
  }

  TodoItem copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    bool? isPaused,
    int? timeLimit,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      isPaused: isPaused ?? this.isPaused,
      timeLimit: timeLimit ?? this.timeLimit,
    );
  }
}
