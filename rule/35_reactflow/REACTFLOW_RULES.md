# React Flow 開発ルール（ひな形 v0）
## YK 表駆動フローチャート — Design & Development Rules

**ステータス:** `active`（[`RULE_INDEX.md`](../RULE_INDEX.md) Status 列 · L0/L1/L2 整備済）

**SSOT（本ファイル）:** `yk-skill/rule/35_reactflow/REACTFLOW_RULES.md`  
**実行手順・ゲート:** `.claude/skills/creating-reactflow-yk/SKILL.md`  
**ロード規則 SSOT:** `.../creating-reactflow-yk/references/ROUTER.md`

**参照実装:** [`c:/yk-application/flowchart-studio/`](c:/yk-application/flowchart-studio/README.md)  
**企画・ADR:** [`docs/03_技術仕様/意思決定記録(ADR).md`](c:/yk-application/flowchart-studio/docs/03_技術仕様/意思決定記録(ADR).md)（ADR-006 · ADR-010）

**横断:** [`../30_web_stack/REACT_RULES.md`](../30_web_stack/REACT_RULES.md)（React 一般 · Hooks） · [`../30_web_stack/NEXTJS_RULES.md`](../30_web_stack/NEXTJS_RULES.md)（App Router · §5 RSC · §6 flowchart） · [`../45_mermaid/MERMAID_RULES.md`](../45_mermaid/MERMAID_RULES.md) §1.5（方式境界） · [`../10_meta/SECRETS_HYGIENE_RULES.md`](../10_meta/SECRETS_HYGIENE_RULES.md) · [`../10_meta/GIT_WORKFLOW_RULES.md`](../10_meta/GIT_WORKFLOW_RULES.md)

**最終更新:** 2026-06-25（§5.6-10 react-resizable-panels v4 API · 3ペイン PanelGroup · useIsDesktop パターン追記）  
**索引:** [`../RULE_INDEX.md`](../RULE_INDEX.md) No 35

**L0 入口:** 正本 `c:/yk-skill/.cursor/rules/reactflow-dev-entry.mdc`（glob `flowchart-studio/**` · `flowchart-web-mermaid/**`）。同期コピー: `yk-memo/.cursor/rules/` · `yk-tool/.cursor/rules/`。

---

## 0. エージェント向け — いつ何を読むか

| 段階 | 読むもの | タイミング |
|------|----------|------------|
| L0 | `reactflow-dev-entry.mdc` | `flowchart-studio` · `flowchart-web-mermaid` の `lib/flowchart` · UI（studio: `frontend/src/components/flowchart` · mermaid: `components/flowchart`）編集時 |
| L1 | **本ファイル** | 毎回・最初 |
| L2 | `creating-reactflow-yk/SKILL.md` | 手順・ゲート |
| L2.5 | **Ref Plan** | **Write/StrReplace 前**（ROUTER §7 · `creating-mermaid-yk` 同型） |
| L3 | ROUTER の `load` のみ | Ref Plan 後 |

**Ref Plan 不要:** 質問のみ · Read のみ · 本ルール索引の更新のみ。

**誤ルーティング禁止（Mermaid 3分岐 — 固定）**

| 触るもの | 使う入口 | **使わない** |
|----------|----------|--------------|
| **`.mmd`** · diagram-as-code | No 45 · `creating-mermaid-yk` | 本帯 · `flowchart-studio` / `flowchart-web-mermaid` |
| **表 → Mermaid プレビュー**（`flowchart-web-mermaid` · `toMermaid.ts`） | **本帯** · `creating-reactflow-yk` | `creating-mermaid-yk` |
| **表 → React Flow**（`flowchart-studio`） | **本帯** · `creating-reactflow-yk` | `creating-mermaid-yk` |

surge 図解 HTML → `routing-diagram-yk` 系。**表駆動は本帯のみ**（[`RULE_ROUTING_PLAYBOOK.md`](../RULE_ROUTING_PLAYBOOK.md) flowchart 読む順序）。**3 分岐詳細:** [`MERMAID_RULES.md`](../45_mermaid/MERMAID_RULES.md) §1.5-1。

**React 一般（Hooks · 純粋性）:** `frontend/src/components/flowchart/**`（studio）の Client ロジック → [`REACT_RULES.md`](../30_web_stack/REACT_RULES.md) · `creating-react-yk`（**RF API は本 §4**）。

**Next.js シェル:** `app/` · RSC 境界 → [`NEXTJS_RULES.md`](../30_web_stack/NEXTJS_RULES.md) §5 · flowchart パス → **§6** · `creating-nextjs-yk`。

**shadcn / 表 UI:** 現状 flowchart は **shadcn 未導入**（カスタム CSS）。表・ツールバーに shadcn を入れるときのみ [`SHADCN_UI_RULES.md`](../30_web_stack/SHADCN_UI_RULES.md) §13 · `creating-shadcn-yk`。**`workspace-ui-kit` の Base UI（`render` prop）を flowchart に無断コピーしない。**

---

## 1. 四大精神（要約 — Python / Mermaid ルールと同型）

1. **積層的必然** — 表（正本）→ ドメイン生成 → React Flow 表示の順で完成形を残す。レイアウトロジックを Canvas 内に埋め込まない。
2. **仕様先行** — 8列表・列の意味・ADR を先に固定。React Flow は **派生ビュー**（ADR-006）。
3. **論理的生存・可読性** — 孤立ノード · 接続先不明 · バリデーション握りつぶしを残さない。
4. **工数削減** — ドラッグ微調整を主操作にしない（表駆動が本丸 · ADR-010）。

---

## 2. 方式境界（図モダリティ）

**横断 SSOT:** 本節 ↔ [`MERMAID_RULES.md`](../45_mermaid/MERMAID_RULES.md) §1.5 ↔ [`flowchart-studio/README.md`](c:/yk-application/flowchart-studio/README.md) §図モダリティ

| やりたいこと | 選ぶもの | 入口 |
|--------------|----------|------|
| 表 · CSV · ブラウザ編集 · PNG/SVG（**React Flow レイアウト**） | **flowchart-studio** | 参照実装 README · 本ルール |
| 同じ表から **Mermaid プレビュー**（比較 · ADR-010） | **flowchart-web-mermaid** | [`flowchart-web-mermaid/README.md`](c:/yk-tool/flowchart-web-mermaid/README.md) · 本ルール §3-6 |
| テキスト版管理 · **`.mmd`** · MD 埋め込み | **Mermaid DSL（No 45）** | `creating-mermaid-yk` — **表プレビューではない** |
| surge 図解 HTML | **図解スキル系** | `routing-diagram-yk` → `creating-visual-explainers` 等 — **本ルール非使用** |
| Excel 連携デスクトップツール | **Python（MZ 系）** | [`40_python/PYTHON_RULES.md`](../40_python/PYTHON_RULES.md) |

