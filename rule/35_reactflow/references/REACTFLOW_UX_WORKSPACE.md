# React Flow — UX Workspace（L3 参照）

**SSOT:** 本ファイル · **索引:** [`REACTFLOW_RULES.md`](../REACTFLOW_RULES.md) §5.6  
**ROUTER tag:** `persist` · `next-shell`  
**最終更新:** 2026-06-27（P14 · L1 から分割）

---

## 5.6 実用版 UX — Workspace 節

**対象:** `flowchart-studio` のナビ階層 · モジュール読込 · 3 ペイン · スキーマ移行 · クライアントバンドル。

**横断 UX チェックリスト:** [`USABILITY_HEURISTICS_RULES.md`](../../10_meta/USABILITY_HEURISTICS_RULES.md) No **20**  
**エージェント向けチェックリスト:** `flowchart-studio/.cursor/rules/flowchart-practical-ux-yk.mdc`

### 5.6-1 ナビ階層 · 永続化キー

| 項目 | 規則 |
|------|------|
| 階層 | **装置（Nav 最上段 `<select>`）→ ユニット → 動作 → 表｜図** |
| 選択単位 | 動作 1 件 = フロー 1 本（`moduleId`） |
| 保存キー SSOT | `moduleDraftKey(deviceId, moduleId)` → **`${deviceId}:${moduleId}`**（`lib/flowchart/moduleHierarchy.ts`） |
| 読込 | `resolveModuleDraftKey` — **press-01** の旧キー（`supply-feed` 等・装置 prefix なし）へフォールバック可 |
| 装置切替 | 編集中モジュールを退避 → 動作選択クリア → 新装置のユニット一覧 |
| ヘッダー | 装置名は Nav に集約。エディタヘッダーは **選択中フロー文脈**（例: `供給ユニット · 供給動作`）のみ |

### 5.6-1a モジュール読込の非同期（レース防止 · 2026-06）

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

### 5.6-1d 装置プリフェッチ（2026-06）

動作切替のたびに `loadFlowDocument` を逐次呼ぶと遅い。**装置選択時**に配下モジュールを一括取得する。

| MUST | 実装 |
|------|------|
| 一括 RPC | `loadFlowDocumentsBatch`（`flowDocuments.ts`）— `module_id IN (...)` |
| プリフェッチ | `prefetchDeviceModuleDrafts`（`moduleDraftLoader.ts`）— warm cache + IndexedDB |
| トリガー | `FlowchartWorkspace` — `device.id` 変更時 · 装置切替で `prefetchGenerationRef` を進めてキャンセル |
| 動作切替 | warm cache 命中時はクラウド往復なし（`loadModuleDraft` 先頭） |
| warm cache 読込 UI | **解消済（2026-06-28）** — `peekModuleWarmCache` 命中時は `loadingModule` / overlay を出さない |
| prefetch 完了待ち | **解消済（2026-06-28）** — `devicePrefetchCoordinator` · `loadModule` が prefetch 完了後に warm cache を参照 |

### 5.6-1b サンプル／雛形と自動保存（2026-06）

| MUST | 実装 |
|------|------|
| **サンプル（例）はプレビューのみ**（`persist: false`） | `onPreviewSample` → `runGenerate(..., { persist: false })` |
| **モジュールに保存するのは明示操作のみ** | 「モジュールに適用」· 雛形適用 · 表 JSON 取込 · 再生成 |
| **編集済みモジュールへの破壊的適用は確認** | `isModuleContentDirty`（`moduleContentDirty.ts`）— `userTouched` · `committedJson` · `initialSnapshot` |
| **プレビュー中は復元点を保持** | `prePreviewRestoreRef` — 「プレビューを終了」で復元 |
| **空モジュール**（dirty でない） | 雛形は無確認適用可 · サンプルはプレビュー → 任意で適用 |

**確認（手動または E2E）:** 表編集後に「例を見る」→ プレビュー終了で元の表が残る · 編集後に雛形適用で確認ダイアログ

### 5.6-1b-2 `isUnsaved` は sample preview フラグを除外する（2026-06）

`isUnsaved`（DB 未保存の編集あり）の判定では **`!moduleSamplePreviewActive && !samplePreviewActive`** を必ず含める。この除外がないとサンプルプレビュー中のモジュール切替で false positive が発生し、`module-load-ux.spec.ts` が壊れる。

```typescript
const isUnsaved =
  workspaceMode &&
  !!moduleId &&
  jsonText !== savedJson &&
  !moduleSamplePreviewActive && // ← 必須
  !samplePreviewActive;          // ← 必須
```

あわせて `workspaceMode` での再生成は `persist: !workspaceMode`（プレビュー更新のみ · DB保存なし）とする。明示的な「保存」操作時のみ `onSnapshotPersist` を呼び `setSavedJson(jsonText)` で同期する。

### 5.6-1c モジュール削除の楽観 UI（2026-06）

動作削除成功直後、サーバー refresh 完了前に左ナビから当該行を消す。

| MUST | 実装 |
|------|------|
| 削除成功後 **`optimisticRemovedModuleIds` に moduleId を追加** | `FlowchartWorkspace.tsx` · `excludeModulesFromDevices`（`moduleHierarchy.ts`） |
| サーバー反映済み ID は楽観セットから外す | **`useMemo` で派生**（`activeOptimisticRemovedModuleIds`）— `useEffect` 内の `setState` は **禁止**（`react-hooks/set-state-in-effect`） |
| E2E | 成功バナー **と** ナビから当該動作が消えること（`e2e/module-delete.spec.ts`） |

### 5.6-10 3ペイン PanelGroup（react-resizable-panels v4 · ADR-016 PR-B · 2026-06）

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

### 5.7 スキーマバージョニング — 列順変更の手順（ADR-016 · 2026-06）

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
| E2E · §E chrome | [`PLAYWRIGHT_RULES.md`](../../50_gas_html_test/PLAYWRIGHT_RULES.md) **§12-8** · [`PLAYWRIGHT_AGENT_OPS.md`](../../50_gas_html_test/references/PLAYWRIGHT_AGENT_OPS.md) §12-8 |
| Python ピン | `python/tests/test_schema_consistency.py` — `FLOW_HEADERS` · `FLOW_SCHEMA` のピンテスト（ADR-016 で追加） |

**禁止:** Python だけ / TypeScript だけ更新して片方を放置する。両テストが同時にグリーンであることを commit 条件にすること。

---

### 5.6-8 クライアントバンドル · プレビュー再レンダー（2026-06）

| 項目 | SSOT · 方針 |
|------|-------------|
| **Excel（表ペイン）** | `CsvPastePanel` → `parseExcel` は **ファイル選択時のみ** dynamic import。表表示だけでは `xlsx` を載せない。**取込後は v2 列順へ正規化すること**（§5.6-2b · 恒常 repair スクリプト禁止） |
| **スナップショット復元** | `nodes` / `edges` は snapshot から。**`jsonText` / `committedJson` は `normalize` 後の `serializeDocument` に揃える**（`REACTFLOW_RULES` §5.7）。空 `nodes` + マウント effect `runGenerate` は避ける |
| **プレビュー UI** | `FlowPreviewPane`（または同等）— ズーム % state をキャンバス subtree に閉じ、`memo(FlowCanvas)` で表編集と分離 |
| **サンプル JSON** | `as FlowchartDocument` 禁止 — `parseFlowchartDocument` 経由（`REACT_RULES` §3-1） |
