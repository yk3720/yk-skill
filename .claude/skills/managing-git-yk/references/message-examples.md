# コミットメッセージ例（日本語 · YK 既定）

**方針 SSOT:** `c:/yk-skill/rule/10_meta/GIT_WORKFLOW_RULES.md` §3 — **直近 log を最優先**。本ファイルは log が無い・日本語既定のときの参考。

## 推奨形式（ハイブリッド）

- **type（scope）:** 英小文字 + 任意 scope（commitlint 互換を保ちたいとき）
- **subject / body:** **日本語** · **why** を 1〜2 文

```text
feat(publish): 図解 HTML 正本を yk-tool に移行

yk-memo/output から publish へ物理移行し、SSOT を yk-tool に統一するため。
```

## type の目安

| type | 使うとき |
|------|----------|
| `feat` | 新機能 · 新規収容 |
| `fix` | バグ修正 |
| `docs` | ドキュメント・handoff のみ |
| `chore` | 雑務 · 設定 · 移行の機械的整理 |
| `refactor` | 挙動を変えない整理 |

## 避ける例

| NG | 理由 |
|----|------|
| `update` のみ | why が無い |
| `fix` / 英語1語だけ | 内容が追えない |
| secrets · トークン文字列 | 漏洩リスク |

## ユーザー指定

| 指定 | 対応 |
|------|------|
| 日本語で | subject + 必要なら body を日本語 |
| 本文あり / 詳細に | 空行のあと body に why・補足 |
| Conventional で | type を英語固定（上記ハイブリッド） |
| タイトルだけ | 1 行のみ（リポの log が 1 行型ならそれに合わせる） |

## リポ別の傾向（参考 · 更新時は log を見る）

実際の文体は **必ず `git log -5`** で確認する。過去に `新規作成20260523` のような短い行があるリポもある — **模倣が既定**。