**MUST**

- **正本は表（`FlowchartDocument.table`）** — Excel 8列表 · 図形シートは正本にしない（ADR-010）。
- **reactflow 版の Mermaid エクスポート / インポートは Phase 外**。表 → Mermaid プレビューは **`flowchart-web-mermaid`**（`toMermaid`）。**`.mmd` 執筆は No 45**。
- **同一ノードを二重 SSOT にしない**（表と `.mmd` の両方を正本にしない）。

### 2-1. 二アプリ共通 — `lib/flowchart` 同期

`flowchart-studio` と `flowchart-web-mermaid` は **同一ドメイン層を物理コピー**で保持（共通化パッケージは ADR-010 比較後に検討）。

**MUST:** `parseTable` · `validate` · `buildEdges` · `types` · `layoutGrid` 等 **ドメイン層**を変更するときは **両アプリを同期**する（片方だけ直して比較を壊さない）。アダプタ（`toReactFlow` / `toMermaid`）と UI は各アプリ固有。

---

## 3. アーキテクチャ — MUST（`flowchart-studio` · `flowchart-web-mermaid` 共通 + アダプタ）

### 3-1. レイヤ分割

| レイヤ | パス | 規則 |
|--------|------|------|
| **ドメイン** | `lib/flowchart/`（`model/` · `table/` · `graph/` · `visual/` · `policy/` · `import/` · `browser/`） | **React 非依存**（`browser/` は永続化のみ例外）。表パース · 検証 · レイアウト · エッジ生成 |
| **アダプタ（RF）** | `lib/flowchart/graph/toReactFlow.ts` | `PlacedNode` + `FlowEdge` → `@xyflow/react` |
| **アダプタ（Mermaid）** | `lib/flowchart/toMermaid.ts`（**mermaid 版のみ**） | 同上 → Mermaid `flowchart TD` 文字列（**座標は使わない**） |
| **UI（flowchart-studio）** | `frontend/src/components/flowchart/` | Client 層 · プレビュー · 表 UI · PNG/SVG（`exportPng.ts` 等） |
| **UI（flowchart-web-mermaid）** | `components/flowchart/` | 同上（旧単一ツリー構成） |

**四層 SSOT（studio）:** [`flowchart-studio/docs/04_リポジトリ構造/リポジトリ構造.md`](c:/yk-application/flowchart-studio/docs/04_リポジトリ構造/リポジトリ構造.md)

**禁止:** `parseTable` / `layoutGrid` / `buildEdges` に JSX や `useReactFlow` を置く。逆に UI 層に列定義ロジックを複製しない。

### 3-2. 生成パイプライン（SSOT 順序）

```
validateTable(table)
  → parseTable → { nodes, rowMap }
  → measureRowHeights(rowMap, layout)
  → layoutGrid(rowMap, rowHeights, layout) → { placed, bounds }
  → buildEdges(nodes, placed) → FlowEdge[]
  → toReactFlow(...)  または  toMermaid(...)   // アプリ別アダプタ
```

**入口（ドメイン）:** `generateFlowchart()` — **`toReactFlow` / `toMermaid` は含まない**。UI が `generateFlowchart` の戻り値にアダプタを適用する。

**変更時の原則:** 座標・分岐・合流の修正は **表 or レイアウト層** を先に疑う。Canvas 上の手動座標は採用しない。

### 3-5. シグナル → 触る層（Ref Plan 用）

**手順:** ROUTER §4 で **tag** 決定 → 本表で **層** 確定 → **ファイル floor の正本は ROUTER §3**（本表は L1 要約）。

| 症状・依頼 | tag | 層 | floor（Read 優先 · 詳細は ROUTER §3） |
|------------|-----|-----|--------------------------------------|
| 列・接続先・バリデーション | `table-ui` | ドメイン | `table/parseTable.ts` · `model/validate.ts` · `table/tableColumns.ts` |
| 行高 · Level 座標 · 分岐位置 | `layout` | レイアウト | `graph/layoutGrid.ts` · `graph/measureHeights.ts` |
| Yes/No エッジ · 肘/直線 | `edges` | エッジ | `graph/buildEdges.ts` · `graph/edgeLabelPlacement.ts` · `model/types.ts` |
| テーマ色 · RF Node/Edge 形 | `canvas` | アダプタ RF | `graph/toReactFlow.ts` · `visual/flowColors.ts` |
| Mermaid DSL 生成 · 形状記法 | `mermaid-preview` | アダプタ Mermaid | `toMermaid.ts`（mermaid 版） |
| ブラウザ Mermaid 描画 | `mermaid-preview` | Mermaid UI | `MermaidPreview.tsx` |
| 真っ白 · 高さ 0 · fitView · 操作ロック | `canvas` | Canvas UI | `FlowCanvas.tsx` · `FlowchartEditor.tsx` · `flowTypes.ts` |
| PNG/SVG 出力 | `export` | エクスポート | `frontend/src/components/flowchart/exportPng.ts` · `exportSvg.ts`（studio） |
| 表 UI · stale · 生成ボタン | `table-ui` | エディタ UI | `FlowchartEditor.tsx` · `FlowTableEditor.tsx` |
| `app/page` · ルートのみ | `next-shell` | Next シェル | `app/page.tsx` · [`NEXTJS_RULES`](../30_web_stack/NEXTJS_RULES.md) §6 |

### 3-3. 型の正本

- ドメイン型: `lib/flowchart/types.ts`（`FlowNode` · `FlowEdge` · `FlowchartDocument` · `LayoutConfig`）
- React Flow 用データ: `FlowNodeData`（`toReactFlow.ts`）
- 形状種別（表）: `ShapeType` — `端子` · `処理` · `判断` · `入出力` · `手動入力`
- 描画種別: `ShapeKind` — `rectangle` · `diamond` · `rounded` · `parallelogram` · `manual`

`normalizeShapeType.ts` 経由で表記ゆれを吸収。新形状は **型 + layoutGrid + FlowShapeNode** をセットで追加。

### 3-4. レイアウト規約

| 項目 | 規則 |
|------|------|
| 主軸 | **行（`rowIndex`）** が縦 · **Level** が横（`layoutGrid`） |
| 接続 | `destsDown` / `destsRight` · 判断は Yes/No ラベル（`buildEdges`） |
| プリセット | `layoutPresets.ts` · `DEFAULT_LAYOUT`（`types.ts`） |
| テーマ | `themes.ts` — RF 版は `toReactFlow` で適用。**Mermaid 版のテーマセレクタは doc 永続化用**（見た目は Mermaid エンジン任せ） |

