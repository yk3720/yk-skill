---
name: handoff-session-work
description: >
  yk-memo/handoffs のセッション引き継ぎ（終了・再開・確認・整理）。
  終了: 「引き継ぎして」「セッション終了」「作業を保存」「引き継ぎ終了」— **整理→archive 先（必須）** → 新規セッション MD → **commit+push（Phase C · 子スキル委譲）**
  再開: 「続きから」「引き継ぎを読んで」「@...SESSION...md」— §4の1件のみ実行
  確認: 「引き継ぎ内容を確認」「handoffsを確認」「引き継ぎの状態を教えて」— Tier-0 索引→指定時 Tier-1 詳細・実行しない
  整理: 「引き継ぎ整理」「handoffsを整理」「引き継ぎをarchive」「archiveして」（handoffs/引き継ぎの文脈）
  Do NOT use for 汎用の「整理して」「片付けて」のみ、RULE_IMPROVEMENT_HANDOFF 更新のみ、commit/push のみ（→ managing-git-yk）。
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

**複合発話**（例:「状態を確認して、必要なら整理して」）のときは、**先頭のモード（確認）だけ実行**し、結果を報告した上で後続モード（整理）に進むかを改めて確認する（1 発話内で確認→整理を自己判断で連続実行しない）。

**スキル選択:** 汎用の「整理して」「片付けて」単独では発火しない（引き継ぎ · handoffs · archive の文脈が必要）。

## 依存

| 用途 | 参照 |
|------|------|
| 配置・命名・終了ゲート・アーカイブ | [references/routing.md](references/routing.md) |
| セッション MD 見出し | [references/template.md](references/template.md) |
| 口調の引き継ぎ（書式・記録・適用の正本） | [routing.md §口調の引き継ぎ](references/routing.md) |
| 確認モードのチェックリスト | [references/folder-audit.md](references/folder-audit.md) |
| Git 方針 | `c:/yk-skill/rule/10_meta/GIT_WORKFLOW_RULES.md` |
| 終了時 Git | `managing-git-yk`（**終了モード Phase C** · **commit+push** · PR は含めない） |
| Phase C 手順 | [references/git-save.md](references/git-save.md) |
| スキル台帳更新 | `managing-skills-yk`（本スキルとは別） |

## 使わない場面

| 依頼 | 正しい扱い |
|------|------------|
| `RULE_IMPROVEMENT_HANDOFF.md` の更新だけ | そのファイルの手順（本スキル非使用） |
| rule 構造の P1〜P7 バックログ | 同上 · 別トラック |
| **コミットして** / **push して** のみ（引き継ぎ終了なし） | `managing-git-yk` |
| 引き継ぎ終了で **PR まで** | 終了モード完了後に PR 明示、または `managing-git-yk` の **pr** モード |

---

## 終了（Write · Agent モード必須）

実行手順（Phase A・B・B+ の番号付きステップ）は本章が正本。**Phase C（Git 保存）の逐条は `git-save.md` が正本** — 本章の Phase C は要約・禁止事項のみ。用語・ライフサイクル定義・「終了ゲートを満たさない操作」一覧は [routing.md §引き継ぎ終了](references/routing.md) を参照。

**鉄則: 整理してから終了。** 新規セッション MD の Write より **先に** Phase A（整理・アーカイブ）を完了する。Phase A を飛ばした終了は **無効**（要整理）。

**複数プロジェクトを同時に終了する場合:** 1 件ごとに Phase A→B→B+→C を完結させてから次のプロジェクトに着手する（複数プロジェクトの Phase A を先にまとめて行う等、並行させない）。

### Phase A — 整理（必須 · Write より先）

1. [references/routing.md](references/routing.md) を Read
1b. **差分確認（別PC対策 · 必須 · Write より先）** — 触る予定の各 Git ルート（実装リポ · `c:/yk-memo` · 必要なら `c:/yk-skill`）で `git fetch`。**behind があれば Phase B の Write 前に `git pull --rebase` で取り込む**（stale ツリー上にセッション MD を作らない）。衝突時はユーザーへ報告して止める
2. プロジェクト slug が不明ならユーザーに確認（停止文言の型 → [routing.md §停止文言](references/routing.md)）
3. `handoffs/{project}/` を Glob — ルート直下のセッション MD（`HANDOFF.md` · `README.md` · `archive/` を除く `*.md`）を列挙
4. **資料整理** — [routing.md §資料整理](references/routing.md)：完了済み・重複の削除または移行。**削除は候補を提示してユーザーの OK 後に実行**（Phase A 自体は必須でもノンストップにしない）
5. **アーカイブ（必須）** — 手順 3 で列挙した **ルート直下のセッション MD をすべて** `archive/{YYYY}/` へ移動（削除しない）。0 本ならスキップ可
6. `archive/{YYYY}/README.md` に移動したファイルを追記（あれば）
7. **Phase A 完了チェック** — ルート直下のセッション MD が **0 本**であること（移動漏れがあれば 5 に戻る）

### Phase B — 記録（整理のあと）

8. [references/template.md](references/template.md) を Read
9. セッション MD を **新規 Write**（上書き禁止 · 122KB 級の単一 HANDOFF を毎回上書きするような運用は禁止 — 恒久方針は `HANDOFF.md` に薄く保ち、本文は常にセッション MD 側に新規作成する · **秘密情報・PII の貼付禁止** → [template.md §記入ルール](references/template.md)）
10. テンプレの全見出しを埋める（空欄・`TBD` 禁止）。§1-3 に **Phase A の移動・削除一覧**を記録。先頭表 **「口調」** を記録（書式 → [routing.md §口調の引き継ぎ](references/routing.md)）
11. `HANDOFF.md` の **「最新セッション」1 行**を更新（§6 は次の 1 手・進捗状態が変わった場合のみ 1 行更新）
12. 触った各 Git ルートの変更 — **Glob/Read で把握**（**Phase B 単独の `git status` Shell 禁止** · hash は Phase C 完了報告へ）
13. `{project}/README.md` の「最新セッション」行を HANDOFF と一致させる
14. `handoffs/README.md` の当該 slug **1 行**を更新（状態 · 最新ファイル · ルート MD 本数 · 次の 1 手）— [routing.md §横断索引](references/routing.md)

