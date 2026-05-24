---
name: creating-react-yk
description: React コンポーネント・Hooks・Client UI の作成・更新。発火例「useState」「カスタムHook」「Clientコンポーネント」。Do NOT use for app/ルート（creating-nextjs-yk）· lib/flowchart/· @xyflow/react（creating-reactflow-yk）· surge図解。
---

# Creating React（YK · Client コンポーネント）

**品質方針:** `REACT_RULES.md` §6 ゲート未通過の完了報告は禁止。

## Step 0: ルールを読む（必須・この順）

1. **`c:/yk-skill/rule/30_web_stack/REACT_RULES.md`** — L1 SSOT（毎回・最初）
2. **本 SKILL.md** — 手順
3. **[references/ROUTER.md](references/ROUTER.md)** — tier / tag / Ref Plan（**ロード規則 SSOT**）
4. **RSC / `"use client"` が絡む場合** — [`NEXTJS_RULES.md`](../../../rule/30_web_stack/NEXTJS_RULES.md) **§5** を追加 Read
5. **Ref Plan の `load` に列挙したパスのみ** Read

## Step 0.1: Ref Plan（Write/StrReplace 前・必須）

**Write / StrReplace の前に** Ref Plan を出力。未出力のまま Client コードを編集しない。  
**質問のみ・Read のみ**のときは不要。

→ テンプレは [ROUTER.md §7](references/ROUTER.md#7-ref-plan-テンプレート)。

## 作業プロセス

| Step | 内容 |
|------|------|
| 1 | 触る層を固定（`components/` vs 委譲先） |
| 2 | Rules of React MUST（L1 §2）を満たす実装 |
| 3 | §6 品質ゲート |
| 4 | §7 完了報告 + **読んだ refs** |

## 方式境界

| やりたいこと | 使うもの |
|--------------|----------|
| Hooks · 合成 · `components/**` | **本スキル + REACT_RULES** |
| `app/` · ルーティング · RSC 境界 | `creating-nextjs-yk` · `NEXTJS_RULES` §5 |
| flowchart · `@xyflow/react` | `creating-reactflow-yk` · `REACTFLOW_RULES` |
| shadcn 部品追加 | `creating-shadcn-yk` |
| surge 図解 HTML | `creating-visual-explainers` 等 |

## L0 入口

- `workspace-ui-kit` → `workspace-dev-entry.mdc`（本スキルへリンク）
- `flowchart-web-*` の `components/flowchart` → `reactflow-dev-entry.mdc`

---

索引: `c:/yk-skill/rule/RULE_INDEX.md` No 36
