import 'package:flutter/material.dart';
import '../services/api_service.dart';

// TodoManagerウィジェット
class TodoManager extends StatefulWidget {
  const TodoManager({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodoManagerState createState() => _TodoManagerState();
}

class _TodoManagerState extends State<TodoManager> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _todoController = TextEditingController();

   // IDによるToDo検索
  Future<void> _searchTodo() async {
    final id = _idController.text;
    if (id.isEmpty) return; // IDが空の場合は処理を中断

    final todo = await ApiService.fetchTodoById(int.parse(id));
    setState(() {
      _todoController.text = todo?['todo'] ?? ''; // 見つからなければ空文字
    });
  }

  // ToDoの追加
  Future<void> _addTodo() async {
    final id = _idController.text;
    final todoText = _todoController.text;
    if (id.isEmpty || todoText.isEmpty) return; // IDまたはToDoが空なら処理しない

    final success = await ApiService.addTodo(
      int.parse(id),
      todoText,
    );
    if (success != null) {
      setState(() {
        _todoController.text = '';
        _idController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'IDを入力'),
            ),
            // ToDo入力用のTextField
            TextField(
              controller: _todoController,
              decoration: const InputDecoration(labelText: 'ToDoを入力'),
            ),
            const SizedBox(height: 20),
            // 検索と追加のボタン
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: _searchTodo, child: const Text('検索')),
                ElevatedButton(onPressed: _addTodo, child: const Text('追加')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
