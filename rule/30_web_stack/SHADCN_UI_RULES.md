# shadcn/ui 開発ルール

## このルールが必要な背景

**shadcn/ui** は npm の黒箱コンポーネントライブラリではなく、**CLI でソースをプロジェクトに取り込む Open Code モデル**である。MUI や Chakra のように `import { Button } from "@mui/material"` だけでは運用できず、`components.json` · テーマトークン · `npx shadcn@latest add` の理解が必要。

本ファイルは **公式ドキュメントに基づく SSOT**（思想・禁止・YK 分岐・品質ゲート）。**init / add の実行コマンド SSOT は `creating-shadcn-yk` スキル**。

**用語:** 本文の `shadcn` は **shadcn/ui** の略。CLI パッケージ `@shadcn` は別物。

**ファイルパス:** `c:/yk-skill/rule/30_web_stack/SHADCN_UI_RULES.md`  
**索引:** [`RULE_INDEX.md`](../RULE_INDEX.md) No 32  
**最終更新:** 2026-05-24（Web 調査 + 3視点レビュー · ROUTER · shadcn-dev-entry）

**横断:** [`REACT_RULES.md`](REACT_RULES.md) · [`NEXTJS_RULES.md`](NEXTJS_RULES.md) §5（RSC） · [`TAILWINDCSS_RULES.md`](TAILWINDCSS_RULES.md)（v4） · flowchart 時 [`REACTFLOW_RULES.md`](../35_reactflow/REACTFLOW_RULES.md)

---

## 1. 概要（一言）

**CLI で UI コンポーネントのソースを自分のリポジトリに取り込み、Tailwind トークンと合成 API（Radix の `asChild` または Base UI の `render`）で組み立てる UI キットの作り方。**

---

## 2. YK プロジェクト分岐（最優先）

**対象が未確定なら、§2 より先にここで止める。**

| 判定（cwd / パス / シグナル） | 適用節 | プリミティブ | init の base |
|------------------------------|--------|--------------|--------------|
| `flowchart-studio` · `flowchart-web-mermaid` | **§13** | Radix · **`asChild`** | `-b radix` |
| `workspace-ui-kit` | **§12** | Base UI · **`render`** | 既存は **re-init 禁止** · 新規のみ `-b base` |
| `@workspace/ui` import あり（将来の Turborepo） | **§11** モノレポ | 各 workspace の `components.json` に従う | `--monorepo` |
| surge 静的 HTML 図解 | **§14 禁止** | — | shadcn 使わない |

**Radix vs Base UI（混同防止）**

| 項目 | flowchart-studio | workspace-ui-kit |
|------|-----------------|------------------|
| shadcn ベース | **Radix（標準）** | **Base UI** |
| リンクをボタン見た目 | `<Button asChild><Link /></Button>` | `<Button render={<a />} nativeButton={false}>…</Button>` |
| 相互コピー | **禁止** | **禁止** |

**§ 番号の正本は本ファイル。** 他文書に「§5=ui-kit / §6=flowchart」とある場合は **§12 / §13** を指す（2026-05-24 再編）。

---

## 3. エージェント向け — いつ何を読むか

| 段階 | 読むもの | タイミング |
|------|----------|------------|
| L1 | **本ファイル** | 毎回・最初（§2 で分岐確定後） |
| L2 | `creating-shadcn-yk/SKILL.md` | **init / add 実行時**（コマンド SSOT） |
| 併用 | `REACT_RULES.md` | Hooks · 純粋性 |
| 併用 | `NEXTJS_RULES.md` §5 | App Router · `"use client"` |
| 併用 | `TAILWINDCSS_RULES.md` | v4 · `@import "tailwindcss"` |
| ドメイン | §12 ui-kit · §13 flowchart | §2 表のとおり |

**実行スキル:** `creating-shadcn-yk` · **禁止:** 静的 surge 図解 HTML（`creating-visual-explainers` 系）

**L0 入口:**

