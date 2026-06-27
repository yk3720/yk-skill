# shadcn/ui 開発ルール

## このルールが必要な背景

**shadcn/ui** は npm の黒箱コンポーネントライブラリではなく、**CLI でソースをプロジェクトに取り込む Open Code モデル**である。MUI や Chakra のように `import { Button } from "@mui/material"` だけでは運用できず、`components.json` · テーマトークン · `npx shadcn@latest add` の理解が必要。

本ファイルは **公式ドキュメントに基づく SSOT**（思想・禁止・YK 分岐・品質ゲート）。**init / add の実行コマンド SSOT は `creating-shadcn-yk` スキル**。

**用語:** 本文の `shadcn` は **shadcn/ui** の略。CLI パッケージ `@shadcn` は別物。

**ファイルパス:** `c:/yk-skill/rule/30_web_stack/SHADCN_UI_RULES.md`  
**索引:** [`RULE_INDEX.md`](../RULE_INDEX.md) No 32  
**最終更新:** 2026-06-27（P14e · §5–§9 · §12–§13 · §16 を `references/` へ分割）

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
| L3 | `references/`（下表） | init/add · テーマ · ドメイン詳細時 |
| 併用 | `REACT_RULES.md` | Hooks · 純粋性 |
| 併用 | `NEXTJS_RULES.md` §5 | App Router · `"use client"` |
| 併用 | `TAILWINDCSS_RULES.md` | v4 · `@import "tailwindcss"` |
| ドメイン | §12 ui-kit · §13 flowchart | §2 表のとおり |

**実行スキル:** `creating-shadcn-yk` · **禁止:** 静的 surge 図解 HTML（`creating-visual-explainers` 系）

**L0 入口:**

| パス | entry |
|------|-------|
| `flowchart-studio/frontend/src/components/ui/**` | [`reactflow-dev-entry.mdc`](../../.cursor/rules/reactflow-dev-entry.mdc) → 本ファイル **§13** |
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

## 5. セットアップ · CLI · テーマ（索引）

**詳細 SSOT:** [`references/SHADCN_CORE_SETUP.md`](references/SHADCN_CORE_SETUP.md)

| 節 | 内容 |
|----|------|
| §5 | インストール経路（create · CLI · flowchart 初回） |
| §6 | `components.json` |
| §7 | CLI コマンド |
| §8 | テーマ · v4 `globals.css`（**§8-2 必須行**） |
| §9 | コンポーネント使い方 · `asChild` |

**init/add 実行:** `creating-shadcn-yk` + ROUTER Ref Plan。

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

詳細: [Monorepo](https://ui.shadcn.com/docs/monorepo) · 手順全文は [`SHADCN_CORE_SETUP.md`](references/SHADCN_CORE_SETUP.md) §5–§7

---

## 12. workspace-ui-kit（Base UI · 索引）

**詳細 SSOT:** [`references/SHADCN_WORKSPACE_UKIT.md`](references/SHADCN_WORKSPACE_UKIT.md)

| MUST | 内容 |
|------|------|
| 合成 API | **`render` + `nativeButton`** — `asChild` **禁止** |
| 運用 | 既存 ui-kit: **`init` / re-init 禁止** · `add` のみ · **`add --diff` 必須** |
| 併読 | `WORKSPACE_RULES.md` · ui-kit `base-vs-radix.md` |

---

## 13. flowchart-studio（Radix · 索引）

**詳細 SSOT:** [`references/SHADCN_FLOWCHART.md`](references/SHADCN_FLOWCHART.md)

| MUST | 内容 |
|------|------|
| ベース | **Radix · `asChild`** — ui-kit から **コピー禁止** |
| 初回 | `init -b radix` → 1 コンポーネント `add` で共存確認 |
| 併読 | `REACTFLOW_RULES.md` · `creating-shadcn-yk` ROUTER tag `init-radix` |

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
- [ ] v4: `@custom-variant dark` を `globals.css` に含めた（[`SHADCN_CORE_SETUP.md`](references/SHADCN_CORE_SETUP.md) §8-2）

**完了報告:** 触った公式 URL · init/add コマンド · §12 or §13 のどちらか — 各 1 行。

---

## 16. 参照 URL（索引）

**詳細:** [`references/SHADCN_OFFICIAL_URLS.md`](references/SHADCN_OFFICIAL_URLS.md)

---

**行数監査:** `yk-tool/scripts/audit-rule-line-counts.ps1` — L1 理想 ~250行 · FAIL 500行超
