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

### 図解・可視化

| スキル | 発火条件 | 用途 |
|--------|----------|------|
| `routing-diagram-yk` | 「図解して」（形式未指定） | 読者・形式を判定して適切な図解スキルへ委譲 |
| `creating-curiosity-map` | 「curiositymapで」「文系向けに」「初心者向けに」 | 文系の大人向けHTML図解 → surge.sh |
| `creating-diagram-techmap` | 「techmapで」「技術を図解して」 | 理系エンジニア向け技術解説HTML図解 → surge.sh |
| `creating-proposalmap-yk` | 「proposalmapで」「企画書形式で」「社内周知で」 | 社内非専門職向けHTML図解 → surge.sh |
| `creating-visual-explainers` | 「汎用で図解」「visualで図解」 | 形式指定なし汎用HTML図解 → surge.sh |
| `commenting-visual-explainers` | 図解ページへのフィードバック機能追加 | surge図解にコメント・FB機能を付加 |
| `creating-mermaid-yk` | 「mermaidで図」「.mmdを書いて」 | Mermaid DSL（.mmd）作成・更新・検証 |
| `creating-reactflow-yk` | 「flowchart-web」「表駆動フロー」「layoutGrid」 | @xyflow/react 表駆動フローチャート |

### 開発・実装

| スキル | 発火条件 | 用途 |
|--------|----------|------|
| `creating-pythoncode-yk` | 「Pythonで」「ツールを作って」 | Python コード作成・更新・修正 |
| `creating-nextjs-yk` | 「Next.jsで」「app/page」「layout.tsx」 | Next.js（App Router）作成・更新 |
| `creating-react-yk` | 「useState」「カスタムHook」「Clientコンポーネント」 | React コンポーネント・Hooks・Client UI |
| `creating-reactflow-yk` | 「flowchart-web」「toReactFlow」 | @xyflow/react フローチャート |
| `creating-shadcn-yk` | 「shadcn init」「npx shadcn add」「components/ui」 | shadcn/ui 導入・追加 |
| `creating-vercel-yk` | 「vercel link」「vercel env」「Vercelにデプロイ」 | Vercel link/env/deploy |
| `creating-skills` | 「スキルを作って」「スキルを改善して」 | スキル作成・更新・改善 |
| `managing-skills-yk` | 「SKILL_CATALOGを更新」（disable-model-invocation） | スキル台帳の再生成・処理 |

### テスト・レビュー

| スキル | 発火条件 | 用途 |
|--------|----------|------|
| `designing-playwright-tests-yk` | 「E2Eで何をテストするか設計」「テストピラミッド」 | Playwright E2E テスト設計 |
| `using-playwright` | 「Playwrightでテスト」「E2E」「specを書いて」 | Playwright E2E spec 実行 |
| `reviewing-code-yk` | 「コードレビューして」「PRを見て」「差分をレビュー」 | 単一パスコードレビュー（エージェント1回） |
| `reviewing-with-subagents` | 「サブエージェントでレビュー」「複数視点でレビュー」 | 複数視点並列レビュー（3+レンズ） |

### Git・セッション管理

| スキル | 発火条件 | 用途 |
|--------|----------|------|
| `committing-with-git-yk` | 「コミットして」「日本語でコミット」（disable-model-invocation） | YK向け git commit（日本語メッセージ） |
| `pushing-and-pr-yk` | 「pushして」「PRを作って」「プルリクを出して」 | git push + GitHub PR 作成 |
| `handoff-session-work` | 「引き継ぎして」「セッション終了」「続きから」 | セッション引き継ぎ・再開・確認・処理 |
| `starting-app-project-yk` | 「新しいアプリを始めて」「設計フォルダを作って」 | 個人アプリ設計パック新設・handoffs 一本化 |

### 調査・計画・説明

| スキル | 発火条件 | 用途 |
|--------|----------|------|
| `researching-web` | 「ウェブで調べて」「公式ドキュメントを確認」 | Web調査・収集（スコア10点まで再帰） |
| `grill-me` | 「グリルして」「grill me」「計画を詰めて」 | 計画・設計を1問ずつ深掘り |
| `re-explaining-in-chat-yk` | 「もう一度説明して」「さっぱり整理して」 | 直前の作業・技術説明を簡潔に再説明 |
| `distilling-rules-yk` | 「ルールに追記して」「今回の気づきを整理して」「コードから学んだことを記録して」 | 実装の気づきを L1 ルールファイルへ追記 |
| `personal-scheduler` | 「スケジュールを更新」「今日の予定を整理」 | 個人スケジュール → surge.sh 公開 |
