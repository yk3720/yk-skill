# Next.js 参照ルール

## このルールが必要な背景

React を前提としたフルスタック Web 開発で **Next.js** を触る際、公式ドキュメントの構成・App Router と Pages Router の違い・Server/Client 境界を揃えておくと、エージェントや人間の両方が手戻りを減らせる。本ファイルは **YK 横断 MUST と公式索引の SSOT** とする。

**ファイルパス（エージェント・スキル参照用）:** `c:/yk-skill/rule/30_web_stack/NEXTJS_RULES.md`

**React 一般（Hooks · 純粋性）:** [`REACT_RULES.md`](REACT_RULES.md) · `creating-react-yk`（**RSC は本ファイル §5**）

**実行スキル:** `creating-nextjs-yk` · 参照ルーティング: `.../creating-nextjs-yk/references/ROUTER.md`

**最終更新:** 2026-05-24（公式 `llms.txt` @doc-version **16.2.6** に基づく索引整備）

---

## 0. エージェント向け — いつ何を読むか

| 段階 | 読むもの | タイミング |
|------|----------|------------|
| L1 | **本ファイル** | `app/` · ルーティング · RSC 境界 · Route Handler を触るたび |
| L2 | `creating-nextjs-yk/SKILL.md` | 手順・ゲート |
| L2.5 | **Ref Plan** | Write/StrReplace 前（ROUTER §7） |
| L3 | ROUTER の `load` のみ | Ref Plan 後 |

**Ref Plan 不要:** 質問のみ · Read のみ。

**本ファイルで扱わない（委譲 SSOT）**

| 関心 | SSOT |
|------|------|
| Hooks · コンポーネント純粋性 · `components/**` 合成 | [`REACT_RULES.md`](REACT_RULES.md) · `creating-react-yk` |
| `@xyflow/react` · 表駆動 · `lib/flowchart/` | [`REACTFLOW_RULES.md`](../35_reactflow/REACTFLOW_RULES.md) · `creating-reactflow-yk` |
| shadcn init/add | `SHADCN_UI_RULES` · `creating-shadcn-yk` |

**誤ルーティング禁止**

| 触るもの | 使う入口 | **使わない** |
|----------|----------|--------------|
| **`app/**`** | **本帯** · `creating-nextjs-yk` | `creating-react-yk` 単独 |
| **`components/**`（Hooks · イベント）** | `creating-react-yk` + 本 §5 | 本スキル単独で Hooks 規約を再掲しない |
| surge 図解 HTML | 図解スキル系 | 本帯 |

---

## 1. 概要（一言）

**React でフルスタック Web アプリを組み立てるためのフレームワーク。** UI は React コンポーネント、ルーティング・ビルド・キャッシュ・最適化は Next.js が担う。

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
| **App Router** | 新方式（`app/`）。Server Components · ストリーミング等。**YK 新規はこちらを既定。** |
| **Pages Router** | 従来方式（`pages/`）。既存プロジェクトのみ。触る前に README / ディレクトリで確認。 |

### 2-4. App Router と React（公式）

App Router は **React canary（安定した React 19 変更＋検証中機能を含む）を内蔵**する説明がある。Pages Router は `package.json` の React バージョンを使う。

### 2-5. 前提知識（公式の想定）

