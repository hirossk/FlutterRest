const express = require('express');
const cors = require('cors');
const app = express();

app.use(express.json()); // JSONデータ解析のため
app.use(cors());

const port = 3000;
app.listen(port, () => {
  console.log("server running PORT:"+port);
});

//JSONデータの準備
const todos = [
    { id: 1, todo: "Game" },
    { id: 2, todo: "Camp" },
    { id: 3, todo: "Study" },
  ];

//一覧の取得
app.get("/api/todos", (req, res) => {
    // todosを返す
    res.send(todos);
});

app.get("/api/todos/:id", (req, res) => {
  const todoId = parseInt(req.params.id, 10); // リクエストされたIDを取得し、数値に変換
  const todo = todos.find((t) => t.id === todoId); // todosから該当IDのToDoを検索

  if (todo) {
    res.send(todo); // データが見つかった場合、そのデータを返す
  } else {
    res.status(404).send("ToDoが見つかりません"); // データが見つからなかった場合、404エラーメッセージを返す
  }
});
// todoの登録
app.post("/api/todos", (req, res) => {
    // todos配列のidの最大値を取得し、新しいidを設定
    const maxId = todos.length > 0 ? Math.max(...todos.map(t => t.id)) : 0;
    const newTodo = {
        id: maxId + 1, // 最大値 + 1を新しいidとして設定
        todo: req.body.todo
    };
    todos.push(newTodo); // 新しいToDoを追加
    res.send(todos);     // todosを返す
});


//データの更新
app.put("/api/todos/:id", (req, res) => {
    //指定されたidを持つTodoの特定、データを保持
    const todo = todos.find((t) => t.id === parseInt(req.params.id));
  
    // idが存在しなければエラーを返す
    if (!todo) return res.status(404).send("このToDoは存在しません");
    
    // 名前をリクエストに付与された値に変更
    todo.todo = req.body.todo;
    
    // todosを返す
    res.send(todos);
});
//削除 このままの削除だとデータの作成で不整合を起こします
app.delete("/api/todos/:id", (req, res) => {
    // リクエストされたidを持つユーザの特定
    const todo = todos.find((t) => t.id === parseInt(req.params.id));
  
    // idが存在しなければエラーを返す
    if (!todo) return res.status(404).send("このToDoは存在しません");
    
    // 特定したToDoがtodos配列のどこにいるか調べ
    // そのindexを保持
    const index = todos.indexOf(todo);
    
    // spliceを使いindexをもとにToDoの削除
    todos.splice(index, 1);
  
    // todosを返す
    res.send(todos);
});



