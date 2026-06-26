# React Flow — Edges & Canvas UX（L3 参照）

**SSOT:** 本ファイル · **索引:** [`REACTFLOW_RULES.md`](../REACTFLOW_RULES.md) §5.6  
**ROUTER tag:** `edges` · `canvas` · `layout`  
**最終更新:** 2026-06-27（P14 · L1 から分割）

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
| **ループエッジ** | 同上 — 戻り先 `rowIndex < source` で `isLoop` · `route: elbow` · 左/右入口 |
| **プレビュー ID バッジ** | `FlowShapeNode` — 表 ID を左上表示。**PNG/SVG に含めない**（`exportImageFilter` · class `flow-node-id` · §4 エクスポート） |
| **表の書き方（作者）** | [`docs/03_技術仕様/作者ガイド.md`](c:/yk-application/flowchart-studio/docs/03_技術仕様/作者ガイド.md) **§4**（No → 右列1行 → 接続先(下) で戻す） |
| **列ヘルプ** | `table/tableColumns.ts` — `CONNECT_RIGHT_HELP` |
| **E2E** | `e2e/curry-loop.spec.ts`（ループ · 斜め図形 · ID バッジ）· `fixtures/sample-curry.json` · `generate.test.ts`（順方向配線） |
| **並列エッジのバス重なり（v1.1 #1 · 2026-06-26）** | `graph/assignEdgePathOffsets.ts` — 同一 source 出口 / 同一 target 入口の **elbow** をグループ化し `pathOffset`（`EDGE_PARALLEL_LANE_SPACING_PX` = **12**）を付与 · `buildEdges` 末尾で実行 |
| **`getSmoothStepPath` の `offset` 混同禁止** | `offset` はハンドルからの離れ（既定 20px）— **並列線の分離には使わない**。分離は `edgePathOffset.ts` → **`centerX` / `centerY` 上書き**（`LabeledEdge`） |
| **straight 並列** | レーン **順序・本数**のカウントに含める · `pathOffset` は **elbow のみ**（straight はオフセット対象外） |
| **テスト** | `assignEdgePathOffsets.test.ts` · `generate.test.ts`（M002 fan-out / merge） |