### 3-6. `toMermaid` — MUST（`flowchart-web-mermaid`）

| 項目 | 規則 |
|------|------|
| 入力 | `generateFlowchart` の **`placed` + `edges` のみ**（`x`/`y`/`Level` 座標は Mermaid レイアウトに渡さない） |
| 出力 | `flowchart TD` + ノード行 + `-->` エッジ（Yes/No は `\|Yes\|` / `\|No\|`） |
| ノード ID | `mermaidNodeId()` — 表 ID を `n…` にサニタイズ（Mermaid パーサ安全） |
| 形状 | `ShapeKind` → Mermaid 記法（`diamond`→`{}` · `rounded`→ stadium · `parallelogram`→`[/…/]` · `manual`→`[(…)]` · 他→`[]`） |
| ラベル | 改行は `<br/>` · `"[]{}` は HTML エンティティでエスケープ |
| レイアウトプリセット | **Mermaid 見え方にはほぼ効かない**（比較時は **分岐・合流の構造**を見る · ADR-010） |
| 検証 | `toMermaid.test.ts` · `npm run test` |

**禁止:** `.mmd` ファイルを正本にする · `creating-mermaid-yk` / `mmdc` を表プレビューの実行経路にする（No 45 は DSL 専用）。

**参照実装:** `c:/yk-tool/flowchart-web-mermaid/lib/flowchart/toMermaid.ts`

---

## 4. React Flow（@xyflow/react）— MUST

**汎用 React → [`REACT_RULES.md`](../30_web_stack/REACT_RULES.md)。本 § は @xyflow/react の YK 不変条件のみ。**

**L1 §4 は YK 不変条件（表駆動 · 操作ロック · エクスポート経路）のみ。** props 網羅列挙 · 追加公式 URL は ROUTER §3 の該当 tag に **Learn / Troubleshooting 1 ページまで**（Ref Plan `load` 必須）。

**Canvas 変更の default template:** `FlowCanvas.tsx` · `flowTypes.ts` · `toReactFlow.ts`（Examples の UI シェルではない）。

### 4-0. 公式参照 — エージェント索引

