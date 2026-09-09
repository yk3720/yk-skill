# yk-skill/rule 改善プロジェクト — 続き用引き継ぎ

> **AI 向け:** 新チャットで本ファイルを **最初に Read** し、§「再開手順」に従う。ユーザーは「`RULE_IMPROVEMENT_HANDOFF` の続きから」と言えばよい。

| 項目 | 値 |
|------|-----|
| **状態** | Phase 2 は**保留**（P16 まで完了 · 2026-06-27）。以後は単発の doc-sync / リンク修正のみ。**次セッションの実作業: B5（WARN 12本の仕分け）+ 行数ドリフト防止 M1**（いずれも方針確定済み・下記） |
| **直近セッション** | 2026-09-09（2回目）— **調査・方針確定のみ・実装なし**。監査再実行で `PLAYWRIGHT_RULES` 327 / `REACTFLOW_RULES` 337 を実測 → 前回記録「約290 / 約330」は**目算誤り**、git 履歴上 **リバウンドではなく分割が 250 に届かず中途停止**と判明。行数ドリフト防止策をサブエージェントでレビュー → M1 として確定。口調: frieza（ユーザー指示「フリーザの口調で」· 本セッション内で解除なし） |
| **1回前セッション** | 2026-09-09（1回目）— リンク切れ 8 件修正 · APP_PROJECT §13 末尾移動 + No 25 へ昇格ルール一本化 · A11Y_ROADMAP/PLAYBOOK 重複リンク化 · manifest 34 本同期 · 入口 3 doc 日付同期 |
| **リポジトリ** | `c:/yk-skill`（主）· 参照更新済み: `5.Python` · `yk-memo` 一部 · `workspace-ui-kit` |
| **入口 SSOT** | `c:/yk-skill/rule/RULE_INDEX.md` |
| **対話の経緯** | ルール矛盾チェック → Web調査 → 多視点レビュー → 対話で1件ずつ決定 → 実装 |
| **会話 transcript** | `C:\Users\ykoba\.cursor\projects\c-yk-memo\agent-transcripts\46267dcc-f9ea-4ac1-824c-3bb349c0882a\46267dcc-f9ea-4ac1-824c-3bb349c0882a.jsonl`（詳細な議論・却下案はここを検索） |

---

## 再開手順（エージェント用）

