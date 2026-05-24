---
name: creating-reactflow-yk
description: 表駆動フローチャート（@xyflow/react）の作成・更新。発火例「flowchart-web」「表駆動フロー」「layoutGrid」「toReactFlow」。Do NOT use for 汎用Reactコンポーネント（creating-react-yk）· .mmd/Mermaid（creating-mermaid-yk）· surge図解HTML · workspace-ui-kit。
---

# Creating React Flow（YK · 表駆動）

**品質方針:** `REACTFLOW_RULES.md` §6 ゲート未通過の完了報告は禁止。

## Step 0: ルールを読む（必須・この順）

1. **`c:/yk-skill/rule/35_reactflow/REACTFLOW_RULES.md`** — L1 SSOT（毎回・最初）
2. **本 SKILL.md** — 手順
3. **[references/ROUTER.md](references/ROUTER.md)** — tier / tag / Ref Plan（**ロード規則 SSOT**）
4. **Ref Plan の `load` に列挙したパスのみ** Read（公式は tag 時のみ）

## Step 0.1: Ref Plan（Write/StrReplace 前・必須）

**Write / StrReplace の前に** Ref Plan を出力。未出力のまま flowchart コードを編集しない。  
**質問のみ・Read のみ**のときは不要。

→ テンプレは [ROUTER.md §7](references/ROUTER.md#7-ref-plan-テンプレート)。tier は [ROUTER §2](references/ROUTER.md#2-tier--floor)。

## 作業プロセス（`REACTFLOW_RULES.md` と同型）

| Step | 内容 |
|------|------|
| 1 | 症状・層を固定（ROUTER §4 → L1 §3-5 · tag） |
| 2 | 正本は表 — Canvas 手修正を主経路にしない |
| 3 | 実装（domain → adapter → UI の順 · Canvas は `FlowCanvas` パターン拡張） |
| 4 | §6 品質ゲート |
| 5 | §7 完了報告 + **読んだ refs** |

## 方式境界

**図モダリティ SSOT:** `REACTFLOW_RULES.md` §2 ↔ [`flowchart-web-reactflow/README.md`](c:/yk-tool/flowchart-web-reactflow/README.md) §図モダリティ

| やりたいこと | 使うもの |
|--------------|----------|
| 表 · CSV → React Flow · PNG/SVG | **本スキル + REACTFLOW_RULES** |
| テキスト SSOT（`.mmd`） | `creating-mermaid-yk` |
| Next シェル（`app/`） | `creating-nextjs-yk` · `NEXTJS_RULES` §6 |
| Client Hooks（`components/flowchart`） | `creating-react-yk` · `REACT_RULES` |
| shadcn 表 UI | `creating-shadcn-yk`（未導入時は触らない） |
| surge 図解 HTML | `creating-visual-explainers` 等 |

## L0 入口

L0 正本: `c:/yk-skill/.cursor/rules/reactflow-dev-entry.mdc`（`yk-memo` · `yk-tool` に同期コピー）

---

索引: `c:/yk-skill/rule/RULE_INDEX.md` No 35 · 参照実装: `c:/yk-tool/flowchart-web-reactflow/`
