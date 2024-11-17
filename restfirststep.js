const express = require("express"); // expressモジュールのインポート
const http = require("http"); // httpモジュールのインポート
const app = express(); // expressアプリケーションの作成
app.use(express.json()); // JSON形式のリクエストボディを処理するためのミドルウェア設定

// POSTリクエストを受けてメッセージを処理するエンドポイント
app.post("/post-hello", (req, res) => {
  // リクエストボディにメッセージが含まれている場合
  if (req.body.message) {
    helloMessage = req.body.message; // メッセージを変数に格納
    res.send("OK:" + helloMessage); // メッセージを返す
  } else {
    res.send("ERROR"); // メッセージが無ければエラーを返す
  }
});

// GETリクエストに対して「hello server」を返すエンドポイント
app.get("/hello", (req, res) => {
  res.send("hello server"); // 単純なレスポンスを返す
});

const port = 3000; // サーバーがリッスンするポート番号を設定
const server = http.createServer(app); // HTTPサーバーを作成
server.listen(port); // 指定したポートでサーバーを開始
console.log("Server listen on port " + port); // サーバーが起動したことをコンソールに出力

let counter = 0; // カウンター変数の初期化

// GETリクエストに対してカウンターをインクリメントして返すエンドポイント
app.get("/countup", (req, res) => {
  counter++; // カウンターを1増やす
  res.send("" + counter); // 増加後のカウンターの値を文字列として返す
});