1. **Read** `c:/yk-skill/rule/RULE_INDEX.md`（**[クイック入口](RULE_INDEX.md#タスク別クイック入口)** → Governance・カタログ）→ 手順が要るときのみ `RULE_ROUTING_PLAYBOOK.md`
2. **Read** 本ファイル（未着手バックログ）
3. ユーザーに **次の1件** を確認するか、下表 **推奨順の先頭** から着手する
4. 各項目は **対話で1件ずつ** 方針確定 → 実装 → 本ファイルの該当行を `done` に更新
5. **リビジョン保護:** `5.Python` の `*revNNN*` ファイルは上書き禁止（`revision-protection.mdc`）。ルール本文の rev 番号付き KB は同様の精神で新 rev のみ積層
6. **コミット / push:** [`10_meta/GIT_WORKFLOW_RULES.md`](10_meta/GIT_WORKFLOW_RULES.md) — ユーザー明示時のみ

**依頼文の例（ユーザー）**

```text
@c:/yk-skill/rule/RULE_IMPROVEMENT_HANDOFF.md の続きから。
次はバックログ P1（横断 Git SSOT）を進めてください。
```

---

## 完了済み（再実装不要）

| ID | 内容 | 主な成果物 |
|----|------|------------|
| **G1** | Governance（7段優先順位） | `RULE_INDEX.md` 先頭 § Governance |
| **G2** | 帯フォルダ + カタログ No（v1） | `10_meta/` … `60_tooling/` · 直下スタブ（移行期） |
| **G3** | `DESIGN` → `GAS_REPORT_DESIGN` 整理 | `50_gas_html_test/GAS_REPORT_DESIGN_RULES.md` · ui-kit 読み順から除外 |
| **G4** | PYTHON §6 ↔ ROUTER の SSOT 一本化 | `40_python/PYTHON_RULES.md` §6 · `references/ROUTER.md` §5・§11 |
| **G5** | Light tier の Ref Plan 簡略化 | `SKILL.md` Step 0.1 · `ROUTER.md` · `PYTHON_RULES` §0/§6/§8 · `PROGRESSIVE` §4 · `python-dev-entry.mdc` |
| **G6** | 参照パス一括更新（Phase 1） | Python スキル · 図解3スキル · `5.Python/入口.md` · `workspace-ui-kit/CLAUDE.md` · yk-memo 図解関連メモ |
| **P1** | 横断 Git SSOT | `10_meta/GIT_WORKFLOW_RULES.md`（No 14）· `RULE_INDEX` · `PYTHON_RULES` §9 リンク化 · PLAYWRIGHT / using-playwright / Rules_2 重複削減 |
| **P2** | 横断 Secrets Hygiene | `10_meta/SECRETS_HYGIENE_RULES.md`（No 15）· GIT_WORKFLOW §2 リンク化 · GAS / Vercel / PYTHON / PLAYWRIGHT · 図解3スキル · FB README |
| **P3** | `GAS_RULES` ALLOWALL 正例修正 | デフォルト正例は `setXFrameOptionsMode` 省略 · 埋め込み時のみ ALLOWALL 分岐 · 悪い例を明示 |
| **P4** | `PLAYWRIGHT_RULES` waitForTimeout 整理 | §2-2 を anti-pattern 化 · §4-1 `getContentFrame` を `expect` + `toPass` に置換 |
| **P5** | `workspace-dev-entry.mdc` | `workspace-ui-kit/.cursor/rules/` · glob `app`/`components`/`lib` · `RULE_INDEX` · `CLAUDE.md` |
| **P6** | 移行スタブ削除 | 再スキャン後 17 スタブ削除 · `RULE_INDEX` 更新 |
| **P7** | `Rules_1.md` Superseded バナー | 目立つボックス · `入口.md` 導線強化 |
| **P10** | Mermaid PROGRESSIVE 完遂 | `creating-mermaid-yk` · `mermaid-dev-entry.mdc` · `MERMAID_RULES` · INDEX status `active` |
| **P12** | RULE_INDEX Status 定義 | `RULE_INDEX.md` § Status 列（エージェント向け） |
| **I1** | RULE_INDEX P0 整備 | 目次 · クイック入口 · 誤ルーティング早見表 · カタログ No 昇順 · No 13/50 帯注記 |
| **I2** | 読む順序の外出し | `RULE_ROUTING_PLAYBOOK.md` 新設 · INDEX はリンクのみ · REACTFLOW 参照更新 |
| **P8** | yk-memo 旧パス棚卸し | 講座4件: `DESIGN_RULES` 廃止 · 帯パス · `RULE_ROUTING_PLAYBOOK` 追記 |
| **I3** | リポジトリマップ後置 | INDEX 先頭付近に要約 · 詳細マップは末尾 |
| **P11** | 図モダリティ横断リンク | `MERMAID_RULES` §1.5 ↔ reactflow/mermaid README · アンカー · INDEX/PLAYBOOK |
| **P13** | Mermaid §11 フィードバック | 構文表 + エージェント運用（Ref Plan · 方式境界 · mmdc/Shell） |
| **P9** | load-manifest 試作 | `rule/load-manifest.yaml` 22 本 · INDEX Phase 2 節更新 |
| **P14b** | ルール行数監査スクリプト | `yk-tool/scripts/audit-rule-line-counts.ps1` · `catalog.yaml` · `scripts/README.md` |
| **P14** | L1 肥大化分割（REACTFLOW） | `REACTFLOW_RULES.md` 662→328行 · §5.6 → `35_reactflow/references/` 3 本 · ROUTER Standard を索引+tag 読みに変更 |
| **P14c** | L1 肥大化分割（PLAYWRIGHT） | `PLAYWRIGHT_RULES.md` 556→427行 · §12-13 → `references/` 2 本 · `using-playwright/references/ROUTER.md` 新設 |
| **P14d** | L1 肥大化分割（SUPABASE · GAS） | `SUPABASE_RULES.md` 500→192行 · `GAS_RULES.md` 428→233行 · 各 `references/` 3 本 |
| **DocSync** | rule 横断矛盾修正（C-01〜C-06） | `docs/` 統一 · AGENT_SHELL Phase B · manifest 32 本 · WORKSPACE DESIGN 表記 · INDEX 行数目安 |
| **P14e** | L1 肥大化分割（SHADCN · SKILL_AUTHORING） | `SHADCN_UI` 353→186行 · `SHADCN_*` references 4 本 · `SKILL_AUTHORING` 351→198行 · `SKILL_AUTHORING_*` references 4 本 |
| **P14f** | L1 肥大化分割（PYTHON） | `PYTHON_RULES.md` 451行から旧 §12–§14 を `40_python/references/` 3 本へ。ROUTER §2.1。distilling Step 3 を L3 追記に変更 |
| **P15** | Supabase PROGRESSIVE 完遂 | `creating-supabase-yk` · `supabase-dev-entry.mdc` · `SUPABASE_RULES` status `active` · INDEX · PLAYBOOK · manifest · SKILL_CATALOG |
| **P16** | Tauri 統合方針決定 | 当面統合しない · INDEX「未登録ドメイン」· `tauri-practice/HANDOFF` §6 · yk-memo INDEX 注記 · playwright `.mdc` 同期 |
| **Hooks** | yk-skill Cursor `preToolUse` / `postToolUse` ゲート | `yk-skill/.cursor/hooks.json` — L1 500行超と rule .md の Delete / 壊滅縮小を拒否 · 編集後に行数を注入。INDEX §新規追加手順 · `QUALITY_GATE_RULES` §8 · `SKILL_AUTHORING` 末尾 |
| **2026-09-09a** | 単発 doc-sync（Phase 2 外） | リンク切れ 8 · APP_PROJECT §13 移動/一本化（B1·B2）· A11Y_ROADMAP §6-2 · PLAYBOOK 更新節（B6·B7）· manifest 34 本 · 入口 3 doc 日付 · C1（AGENTS.md 正本の判定表）· C2（diagram-manager = `diagram-manager-web` を INDEX/PLAYBOOK/WORKSPACE_RULES 同期） |
| **2026-09-09b** | L1 肥大化分割（B3·B4） | `REACTFLOW_RULES` 417→約330 · 新 `references/REACTFLOW_PANELS.md`（旧 §5-P〜§5-S ＋ §5.6-10）· ROUTER `persist` 追記。`PLAYWRIGHT_RULES` 430→約290 · 新 `references/PLAYWRIGHT_GAS.md`（旧 §4·§8·§9·§11 GAS 分）· using-playwright / designing ROUTER・SKILL の `§1–11` 参照を `§1–7 + PLAYWRIGHT_GAS.md` に更新 |

### 採用済みアーキテクチャ決定（再議論しない）

- **入口:** `rule/` 直下は `RULE_INDEX.md` · `RULE_ROUTING_PLAYBOOK.md` · `RULE_IMPROVEMENT_HANDOFF.md`（**移行スタブは 2026-05-23 削除済み**）。索引＝WHAT/WHEN · プレイブック＝HOW · L1 SSOT は帯フォルダ内
- **命名:** ファイル名 `{TOPIC}_RULES.md`（番号なし）。論理順は `RULE_INDEX` の **No 列**
- **帯:** 10刻み（`10_meta` … `60_tooling`）。`load-manifest.yaml` 試作運用中（34 本 · No 00 除く · INDEX と人手同期）
- **L1 500行ゲート:** yk-skill Cursor `preToolUse` が L1 500行超・rule .md の Delete / 壊滅縮小を拒否（`postToolUse` が行数注入）。監査は `audit-rule-line-counts.ps1`（WARN 250 / FAIL 500）
- **企画 vs 実装:** 実装 SSOT は `yk-skill/rule`（Governance 段階7で yk-memo は参考のみ）
- **Light Ref Plan:** `tier` + `load` のみ。迷ったら **Standard**
- **ROUTER:** tier/tag/K-ID 表の SSOT は `references/ROUTER.md` のみ
- **Git SSOT:** `10_meta/GIT_WORKFLOW_RULES.md` — 方針のみ。push / commit はユーザー明示時。メッセージは直近 `git log` に合わせる。実行手順は User Rules
- **Secrets SSOT:** `10_meta/SECRETS_HYGIENE_RULES.md` — チェックリスト + 禁止パターン。チャットへの値貼付は **原則禁止（例外なし）**。実装手順は各ドメイン rule
- **Product Spec（独立リポ）:** `{app}/docs/` + `AGENTS.md`（`specs/` は廃止 · 2026-06-23 移行）
- **Web L0 入口:** `workspace-ui-kit/.cursor/rules/workspace-dev-entry.mdc` — glob `app` · `components` · `lib` の `*.{ts,tsx}`
- **行数の記録（2026-09-09 2回目 · M1）:** 絶対行数は散文（`RULE_IMPROVEMENT_HANDOFF` · `RULE_INDEX`）に書かない。必要時は `audit-rule-line-counts.ps1` を実行し機械出力を正とする。分割・監査の記録は質的事実のみ（「§X を references へ」「まだ WARN」等）。目算値の凍結が「約290」誤記の原因

### 帯フォルダ一覧（SSOT パス）

| 帯 | パス |
|----|------|
| 入口 | `rule/RULE_INDEX.md` · `rule/RULE_ROUTING_PLAYBOOK.md` |
| 10_meta | `PROGRESSIVE` · `SKILL_AUTHORING` · `AI_DRIVEN` · `GIT_WORKFLOW` · `SECRETS_HYGIENE` · `COMMUNICATION` |
| 15_project_mgmt | `APP_PROJECT` · `YK_APPLICATION` · `PROJECT_DOCUMENT` |
| 20_web_workspace | `WORKSPACE_RULES.md` · `DIAGRAM_MANAGER_WORKSPACE_RULES.md` |
| 25_design_ux | `VISUAL_DESIGN` · `USABILITY` · `A11Y_ROADMAP` · `A11Y` |
| 30_web_stack | `NEXTJS` · `SHADCN_UI` · `TAILWINDCSS` · `VERCEL` · `REACT` · `SUPABASE` |
| 35_reactflow | `REACTFLOW_RULES.md` |
| 40_python | `PYTHON_RULES.md` |
| 45_mermaid | `MERMAID_RULES.md`（`active`） |
| 50_gas_html_test | `GAS` · `GAS_REPORT_DESIGN` · `PLAYWRIGHT` · `POWERSHELL_HTML`（物理名レガシー · No 51–54） |
| 60_tooling | `CURSOR_RULES` · `AGENT_SHELL` · `QUALITY_GATE` · `WORKSPACE_SCRIPTS` |

### P6 スタブ削除（2026-05-23 実施）

`yk-skill` · `yk-memo` · `5.Python` · `Users\ykoba\src` で旧フラットパス `yk-skill/rule/{NAME}_RULES.md` を再スキャン → **参照 0件**（HANDOFF 内の rg 例示のみ）→ 直下スタブ **17 件削除**。

---

## 未着手バックログ

**優先:** 下記「周辺」または新規ルール追加時の manifest 同期。

| ID | 優先 | タイトル | 概要・受け入れ基準 | 主に触るファイル |
|----|------|----------|-------------------|------------------|
| **M1** | 高 | 行数ドリフト防止 | サブエージェントレビュー済み（2026-09-09 2回目）。B5 と同時可。**今やる:** ①散文に絶対行数を書かない+誤記訂正 · ★warn-only grep バックストップ · ④Claude Code フック parity（CC 形状アダプタ新規）。**据え置き:** ③縮小版（check-and-fail のみ）· ⑤=P9b が supersede。**却下:** ②コミット生成スナップショット。詳細 → 下記 §M1 詳細 | `.claude/settings.json`（新規）· `.cursor/hooks/` · `RULE_INDEX.md` · `.githooks/pre-commit`（据え置き分） |
| **P9b** | 予約 | manifest 本格運用 | tag 検証需要時 · `route_refs.py` / CI 連携（PROGRESSIVE §7） | `load-manifest.yaml` |

### 当初レビューで言及・未タスク化した周辺

- ~~ルール全文の **再矛盾チェック**~~ — 2026-06-27（doc-sync C-01〜C-06）· **2026-09-09 再実施**（meta/design/project 帯 + 入口 3 doc + 肥大 L1 2 本）
- ~~**サブエージェント多視点レビュー**の再実施~~ — **2026-05-24 実施済**（監査ターン）
- `flowchart-studio/` 等、今回スコープ外リポジトリのルールリンク
- **2026-09-09 監査の残タスク（未着手）:**
  - **B5 = WARN 12 本の仕分け（方針: 実務的トリアージで確定）** — 監査実測（2026-09-09 2回目）: `5_writing/references/WRITING_RULES_CONTENT` 473 / `5_writing/references/WRITING_RULES_FORMAT` 383 / `PROJECT_DOCUMENT_RULES` 373 / `REACTFLOW_RULES` 337 / `PLAYWRIGHT_RULES` 327 / `RULE_INDEX` 325 / `GAS_REPORT_DESIGN_RULES` 317 / `VERCEL_RULES` 307 / `REACT_RULES` 299 / `A11Y_ROADMAP` 293 / `MERMAID_RULES` 287 / `RULE_ROUTING_PLAYBOOK` 270。**リバウンドは無し**（PLAYWRIGHT/REACTFLOW は B3/B4 分割が 250 に届かず中途停止しただけ · HEAD=`0b079ff` 以降未編集を git で確認）。**やること:** 真の肥大だけ分割 → `WRITING_RULES_CONTENT`（500 目前・最優先）· `PROJECT_DOCUMENT §12/§15` · `VERCEL §6-1 ダッシュボード画面` · `REACT §3-1 パターン補足`(138行) · `PLAYWRIGHT §10/§11`。残りは各ファイル冒頭 or 台帳に「検分済み・WARN 許容」1行を明記し再 litigate を防ぐ。索引類（`RULE_INDEX` · `RULE_ROUTING_PLAYBOOK`）と `A11Y_ROADMAP`（完了で自然縮小）は対象外。**「対話で1件ずつ」**厳守
  - No 22 DIAGRAM_MANAGER を `active` のまま置くか deprecate するかの最終判断
  - 未スキャン帯（30_web_stack 本体 / 40_python / 45_mermaid / GAS 系 51-52-54）の矛盾チェック
  - **stale 索引の修正（B5 と同時に）:** §帯フォルダ一覧に `5_writing/` 帯（`WRITING_RULES` + references 2 本）と `40_python/FASTAPI_RULES.md` が未記載
- **2026-09-09 で処理済み:** C1（AGENTS.md 正本の判定表 · APP_PROJECT §5）· C2（diagram-manager = `diagram-manager-web`）· B3（REACTFLOW_PANELS.md）· B4（PLAYWRIGHT_GAS.md）

### M1 詳細（行数ドリフト防止 · 2026-09-09 2回目にサブエージェントレビューで確定）

**背景:** 前回セッションが引き継ぎに「`PLAYWRIGHT_RULES` 430→約290」と目算値を凍結 → 実測 327。根本原因は「絶対行数を散文に手打ちし機械検証しない」こと。既存防御は `audit-rule-line-counts.ps1`（測定エンジン）＋ Cursor pre/post フックのみで、**Cursor 以外（この Claude Code CLI 含む）では無反応**。git フック無し・CI 無し。`core.hooksPath` はこのマシンで未設定。

| # | 判定 | 内容 |
|---|------|------|
| ① | **今やる** | `RULE_IMPROVEMENT_HANDOFF` / `RULE_INDEX` は行数の絶対値を書かず質的事実のみ。既存の誤記（約290/約330）は本セッションで訂正済み。RULE_INDEX の該当箇所も次セッションで確認・「スクリプト実行」1行に置換 |
| ★ | **今やる（新規）** | **warn-only grep バックストップ** — ステージ差分の `RULE_IMPROVEMENT_HANDOFF.md` / `RULE_INDEX.md` を `\d+\s*行` や `\d+\s*[→⇒]\s*(約\s*)?\d+` × ファイル名トークンで検査し**警告のみ**（ブロックしない）。誤検出源が多い（"No 25" · "34 本" · 日付 · "§13"）ので調整必須。~20行。今回のバグ種を実際に捕まえる唯一の機構 |
| ④ | **今やる（① の隣に格上げ）** | Claude Code `PreToolUse`（L1 500 ブロック）＋ `PostToolUse`（行数注入）。**既存 Cursor .ps1 は流用不可** — CC はペイロード形状が別（`tool_name` / `tool_input.file_path` / Write は `content` · Edit は `old_string`+`new_string` / ブロックは exit 2 か `hookSpecificOutput` deny / 注入は `hookSpecificOutput.additionalContext`）。ツールは `Edit`/`Write`/`MultiEdit`（`Delete` 無し → 削除ゲートは対象外）。`Edit` は全文を持たないのでディスクから読んで置換適用。Windows は `command` が `cmd.exe` 経由 → `powershell -NoProfile -ExecutionPolicy Bypass -File "<abs or $CLAUDE_PROJECT_DIR>"` を明示。`yk-skill/.claude/settings.json` は未存在なので新規作成 |
| ③ | **据え置き（縮小）** | git `pre-commit`。**`-FailOnError` の 500 ブロックのみ・check-and-fail**（`git add` 禁止・生成ファイル再生成禁止 — フックからインデックスを変えると partial-commit 不整合 · `--amend`/rebase 破壊 · `--no-verify` で嘘ファイルが残る）。`core.hooksPath` 配線＋ per-clone setup 手順化が前提。それが無いなら「advisory」と割り切る |
| ⑤ | **据え置き（= P9b）** | CI（GitHub Actions で `audit-rule-line-counts.ps1 -FailOnError`）。エディタ非依存・`--no-verify` 不可・ローカル導入不要で **③ を supersede**。現状 `main` へ直コミット運用のため未着手。PR ワークフロー導入時は ③ の機構を飛ばして CI 直行 |
| ② | **却下** | コミットされる生成スナップショット（`rule/_generated/LINE_AUDIT.md` 等）。diff 汚染 + staleness-lie（`--no-verify` で嘘化）+ 手コピーで①のリスク再導入。RULE_INDEX に「`audit-rule-line-counts.ps1` を実行」の 1 行で代替。`-Markdown` 出力モードは ⑤ が要求したときだけ追加 |

**まだ捕まえられない drift（許容）:** フック未配線のエディタ（vim · `sed` · GitHub Web 編集）· `--no-verify` · `LINE_AUDIT.md` から手コピー（②却下で回避）· サイズOKだが内容が誤り（size ≠ quality）。

---

## Python 作業時のクイック参照（変更なし）

1. `40_python/PYTHON_RULES.md`
2. `creating-pythoncode-yk/SKILL.md`
3. `references/ROUTER.md`
4. Ref Plan → 列挙 refs のみ Read（Light / Standard は G5 参照）
5. `5.Python` では `python-dev-entry.mdc`（glob `**/*.py`）

スキルパス: `c:/yk-skill/.claude/skills/creating-pythoncode-yk/`

---

## Web（workspace-ui-kit）作業時

1. `20_web_workspace/WORKSPACE_RULES.md`
2. ドメイン（例: `DIAGRAM_MANAGER_WORKSPACE_RULES.md`）
3. `30_web_stack/`（SHADCN · TAILWIND · NEXTJS）— **GAS_REPORT_DESIGN は読まない**
4. 企画は `yk-memo`（参考のみ）

---

## 関連プロジェクト（別トラック）

| 項目 | パス |
|------|------|
| **4リポ分割（yk-tool / yk-document）** | `c:/yk-memo/handoffs/workspace-layout/HANDOFF.md` — 3 アプリ yk-tool へ移動済み（2026-05-23）· commit 未 |

---

## 本ファイルのメンテナンス

- タスク完了時: 該当行を **完了済み表へ移動**し、バックログから削除
- 新規決定時: §「採用済みアーキテクチャ決定」に1行追加
- `RULE_INDEX.md` の最終更新日は構造変更時のみ更新（本ファイルの日付と揃える）

**最終更新:** 2026-09-09（2回目 — B5 前提調査 · リバウンド否定（実測 327/337）· 行数ドリフト防止 M1 をサブエージェントレビューで確定 · stale 索引摘出 · 誤記「約290/約330」訂正。実装は次セッション）
