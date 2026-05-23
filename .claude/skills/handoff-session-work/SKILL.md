---
name: handoff-session-work
description: >
  セッション終了・中断時に Markdown 引き継ぎを書き、次回再開用パスを残すスキル。
  「引き継ぎして」「セッション終了」「続きは次回」「handoff」「作業を保存」
  「続きから」「引き継ぎを読んで」「@...SESSION...md から」で使用。
  ルール改修専用トラック（RULE_IMPROVEMENT_HANDOFF 更新のみ）には使わない。
---

# Session Handoff

セッションの状態を **ファイルに書き出し**、次回エージェントがチャット履歴なしで再開できるようにする。1 セッション = 1 新規 Markdown。恒久方針は **`handoffs/{project}/HANDOFF.md`** に集約する。

## 依存

- 配置・命名・整理 SSOT → [references/routing.md](references/routing.md)
- セッション MD の見出し・必須項目 → [references/template.md](references/template.md)
- Git 操作方針 → `c:/yk-skill/rule/10_meta/GIT_WORKFLOW_RULES.md`（commit はユーザー明示までしない）

## 使わない場面

| 依頼 | 正しい扱い |
|------|------------|
| `RULE_IMPROVEMENT_HANDOFF.md` の更新だけ | そのファイルの手順に従う（本スキル非使用） |
| rule 構造の P1〜P7 バックログ | 同上 · 別トラック |
| 122KB 級の単一 HANDOFF を毎回上書き | 禁止 — セッション MD を新規 Write |

## 終了時（Write · Agent モード必須）

1. [references/routing.md](references/routing.md) を Read
2. プロジェクト slug が不明ならユーザーに確認（例: `workspace-layout`）
3. [references/template.md](references/template.md) を Read
4. セッション MD を **新規 Write**（`handoffs/{project}/{YYYY-MM-DD}_{slug}.md` · 上書き禁止）
5. テンプレの全見出しを埋める（空欄・`TBD` 禁止）
6. `handoffs/{project}/HANDOFF.md` の **「最新セッション」1 行**（と必要なら §6）だけ更新
7. 本セッションで触った **各 Git ルート**で `git status` を実行し、要約表をセッション MD に記載
8. **資料整理** — [routing.md §資料整理](references/routing.md) に従い、完了済み・重複ファイルを削除または `archive/` へ移動。実施内容をセッション MD §1-3 に記録
9. ユーザーに保存パスと、再開用 `@` 依頼文を提示

**禁止:** `git commit` / `git push`（ユーザーが明示するまで）· rule / SKILL 全文の貼り付け · PRD の丸ごと複製

## 再開時（Read）

1. `handoffs/{project}/HANDOFF.md` の「最新セッション」リンクを Read
2. セッション MD の **「次回の最初の 1 件」** だけを実行（HANDOFF のロードマップ全体には広げない）
3. ユーザーが「一つずつ」「順番に」と言っているときは **1 タスクで止め**、次に進む前に確認する

## 任意（セッション終了時）

- 90 日超 · 最新でないセッション MD → [routing.md §アーカイブ](references/routing.md)
- マイルストーン完了時、ユーザーに「引き継ぎしますか？」と**提案**する（強制しない）

## スキル改善時

`creating-skills` の Step 0〜7 と `c:/yk-skill/rule/10_meta/SKILL_AUTHORING_RULES.md` に従う。テンプレ変更は `references/template.md` のみ（`yk-memo` へ同期コピーしない）。
