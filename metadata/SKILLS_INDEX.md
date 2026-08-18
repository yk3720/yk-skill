# YK スキル索引（人間・エージェント向け SSOT）

**最終更新:** 2026-08-18（`writing-in-my-voice-yk` 追加）  
**機械台帳:** [SKILL_CATALOG.md](./SKILL_CATALOG.md) · **カテゴリ:** [skill-categories.yaml](./skill-categories.yaml)  
**図:** [diagrams/skills-overview.mmd](./diagrams/skills-overview.mmd) · [skills-routing-pairs.mmd](./diagrams/skills-routing-pairs.mmd) · [briefmap-skills-overview.html](./briefmap-skills-overview.html)  
**聞く:** 「スキル一覧」「〇〇に使えるスキルは？」→ `exploring-skills-yk`

> 発火条件の正本は各 `SKILL.md` の YAML `description`。本索引は要約。矛盾時は `description` を優先する。

---

## 図解・可視化

| name | 発火（要約） | 明示のみ | 用途 |
|------|-------------|----------|------|
| `routing-diagram-yk` | 「図解して」（形式未指定） | no | 形式選択のみ · HTML は作らない |
| `creating-curiosity-map` | curiositymap · 文系向け | no | 文系 HTML 図解 → surge |
| `creating-diagram-techmap` | techmap · 技術を図解 | no | 理系 HTML 図解 → surge |
| `creating-proposalmap-yk` | proposalmap · 社内周知 | no | 社内非専門職向け図解 |
| `creating-briefmap-yk` | briefmap · 上司向け | no | 状況+判断依頼のブリーフ図解 |
| `creating-visual-explainers` | 汎用で図解 · visual | no | 形式未指定の汎用 HTML 図解 |
| `creating-mermaid-yk` | mermaidで図 · .mmd | no | Mermaid DSL |
| `creating-reactflow-yk` | flowchart-web · 表駆動 | no | @xyflow/react 表駆動フロー |
| `creating-visual-explainers-fb` | （nested · FB バンドル） | no | 図解 FB 付き版 |
| `setup-fb-tool` | （nested · FB 初回） | no | FB ツールセットアップ |

---

## Web 開発

| name | 発火（要約） | 明示のみ | 用途 |
|------|-------------|----------|------|
| `creating-nextjs-yk` | Next.js · app/page | no | App Router · RSC |
| `creating-react-yk` | useState · Client UI | no | React コンポーネント · Hooks |
| `creating-shadcn-yk` | shadcn init/add | no | shadcn/ui |
| `creating-vercel-yk` | vercel link/env/deploy | no | Vercel デプロイ |
| `creating-supabase-yk` | Supabase · RLS · auth | no | Supabase Auth · DB |

---

## Python

| name | 発火（要約） | 明示のみ | 用途 |
|------|-------------|----------|------|
| `creating-pythoncode-yk` | Pythonで · ツールを作って | no | `.py` 作成・更新 |

---

## テスト・レビュー

| name | 発火（要約） | 明示のみ | 用途 |
|------|-------------|----------|------|
| `designing-playwright-tests-yk` | E2Eで何をテスト · 方針 | no | E2E 設計（§13） |
| `using-playwright` | Playwright · spec | no | E2E 執筆・実行（§12） |
| `reviewing-code-yk` | コードレビュー · PR前 | no | 単一パスコードレビュー |
| `reviewing-with-subagents` | サブエージェントでレビュー · 多視点 | no | 3+レンズ並列レビュー（修正なし） |
| `optimizing-code-yk` | コードチェック · 最適化 | no | Web 調査+サブエージェント最適化 |

---

## Git・セッション

| name | 発火（要約） | 明示のみ | 用途 |
|------|-------------|----------|------|
| `committing-with-git-yk` | コミットして | **yes** | git commit |
| `pushing-and-pr-yk` | push · PRを作って | **yes** | push · gh pr |
| `handoff-session-work` | 引き継ぎ · 続きから · archive | no | handoffs 運用 |
| `starting-app-project-yk` | 新しいアプリ · AGENTS.md | no | 個人アプリ企画パック |

---

## 調査・計画・説明

| name | 発火（要約） | 明示のみ | 用途 |
|------|-------------|----------|------|
| `researching-web` | ウェブで調べて | no | Web 調査 |
| `grill-me` | グリルして · 計画を詰めて | no | 設計インタビュー |
| `re-explaining-in-chat-yk` | もう一度説明 · 平易に | no | チャット再説明 |

---

## 文書・提案

| name | 発火（要約） | 明示のみ | 用途 |
|------|-------------|----------|------|
| `writing-proposals` | 提案文を作って | no | 長い提案文書 |
| `writing-in-my-voice-yk` | 文章を保存 · 特徴を書き出して · **私の文体で** · Teams | no | 確定稿フォルダの保存・特徴・起草（チャット / メール） |
| `writing-internal-mail-yk` | 私の文体で**メール** | no | メール発火の入口（手順は `writing-in-my-voice-yk`） |
| `refining-copy-yk` | 文章を洗練 | no | 既存文の多視点レビュー→修正ループ |

---

## スキル・ルール・資料メタ

| name | 発火（要約） | 明示のみ | 用途 |
|------|-------------|----------|------|
| `creating-skills` | スキルを作って · 改善 | no | スキル作成・改善実行 |
| `managing-skills-yk` | スキル台帳を更新 | **yes** | SKILL_CATALOG 再生成 |
| `exploring-skills-yk` | スキル一覧 · 使ってないスキル · 改善提案 | no | 索引・監査（Read 基本） |
| `distilling-rules-yk` | ルールに追記 | no | 実装→L1 ルール |
| `organizing-documents-yk` | 資料整合 · doc-sync | no | 資料 M1/M2 |

---

## 個人ツール

| name | 発火（要約） | 明示のみ | 用途 |
|------|-------------|----------|------|
| `personal-scheduler` | スケジュールを更新 | no | 個人予定 → surge |

---

## よくあるペア（詳細は SKILL_CATALOG）

| 使い分け | メモ |
|----------|------|
| `routing-diagram-yk` → 図解4種 | 受付 vs 実行 |
| `designing-playwright-tests-yk` ↔ `using-playwright` | 設計 vs spec |
| `reviewing-code-yk` ↔ `reviewing-with-subagents` | 1周 vs 多視点 |
| `refining-copy-yk` ↔ `reviewing-with-subagents` | 修正ループあり vs なし |
| `writing-proposals` ↔ `writing-in-my-voice-yk` | 長文提案 vs 短い実務文（保存・特徴・起草） |
| `writing-in-my-voice-yk` ↔ `writing-internal-mail-yk` | 手順の正本 vs メール発火の入口 |
| `writing-in-my-voice-yk` ↔ `refining-copy-yk` | 新規起草 · 保存 vs 既存文の洗練 |
| `managing-skills-yk` ↔ `exploring-skills-yk` | 台帳書込 vs 一覧・監査 |

---

## sample（本番外）

| name | 用途 |
|------|------|
| `diagram-maji` | 本気AI ブランド図解サンプル |
