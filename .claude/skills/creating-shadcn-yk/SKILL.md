---
name: creating-shadcn-yk
description: shadcn/ui の init/add と Next プロジェクトへの組み込み。flowchart-web 表UI・ツールバー想定。Do NOT use for 静的surge図解HTML（creating-visual-explainers系·shadcn禁止）· workspace-ui-kit Base UI（SHADCN_UI_RULES §12）。
---

# Creating shadcn/ui（YK）

## Step 0（必須）

1. **`c:/yk-skill/rule/30_web_stack/SHADCN_UI_RULES.md`** — SSOT
2. **§2 分岐表** — 対象が flowchart（§13）か ui-kit（§12）かを先に確定
3. **Tailwind** — 必要なら `TAILWINDCSS_RULES.md`

## 手順（既存 Next · flowchart）

```bash
cd c:/yk-tool/flowchart-web-reactflow   # flowchart のみ（ui-kit は add のみ）
npx shadcn@latest init -b radix
npx shadcn@latest add <component>
```

- 公式: [Installation / Next](https://ui.shadcn.com/docs/installation/next) · [CLI](https://ui.shadcn.com/docs/cli)
- **yk-tool 単体アプリ** — `--monorepo` 不要
- **ui-kit からコンポーネントをコピーしない** — flowchart は標準 Radix バリアント

## 境界

| やりたいこと | 使うもの |
|--------------|----------|
| flowchart 表 UI | 本スキル + `SHADCN_UI_RULES` §13 |
| workspace-ui-kit | `SHADCN_UI_RULES` §12 · `WORKSPACE_RULES` |
| surge 図解 HTML | `creating-visual-explainers` 等 — **shadcn 禁止** |

---

索引: `RULE_INDEX.md` No 32
