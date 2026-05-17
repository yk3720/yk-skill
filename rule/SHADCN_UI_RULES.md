# shadcn/ui 参照ルール

## このルールが必要な背景

**shadcn/ui** は「npm の黒箱コンポーネント」と設計思想が異なり、CLI でソースを取り込む **Open Code** モデルである。誤解すると依存関係やカスタマイズ方針の説明がずれる。本ファイルは **公式要点とリンクの SSOT** とする。

**ファイルパス（エージェント・スキル参照用）:** `c:\yk-skill\rule\SHADCN_UI_RULES.md`

**最終更新:** 2026-05-17

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

---

## 5. workspace-ui-kit 実践メモ（2026-05-17 追記）

`c:\yk-skill\workspace-ui-kit` は shadcn/ui の **base**（Base UI）バリアントを使用している。標準の shadcn/ui とは一部 API が異なるため注意が必要。

### 5-1. `asChild` は使わない → `render` を使う

このプロジェクトでは shadcn の **Base UI** を採用しているため、`asChild` prop は動作しない（DOM に素通りして React 警告が出る）。代わりに **`render` prop** を使う。

```tsx
// ❌ 標準 shadcn/ui の書き方（このプロジェクトでは使えない）
<Button asChild>
  <a href="https://example.com">開く</a>
</Button>

// ✅ workspace-ui-kit の正しい書き方
<Button render={<a href="https://example.com">開く</a>} />
```

`TooltipTrigger` / `DialogTrigger` などの Trigger 系も同様に `render` を使う：

```tsx
<TooltipTrigger
  render={
    <Button variant="ghost" size="icon-sm">
      <Settings />
    </Button>
  }
/>
```

### 5-2. SidebarProvider を使う 3 ペイン構成パターン

Sidebar（Pane1） + SidebarInset（Pane2以降）の構成が基本。

```tsx
<SidebarProvider defaultOpen className="h-screen w-full overflow-hidden">
  <Sidebar collapsible="icon">   {/* Pane 1 */}
    ...
  </Sidebar>
  <SidebarInset className="flex min-w-0 flex-col">
    <header>...</header>          {/* グローバルヘッダー */}
    <div className="flex min-h-0 flex-1">
      {/* Pane 2 */}
      {/* Pane 3 */}
    </div>
  </SidebarInset>
</SidebarProvider>
```

- `h-screen overflow-hidden` を SidebarProvider に付けてビューポート固定
- 各ペインで `min-h-0` を付けないと `ScrollArea` が伸びきらないことがある
- Pane1 の折りたたみトグルは `Pane1Toggle` コンポーネントを再利用できる

### 5-3. コーディングルール（CLAUDE.md より抜粋）

| ルール | 理由 |
|--------|------|
| 子要素の間隔は親で `flex flex-col gap-*` | `space-y-*` は使わない |
| 色は役割トークンで指定（`bg-primary` 等） | `bg-blue-500` のような色番号は使わない |
| 正方形要素は `size-N` | `w-N h-N` は使わない |
| shadcn 部品が使えるなら自前 `div` で代替しない | |
| 部品の見た目を呼び出し側の `className` で打ち消さない | 部品側に variant を追加する |
