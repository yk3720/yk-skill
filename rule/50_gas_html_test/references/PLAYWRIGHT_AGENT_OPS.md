# Playwright — エージェント運用（L3 参照）

**SSOT:** 本ファイル · **索引:** [`PLAYWRIGHT_RULES.md`](../PLAYWRIGHT_RULES.md) §12  
**スキル:** `using-playwright` · **ROUTER:** `using-playwright/references/ROUTER.md`  
**最終更新:** 2026-06-27（P14c · L1 から分割）

---

## 12. エージェント運用 — UI 確認は Playwright 優先

**目的:** エージェントが「ブラウザで何度もリロードしてスクショ依頼」を繰り返すより、**再現可能な Playwright 検証**で完了判定する。

### 12-1. いつ Playwright を使うか（実装層 · ツール選択）

**戦略層（E2E に載せる/載せない）** → §13 · [`PLAYWRIGHT_TEST_STRATEGY.md`](PLAYWRIGHT_TEST_STRATEGY.md) · `designing-playwright-tests-yk`。spec 新規追加前は decision-matrix のチェックリスト。

| 確認したいこと | 第一選択 | 補足 |
|----------------|----------|------|
| 純ロジック（座標計算・分岐） | Vitest 等の単体テスト | DOM 不要 |
| 表示・クリック・文言・件数 | Playwright + `getByRole` / `getByText` | 公式 Best Practices に沿う |
| レイアウト（重なり・左右関係） | Playwright + `boundingBox` / `page.evaluate` | 下記 §12-3 |
| ピクセル単位の見た目全体 | `toHaveScreenshot` | OS・フォント差に弱い。必要時のみ |
| GAS iframe / Sheets | L1 §4 · §7 | 既存パターン |

