# YK Skill Catalog（スキル台帳）

**最終更新:** 2026-05-23（Phase B1: `creating-visual-explainers-fb`）  
**管理:** `.claude/skills/managing-skills-yk/` · 再生成は [regenerate-procedure.md](../.claude/skills/managing-skills-yk/references/regenerate-procedure.md)  
**件数:** L1 **12** · nested **3** · sample **1**（計 **16** `SKILL.md`）

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
| 4 | creating-skills | `.claude/skills/creating-skills/SKILL.md` | L1 | — | no | スキル作成・改善 |
| 5 | creating-visual-explainers | `.claude/skills/creating-visual-explainers/SKILL.md` | L1 | — | no | 汎用図解 · surge |
| 6 | creating-visual-explainers-fb | `.claude/skills/commenting-visual-explainers/.claude/skills/creating-visual-explainers/SKILL.md` | nested | — | no | FB バンドル専用 · フォルダ名は legacy |
| 7 | grill-me | `.claude/skills/grill-me/SKILL.md` | L1 | — | no | 設計インタビュー |
| 8 | handoff-session-work | `.claude/skills/handoff-session-work/SKILL.md` | L1 | — | no | 引き継ぎ: 終了・再開・確認・整理 |
| 9 | managing-skills-yk | `.claude/skills/managing-skills-yk/SKILL.md` | L1 | — | yes | 本台帳の再生成 |
| 10 | personal-scheduler | `.claude/skills/personal-scheduler/SKILL.md` | L1 | — | no | 個人スケジュール · surge |
| 11 | researching-web | `.claude/skills/researching-web/SKILL.md` | L1 | — | no | Web 調査 |
| 12 | reviewing-with-subagents | `.claude/skills/reviewing-with-subagents/SKILL.md` | L1 | — | no | 多視点サブエージェントレビュー |
| 13 | using-playwright | `.claude/skills/using-playwright/SKILL.md` | L1 | — | no | Playwright / E2E |
| 14 | creating-pythoncode-yk | `.claude/skills/creating-Pythoncode/.claude/skills/creating-Pythoncode-yk/SKILL.md` | nested | — | no | 親: `creating-Pythoncode/`（L1 SKILL なし） |
| 15 | setup-fb-tool | `.claude/skills/commenting-visual-explainers/.claude/skills/setup-fb-tool/SKILL.md` | nested | — | no | 図解 FB ツールセットアップ |

---

## ペア・要判断

| 関連スキル | メモ |
|------------|------|
| `creating-visual-explainers`（L1）↔ `creating-visual-explainers-fb`（nested） | Phase B1 で `name` 分離済み。方針: [`2026-05-23_6_visual-explainers-dedup-policy.md`](../../yk-memo/handoffs/workspace-layout/2026-05-23_6_visual-explainers-dedup-policy.md) · フォルダリネーム（B2）は未実施 |

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
