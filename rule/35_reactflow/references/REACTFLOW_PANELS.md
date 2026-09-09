# React Flow — ワークスペースペイン / react-resizable-panels（L3 参照）

**SSOT:** 本ファイル · **索引:** [`REACTFLOW_RULES.md`](../REACTFLOW_RULES.md) §5（永続化）· §5.6（実用版 UX）
**ROUTER tag:** `persist` · `next-shell`（パネル構造・レイアウトキーを触るとき）
**対象:** `react-resizable-panels` v4（`Group` / `Panel` / `Separator` / `useDefaultLayout`）を使うアプリ — `flowchart-studio` · `comment-studio` 等
**最終更新:** 2026-09-09（B3 · `REACTFLOW_RULES` 旧 §5-P〜§5-S ＋ `REACTFLOW_UX_WORKSPACE` 旧 §5.6-10 を集約）

**関連:** ペイン幅の既定値・リセット SSOT → [`REACTFLOW_UX_CHROME.md`](REACTFLOW_UX_CHROME.md)（表｜プレビュー比率 · 左ナビ幅 · `workspacePaneLayout.ts`）· 列順 normalize → [`REACTFLOW_UX_WORKSPACE.md`](REACTFLOW_UX_WORKSPACE.md) §5.7

---

## 1. 3ペイン PanelGroup（react-resizable-panels v4 · ADR-016 PR-B · 旧 §5.6-10）

デスクトップ（lg+）: 外側 `Group`（ナビ｜エディタ）+ 内側 `Group`（表｜プレビュー）。モバイルは既存タブ UX（`useIsDesktop` フックで切り替え）。

**react-resizable-panels v4 — v2/v3 からの破壊的変更（型定義を読まないと気づかない）**

| v2/v3 | v4 | 備考 |
|-------|-----|------|
| `PanelGroup` | `Group` | — |
| `PanelResizeHandle` | `Separator` | — |
| `direction="horizontal"` | `orientation="horizontal"` | — |
| `autoSaveId="key"` prop | `useDefaultLayout({ id: "key" })` フック | localStorage 永続化 |
| `ref` on Panel | `panelRef` prop + `usePanelRef()` | 型: `PanelImperativeHandle` |
| `onCollapse`/`onExpand` prop | **なし** — `onResize` + `panelRef.current?.isCollapsed()` | 折りたたみ検知パターン |

**`Panel` の `className` は外側 flex アイテムではなく内側ネスト div に適用される。** flex 子として min-h-0 を設定するなら `<Panel className="flex min-h-0 flex-col">` で OK（外側は Group が flex サイジング）。

**collapse/expand をボタンからトリガーするパターン（`FlowchartWorkspace.tsx` 参照）:**

```tsx
const navPanelRef = usePanelRef();
const handleToggle = () => {
  const p = navPanelRef.current;
  if (!p) { setNavCollapsed(v => !v); return; }
  p.isCollapsed() ? p.expand() : p.collapse();
};
// <Panel panelRef={navPanelRef} collapsible collapsedSize="48px"
//        onResize={() => setNavCollapsed(navPanelRef.current?.isCollapsed() ?? false)} />
```

**`useIsDesktop` フック:** `frontend/src/hooks/useIsDesktop.ts`（`window.matchMedia` · 初期値 `false` で SSR 安全）。親（`FlowchartWorkspace`）で保持し、子（`FlowchartEditor`）へ prop 経由で渡す。フックを両方で呼ぶと render タイミングがずれる。

**`useDefaultLayout` + SSR（`next start` · 2026-06）:** 省略時のデフォルト引数 `storage = localStorage` が**呼び出し時に評価**され、SSR で `ReferenceError: localStorage is not defined` になる。**必ず** `storage: getWorkspaceLayoutStorage()` を渡す（`workspacePaneLayout.ts`）。`react-resizable-panels` を `"use client"` 外のモジュールから import しない（型はローカル interface で足りる）。

**ペイン幅リセット（T4）:** `useGroupRef` × 2（outer + inner）· `resetWorkspacePaneLayouts(outer, inner)` — v1/v2 キーをクリアして `setLayout`（`FlowchartWorkspace` → `FlowchartEditor` → `FlowTableEditor`）。

**tsconfig パスエイリアス:** `frontend/src/` 配下に新サブディレクトリを作ったら `tsconfig.json` の `paths` に `"@/hooks/*": ["./frontend/src/hooks/*"]` を追加する（既存の `@/components/*` と同型）。

---

## 2. localStorage レイアウトキーのバージョニング（旧 §5-P）

**対象:** `react-resizable-panels` + `useDefaultLayout` を使うすべてのアプリ（`flowchart-studio` · `comment-studio` 等）の `workspacePaneLayout.ts`（`OUTER_LAYOUT_ID` · `INNER_LAYOUT_ID` · `DEFAULT_*` 等）

