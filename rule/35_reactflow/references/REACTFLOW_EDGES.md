# React Flow — Edges & Canvas UX（L3 参照）

**SSOT:** 本ファイル · **索引:** [`REACTFLOW_RULES.md`](../REACTFLOW_RULES.md) §5.6  
**ROUTER tag:** `edges` · `canvas` · `layout`  
**最終更新:** 2026-07-25（ハンドル制約 · centerY 幹線スタイル統一 · MIN_TIER_GAP_V 追記）

---

## 5.6 実用版 UX — Edges / Canvas 節

**対象:** プレビュー edges 鮮度 · バリデーション警告 · 図形描画 · エッジ配線 · 並列オフセット。

### 5.6-4 プレビュー edges の鮮度（落とし穴 · 2026-05）

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

### 5.6-5 警告（`model/validationMeta.ts`）

| 種別 | 挙動 |
|------|------|
| **警告** | 生成 **継続** · 琥珀バナー · 行クリックでジャンプ |
| **エラー** | 生成 **停止**（ADR-002） |

- バナー説明 SSOT: `WARNING_BANNER_HINT`（「図はこのまま生成されます…」）。
- 文言は **列名**（接続先(下) 等）と **直し方** をセット。判断ノードは Yes=下 · No=右 を案内してよい。

### 5.6-7 図形描画 · エッジ配線（2026-06）

| 項目 | SSOT · 方針 |
|------|-------------|
| **菱形** | SVG `polygon` · `FLOW_NODE_DIAMOND_STROKE_WIDTH` |
| **入出力（平行四辺形）· 手動入力（台形）** | 同上 — `SlantedPolygonShape` · **`globals.css` の clip-path 禁止** |
| **順方向エッジ（接続先(下)）** | `graph/buildEdges.ts` — `tierDiff > 0`（先が下段）→ `sourceSide=bottom` · `targetSide=top`（合流も top 入口）。**`levelDiff` 単独で left 入口にしない** |
| **ループエッジ（上へ戻る）** | 同上 — `isLoop`（戻り先 tier < source tier）は **`sourceSide=right` / `targetSide=left` に固定**（下記ハンドル制約のため。`levelDiff` による分岐はしない） |
| **プレビュー ID バッジ** | `FlowShapeNode` — 表 ID を左上表示。**PNG/SVG に含めない**（`exportImageFilter` · class `flow-node-id` · §4 エクスポート） |
| **表の書き方（作者）** | [`docs/03_技術仕様/作者ガイド.md`](c:/yk-application/flowchart-studio/docs/03_技術仕様/作者ガイド.md) **§4**（No → 右列1行 → 接続先(下) で戻す） |
| **列ヘルプ** | `table/tableColumns.ts` — `CONNECT_RIGHT_HELP` |
| **E2E** | `e2e/curry-loop.spec.ts`（ループ · 斜め図形 · ID バッジ）· `fixtures/sample-curry.json` · `generate.test.ts`（順方向配線） |
| **並列エッジのバス重なり（v1.1 #1 · 2026-06-26）** | `graph/assignEdgePathOffsets.ts` — 同一 source 出口 / 同一 target 入口の **elbow** をグループ化し `pathOffset`（`EDGE_PARALLEL_LANE_SPACING_PX` = **12**）を付与 · `buildEdges` 末尾で `placedById` 付きで実行 |
| **`getSmoothStepPath` の `offset` 混同禁止** | `offset` はハンドルからの離れ（既定 20px）— **並列線の分離には使わない**。分離は `edgePathOffset.ts` → **`centerX` 上書き**（`LabeledEdge`）。**`centerY` は揃える**（下記「幹線スタイル」） |
| **straight 並列** | レーン **順序・本数**のカウントに含める · `pathOffset` は **elbow のみ**（straight はオフセット対象外） |
| **x 揃いエッジはレーン対象外** | `source.x === target.x`（まっすぐ降りるだけ）のエッジは `assignEdgePathOffsets` のレーン分けから除外（`isXAligned`）。含めると不要なフック状の折れが入る |
| **テスト** | `assignEdgePathOffsets.test.ts` · `generate.test.ts`（M002 fan-out / merge） |

### 5.6-7a `FlowShapeNode` のハンドルは4つだけ（落とし穴 · 2026-07）

**症状:** ループ／分岐エッジで `targetSide="right"` や `sourceSide="left"` を使うと、ブラウザ Console に `[React Flow] Couldn't create edge for source/target handle id` が出て矢印が正しく描画されない（見た目には「重なって消える」「変な位置に飛ぶ」形で現れ、原因がエッジ幾何ではなくハンドル不在だと気づきにくい）。

**原因:** `FlowShapeNode.tsx` の Handle は固定4つのみ — **source は `bottom`/`right` の2つだけ**、**target は `top`/`left` の2つだけ**。`right` を target として、`left` を source として使うハンドルは存在しない。`toReactFlow.ts` は `sourceHandle: edge.sourceSide` / `targetHandle: edge.targetSide` を **そのまま** id として渡すため、存在しない組み合わせは黙って描画が壊れる（型エラーにならない）。

**MUST:** `sourceSide` は `"bottom" | "right"` のみ、`targetSide` は `"top" | "left"` のみを使う。新しいエッジパターンを追加するときは、まずこの4通り（bottom→top・bottom→left・right→top・right→left）の組み合わせで足りるか検討する。

**確認方法:** 実ブラウザ（`PLAYWRIGHT_USE_DEV=1 npx playwright test` 等）で Console の `page.on("console", ...)` を拾い `Couldn't create edge` が出ないことを見る。`getSmoothStepPath` を Node.js で直接呼ぶ静的テストだけでは検出できない（ハンドル解決はブラウザ側の実描画でのみ発生）。

### 5.6-7b 折れ線の高さ（`centerY`）— 幹線スタイルに統一（2026-07）

**背景:** `graph/edgePathOffset.ts`（`smoothStepCenterWithPathOffset`）は `sourceSide=bottom, targetSide=top` のエッジで `centerY` を明示的に上書きする。理由と踏んだ罠:

| 罠 | 症状 | 対策 |
|----|------|------|
| `centerY` 未指定（RF既定の中点） | 複数段をまたぐ接続先(下)（例: 1セルに `2,3,4` の複数ID）で、中点が経由先の段のノード内に落ち **矢印がそのノードを貫通**する | `centerY = sourceY + bendMargin`（既定18px・ソース直後で早めに折れる） |
| 段間（`gapV`）が狭い | react-flow 側が丸め角を1つで描けず「くの字」の二重折れになる。**`centerY` の値に関わらず発生**（縦の余白が横移動量に対して狭すぎると RF が指定を事実上無視する） | `layoutGrid.ts` の `MIN_TIER_GAP_V`（既定45px）— **列(level)が変わる接続がある段の直後にだけ**適用（1:1 の直列区間まで一律に広げない） |
| `centerY` を `pathOffset` でレーンごとにずらす | 差が12pxで分かりにくい上、階段状の分岐/合流でレーン順序を誤ると「遠い接続先の水平区間が近い接続先の垂直区間を横切る」新たな交差が発生 | **`centerY` は同一グループの全エッジで揃える**（`pathOffset` は `centerX` にのみ使う）。「幹線から各枝が分岐する」見た目になり、階段状でも交差しない |

**MUST:** 新しく `centerY` に手を加えるときは、まず「揃える」で足りるか検討する。個別にずらす設計は上記の交差バグを再発させやすい。
