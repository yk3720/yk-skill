# Claude Code グローバル設定

> **SSOT:** `c:/yk-skill/rule/60_tooling/claude-global/CLAUDE.md` — 反映は `Deploy-ClaudeGlobal.ps1`（`README.md` 参照）

## セッション引き継ぎ（handoffs）

セッション引き継ぎは `c:/yk-memo/handoffs/` に格納されている。
スキル: `handoff-session-work`

### handoffs 構造

```
handoffs/
  README.md               ← プロジェクト一覧（Tier-0）
  {project}/
    HANDOFF.md            ← 恒久方針・次の1手（§6）
    README.md             ← セッションMD索引
    {最新セッション}.md  ← ルート直下は1本のみ
    archive/2026/         ← 過去セッション
```

### 再開手順

1. `handoffs/README.md` でプロジェクトの状態を確認
2. 該当プロジェクトの最新セッション MD §4 の **1件だけ** 実行
3. 詳細文脈は `HANDOFF.md` を参照

### 現在のプロジェクト状態（2026-06-24時点）

| slug | 状態 | 次の1手 |
|------|------|---------|
| `flowchart-studio` | **進行中** | U0 動作001 本文（Excel→正規化→取込確認） |
| `workspace-layout` | **進行中** | APP_PROJECT_RULES §6 移行注記更新 |
| `tauri-practice` | **進行中** | flowchart-web 統合要否の決定 |
| `mermaid-rules` | **待機** | 新規 .mmd 作業まで §6 のみ |

### flowchart-web の推奨 workspace

`yk-memo` + `yk-application/flowchart-studio` + `yk-skill`
本番URL: https://flowchart-studio-dun.vercel.app

---

## 開発ルール（コードを書く前に必ず参照）

開発ルールは `C:\yk-skill\rule\` に格納されている。
**コードを書く・編集する前に、必ず以下の手順でルールを確認すること。**

### 参照手順

1. `C:\yk-skill\rule\RULE_INDEX.md` の「タスク別クイック入口」表で、触るもの → No → L1 ファイルを特定する
2. 該当する L1 ルールファイルを Read してからコードを書く
3. 詳細な読む順序が必要なときのみ `RULE_ROUTING_PLAYBOOK.md` を Read する

### ドメイン別 L1 ルールファイル早見表

| 触るもの | L1 ファイル |
|----------|------------|
| Python `.py` | `C:\yk-skill\rule\40_python\PYTHON_RULES.md` |
| Next.js `app/` | `C:\yk-skill\rule\30_web_stack\NEXTJS_RULES.md` |
| React コンポーネント・Hooks | `C:\yk-skill\rule\30_web_stack\REACT_RULES.md` |
| shadcn / `components/ui` | `C:\yk-skill\rule\30_web_stack\SHADCN_UI_RULES.md` |
| Tailwind | `C:\yk-skill\rule\30_web_stack\TAILWINDCSS_RULES.md` |
| Vercel / deploy | `C:\yk-skill\rule\30_web_stack\VERCEL_RULES.md` |
| Supabase · RLS · Auth | `C:\yk-skill\rule\30_web_stack\SUPABASE_RULES.md` |
| `@xyflow/react` · 表駆動フロー | `C:\yk-skill\rule\35_reactflow\REACTFLOW_RULES.md` |
| Mermaid DSL / `.mmd` | `C:\yk-skill\rule\45_mermaid\MERMAID_RULES.md` |
| Playwright E2E | `C:\yk-skill\rule\50_gas_html_test\PLAYWRIGHT_RULES.md` |
| GAS Web アプリ | `C:\yk-skill\rule\50_gas_html_test\GAS_RULES.md` |
| surge 図解 HTML chip | `C:\yk-skill\rule\50_gas_html_test\GAS_REPORT_DESIGN_RULES.md` |
| 大容量 HTML + PowerShell | `C:\yk-skill\rule\50_gas_html_test\POWERSHELL_HTML_RULES.md` |
| workspace-ui-kit | `C:\yk-skill\rule\20_web_workspace\WORKSPACE_RULES.md` |
| git commit / push | `C:\yk-skill\rule\10_meta\GIT_WORKFLOW_RULES.md` |
| トークン・secrets | `C:\yk-skill\rule\10_meta\SECRETS_HYGIENE_RULES.md` |
| UI ビジュアル統一 | `C:\yk-skill\rule\10_meta\VISUAL_DESIGN_RULES.md` |
| 品質ゲート / lint / CI | `C:\yk-skill\rule\60_tooling\QUALITY_GATE_RULES.md` |
| Agent Shell 操作 | `C:\yk-skill\rule\60_tooling\AGENT_SHELL_RULES.md` |

### Governance（優先順位）

ルールが矛盾した場合: **ユーザー明示指示 > alwaysApply ルール > glob ルール > 狭いドメイン rule > 広い rule**

---

## スキルディレクトリ

`C:\yk-skill\.claude\skills` にカスタムスキルが格納されている。
セッション開始時に自動ロードされる。状況に応じて適切なスキルを使用すること。

## 利用可能なスキル一覧

**SSOT（手書き表は廃止 · 2026-07-05）**

| 用途 | 参照 |
|------|------|
| カテゴリ別 · 発火要約 | `c:/yk-skill/metadata/SKILLS_INDEX.md` |
| tier · explicit_only · ペア | `c:/yk-skill/metadata/SKILL_CATALOG.md` |
| 一覧を聞く · 未使用分析 · 改善提案 | スキル `exploring-skills-yk`（「スキル一覧を教えて」等） |
| 台帳の機械再生成 | `managing-skills-yk`（ユーザー明示時のみ） |
| スキル作成・改善の実行 | `creating-skills` |

ディレクトリ: `C:\yk-skill\.claude\skills` — 各 `SKILL.md` の `description` が Cursor に常時載る。詳細は上記 SSOT を Read する。
