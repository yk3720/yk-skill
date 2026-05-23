---
name: managing-skills-yk
description: >
  YK スキル台帳の再生成・整理。ユーザーが「スキル台帳を更新して」「スキル一覧を整理して」
  「SKILL_CATALOG を更新」と明示したときのみ。metadata/SKILL_CATALOG.md を
  **/SKILL.md スキャン**で再生成。通常のスキル実行では起動しない。
disable-model-invocation: true
---

# スキル台帳管理（YK）

**副作用あり** — **`/managing-skills-yk`** またはユーザーが **当ターンで台帳更新を明示**したときのみ実行する。

## 方針 SSOT

| レイヤ | 参照 |
|--------|------|
| 台帳ファイル | `c:/yk-skill/metadata/SKILL_CATALOG.md` |
| 列・tier · canonical | [references/catalog-schema.md](references/catalog-schema.md) |
| 再生成手順 | [references/regenerate-procedure.md](references/regenerate-procedure.md) |
| スキル執筆 | `c:/yk-skill/rule/10_meta/SKILL_AUTHORING_RULES.md` |
| 新規スキル作成 | `creating-skills`（完了時も同じ再生成手順） |

**却下（再掲）:** 任意スキル発火のたびに台帳を更新しない · `skills/` 直下にインデックス用 `SKILL.md` を置かない · `RULE_INDEX` にスキル全文表を転記しない。

## 混同禁止

| ファイル | 役割 |
|----------|------|
| `metadata/SKILL_CATALOG.md` | **スキル**インベントリ（本スキルが管理） |
| `metadata/surge-published-list.md` | surge 公開図解 URL |
| `yk-tool/catalog.yaml` | ツール・成果物台帳 |

## 開始ゲート

1. **Agent モード**（ファイル書き込み可）
2. 次のいずれか:
   - ユーザー発話に **台帳更新意図**がある（例: スキル台帳を更新 / SKILL_CATALOG を再生成 / スキル一覧を整理）
   - **`creating-skills` Step 8**（スキル作成・更新の完了ゲートの一部）
3. HANDOFF の「次は台帳」**だけ**では不十分（上記 2 の第 1 条のみ。Step 8 は除く）

## 手順

1. [catalog-schema.md](references/catalog-schema.md) と [regenerate-procedure.md](references/regenerate-procedure.md) を Read
2. スキャン · 機械列抽出 · `canonical` 判定（スキーマの確定済み重複表を適用）
3. `c:/yk-skill/metadata/SKILL_CATALOG.md` を全文更新
4. ユーザーに **件数サマリ**と **`canonical=no` 行**を報告

## やらないこと

- スキル本体（`SKILL.md` 本文）の品質改修 — それは `creating-skills`
- 13 フォルダの物理移動 · 重複スキルの削除（台帳で可視化のみ。削除は別依頼）
- `git commit` / `push`（明示まで）
- `RULE_INDEX.md` の更新（別タスク）

## スキル改善時

`creating-skills` Step 0〜7 · `SKILL_AUTHORING_RULES.md`