| パス | entry |
|------|-------|
| `flowchart-studio/components/ui/**` | [`reactflow-dev-entry.mdc`](../../.cursor/rules/reactflow-dev-entry.mdc) → 本ファイル **§13** |
| `workspace-ui-kit/components/ui/**` | [`workspace-dev-entry.mdc`](../../../yk-tool/workspace-ui-kit/.cursor/rules/workspace-dev-entry.mdc) → **§12** |
| その他 `components/ui/**` · `components.json` | [`shadcn-dev-entry.mdc`](../../.cursor/rules/shadcn-dev-entry.mdc) |

---

## 4. 設計思想（公式 5 原則）

| 原則 | 意味 | エージェントが守ること |
|------|------|------------------------|
| **Open Code** | コンポーネントの**実ソース**がリポジトリに残る | ラップでごまかさず `components/ui/*` を直接編集してよい |
| **Composition** | 共通の合成インターフェース | コンポーネントごとに別 API を増やさない |
| **Distribution** | フラットスキーマ + **CLI** で配布 | `npx shadcn@latest add` が正規経路 |
| **Beautiful Defaults** | 初期スタイルが揃っている | まず variant / トークンで調整 |
| **AI-Ready** | オープンコードで LLM が読める | 追加時は公式例と `components/ui` の実装を Read |

**公式の明言:** 「コンポーネントライブラリではない」「自分のコンポーネントライブラリの作り方」。

> **§2 以降（一般論）:** プロジェクト未確定なら先に §2。flowchart / ui-kit 固有は §12–§13。

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
| `npx shadcn@latest info` | 設定確認 |

**init 主要オプション:** `-t next` · `--monorepo` · `--css-variables` · `--pointer` · `--rtl` · `-y` · `-f`

