---
name: handoff-session-work
description: >
  yk-memo/handoffs のセッション引き継ぎ（終了・再開・確認・整理）。
  終了: 「引き継ぎして」「セッション終了」「作業を保存」「引き継ぎ終了」— **整理→archive 先（必須）** → 新規セッション MD → **commit+push（Phase C · 子スキル委譲）**
  再開: 「続きから」「引き継ぎを読んで」「@...SESSION...md」— §4の1件のみ実行
  確認: 「引き継ぎ内容を確認」「handoffsを確認」「引き継ぎの状態を教えて」— Tier-0 索引→指定時 Tier-1 詳細・実行しない
  整理: 「引き継ぎ整理」「handoffsを整理」「引き継ぎをarchive」「archiveして」（handoffs/引き継ぎの文脈）
  Do NOT use for 汎用の「整理して」「片付けて」のみ、RULE_IMPROVEMENT_HANDOFF 更新のみ、commit/push のみ（→ committing-with-git-yk / pushing-and-pr-yk）。
---

# Session Handoff

`c:/yk-memo/handoffs/` のセッション MD とプロジェクト HANDOFF を扱う。1 セッション = 1 新規 Markdown。恒久方針は `handoffs/{project}/HANDOFF.md`。

**応答の先頭ラベル:** `[終了]` `[再開]` `[確認]` `[整理]` のいずれかを付ける。

## モード選択（先に 1 つだけ）

| モード | 発火例 | 副作用 |
|--------|--------|--------|
| **終了** | 引き継ぎして · セッション終了 · 作業を保存 · 引き継ぎ終了 | **整理→archive 先（必須）** · 新規セッション MD · HANDOFF 更新 · **commit+push（Phase C）** |
| **再開** | 続きから · 引き継ぎを読んで · `@...md` | §4 の **1 件だけ**実行 |
| **確認** | 引き継ぎ内容を確認 · handoffs を確認 · 一覧 · 状態を教えて | **Tier-0 索引**（全体）/ **Tier-1 詳細**（プロジェクト指定）· Read のみ |
| **整理** | 整理して · archive して · 片付けて | 移動 · 削除 · README 更新（新規セッション MD は不要なら Write しない） |

曖昧なとき（「引き継ぎを見て」等）は **1 問だけ**: 確認だけ / 続きから作業 / 整理まで。

**スキル選択:** 汎用の「整理して」「片付けて」単独では発火しない（引き継ぎ · handoffs · archive の文脈が必要）。

## 依存

| 用途 | 参照 |
|------|------|
| 配置・命名・終了ゲート・アーカイブ | [references/routing.md](references/routing.md) |
| セッション MD 見出し | [references/template.md](references/template.md) |
| 確認モードのチェックリスト | [references/folder-audit.md](references/folder-audit.md) |
| Git 方針 | `c:/yk-skill/rule/10_meta/GIT_WORKFLOW_RULES.md` |
| 終了時 commit | `committing-with-git-yk`（**終了モード Phase C** で Read して実行） |
| 終了時 push | `pushing-and-pr-yk`（**終了モード Phase C** · push のみ） |
| Phase C 手順 | [references/git-save.md](references/git-save.md) |
| スキル台帳更新 | `managing-skills-yk`（本スキルとは別） |

## 使わない場面

| 依頼 | 正しい扱い |
|------|------------|
| `RULE_IMPROVEMENT_HANDOFF.md` の更新だけ | そのファイルの手順（本スキル非使用） |
| rule 構造の P1〜P7 バックログ | 同上 · 別トラック |
| 122KB 級の単一 HANDOFF を毎回上書き | 禁止 — セッション MD を新規 Write |
| **コミットして** / **push して** のみ（引き継ぎ終了なし） | `committing-with-git-yk` / `pushing-and-pr-yk` |
| 引き継ぎ終了で **PR まで** | 終了モード完了後に PR 明示、または `pushing-and-pr-yk` |

---

## 終了（Write · Agent モード必須）

[routing.md §引き継ぎ終了](references/routing.md) の終了ゲートに従う。

**鉄則: 整理してから終了。** 新規セッション MD の Write より **先に** Phase A（整理・アーカイブ）を完了する。Phase A を飛ばした終了は **無効**（要整理）。

### Phase A — 整理（必須 · Write より先）

1. [references/routing.md](references/routing.md) を Read
2. プロジェクト slug が不明ならユーザーに確認
3. `handoffs/{project}/` を Glob — ルート直下のセッション MD（`HANDOFF.md` · `README.md` · `archive/` を除く `*.md`）を列挙
4. **資料整理** — [routing.md §資料整理](references/routing.md)：完了済み・重複の削除または移行
5. **アーカイブ（必須）** — 手順 3 で列挙した **ルート直下のセッション MD をすべて** `archive/{YYYY}/` へ移動（削除しない）。0 本ならスキップ可
6. `archive/{YYYY}/README.md` に移動したファイルを追記（あれば）
7. **Phase A 完了チェック** — ルート直下のセッション MD が **0 本**であること（移動漏れがあれば 5 に戻る）

### Phase B — 記録（整理のあと）