### Phase B+ — 資料整合（必須 · Phase C の前）

15. **矛盾の持ち越し禁止** — `PROJECT_DOCUMENT_RULES` §9.1 · §9.2（ADR が Draft/実装前のときの追随 MD 二層注記漏れ = S8 も対象）
16. **`organizing-documents-yk` M1（Tier P）** — [reconcile.md](../organizing-documents-yk/references/reconcile.md) の **S1–S8** · H1（**S7・S8 は検出したら必ず同一ターンで修正** — reconcile.md 自身がそう定める）。セッション §1 で触った論点（機能名 · ADR · 作者データ等）を Grep し、追随 MD を HANDOFF と照合（**Tier P** は `organizing-documents-yk` 側の資料整合レベルを指す用語で、本スキルの確認モード `Tier-0`/`Tier-1` とは無関係。**reconcile.md 側の `S1`/`H1` 等のチェック ID も `organizing-documents-yk` 独自の名前空間 — 本スキル [folder-audit.md](references/folder-audit.md) の同名 `S1`/`H1` とは無関係の別チェック**）
17. **機械的矛盾は同一ターンで修正**（`現状とロードマップ` · `decision-log` 戦術/ADR索引 · ADR 状態行 · 触った方針/UI仕様 · `AGENTS.md`）
18. 修正一覧をセッション MD §1-3 に 1 行追記（`資料整合（Phase B+）:` …）
19. **スキップ不可** — WARN のみ残して Phase C に進めない（意図的バックログ行を除く）。**ユーザーが明示的に「警告は残したまま進めて」等と指示した場合のみ**、残存 WARN をセッション MD §3（未実施）に記録してから Phase C へ進んでよい

### Phase C — Git 保存（記録のあと · 必須）

**逐条手順（RUN 予算 · コマンド例 · 失敗時対応）は [git-save.md](references/git-save.md) が正本。** 以下は要約のみ:

20. **`git-save.md` を Read** → **`managing-git-yk` を Read** — Phase C は **commit+push** · **Bash 1 本/リポ**（add+commit+push · RUN 予算 = リポ数）。PowerShell HEREDOC **禁止**
21. **Post-C 専用 commit 禁止** — hash は完了報告（方式 A · マルチリポ時はこちらのみ）または push 前 amend（方式 B · 単一リポ限定 · [git-save.md §C-3](references/git-save.md)）
22. セッション MD §2 · 先頭表 `commit` — 方式 A なら「完了報告参照」でよい
23. ユーザーに保存パス · 再開 `@` · **Run 回数** · リポごと commit / push を提示

**禁止:** Phase A 前の Write · Phase B 前の commit/push · Phase B だけの git status Shell · Post-C 2 回目 push

---

## 再開（Read · Execute）

1. **プロジェクト slug** — ユーザー指定 · `@` パス · 単一進行中ならその slug。複数進行中・不明・指定 slug のフォルダが存在しない場合は、推測で読み替えず [routing.md §停止文言](references/routing.md) の型で確認して停止（索引が必要なら [folder-audit.md Tier-0](references/folder-audit.md)）
2. [routing.md §待機](references/routing.md) — ルート直下セッション **0 本** かつ HANDOFF 先頭表に **待機** → §4 は実行せず §6 の 1 行を報告して停止
3. `HANDOFF.md` — **先頭表のみ** Read（`| **最新セッション** |` · `| **状態** |`）。ユーザーが `@HANDOFF` 全文を指定したときのみ全文
3b. **検証駆動フェーズ** — HANDOFF §6 に「検証駆動」「§4 機械消化しない」等がある slug は **§6 が実行正本**。§4 は Read しない（履歴）。検証メモ・明示依頼がなければ §6 の 1 行を報告して停止
3c. **口調の引き継ぎ** — 最新セッション MD 先頭表の **「口調」** を Read し、[routing.md §口調の引き継ぎ](references/routing.md) のルールに従って適用する（待機・3b で停止する場合も切り替えは行う）
3d. **差分確認（別PC対策 · 必須）** — 対象プロジェクトの実装リポ（HANDOFF 先頭表の「実装」/「コード」パス）と `c:/yk-memo` で `git fetch`。ローカルが **behind** なら **§4 着手前にユーザーへ報告**し、`git pull --rebase` するか確認してから進む（SessionStart フック（定義 → `c:/yk-skill/rule/60_tooling/CLAUDE_HOOKS_RULES.md`）がカバーするのは `yk-memo` / `yk-skill` / `yk-tool` のみ。`yk-application/<slug>` は本ステップで見る）
4. 最新セッション MD — **§4 のみ**（Grep `## 4.` 〜 次の `## 5.` 手前、または Read の `offset/limit`）。`@セッション` 指定時は当該 MD の §4 のみ（HANDOFF 省略可）。**3b 該当時はスキップ**
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
2. 対象 `{project}` を特定（未指定 · 複数が同時に対象なら [folder-audit.md Tier-0](references/folder-audit.md) の索引を出し、[routing.md §停止文言](references/routing.md) の型で確認してから絞る）
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
