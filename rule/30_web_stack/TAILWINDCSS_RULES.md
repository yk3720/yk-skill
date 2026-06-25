# Tailwind CSS 参照ルール

## このルールが必要な背景

**ユーティリティファースト**のスタイリングでは、クラス名の意味・ビルド時スキャン・バリアント記法を誤解すると修正コストが跳ねる。公式の考え方とリンクを一箇所にまとめる。本ファイルは **公式要点とリンクの SSOT** とする。

**ファイルパス（エージェント・スキル参照用）:** `c:/yk-skill/rule/30_web_stack/TAILWINDCSS_RULES.md`

**最終更新:** 2026-05-10

**メモ:** ドキュメント取得時点のバージョン表記は **v4.2**。

---

## 1. 概要（一言）

**HTML / コンポーネントに「ユーティリティクラス」を直接書いてスタイルする CSS フレームワーク。** プロジェクト内のファイルをスキャンして使われたクラスに対応する CSS を生成し、**ビルド時に静的 CSS にまとめる**（公式は **zero-runtime** と説明）。

---

## 2. 公式ドキュメントで押さえること

### 2-1. 仕組み（インストール概要）

1. HTML・JS・テンプレートなどをスキャンし、クラス名を検出する。  
2. 対応するスタイルを生成し、**実際に使った分だけ**スタイルシートにまとめる。

### 2-2. Vite 向けの例（公式）

- `tailwindcss` と `@tailwindcss/vite` をインストール。
- `vite.config` に `@tailwindcss/vite` プラグインを追加。
- CSS で `@import "tailwindcss";`。
- マークアップで `class="text-3xl font-bold underline"` のようにユーティリティを付与。

フレームワーク別は [Framework Guides](https://tailwindcss.com/docs/installation/framework-guides) を参照。

### 2-3. ユーティリティファースト（Core concepts）

- **単一用途のクラスを組み合わせる**ことで UI を組み立てる。
- **インラインスタイルとの違い（公式の主張）:** 値がすべて任意数値になるのではなく **テーマに沿った制約**がありやすい、**hover / focus** など状態、[レスポンシブ](https://tailwindcss.com/docs/responsive-design)、**ダークモード**（`dark:`）などをクラスで扱いやすい。
- **メリット（公式）:** 命名や CSS ファイルの行き来が減り変更が局所的、長期プロジェクトでも保守しやすい、マークアップとスタイルが同じ場所にあり移植しやすい、使ったユーティリティだけなので **CSS が線形に肥大化しにくい** 等。
- **バリアント:** `hover:bg-sky-700`、`sm:grid-cols-3`、`dark:bg-gray-800` のようにプレフィックスで条件を付ける。
- **任意値:** `bg-[#316ff6]` のような角括弧でワンオフの値を指定可能（テーマ外の色や複雑な `grid` など）。

### 2-4. 重複の扱い

ループ・コンポーネント化・テンプレート部分など、**フレームワークのコンポーネントにまとめる**のが推奨パターンとして紹介されている。

---

## 3. 参照 URL（公式）

| 説明 | URL |
|------|-----|
| ドキュメント（インストール入口） | https://tailwindcss.com/docs |
| ユーティリティクラスでスタイル（Core concepts） | https://tailwindcss.com/docs/utility-first |
| フレームワーク別ガイド | https://tailwindcss.com/docs/installation/framework-guides |
| テーマ | https://tailwindcss.com/docs/theme |

---

## 4. エージェント向けメモ

- Next.js のひな形では **Tailwind が既に含まれている**ことが多い。自分で触るのは主に **クラス名**と、必要なら `tailwind.config` 周り。
- UI の見た目を説明するときは、**レイアウト（flex / grid）、余白（p-/m-）、タイポ（text-/font-）、色（bg-/text-）** の読み方ができると伝わりやすい。
- **`overflow-auto` 二重ネスト禁止:** 外側 wrapper と内側コンテナ両方に `overflow-auto`（または `overflow-scroll`）を付けると、内側コンテンツが増えたとき水平スクロールバーが画面外に落ちる。**スクロール源は 1 箇所だけ**にする。
  ```
  NG: 外側 div.overflow-auto → 内側 div.overflow-auto
  OK: 外側 div（overflow なし） → 内側 div.overflow-auto
  ```
  `flex-col` レイアウトで複数ペインを積むとき、外側ペイン wrapper に残った `overflow-auto` が原因で踏みやすい。
