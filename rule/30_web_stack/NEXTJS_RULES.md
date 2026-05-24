# Next.js 参照ルール

## このルールが必要な背景

React を前提としたフルスタック Web 開発で **Next.js** を触る際、公式ドキュメントの構成・App Router と Pages Router の違い・前提知識を揃えておくと、エージェントや人間の両方が手戻りを減らせる。本ファイルは **公式要点とリンクの SSOT** とする。

**ファイルパス（エージェント・スキル参照用）:** `c:/yk-skill/rule/30_web_stack/NEXTJS_RULES.md`

**最終更新:** 2026-05-24

---

## 1. 概要（一言）

**React でフルスタック Web アプリを組み立てるためのフレームワーク。** UI は React コンポーネント、ルーティング・ビルド・最適化などは Next.js が肩代わりするイメージ。

---

## 2. 公式ドキュメントで押さえること

### 2-1. 役割

React コンポーネントで UI を作り、Next.js が追加機能と最適化を提供する。**バンドラなど下位ツールは自動設定**され、プロダクト実装に集中しやすい。

### 2-2. ドキュメント構成（公式）

| 区分 | URL |
|------|-----|
| Getting Started | https://nextjs.org/docs/app/getting-started |
| Guides | https://nextjs.org/docs/app/guides |
| API Reference | https://nextjs.org/docs/app/api-reference |

### 2-3. ルータは 2 系統

| 名称 | 説明 |
|------|------|
| **App Router** | 新方式。Server Components など新しい React 機能に対応。 |
| **Pages Router** | 従来方式。引き続きサポート・改善中。 |

### 2-4. App Router と React（公式の説明）

App Router は **React canary（安定した React 19 の変更＋検証中機能を含む）を内蔵**する説明がある。Pages Router は `package.json` に入れた React のバージョンを使う。

### 2-5. 前提知識（公式の想定）

HTML / CSS / JavaScript / React にある程度慣れていること。React が不安な場合は [React Foundations](https://nextjs.org/learn/react-foundations) や [Next.js Foundations（ダッシュボードアプリ）](https://nextjs.org/learn/dashboard-app) が案内されている。

### 2-6. Getting Started で触れるトピック（目次レベル）

インストール（`create-next-app`）、プロジェクト構成、レイアウトとページ、リンクとナビ、Server / Client Components、データ取得・更新、キャッシュ・再検証、エラー処理、CSS（Tailwind 含む）、画像・フォント、メタデータ、Route Handlers、デプロイ、アップグレードなど。

---

## 3. 参照 URL（公式）

| 説明 | URL |
|------|-----|
| ドキュメント入口 | https://nextjs.org/docs |
| App Router · Getting Started | https://nextjs.org/docs/app/getting-started |
| インストール（個別ページ） | https://nextjs.org/docs/app/getting-started/installation |
| LLM 向け索引（公式） | https://nextjs.org/docs/llms.txt |

---

## 4. エージェント向けメモ

- まず **Getting Started の見出し一覧**で全体像を掴み、プロジェクトが **App Router か Pages Router か** を README または `app/` と `pages/` の有無で確認する。

---

## 5. flowchart-web 向け追記（`yk-tool` · ADR-010）

**対象:** `c:/yk-tool/flowchart-web-reactflow/` · `c:/yk-tool/flowchart-web-mermaid/`  
**React Flow / 表駆動:** [`35_reactflow/REACTFLOW_RULES.md`](../35_reactflow/REACTFLOW_RULES.md) · `creating-reactflow-yk`

### 5-1. プロジェクト構成

| 項目 | 規則 |
|------|------|
| 配置 | `yk-tool` リポジトリ直下（単体 Next アプリ · Turborepo モノレポではない） |
| ルータ | **App Router のみ**（`app/` · `pages/` なし） |
| 参照 | `catalog.yaml` · `flowchart-web-reactflow` / `flowchart-web-mermaid` |
| dev ポート | reactflow **3000** · mermaid **3001**（並行起動可） |

### 5-2. Server / Client 境界

| パス | 規則 |
|------|------|
| `app/page.tsx` | **Server Component** — 子の Client のみ import |
| `components/flowchart/**` | **`"use client"`** — React Flow / Mermaid プレビュー · 表 UI · localStorage |
| `lib/flowchart/**` | React 非依存 — DOM 禁止 |

**MUST:** Client 境界は **葉** に置く（[Server and Client Components](https://nextjs.org/docs/app/getting-started/server-and-client-components)）。`@xyflow/react` は `FlowCanvas.tsx` · `mermaid` は `MermaidPreview.tsx` 経由。

**任意:** Canvas のみ `next/dynamic(..., { ssr: false })` + 親 `min-height`（CLS 防止）。

### 5-3. 実行スキル

- flowchart の Next シェル → **`creating-nextjs-yk`**（本 §5 が floor）
- 汎用 Next → 本ファイル §2〜3
