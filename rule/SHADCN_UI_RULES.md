# shadcn/ui 参照ルール

## このルールが必要な背景

**shadcn/ui** は「npm の黒箱コンポーネント」と設計思想が異なり、CLI でソースを取り込む **Open Code** モデルである。誤解すると依存関係やカスタマイズ方針の説明がずれる。本ファイルは **公式要点とリンクの SSOT** とする。

**ファイルパス（エージェント・スキル参照用）:** `c:\yk-skill\rule\SHADCN_UI_RULES.md`

**最終更新:** 2026-05-10

---

## 1. 概要（一言）

**デザインされたアクセシブルなコンポーネント群と、それを配布するための仕組み。** 公式は **「コンポーネントライブラリではない」「自分のコンポーネントライブラリの作り方」** と明言している。**npm にブラックボックスで依存するのではなく、ソースを自分のリポジトリに取り込んで編集できる（Open Code）。**

---

## 2. 公式ドキュメントで押さえること

### 2-1. 原則（Introduction）

- **Open Code:** コンポーネントの**実コードが手元に残る**。見た目・挙動をそのまま編集できる。LLM が読んで改善もしやすい。
- **Composition:** 共通の合成しやすいインターフェースで揃えられ、API がコンポーネントごとにバラバラになりにくい。
- **Distribution:** フラットファイルのスキーマと **CLI** でコンポーネントを配布・インストール。クロスフレームワーク対応の説明がある。
- **Beautiful Defaults:** 初期スタイルがそろっており、そのまま最低限きれいに見える。
- **AI-Ready:** オープンなコードと一貫した API で、モデルが読み・生成しやすい。

### 2-2. Next.js での使い方（Installation / Next）

大きく 3 パターンがドキュメント化されている。

1. **shadcn/create** … [create 画面](https://ui.shadcn.com/create?template=next) でプリセットを組み、`npx shadcn@latest init --preset [CODE] --template next` のようなコマンドを生成。
2. **CLI で新規** … `npx shadcn@latest init -t next`（モノレポなら `--monorepo`）。
3. **既存プロジェクト** … `npx create-next-app@latest` で作成（推奨デフォルトで Tailwind・App Router・`@/*` エイリアスなど）、必要なら Tailwind と `tsconfig` の `paths` を確認後、`npx shadcn@latest init`、`npx shadcn@latest add button` など。

コンポーネント追加後の import 例（公式）:

```tsx
import { Button } from "@/components/ui/button"
```

**`@/components/ui/`** 配下から import する形が公式例として載っている。

---

## 3. 参照 URL（公式）

| 説明 | URL |
|------|-----|
| Introduction | https://ui.shadcn.com/docs |
| Next.js インストール | https://ui.shadcn.com/docs/installation/next |
| shadcn/create（テンプレ next） | https://ui.shadcn.com/create?template=next |

---

## 4. エージェント向けメモ

- **「ライブラリを import するだけ」ではなく「コードがプロジェクトにコピーされる」** と説明できると、AI やチームへの指示もブレにくい。
- スタイルの土台は **Tailwind** が前提になりやすい（Next の公式流儀とも相性がよい）。詳細は `c:\yk-skill\rule\TAILWINDCSS_RULES.md` を参照。
