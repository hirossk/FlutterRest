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
  // TextFieldのコントローラー
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _todoController = TextEditingController();

  // ToDoのリスト
  List<Map<String, dynamic>> todos = [];

  // 全件検索処理
  Future<void> _searchAllTodo() async {
    final result = await ApiService.fetchAllTodos();
    setState(() {
      // 結果がnullでなければ更新、nullなら空のリストを設定
      todos = result ?? [];
    });
  }

  // IDによるToDo検索
  Future<void> _searchTodo() async {
    final id = _idController.text;
    if (id.isEmpty) return; // IDが空の場合は処理を中断

    // ToDoの詳細を取得
    final todo = await ApiService.fetchTodoById(int.parse(id));
    if (todo != null) {
      setState(() {
        // ToDoが見つかればその内容を表示
        _todoController.text = todo['todo']!;
      });
    } else {
      setState(() {
        // 見つからなければ入力欄を空にする
        _todoController.text = '';
      });
    }
  }

  // ToDoの追加
  Future<void> _addTodo() async {
    final id = _idController.text;
    final todoText = _todoController.text;
    if (id.isEmpty || todoText.isEmpty) return; // IDまたはToDoが空なら処理しない

    // 新しいToDoを追加
    final updatedTodos = await ApiService.addTodo(
      int.parse(id),
      todoText,
    );
    if (updatedTodos != null) {
      setState(() {
        // ToDoが追加されたらリストを更新
        todos = updatedTodos;
        _todoController.text = '';
        _idController.text = '';
      });
    }
  }

  // ToDoの更新
  Future<void> _updateTodo() async {
    final id = _idController.text;
    final todoText = _todoController.text;
    if (id.isEmpty || todoText.isEmpty) return; // IDまたはToDoが空なら処理しない

    // ToDoを更新
    final updatedTodos = await ApiService.updateTodo(
      int.parse(id),
      todoText,
    );
    if (updatedTodos != null) {
      setState(() {
        // 更新後にToDoリストを更新
        todos = updatedTodos;
        _todoController.text = '';
        _idController.text = '';
      });
    }
  }

  // ToDoの削除
  Future<void> _deleteTodo() async {
    final id = _idController.text;
    if (id.isEmpty) return; // IDが空なら処理しない

    // ToDoを削除
    final updatedTodos = await ApiService.deleteTodoById(int.parse(id));
    if (updatedTodos != null) {
      setState(() {
        // 削除後にToDoリストを更新
        todos = updatedTodos;
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
              keyboardType: TextInputType.number, // 数字入力専用
              decoration: const InputDecoration(labelText: 'IDを入力'),
            ),
            // ToDo入力用のTextField
            TextField(
              controller: _todoController,
              decoration: const InputDecoration(labelText: 'ToDoを入力'),
            ),
            const SizedBox(height: 20),
            // ボタン群（全件検索、検索、追加、更新、削除）
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: _searchAllTodo, child: const Text('全件検索')),
                ElevatedButton(onPressed: _searchTodo, child: const Text('検索')),
                ElevatedButton(onPressed: _addTodo, child: const Text('追加')),
                ElevatedButton(onPressed: _updateTodo, child: const Text('更新')),
                ElevatedButton(onPressed: _deleteTodo, child: const Text('削除')),
              ],
            ),
            const SizedBox(height: 20),
            // ToDoリストを表示
            Expanded(
              // ColumnやRowのような親ウィジェット内で空間を最大限に活用して、子ウィジェット（ここではListView）が伸びるようにします。
              child: ListView.builder(
                // ListView.builderは効率的にリストのアイテムを作成・表示するウィジェットです。アイテムが多くてもパフォーマンスに優れています。
                itemCount: todos
                    .length, // リストのアイテム数を指定します。todosリストの長さを基に、表示するアイテム数が決まります。
                itemBuilder: (context, index) {
                  // itemBuilderはリストの各アイテムを作成するための関数です。`index`はリスト内のアイテムの位置を示します。
                  final todo = todos[
                      index]; // 現在の`index`に対応する`todos`リストのアイテムを取得します。`todos`はリストの各アイテムがMap形式で保存されています。
                  return ListTile(
                    // ListTileはリストアイテムを表示するウィジェットです。各アイテムが1行で表示されるため、簡潔なリスト表示に適しています。
                    title: Text(
                        "ID: ${todo['id']} - ${todo['todo']}"), // `todo['id']`と`todo['todo']`を表示し、ToDoリストのIDと内容を表示します。
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
