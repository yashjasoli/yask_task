import 'package:get/get.dart';
import '../models/todo_item.dart';
import '../services/database_helper.dart';

class TodoController extends GetxController {
  var todos = <TodoItem>[].obs;
  var filteredTodos = <TodoItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final loadedTodos = await DatabaseHelper.instance.getAllTodos();
    todos.assignAll(loadedTodos);
    filteredTodos.assignAll(loadedTodos);
  }

  Future<void> addTodo(TodoItem todo) async {
    await DatabaseHelper.instance.create(todo);
    loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await DatabaseHelper.instance.delete(id);
    loadTodos();
  }

  Future<void> updateTodo(TodoItem todo) async {
    await DatabaseHelper.instance.update(todo);
    loadTodos();
  }

  void searchTodos(String query) {
    if (query.isEmpty) {
      filteredTodos.assignAll(todos);
    } else {
      filteredTodos.assignAll(
        todos.where(
            (todo) => todo.title.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }
}
