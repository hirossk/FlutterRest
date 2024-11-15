import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/todo_provider.dart';

class TodoManager extends HookConsumerWidget {
  const TodoManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider); // ToDoリストを監視
    final idController = ref.watch(idControllerProvider); // ID入力
    final todoController = ref.watch(todoControllerProvider); // ToDo入力

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ID入力用TextField
            TextField(
              controller: idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'IDを入力'),
            ),
            // ToDo入力用TextField
            TextField(
              controller: todoController,
              decoration: const InputDecoration(labelText: 'ToDoを入力'),
            ),
            const SizedBox(height: 20),
            // ボタン群
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => ref.read(todoProvider.notifier).fetchAllTodos(),
                  child: const Text('全件検索'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final id = idController.text;
                    if (id.isEmpty) return;
                    final todo = await ref.read(todoProvider.notifier).fetchTodoById(id);
                    todoController.text = todo ?? '';
                  },
                  child: const Text('検索'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final id = idController.text;
                    final todoText = todoController.text;
                    if (id.isEmpty || todoText.isEmpty) return;

                    ref.read(todoProvider.notifier).addTodo(int.parse(id), todoText);
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

                    ref.read(todoProvider.notifier).updateTodo(int.parse(id), todoText);
                    idController.clear();
                    todoController.clear();
                  },
                  child: const Text('更新'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final id = idController.text;
                    if (id.isEmpty) return;

                    ref.read(todoProvider.notifier).deleteTodoById(int.parse(id));
                    idController.clear();
                    todoController.clear();
                  },
                  child: const Text('削除'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // ToDoリスト表示
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
