import 'package:http/http.dart' as http; // HTTPリクエストを扱うためのライブラリ
import 'dart:convert'; // JSONデータを扱うためのライブラリ

// API通信を行うサービスクラス
class ApiService {
  // APIのベースURL
  static const String baseUrl = 'http://localhost:3000/api/todos';

  // 全てのToDoを取得する非同期メソッド
  static Future<List<Map<String, dynamic>>?> fetchAllTodos() async {
    try {
      // HTTP GETリクエストを送信してレスポンスを取得
      final response = await http.get(Uri.parse(baseUrl));

      // レスポンスのステータスコードが200（成功）ならば
      if (response.statusCode == 200) {
        // JSONデータをデコードし、List<Map<String, dynamic>>型に変換
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (e) {
      // エラーが発生した場合はエラーメッセージを表示
      print(e);
    }
    return null; // エラーまたは失敗した場合はnullを返す
  }

  // IDを指定してToDoを取得する非同期メソッド
  static Future<Map<String, dynamic>?> fetchTodoById(String id) async {
    try {
      // 指定したIDのToDoを取得するHTTP GETリクエストを送信
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      // レスポンスのステータスコードが200（成功）ならば
      if (response.statusCode == 200) {
        // JSONデータをデコードしてMap型で返す
        return json.decode(response.body);
      }
    } catch (e) {
      // エラーが発生した場合は何もしない（後でエラーハンドリングを追加することもできる）
    }
    return null; // 失敗した場合はnullを返す
  }

  // 新しいToDoを追加する非同期メソッド
  static Future<List<Map<String, dynamic>>?> addTodo(
      int id, String todo) async {
    try {
      // 新しいToDoを追加するためのHTTP POSTリクエストを送信
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id, 'todo': todo}),
      );

      // レスポンスのステータスコードが200（成功）ならば
      if (response.statusCode == 200) {
        // JSONデータをデコードしてリストに変換して返す
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (e) {
      // エラーが発生した場合は何もしない
    }
    return null; // 失敗した場合はnullを返す
  }

  // 既存のToDoを更新する非同期メソッド
  static Future<List<Map<String, dynamic>>?> updateTodo(
      int id, String todo) async {
    try {
      // ToDoの更新リクエスト（HTTP PUT）を送信
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'todo': todo}),
      );

      // レスポンスのステータスコードが200（成功）ならば
      if (response.statusCode == 200) {
        // JSONデータをデコードしてリストに変換して返す
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (e) {
      // エラーが発生した場合は何もしない
    }
    return null; // 失敗した場合はnullを返す
  }

  // IDを指定してToDoを削除する非同期メソッド
  static Future<List<Map<String, dynamic>>?> deleteTodoById(int id) async {
    try {
      // ToDo削除のHTTP DELETEリクエストを送信
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      // レスポンスのステータスコードが200（成功）ならば
      if (response.statusCode == 200) {
        // JSONデータをデコードしてリストに変換して返す
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (e) {
      // エラーが発生した場合は何もしない
    }
    return null; // 失敗した場合はnullを返す
  }
}
