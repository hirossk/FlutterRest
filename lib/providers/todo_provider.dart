import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

// ToDoの状態を管理するクラス
class TodoNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  TodoNotifier() : super([]);

  Future<void> fetchAllTodos() async {
    final result = await ApiService.fetchAllTodos();
    state = result ?? [];
  }

  Future<String?> fetchTodoById(String id) async {
    final todo = await ApiService.fetchTodoById(id);
    return todo?['todo'];
  }

  Future<void> addTodo(int id, String todo) async {
    final updatedTodos = await ApiService.addTodo(id, todo);
    if (updatedTodos != null) {
      state = updatedTodos;
    }
  }

  Future<void> updateTodo(int id, String todo) async {
    final updatedTodos = await ApiService.updateTodo(id, todo);
    if (updatedTodos != null) {
      state = updatedTodos;
    }
  }

  Future<void> deleteTodoById(int id) async {
    final updatedTodos = await ApiService.deleteTodoById(id);
    if (updatedTodos != null) {
      state = updatedTodos;
    }
  }
}

// プロバイダーの定義
final todoProvider = StateNotifierProvider<TodoNotifier, List<Map<String, dynamic>>>(
  (ref) => TodoNotifier(),
);

final idControllerProvider = StateProvider<TextEditingController>(
  (ref) => TextEditingController(),
);

final todoControllerProvider = StateProvider<TextEditingController>(
  (ref) => TextEditingController(),
);
