# yk-skill/rule — 読む順序プレイブック

**用途:** ドメイン別の **PROGRESSIVE 手順（HOW）**。索引は [RULE_INDEX.md](RULE_INDEX.md)（カタログ · クイック入口 · 誤ルーティング早見表）。

**いつ Read するか:** [RULE_INDEX — タスク別クイック入口](RULE_INDEX.md#タスク別クイック入口) で No と L1 を特定したあと、手順の詳細が必要なときだけ本ファイルを開く。**常時全読みしない**（`10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md` §3-4）。

**最終更新:** 2026-05-24（I2：INDEX から外出し）

**誤ルーティング:** [RULE_INDEX — 誤ルーティング早見表](RULE_INDEX.md#誤ルーティング早見表)

---

## 目次

| 節 | タスク |
|----|--------|
| [PROGRESSIVE 共通手順](#progressive-共通手順スキル付きドメイン) | L1 → SKILL → ROUTER → Ref Plan |
| [Python](#読む順序python-ツールを触るとき) | `.py` · `5.Python` |
| [Mermaid](#読む順序mermaid-図を書くとき) | `.mmd` |
| [React Client](#読む順序react-client-コンポーネントを触るとき) | components · Hooks · `app/` |
| [flowchart React Flow](#読む順序flowchart-web-reactflow--react-flow-を触るとき) | No 35 |
| [flowchart Mermaid プレビュー](#読む順序flowchart-web-mermaid--表--mermaid-プレビュー) | 表 → Mermaid プレビュー |
| [shadcn/ui](#読む順序shadcnui-を触るとき) | `components/ui` |
| [Vercel / デプロイ](#読む順序vercel--デプロイを触るとき) | deploy |
| [workspace-ui-kit](#読む順序workspace-ui-kit-を触るとき) | ui-kit |
| [Agent Shell](#読む順序agent-が-shell-を使うとき) | RUN 削減 |
| [Git](#読む順序git-操作をするとき) | commit / push |
| [Secrets](#読む順序資格情報トークンを扱うとき) | トークン · `.env` |
| [GAS / Playwright / HTML](#読む順序gas--playwright--大容量-html) | No 51–54 |
| [個人アプリ · 企画 · 再開](#読む順序個人アプリ新規企画フォルダ再開) | No 17 · handoffs · AGENTS.md |

---

## PROGRESSIVE 共通手順（スキル付きドメイン）

`active` なドメイン rule（No 31–36 · 41 · 45 等）の多くは次の型に従う。差分は各節に記載。

| 順 | 層 | 内容 |
|----|-----|------|
| 1 | **L1** | `rule/{帯}/{TOPIC}_RULES.md` — 要約 SSOT（毎回） |
| 2 | **L2** | `.claude/skills/{skill}/SKILL.md` — 手順 |
| 3 | **ROUTER** | `references/ROUTER.md` — tier / tag |
| 4 | **Ref Plan** | コード編集前にチャット出力（ROUTER §7） |
| 5 | **L3** | Ref Plan の `load` に列挙された `references/` のみ Read |

**Light tier:** `tier` + `load` の短形式 · **Standard 以上:** SKILL Step 0.1 のフル形式。

**新ドメイン設計:** `10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md` §10

---

## 読む順序（Python ツールを触るとき）

1. **`40_python/PYTHON_RULES.md`** — 要約 SSOT（毎回）
2. **スキル `creating-pythoncode-yk/SKILL.md`** — 手順
3. **`creating-pythoncode-yk/references/ROUTER.md`** — tier / tag
4. **Ref Plan 出力後** — `references/` の列挙ファイルのみ Read  
   - **Light**（局所修正）: `tier` + `load` の短形式 · **Standard 以上**: フル形式（SKILL Step 0.1）

`5.Python` で `.py` を触るときは `python-dev-entry.mdc` が自動適用される。

---

## 読む順序（Mermaid 図を書くとき）

1. **`45_mermaid/MERMAID_RULES.md`** — L1 SSOT（毎回）
2. **スキル `creating-mermaid-yk/SKILL.md`** — 手順
3. **`creating-mermaid-yk/references/ROUTER.md`** — tier / tag
4. **Ref Plan** — `.mmd` 編集前（ROUTER §7）
5. **表駆動フローが必要なら** → [flowchart React Flow](#読む順序flowchart-web-reactflow--react-flow-を触るとき)（Mermaid 比較版は ADR-010 · 併用 · 代替ではない）

`yk-skill` · `yk-memo` で `.mmd` を触るときは `mermaid-dev-entry.mdc` が自動適用される。

---

## 読む順序（React Client コンポーネントを触るとき）

| 触るもの | 読む順序 |
|----------|----------|
| **`components/**`（flowchart 以外）** · Hooks | 1. **`30_web_stack/REACT_RULES.md`** 2. **`creating-react-yk`** 3. ROUTER · Ref Plan 4. **`NEXTJS_RULES` §5**（RSC 境界が絡むとき） |
| **`components/flowchart/**`** | 上 + **`35_reactflow/REACTFLOW_RULES.md`** · `creating-reactflow-yk` |
| **`app/**`** | **`creating-nextjs-yk`** · `NEXTJS_RULES` §5（§6 は flowchart のみ） |
| **`lib/flowchart/**`** | `creating-reactflow-yk` のみ（React 禁止） |

**誤ルーティング:** [RULE_INDEX — 早見表](RULE_INDEX.md#誤ルーティング早見表)（React Flow ≠ React 一般）。

---

## 読む順序（flowchart-web-reactflow / React Flow を触るとき）

1. **`35_reactflow/REACTFLOW_RULES.md`** — L1 SSOT（毎回）
2. **スキル `creating-reactflow-yk/SKILL.md`** — 手順
3. **`creating-reactflow-yk/references/ROUTER.md`** — tier / tag · Ref Plan
4. **Ref Plan** — コード編集前（ROUTER §7）
5. **Next.js シェル** — `30_web_stack/NEXTJS_RULES.md` §5 + §6 · `creating-nextjs-yk`
6. **Client React 一般** — `REACT_RULES.md` · `creating-react-yk`（`components/flowchart` の Hooks）
7. **shadcn 表 UI** — [shadcn/ui](#読む順序shadcnui-を触るとき) · §13 · `init-radix`（未導入時は init が次の 1 件）
8. **参照実装** — `c:/yk-tool/flowchart-web-reactflow/`
9. **方式境界** — `45_mermaid/MERMAID_RULES.md` §1.5

**誤ルーティング:** [RULE_INDEX — 早見表](RULE_INDEX.md#誤ルーティング早見表)。

---

## 読む順序（flowchart-web-mermaid / 表 → Mermaid プレビュー）

1. **`35_reactflow/REACTFLOW_RULES.md`** — L1 SSOT（§3-6 `toMermaid` · §4-3 Mermaid プレビュー · §4-0 公式索引）
2. **スキル `creating-reactflow-yk/SKILL.md`** — 手順（**`creating-mermaid-yk` 非使用**）
3. **`creating-reactflow-yk/references/ROUTER.md`** — tag `mermaid-preview` 等
4. **Next.js シェル** — `NEXTJS_RULES.md` §5 + §6 · `creating-nextjs-yk`
5. **参照実装** — `c:/yk-tool/flowchart-web-mermaid/`（`toMermaid.ts` · `MermaidPreview.tsx`）
6. **方式境界** — `45_mermaid/MERMAID_RULES.md` §1.5-1（`.mmd` 執筆は No 45 へ）

**開発ポート:** **3001**（reactflow 版 3000 と並行）。

---

## 読む順序（shadcn/ui を触るとき）

1. **`30_web_stack/SHADCN_UI_RULES.md`** — L1 SSOT（**§2 で flowchart §13 / ui-kit §12 / surge 禁止を確定**）
2. **スキル `creating-shadcn-yk/SKILL.md`** — init/add 手順
3. **`creating-shadcn-yk/references/ROUTER.md`** — tier / tag · Ref Plan
4. **Ref Plan** — `components/ui` 編集 · CLI 前（ROUTER §7）
5. **ドメイン floor** — flowchart → `REACTFLOW_RULES` · §13 / ui-kit → `WORKSPACE_RULES` · §12
6. **併用** — `TAILWINDCSS_RULES`（v4）· `NEXTJS_RULES` §5（`"use client"`）
7. **L0** — `shadcn-dev-entry.mdc`（汎用）· flowchart → `reactflow-dev-entry` 優先 · ui-kit → `workspace-dev-entry` 優先

**誤ルーティング:** [RULE_INDEX — 早見表](RULE_INDEX.md#誤ルーティング早見表)。

---

## 読む順序（Vercel / デプロイを触るとき）

1. **`30_web_stack/VERCEL_RULES.md`** — L1 SSOT（**§2 で surge / FB 初回 / 汎用 deploy を確定**）
2. **スキル `creating-vercel-yk/SKILL.md`** — link/env/deploy 方針 · Shell 停止条件
3. **`creating-vercel-yk/references/ROUTER.md`** — tier / tag · Ref Plan
4. **Ref Plan** — `vercel` CLI 前（ROUTER §7）
5. **横断** — `SECRETS_HYGIENE_RULES`（env 値）· `GIT_WORKFLOW_RULES`（commit 明示時）
6. **併用** — `NEXTJS_RULES` §5（`app/` 同時編集）· Neon 初回 → **`setup-fb-tool`**（nested）
7. **L0** — `vercel-dev-entry.mdc` · `app/**` のみ → `nextjs-dev-entry` 優先

**誤ルーティング:** [RULE_INDEX — 早見表](RULE_INDEX.md#誤ルーティング早見表)。Python `.env` は No 41 · Secrets（No 15）。

**D（性能）:** React/Next **性能**は `yk-tool/workspace-ui-kit/.claude/skills/vercel-react-best-practices` を **ui-kit 正本のまま**とし、yk-skill は `creating-react-yk` ROUTER tag `performance` 経由で参照する。**Vercel デプロイ**は `VERCEL_RULES`（No 34）のみ。

---

## 読む順序（workspace-ui-kit を触るとき）

1. **`20_web_workspace/WORKSPACE_RULES.md`** — キット横断
2. **ドメイン固有** — [RULE_INDEX カタログ](RULE_INDEX.md#番号付きカタログssot) No 22 等
3. **スタック** — `REACT` · `NEXTJS` §5 · `SHADCN` · `TAILWIND`（**`GAS_REPORT_DESIGN` は含めない** — ui-kit は shadcn トークンが SSOT）
4. **企画（人間向け・参考）** — `yk-memo`（Governance 段階 7）

`workspace-ui-kit` で `app/` · `components/` · `lib/` 内の `.ts` / `.tsx` を触るときは `workspace-ui-kit/.cursor/rules/workspace-dev-entry.mdc` が自動適用される。

**デザイン判断のルーティング**

| 状況 | 読むルール |
|------|------------|
| workspace-ui-kit（Next / shadcn） | `SHADCN_UI` · `TAILWIND` · ドメイン rule |
| GAS 進捗レポート HTML・surge 図解 HTML（chip・8px グリッド） | `50_gas_html_test/GAS_REPORT_DESIGN_RULES.md` |
| 迷ったら | [RULE_INDEX](RULE_INDEX.md) No 00 → クイック入口 |

**リポジトリ内（workspace-ui-kit）**

| 用途 | ファイル |
|------|----------|
| 採用管理雛形・ADR・スキル | `workspace-ui-kit/CLAUDE.md` |
| 図解管理の実装 | `app/diagram-manager/` · `components/diagram-manager/` |

---

## 読む順序（Agent が Shell を使うとき）

1. **`60_tooling/AGENT_SHELL_RULES.md`** — RUN 削減 · Read/Glob 優先 · タスク別例外 D-1〜D-4
2. **`60_tooling/CURSOR_RULES.md`** — Windows · 権限 · 人間向け Auto-Run 手順（§5 からリンク）

---

## 読む順序（Git 操作をするとき）

1. **`10_meta/GIT_WORKFLOW_RULES.md`** — 横断方針（commit / push / メッセージ / 禁止）
2. **`10_meta/SECRETS_HYGIENE_RULES.md`** — コミットしてはいけないファイル・チャット貼付禁止
3. **ドメイン補足** — 例: Python rev 積層 → `40_python/PYTHON_RULES.md` §9 · Playwright セッション → No 53 §5
4. **実行手順** — Cursor User Rules（`git status` / `git diff` / HEREDOC 等）
5. **（任意）** スキル `committing-with-git-yk` — マルチリポ判定 · 日本語メッセージ草案 · `/committing-with-git-yk` 明示起動

---

## 読む順序（資格情報・トークンを扱うとき）

1. **`10_meta/SECRETS_HYGIENE_RULES.md`** — チェックリスト · 禁止パターン
2. **ドメイン** — Python `.env` → No 41 · GAS → No 51 §4 · Vercel → No 34 §0 · Playwright → No 53 §5
3. **Git に載せる前** — `GIT_WORKFLOW_RULES.md` §2

---

## 読む順序（GAS / Playwright / 大容量 HTML）

1. [RULE_INDEX — カタログ](RULE_INDEX.md#番号付きカタログssot) で該当 No を特定
2. **GAS** → No 51 · **E2E** → No 53（GAS は `networkidle`、Sheets は `load` — PLAYWRIGHT 参照）
3. **大容量 HTML 編集** → No 54（Python 文字列処理が安定する場合は `40_python` も可）

---

## 読む順序（個人アプリ新規 · 企画フォルダ · 再開）

1. **`10_meta/APP_PROJECT_RULES.md`** — 三層モデル · 新規チェックリスト · AGENTS 必須項目
2. **handoffs** — `c:/yk-memo/handoffs/{slug}/HANDOFF.md` → 最新セッション MD **§4 の 1 件**
3. **企画 `AGENTS.md`** — 境界 · SSOT マップ · やる/やらない
4. **Product Spec** — 仕様疑問時のみ（README 読む順序 · データモデル · ADR）
5. **スタック L1** — 実装開始後 [RULE_INDEX クイック入口](RULE_INDEX.md#タスク別クイック入口)（No 31–35 等）
6. **新規/整理/AGENTS 整備** — スキル `starting-app-project-yk`
7. **引き継ぎ終了** — スキル `handoff-session-work`（本 rule に手順全文は載せない）

**実例:** flowchart-web → [AGENTS.md](c:/yk-memo/00.ai-driven-school/個人テーマ_フローチャートアプリ/AGENTS.md) · [handoffs/flowchart-web](c:/yk-memo/handoffs/flowchart-web/HANDOFF.md)

---

## プレイブックの更新

- ドメイン手順の追加・変更は **本ファイル** を SSOT とし、[RULE_INDEX](RULE_INDEX.md) のクイック入口表のリンク先アンカーのみ同期する
- 新規ドメイン rule 追加時: `PROGRESSIVE` §10 → L1 作成 → 本ファイルに節追加 → INDEX クイック表に行追加
