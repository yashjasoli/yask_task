import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yash_pratical/models/todo_item.dart';
import '../controllers/todo_controller.dart';
import '../widgets/todo_item_widget.dart';
import '../screens/todo_details_page.dart';
import '../widgets/todo_form_sheet.dart';

class TodoListPage extends StatelessWidget {
  final TodoController todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: Text(
          'My Tasks',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search tasks',
                hintText: 'Enter task name...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).primaryColor,
                ),
                filled: true,
                fillColor: Theme.of(context).primaryColor.withOpacity(0.05),
              ),
              onChanged: (query) => todoController.searchTodos(query),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (todoController.filteredTodos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_outlined,
                        size: 64,
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks found',
                        style: TextStyle(
                          fontSize: 18,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: todoController.filteredTodos.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => TodoDetailsPage(
                          todo: todoController.filteredTodos[index],
                        ),
                        transition: Transition.rightToLeft,
                      )?.then((_) => todoController.loadTodos());
                    },
                    child: TodoItemWidget(
                      todo: todoController.filteredTodos[index],
                      onDelete: () => todoController
                          .deleteTodo(todoController.filteredTodos[index].id!),
                      onStatusChange: (TodoItem updatedTodo) async {
                        await todoController.updateTodo(updatedTodo);
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            builder: (context) => TodoFormSheet(
              onSave: (TodoItem newTodo) async {
                await todoController.addTodo(newTodo);
              },
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}
