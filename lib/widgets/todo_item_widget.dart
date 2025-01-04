import 'package:flutter/material.dart';
import 'package:yash_pratical/widgets/delete_confirmation_dialog.dart';
import '../models/todo_item.dart';
import 'dart:async';
import '../constants/todo_constants.dart';
import 'package:get/get.dart';

class TodoItemWidget extends StatefulWidget {
  final TodoItem todo;
  final VoidCallback onDelete;
  final Function(TodoItem) onStatusChange;

  const TodoItemWidget({
    Key? key,
    required this.todo,
    required this.onDelete,
    required this.onStatusChange,
  }) : super(key: key);

  @override
  _TodoItemWidgetState createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends State<TodoItemWidget> {
  Timer? _timer;
  String _duration = '';

  @override
  void initState() {
    super.initState();
    if (widget.todo.status == TodoStatus.inProgress.value &&
        !widget.todo.isPaused) {
      _startTimer();
    }
    _updateDuration();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateDuration();
    });
  }

  void _updateDuration() {
    if (widget.todo.startedAt == null) return;

    final now = DateTime.now();
    final duration = now.difference(widget.todo.startedAt!);
    setState(() {
      _duration = _formatDuration(duration);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = TodoStatus.fromString(widget.todo.status);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.todo.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: status == TodoStatus.done
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                _buildStatusChip(status),
              ],
            ),
            if (widget.todo.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                widget.todo.description,
                style: TextStyle(
                  color: Colors.grey[600],
                  decoration: status == TodoStatus.done
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ],
            if (widget.todo.startedAt != null) ...[
              const SizedBox(height: 8),
              Text(
                'Timer: $_duration',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: _getStatusIcon(),
                  color: Theme.of(context).primaryColor,
                  onPressed: _handleStatusChange,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  onPressed: _showDeleteConfirmation,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(TodoStatus status) {
    Color chipColor;
    switch (status) {
      case TodoStatus.todo:
        chipColor = Colors.grey;
        break;
      case TodoStatus.inProgress:
        chipColor = Colors.blue;
        break;
      case TodoStatus.done:
        chipColor = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.value,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Icon _getStatusIcon() {
    switch (widget.todo.status) {
      case 'TODO':
        return const Icon(Icons.play_arrow);
      case 'In-Progress':
        return Icon(widget.todo.isPaused ? Icons.play_arrow : Icons.pause);
      case 'Done':
        return const Icon(Icons.check);
      default:
        return const Icon(Icons.error);
    }
  }

  void _handleStatusChange() {
    TodoItem updatedTodo;
    final now = DateTime.now();

    switch (widget.todo.status) {
      case 'TODO':
        updatedTodo = TodoItem(
          id: widget.todo.id,
          title: widget.todo.title,
          description: widget.todo.description,
          status: 'In-Progress',
          createdAt: widget.todo.createdAt,
          startedAt: now,
        );
        _startTimer();
        break;
      case 'In-Progress':
        if (widget.todo.isPaused) {
          updatedTodo = TodoItem(
            id: widget.todo.id,
            title: widget.todo.title,
            description: widget.todo.description,
            status: 'In-Progress',
            createdAt: widget.todo.createdAt,
            startedAt: widget.todo.startedAt,
            isPaused: false,
          );
          _startTimer();
        } else {
          updatedTodo = TodoItem(
            id: widget.todo.id,
            title: widget.todo.title,
            description: widget.todo.description,
            status: 'Done',
            createdAt: widget.todo.createdAt,
            startedAt: widget.todo.startedAt,
            completedAt: now,
          );
          _timer?.cancel();
        }
        break;
      default:
        return;
    }

    widget.onStatusChange(updatedTodo);
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      DeleteConfirmationDialog(
        title: widget.todo.title,
        onDelete: widget.onDelete,
      ),
      barrierDismissible: true,
    );
  }
}
