# React Flow 開発ルール（ひな形 v0）
## YK 表駆動フローチャート — Design & Development Rules

**ステータス:** `active`（[`RULE_INDEX.md`](../RULE_INDEX.md) Status 列 · L0/L1/L2 整備済）

**SSOT（本ファイル）:** `yk-skill/rule/35_reactflow/REACTFLOW_RULES.md`  
**実行手順・ゲート:** `.claude/skills/creating-reactflow-yk/SKILL.md`  
**ロード規則 SSOT:** `.../creating-reactflow-yk/references/ROUTER.md`

**参照実装:** [`c:/yk-tool/flowchart-web-reactflow/`](c:/yk-tool/flowchart-web-reactflow/README.md)  
**企画・ADR:** [`c:/yk-memo/00.ai-driven-school/個人テーマ_フローチャートアプリ/`](c:/yk-memo/00.ai-driven-school/個人テーマ_フローチャートアプリ/意思決定記録(ADR).md)（ADR-006 · ADR-010）

**横断:** [`../30_web_stack/REACT_RULES.md`](../30_web_stack/REACT_RULES.md)（React 一般 · Hooks） · [`../30_web_stack/NEXTJS_RULES.md`](../30_web_stack/NEXTJS_RULES.md)（App Router · §5 RSC · §6 flowchart） · [`../45_mermaid/MERMAID_RULES.md`](../45_mermaid/MERMAID_RULES.md) §1.5（方式境界） · [`../10_meta/SECRETS_HYGIENE_RULES.md`](../10_meta/SECRETS_HYGIENE_RULES.md) · [`../10_meta/GIT_WORKFLOW_RULES.md`](../10_meta/GIT_WORKFLOW_RULES.md)

**最終更新:** 2026-05-24（§4 公式索引 · v12 要約 · Common Errors MUST 化 · ROUTER 連携）  
**索引:** [`../RULE_INDEX.md`](../RULE_INDEX.md) No 35

**L0 入口:** `yk-skill` · `yk-tool` · `yk-memo` — `.cursor/rules/reactflow-dev-entry.mdc`（`flowchart-web-*/**` 配下の flowchart コード）

---

## 0. エージェント向け — いつ何を読むか

| 段階 | 読むもの | タイミング |
|------|----------|------------|
| L0 | `reactflow-dev-entry.mdc` | `flowchart-web-*` の `lib/flowchart` · `components/flowchart` 編集時 |
| L1 | **本ファイル** | 毎回・最初 |
| L2 | `creating-reactflow-yk/SKILL.md` | 手順・ゲート |
| L2.5 | **Ref Plan** | **Write/StrReplace 前**（ROUTER §7 · `creating-mermaid-yk` 同型） |
| L3 | ROUTER の `load` のみ | Ref Plan 後 |

**Ref Plan 不要:** 質問のみ · Read のみ · 本ルール索引の更新のみ。

**誤ルーティング禁止（Mermaid 3分岐 — 固定）**

| 触るもの | 使う入口 | **使わない** |
|----------|----------|--------------|
| **`.mmd`** · diagram-as-code | No 45 · `creating-mermaid-yk` | 本帯 · `flowchart-web-*` |
| **表 → Mermaid プレビュー**（`flowchart-web-mermaid` · `toMermaid.ts`） | **本帯** · `creating-reactflow-yk` | `creating-mermaid-yk` |
| **表 → React Flow**（`flowchart-web-reactflow`） | **本帯** · `creating-reactflow-yk` | `creating-mermaid-yk` |

surge 図解 HTML → `routing-diagram-yk` 系。**表駆動は本帯のみ**（[`RULE_ROUTING_PLAYBOOK.md`](../RULE_ROUTING_PLAYBOOK.md) flowchart 読む順序）。**3 分岐詳細:** [`MERMAID_RULES.md`](../45_mermaid/MERMAID_RULES.md) §1.5-1。

**React 一般（Hooks · 純粋性）:** `components/flowchart/**` の Client ロジック → [`REACT_RULES.md`](../30_web_stack/REACT_RULES.md) · `creating-react-yk`（**RF API は本 §4**）。

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

**横断 SSOT:** 本節 ↔ [`MERMAID_RULES.md`](../45_mermaid/MERMAID_RULES.md) §1.5 ↔ [`flowchart-web-reactflow/README.md`](c:/yk-tool/flowchart-web-reactflow/README.md) §図モダリティ

