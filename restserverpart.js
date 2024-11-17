const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());

const port = 3000;
app.listen(port, () => {
  console.log("Server running on PORT:" + port);
});

// JSONデータの準備
const todos = [
  { id: 1, todo: "Game" },
  { id: 2, todo: "Camp" },
  { id: 3, todo: "Study" },
];

// 一覧の取得
app.get("/api/todos", (req, res) => {
    res.send(todos); // 全てのToDoを返す
  });
  
// IDでの取得
app.get("/api/todos/:id", (req, res) => {
  const todoId = parseInt(req.params.id, 10); // IDを数値に変換
  const todo = todos.find((t) => t.id === todoId);

  if (todo) {
    res.send(todo); // 該当するToDoを返す
  } else {
    res.status(404).send("ToDoが見つかりません");
  }
});

// ToDoの削除
app.delete("/api/todos/:id", (req, res) => {
  const todoId = parseInt(req.params.id, 10); // IDを数値に変換
  const index = todos.findIndex((t) => t.id === todoId);

  if (index !== -1) {
    todos.splice(index, 1); // 該当するToDoを削除
    res.send(todos); // 更新後のToDo一覧を返す
  } else {
    res.status(404).send("このToDoは存在しません");
  }
});
