# YK Skill Catalog（スキル台帳）

**最終更新:** 2026-05-24（`creating-proposalmap-yk` 新設）  
**管理:** `.claude/skills/managing-skills-yk/` · 再生成は [regenerate-procedure.md](../.claude/skills/managing-skills-yk/references/regenerate-procedure.md)  
**件数:** L1 **25** · nested **2** · sample **1**（計 **28** `SKILL.md`）

> **人間向けインベントリ。** Cursor ランタイムは各 `SKILL.md` の `description` を自動載せる。台帳は整理依頼・`creating-skills` 完了・本スキル明示時のみ更新する（通常発火では更新しない）。

---

## 列の意味

| 列 | 説明 |
|----|------|
| **tier** | `L1` = `.claude/skills/<folder>/SKILL.md` 直下 · `nested` = 親スキル配下 · `sample` = `sample/` |
| **canonical** | 同名重複時の正本 `yes` / 非正本 `no` / 単一 `—` |
| **explicit_only** | `disable-model-invocation: true` → ユーザー明示時のみ起動 |

詳細スキーマ: [catalog-schema.md](../.claude/skills/managing-skills-yk/references/catalog-schema.md)

---

## 本番スキル一覧

| No | name | skill_path | tier | canonical | explicit_only | notes |
|----|------|------------|------|-----------|---------------|-------|
| 1 | committing-with-git-yk | `.claude/skills/committing-with-git-yk/SKILL.md` | L1 | — | yes | Git commit（明示のみ） |
| 2 | creating-curiosity-map | `.claude/skills/creating-curiosity-map/SKILL.md` | L1 | — | no | 文系向け図解 · surge |
| 3 | creating-diagram-techmap | `.claude/skills/creating-diagram-techmap/SKILL.md` | L1 | — | no | 理系 techmap 図解 |
| 4 | creating-mermaid-yk | `.claude/skills/creating-mermaid-yk/SKILL.md` | L1 | — | no | Mermaid `.mmd` · `MERMAID_RULES` |
| 5 | creating-nextjs-yk | `.claude/skills/creating-nextjs-yk/SKILL.md` | L1 | — | no | App Router · RSC · ROUTER · Ref Plan |
| 6 | creating-react-yk | `.claude/skills/creating-react-yk/SKILL.md` | L1 | — | no | React Client · `REACT_RULES` No 36 |
| 7 | creating-reactflow-yk | `.claude/skills/creating-reactflow-yk/SKILL.md` | L1 | — | no | 表駆動 · `@xyflow/react` No 35 |
| 8 | creating-shadcn-yk | `.claude/skills/creating-shadcn-yk/SKILL.md` | L1 | — | no | shadcn init/add |
| 8b | creating-vercel-yk | `.claude/skills/creating-vercel-yk/SKILL.md` | L1 | — | no | Vercel link/env/deploy · ROUTER |
| 9 | creating-skills | `.claude/skills/creating-skills/SKILL.md` | L1 | — | no | スキル作成・改善 |
| 10 | creating-proposalmap-yk | `.claude/skills/creating-proposalmap-yk/SKILL.md` | L1 | — | no | 社内提案図解 proposalmap · surge |
| 10b | creating-visual-explainers | `.claude/skills/creating-visual-explainers/SKILL.md` | L1 | — | no | 汎用図解 · surge |
| 11 | creating-visual-explainers-fb | `.claude/skills/commenting-visual-explainers/.claude/skills/creating-visual-explainers-fb/SKILL.md` | nested | — | no | FB バンドル専用 |
| 12 | grill-me | `.claude/skills/grill-me/SKILL.md` | L1 | — | no | 設計インタビュー |
| 13 | handoff-session-work | `.claude/skills/handoff-session-work/SKILL.md` | L1 | — | no | 引き継ぎ: 終了（commit+push 含む）・再開・確認・整理 |
| 14 | managing-skills-yk | `.claude/skills/managing-skills-yk/SKILL.md` | L1 | — | yes | 本台帳の再生成 |
| 15 | personal-scheduler | `.claude/skills/personal-scheduler/SKILL.md` | L1 | — | no | 個人スケジュール · surge |
| 16 | pushing-and-pr-yk | `.claude/skills/pushing-and-pr-yk/SKILL.md` | L1 | — | yes | push / GitHub PR（明示のみ） |
| 17 | researching-web | `.claude/skills/researching-web/SKILL.md` | L1 | — | no | Web 調査 |
| 18 | re-explaining-in-chat-yk | `.claude/skills/re-explaining-in-chat-yk/SKILL.md` | L1 | — | no | チャット再説明 · `COMMUNICATION_RULES` |
| 19 | reviewing-code-yk | `.claude/skills/reviewing-code-yk/SKILL.md` | L1 | — | no | 単一パスコードレビュー（差分・PR 前） |
| 20 | reviewing-with-subagents | `.claude/skills/reviewing-with-subagents/SKILL.md` | L1 | — | no | 多視点サブエージェントレビュー |
| 21 | routing-diagram-yk | `.claude/skills/routing-diagram-yk/SKILL.md` | L1 | — | no | 図解形式の受付・質問・委譲（HTML は作らない） |
| 22 | using-playwright | `.claude/skills/using-playwright/SKILL.md` | L1 | — | no | Playwright / E2E |
| 23 | creating-pythoncode-yk | `.claude/skills/creating-pythoncode-yk/SKILL.md` | L1 | — | no | `paths: **/*.py` · PYTHON_RULES |
| 24 | setup-fb-tool | `.claude/skills/commenting-visual-explainers/.claude/skills/setup-fb-tool/SKILL.md` | nested | — | no | 図解 FB ツールセットアップ |
| 25 | starting-app-project-yk | `.claude/skills/starting-app-project-yk/SKILL.md` | L1 | — | no | 個人アプリ企画 · handoffs 一本化 · AGENTS.md |