| やりたいこと | 選ぶもの | 入口 |
|--------------|----------|------|
| 表 · CSV · ブラウザ編集 · PNG/SVG（**React Flow レイアウト**） | **flowchart-web-reactflow** | 参照実装 README · 本ルール |
| 同じ表から **Mermaid プレビュー**（比較 · ADR-010） | **flowchart-web-mermaid** | [`flowchart-web-mermaid/README.md`](c:/yk-tool/flowchart-web-mermaid/README.md) · 本ルール §3-6 |
| テキスト版管理 · **`.mmd`** · MD 埋め込み | **Mermaid DSL（No 45）** | `creating-mermaid-yk` — **表プレビューではない** |
| surge 図解 HTML | **図解スキル系** | `routing-diagram-yk` → `creating-visual-explainers` 等 — **本ルール非使用** |
| Excel 連携デスクトップツール | **Python（MZ 系）** | [`40_python/PYTHON_RULES.md`](../40_python/PYTHON_RULES.md) |

**MUST**

- **正本は表（`FlowchartDocument.table`）** — Excel 8列表 · 図形シートは正本にしない（ADR-010）。
- **reactflow 版の Mermaid エクスポート / インポートは Phase 外**。表 → Mermaid プレビューは **`flowchart-web-mermaid`**（`toMermaid`）。**`.mmd` 執筆は No 45**。
- **同一ノードを二重 SSOT にしない**（表と `.mmd` の両方を正本にしない）。

### 2-1. 二アプリ共通 — `lib/flowchart` 同期

`flowchart-web-reactflow` と `flowchart-web-mermaid` は **同一ドメイン層を物理コピー**で保持（共通化パッケージは ADR-010 比較後に検討）。

**MUST:** `parseTable` · `validate` · `buildEdges` · `types` · `layoutGrid` 等 **ドメイン層**を変更するときは **両アプリを同期**する（片方だけ直して比較を壊さない）。アダプタ（`toReactFlow` / `toMermaid`）と UI は各アプリ固有。

---

## 3. アーキテクチャ — MUST（`flowchart-web-*` 共通 + アダプタ）

### 3-1. レイヤ分割

| レイヤ | パス | 規則 |
|--------|------|------|
| **ドメイン** | `lib/flowchart/` | **React 非依存**。表パース · 検証 · レイアウト · エッジ生成 |
| **アダプタ（RF）** | `lib/flowchart/toReactFlow.ts` | `PlacedNode` + `FlowEdge` → `@xyflow/react` |
| **アダプタ（Mermaid）** | `lib/flowchart/toMermaid.ts` | 同上 → Mermaid `flowchart TD` 文字列（**座標は使わない**） |
| **UI** | `components/flowchart/` | Client 層（`"use client"` 詳細は NEXTJS §6 · Hooks は REACT_RULES）· プレビュー · 表 UI |

