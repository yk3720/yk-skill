---
name: exploring-skills-yk
description: >
  YK スキルの一覧・発火条件の説明、未使用分析、改善提案（実行は creating-skills へ）。
  発火例「スキル一覧」「どんなスキルがある」「〇〇に使えるスキルは」「使ってないスキル」「スキル監査」「スキル改善提案」。
  Do NOT use for 台帳ファイルの機械再生成（managing-skills-yk）、スキル本文の修正実行のみ（creating-skills）、
  コードレビュー（reviewing-code-yk）。
---

# Exploring Skills（YK）

**Read-only が基本。** ファイル書き込みは `skill-usage.yaml` 更新（M2）· `creating-skills` 委譲（M3）のみ。

## SSOT（着手時に Read）

| 順 | ファイル | 用途 |
|----|----------|------|
| 1 | `c:/yk-skill/metadata/SKILLS_INDEX.md` | カテゴリ別 · 発火条件（人間向け索引） |
| 2 | `c:/yk-skill/metadata/SKILL_CATALOG.md` | tier · explicit_only · ペア関係 |
| 3 | `c:/yk-skill/metadata/skill-categories.yaml` | カテゴリ分類 |
| 4 | `c:/yk-skill/metadata/skill-usage.yaml` | 利用メモ（あれば） |

詳細が必要なときだけ該当 `SKILL.md` の YAML `description` を Read する。

## モード

| モード | 発火例 | 手順 |
|--------|--------|------|
| **M1 一覧・説明** | スキル一覧 · どんなスキル · 図解系は？ | [query-modes.md](references/query-modes.md) §M1 |
| **M2 未使用分析** | 使ってないスキル · スキル監査 · 発火条件の見直し | [unused-analysis.md](references/unused-analysis.md) |
| **M3 改善提案** | スキル改善提案 · ヘルスチェック | [health-audit.md](references/health-audit.md) → 修正は `creating-skills` |

複数モードが絡むときは **M1 → M2 → M3** の順。ユーザーが「改善まで」と言ったときだけ M3 のあと `creating-skills` を起動する。

## 境界

| 使う | 使わない |
|------|----------|
| スキルの探し方 · 発火条件の説明 | `SKILL_CATALOG` の機械再生成 |
| 未使用候補と理由分類 | スキル削除の独断実行 |
| 改善提案リスト | スキル本文の直接大規模改稿（→ creating-skills） |

## 関連スキル

- `managing-skills-yk` — 台帳再生成（ユーザー明示 · `disable-model-invocation`）
- `creating-skills` — スキル新規 · 改善の実行 · Step 8 で台帳更新
