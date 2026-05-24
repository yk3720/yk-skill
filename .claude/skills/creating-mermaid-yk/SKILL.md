---
name: creating-mermaid-yk
description: Mermaid DSL（.mmd）の作成・更新・検証。発火例「mermaidで図」「.mmdを書いて」。Do NOT use for flowchart-web表駆動（creating-reactflow-yk）· surge図解HTMLのみ。
---

# Creating Mermaid（YK）

**品質方針:** `MERMAID_RULES.md` §7 ゲート未通過の完了報告は禁止。

## Step 0: ルールを読む（必須・この順）

1. **`c:/yk-skill/rule/45_mermaid/MERMAID_RULES.md`** — L1 SSOT（毎回・最初）
2. **本 SKILL.md** — 手順
3. **[references/ROUTER.md](references/ROUTER.md)** — tier / tag / Ref Plan（**ロード規則の SSOT**）
4. **Ref Plan で列挙したパスのみ** Read（公式ページは tag 時のみ）

## Step 0.1: Ref Plan（.mmd 編集前・必須）

**Write / StrReplace の前に** Ref Plan を出力。未出力のまま `.mmd` を編集しない。  
**質問のみ・Read のみ**のときは不要。

→ テンプレは [ROUTER.md §7](references/ROUTER.md#7-ref-plan-テンプレート)。tier 決定は [ROUTER §2](references/ROUTER.md#2-tier--floor)。

## 作業プロセス（`MERMAID_RULES.md` §6 と同型）

| Step | 内容 |
|------|------|
| 1 | 目的・読者・成功条件を固定 |
| 2 | 図種 · 方向 · ファイル分割（ROUTER tag 推定） |
| 3 | 実装（骨格 → 分岐 → スタイル） |
| 4 | §7 品質ゲート（mmdc / Live Editor — Shell はユーザー `test` 明示時） |
| 5 | §8 完了報告 + **読んだ refs** |

## 方式境界

**図モダリティ SSOT:** `MERMAID_RULES.md` §1.5 ↔ [`flowchart-web-reactflow/README.md`](c:/yk-tool/flowchart-web-reactflow/README.md) §図モダリティ

| やりたいこと | 使うもの |
|--------------|----------|
| 表・CSV → Mermaid プレビュー（比較 · ADR-010） | [`flowchart-web-mermaid/README.md`](c:/yk-tool/flowchart-web-mermaid/README.md) · `creating-reactflow-yk`（**本スキル非使用**） |
| 表・CSV → React Flow · PNG/SVG 即出力 | [`flowchart-web-reactflow/README.md`](c:/yk-tool/flowchart-web-reactflow/README.md) · `creating-reactflow-yk` |
| テキスト SSOT の図（`.mmd`） | **本スキル + MERMAID_RULES** |
| Python デスクトップ業務ツール | `creating-pythoncode-yk` |
| surge 図解 HTML | `creating-visual-explainers` 等（本スキル非使用） |

## L0 入口

`yk-skill` · `yk-memo` — `.cursor/rules/mermaid-dev-entry.mdc`（`**/*.mmd` 編集時に自動適用）

---

索引: `c:/yk-skill/rule/RULE_INDEX.md` No 45 · 参照実装: `creating-pythoncode-yk`
