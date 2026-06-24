---
name: creating-nextjs-yk
description: Next.js（App Router）の作成・更新。RSC/`use client`境界・`app/`ルート・データ取得索引。発火例「Next.jsで」「app/page」「layout.tsx」。Do NOT use for components/Hooks本体（creating-react-yk）· lib/flowchart/React Flow（creating-reactflow-yk）· .mmd · surge図解。
---

# Creating Next.js（YK）

**品質方針:** `NEXTJS_RULES.md` §8 ゲート未通過の完了報告は禁止。

## Step 0: 入口（必須）

1. **`NEXTJS_RULES.md`** — L1（ROUTER **tier** で Read 範囲を決める）
2. **本 SKILL.md**
3. **[ROUTER.md](references/ROUTER.md)** — tier / tag · bundled docs · Ref Plan テンプレ

**同一ターンで `app/` + `components/**` を触る場合:** lead は **`creating-nextjs-yk`**。components 側は Ref Plan の **`委譲: creating-react-yk`** を列挙し、別 Ref Plan または同一 Plan 内で `REACT_RULES` を `load` する。

## Step 0.1: Ref Plan → load（Write/StrReplace 前）

1. ROUTER で tier / tags を決定
2. **Ref Plan をチャットに出力**（未出力のまま `app/` を編集しない）
3. Ref Plan の **`load` に列挙したものだけ** Read

→ テンプレ: [ROUTER.md §7](references/ROUTER.md#7-ref-plan-テンプレート) · 作業フロー: [ROUTER.md §1](references/ROUTER.md#1-手順毎タスク)

**委譲（Hooks · `components/**`）:** `creating-react-yk` · RSC 境界は L1 §5。

**flowchart-studio の `app/` のみ:** L1 §6 + 本スキル。`components/flowchart` · `lib/flowchart` は **`creating-reactflow-yk`**（ROUTER tag `flowchart-web` は RF 作業時のみ）。

## 作業プロセス

ROUTER §1 と同じ: 層固定 → L1 MUST → §8 ゲート → §9 完了報告。

## 方式境界

| やりたいこと | 使うもの |
|--------------|----------|
| `app/` · layout/page · Route Handler | **本スキル + NEXTJS_RULES** |
| Hooks · `components/**`（flowchart 以外） | `creating-react-yk` · `REACT_RULES` + L1 §5 |
| `@xyflow/react` · `lib/flowchart/` | `creating-reactflow-yk` · `REACTFLOW_RULES` |
| shadcn 部品追加 | `creating-shadcn-yk` |
| surge 図解 HTML | 図解スキル系 |

## L0 入口

| パス | 優先 entry |
|------|------------|
| `flowchart-studio/app/**` | **`reactflow-dev-entry.mdc`**（Next シェルは本スキル） |
| `workspace-ui-kit/app/**` | `workspace-dev-entry.mdc` + 本スキル · ROUTER tag `ui-kit-shell` |
| その他 `**/app/**` | `nextjs-dev-entry.mdc` |
| `next.config.*` のみ | 本スキル（entry glob 外 — description 発火または明示 @） |

---

索引: `RULE_INDEX.md` No 31 · No 36（`REACT_RULES` 併読）
