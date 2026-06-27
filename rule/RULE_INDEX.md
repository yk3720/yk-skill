# yk-skill/rule — ルール索引

エージェント・人間が **どのファイルをいつ読むか** の入口。詳細は各ファイルが SSOT。

**最終更新:** 2026-06-27（P16 · yk-memo 部分セット · 未登録ドメイン節）

**改善プロジェクトの続き:** [RULE_IMPROVEMENT_HANDOFF.md](RULE_IMPROVEMENT_HANDOFF.md)（未着手バックログ・再開手順）

---

## 目次

| 節 | 用途 |
|----|------|
| [タスク別クイック入口](#タスク別クイック入口) | **最初にここ** — 触るもの → No → L1 |
| [誤ルーティング早見表](#誤ルーティング早見表) | React / Flow / Mermaid / shadcn / Vercel 等の取り違え防止 |
| [ルール配置の規約](#ルール配置の規約v1--固定) | 帯 · ファイル名 · 新規追加 |
| [Governance](#governance--precedence優先順位) | 矛盾時の優先順位 |
| [リポジトリ要約](#リポジトリ要約) | 5 ルートの役割（詳細は末尾） |
| [番号付きカタログ](#番号付きカタログssot) | 全ルール一覧（No 列が論理順 SSOT） |
| [Status 列](#status-列エージェント向け定義) | `active` / `draft` の意味 |
| [読む順序プレイブック](RULE_ROUTING_PLAYBOOK.md) | PROGRESSIVE 手順の詳細（**必要時のみ Read**） |
| [新規ルールの追加手順](#新規ルールの追加手順) | 帯選択 → 本表追記 |
| [リポジトリマップ（詳細）](#リポジトリマップ横断パス-ssot) | 横断パス · マルチルート（末尾） |

---

## タスク別クイック入口

**索引の使い方:** 下表で No と L1 を特定 → 手順の詳細が要るときだけ [RULE_ROUTING_PLAYBOOK.md](RULE_ROUTING_PLAYBOOK.md) を Read。glob 一致時は **L0 entry** が L1 より先に効くことがある（Governance 段階 2–3）。

| 触るもの / 依頼 | No | L1（最初に Read） | 読む順序 | L0 entry（`.mdc`） |
|-----------------|-----|-------------------|----------|-------------------|
| 初回・迷った | 00 | 本ファイル | — | — |
| commit / push（ユーザー明示時） | 14 | `10_meta/GIT_WORKFLOW_RULES.md` | [Git](RULE_ROUTING_PLAYBOOK.md#読む順序git-操作をするとき) | — |
| トークン · `.env` · 秘密情報 | 15 | `10_meta/SECRETS_HYGIENE_RULES.md` | [Secrets](RULE_ROUTING_PLAYBOOK.md#読む順序資格情報トークンを扱うとき) | — |
| 調査のみ · Shell 抑制 | 62 | `60_tooling/AGENT_SHELL_RULES.md` | [Shell](RULE_ROUTING_PLAYBOOK.md#読む順序agent-が-shell-を使うとき) | `yk-skill` · `agent-shell-yk`（always） |
| 品質ゲート · lint/hook/CI | 63 | `60_tooling/QUALITY_GATE_RULES.md` | L1 直接 | `quality-gates-yk`（flowchart 等） |
| 横断スクリプト · hook 用ユーティリティ | 64 | `60_tooling/WORKSPACE_SCRIPTS_RULES.md` | L1 → `yk-tool/scripts/README.md` | — |
| Python `.py` | 41 | `40_python/PYTHON_RULES.md` | [Python](RULE_ROUTING_PLAYBOOK.md#読む順序python-ツールを触るとき) | `5.Python` · `python-dev-entry` |
| FastAPI · APIRouter · UploadFile | 42 | `40_python/FASTAPI_RULES.md` | [FastAPI](RULE_ROUTING_PLAYBOOK.md#読む順序fastapi-api-を触るとき) | —（draft · スキル未整備） |
| `.mmd` · 図解 MD | 45 | `45_mermaid/MERMAID_RULES.md` | [Mermaid](RULE_ROUTING_PLAYBOOK.md#読む順序mermaid-図を書くとき) | `yk-skill` · `mermaid-dev-entry` |
| `@xyflow` · 表駆動 · flowchart RF | 35 | `35_reactflow/REACTFLOW_RULES.md` | [flowchart RF](RULE_ROUTING_PLAYBOOK.md#読む順序flowchart-studio--react-flow-を触るとき) | `reactflow-dev-entry` |
| flowchart · 表 → Mermaid プレビュー | 35 | 同上 | [flowchart mmd](RULE_ROUTING_PLAYBOOK.md#読む順序flowchart-web-mermaid--表--mermaid-プレビュー) | `reactflow-dev-entry` |
| React 一般 · Hooks（flowchart 外） | 36 | `30_web_stack/REACT_RULES.md` | [React](RULE_ROUTING_PLAYBOOK.md#読む順序react-client-コンポーネントを触るとき) | — |
| Supabase · RLS · Auth · DB | 37 | `30_web_stack/SUPABASE_RULES.md` | [Supabase](RULE_ROUTING_PLAYBOOK.md#読む順序supabase--rls--auth-を触るとき) | `supabase-dev-entry` |
| Next.js `app/` | 31 | `30_web_stack/NEXTJS_RULES.md` | [React](RULE_ROUTING_PLAYBOOK.md#読む順序react-client-コンポーネントを触るとき) | `nextjs-dev-entry`（`app/**` 優先） |
| shadcn / `components/ui` | 32 | `30_web_stack/SHADCN_UI_RULES.md` | [shadcn](RULE_ROUTING_PLAYBOOK.md#読む順序shadcnui-を触るとき) | `shadcn-dev-entry` |
| Tailwind | 33 | `30_web_stack/TAILWINDCSS_RULES.md` | [PLAYBOOK](RULE_ROUTING_PLAYBOOK.md) · L1 | — |
| Vercel · deploy | 34 | `30_web_stack/VERCEL_RULES.md` | [Vercel](RULE_ROUTING_PLAYBOOK.md#読む順序vercel--デプロイを触るとき) | `vercel-dev-entry` |
| workspace-ui-kit | 21 | `20_web_workspace/WORKSPACE_RULES.md` | [ui-kit](RULE_ROUTING_PLAYBOOK.md#読む順序workspace-ui-kit-を触るとき) | `yk-tool/workspace-ui-kit` · `workspace-dev-entry` |
| `/diagram-manager` | 22 | `DIAGRAM_MANAGER_WORKSPACE_RULES.md` | [ui-kit](RULE_ROUTING_PLAYBOOK.md#読む順序workspace-ui-kit-を触るとき) | 同上 |
| GAS Web アプリ | 51 | `50_gas_html_test/GAS_RULES.md` | [GAS / E2E](RULE_ROUTING_PLAYBOOK.md#読む順序gas--playwright--大容量-html) | — |
| Playwright E2E | 53 | `50_gas_html_test/PLAYWRIGHT_RULES.md` | [GAS / E2E](RULE_ROUTING_PLAYBOOK.md#読む順序gas--playwright--大容量-html) | `playwright-agent-yk`（always）· `designing-playwright-tests-yk`（§13 設計）· `using-playwright`（実行） |
| surge 図解 · GAS レポート HTML（chip） | 52 | `GAS_REPORT_DESIGN_RULES.md` | [ui-kit デザイン](RULE_ROUTING_PLAYBOOK.md#読む順序workspace-ui-kit-を触るとき) | — |
| 大容量 HTML + PowerShell | 54 | `POWERSHELL_HTML_RULES.md` | [GAS / E2E](RULE_ROUTING_PLAYBOOK.md#読む順序gas--playwright--大容量-html) | — |
| スキル MD 作成・更新 | 12 | `SKILL_AUTHORING_RULES.md` | — | — |
| 新ドメイン rule / スキル | 11 | `PROGRESSIVE_CONTEXT_ROUTING_RULES.md` | — | — |
| チャット応答（平易さ等） | 16 | `COMMUNICATION_RULES.md` | — | `communication-yk`（always） |
| 個人アプリ新規 · 企画フォルダ · 再開 | 17 | `10_meta/APP_PROJECT_RULES.md` | [App project](RULE_ROUTING_PLAYBOOK.md#読む順序個人アプリ新規企画フォルダ再開) · 手順: `starting-app-project-yk` | — |
| 企画フォルダ 6 種 · ドキュメント種別 · 移行 | 25 | `10_meta/PROJECT_DOCUMENT_RULES.md` | L1 直接 · 入口は No 17 と併用 | — |
| 独立リポジトリ移行 · yk-application | 18 | `10_meta/YK_APPLICATION_RULES.md` | L1 直接 | — |
| UI · 図の線の太さ・統一感 | 19 | `10_meta/VISUAL_DESIGN_RULES.md` | L1 直接 | `visual-design-yk`（always） |
| UI/UX · 画面設計 · ヒューリスティック評価 | 20 | `10_meta/USABILITY_HEURISTICS_RULES.md` | L1 直接 · UI レビュー時 | — |
| アクセシビリティ · WCAG 2.2 | 24 | `10_meta/A11Y_RULES.md` | a11y 実装 · レビュー · チェックリスト | — |
| アクセシビリティ · 導入計画 | 23 | `10_meta/A11Y_ROADMAP.md` | Phase 判断 · CI 段階 · 工数 | — |
| 講座・行動指針 · ルール抽出ループ（YK 補足） | 13 | `10_meta/AI_DRIVEN_RULES.md` | **通常 Read しない**（YK 補足: `distilling-rules-yk` 発火時） | — |

---

## 誤ルーティング早見表

| やりたいこと | 使う | 使わない |
|--------------|------|----------|
| `@xyflow/react` · 表駆動フロー · `flowchart-studio` | No **35** · `creating-reactflow-yk` | No 36 のみ · `creating-mermaid-yk` · surge 図解スキル |
| 汎用 React / Hooks · `components/**`（flowchart 外） | No **36** · `creating-react-yk` | No 35 のみで代替 |
| `.mmd` 執筆 · diagram-as-code | No **45** · `creating-mermaid-yk` | No 35 のプレビュー手順で `.mmd` 執筆を代替 |
| flowchart · 表 → Mermaid **プレビュー** | No **35** · `creating-reactflow-yk` | **`creating-mermaid-yk`** |
| UI レイアウト・重なり · E2E spec | No **53** §12 · `using-playwright` | 手動スクショ反復 · 単体ロジックのみ Vitest で足りるのに E2E のみ · spec 前設計なし（→ §13 · `designing-playwright-tests-yk`） |
| shadcn init / add | No **32** · `creating-shadcn-yk` | surge · `lib/flowchart/` · ui-kit 既存への `init -b radix` |
| Vercel / Neon **デプロイ** | No **34** · `creating-vercel-yk` | surge ホスト · FB 初回のみで vercel スキル完結 · 未明示 `--prod` |
| Supabase RLS · Auth · `@supabase/ssr` | No **37** · `creating-supabase-yk` | No **31** のみ · No **35** のみ · `creating-vercel-yk` で RLS 代替 |
| ui-kit の Next / shadcn UI | SHADCN · TAILWIND · WORKSPACE | **GAS_REPORT_DESIGN**（静的 HTML chip は No 52） |
| React / ui-kit / flowchart の a11y | No **24** · `A11Y_RULES` | No **52** GAS_REPORT のみ（React chrome には読まない） |
| アクセシビリティ Phase · CI 段階 | No **23** · `A11Y_ROADMAP` | 本ファイルでチェックリストを再定義しない |
| Python `.py` · CLI · pandas | No **41** · `creating-pythoncode-yk` | No **42** のみで CLI/SDD を省略 |
| FastAPI · UploadFile · Uvicorn · TestClient | No **42** · `FASTAPI_RULES` + No **41** | No **41** のみ · No **34** で FastAPI 本体デプロイ |

各ドメインの詳細手順は [RULE_ROUTING_PLAYBOOK.md](RULE_ROUTING_PLAYBOOK.md)（**必要時のみ Read**）。

---

## ルール配置の規約（v1 — 固定）

| 項目 | 規約 |
|------|------|
| **入口** | `rule/RULE_INDEX.md`（索引）· `rule/RULE_ROUTING_PLAYBOOK.md`（読む順序）— ルート直下（移動しない） |
| **帯フォルダ** | `10_meta/` · `20_web_workspace/` · `30_web_stack/` · **`35_reactflow/`** · `40_python/` · **`45_mermaid/`** · `50_gas_html_test/` · `60_tooling/` — **並び・分類用**（10刻みで空きを残す。中間ドメインは **No と一致**させる例: No 35 → `35_reactflow` · No 45 → `45_mermaid`）。**例外:** `50_gas_html_test` は物理名レガシー（カタログ No は **51–54**）— 意味は [帯の意味](#帯の意味要約) |
| **ファイル名** | `{TOPIC}_RULES.md`（番号はファイル名に付けない） |
| **カタログ No** | 下表の **No 列**が論理順の SSOT. 帯番号と優先順位（Governance）は別 |
| **新規追加** | 該当帯にファイル作成 → **本表に1行追加**（No は空き番号。既存ファイルのリネームは避ける） |
| **ルート直下** | `RULE_INDEX.md` · `RULE_ROUTING_PLAYBOOK.md` · `RULE_IMPROVEMENT_HANDOFF.md` · `load-manifest.yaml`（Phase 2 試作）— 移行スタブ削除済み |

**Phase 2:** [`load-manifest.yaml`](load-manifest.yaml) **試作あり**（L1 **33** 本 · No 00 除く · 本格運用は tag 検証需要時または CI 連携時）。列: `path` · `band` · `tags` · `read_when` · `status` — **人手で INDEX と同期**（自動生成スクリプトは未導入）。

---

## Governance & Precedence（優先順位）

複数ルールが矛盾したときは、**上ほど優先**する。同順位で指示が食い違うときは、**推測で片方を捨てず**チャットでユーザーに確認する。

| 順 | レイヤ | 例 |
|----|--------|-----|
| **1** | **ユーザー明示指示** | 当該チャットで今回と指定されたこと |
| **2** | **ワークスペース alwaysApply ルール** | `.cursor/rules/*.mdc`（`alwaysApply: true`）。`5.Python` では **rev 積層保護**（`revision-protection.mdc`）— 既存 `*revNNN*` ファイルの上書き禁止・新 rev のみ積層 |
| **3** | **glob 付き .mdc** | 編集中ファイルに一致する entry（例: `python-dev-entry.mdc`） |
| **4** | **狭いドメイン rule → 広い rule** | 例: `REACTFLOW_RULES` > `REACT_RULES` > `NEXTJS` · `DIAGRAM_MANAGER_WORKSPACE_RULES` > `WORKSPACE_RULES` |
| **5** | **yk-skill L1 + 発火スキル** | 例: `40_python/PYTHON_RULES.md` + `creating-pythoncode-yk/SKILL.md` |
| **6** | **Ref Plan で列挙した references のみ** | ロード規則の SSOT は各スキルの `ROUTER.md` |
| **7** | **企画・メモ（人間向け）** | `yk-memo` 等 — スコープ・背景の参考。**実装の正解ではない** |

**L0 `.mdc` と L1:** alwaysApply / glob の `.mdc` は**入口要約**。手順・禁止の SSOT は L1 rule。`.mdc` と L1 が食い違うときは **L1 を正として `.mdc` を更新**（段階 2 の要約が段階 5 の L1 より古くならない）。

**企画メモ vs 実装 rule:** 実装・AI 指示の SSOT は **`yk-skill/rule` の該当 `*_WORKSPACE_RULES.md`（およびコード内の型・定数）** が勝つ。`yk-memo` と食い違う場合は **rule または ADR を更新してから**実装に反映する。

Web ドメイン内の「狭い > 広い」の詳細 → `20_web_workspace/WORKSPACE_RULES.md` §1。

---

## リポジトリ要約

日常のルール選びでは本節で足りる。**横断パス一覧・マルチルート**は末尾 [リポジトリマップ](#リポジトリマップ横断パス-ssot)。移行履歴は `c:/yk-memo/handoffs/workspace-layout/HANDOFF.md`。

| ルート | 役割 |
|--------|------|
| `c:/yk-skill` | スキル · **`rule/`（本索引）** · `metadata/` |
| `c:/yk-tool` | 成果物 · `publish/` · `workspace-ui-kit/` · `flowchart-web-mermaid` |
| `c:/yk-memo` | 企画 · 講座 · `handoffs/`（Governance 段階 7 — 実装の正解ではない）· **`.cursor/rules` は部分セット**（下記） |
| `c:/yk-document` | Excel 原本（Git 外）· `exports/` |
| `c:/yk-application` | 完成間近のアプリ（個別リポジトリ管理用） |
| `c:/1.cursor/5.Python` | Python デスクトップ（別リポ · rev 積層保護） |

**ui-kit / flowchart:** `workspace-ui-kit` 作業は **`yk-tool` をワークスペースに含める**（`workspace-dev-entry.mdc` は `yk-tool/workspace-ui-kit/.cursor/rules/` のみ）。

**yk-memo の `.cursor/rules`（部分セット · yk-skill 全文同期しない）:** alwaysApply 4 本（`communication-yk` · `visual-design-yk` · `agent-shell-yk` · `playwright-agent-yk`）+ `reactflow-dev-entry` · `mermaid-dev-entry` · `quality-gates-yk`。Next/shadcn/Vercel/Supabase entry は **含めない**（企画 · handoffs 中心 WS）。

---

## 未登録ドメイン（L0 `.mdc` のみ）

`rule/` 帯 · L1 · L2 スキル · ROUTER **未整備**。glob 一致時は **`.mdc` 本文が SSOT**（Governance 段階 2–3）。PROGRESSIVE 化は本線化判断後。

| ドメイン | L0 entry（`yk-skill/.cursor/rules/`） | 備考 |
|----------|--------------------------------------|------|
| Tauri 2 | `tauri2-dev-yk.mdc` | `src-tauri/**` · `tauri.conf.json` · `capabilities/**` |
| Rust | `rust-dev-yk.mdc` | `**/*.rs` · `Cargo.toml` |
| Supabase（Desktop Auth） | — | Tauri 連携の索引は [`SUPABASE_RULES.md`](30_web_stack/SUPABASE_RULES.md) §10 |

**Tauri × flowchart-studio:** 2026-06-27 — **当面統合しない**（[`tauri-practice/HANDOFF`](c:/yk-memo/handoffs/tauri-practice/HANDOFF.md) §6）。Web 正本は No 35 · 31 · 37。

---

## Status 列（エージェント向け定義）

本表 **Status** 列は、各 `*_RULES.md` の **整備度**（索引メタデータ）を示す。Git ブランチ名や本文中の「下書き」とは別概念。

| Status | 意味 | エージェントの扱い |
|--------|------|-------------------|
| **active** | L1 整備済。**当該ドメインで PROGRESSIVE 完遂**（L0 `*-dev-entry.mdc` · L2 スキル · `ROUTER.md` — meta 横断など L0 不要の帯は例外） | 該当作業時に **L1 を Read**。手順・Ref Plan はスキルと entry に従う |
| **draft** | L1 はあるが **PROGRESSIVE 完遂前**（スキル未作成 · ROUTER が L1 暫定 · entry 未作成 等） | **L1 先頭の注記どおり、構文・安全など MUST は適用**。手順は L1 暫定節 + 既存スキル。`active` への昇格は人間が索引を更新するまで行わない |
| **deprecated** | 置換先あり。**参照禁止** | 読まない。本表の置換ルールまたは移行スタブを確認 |

**SSOT:** Status の定義は **本節のみ**。各ルールファイル先頭の「ステータス」行は本表と **同期** する（食い違い時は本表を正として L1 を直す）。

**`draft` → `active` 昇格の目安（ドメイン rule）**

1. `10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md` §10 の新ドメイン手順が完了している  
2. 本表の当該行を `active` に更新した  
3. L1 先頭のステータス表記を `active` に合わせる  

例: No 45 `MERMAID_RULES` — 2026-05-23 に P10 完了後 `active`。

---

## 番号付きカタログ（SSOT）

| No | 帯 | パス | いつ読む | Status |
|----|-----|------|----------|--------|
| 00 | — | `RULE_INDEX.md` | **常に最初**（本ファイル） | active |
| 11 | 10_meta | `10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md` | 新ドメインスキル・ルーティング設計 | active |
| 12 | 10_meta | `10_meta/SKILL_AUTHORING_RULES.md` | スキル作成・更新 | active |
| 13 | 10_meta | `10_meta/AI_DRIVEN_RULES.md` | 講座・行動指針（**人間向け** — エージェントは通常 Read しない） | active |
| 14 | 10_meta | `10_meta/GIT_WORKFLOW_RULES.md` | **Git 操作**（commit / push / メッセージ / 禁止事項） | active |
| 15 | 10_meta | `10_meta/SECRETS_HYGIENE_RULES.md` | **Secrets**（コミット禁止・チャット貼付禁止・保管場所） | active |
| 16 | 10_meta | `10_meta/COMMUNICATION_RULES.md` | **チャット応答**（平易さ・作業後3点サマリ） | active |
| 17 | 10_meta | `10_meta/APP_PROJECT_RULES.md` | **個人アプリ**新規 · 企画フォルダ · handoffs 再開 · `AGENTS.md` | active |
| 18 | 10_meta | `10_meta/YK_APPLICATION_RULES.md` | **独立リポジトリ移行** · yk-application 管理 | active |
| 19 | 10_meta | `10_meta/VISUAL_DESIGN_RULES.md` | **ビジュアル共通** — 線の太さ統一 · 強調の例外 | active |
| 20 | 10_meta | `10_meta/USABILITY_HEURISTICS_RULES.md` | **UX 共通** — ニールセン10原則 · UI レビュー · ヒューリスティック評価 | active |
| 23 | 10_meta | `10_meta/A11Y_ROADMAP.md` | **a11y 導入ロードマップ** — WCAG 2.2 AA 段階導入 · Phase 0–5 | active |
| 24 | 10_meta | `10_meta/A11Y_RULES.md` | **a11y 横断 SSOT** — WCAG 2.2 AA チェックリスト · ツール · スコープ | active |
| 25 | 10_meta | `10_meta/PROJECT_DOCUMENT_RULES.md` | **企画フォルダ 6 種** — 要求定義〜ユビキタス言語 · 吸収 · 移行 · 仕様↔コード | active |
| 21 | 20_web_workspace | `20_web_workspace/WORKSPACE_RULES.md` | workspace-ui-kit 横断 | active |
| 22 | 20_web_workspace | `20_web_workspace/DIAGRAM_MANAGER_WORKSPACE_RULES.md` | `/diagram-manager` 作業 | active |
| 31 | 30_web_stack | `30_web_stack/NEXTJS_RULES.md` | Next.js 作業 | active |
| 32 | 30_web_stack | `30_web_stack/SHADCN_UI_RULES.md` | shadcn / Base UI 作業 | active |
| 33 | 30_web_stack | `30_web_stack/TAILWINDCSS_RULES.md` | Tailwind 作業 | active |
| 34 | 30_web_stack | `30_web_stack/VERCEL_RULES.md` | Vercel / Neon デプロイ | active |
| 35 | 35_reactflow | `35_reactflow/REACTFLOW_RULES.md` | 表駆動フロー · `@xyflow/react` · `flowchart-studio` | active |
| 36 | 30_web_stack | `30_web_stack/REACT_RULES.md` | React コンポーネント · Hooks · Client UI | active |
| 37 | 30_web_stack | `30_web_stack/SUPABASE_RULES.md` | Supabase · RLS · Auth · Server Actions | active |
| 41 | 40_python | `40_python/PYTHON_RULES.md` | Python ツール（毎回・L1） | active |
| 42 | 40_python | `40_python/FASTAPI_RULES.md` | FastAPI REST API · ファイルアップロード · Uvicorn | draft |
| 45 | 45_mermaid | `45_mermaid/MERMAID_RULES.md` | Mermaid DSL（`.mmd` / 図解 MD）・diagram-as-code | active |
| 51 | 50_gas_html_test | `50_gas_html_test/GAS_RULES.md` | GAS Web アプリ | active |
| 52 | 50_gas_html_test | `50_gas_html_test/GAS_REPORT_DESIGN_RULES.md` | **GAS 進捗レポート HTML**・surge 図解 HTML の chip デザイン | active |
| 53 | 50_gas_html_test | `50_gas_html_test/PLAYWRIGHT_RULES.md` | Playwright / E2E | active |
| 54 | 50_gas_html_test | `50_gas_html_test/POWERSHELL_HTML_RULES.md` | 大容量 HTML + PowerShell | active |
| 61 | 60_tooling | `60_tooling/CURSOR_RULES.md` | Cursor / Windows 実務 | active |
| 62 | 60_tooling | `60_tooling/AGENT_SHELL_RULES.md` | **Agent Shell / RUN 削減** · Read 優先 · allowlist | active |
| 63 | 60_tooling | `60_tooling/QUALITY_GATE_RULES.md` | **品質ゲート** · lint/hook/CI · hook 失敗時のエージェント行動 | active |
| 64 | 60_tooling | `60_tooling/WORKSPACE_SCRIPTS_RULES.md` | **横断スクリプト配置** · 正本 `yk-tool/scripts/` · `catalog.yaml` | active |

**帯の意味（要約）**

| 帯 | 含むもの | 含まないもの |
|----|----------|--------------|
| 10_meta | 横断設計·Git · Secrets · **ビジュアル共通** · **個人アプリプロジェクト** · **企画ドキュメント 6 種** · スキル執筆 · 講座原則 | ドメイン実装詳細 |
| 20_web_workspace | ui-kit 横断・図解管理等ドメイン | スタック個別 API |
| 30_web_stack | Next / React / shadcn / Tailwind / Vercel / Supabase | workspace-ui-kit の画面仕様 · flowchart の表→RF パイプライン（→ No 35） |
| 35_reactflow | 表駆動 · React Flow · `flowchart-studio` | Mermaid DSL（→ 45）· surge 図解 HTML |
| 40_python | Python L1 · FastAPI L1（No 42）· SDD 要約 | KB 全文（スキル references） |
| 45_mermaid | Mermaid DSL・図の SDD・検証（mmdc） | L1 本文に手順全文は含めない（→ L2 `creating-mermaid-yk` + `ROUTER.md`） |
| 50_gas_html_test | GAS（No 51）· レポート/surge HTML デザイン（52）· Playwright E2E（53）· 大容量 HTML+PS（54）— **物理フォルダ名はレガシー** | Next.js UI（→ 30） |
| 60_tooling | エディタ・OS 操作 | アプリ仕様 |

**パス:** 上表の `帯/{NAME}_RULES.md` が SSOT. 旧 `rule/{NAME}_RULES.md` フラットパスは廃止（2026-05-23）。

---

## 読む順序（ドメイン別）

**SSOT:** [RULE_ROUTING_PLAYBOOK.md](RULE_ROUTING_PLAYBOOK.md) — PROGRESSIVE 手順の全文。本索引では **常時全読みしない**。

| よく使う入口 | プレイブック節 |
|--------------|----------------|
| Python · Mermaid · React / Flow · shadcn · Vercel · ui-kit | [PLAYBOOK 目次](RULE_ROUTING_PLAYBOOK.md#目次) |
| Git · Secrets · Shell · GAS / Playwright | 同上 |

**共通型（要約）:** L1 → スキル `SKILL.md` → `ROUTER.md` → Ref Plan → `references/` のみ。詳細は PLAYBOOK [PROGRESSIVE 共通手順](RULE_ROUTING_PLAYBOOK.md#progressive-共通手順スキル付きドメイン)。

---

## 新規ルールの追加手順

1. **帯を選ぶ**（上表「帯の意味」）。該当なしなら **70_** など空き帯を `RULE_INDEX` に定義してから作成
2. `rule/{帯}/{TOPIC}_RULES.md` を作成（**~250 行目安**（理想 · `PROGRESSIVE` §2）。**500 行超**は `references/` へ · `audit-rule-line-counts.ps1`）
3. **本表に行を追加**（No · path · いつ読む · status）
4. **[RULE_ROUTING_PLAYBOOK.md](RULE_ROUTING_PLAYBOOK.md)** に読む順序節を追加 · クイック入口表のリンクを同期
5. 既存 rule / スキルから **絶対パス `c:/yk-skill/rule/{帯}/{FILE}`** でリンク（`SKILL_AUTHORING` §12 準拠）
6. 旧来の フラット名が必要なら **スタブのみ**（本文コピー禁止）
7. **[`load-manifest.yaml`](load-manifest.yaml)** に `rules` 行を追加（Phase 2 試作 — INDEX と同期）

---

## リポジトリマップ（横断パス SSOT）

**目的:** 複数 Git ルートにまたがるパスの正本。詳細・移行手順は `c:/yk-memo/handoffs/workspace-layout/HANDOFF.md`。

**注意（2026-05-23）:** 図解 HTML の `yk-tool/publish/` · 主要ツールの `yk-tool/` 移行は **完了**。`surge-published-list.md` は移行後表記に更新済み。古いメモ・スキル断片に旧パスが残る場合は本表を正とする。

### リポジトリの役割

| ルート | 役割 | Git |
|--------|------|-----|
| `c:/yk-memo` | テキスト・企画（MD · 講座 · 議事） | あり |
| `c:/yk-skill` | スキル · `rule/` · 公開台帳 `metadata/` | あり |
| `c:/yk-tool` | 成果物・アプリ（`publish/` · `apps/` · ui-kit 等） | あり（新規） |
| `c:/yk-document` | 業務データ（Excel 原本 Git 外 · `exports/` · `_index/`） | あり（新規） |
| `c:/yk-application` | 完成間近のアプリ（個別リポジトリ管理用） | なし（各アプリが Git） |
| `c:/1.cursor/5.Python` | Python 実装（**別リポ・実験混在・一括整理しない**） | あり |
| `c:/yk-local`（任意） | `.env` · トークン · フル PII — 各リポから参照のみ | なし |

### 横断パス一覧（目標）

| 用途 | 目標パス | 備考 |
|------|----------|------|
| AI 指示・実装 rule の SSOT | `c:/yk-skill/rule/` | 本ファイル所在 |
| surge 公開図解台帳 | `c:/yk-skill/metadata/surge-published-list.md` | 図解スキルがデプロイ後に更新 |
| スキル台帳（インベントリ） | `c:/yk-skill/metadata/SKILL_CATALOG.md` | `creating-skills` 完了時に再生成 · 整理依頼時は `managing-skills-yk` · **`yk-tool/catalog.yaml`（成果物台帳）と混同しない** — 後者に `tools:` / `scripts:` |
| 図解 HTML 正本（ローカル） | `c:/yk-tool/publish/` | スキル内 `output/` は作業用 · デプロイ後に publish へコピー |
| 図解以外の Web/ツールアプリ | `c:/yk-tool/apps/` · ルート直下 Next アプリ | 例: `apps/commit-report-tool/` · `workspace-ui-kit/` |
| **ワークスペース横断スクリプト** | `c:/yk-tool/scripts/` | L1 [`WORKSPACE_SCRIPTS_RULES.md`](60_tooling/WORKSPACE_SCRIPTS_RULES.md) · 台帳 [`catalog.yaml`](c:/yk-tool/catalog.yaml) · 入口 [`scripts/README.md`](c:/yk-tool/scripts/README.md) |
| 図解管理 UI（Next） | `c:/yk-tool/workspace-ui-kit/` | 移行元: `yk-skill/workspace-ui-kit/` |
| フローチャート Web（React Flow） | `c:/yk-application/flowchart-studio/` | ADR-010 · 表 → React Flow |
| フローチャート Web（Mermaid 比較） | `c:/yk-tool/flowchart-web-mermaid/` | ADR-010 · 表 → Mermaid プレビュー |
| Playwright E2E | `c:/yk-tool/playwright-test/` | 移行元: `yk-skill/playwright-test/`（2026-05-23） |
| Python デスクトップツール | `c:/1.cursor/5.Python/` | 新規本番は必要分のみ **新フォルダへ移出** · `revision-protection` 適用 |
| 企画・背景（参考のみ） | `c:/yk-memo/` | Governance 段階 7 — 実装の正解ではない |
| Excel 原本 | `c:/yk-document/**/originals/` | Git ignore · 変換は `5.Python` + `exports/` |
| セッション引き継ぎ MD | `c:/yk-memo/handoffs/{project}/` | スキル `handoff-session-work`（終了·再開·確認·整理）· `references/template.md` · `folder-audit.md` |
| Git commit（ユーザー明示時） | 各リポ의 Git ルート | スキル `committing-with-git-yk` · 方針は `10_meta/GIT_WORKFLOW_RULES.md` |
| Agent Shell / RUN 承認 | `60_tooling/cursor-permissions/permissions.json` → `~/.cursor/` にデプロイ | `60_tooling/AGENT_SHELL_RULES.md` · `cursor-permissions/README.md` |
| Claude Code グローバル設定 | `60_tooling/claude-global/CLAUDE.md` → `~/.claude/` にデプロイ | `claude-global/README.md` |

### Cursor マルチルート（目安）

| タスク | 載せるルート |
|--------|-------------|
| 図解生成・デプロイ | `yk-skill` + `yk-tool` |
| ui-kit / flowchart-studio | `yk-application/flowchart-studio` + `yk-skill`（handoffs 時は `yk-memo`） |
| Excel 読取・変換 | `yk-document` + `5.Python` |
| 企画確認のみ | `yk-memo` のみ可 |

**パス方針:** シンボリックリンクは使わない。`5.Python` · 各実装リポの `.mdc` から `yk-skill/rule` へは **絶対パス**で参照（現行パターン維持）。
