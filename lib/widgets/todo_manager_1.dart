import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/todo_provider_1.dart';

class TodoManager extends ConsumerWidget {
  const TodoManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);
    final idController = ref.watch(idControllerProvider);
    final todoController = ref.watch(todoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ID入力用のTextField
            TextField(
              controller: idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'IDを入力'),
            ),
            // ToDo入力用のTextField
            TextField(
              controller: todoController,
              decoration: const InputDecoration(labelText: 'ToDoを入力'),
            ),
            const SizedBox(height: 20),
            // ボタン群（全件検索、検索、追加、更新、削除）
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      ref.read(todoProvider.notifier).fetchAllTodos(),
                  child: const Text('全件検索'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final id = idController.text;
                    if (id.isEmpty) return;

                    final todo = await ref
                        .read(todoProvider.notifier)
                        .fetchTodoById(int.parse(id));
                    todoController.text = todo ?? '';
                  },
                  child: const Text('検索'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final id = idController.text;
                    final todoText = todoController.text;
                    if (id.isEmpty || todoText.isEmpty) return;

                    ref
                        .read(todoProvider.notifier)
                        .addTodo(int.parse(id), todoText);
                    idController.clear();
                    todoController.clear();
                  },
                  child: const Text('追加'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final id = idController.text;
                    final todoText = todoController.text;
                    if (id.isEmpty || todoText.isEmpty) return;

                    ref
                        .read(todoProvider.notifier)
                        .updateTodo(int.parse(id), todoText);
                    idController.clear();
                    todoController.clear();
                  },
                  child: const Text('更新'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final id = idController.text;
                    if (id.isEmpty) return;

                    ref
                        .read(todoProvider.notifier)
                        .deleteTodoById(int.parse(id));
                    idController.clear();
                    todoController.clear();
                  },
                  child: const Text('削除'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// ToDoリストを表示
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
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
}
