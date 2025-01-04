import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class TodoFormSheet extends StatefulWidget {
  final Function(TodoItem) onSave;
  final TodoItem? todo;

  const TodoFormSheet({
    Key? key,
    required this.onSave,
    this.todo,
  }) : super(key: key);

  @override
  _TodoFormSheetState createState() => _TodoFormSheetState();
}

class _TodoFormSheetState extends State<TodoFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _minutesController = TextEditingController();
  final _secondsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
      if (widget.todo!.timeLimit != null) {
        _minutesController.text = (widget.todo!.timeLimit! ~/ 60).toString();
        _secondsController.text = (widget.todo!.timeLimit! % 60).toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _minutesController,
                    decoration:
                        const InputDecoration(labelText: 'Minutes (max 5)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final minutes = int.tryParse(value);
                        if (minutes == null || minutes < 0 || minutes > 5) {
                          return 'Enter a value between 0 and 5';
                        }
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _secondsController,
                    decoration: const InputDecoration(labelText: 'Seconds'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final seconds = int.tryParse(value);
                        if (seconds == null || seconds < 0 || seconds > 59) {
                          return 'Enter a value between 0 and 59';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final minutes = int.tryParse(_minutesController.text) ?? 0;
                  final seconds = int.tryParse(_secondsController.text) ?? 0;
                  final timeLimit = minutes * 60 + seconds;
                  final newTodo = TodoItem(
                    id: widget.todo?.id,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    status: widget.todo?.status ?? 'TODO',
                    createdAt: widget.todo?.createdAt ?? DateTime.now(),
                    startedAt: widget.todo?.startedAt,
                    completedAt: widget.todo?.completedAt,
                    isPaused: widget.todo?.isPaused ?? false,
                    timeLimit: timeLimit > 0 ? timeLimit : null,
                  );
                  widget.onSave(newTodo);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }
}
