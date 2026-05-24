---
name: reviewing-code-yk
description: >
  変更差分・ソースの単一パスコードレビュー（1エージェント・1周）。「コードレビューして」「この差分をレビュー」「PR前に見て」「変更をレビュー」で使用。
  重大度付きの所見と次アクションを返す。修正の実装はユーザー明示まで行わない。
  Do NOT use for サブエージェント並列・多視点・3レンズ以上（→ reviewing-with-subagents）、スキル MD の委員会型レビュー、図解/HTMLのみ、チャット再説明、commit/push/PR作成。
---

# Code Review（YK · 単一パス）

**役割:** コード・差分を **1 回の読み取り**でレビューし、所見を返す。`Task` による並列レビューは **行わない**。

## Step 0: 委譲判定（先に）

次に当てはまるときは **本スキルを使わず** `reviewing-with-subagents` の `SKILL.md` を Read して従う。

| ユーザー意図の例 | 委譲先 |
|------------------|--------|
| サブエージェント · 並列 · 多視点 · 3レンズ · 委員会型 | `reviewing-with-subagents` |
| 報告者/報告先/監査 · Staff+Security など **複数レンズ明示** | 同上 |
| スキルパッケージの **執筆品質を多視点**で見る | 同上（基準は `SKILL_AUTHORING_RULES.md`） |

**本スキルが担うもの:** 通常の **コード・差分・PR 前**の軽量レビュー。

## Step 1: 対象と制約

親が確定する:

| 項目 | 内容 |
|------|------|
| **対象** | パス · `@` ファイル · 貼り付け · ユーザー提供 diff。`git diff` は **Shell 禁止時は使わない**（Read / Grep / 親が渡した差分のみ） |
| **目的** | マージ可否 · バグ · 設計 · 可読性 など（ユーザーが書いていなければ「マージ前の問題洗い出し」） |
| **スコープ外** | リファクタ全体 · 無関係ファイルの修正（ユーザーが明示したときのみ） |

**ルール参照（必要時のみ Read）:**

| 対象 | SSOT |
|------|------|
| Python | `c:/yk-skill/rule/40_python/PYTHON_RULES.md` |
| スキル MD | `c:/yk-skill/rule/10_meta/SKILL_AUTHORING_RULES.md` |
| Git 操作 | レビュー内では **commit/push しない**（`committing-with-git-yk` は別） |

## Step 2: 事前整理（親がやる）

- **機械で拾えるものは先に潰す:** リンター・型・明らかなフォーマット（ユーザーが「lint も」と言ったときのみ実行）
- **読む順:** 変更の意図（ユーザー説明）→ 差分 → 呼び出し元・型・境界

## Step 3: 単一パスレビュー

[references/checklist.md](references/checklist.md) の観点で **1 周だけ**読む。同じ論点をレンズ分けして繰り返さない。

重点（ユーザー指定がなければこの順）:

1. **正しさ** — バグ · 境界 · エラー処理 · リグレッション
2. **セキュリティ** — 注入 · 秘密 · 権限（該当時）
3. **保守性** — 命名 · 重複 · テストの有無（不足は指摘のみ）

## Step 4: 報告（出力形式）

```markdown
## サマリー
（1〜2文 · マージ可否の印象）

## 所見
| 重大度 | 場所 | 問題 | 提案 |
|--------|------|------|------|
| blocker/major/minor/nit | path:行 | … | … |

## よかった点（任意）
- …

## 次のアクション
1. …
```

- **重大度:** [checklist.md](references/checklist.md) の定義に従う
- **コード引用:** ```startLine:endLine:path``` 形式を優先
- **修正:** ユーザーが「直して」と言うまで実装しない（指摘と提案のみ）

## 禁止

- `Task` でサブエージェントを並列起動する（多視点は `reviewing-with-subagents`）
- レビュー名目で無関係な大規模リファクタ
- レビュー報告なしに `git commit` / `push` / `gh pr create`

## 参照

- 観点 · 重大度: [references/checklist.md](references/checklist.md)
- 多視点レビュー: `c:/yk-skill/.claude/skills/reviewing-with-subagents/SKILL.md`
