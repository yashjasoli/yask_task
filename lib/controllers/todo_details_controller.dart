import 'package:get/get.dart';
import 'dart:async';
import '../models/todo_item.dart';
import '../constants/todo_constants.dart';

class TodoDetailsController extends GetxController {
  final TodoItem initialTodo;
  final Function(TodoItem) onTodoUpdated;

  final _duration = ''.obs;
  final _isRunning = false.obs;
  final _todo = Rx<TodoItem?>(null);
  Timer? _timer;

  TodoDetailsController({
    required this.initialTodo,
    required this.onTodoUpdated,
  });

  // Getters
  TodoItem get todo => _todo.value ?? initialTodo;
  bool get isRunning => _isRunning.value;
  String get duration => _duration.value;
  bool get isDone => TodoStatus.fromString(todo.status) == TodoStatus.done;
  bool get canStart => !isDone && (!isRunning || todo.isPaused);
  bool get canStop => !isDone && isRunning;

  @override
  void onInit() {
    super.onInit();
    _initializeTodo();
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }

  void _initializeTodo() {
    _todo.value = initialTodo;
    if (_shouldStartTimer) {
      startTimer();
    }
    _updateDuration();
  }

  bool get _shouldStartTimer =>
      TodoStatus.fromString(todo.status) == TodoStatus.inProgress &&
      !todo.isPaused;

  void startTimer() {
    _isRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), _onTimerTick);
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _isRunning.value = false;
  }

  void _onTimerTick(Timer timer) {
    _updateDuration();
    _checkTimeLimit();
  }

  void _checkTimeLimit() {
    if (!_hasTimeLimit) return;

    final now = DateTime.now();
    final duration = now.difference(todo.startedAt!);
    if (duration.inSeconds >= todo.timeLimit!) {
      handleStop();
    }
  }

  bool get _hasTimeLimit => todo.timeLimit != null && todo.startedAt != null;

  void _updateDuration() {
    if (todo.startedAt == null) return;

    final now = DateTime.now();
    final duration = now.difference(todo.startedAt!);
    _duration.value = _formatDuration(duration);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> handlePlay() async {
    if (!canStart) return;

    final now = DateTime.now();
    final updatedTodo = todo.copyWith(
      status: TodoStatus.inProgress.value,
      startedAt: todo.startedAt ?? now,
      isPaused: false,
    );
    await _updateTodo(updatedTodo);
    startTimer();
  }

  Future<void> handlePause() async {
    if (!canStop) return;

    _stopTimer();
    final updatedTodo = todo.copyWith(isPaused: true);
    await _updateTodo(updatedTodo);
  }

  Future<void> handleStop() async {
    _stopTimer();
    final now = DateTime.now();
    final updatedTodo = todo.copyWith(
      status: TodoStatus.done.value,
      completedAt: now,
    );
    await _updateTodo(updatedTodo);
  }

  Future<void> _updateTodo(TodoItem updatedTodo) async {
    _todo.value = updatedTodo;
    await onTodoUpdated(updatedTodo);
  }
}