HTML / CSS / JavaScript / React にある程度慣れていること。不安な場合は [React Foundations](https://nextjs.org/learn/react-foundations) · [Next.js Foundations](https://nextjs.org/learn/dashboard-app)。

### 2-6. 詳細トピック

**全文目次は転記しない。** [llms.txt](https://nextjs.org/docs/llms.txt) またはプロジェクトの `node_modules/next/dist/docs/` を Ref Plan の `load` で参照。

### 2-7. プロジェクト構成（YK 確認用）

| トップ | 用途 |
|--------|------|
| `app/` | App Router（YK 既定） |
| `pages/` | Pages Router（レガシー） |

ルーティングファイル規約 · `(group)` · `_folder` → [Project Structure](https://nextjs.org/docs/app/getting-started/project-structure)（ROUTER tag `routing-files`）

---

## 3. 参照 URL（公式）

| 説明 | URL |
|------|-----|
| ドキュメント入口 | https://nextjs.org/docs |
| App Router · Getting Started | https://nextjs.org/docs/app/getting-started |
| Server and Client Components | https://nextjs.org/docs/app/getting-started/server-and-client-components |
| Project Structure | https://nextjs.org/docs/app/getting-started/project-structure |
| LLM 向け索引 | https://nextjs.org/docs/llms.txt |

データ取得 · 変更 · キャッシュ · セキュリティの公式 URL → **ROUTER §3**（本ファイル §7 は索引 1 行のみ）。

---

## 4. エージェント向けメモ

- プロジェクトが **App Router か Pages Router か** を `app/` / `pages/` の有無で確認する。
- **Hooks · 純粋性** → [`REACT_RULES.md`](REACT_RULES.md)（本ファイルでは再掲しない）。
- **Next.js 15+（v15.0.0-RC 以降）の Request APIs:** 動的 segment の **`params`**（`layout` · `page` · `route` · `generateMetadata` 等）と **`page` の `searchParams`** は **Promise**。Server では `await`、Client の `page` では React の **`use(params)`** / **`use(searchParams)`**（[Version 15 upgrade · Async Request APIs](https://nextjs.org/docs/app/guides/upgrading/version-15)）。**`cookies()` · `headers()` · `draftMode()`** も `await` 必須。v15 では同期アクセスが残るが deprecated — 新規・修正は Promise 前提。
- **バンドル doc の読み方:** `creating-nextjs-yk` ROUTER §3（`AGENTS.md` · `node_modules/next/dist/docs/`）。YK 横断 MUST は **本ファイルが SSOT**。
- **環境変数:** クライアントに載るのは `NEXT_PUBLIC_` 接頭辞のみ。秘密は Server 側（`server-only` 推奨）。
- **L1 の Read 深さ:** ROUTER **tier** に従う（Light は §5 中心 · Standard は L1 全体）。
- **`useState` initializer でのブラウザ API:** `localStorage` · `sessionStorage` · `navigator` 等は SSR でクラッシュする。`useState(() => ...)` の initializer は SSR でも実行されるため **`typeof window === "undefined"` ガード**が必要。`useEffect` 内は SSR で実行されないためガード不要。util 関数側にガードを置くのが再利用しやすい。
  ```typescript
  // NG: SSR でクラッシュ
  const [v] = useState(() => localStorage.getItem(key));

  // OK: util にガード
  function loadFromStorage(key: string): string | null {
    if (typeof window === "undefined") return null;
    return localStorage.getItem(key);
  }
  const [v] = useState(() => loadFromStorage(key));
  ```

---

## 5. App Router — Server / Client 境界（YK 横断 MUST）

**SSOT:** 本 §5 が `"use client"` · RSC · serializable props · 合成パターンの唯一の正本。  
**React 一般論:** [`REACT_RULES.md`](REACT_RULES.md) · **shadcn:** [`SHADCN_UI_RULES.md`](SHADCN_UI_RULES.md) §10（再掲禁止）。

### 5-1. 原則（公式 + YK）

| MUST | 規則 |
|------|------|
| Server default | `layout` / `page` は **Server Component がデフォルト** |
| Client 条件 | 次が必要なときだけ **`"use client"`** — state · イベント · `useEffect` 等ライフサイクル · ブラウザ API · カスタム Hook · Context |
| 葉に置く | Client 境界は **できるだけ葉** — [Server and Client Components](https://nextjs.org/docs/app/getting-started/server-and-client-components) |
| シリアライズ | Server → Client の props は **シリアライズ可能**（関数 · class インスタンス禁止） |
| 第三者 Client | RSC 非対応ライブラリは **Client ラッパー**（`"use client"` 再エクスポート） |
| 環境汚染防止 | サーバー専用モジュールは **`server-only`** · クライアント専用は **`client-only`**（[同上](https://nextjs.org/docs/app/getting-started/server-and-client-components#preventing-environment-poisoning)） |
| Context | React Context は **Client 側 Provider** — Provider はツリー **できるだけ深く**（静的 Server 部分を広く保つ） |

**Client Component にしないもの（データ取得・秘密・大きな静的 UI）** — Server のまま props / `children` で渡す。

**実行スキル:** `app/` 編集 → **`creating-nextjs-yk`** · `components/` の Hooks → **`creating-react-yk`** + 本 §5。

### 5-2. 合成（children / スロット）

| MUST | 規則 |
|------|------|
| Server を Client に import しない | Client が Server モジュールを **直接 import しない** |
| children パターン | Server UI は **`children`（または named slot）** で Client に渡す — Client の子ツリーはサーバーで先にレンダリングされ RSC Payload に含まれる |
| バンドル | `"use client"` ファイルは **その import 先もクライアントバンドル** — 広いファイルに付けない |

### 5-3. workspace-ui-kit パス表

| パス | 規則 |
|------|------|
| `app/**/page.tsx` | **Server Component** — Client 子を import |
| `components/**` | **Client**（`"use client"`）— Hooks · イベント |
| `lib/**` | React 非依存 — [`WORKSPACE_RULES.md`](../20_web_workspace/WORKSPACE_RULES.md) §3 |

---

## 6. flowchart-studio 向け追記（`yk-application` · ADR-010）

**対象:** `c:/yk-application/flowchart-studio/` · `c:/yk-tool/flowchart-web-mermaid/`  
**React Flow / 表駆動:** [`35_reactflow/REACTFLOW_RULES.md`](../35_reactflow/REACTFLOW_RULES.md) · `creating-reactflow-yk`  
**Client 一般:** [`REACT_RULES.md`](REACT_RULES.md)

### 6-1. プロジェクト構成

| 項目 | 規則 |
|------|------|
| 配置 | **本線:** `yk-application/flowchart-studio`（独立 Git）· **比較:** `yk-tool/flowchart-web-mermaid`（単体 Next アプリ） |
| ルータ | **App Router のみ**（`app/` · `pages/` なし） |
| 参照 | `catalog.yaml` · `flowchart-studio` / `flowchart-web-mermaid` |
| dev ポート | reactflow **3000** · mermaid **3001**（並行起動可） |

### 6-2. Server / Client 境界（flowchart パス）

**一般 RSC MUST:** §5-1〜5-2。**RF 固有:** [`REACTFLOW_RULES.md`](../35_reactflow/REACTFLOW_RULES.md) §3。

| パス | 規則 |
|------|------|
| `app/page.tsx` | **Server Component** — 子の Client のみ import |
| `frontend/src/components/flowchart/**` | **`"use client"`** |
| `lib/flowchart/**` | React 非依存 — DOM 禁止 |

**任意:** Canvas のみ `next/dynamic(..., { ssr: false })` + 親 `min-height`（CLS 防止）。

### 6-3. 実行スキル

- flowchart の Next シェル → **`creating-nextjs-yk`**（本 §6 が floor）
- 汎用 Next → 本ファイル §2〜5

---

## 7. データ取得・変更

**公式 URL と tag:** `creating-nextjs-yk/references/ROUTER.md` §3（`data-fetch` · `mutate-actions` · `cache-revalidate` · `route-handler`）。

**YK MUST（要約）:** 新規本番向けは **DAL（server-only）** を推奨。プロトタイプのみ Server Component 直クエリ可。mutation は `"use server"` を薄くし認可・DB は DAL に集約。

---

## 8. 品質ゲート

| ゲート | 手段 |
|--------|------|
| Lint | プロジェクトの `npm run lint` |
| 型 · ビルド | `npm run build` または `tsc` |

**Shell:** `AGENT_SHELL_RULES` — ユーザーが当ターンで `test` / `build` / `lint` を明示したときのみ実行。

---

## 9. 完了報告

`creating-nextjs-yk` SKILL · ROUTER §8 に従う。末尾に **読んだ refs**（L1 · ROUTER · 触ったファイル · 公式 URL · プロジェクト `node_modules/next/dist/docs/` の有無）を列挙。
