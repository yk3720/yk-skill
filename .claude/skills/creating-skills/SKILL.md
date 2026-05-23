---
name: creating-skills
description: スキルを作成・更新・改善するスキル。「スキルを作って」「このスキルを改善して」「スキルを更新して」など依頼された際やスキルを更新する際に使用する。 
---

# Skill Creator

**品質方針**: スキル作成は時間より品質を優先する。手順のスキップや品質チェックの省略は禁止。全ステップを確実に実行し、品質チェックを通過してから完了とする。

## 必読（省略禁止）

| 順 | 参照 | 役割 |
|----|------|------|
| 1 | `c:/yk-skill/rule/10_meta/SKILL_AUTHORING_RULES.md` | **執筆規範 SSOT**（構造 · description · 簡潔さ · チェックリスト） |
| 2 | [references/principles.md](references/principles.md) | 種類判断 · 洗練 · コード vs プロンプト（補助） |
| 3 | [references/ssot-audit.md](references/ssot-audit.md) | SSoT 監査ゲート |
| 4 | [references/exemplar.md](references/exemplar.md) | 模範例 · 品質チェックリスト |
| 5 | [references/patterns.md](references/patterns.md) | 設計パターン · サイズ目安 |

## 作成プロセス

### Step 0: 必読を読む

1. **`SKILL_AUTHORING_RULES.md` を最初に Read**（§2〜§5 · §11 を最低限。必要なら全文）
2. 上表の 2〜5（references）を Read。省略禁止。

### Step 1: 種類を判断

汎用スキルかプロジェクト固有スキルかを判断する。

→ [principles.md](references/principles.md)（スキルの種類）

### Step 2: 情報を分離

SKILL.md に置く情報と references/ に置く情報を分離する。

→ [patterns.md](references/patterns.md)（ディレクトリパターン、3段階ローディング）

### Step 3: 洗練

核心原則に基づいてスキルの内容を精査する。

→ [principles.md](references/principles.md)（洗練、簡潔性）

### Step 4: SSoT 監査（ゲート）

**SSoT 監査を通過するまで次のステップに進めない。**

[ssot-audit.md](references/ssot-audit.md) の全ステップを実行し、違反がないことを確認する。違反が見つかったら修正してから再監査。

### Step 5: 品質チェック

[exemplar.md](references/exemplar.md) のチェックリストを全項目確認する。未通過の項目があれば修正。

### Step 6: ハードコード・不整合レビュー（ゲート）

**このレビューを通過するまで完了としない。**

作成したスキルに以下の問題がないか最終確認する:

1. **ハードコードされた詳細情報がないか** — 参照先を読めばわかる具体的な値・構造・手順がスキル内にベタ書きされていないか
2. **参照先変更時の不整合リスクがないか** — 参照先が更新されたとき、スキル内の記述が古くなる箇所がないか

→ [ssot-audit.md](references/ssot-audit.md)（ハードコード・不整合レビュー）

### Step 7: 評価と反復

スキルを書いて終わりにしない。実際の使用を観察して改善する。

→ [exemplar.md](references/exemplar.md)（評価と反復プロセス）

### Step 8: スキル台帳を再生成（完了ゲート）

**新規作成・更新・改善の作業が完了したら必ず実行する。** 台帳手順の SSOT は **`managing-skills-yk`**（ここにインライン手順を書かない）。

1. [managing-skills-yk/SKILL.md](../managing-skills-yk/SKILL.md) の「手順」に従う
2. 詳細は [regenerate-procedure.md](../managing-skills-yk/references/regenerate-procedure.md) と [catalog-schema.md](../managing-skills-yk/references/catalog-schema.md) を Read
3. **`creating-skills` 完了ターン**では台帳専用のユーザー明示は不要（本 Step が手順の一部）
4. 報告は `managing-skills-yk` と同様（件数サマリ · `canonical=no` 行があれば一覧）

**台帳だけ更新したいとき:** `managing-skills-yk` を直接使う（ユーザーが当ターンで明示）。