**禁止:** `parseTable` / `layoutGrid` / `buildEdges` に JSX や `useReactFlow` を置く。逆に `components/flowchart` に列定義ロジックを複製しない。

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
| 列・接続先・バリデーション | `table-ui` | ドメイン | `parseTable.ts` · `validate.ts` · `tableColumns.ts` |
| 行高 · Level 座標 · 分岐位置 | `layout` | レイアウト | `layoutGrid.ts` · `measureHeights.ts` · `layoutPresets.ts` |
| Yes/No エッジ · 肘/直線 | `edges` | エッジ | `buildEdges.ts` · `types.ts` |
| テーマ色 · RF Node/Edge 形 | `canvas` | アダプタ RF | `toReactFlow.ts` · `themes.ts` |
| Mermaid DSL 生成 · 形状記法 | `mermaid-preview` | アダプタ Mermaid | `toMermaid.ts` |
| ブラウザ Mermaid 描画 | `mermaid-preview` | Mermaid UI | `MermaidPreview.tsx` |
| 真っ白 · 高さ 0 · fitView · 操作ロック | `canvas` | Canvas UI | `FlowCanvas.tsx` · `FlowchartEditor.tsx` · `flowTypes.ts` |
| PNG/SVG 出力 | `export` | エクスポート | `exportPng.ts` · `exportSvg.ts` |
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
| 操作（グローバル） | 公式デフォルトは `nodesDraggable` / `nodesConnectable` / `elementsSelectable` / `edgesReconnectable` すべて **`true`**。表駆動は **四つとも `false` を MUST**（`FlowCanvas.tsx`）。`readOnly` prop は v12 で廃止 — 上記が SSOT |
| Provider | **`ReactFlowProvider` でラップ MUST**。**`useReactFlow` は Provider の子のみ**（Provider 自身の中では不可 · Common Errors） |
| 状態 | nodes/edges は **`generateFlowchart` → `toReactFlow` 派生**。`useNodesState` + `onConnect` を表更新の主経路にしない |
| fitView | `<ReactFlow fitView />`（初回）+ 生成後 `fitView({ padding: 0.2, duration: 200 })`（`useEffect` / export 前 imperative · `FlowCanvas.tsx`）。**PNG/SVG 前**は imperative `fitView` → **~300ms 待機**（`FlowchartEditor.tsx`） |
| 閲覧操作 | **`panOnDrag` · `zoomOnScroll` は許容**（ADR-010）。`Controls showInteractive={false}` |
| エクスポート | `data-flowchart-export-root` → **`.react-flow__viewport`** を `html-to-image`（`toPng` / `toSvg`）· Controls は `filter` で除外（`exportPng.ts` · `exportSvg.ts`） |
| 安定参照 | `defaultEdgeOptions` 等も **`useMemo` またはモジュール外**（参照: `FlowCanvas.tsx`） |

**禁止（flowchart-web 系）**

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
| localStorage キー | `flowchart-web:draft-v1`（**両 `flowchart-web-*` で共有** · リネーム後も維持） |
| ドキュメント JSON | `FlowchartDocument`（`version: 1`） |

`lib/flowchart/document.ts` · `draftStorage.ts` を SSOT。キー変更は ADR + マイグレーション必須。

---

## 6. 品質ゲート

**品質方針:** §6 ゲート未通過（または Shell 禁止時の代替確認なし）の完了報告は **禁止**。

| ゲート | コマンド / 手段 |
|--------|----------------|
| ユニット | `npm run test`（`lib/flowchart/*.test.ts`） |
| 型・ビルド | `npm run build` |
| E2E | `npm run test:e2e`（Playwright — [`PLAYWRIGHT_RULES.md`](../50_gas_html_test/PLAYWRIGHT_RULES.md)） |

**Shell:** `AGENT_SHELL_RULES` — ユーザーが当ターンで `test` / `build` を明示したときのみ実行。

**Shell 禁止ターンの代替:** 触った `lib/flowchart` の既存 `*.test.ts` を Read し、変更がテスト対象と整合するかを 1 行で記載。ビルドは未実行と明記。

## 7. 完了報告

`creating-reactflow-yk` SKILL · ROUTER §8 に従う。末尾に **読んだ refs**（L1 · ROUTER · 実装ファイル · 公式 URL）を列挙。

---

## 8. リポジトリ・パス

| 用途 | パス |
|------|------|
| React Flow 版 | `c:/yk-tool/flowchart-web-reactflow/` · dev ポート → [`NEXTJS_RULES`](../30_web_stack/NEXTJS_RULES.md) §6-1 |
| Mermaid 比較版 | `c:/yk-tool/flowchart-web-mermaid/` · 同上 |
| ツール台帳 | `catalog.yaml`（`flowchart-web-reactflow` · `flowchart-web-mermaid`） |
| ルール・スキル | `c:/yk-skill/rule/35_reactflow/` · `creating-reactflow-yk` |

**Cursor マルチルート:** `yk-tool` + `yk-skill`（企画確認時は `yk-memo` を追加）。

---

## 9. 関連（逆リンク）

| 参照元 | リンク先 |
|--------|----------|
| [`flowchart-web-reactflow/README.md`](c:/yk-tool/flowchart-web-reactflow/README.md) §図モダリティ | 本ファイル |
| [`MERMAID_RULES.md`](../45_mermaid/MERMAID_RULES.md) §1.5 · §1.5-1 | 本ファイル |
| [`RULE_ROUTING_PLAYBOOK.md`](../RULE_ROUTING_PLAYBOOK.md) flowchart 読む順序 | No 35 |
| `creating-mermaid-yk` | 表駆動は **Do NOT use** → 本帯 |
