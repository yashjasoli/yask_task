enum TodoStatus {
  todo('TODO'),
  inProgress('In-Progress'),
  done('Done');

  final String value;
  const TodoStatus(this.value);

  static TodoStatus fromString(String status) {
    return TodoStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => TodoStatus.todo,
    );
  }
}

class TodoConstants {
  static const int maxTimeLimit = 5 * 60; // 5 minutes in seconds
  static const int maxMinutes = 5;
  static const int maxSeconds = 59;
}
