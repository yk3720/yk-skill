# React Flow — UX Chrome（L3 参照）

**SSOT:** 本ファイル · **索引:** [`REACTFLOW_RULES.md`](../REACTFLOW_RULES.md) §5.6  
**ROUTER tag:** `chrome-ui` · `table-ui` · `export`（§5.6-3 色）  
**最終更新:** 2026-06-27（P14 · L1 から分割）

---

## 5.6 実用版 UX — Chrome 節

**対象:** ツールバー · design-system · Excel 取込 · 見た目固定 · 表ペイン。

### 5.6-2 ツールバー（AppHeader）

| 常時表示 | その他メニュー（`EditorMoreMenu`） |
|----------|-------------------------------------|
| **再生成**（主操作 · stale 時は視覚強調） | PNG · SVG |
| 表を保存 · 表を読込（editor のみ） | オフライン用に保存（モジュール選択時） |
| | **装置取込 → import.jsonを取込…**（editor · workspace · `005` RPC 要） |
| | **危険 → フローをリセット…**（確認ダイアログ文言は「フローを雛形にリセットしますか？」のまま） |
| | サンプル表 · 下書き削除（非 workspace） |

- ボタン追加前に **「常時か / その他か」** を決める（§5.5 と併用）。
- JSON 編集タブは **出さない**（保存形式としての JSON は `document.ts` · 表を保存/読込）。

### 5.6-2a UI 操作部品 · workspace レイアウト（2026-06 · スタイル Phase 2）

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
| 枠線太さ | [`VISUAL_DESIGN_RULES.md`](../../10_meta/VISUAL_DESIGN_RULES.md) §2 と整合 |

**禁止:** フロー編集 chrome に `blue-600` 等の Tailwind 色を直書き（`flowchartUiClasses.ts` 経由）。キャンバス色は `visual/flowColors.ts`（§5.6-3）— chrome と混在させない。

**却下（2026-06）:** 12 カラム CSS grid への移行 — 現比率で目的達成 · 大規模リファクタ不要。

### 5.6-2c 操作 chrome — 文字サイズ · コントロール（2026-06）

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

### 5.6-2b 装置一括取込（Excel パイプライン · ADR-014 · 2026-06）

| 項目 | 規則 |
|------|------|
| **作者入力** | 1 xlsx = 1 装置 · 構成 1 シート + ユニット数フローシート · 動作表は**横並び** · 各動作 = Excel **テーブル** |
| **正規化 SSOT** | **Python** `flowchart-studio/python/` → `import.json`（Power Query 任意 · VBA 禁止） |
| **Web 入口** | その他 → **import.jsonを取込…**（`EditorMoreMenu` · editor · workspace） |
| **DB** | RPC **`import_equipment_bundle`**（`005_import_equipment_bundle.sql`）— 4 表 + `flow_documents` · 1 トランザクション |
| **再取込** | upsert のみ · 構成行削除の **prune なし** |
| **Git（作者 xlsx）** | **`*.xlsx` / `*.xls` はコミットしない** — ローカル編集 · 共有は **`import.json`**（`python/.gitignore`）· CI は `excel:template` / `excel:fixture` で生成 |
| **設計 SSOT** | [Excel取込.md](c:/yk-application/flowchart-studio/docs/03_技術仕様/Excel取込.md) |
| **v0.3 入力 SSOT** | [Excel入力フォーマット_v0.3.md](c:/yk-application/flowchart-studio/docs/03_技術仕様/Excel入力フォーマット_v0.3.md)（作者 xlsx · 帯・構成割当。正規化は上記 Excel取込） |

- **Web は入力用 xlsx を読まない**（横並び分割は Python 側）。
- テーブル名（v0.2）: **`{ユニット短名}_{動作名}`** — v0.3 の **照合キーではない**（§6.4 · MID 見出し行）。v0.2 テンプレのみ一意命名。
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

### 5.6-3 見た目の固定（ユーザー向け選択なし）

| 項目 | SSOT |
|------|------|
| レイアウト寸法 | `DEFAULT_LAYOUT`（`model/types.ts`）— サイズ preset なし |
| 矢印・ラベル色 | `visual/flowColors.ts` — テーマ切替なし |
| ノード枠の太さ・色 | `FLOW_NODE_FRAME_WIDTH` / `FLOW_NODE_DIAMOND_STROKE_WIDTH`（**2px** · 菱形は `miter`）· [`VISUAL_DESIGN_RULES.md`](../../10_meta/VISUAL_DESIGN_RULES.md) §2 |
| **斜め図形（入出力・手動入力）** | `FlowShapeNode` — **SVG `polygon` stroke**（菱形と同様）。**`clip-path` + CSS border は禁止**（角が途切れる） |
| **10 列表 · 色列** | 最右列「色」— 狭い中央ペインでは**表コンテナ横スクロール**で表示（列自体は省略しない） |
| Yes/No ラベル | `graph/edgeLabelPlacement.ts` — **halo**（透明＋白縁文字）· 線の右 `FLOW_EDGE_LABEL_GAP`（`edge.data.branch` + `direction`） |

### 5.6-6 作者向け記述（図形 · 色）

| 項目 | SSOT |
|------|------|
| **作者向け記述（図形 · 色 · ループ）** | [`docs/03_技術仕様/作者ガイド.md`](c:/yk-application/flowchart-studio/docs/03_技術仕様/作者ガイド.md)（§2 図形 · §3 色 · §4 ループ） |
| **列ヘルプ（表 UI ?）** | `table/tableColumns.ts` — `SHAPE_TYPE_COLUMN_HELP` · `COLOR_COLUMN_HELP` · `CONNECT_RIGHT_HELP` |
| **プレビュー凡例** | `visual/flowColors.ts` — `COLOR_HINT_LEGEND_ITEMS`（`FlowColorLegend`） |

- **図形・色の種類追加**は同 SSOT §1 の結論に従う（当面は維持 · 将来候補=サブルーチン記号）。

### 5.6-9 FlowTableEditor — 表コンテナ minWidth（2026-06）

表の列幅合計を `style={{ minWidth }}` に設定しないと、ウィンドウ縮小 → 拡大時に列が潰れたまま戻らないリサイズ視覚バグが出る。

| MUST | 実装 |
|------|------|
| `<table style={{ minWidth: tableMinWidth }}>` | `tableMinWidth = getTotalDefaultWidth(colCount, tableSchema)` (`tableColumnWidths.ts`) |
| 列幅 SSOT | `DATA_COL_WIDTHS_10_V2` (`tableColumnWidths.ts`) — スキーマ別に分岐 |
| 表示ラベル SSOT | `getDisplayHeaders(colCount, schema)` — 短縮ラベル（例: "接続先(下)" → "下先"） |