**原則:** ユーザーに「画面を見てください」を繰り返す前に、**同じ手順を spec に固定**し `npm run test:e2e`（またはプロジェクトの script）を実行する。失敗時は [Trace Viewer](https://playwright.dev/docs/trace-viewer)（§12-5）で原因を特定する。

### 12-2. 手動ブラウザ反復を避ける理由（調査要約）

- Playwright の **web-first アサーション**は自動リトライ付きで、固定 `waitForTimeout` より安定（[Best Practices](https://playwright.dev/docs/best-practices)）。
- テストは **ユーザーが見える出力**（role・label・text）に寄せ、CSS クラス依存を減らす（[Locators](https://playwright.dev/docs/locators)）。
- **テスト分離**（コンテキスト・認証 state）で「前のテストの影響」を排除（同上）。
- エージェントの手動確認は再現性・CI 共有・回帰検知に不利。**一度書いた spec は以降の修正でも使い回せる**。

### 12-3. レイアウト・重なりの検証パターン

1. **契約属性** — `data-testid` または `data-*`（例: `data-edge-label-branch`）。L1 §1 の CSS クラスは最終手段。
2. **2要素の相対位置** — まず `locator.boundingBox()`（null チェック後に gap 比較）。
3. **複数 path / ライブラリ DOM** — `page.evaluate` + `getBoundingClientRect()`。**対象縦線が見つかったか**（`matchedVertical` 等）を必ず検証し、見つからなければ失敗。
4. **安定待ち** — 幾何の単発 `expect` はリトライなし。`await expect(...).toBeVisible()` の後、`expect(async () => { ... }).toPass()` または `expect.poll` で evaluate。
5. **スクリーンショット** — 要素単位の `toHaveScreenshot`（[Visual comparisons](https://playwright.dev/docs/test-snapshots)）。全体スクショは最終手段。`animations: 'disabled'` · `mask` · `maxDiffPixelRatio` を検討。

```typescript
// 2要素（契約属性があるとき）
const labelBox = await page.locator('[data-edge-label-branch="yes"]').boundingBox();
expect(labelBox).not.toBeNull();
// edgeBox も同様 · labelBox!.left >= edgeBox!.right + MIN_GAP_PX

// 複数 path（flowchart 例 — canonical: flowchart-studio/e2e/edge-label-placement.spec.ts）
await expect(async () => {
  const result = await page.evaluate(() => {
    const label = document.querySelector('[data-edge-label-branch="yes"]');
    if (!label) return { ok: false as const, reason: "no-yes-label" };
    const lb = label.getBoundingClientRect();
    let matchedVertical = false;
    for (const path of document.querySelectorAll(
      ".react-flow__edge path.react-flow__edge-path",
    )) {
      const pb = path.getBoundingClientRect();
      if (pb.height <= pb.width * 3 || pb.width >= 14) continue;
      if (lb.bottom <= pb.top + 2 || lb.top >= pb.bottom - 2) continue;
      matchedVertical = true;
      if (lb.left < pb.right + 2) {
        return { ok: false as const, reason: "yes-left-of-vertical-gap" };
      }
    }
    if (!matchedVertical) {
      return { ok: false as const, reason: "no-vertical-edge-aligned-with-yes" };
    }
    return { ok: true as const };
  });
  expect(result.ok, JSON.stringify(result)).toBe(true);
}).toPass({ timeout: 10_000 });
```

→ React Flow の表駆動 E2E ゲート: [`REACTFLOW_RULES.md`](../../35_reactflow/REACTFLOW_RULES.md) §6

### 12-4. プロジェクト配置

| リポジトリ | テスト置き場 | 起動例 |
|------------|--------------|--------|
| `c:/yk-tool/playwright-test/` | `tests/*.spec.ts` | `cd ...; npx playwright test` |
| `flowchart-studio` | `e2e/*.spec.ts` | `npm run test:e2e`（デモ · **:3001** · `AUTH_DISABLED=1`）· **`npm run test:e2e:import-auth`**（本番 auth UI · §12-10）· ラベルのみ `npm run test:e2e:labels` · [`docs/LOCAL_DEV.md`](c:/yk-application/flowchart-studio/docs/LOCAL_DEV.md) |
| その他 Next アプリ | `e2e/*.spec.ts` | 各 `docs/LOCAL_DEV.md` |

**エージェント:** Shell は [`AGENT_SHELL_RULES.md`](../../60_tooling/AGENT_SHELL_RULES.md) §3-2（test / E2E / 確認して の明示、**または** UI 修正で spec を追加した同一ターン）。Cursor からは `required_permissions: ["all"]`。

### 12-5. 実装時チェックリスト

- [ ] 再現手順（サンプル読込・再生成など）を spec に含めた
- [ ] 幾何 assert の前に web-first で準備完了（文言・件数・契約属性の visible）
- [ ] 認証が要るアプリは `AUTH_DISABLED` / `storageState` を config で明示した
- [ ] Trace が**実際に残る**設定（`on-first-retry` は **`retries >= 1` が前提**。`retries: 0` なら `retain-on-failure` または `trace: 'on'`）
- [ ] ユーザーへの依頼は「spec を直して green にする」に寄せ、スクショ依頼は最終手段

### 12-6. flowchart-studio — レイアウト E2E の落とし穴（2026-05）

| 落とし穴 | 対策 |
|----------|------|
| **サンプル読込だけ E2E** し、**モジュール選択**を試さない | 実利用は左ナビのモジュール復元が多い → spec に **モジュールクリック → 生成完了 → halo** を含める（[`REACTFLOW_EDGES.md`](../../35_reactflow/references/REACTFLOW_EDGES.md) §5.6-4） |
| コード修正後 **`:3000` の dev だけ**見る | E2E は `build` + `:3001` `next start`。手元確認は dev 再起動 + ハードリロード |
| `edge.label` 残存で白 pill が線上に見える | `toReactFlow` は `data.edgeLabel` のみ · `.react-flow__edge-text` が 0 件であることを assert |
| 幾何のみ pass で **halo スタイル未検証** | `[data-edge-label-branch]` が `bg-transparent` かを併用 |
| JSON 読込 E2E で status だけ「生成完了」· **ノード 0** | モジュール未選択時 `showEditorPanes` が false → canvas 非表示。`executeImportText` 後に samplePreview を維持するか spec でモジュール選択 |

→ 実装 SSOT: [`REACTFLOW_EDGES.md`](../../35_reactflow/references/REACTFLOW_EDGES.md) §5.6-4

### 12-7. Server Action E2E スタブ（2026-06）

`PLAYWRIGHT_E2E=1` 等で Server Action の RPC をスキップするスタブを使うとき:

| MUST | 理由 |
|------|------|
| E2E スタブは **`PLAYWRIGHT_E2E=1` かつ専用 env（例 `IMPORT_E2E_STUB=1`）の両方**でのみ有効 | 本番 env 単体では発動しない |
| **`VERCEL_ENV=production` ではスタブを常に無効** | 本番バンドルにスタブ経路が残っても発動しない（`lib/supabase/e2eStub.ts` · `isPlaywrightActionStubEnabled`） |
| E2E スタブは **`isAuthDisabled()` 等の早期 return より前** | CI は `AUTH_DISABLED=1` のため、後段ガードが stub を潰す（2026-06 CI #9） |
| **本番経路**の RPC は **`requireEditor()` の後** | 認可前の DB 操作禁止 |
| スタブは **Playwright `webServer.env`（または CI job env）のみ**で有効化 | 通常 dev / 本番バンドルに含めない |
| 実 DB 取込の検証は **Runbook 手動**（E2E は UI 配線まで） | CI コスト · 認証分離 |
| **削除系 E2E** は action 成功だけでなく **UI 反映**まで assert | 例: 動作削除 — 成功バナー **+** 左ナビから当該動作が消える（`e2e/module-delete.spec.ts` · [`REACTFLOW_UX_WORKSPACE.md`](../../35_reactflow/references/REACTFLOW_UX_WORKSPACE.md) §5.6-1c） |
| **本番 auth UI**（装置取込 · 設計メモタブ等） | **`AUTH_E2E_STUB`** — デモ E2E とは **別 npm 脚本**（→ §12-10） |

正本: `importEquipmentBundle.ts` · `deleteModule.ts` · `e2eStub.ts` · `playwright.config.ts` · [`SUPABASE_AUTH_SSR.md`](../../30_web_stack/references/SUPABASE_AUTH_SSR.md) §8-2

### 12-8. flowchart-studio — §E chrome 後の E2E 落とし穴（2026-06）

§E 改定（固定ヘッダー · 表/プレビュー見出し整理 · N8/N9 · fixed `EditorMoreMenu`）後に spec が一括で落ちる典型。**新規スクリプトは不要** — ロケーターと helper の SSOT を直す。

| 落とし穴 | 対策 |
|----------|------|
| `getByRole('button', { name: '再生成' })` が **strict mode**（表ヘッダー + canvas 内リンクの 2 件） | `#table` にスコープ（`e2e/helpers/flowchart.ts` · `headerRegenerate`）— workspace+desktop では Panel#table 内は `<header>` でなく `<div.shrink-0>` のため `#table header` では見つからない |
| デスクトップ §E で見出し **「表」「プレビュー」** が `sr-only` または削除 | `#table` · `#canvas` の visible、または `.react-flow__node` で 3 ペインを検証 |
| **N8** 初期は全ユニット折りたたみ → 動作ボタン・削除 icon が DOM にない | `getByTestId('toggle-all-units')` / `ensureUnitsExpanded` を **モジュール操作・削除の前**に実行（`e2e/nav-n8.spec.ts`） |
| `EditorMoreMenu` 下端（**危険** · 例: フローリセット）が **viewport 外**で `.click()` 失敗 | `dispatchEvent('click')`（`e2e/flow-reset.spec.ts`）— fixed 配置メニューの既知パターン |
| 無効 `menuitem`（例: import 未設定）は **フォーカス不可** | keyboard テストは `getByRole('menuitem', { disabled: false })`（`e2e/a11y-keyboard.spec.ts`） |
| 取込ステータスが **閉じた `<details>`** 内で `hidden` | `toBeVisible` だけに頼らず `toBeAttached` や **表行数** assert |
| メニュー文言の **スペース差**（`import.jsonを取込…` 等） | UI 正本は `EditorMoreMenu.tsx` · `ボタン一覧.md` — spec は **完全一致** |

→ 索引: [`REACTFLOW_UX_CHROME.md`](../../35_reactflow/references/REACTFLOW_UX_CHROME.md) §5.6-2 · §5.6-2b · [`REACTFLOW_UX_WORKSPACE.md`](../../35_reactflow/references/REACTFLOW_UX_WORKSPACE.md) §5.7 · `e2e/nav-n8.spec.ts`

---

### 12-9. flowchart-studio — ADR-018 第2弾後の E2E 追従パターン（2026-06）

サンプルメニュー削除 · CSV モーダル化 · `authDisabled` ガード強化後の典型落とし穴。

| 落とし穴 | 対策 |
|----------|------|
| `setInputFiles` が `display:none`（`className="hidden"`）input でタイムアウト | `page.evaluate` + `DataTransfer` + `dispatchEvent('change', { bubbles: true })` で注入。`Object.defineProperty(input, 'files', { value: dt.files, configurable: true })` が必要（`loadCurrySampleViaFileInput` が正本） |
| `page.evaluate` 内で input が見つからない | **production build** に `data-testid` が含まれているか確認。E2E は `npm run start`（ビルド済み）を使うため、app code 変更後は必ず `npm run build` が先 |
| モーダルが `onApply` 直後に閉じ、パネル内 `setMessage()` が消える | モーダル内のステータスは assert せず、**親コンポーネントのステータスバー**（`"CSV を表に反映しました"` 等）を `toBeVisible()` で確認 |
| `boundingBox()` が `null` — async remount 後に呼ぶとヒットしない | `loadModule → setLoadKey` によるキー変更でリマウントが起きる。`boundingBox()` 前に `await expect(locator).toBeVisible({ timeout: 10_000 })` で安定させる |
| `authDisabled=true` 時に `!authDisabled` ガードで非表示になる UI | 「危険」セクション（フローリセット等）は `AUTH_DISABLED=1` E2E では DOM に出ない。`test.skip(true, "authDisabled=true 時は…非表示")` でスキップ |

正本: `e2e/helpers/flowchart.ts` · `e2e/flow-reset.spec.ts` · `e2e/a0001-excel-import.spec.ts` · `FlowchartEditor.tsx#import-json-file`

---

### 12-10. flowchart-studio — 本番 auth UI E2E（AUTH_E2E_STUB · 2026-06）

`AUTH_DISABLED=1` のデモ E2E では装置取込 · 設計メモタブ等が **非表示**（ADR-018）。本番 auth UI だけを検証する **別系統**を用意する。

| MUST | 実装 |
|------|------|
| **`AUTH_E2E_STUB=1` + `AUTH_DISABLED=0`** | `getAuthState()` → `kind: allowed`（Supabase 不要 · `isPlaywrightAuthStubEnabled` · Vercel 本番では無効） |
| **`IMPORT_E2E_STUB=1` とセット** | `importEquipmentBundle` が RPC をスキップ — **UI 配線**（ファイル選択 → プレビュー → 取込）まで |
| **spec 分離** | `e2e/import-bundle-auth.spec.ts` — 通常 `npm run test:e2e` では `playwright.config` の **`testIgnore`** で除外 |
| **実行** | `npm run test:e2e:import-auth` · CI は **別ステップ** · config の `isAuthImportRun()` が webServer env を切替 |
| **デモ spec との分担** | `import-bundle.spec.ts` — デモで取込メニュー**非表示** · auth spec — 取込**表示〜成功** · 右タブ表示 |

| 落とし穴 | 対策 |
|----------|------|
| 全 spec を `AUTH_DISABLED=0` で回す | **不可** — デモ専用 spec（`right-tabs` 等）が壊れる。auth 系は **ファイル分離 + 別 npm 脚本** |
| `import-bundle.spec.ts` の `test.skip` を外すだけ | webServer が `AUTH_DISABLED=1` のままでは import input が DOM にない — **auth 専用 spec + env 切替**が正 |
| Supabase なしで `allowed` を試す | **`AUTH_E2E_STUB`** を使う。本番 URL への E2E 直叩きは別途 storageState / 実ログイン |

正本: `backend/src/lib/supabase/e2eStub.ts` · `backend/src/lib/auth/session.ts` · `playwright.config.ts` · `e2e/import-bundle-auth.spec.ts` · [`LOCAL_DEV.md`](c:/yk-application/flowchart-studio/docs/LOCAL_DEV.md)
