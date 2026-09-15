# Python 技術ナレッジベース 外部連携 (Field Manual - External Integration)
## ■ 本書の役割
スクレイピング、データベース、API 連携、ネットワーク通信に関するナレッジ。**（05番へ移動）**

---

## 第1章：データ収集と永続化 (Data & Persistence)

### [K-012] スクレイピング堅牢化
- **マナーと防護**: 連続アクセス時は必ずスリープを入れ、`User-Agent` を設定せよ。
- **指数バックオフ**: リトライ時は `2^n + random` 秒の待機を入れ、サーバー負荷を最小化せよ。

### [K-018] SQLite のスレッドセーフ管理
- **接続の隔離**: マルチスレッド環境では、スレッドごとに新しい DB 接続を作成するか、キューイングによる一括処理を行え。

### [K-060] HTTP クライアントの選択 (httpx)
- **非同期対応**: `requests` に代わり、非同期通信（asyncio）に対応し、よりモダンな API を提供する `httpx` の採用を推奨。
- **導入**: `uv add httpx`

### [K-061] JSON 処理の高速化と安全性
- **信頼性**: 巨大な JSON や複雑なネスト構造を扱う際は、標準の `json` よりも `orjson` や `msgspec` などの高速なライブラリを検討せよ。

### [K-062] ローカルサーバーのdetached自動起動+ヘルスチェック待機
- **プロセス切り離し**: CLI終了後もバックグラウンドサーバーを動かし続けるには、Windowsは`subprocess.Popen(..., creationflags=subprocess.DETACHED_PROCESS | subprocess.CREATE_NEW_PROCESS_GROUP, stdin/stdout/stderr=subprocess.DEVNULL)`、POSIXは`start_new_session=True`を使う（`**kwargs`辞書展開だとmypyが`Popen`オーバーロード解決に失敗するので、プラットフォーム分岐で別呼び出しにする）。
- **3値ヘルスチェック**: 「未起動（接続拒否）」「起動済みだが読込中（503等）」「準備完了（200）」を区別し、未起動時のみ起動して二重起動を避ける。テストでは`time.sleep`を直接使わず`sleep_func`引数で注入し、監視ループを実時間に依存せず検証する。
- **`-hf`系の取得オプションは常駐起動に使わない**: モデルがキャッシュ済みでも毎回リモートへ疎通確認に行き、遅延・ハングの原因になりうる（llama.cppで実測）。日常起動はダウンロード済みのローカルパスを直接指定する。
