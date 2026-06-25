# コード最適化 — スコープ

## デフォルト

| 項目 | 決定 |
|------|------|
| **リポ** | ユーザー指定 · `@` パス · 文脈のプロジェクト（例: `flowchart-studio`） |
| **パス** | 明示がなければ **リポ全体**（ただし Read は Grep で絞る） |
| **深さ** | 変更ファイル周辺 + エントリ（`app/` · 主要 `components/`）を優先 |

## パス限定（ユーザー明示時）

例: `frontend/src/components/flowchart/` のみ · `lib/flowchart/` のみ

このとき M1 の Web 調査クエリもそのスタックに合わせる（React コンポーネントなら React 19 / Next 公式等）。

## やらないこと（デフォルト）

| 除外 | 理由 |
|------|------|
| 依頼外リポの横断スキャン | ノイズ · コスト |
| `node_modules` · `.next` · 生成物 | 非 SSOT |
| 資料のみ（`docs/`） | `organizing-documents-yk` |

## Read のしかた

1. `package.json`（または `pyproject.toml`）でスタック確定
2. 対象パスを Glob · Grep で列挙
3. サブエージェントには **パス一覧 + 調査 URL 要約**を prompt に埋め込む

Shell は `AGENT_SHELL_RULES` に従う（調査ターンでは test 実行以外は原則禁止）。