---

## ペア・要判断

| 関連スキル | メモ |
|------------|------|
| `creating-visual-explainers`（L1）↔ `creating-visual-explainers-fb`（nested） | Phase B1/B2 完了（`name` · フォルダ名一致）。方針: [`2026-05-23_6_visual-explainers-dedup-policy.md`](../../yk-memo/handoffs/workspace-layout/archive/2026/2026-05-23_6_visual-explainers-dedup-policy.md) |
| `re-explaining-in-chat-yk` ↔ 図解3種 | チャット再説明のみ。図解 HTML は routing-diagram-yk → 各実行スキル |
| `routing-diagram-yk` ↔ 図解4種 | 形式未指定の受付。実行は curiosity / techmap / visual / fb に委譲 |
| `reviewing-code-yk` ↔ `reviewing-with-subagents` | 単一パスコードレビュー vs 多視点並列。description の Do NOT で分離 |
| `committing-with-git-yk` ↔ `pushing-and-pr-yk` | commit vs push/PR · いずれも `explicit_only`（`disable-model-invocation`） |
| `creating-react-yk` ↔ `creating-reactflow-yk` | React 一般 vs 表駆動 `@xyflow/react`。description の Do NOT で分離 |
| `creating-react-yk` ↔ `creating-nextjs-yk` | `components/` Hooks vs `app/` RSC 境界 |

**バンドル:** `commenting-visual-explainers/` は L1 の `SKILL.md` を持たず、nested スキル 2 件（`creating-visual-explainers-fb` · `setup-fb-tool`）。

---

## sample（本番外）

| No | name | skill_path | tier | canonical | explicit_only | notes |
|----|------|------------|------|-----------|---------------|-------|
| S1 | diagram-maji | `sample/majiai-diagram/.claude/skills/diagram-maji/SKILL.md` | sample | — | no | 本気AI ブランド図解サンプル |

---

## 関連（混同禁止）

| ファイル | 役割 |
|----------|------|
| [surge-published-list.md](surge-published-list.md) | surge 公開図解の URL 台帳 |
| `c:/yk-tool/catalog.yaml` | ツール・成果物レジストリ（スキルではない） |
| `c:/yk-skill/rule/RULE_INDEX.md` | rule カタログ（スキル全文は載せない） |