8. [references/template.md](references/template.md) を Read
9. セッション MD を **新規 Write**（上書き禁止）
10. テンプレの全見出しを埋める（空欄・`TBD` 禁止）。§1-3 に **Phase A の移動・削除一覧**を記録
11. `HANDOFF.md` の **「最新セッション」1 行**（と必要なら §6）だけ更新
12. 触った各 Git ルートで `git status` → セッション MD §2 に記載
13. `{project}/README.md` の「最新セッション」行を HANDOFF と一致させる
14. `handoffs/README.md` の当該 slug **1 行**を更新（状態 · 最新ファイル · ルート MD 本数 · 次の 1 手）— [routing.md §横断索引](references/routing.md)

### Phase C — Git 保存（記録のあと · 必須）

[routing.md §引き継ぎ終了](references/routing.md) · [git-save.md](references/git-save.md) に従う。

16. **`committing-with-git-yk` を Read** — 触った各 Git ルートで子スキル手順どおり commit（終了依頼 = 当ターンの commit 明示）
17. **`pushing-and-pr-yk` を Read** — commit 済みルートを push（**PR は含めない**）
18. セッション MD の先頭表 `commit` 行と §2 を **Post-C** で更新（hash · push 結果）
19. ユーザーに保存パス · 再開用 `@` 依頼文 · **リポごとの commit / push 結果**を提示

**禁止:** Phase A 前の新規 Write · Phase B 前の `git commit` / `git push` · 確認/整理モードでの commit/push · rule / SKILL 全文の貼り付け · 最新セッション MD の削除

---

## 再開（Read · Execute）

1. **プロジェクト slug** — ユーザー指定 · `@` パス · 単一進行中ならその slug。複数進行中または不明なら [folder-audit.md Tier-0](references/folder-audit.md) で索引を出し **1 問**（Glob + 各 HANDOFF 先頭表のみ · 根 README は補助）
2. [routing.md §待機](references/routing.md) — ルート直下セッション **0 本** かつ HANDOFF 先頭表に **待機** → §4 は実行せず §6 の 1 行を報告して停止
3. `HANDOFF.md` — **先頭表のみ** Read（`| **最新セッション** |` · `| **状態** |`）。ユーザーが `@HANDOFF` 全文を指定したときのみ全文
4. 最新セッション MD — **§4 のみ**（Grep `## 4.` 〜 次の `## 5.` 手前、または Read の `offset/limit`）。`@セッション` 指定時は当該 MD の §4 のみ（HANDOFF 省略可）
5. §4 の **1 件だけ**実行（HANDOFF §6 ロードマップ全体には広げない）
6. 「一つずつ」「順番に」のときは **1 タスクで止め**、次に進む前に確認

**禁止:** archive · 削除 · 新規セッション Write · 確認モードの代行 · 再開時の HANDOFF 全文 + セッション全文の常時 Read

---

## 確認（Read のみ）

[references/folder-audit.md](references/folder-audit.md) の **Tier** に従う。

1. **Tier を決める** — 全体・未指定 → **Tier-0**。プロジェクト指定 · 「詳しく」「整合」→ **Tier-1**
2. Tier-0: Glob `handoffs/*/HANDOFF.md` · 各 HANDOFF **先頭表のみ** · [folder-audit.md](references/folder-audit.md) Tier-0 テンプレ
3. Tier-1: 当該 `{project}/` で H1〜T2 · Tier-1 テンプレ（T1 は §4 中心でよい）
4. 末尾に **提案のみ**（実行しない）: 続きから（slug 指定）/ Tier-1 詳細 / 整理して

**RUN を減らす:** 本モードでは **Shell を使わない**（`git status` · `ls` · `Get-ChildItem` 等は出さない）。一覧は **Glob**、本文は **Read**（必要なら **Grep**）のみ。Git の未 commit 有無はユーザーが聞いたときだけ答える（そのときも Shell は 1 本にまとめるか、Read で足りる範囲に留める）。

**禁止:** ファイル移動 · 削除 · §4 実行 · GO と言って作業開始 · **確認専用ターンでの Shell 乱用**

---

## 整理（Tidy）

新規セッション MD が不要なら Write しない。[routing.md §資料整理](references/routing.md) · [§アーカイブ](references/routing.md) に従う。

1. [references/routing.md](references/routing.md) を Read
2. 対象 `{project}` を特定（未指定なら [folder-audit.md Tier-0](references/folder-audit.md) の索引を出してから 1 プロジェクトに絞る）
3. **移動・削除候補**を表で提示（移動元 → 行き先）
4. 曖昧な操作（ファイル削除 · stub 削除 · 90 日超一括）は **ユーザーの OK 後**に実行
5. **superseded の archive** — 「整理して」単独依頼時はここで実行。**終了**では Phase A で必ず先に実施済み（終了モードで Phase A を飛ばした漏れも救済）
6. HANDOFF · `{project}/README.md` · 触った場合は `handoffs/README.md` 当該行を更新 · 実施一覧を報告（セッション MD を新規した場合は §1-3 にも記録）

**禁止:** `git commit` / `git push`（整理モード）· 最新セッション MD の削除

---

## 任意

- マイルストーン完了時、「引き継ぎ終了しますか？」と**提案**（強制しない）
- 90 日超のセッション → `tidy` または終了時の整理で `archive/{YYYY}/` へ（[routing.md §アーカイブ](references/routing.md)）

## スキル改善時

`creating-skills` と `c:/yk-skill/rule/10_meta/SKILL_AUTHORING_RULES.md` に従う。テンプレ変更は `references/template.md` のみ（`yk-memo` へ同期コピーしない）。
