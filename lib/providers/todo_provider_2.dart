import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/api_service.dart';

// 状態モデル
class TodoState {
  final List<Map<String, dynamic>> todos;
  const TodoState({this.todos = const []});
}

// StateNotifierによる状態管理
class TodoNotifier extends StateNotifier<TodoState> {
  TodoNotifier() : super(const TodoState());

  Future<void> fetchAllTodos() async {
    final todos = await ApiService.fetchAllTodos();
    state = TodoState(todos: todos ?? []);
  }

  Future<String?> fetchTodoById(int id) async {
    final todo = await ApiService.fetchTodoById(id);
    return todo?['todo'];
  }

  Future<void> addTodo(int id, String todoText) async {
    final updatedTodos = await ApiService.addTodo(id, todoText);
    if (updatedTodos != null) state = TodoState(todos: updatedTodos);
  }

  Future<void> updateTodo(int id, String todoText) async {
    final updatedTodos = await ApiService.updateTodo(id, todoText);
    if (updatedTodos != null) state = TodoState(todos: updatedTodos);
  }

  Future<void> deleteTodoById(int id) async {
    final updatedTodos = await ApiService.deleteTodoById(id);
    if (updatedTodos != null) state = TodoState(todos: updatedTodos);
  }
}

// プロバイダーの定義
final todoProvider =
    StateNotifierProvider<TodoNotifier, TodoState>((ref) => TodoNotifier());
