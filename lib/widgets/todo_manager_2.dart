import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/todo_provider_2.dart';

class TodoApp extends HookConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoState = ref.watch(todoProvider); // ToDoリストの状態を監視
    final notifier = ref.read(todoProvider.notifier); // 操作用のNotifer

    final idController = TextEditingController(); // ID入力用
    final todoController = TextEditingController(); // ToDo入力用

    return Scaffold(
      appBar: AppBar(title: const Text('ToDo Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(controller: idController, label: 'IDを入力'),
            _buildTextField(controller: todoController, label: 'ToDoを入力'),
            const SizedBox(height: 20),
            _buildButtonRow(
              onFetchAll: notifier.fetchAllTodos,
              onFetchOne: () async {
                final id = idController.text;
                if (id.isEmpty) return;

                final todo = await notifier.fetchTodoById(int.tryParse(idController.text) ?? 0);
                todoController.text = todo ?? '';
                if (todo == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ToDoが見つかりません')),
                  );
                }
              },
              onAdd: () => notifier.addTodo(
                int.tryParse(idController.text) ?? 0,
                todoController.text,
              ),
              onUpdate: () => notifier.updateTodo(
                int.tryParse(idController.text) ?? 0,
                todoController.text,
              ),
              onDelete: () => notifier.deleteTodoById(
                int.tryParse(idController.text) ?? 0,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: todoState.todos.length,
                itemBuilder: (context, index) {
                  final todo = todoState.todos[index];
                  return ListTile(
                    title: Text("ID: ${todo['id']} - ${todo['todo']}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 共通のTextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  // ボタン群
  Widget _buildButtonRow({
    required VoidCallback onFetchAll,
    required VoidCallback onFetchOne,
    required VoidCallback onAdd,
    required VoidCallback onUpdate,
    required VoidCallback onDelete,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(onPressed: onFetchAll, child: const Text('全件検索')),
        ElevatedButton(onPressed: onFetchOne, child: const Text('1件取得')),
        ElevatedButton(onPressed: onAdd, child: const Text('追加')),
        ElevatedButton(onPressed: onUpdate, child: const Text('更新')),
        ElevatedButton(onPressed: onDelete, child: const Text('削除')),
      ],
    );
  }
}
