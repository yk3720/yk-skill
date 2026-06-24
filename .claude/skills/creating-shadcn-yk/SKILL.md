---
name: creating-shadcn-yk
description: shadcn/ui の init/add と Next プロジェクトへの組み込み。発火例「shadcn init」「components.json」「npx shadcn add」「components/ui」。flowchart 表UI・ui-kit add（§12）。Do NOT use for 静的surge図解HTML（creating-visual-explainers系·shadcn禁止）· ui-kit 既存の init/re-init（§12-3）。
---

# Creating shadcn/ui（YK）

**品質方針:** `SHADCN_UI_RULES.md` §15 ゲート未通過の完了報告は禁止。

## Step 0: 入口（必須）

1. **`SHADCN_UI_RULES.md`** — L1（**§2 分岐を先に確定**）
2. **本 SKILL.md**
3. **[ROUTER.md](references/ROUTER.md)** — tier / tag · Ref Plan テンプレ

**同一ターンで `components/ui` + `app/` を触る場合:** lead は **`creating-nextjs-yk`**。shadcn 側は Ref Plan の **`委譲: creating-shadcn-yk`** を列挙する。

## Step 0.1: Ref Plan → load（Write/StrReplace / CLI 前）

1. ROUTER で tier / tags を決定
2. **Ref Plan をチャットに出力**（未出力のまま `components/ui` を編集しない）
3. Ref Plan の **`load` に列挙したものだけ** Read

→ テンプレ: [ROUTER.md §7](references/ROUTER.md#7-ref-plan-テンプレート)

**委譲:** Hooks · `components/**`（ui 以外）→ `creating-react-yk` · RSC → L1 `NEXTJS_RULES` §5。

## 作業プロセス

ROUTER §1 と同じ: §2 確定 → tier/tag → Ref Plan → load → §15 ゲート → 完了報告。

## CLI（実行 SSOT）

**cwd を必ず明示。** ui-kit 既存は **`add` のみ**（init / `-b` 禁止）。

### flowchart-studio（初回 · Radix）

```bash
cd c:/yk-application/flowchart-studio   # または flowchart-web-mermaid
npx shadcn@latest init -t next -b radix -y -d
npx shadcn@latest add button --dry-run   # 確認後
npx shadcn@latest add button
```

初回は **1 コンポーネント**だけ add して共存確認（L1 §13）。`globals.css` は L1 §8-2 を満たすこと。

### ui-kit（Base UI · 既存）

```bash
cd c:/yk-tool/workspace-ui-kit
npx shadcn@latest add <component> --diff    # 上書き前必須
# --overwrite はユーザー明示まで禁止
```

### 共通

- 公式: [Installation / Next](https://ui.shadcn.com/docs/installation/next) · [CLI](https://ui.shadcn.com/docs/cli)
- **yk-tool 単体アプリ** — `--monorepo` 不要
- flowchart から ui-kit の `components/ui` を **コピー禁止**

## 方式境界

| やりたいこと | 使うもの |
|--------------|----------|
| shadcn init / add / `components/ui` | **本スキル + SHADCN_UI_RULES** |
| `app/` · layout/page | `creating-nextjs-yk` · `NEXTJS_RULES` |
| Hooks · ui 以外の `components/**` | `creating-react-yk` |
| `@xyflow/react` · `lib/flowchart/` | `creating-reactflow-yk` |
| surge 図解 HTML | 図解スキル系 — **shadcn 禁止** |

## L0 入口

| パス | 優先 entry |
|------|------------|
| `flowchart-studio/components/ui/**` | **`reactflow-dev-entry.mdc`** → 本スキル |
| `workspace-ui-kit/components/ui/**` | **`workspace-dev-entry.mdc`** → 本スキル |
| その他 `**/components/ui/**` · `components.json` | `shadcn-dev-entry.mdc` |

---

索引: `RULE_INDEX.md` No 32 · No 31（Next 併用）
