---
name: handoff-session-work
description: >
  yk-memo/handoffs のセッション引き継ぎ（終了・再開・確認・整理）。
  終了: 「引き継ぎして」「セッション終了」「作業を保存」「引き継ぎ終了」
  再開: 「続きから」「引き継ぎを読んで」「@...SESSION...md」— §4の1件のみ実行
  確認: 「引き継ぎ内容を確認」「handoffsを確認」「引き継ぎの状態を教えて」— フォルダ俯瞰のみ・実行しない
  整理: 「引き継ぎ整理」「整理して」「archiveして」
  RULE_IMPROVEMENT_HANDOFF 更新のみには使わない。commit は committing-with-git-yk。
---

# Session Handoff

`c:/yk-memo/handoffs/` のセッション MD とプロジェクト HANDOFF を扱う。1 セッション = 1 新規 Markdown。恒久方針は `handoffs/{project}/HANDOFF.md`。

**応答の先頭ラベル:** `[終了]` `[再開]` `[確認]` `[整理]` のいずれかを付ける。

## モード選択（先に 1 つだけ）

| モード | 発火例 | 副作用 |
|--------|--------|--------|
| **終了** | 引き継ぎして · セッション終了 · 作業を保存 · 引き継ぎ終了 | Write · HANDOFF 更新 · **superseded を archive（必須）** |
| **再開** | 続きから · 引き継ぎを読んで · `@...md` | §4 の **1 件だけ**実行 |
| **確認** | 引き継ぎ内容を確認 · handoffs を確認 · 一覧 · 状態を教えて | **Read のみ**（移動・削除・§4 実行なし） |
| **整理** | 整理して · archive して · 片付けて | 移動 · 削除 · README 更新（新規セッション MD は不要なら Write しない） |

曖昧なとき（「引き継ぎを見て」等）は **1 問だけ**: 確認だけ / 続きから作業 / 整理まで。

## 依存

| 用途 | 参照 |
|------|------|
| 配置・命名・終了ゲート・アーカイブ | [references/routing.md](references/routing.md) |
| セッション MD 見出し | [references/template.md](references/template.md) |
| 確認モードのチェックリスト | [references/folder-audit.md](references/folder-audit.md) |
| Git | `c:/yk-skill/rule/10_meta/GIT_WORKFLOW_RULES.md` |
| commit | `committing-with-git-yk`（ユーザー明示まで本スキルは commit しない） |
| スキル台帳更新 | `managing-skills-yk`（本スキルとは別） |

## 使わない場面

| 依頼 | 正しい扱い |
|------|------------|
| `RULE_IMPROVEMENT_HANDOFF.md` の更新だけ | そのファイルの手順（本スキル非使用） |
| rule 構造の P1〜P7 バックログ | 同上 · 別トラック |
| 122KB 級の単一 HANDOFF を毎回上書き | 禁止 — セッション MD を新規 Write |
| ユーザーが **コミットして** と明示 | `committing-with-git-yk` |

---

## 終了（Write · Agent モード必須）

[routing.md §引き継ぎ終了](references/routing.md) の終了ゲートに従う。

1. [references/routing.md](references/routing.md) を Read
2. プロジェクト slug が不明ならユーザーに確認
3. [references/template.md](references/template.md) を Read
4. セッション MD を **新規 Write**（上書き禁止）
5. テンプレの全見出しを埋める（空欄・`TBD` 禁止）
6. `HANDOFF.md` の **「最新セッション」1 行**（と必要なら §6）だけ更新
7. 触った各 Git ルートで `git status` → セッション MD §2 に記載
8. **資料整理** — [routing.md §資料整理](references/routing.md)：完了済み・重複の削除または移行
9. **アーカイブ（必須）** — HANDOFF が指さない **superseded** セッション MD を `archive/{YYYY}/` へ移動（同日の最新以外を含む）。移動一覧を §1-3 に記録
10. `{project}/README.md` の「最新セッション」行を HANDOFF と一致させる
11. ユーザーに保存パスと再開用 `@` 依頼文を提示

**禁止:** `git commit` / `git push` · rule / SKILL 全文の貼り付け · 最新セッション MD の削除

---

## 再開（Read · Execute）

1. `handoffs/{project}/HANDOFF.md` の「最新セッション」リンクを Read（正本 → [routing.md §最新セッション](references/routing.md)）
2. セッション MD の **「次回の最初の 1 件」** だけを実行（HANDOFF §6 ロードマップ全体には広げない）
3. 「一つずつ」「順番に」のときは **1 タスクで止め**、次に進む前に確認

**禁止:** archive · 削除 · 新規セッション Write · 確認モードの代行

---

## 確認（Read のみ）

[references/folder-audit.md](references/folder-audit.md) に従う。

1. 対象を特定: `handoffs/` 全体、または `handoffs/{project}/`（ユーザー指定 · `@` パス）
2. 列挙: HANDOFF · ルート直下のセッション MD · `archive/` · README
3. 整合: HANDOFF「最新」= `{project}/README.md`「最新」= ルートに残す 1 本
4. [folder-audit.md](references/folder-audit.md) の報告テンプレで出力
5. 末尾に **提案のみ**（実行しない）: 続きから / 整理して / このまま終了

**禁止:** ファイル移動 · 削除 · §4 実行 · GO と言って作業開始

---

## 整理（Tidy）

新規セッション MD が不要なら Write しない。[routing.md §資料整理](references/routing.md) · [§アーカイブ](references/routing.md) に従う。

1. [references/routing.md](references/routing.md) を Read
2. 対象 `{project}` を特定（未指定なら確認モード相当の一覧を出してから 1 プロジェクトに絞る）
3. **移動・削除候補**を表で提示（移動元 → 行き先）
4. 曖昧な操作（ファイル削除 · stub 削除 · 90 日超一括）は **ユーザーの OK 後**に実行
5. **superseded の archive** はユーザーが「整理して」「全部」等と言ったら実行（終了モードで未実施の分を含む）
6. HANDOFF · README を更新 · 実施一覧を報告（セッション MD を新規した場合は §1-3 にも記録）

**禁止:** ユーザーの明示なしに `git commit` · 最新セッション MD の削除

---

## 任意

- マイルストーン完了時、「引き継ぎ終了しますか？」と**提案**（強制しない）
- 90 日超のセッション → `tidy` または終了時の整理で `archive/{YYYY}/` へ（[routing.md §アーカイブ](references/routing.md)）

## スキル改善時

`creating-skills` と `c:/yk-skill/rule/10_meta/SKILL_AUTHORING_RULES.md` に従う。テンプレ変更は `references/template.md` のみ（`yk-memo` へ同期コピーしない）。
