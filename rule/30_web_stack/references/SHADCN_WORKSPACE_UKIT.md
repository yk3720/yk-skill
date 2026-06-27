# shadcn/ui — workspace-ui-kit（Base UI）

**SSOT:** 本ファイル · **索引:** [`SHADCN_UI_RULES.md`](../SHADCN_UI_RULES.md) §12

`c:/yk-tool/workspace-ui-kit` — **単体 Next アプリ**（`style: "base-nova"` · `@base-ui/react`）。Turborepo ではない。

---

## 12-1. `render` + `nativeButton`

```tsx
// ❌ asChild（本プロジェクト不可）
<Button asChild><a href="...">開く</a></Button>

// ✅ リンクをボタン見た目に
<Button render={<a href="/docs" />} nativeButton={false}>
  Read the docs
</Button>

// ✅ Dialog 等の Trigger
<DialogTrigger render={<Button variant="outline" />}>設定を開く</DialogTrigger>
```

`<a>` / `<span>` を `render` する場合は **`nativeButton={false}` 必須**（ラベルは `Button` の children）。

---

## 12-2. レイアウト規約（§8 トークン規約に加え）

| ルール | 理由 |
|--------|------|
| `flex flex-col gap-*` | `space-y-*` 禁止 |
| 役割トークンのみ | `bg-blue-500` 禁止 |
| `size-N` | `w-N h-N` 禁止 |
| shadcn 部品を優先 | 自前 `div` 代替禁止 |

---

## 12-3. 運用

- 既存 ui-kit: **`init` や `-b` の再実行禁止** — `npx shadcn@latest add ...` のみ
- 上書き: **`add --diff` で確認** → `--overwrite` はユーザー明示まで使わない
- ローカル `workspace-ui-kit/.claude/skills/shadcn/` は registry 検索補助。**Base UI / re-init 禁止の正本は本 §12 + `creating-shadcn-yk`**

併読: `WORKSPACE_RULES.md` · ui-kit 同梱 `base-vs-radix.md`
