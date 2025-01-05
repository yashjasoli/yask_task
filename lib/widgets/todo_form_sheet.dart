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
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.todo == null ? 'Create Todo' : 'Edit Todo',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _minutesController,
                      decoration: InputDecoration(
                        labelText: 'Minutes (max 5)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.timer),
                      ),
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
                      decoration: InputDecoration(
                        labelText: 'Seconds',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.timer),
                      ),
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
              const SizedBox(height: 24),
              ElevatedButton.icon(
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
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
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