| 区分 | 扱い |
|------|------|
| **L1 記載（毎回 Read 不要）** | §4-1 MUST 表 · §4-2 v12 要約 · 参照実装パターン |
| **Ref Plan `load` で Read 可** | [Quick Start](https://reactflow.dev/learn) · [Common Errors](https://reactflow.dev/learn/troubleshooting/common-errors) · [Migrate to v12](https://reactflow.dev/learn/troubleshooting/migrate-to-v12) · [Custom Nodes](https://reactflow.dev/learn/customization/custom-nodes) · [Custom Edges](https://reactflow.dev/learn/customization/custom-edges) · tag 固有は ROUTER §3 |
| **禁止** | `/examples/*` から **UI シェル全体**をコピー · `useNodesState` + `onConnect` で表を正本化 · ドメインパイプライン bypass |

### 4-1. React Flow MUST（表駆動不変条件）

| 項目 | 規則 |
|------|------|
| パッケージ | **`@xyflow/react`**（v12 系 · 参照実装 `^12.10.x`）。v11 `reactflow` パッケージ禁止 |
| CSS | **`import '@xyflow/react/dist/style.css'` を MUST**（Client 入口 · 参照: `FlowCanvas.tsx`）。Tailwind v4 で global に置く場合は `@import "tailwindcss"` の**後**（[Quick Start](https://reactflow.dev/learn)） |
| 親コンテナ | `<ReactFlow>` の**直接親**に `width`/`height`（Tailwind なら `w-full h-full min-h-[420px]` 等）を MUST。`h-full` は親チェーンも Read（`FlowchartEditor.tsx` ラッパー） |
| カスタムノード/エッジ | **`flowTypes.ts` で `flowNodeTypes` / `flowEdgeTypes` をモジュールスコープ定義**（`nodeTypes` / `edgeTypes` ともレンダー毎新規オブジェクト禁止 · [Common Errors](https://reactflow.dev/learn/troubleshooting/common-errors)）。`memo()` 推奨（`FlowShapeNode` · `LabeledEdge`） |
| カスタムエッジ実装 | `BaseEdge` + `getStraightPath` / `getBezierPath` 等 · `EdgeLabelRenderer` · 型 `labeled`（`edges/LabeledEdge.tsx`） |
| ノード寸法（v12） | **`toReactFlow` が layout 由来の `width`/`height` を設定**（固定寸法）。`node.measured.*` は RF 内部計測 — 表駆動では触らない |
| ノード単位 | `toReactFlow` で各 Node に `draggable: false` · `selectable: false` · `connectable: false` |
| **複数行ラベル（Text1–3）** | `parseTable` が `\n` 結合 · **`FlowShapeNode` は `flex-col`**（行方向 `flex` 禁止）· 行高は `measureHeights` の `textLineCount`（§5.6-4） |
| 操作（グローバル） | 公式デフォルトは `nodesDraggable` / `nodesConnectable` / `elementsSelectable` / `edgesReconnectable` すべて **`true`**。表駆動は **四つとも `false` を MUST**（`FlowCanvas.tsx`）。`readOnly` prop は v12 で廃止 — 上記が SSOT |
| Provider | **`ReactFlowProvider` でラップ MUST**。**`useReactFlow` は Provider の子のみ**（Provider 自身の中では不可 · Common Errors） |
| 状態 | nodes/edges は **`generateFlowchart` → `toReactFlow` 派生**。`useNodesState` + `onConnect` を表更新の主経路にしない |
| fitView | **ホーム表示:** `computeHomeViewport`（`lib/flowchart/visual/flowHomeViewport.ts`）— 横フィット + 上段揃え · 動作切替・⌂ ホームで適用。**エクスポート:** `fitViewFull` + `fcFitViewOptions`（全体センター fit）· PNG/SVG 前 **~300ms 待機**（`FlowchartEditor.tsx`）。`<ReactFlow fitView />` prop は使わない |
| 閲覧操作 | **`panOnDrag` · `zoomOnScroll` は許容**（ADR-010）。`Controls showInteractive={false}` |
| エクスポート | `data-flowchart-export-root` → **`.react-flow__viewport`** を `html-to-image`（`toPng` / `toSvg`）· **`exportImageFilter.ts`** で Controls · プレビュー専用 UI（`.flow-node-id` 等）を除外（`exportPng.ts` · `exportSvg.ts`） |
| 安定参照 | `defaultEdgeOptions` 等も **`useMemo` またはモジュール外**（参照: `FlowCanvas.tsx`） |

**禁止（`flowchart-studio` / `flowchart-web-mermaid` 系）**

- ドラッグでレイアウトを正本として保存する設計
- `onConnect` / `onReconnect` で表を書き換える主経路
- **`flowTypes.ts` 外で `nodeTypes` / `edgeTypes` オブジェクトを生成**
- **Provider 外で `useReactFlow`**
- **`@xyflow/react/dist/style.css` 未 import**
- 公式 Examples から **UI シェル全体**をコピペし **ドメイン · レイアウトパイプラインをバイパス**（単一 API 確認は §4-0 · Ref Plan 必須）
- v11 API: `onEdgeUpdate` · `edgesUpdatable` · `readOnly`（→ §4-2）

**許容:** 既存 `FlowCanvas.tsx` / `toReactFlow.ts` パターンの拡張 · stale UX。**新規 RF API** は ROUTER tag `canvas` で公式 Learn / Troubleshooting **1 ページまで**（Ref Plan 必須）。

**イベントハンドラ追加時:** `onNodesChange` / `onEdgesChange` / `onConnect` 等は **`useCallback` またはモジュール外**（Common Errors · 無限 re-render 防止）。

### 4-2. v12 — YK で触る項目のみ

| 項目 | YK の扱い |
|------|-----------|
| パッケージ名 | `@xyflow/react` + named import `{ ReactFlow }` |
| `readOnly` 廃止 | §4-1 の interaction props 四 `false` が SSOT |
| `onEdgeUpdate` → `onReconnect` | 触らない（`edgesReconnectable: false` 固定 · `onReconnect` 不要） |
| `node.width`/`height` vs `measured` | `toReactFlow` / layoutGrid が `width`/`height` を設定。`measured` は読み取り専用 |
| 状態更新 | nodes/edges 更新は **イミュータブル**（スプレッド）。ミューテーション禁止（Migrate to v12） |
| Examples の `useNodesState` | 表駆動では **静的 props 渡し**が主経路 |

### 4-3. Mermaid プレビュー（`flowchart-web-mermaid`）— MUST

| 項目 | 規則 |
|------|------|
| パッケージ | **`mermaid` npm**（ブラウザ `mermaid.render()` · `"use client"` 必須） |
| 初期化 | `securityLevel: "strict"` · `startOnLoad: false`（`MermaidPreview.tsx`） |
| 入力 | `toMermaid()` の **文字列**（`.mmd` ファイルを Read しない） |
| エクスポート | **描画済み SVG** から PNG/SVG（`exportMermaid.ts`）— RF 版の `html-to-image` + viewport とは別経路 |
| 開発ポート | [`NEXTJS_RULES.md`](../30_web_stack/NEXTJS_RULES.md) §6-1（reactflow **3000** · mermaid **3001**） |

**検証:** `mmdc` / `.mmd` CI ゲートは **No 45 専用**。表プレビューアプリでは `npm run test` + 手動プレビュー。

---

## 5. 永続化・下書き

| 項目 | 値 |
|------|-----|
| localStorage キー | `flowchart-studio:draft-v1`（SSOT: `lib/flowchart/browser/storageKeys.ts` · 旧 `flowchart-web:draft-v1` — 2026-06-24 に新キーへ書き換え済み） |
| モジュール下書きプレフィックス | `flowchart-studio:module-v1:` |
| IndexedDB DB 名 | `flowchart-studio-offline-v1` |
| ドキュメント JSON | `FlowchartDocument`（`version: 1`） |

`lib/flowchart/browser/storageKeys.ts` が SSOT（`browser/draftStorage.ts` · `browser/moduleDraftRepository.ts` · `browser/offlineFlowCache.ts` が参照）。**`flowchart-web-mermaid` は別キーのまま · 同期対象外**。

### 5.5 UI 整理 — コードをきれいに保つ（優先度: 高）

実用版 UX ブラッシュアップで **ユーザー向け機能を外すとき**、UI 非表示だけにしない。

| やる | やらない |
|------|----------|
| state · 型 · 保存項目 · 専用モジュールを**同時に削除** | dead code（`themeId` state 等）を残す |
| エンジン定数は 1 本化（`DEFAULT_LAYOUT` · `visual/flowColors.ts`） | 選べなくした preset / theme ファイルを orphan のまま残す |
| 旧 payload フィールドは**読込時破棄** | 互換のため二重管理を永久化 |

**ルール（実装リポ）:** `flowchart-studio/.cursor/rules/ui-simplification-yk.mdc`

### 5.6 実用版 UX（2026-05 ブラッシュアップ）

**対象:** `flowchart-studio` のエディタ UI · 3 ペイン · 表→再生成の日常操作。企画: [相談_2026-05-30_Web版ブラッシュアップ方針.md](c:/yk-application/flowchart-studio/docs/archive/01_要求定義/相談_2026-05-30_Web版ブラッシュアップ方針.md)（Historical）。

**横断 UX チェックリスト:** [`USABILITY_HEURISTICS_RULES.md`](../10_meta/USABILITY_HEURISTICS_RULES.md) No **20**（ニールセン10原則 · 画面設計・レビュー時）

**エージェント向けチェックリスト:** `flowchart-studio/.cursor/rules/flowchart-practical-ux-yk.mdc`

#### 5.6-1 ナビ階層 · 永続化キー

| 項目 | 規則 |
|------|------|
| 階層 | **装置（Nav 最上段 `<select>`）→ ユニット → 動作 → 表｜図** |
| 選択単位 | 動作 1 件 = フロー 1 本（`moduleId`） |
| 保存キー SSOT | `moduleDraftKey(deviceId, moduleId)` → **`${deviceId}:${moduleId}`**（`lib/flowchart/moduleHierarchy.ts`） |
| 読込 | `resolveModuleDraftKey` — **press-01** の旧キー（`supply-feed` 等・装置 prefix なし）へフォールバック可 |
| 装置切替 | 編集中モジュールを退避 → 動作選択クリア → 新装置のユニット一覧 |
| ヘッダー | 装置名は Nav に集約。エディタヘッダーは **選択中フロー文脈**（例: `供給ユニット · 供給動作`）のみ |

#### 5.6-1a モジュール読込の非同期（レース防止 · 2026-06）

左ナビで動作を切り替えると **クラウド / IndexedDB / localStorage** から非同期読込が走る。完了が遅れたり順序が入れ替わると、**別モジュールの内容で上書き**・**サンプル読込後に勝手に切り替わる**症状になる。

| MUST | 実装（`FlowchartWorkspace.tsx` · `FlowchartEditor.tsx`） |
|------|--------------------------------------------------------|
| モジュール選択時に **`initialSnapshot` を即 `null`** | `resetModuleLoadState()` — 前モジュールの snapshot をエディタに渡さない |
| 読込リクエストに **世代 ID（`loadGenerationRef`）** を付与 | 選択のたびに `++` し、古い `loadModule` 完了は **state 更新しない** |
| 読込完了時は **世代が一致するときだけ** `setInitialSnapshot` · `setLoadKey` | `isModuleLoadStale(generation)` — **`getOfflineModuleCache` の await 後も再チェック** |
| 装置切替時も世代を進める | 進行中の `loadModule` を無効化 |
| **同一モジュール選択中にユーザーが内容を上書きしたら世代を進める** | `invalidatePendingModuleLoad()` — サンプル · 表編集 · CSV · JSON 取込 · 再生成。`userContentOverrideRef` を立てる · `initialSnapshot` を `null` に戻す。`setLoadKey` は**進めない** |
| 無効化後は **読込中バナーを下ろす** | `setLoadingModule(false)` |
| 遅延 `loadModule` は **override 中は適用しない** | `userContentOverrideRef` · `skipSnapshotHydrationRef`（`FlowchartEditor` の useEffect 水合わせスキップ） |
| キャンセル時は **IndexedDB へ古い cloud を書き戻さない** | `loadModuleDraft(..., { isCancelled })` — cloud 取得後・`putOfflineModuleCache` 前にチェック |
| **フロー自動保存で `revalidatePath("/")` しない** | `saveFlowDocument` — 保存完了後の Router refresh が遅延巻き戻しの一因になりうる |

**確認（手動または E2E）:**

1. モジュール A 選択 → サンプル読込 → **数秒待っても** サンプル表示が保存内容に戻らないこと（パターン A · 本番 cloud 遅延で顕在化しやすい）
2. モジュール A 選択 → サンプル読込 → すぐモジュール B — 表示が A/B で意図せず入れ替わらないこと

E2E: `e2e/edge-label-placement.spec.ts`（モジュール選択中サンプル · 巻き戻し防止）

#### 5.6-1d 装置プリフェッチ（2026-06）

動作切替のたびに `loadFlowDocument` を逐次呼ぶと遅い。**装置選択時**に配下モジュールを一括取得する。

| MUST | 実装 |
|------|------|
| 一括 RPC | `loadFlowDocumentsBatch`（`flowDocuments.ts`）— `module_id IN (...)` |
| プリフェッチ | `prefetchDeviceModuleDrafts`（`moduleDraftLoader.ts`）— warm cache + IndexedDB |
| トリガー | `FlowchartWorkspace` — `device.id` 変更時 · 装置切替で `prefetchGenerationRef` を進めてキャンセル |
| 動作切替 | warm cache 命中時はクラウド往復なし（`loadModuleDraft` 先頭） |

#### 5.6-1b サンプル／雛形と自動保存（2026-06）

| MUST | 実装 |
|------|------|
| **サンプル（例）はプレビューのみ**（`persist: false`） | `onPreviewSample` → `runGenerate(..., { persist: false })` |
| **モジュールに保存するのは明示操作のみ** | 「モジュールに適用」· 雛形適用 · 表 JSON 取込 · 再生成 |
| **編集済みモジュールへの破壊的適用は確認** | `isModuleContentDirty`（`moduleContentDirty.ts`）— `userTouched` · `committedJson` · `initialSnapshot` |
| **プレビュー中は復元点を保持** | `prePreviewRestoreRef` — 「プレビューを終了」で復元 |
| **空モジュール**（dirty でない） | 雛形は無確認適用可 · サンプルはプレビュー → 任意で適用 |

**確認（手動または E2E）:** 表編集後に「例を見る」→ プレビュー終了で元の表が残る · 編集後に雛形適用で確認ダイアログ

#### 5.6-1c モジュール削除の楽観 UI（2026-06）

動作削除成功直後、サーバー refresh 完了前に左ナビから当該行を消す。

| MUST | 実装 |
|------|------|
| 削除成功後 **`optimisticRemovedModuleIds` に moduleId を追加** | `FlowchartWorkspace.tsx` · `excludeModulesFromDevices`（`moduleHierarchy.ts`） |
| サーバー反映済み ID は楽観セットから外す | **`useMemo` で派生**（`activeOptimisticRemovedModuleIds`）— `useEffect` 内の `setState` は **禁止**（`react-hooks/set-state-in-effect`） |
| E2E | 成功バナー **と** ナビから当該動作が消えること（`e2e/module-delete.spec.ts`） |

#### 5.6-2 ツールバー（AppHeader）

| 常時表示 | その他メニュー（`EditorMoreMenu`） |
|----------|-------------------------------------|
| **再生成**（主操作 · stale 時は視覚強調） | PNG · SVG |
| 表を保存 · 表を読込（editor のみ） | オフライン用に保存（モジュール選択時） |
| | **装置取込 → import.jsonを取込…**（editor · workspace · `005` RPC 要） |
| | **危険 → フローをリセット…**（確認ダイアログ文言は「フローを雛形にリセットしますか？」のまま） |
| | サンプル表 · 下書き削除（非 workspace） |

- ボタン追加前に **「常時か / その他か」** を決める（§5.5 と併用）。
- JSON 編集タブは **出さない**（保存形式としての JSON は `document.ts` · 表を保存/読込）。

#### 5.6-2a UI 操作部品 · workspace レイアウト（2026-06 · スタイル Phase 2）

**入口（人間・エージェント）:** [`docs/design-system.md`](c:/yk-application/flowchart-studio/docs/design-system.md) — レイヤー A〜E · 変更マップ · Phase 1–2

| 項目 | SSOT |
|------|------|
| スタイルガイド索引 | `flowchart-studio/docs/design-system.md` |
| 操作 UI トークン | `app/globals.css` の `--flow-*` → `@theme` の Tailwind `flow-*` ユーティリティ |
| ボタン・ダイアログ・ナビ・表 chrome class | `frontend/src/components/flowchart/flowchartUiClasses.ts`（`fcBtn*` · `fcTable*` · `fcColorLegend*` · `fcZoomBtn` · `fcTextUi` / `fcTextHint`） |
| プレビュー初期表示 | `lib/flowchart/visual/flowHomeViewport.ts` · `FlowCanvas.applyHomeViewport` |
| 開発用見本ページ | `app/dev/style/` — `npm run dev` 時 `http://localhost:3000/dev/style`（本番 **404**） |
| 表ペイン : プレビュー比率（スタンドアロン） | `FC_WORKSPACE_MAIN_GRID` = **`2fr:3fr`**（`lg:grid-cols-[2fr_3fr]`）— `workspaceMode` デスクトップは PanelGroup で上書き |
| 左ナビ幅（デスクトップ PanelGroup） | **18% default · 160px min · 28% max · 48px collapsed**（`flowchart-studio:workspace-outer-v2`） |
| 表｜プレビュー（デスクトップ PanelGroup） | **52% : 48%（400px min : 280px min）**（`flowchart-studio:workspace-inner-v2`）· v1 はリセットまで維持 |
| ペイン幅 SSOT · リセット | `frontend/src/components/flowchart/workspacePaneLayout.ts` — `DEFAULT_*_LAYOUT` · `resetWorkspacePaneLayouts` |
| 枠線太さ | [`VISUAL_DESIGN_RULES.md`](../10_meta/VISUAL_DESIGN_RULES.md) §2 と整合 |

**禁止:** フロー編集 chrome に `blue-600` 等の Tailwind 色を直書き（`flowchartUiClasses.ts` 経由）。キャンバス色は `visual/flowColors.ts`（§5.6-3）— chrome と混在させない。

**却下（2026-06）:** 12 カラム CSS grid への移行 — 現比率で目的達成 · 大規模リファクタ不要。

#### 5.6-2c 操作 chrome — 文字サイズ · コントロール（2026-06）

WCAG 2.2 は最小 px を規定しない（SC 1.4.4 は 200% 拡大）。YK 実務:

| トークン | 値 | 用途 |
|----------|-----|------|
| `--flow-font-ui` | `0.875rem`（14px） | ボタン · 表 · メニュー項目 |
| `--flow-font-hint` | `0.75rem`（12px） | 凡例 · セクション説明 · メタ（**これ未満にしない**） |
| `--flow-control-size` | `2rem`（32px） | ツールバー · ズーム `−` `%` `+` `⌂` の高さ/幅 |

| MUST | 実装 |
|------|------|
| 新規 chrome class | `fcTextUi` / `fcTextHint` / `fcControlSquare` 経由（`text-xs` 直書き禁止） |
| その他メニュー | `text-left` · `justify-start`（`EditorMoreMenu` · `fcMenuItem`） |
| ズーム UI | 倍率 `%` 表示 · ホームは Lucide `Home` · `onViewportChange` で同期 |

#### 5.6-2b 装置一括取込（Excel パイプライン · ADR-014 · 2026-06）

| 項目 | 規則 |
|------|------|
| **作者入力** | 1 xlsx = 1 装置 · 構成 1 シート + ユニット数フローシート · 動作表は**横並び** · 各動作 = Excel **テーブル** |
| **正規化 SSOT** | **Python** `flowchart-studio/python/` → `import.json`（Power Query 任意 · VBA 禁止） |
| **Web 入口** | その他 → **import.jsonを取込…**（`EditorMoreMenu` · editor · workspace） |
| **DB** | RPC **`import_equipment_bundle`**（`005_import_equipment_bundle.sql`）— 4 表 + `flow_documents` · 1 トランザクション |
| **再取込** | upsert のみ · 構成行削除の **prune なし** |
| **Git（作者 xlsx）** | **`*.xlsx` / `*.xls` はコミットしない** — ローカル編集 · 共有は **`import.json`**（`python/.gitignore`）· CI は `excel:template` / `excel:fixture` で生成 |
| **設計 SSOT** | [Excel取込.md](c:/yk-application/flowchart-studio/docs/03_技術仕様/Excel取込.md) |

- **Web は入力用 xlsx を読まない**（横並び分割は Python 側）。
- テーブル名規約 v0.1: **`{ユニット短名}_{動作名}`**（例: `供給_取出`）— ブック全体で一意。
- dev DB: Runbook `docs/runbooks/DB2_MIGRATION_RUNBOOK.md` — **004 後に 005**。

**YK パターン補足 — Web 表ペイン Excel 取込と v2 列順（2026-06）**

| 経路 | 列順 |
|------|------|
| Python → `import.json` → RPC | **v2 正本**（`normalize_device.py` · `prepareImportBundleForRpc`） |
| 表ペイン **Excelから取込…**（`parseExcelBuffer`） | **v2 正規化済**（`ensureParsedTable10ColV2Order` · 取込直後） |

| 症状 | 対処 |
|------|------|
| 取込後 **接続先エラー** · Text/MR が列ずれ | **repair スクリプトは作らない** — 取込直後に `migrateTable10ColV1ToV2` / `normalizeFlowchartDocument` を通す（**取込後 v2 正規化必須** · §5.6-2b 上段） |
| 本番・import.json データ | §5.7 の normalize 経路で OK（session 48 色列バグは別件） |

**既存コマンド（新規スクリプト不要）:** `npm run excel:a0001:scratch` · `excel:a0001:normalize` · `seed:a0001`

#### 5.6-3 見た目の固定（ユーザー向け選択なし）

| 項目 | SSOT |
|------|------|
| レイアウト寸法 | `DEFAULT_LAYOUT`（`model/types.ts`）— サイズ preset なし |
| 矢印・ラベル色 | `visual/flowColors.ts` — テーマ切替なし |
| ノード枠の太さ・色 | `FLOW_NODE_FRAME_WIDTH` / `FLOW_NODE_DIAMOND_STROKE_WIDTH`（**2px** · 菱形は `miter`）· [`VISUAL_DESIGN_RULES.md`](../10_meta/VISUAL_DESIGN_RULES.md) §2 |
| **斜め図形（入出力・手動入力）** | `FlowShapeNode` — **SVG `polygon` stroke**（菱形と同様）。**`clip-path` + CSS border は禁止**（角が途切れる） |
| **10 列表 · 色列** | 最右列「色」— 狭い中央ペインでは**表コンテナ横スクロール**で表示（列自体は省略しない） |
| Yes/No ラベル | `graph/edgeLabelPlacement.ts` — **halo**（透明＋白縁文字）· 線の右 `FLOW_EDGE_LABEL_GAP`（`edge.data.branch` + `direction`） |

#### 5.6-4 プレビュー edges の鮮度（落とし穴 · 2026-05）

| 禁止 | 理由 |
|------|------|
| **保存済み `snapshot.edges` を `toReactFlow` なしでそのまま表示** | 旧形式（`edge.label` + 白 pill・線上）が残る。モジュール選択時に再発しやすい |
| **`toReactFlow` で `edge.label` / `labelBgStyle` を付与** | `BaseEdge` が SVG ラベルを二重描画する。文言は **`data.edgeLabel` のみ** · `labelShowBg={false}` |

| 必須 | 実装 |
|------|------|
| 表からの再生成後だけ edges を state に載せる | `runGenerate` → `toReactFlow` |
| モジュール復元時 | `initialSnapshot` 読込後に **`runGenerate(committedJson \|\| jsonText)`**（`FlowchartEditor`） |
| 古い snapshot 互換 | `LabeledEdge` で `edgeLabel` + Yes/No から `branch` / `direction` を推定 |

**確認:** サンプル読込だけでなく **モジュール選択中**（左ナビ）でも Yes/No が halo・線の右であること。E2E は `e2e/edge-label-placement.spec.ts`（§6）。No の縦脚幾何はエルボー形状のため **halo スタイル**を優先し、Yes の縦線右オフセットを幾何 assert の代表とする。

#### 5.6-5 警告（`model/validationMeta.ts`）

| 種別 | 挙動 |
|------|------|
| **警告** | 生成 **継続** · 琥珀バナー · 行クリックでジャンプ |
| **エラー** | 生成 **停止**（ADR-002） |

- バナー説明 SSOT: `WARNING_BANNER_HINT`（「図はこのまま生成されます…」）。
- 文言は **列名**（接続先(下) 等）と **直し方** をセット。判断ノードは Yes=下 · No=右 を案内してよい。

#### 5.6-6 作者向け記述（図形 · 色）

| 項目 | SSOT |
|------|------|
| **作者向け記述（図形 · 色 · ループ）** | [`docs/03_技術仕様/作者ガイド.md`](c:/yk-application/flowchart-studio/docs/03_技術仕様/作者ガイド.md)（§2 図形 · §3 色 · §4 ループ） |
| **列ヘルプ（表 UI ?）** | `table/tableColumns.ts` — `SHAPE_TYPE_COLUMN_HELP` · `COLOR_COLUMN_HELP` · `CONNECT_RIGHT_HELP` |
| **プレビュー凡例** | `visual/flowColors.ts` — `COLOR_HINT_LEGEND_ITEMS`（`FlowColorLegend`） |

- **図形・色の種類追加**は同 SSOT §1 の結論に従う（当面は維持 · 将来候補=サブルーチン記号）。

#### 5.6-7 図形描画 · エッジ配線（2026-06）

| 項目 | SSOT · 方針 |
|------|-------------|
| **菱形** | SVG `polygon` · `FLOW_NODE_DIAMOND_STROKE_WIDTH` |
| **入出力（平行四辺形）· 手動入力（台形）** | 同上 — `SlantedPolygonShape` · **`globals.css` の clip-path 禁止** |
| **順方向エッジ（接続先(下)）** | `graph/buildEdges.ts` — `tierDiff > 0`（先が下段）→ `sourceSide=bottom` · `targetSide=top`（合流も top 入口）。**`levelDiff` 単独で left 入口にしない** |
| **ループエッジ** | 同上 — 戻り先 `rowIndex < source` で `isLoop` · `route: elbow` · 左/右入口 |
| **プレビュー ID バッジ** | `FlowShapeNode` — 表 ID を左上表示。**PNG/SVG に含めない**（`exportImageFilter` · class `flow-node-id` · §4 エクスポート） |
| **表の書き方（作者）** | [`docs/03_技術仕様/作者ガイド.md`](c:/yk-application/flowchart-studio/docs/03_技術仕様/作者ガイド.md) **§4**（No → 右列1行 → 接続先(下) で戻す） |
| **列ヘルプ** | `table/tableColumns.ts` — `CONNECT_RIGHT_HELP` |
| **E2E** | `e2e/curry-loop.spec.ts`（ループ · 斜め図形 · ID バッジ）· `fixtures/sample-curry.json` · `generate.test.ts`（順方向配線） |

#### 5.6-9 FlowTableEditor — 表コンテナ minWidth（2026-06）

表の列幅合計を `style={{ minWidth }}` に設定しないと、ウィンドウ縮小 → 拡大時に列が潰れたまま戻らないリサイズ視覚バグが出る。

| MUST | 実装 |
|------|------|
| `<table style={{ minWidth: tableMinWidth }}>` | `tableMinWidth = getTotalDefaultWidth(colCount, tableSchema)` (`tableColumnWidths.ts`) |
| 列幅 SSOT | `DATA_COL_WIDTHS_10_V2` (`tableColumnWidths.ts`) — スキーマ別に分岐 |
| 表示ラベル SSOT | `getDisplayHeaders(colCount, schema)` — 短縮ラベル（例: "接続先(下)" → "下先"） |

---

#### 5.6-10 3ペイン PanelGroup（react-resizable-panels v4 · ADR-016 PR-B · 2026-06）

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

#### 5.7 スキーマバージョニング — 列順変更の手順（ADR-016 · 2026-06）

テーブル列構造を変えるときの定石。**TypeScript と Python を必ず同時に更新**。

**TypeScript 側（`lib/flowchart/table/`）**

| 手順 | 実装例 |
|------|--------|
| 旧スキーマ定数を残す | `TIER10_V1_SCHEMA = "table-10col-v1"` |
| 新スキーマ定数を追加 | `TIER10_SCHEMA = "table-10col-v2"` |
| 移行関数（行レベル）を追加 | `migrateTable10ColV1ToV2(row)` — `[r[0], r[1], r[9], r[2]...]` |
| ドキュメント移行ラッパーを追加 | `migrateDocToV2(doc)` · desync 修復は `ensureTable10ColV2Order` |
| **`normalizeFlowchartDocument()` を唯一の移行エントリにする** | v1→v2 変換をここだけで実施 |
| `schema` を呼び出しスタック全体に通す | `generate → validate → parseTable(table, schema)` |
| 9→10 列パディングの schema | **未 v2 の doc のみ** `TIER10_V1_SCHEMA` で pad → `migrateDocToV2`。**既に `table-10col-v2` なら v2 のまま pad**（tier9 判定で v1 に戻さない） |

**YK パターン補足 — v2 正規化の落とし穴（2026-06 · 色列 select バグ）**

| 症状 | 原因 |
|------|------|
| 色 select で「黄」が **下先** に入る · 他列がずれる | `normalizeFlowchartDocument` が tier9 判定のたびに **v2 schema を v1 に戻し**、`migrateTable10ColV1ToV2` を **v2 行に再適用**していた |
| UI は v2 ヘッダーなのに列の中身がおかしい | DB / snapshot が **`schema: table-10col-v2` + v1 列順の table** の desync |

| MUST | 実装 |
|------|------|
| v2 doc を normalize しても **schema を v1 に戻さない** | `isTenColV2Schema(doc.schema)` で pad 用 schema を分岐（`document.ts`） |
| v2 schema + v1 列順を読込時に修復 | `tableNeedsV1ToV2Migration`（目安: index 6 が `MR…` = v1 の Text1）→ `migrateTable10ColV1ToV2` |
| 表編集後も v2 行を壊さない | `handleTableChange` → `syncJsonFromDoc` → `normalizeFlowchartDocument` の経路で **再 migrate しない** |
| snapshot 復元で **doc と JSON を揃える** | `resolveInitialState`: `parse` → `normalize` → **`serializeDocument` を `jsonText` / `committedJson` に使う**（raw v1 JSON を doc だけ v2 にして残さない） |

**禁止:** tier9 レイアウトだからといって **常に** `TIER10_V1_SCHEMA` で pad してから `migrateDocToV2` を毎回走らせる（v2 保存データを v1 行として解釈し直す）。

**Python 側（`python/src/excel_normalize/constants.py`）**

- `FLOW_HEADERS` タプルを新列順に更新
- `FLOW_SCHEMA` を新スキーマ文字列に更新

**整合性テスト（変更時は必ず更新）**

| テスト | 場所 |
|--------|------|
| TS ピン | `lib/flowchart/table/tableColumns.test.ts` — `TABLE_HEADERS_10_V2` · `TIER10_SCHEMA` · `tableNeedsV1ToV2Migration` |
| 正規化回帰 | `lib/flowchart/model/document.normalize.test.ts` — v2 色編集後の normalize · desync 修復 · A0001 M002 |
| 再生成スナップショット | `lib/flowchart/model/a0001-m005-m006.snapshot.test.ts` — A0001 M005/M006 |
| E2E · 色列 | `e2e/table-pane-ux.spec.ts` — 色 select 後も他列維持 |
| E2E · N8 | `e2e/nav-n8.spec.ts` — 一括展開/折りたたみ · `data-testid="toggle-all-units"` |
| E2E · §E chrome | [`PLAYWRIGHT_RULES.md`](../50_gas_html_test/PLAYWRIGHT_RULES.md) **§12-8** |
| Python ピン | `python/tests/test_schema_consistency.py` — `FLOW_HEADERS` · `FLOW_SCHEMA` のピンテスト（ADR-016 で追加） |

**禁止:** Python だけ / TypeScript だけ更新して片方を放置する。両テストが同時にグリーンであることを commit 条件にすること。

---

#### 5.6-8 クライアントバンドル · プレビュー再レンダー（2026-06）

| 項目 | SSOT · 方針 |
|------|-------------|
| **Excel（表ペイン）** | `CsvPastePanel` → `parseExcel` は **ファイル選択時のみ** dynamic import。表表示だけでは `xlsx` を載せない。**取込後は v2 列順へ正規化すること**（§5.6-2b · 恒常 repair スクリプト禁止） |
| **スナップショット復元** | `nodes` / `edges` は snapshot から。**`jsonText` / `committedJson` は `normalize` 後の `serializeDocument` に揃える**（`REACTFLOW_RULES` §5.7）。空 `nodes` + マウント effect `runGenerate` は避ける |
| **プレビュー UI** | `FlowPreviewPane`（または同等）— ズーム % state をキャンバス subtree に閉じ、`memo(FlowCanvas)` で表編集と分離 |
| **サンプル JSON** | `as FlowchartDocument` 禁止 — `parseFlowchartDocument` 経由（`REACT_RULES` §3-1） |

---

## 6. 品質ゲート

**品質方針:** §6 ゲート未通過（または Shell 禁止時の代替確認なし）の完了報告は **禁止**。

**機械ゲート（commit / push / CI）:** [`QUALITY_GATE_RULES.md`](../60_tooling/QUALITY_GATE_RULES.md) — husky · lint-staged · pre-push の `typecheck` + `test` + `excel:test`。本 §6 は **エージェントが意図的に実行する検証** の SSOT。

| ゲート | コマンド / 手段 |
|--------|----------------|
| ユニット | `npm run test`（`lib/flowchart/*.test.ts`） |
| 型 | `npm run typecheck`（日常）· リリース前は `npm run build` も推奨 |
| E2E | `npm run build` のあと `npm run test:e2e`（`:3001`）· レイアウトのみ `test:e2e:labels` · §E 回帰は **§12-8** — [`PLAYWRIGHT_RULES.md`](../50_gas_html_test/PLAYWRIGHT_RULES.md) **§12** |
| TS↔Python スキーマ整合 | `cd python && python -m pytest tests/test_schema_consistency.py`（`FLOW_HEADERS` / `FLOW_SCHEMA` が TS 定数と一致）— **列順変更時は両サイド同時にグリーンであること** |

**Shell:** `AGENT_SHELL_RULES` — `test` / `build` 明示、または E2E spec 追加の完了判定ターン。

**Shell 禁止ターンの代替:** 触った `lib/flowchart` の既存 `*.test.ts` を Read し、変更がテスト対象と整合するかを 1 行で記載。ビルドは未実行と明記。

## 7. 完了報告

`creating-reactflow-yk` SKILL · ROUTER §8 に従う。末尾に **読んだ refs**（L1 · ROUTER · 実装ファイル · 公式 URL）を列挙。

---

## 8. リポジトリ・パス

| 用途 | パス |
|------|------|
| React Flow 版 | `c:/yk-application/flowchart-studio/` · dev ポート → [`NEXTJS_RULES`](../30_web_stack/NEXTJS_RULES.md) §6-1 |
| Mermaid 比較版 | `c:/yk-tool/flowchart-web-mermaid/` · 同上 |
| ツール台帳 | `catalog.yaml`（`flowchart-studio` · `flowchart-web-mermaid`） |
| ルール・スキル | `c:/yk-skill/rule/35_reactflow/` · `creating-reactflow-yk` |

**Cursor マルチルート:** `yk-application/flowchart-studio` + `yk-skill`（handoffs · 企画時は `yk-memo` · Mermaid 比較時は `yk-tool/flowchart-web-mermaid` を追加）。

---

## 9. 関連（逆リンク）

| 参照元 | リンク先 |
|--------|----------|
| [`flowchart-studio/README.md`](c:/yk-application/flowchart-studio/README.md) §図モダリティ | 本ファイル |
| [`MERMAID_RULES.md`](../45_mermaid/MERMAID_RULES.md) §1.5 · §1.5-1 | 本ファイル |
| [`RULE_ROUTING_PLAYBOOK.md`](../RULE_ROUTING_PLAYBOOK.md) flowchart 読む順序 | No 35 |
| `creating-mermaid-yk` | 表駆動は **Do NOT use** → 本帯 |