**MUST:** `DEFAULT_INNER_LAYOUT`（または outer）のデフォルト比率を変えるときは、**必ず** 以下の 2 点をセットで行う。

| やること | やらないと起きること |
|----------|---------------------|
| `WORKSPACE_INNER_LAYOUT_ID` の末尾を bump（`-v2` → `-v3`） | 既存ユーザーの localStorage に旧比率が残り、新デフォルトが効かない |
| 旧キーを `LEGACY_LAYOUT_IDS` 配列に追加 | ペイン幅リセット時に旧キーが残り、古い比率で上書きされる |

`clearWorkspacePaneStorage()` は現行キー + LEGACY_LAYOUT_IDS をすべて削除する。リセット後に新デフォルトが適用されるには、旧キーがここに含まれていること。

```ts
// NG — キーを変えずにデフォルト比率だけ変更
export const WORKSPACE_INNER_LAYOUT_ID = "flowchart-studio:workspace-inner-v2"; // 旧キーのまま
export const DEFAULT_INNER_LAYOUT = { canvas: 40, table: 60 }; // 比率だけ変えた

// OK — キー bump + 旧キーを LEGACY に追加
export const WORKSPACE_INNER_LAYOUT_ID = "flowchart-studio:workspace-inner-v3";
const LEGACY_LAYOUT_IDS = ["...-v1", "...-v2"] as const;
export const DEFAULT_INNER_LAYOUT = { canvas: 40, table: 60 };
```

**パネル順序を変えるとき（swap）も同様。** デフォルト比率は変わらなくても、Panel の並びが変わるとユーザーの保存値（旧パネル ID 比率）が意図しない幅になりうる。判断基準: レイアウトの**意味が変わる変更**はキー bump する。

---

## 3. 全幅固定ヘッダーは Group の外へ（旧 §5-Q）

`react-resizable-panels` の `<Group>` 内に header を置くと、その Panel の幅にしか広がらない。**全ペインをまたぐ全幅固定ヘッダー**は `<Group>` の外・前に配置する。

```tsx
// NG — header が table Panel 幅に収まる
<Group>
  <Panel id="canvas">…</Panel>
  <Panel id="table">
    <header>…toolbar…</header>  {/* table 幅にしか広がらない */}
    …
  </Panel>
</Group>

// OK — header が Canvas/Table 両ペインをまたぐ全幅
<div className="flex flex-col">
  <header>…toolbar…</header>   {/* Group の外 → 全幅 */}
  <Group className="flex-1">
    <Panel id="canvas">…</Panel>
    <Panel id="table">…</Panel>
  </Group>
</div>
```

Panel 内に残すのは Panel 固有コンテンツ（タブバー・スクロール領域）のみ。`tableTopSlot` · unsaved バナーも同様に Group 外に出す。

---

## 4. Panel 内タブの実装パターン（旧 §5-R）

`fcMobileTabGroup / fcMobileTabActive / fcMobileTabIdle` は名称が "Mobile" だが、**デスクトップ Panel 内タブにも流用可**（同一クラスセット）。

| 項目 | 実装 |
|------|------|
| 表示条件の導出 | `const showRightTabs = !!moduleId && !!designMemoContext;`（nullable を `!!` で AND） |
| タブバー条件 | `{showRightTabs ? <div className={fcMobileTabGroup} role="tablist">…</div> : null}` |
| コンテンツ切替 | `!showRightTabs \|\| rightTab === "table"` の単純分岐（else に設計メモ） |
| state リセット | moduleId 切替の reset effect に `setRightTab("table")` を追加する |

タブが不要な状態（モジュール未選択・`designMemoContext` なし）では `showRightTabs === false` となり、タブバーとコンテンツ分岐を両方スキップして従来の tablePaneBody をそのまま表示する。

---

## 5. Panel 内に sticky ヘッダー + スクロール本体を持たせるレイアウト（旧 §5-S）

Panel に `overflow-y-auto` を付けると Panel 全体がスクロールし、内部の検索バー等の固定ヘッダーも流れてしまう。Panel の `className` を `flex flex-col` にして、スクロールしたい部分だけに `overflow-y-auto` を付ける。

```tsx
// NG: Panel 全体がスクロールし sticky ヘッダーが流れる
<Panel className="min-h-0 overflow-y-auto">
  <StickyBar />
  <ScrollableContent />
</Panel>

// OK: Panel は flex flex-col、スクロールは内側のみ
<Panel className="flex min-h-0 flex-col">
  <StickyBar />                            {/* 固定 */}
  <div className="overflow-y-auto">        {/* ここだけスクロール */}
    <ScrollableContent />
  </div>
</Panel>
```
