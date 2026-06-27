# shadcn/ui — セットアップ · CLI · テーマ

**SSOT:** 本ファイル · **索引:** [`SHADCN_UI_RULES.md`](../SHADCN_UI_RULES.md) §5–§9 · init/add 実行は `creating-shadcn-yk`

---

## 5. インストール経路（Next.js · 公式順）

### 5-1. 新規 — shadcn/create

1. [shadcn/create](https://ui.shadcn.com/create?template=next) でスタイル・色・フォント等を選ぶ  
2. `npx shadcn@latest init --preset [CODE] --template next`  
3. `npx shadcn@latest add card` 等  

### 5-2. 新規 — CLI

```bash
# Radix（flowchart 等）
npx shadcn@latest init -t next -b radix

# Base UI（ui-kit 新規のみ）
npx shadcn@latest init -t next -b base

# モノレポ新規のみ
npx shadcn@latest init -t next --monorepo
```

### 5-3. 既存 Next（YK flowchart 初回導入）

```bash
cd c:/yk-application/flowchart-studio
npx shadcn@latest init -t next -b radix -y -d   # 非対話（preset Nova + Radix）
npx shadcn@latest add button table input scroll-area
```

**前提:** Tailwind 導入済み · `@/*` エイリアス · `components.json` は CLI 利用時必須。

```tsx
import { Button } from "@/components/ui/button"
```

---

## 6. `components.json`（CLI の正本）

| キー | 意味 | 注意 |
|------|------|------|
| `$schema` | `https://ui.shadcn.com/schema.json` | 推奨 |
| `style` | 例: `new-york` · `radix-nova` · **`base-nova`**（ui-kit） | **init 後は変更不可** |
| `iconLibrary` | 例: `lucide` | モノレポでは workspace 間で**一致** |
| `tailwind.css` | 例: `app/globals.css` | v4 では `config` は空 |
| `tailwind.config` | v3 用 · **v4 は `""`** | |
| `tailwind.baseColor` | neutral, zinc 等 | init 後変更不可 |
| `tailwind.cssVariables` | `true` 推奨 | `false` は再インストールが必要 |
| `rsc` | `true` → add 時に `"use client"` 付与 | Next App Router は **true** |
| `tsx` | TypeScript | YK は **true** |
| `rtl` | RTL レイアウト | |
| `aliases.components` | 例: `@/components` | |
| `aliases.ui` | 例: `@/components/ui` | import SSOT |
| `aliases.utils` | 例: `@/lib/utils` | `cn` |
| `aliases.lib` · `aliases.hooks` | 例: `@/lib` · `@/hooks` | |
| `registries` | `@acme/...` 名前空間 | 社内配布 |

詳細: [components.json](https://ui.shadcn.com/docs/components-json)

---

## 7. CLI コマンド（よく使うもの）

| コマンド | 用途 |
|----------|------|
| `npx shadcn@latest init` | 設定・依存・CSS 変数 |
| `npx shadcn@latest init -b radix` / `-b base` | プリミティブ選択 |
| `npx shadcn@latest add <name>` | コンポーネント追加 |
| `npx shadcn@latest add -c apps/web` | モノレポ cwd |
| `npx shadcn@latest add --dry-run` | プレビュー |
| `npx shadcn@latest add --diff` | 上書き前 diff（ui-kit **推奨必須**） |
| `npx shadcn@latest info` / `info --json` | 設定・フレームワーク確認 |
| `npx shadcn@latest docs [component]` | ドキュメント表示 |
| `npx shadcn@latest view button` | レジストリ確認 |
| `npx shadcn@latest search @shadcn -q "table"` | 検索 |
| `npx shadcn@latest apply <preset>` | テーマ/フォント適用 |
| `npx shadcn@latest migrate radix` | `@radix-ui/react-*` → `radix-ui` |
| `npx shadcn@latest migrate icons` / `rtl` | アイコン・RTL 移行 |
| `npx shadcn@latest preset resolve <url>` | プリセット解決 |

**init 主要オプション:** `-t next` · `--monorepo` · `--css-variables` · `--pointer` · `--rtl` · `-y` · `-f`

詳細: [CLI](https://ui.shadcn.com/docs/cli)

---

## 8. テーマとスタイリング

### 8-1. CSS 変数（推奨）

- `tailwind.cssVariables: true`
- `bg-background` · `text-primary` 等の**セマンティックトークン**
- 新規 UI で `bg-zinc-950` 等の生色は避ける

### 8-2. Tailwind v4 必須行（globals.css）

Tailwind 詳細は [`TAILWINDCSS_RULES.md`](../TAILWINDCSS_RULES.md) を正本とし、shadcn 導入時は最低限次を含める:

```css
@import "tailwindcss";
@import "shadcn/tailwind.css";

@custom-variant dark (&:is(.dark *));
```

- `components.json` の `tailwind.config` は **`""`**
- v4 ボタン既定は `cursor: default` — `init --pointer` または base レイヤで調整

### 8-3. ダークモード（Next）

`next-themes` · `ThemeProvider`（`"use client"`）· `<html suppressHydrationWarning>` · `attribute="class"`  
→ [Dark Mode / Next](https://ui.shadcn.com/docs/dark-mode/next)

---

## 9. コンポーネントの使い方

```bash
npx shadcn@latest add button dialog table field
```

- 配置: `aliases.ui`（通常 `@/components/ui/`）
- 見た目: variant / トークン / ソース編集（呼び出し側 `className` で打ち消さない）

**Radix（標準 · flowchart）— `asChild`:**

```tsx
<Button asChild>
  <Link href="/login">Login</Link>
</Button>
```

**Base UI（ui-kit）— `render`:** [`SHADCN_WORKSPACE_UKIT.md`](SHADCN_WORKSPACE_UKIT.md) §12 を参照。`asChild` は**使わない**。

- フォーム: [Forms](https://ui.shadcn.com/docs/forms)（RHF / TanStack Form 等）
- flowchart 既存カスタム CSS: **一括置換せず**段階的に shadcn 化
