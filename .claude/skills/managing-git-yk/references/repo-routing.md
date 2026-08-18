# リポジトリ判定（YK マルチルート）

**SSOT（役割・移行）:** `c:/yk-skill/rule/RULE_INDEX.md` §リポジトリマップ · `c:/yk-memo/handoffs/workspace-layout/HANDOFF.md`

## 既定 Git ルート

| ルート | 用途（要約） |
|--------|----------------|
| `c:/yk-memo` | メモ · handoffs · 企画 |
| `c:/yk-skill` | スキル · `rule/` |
| `c:/yk-tool` | `publish/` · `apps/` · ui-kit 等 |
| `c:/yk-document` | 業務データ（必要時のみ） |
| `c:/1.cursor/5.Python` | 実験アーカイブ — **ユーザー明示時のみ** commit 対象 |

## 判定手順

1. セッションで編集したファイルパス · ユーザー指定パスを列挙
2. 各パスで `git -C "<親をたどる>" rev-parse --show-toplevel`（または下表ルートでプレフィックス照合）
3. 得られた toplevel を **重複除去**
4. 結果が 0 → ユーザーに「どのリポの何をコミットするか」を質問
5. 結果が 2 以上 → **リポごとに別コミット**（メッセージも分ける）

## ユーザー指定の解釈

| 発話例 | 解釈 |
|--------|------|
| `yk-tool をコミット` | `c:/yk-tool` のみ |
| `移行分をコミット` | 文脈のパスが載るリポ（複数なら一覧提示して確認） |
| `全部コミット` | 変更のある **全ルート**を列挙し、OK を取ってから順に commit |

## 注意

- 図解 HTML 正本は `c:/yk-tool/publish/`（`yk-memo/output/` は退避用 · 通常 Git 無視）
- `handoffs/` の変更は通常 `yk-memo` ルート
- ルート外パスだけでは commit しない