詳細: [CLI](https://ui.shadcn.com/docs/cli)

---

## 8. テーマとスタイリング

### 8-1. CSS 変数（推奨）

- `tailwind.cssVariables: true`
- `bg-background` · `text-primary` 等の**セマンティックトークン**
- 新規 UI で `bg-zinc-950` 等の生色は避ける

### 8-2. Tailwind v4 必須行（globals.css）

Tailwind 詳細は [`TAILWINDCSS_RULES.md`](TAILWINDCSS_RULES.md) を正本とし、shadcn 導入時は最低限次を含める:

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

**Base UI（ui-kit）— `render`:** §12 を参照。`asChild` は**使わない**。

- フォーム: [Forms](https://ui.shadcn.com/docs/forms)（RHF / TanStack Form 等）
- flowchart 既存カスタム CSS: **一括置換せず**段階的に shadcn 化

---

## 10. Next.js / RSC（shadcn 固有のみ）

| 項目 | 規則 |
|------|------|
| `rsc: true` | `add` で Client 部品に `"use client"` を付与 |
| インタラクティブ UI | Server / Client 分離 |

**RSC の一般論・データ取得境界:** [`NEXTJS_RULES.md`](NEXTJS_RULES.md) §5 を併読（本節で再掲しない）。

---

## 11. 単体アプリ vs モノレポ（YK）

| 種別 | 例 | shadcn |
|------|-----|--------|
| **単体** | `flowchart-studio` · **`workspace-ui-kit`**（ルート単体 Next） | `init` / `add` のみ · **`--monorepo` 不要** |
| **モノレポ** | 将来の Turborepo 雛形 | `init --monorepo` · 各 workspace に `components.json` |

モノレポ要件（公式）: `style` · `baseColor` · **`iconLibrary`** を workspace 間で揃える · v4 は `tailwind.config` を空に。

詳細: [Monorepo](https://ui.shadcn.com/docs/monorepo)

---

## 12. workspace-ui-kit（Base UI）

`c:/yk-tool/workspace-ui-kit` — **単体 Next アプリ**（`style: "base-nova"` · `@base-ui/react`）。Turborepo ではない。

### 12-1. `render` + `nativeButton`

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

### 12-2. レイアウト規約（§8 トークン規約に加え）

| ルール | 理由 |
|--------|------|
| `flex flex-col gap-*` | `space-y-*` 禁止 |
| 役割トークンのみ | `bg-blue-500` 禁止 |
| `size-N` | `w-N h-N` 禁止 |
| shadcn 部品を優先 | 自前 `div` 代替禁止 |

### 12-3. 運用

- 既存 ui-kit: **`init` や `-b` の再実行禁止** — `npx shadcn@latest add ...` のみ
- 上書き: **`add --diff` で確認** → `--overwrite` はユーザー明示まで使わない
- ローカル `workspace-ui-kit/.claude/skills/shadcn/` は registry 検索補助。**Base UI / re-init 禁止の正本は本 §12 + `creating-shadcn-yk`**

併読: `WORKSPACE_RULES.md` · ui-kit 同梱 `base-vs-radix.md`

---

## 13. flowchart-web（Radix · 標準 shadcn）

**現状:** shadcn **導入済**（2026-05-24 · `radix-nova` · `button` 初回 add · 既存 UI は段階的に shadcn 化）。ui-kit から **コピー禁止**。

### 13-1. 初回導入チェックリスト

1. §2 で **flowchart** であることを確認  
2. `npx shadcn@latest init -b radix`（`creating-shadcn-yk` と併用）  
3. `app/globals.css` に §8-2 の v4 必須行（`@custom-variant dark` 含む）  
4. 最初の 1 コンポーネントだけ `add`（例: `button`）して既存 UI と共存確認  
5. [`REACTFLOW_RULES.md`](../35_reactflow/REACTFLOW_RULES.md) を併読 — 表編集ロジックは `lib/flowchart/` が SSOT  

```bash
cd c:/yk-application/flowchart-studio
npx shadcn@latest init -t next -b radix -y -d   # 非対話（preset Nova + Radix）
npx shadcn@latest add button table input scroll-area
```

---

## 14. 禁止・境界

| 禁止 | 理由 |
|------|------|
| surge 静的 HTML に shadcn / Tailwind ビルド | 図解スキル系 |
| ui-kit ↔ flowchart の `components/ui` 相互コピー | API が異なる |
| `node_modules` 内の編集 | Open Code は自リポの `components/ui` |
| init 後の `style` / `baseColor` / `cssVariables` の安易な変更 | 再 add が必要 |
| flowchart で `render` / ui-kit で `asChild` | §2 違反 |
| ui-kit 既存に `init -b radix` 等の re-init | Base UI を壊す |

---

## 15. 品質ゲート（変更時）

- [ ] §2 で対象プロジェクト（Radix / Base UI）を確定した
- [ ] `components.json` と `tsconfig` / `imports` のエイリアス一致
- [ ] 追加は `npx shadcn@latest add` 経由
- [ ] Client 境界が必要なファイルに `"use client"`
- [ ] テーマはトークン / variant（打ち消し class を増やしていない）
- [ ] v4: `@custom-variant dark` を `globals.css` に含めた

**完了報告:** 触った公式 URL · init/add コマンド · §12 or §13 のどちらか — 各 1 行。

---

## 16. 参照 URL（公式）

調査日: 2026-05-24。詳細手順は各 URL を Read。

| トピック | URL |
|----------|-----|
| Introduction | https://ui.shadcn.com/docs |
| Installation / Next | https://ui.shadcn.com/docs/installation/next |
| Components | https://ui.shadcn.com/docs/components |
| components.json | https://ui.shadcn.com/docs/components-json |
| CLI | https://ui.shadcn.com/docs/cli |
| Theming | https://ui.shadcn.com/docs/theming |
| Dark Mode / Next | https://ui.shadcn.com/docs/dark-mode/next |
| Forms | https://ui.shadcn.com/docs/forms |
| Monorepo | https://ui.shadcn.com/docs/monorepo |
| shadcn/create | https://ui.shadcn.com/create |
| Schema | https://ui.shadcn.com/schema.json |
