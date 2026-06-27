# shadcn/ui — flowchart-studio（Radix）

**SSOT:** 本ファイル · **索引:** [`SHADCN_UI_RULES.md`](../SHADCN_UI_RULES.md) §13

**現状:** shadcn **導入済**（2026-05-24 · `radix-nova` · `button` 初回 add · 既存 UI は段階的に shadcn 化）。ui-kit から **コピー禁止**。

---

## 13-1. 初回導入チェックリスト

1. L1 §2 で **flowchart** であることを確認  
2. `npx shadcn@latest init -b radix`（`creating-shadcn-yk` と併用）  
3. `app/globals.css` に [`SHADCN_CORE_SETUP.md`](SHADCN_CORE_SETUP.md) §8-2 の v4 必須行（`@custom-variant dark` 含む）  
4. 最初の 1 コンポーネントだけ `add`（例: `button`）して既存 UI と共存確認  
5. [`REACTFLOW_RULES.md`](../../35_reactflow/REACTFLOW_RULES.md) を併読 — 表編集ロジックは `lib/flowchart/` が SSOT  

```bash
cd c:/yk-application/flowchart-studio
npx shadcn@latest init -t next -b radix -y -d   # 非対話（preset Nova + Radix）
npx shadcn@latest add button table input scroll-area
```
