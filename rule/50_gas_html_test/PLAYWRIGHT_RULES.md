# Playwright 設計ルール
## E2E テスト・ブラウザ自動化 — Design & Development Rules v2

**ステータス:** active（横断 always · `playwright-agent-yk.mdc` · L2 `using-playwright` · ROUTER なし）

作成日：2026-05-03（v2 更新）  
**配置:** `c:\yk-tool\playwright-test\`（@playwright/test v1.59.1 / TypeScript / Chromium / Windows）— [RULE_INDEX](../RULE_INDEX.md) リポジトリマップ参照

---

## ⚡ エージェント必読チェックリスト

コードを書く前に必ず確認する。

- [ ] Secrets チェックリスト済み（[`SECRETS_HYGIENE`](../10_meta/SECRETS_HYGIENE_RULES.md) · 本ファイル §5-1）
- [ ] 認証テストは毎回ログインせず `storageState: 'auth/session.json'` を使う
- [ ] `await expect(locator).toBeVisible()` の `await` が漏れていない
- [ ] Google Sheets の `goto` には `waitUntil: 'networkidle'` を使っていない（`'load'` を使う）
- [ ] スプレッドシートへの書き込みテストを並列実行していない（データ競合の恐れ）
- [ ] `page.waitForTimeout()` は使わず、locator/assertion ベースの待機を使っている
- [ ] UI の見え方・重なりをユーザーに手動確認させる前に、再現可能な Playwright 検証を検討した（→ §12）

---

## 1. ロケーター（要素特定）の優先順位

要素を特定するロケーターは、**ユーザー視点に近いもの**を優先して使う。  
CSS クラスや XPath は DOM 構造の変化で壊れやすく、最終手段とする。

### 1-1. 推奨優先順位

```
1. getByRole()       ← 最優先。ユーザー視点 + アクセシビリティ検証も兼ねる
2. getByLabel()      ← フォーム要素に有効
3. getByPlaceholder()← プレースホルダーが安定している場合
4. getByText()       ← 表示テキストで特定（動的テキストは避ける）
5. getByTestId()     ← data-testid 属性（UI 変更に強い）
6. locator('#id')    ← ID セレクタ（変更の少ない ID なら許容）
7. locator('.class') ← クラスセレクタ（極力避ける）
8. XPath             ← 最終手段。使用時はコメントで理由を記載
```

```typescript
// ❌ 悪い例：CSS クラスは DOM 変更で壊れる
const btn = frame.locator('.sec-hd.g button:first-child');

// ✅ 良い例：ロール + 名前で特定
const btn = frame.getByRole('button', { name: '成形加工装置' });

// ✅ 許容例：安定した ID（GAS レポートで ID が固定の場合）
const title = frame.locator('#reportTitle');
```

### 1-2. Google Sheets の例外

**Sheets は canvas 主体の UI のため `getByRole` が効きにくい。**  
セル操作・名前ボックスは CSS セレクタのフォールバックとキーボード操作を許容する。

```typescript
const candidates = ['.waffle-name-box', '#t-name-box', '[class*="cell-input"]'];
for (const selector of candidates) {
  const loc = page.locator(selector);
  if ((await loc.count()) > 0) {
    await loc.first().click();
    break;
  }
}
```

### 1-3. GAS レポートの `data-device` 属性

`button[data-device="成形加工装置"]` パターンは、**ロールや名前が取れない場合の補助**として許容する。  
`getByRole({ name: '...' })` で取得できる場合はそちらを優先する。

---

## 2. 待機処理（Wait）のルール

`page.waitForTimeout()` による固定待機は**原則禁止**。  
Playwright のアサーションは自動リトライ機能を持つため、固定待機はフラキーテストの原因になる。

> **`waitForTimeout` は公式ドキュメントで「デバッグ用途」と明記。本番テストに使うと不安定化の原因になる。**

### 2-1. 代替手段（優先度順）

```typescript
// ❌ 悪い例：固定時間待機
await page.waitForTimeout(2000);

// ✅ 良い例1：web-first アサーション（自動リトライ付き）
await expect(frame.locator('#reportTitle')).toBeVisible({ timeout: 10000 });

// ✅ 良い例2：ロケーターの出現を待つ
await frame.locator('#reportTitle').waitFor({ timeout: 10000 });

// ✅ 良い例3：URL が変わるのを待つ
await page.waitForURL('**/exec**', { timeout: 30000 });
```

### 2-2. GAS iframe と固定待機（避ける）

GAS の iframe 読み込みでも **`waitForTimeout` は使わない**。`#reportTitle` 等の **web-first アサーション**で準備完了を待つ（→ §4-1）。

```typescript
// ❌ 悪い例（anti-pattern）— フラキーの原因。デバッグ時以外は使わない
await page.waitForTimeout(2000);

// ✅ 代わりに §4-1 の getContentFrame または expect(byUrl.locator('#reportTitle')).toBeVisible()
```

---

## 3. アサーション（検証）のルール

### 3-1. web-first アサーションを使う

```typescript
// ❌ 悪い例：点-in-time チェック（リトライなし）
const visible = await locator.isVisible();
expect(visible).toBe(true);

// ✅ 良い例：web-first アサーション（自動リトライ付き）
await expect(locator).toBeVisible();
await expect(locator).toContainText('進捗報告');
await expect(locator).toHaveClass(/active/);
```

### 3-2. `await` を必ず付ける

**Locator に対する `expect` には必ず `await`。**  
`await` の付け忘れは「常に通過するテスト」になる危険なバグ。

```typescript
// ❌ 危険：常に通過してしまう
expect(locator).toBeVisible();

// ✅ 正しい
await expect(locator).toBeVisible();
```

### 3-3. 便利な追加アサーション

```typescript
// フォーカス確認
await expect(locator).toBeFocused();
// 件数確認
await expect(locator).toHaveCount(3);
// アクセシブルネーム確認
await expect(locator).toHaveAccessibleName('送信');
// ソフトアサーション（失敗してもテストを続行）
await expect.soft(locator).toBeVisible();
```

---

## 4. GAS レポート専用：iframe アクセスのルール

GAS の Web アプリは複数の iframe が入れ子になっている。

```
frame[0] : GAS 外側ラッパー（script.google.com/...）
frame[1] : userCodeAppPanel（中間ラッパー）
frame[2] : 実際の HTML コンテンツ ← ここを操作する（インデックスは変わる可能性あり）
```

### 4-1. iframe 取得の優先順位（堅牢な順）

```typescript
import { expect, type Frame, type Page } from '@playwright/test';

async function getContentFrame(page: Page): Promise<Frame> {
  await page.goto(GAS_URL, { waitUntil: 'networkidle', timeout: 30000 });

  let resolved: Frame | null = null;
  await expect(async () => {
    const byUrl = page.frames().find((f) => f.url().includes('userHtmlFrame'));
    if (byUrl) {
      await expect(byUrl.locator('#reportTitle')).toBeVisible({ timeout: 3000 });
      resolved = byUrl;
      return;
    }
    for (const f of page.frames()) {
      if ((await f.locator('#reportTitle').count()) > 0) {
        await expect(f.locator('#reportTitle')).toBeVisible({ timeout: 3000 });
        resolved = f;
        return;
      }
    }
    throw new Error('content frame not ready');
  }).toPass({ timeout: 10000 });

  if (!resolved) {
    page.frames().forEach((f, i) => console.log(`frames[${i}]: ${f.url()}`));
    throw new Error(`content frame not found; total=${page.frames().length}`);
  }
  return resolved;
}
```

### 4-2. ヘルパーの配置方針

- 共通ヘルパー → `tests/helpers/` 配下に置く（複数 spec から使う場合）
- ファイル内限定ヘルパー → spec ファイル内で定義（1 ファイルしか使わない場合）

---

## 5. セキュリティルール

### 5-1. session.json の取り扱い（最重要）

**横断方針:** [`10_meta/SECRETS_HYGIENE_RULES.md`](../10_meta/SECRETS_HYGIENE_RULES.md) · [`GIT_WORKFLOW_RULES.md`](../10_meta/GIT_WORKFLOW_RULES.md) §2。以下は Playwright 固有の実装詳細。

`auth/session.json` には Google のクッキー情報が含まれる。**絶対に Git にコミットしない。**

```gitignore
# .gitignore に必ず記載すること
auth/session.json
```

**エージェント向け追加ルール：**
- チャット・ログ・スクリーンショット・Issue に session.json の内容を貼らない
- CI の artifact に含めない（環境変数や Secret Store を使う）
- 共有 PC ではテスト終了後にファイルを削除する

### 5-2. URL・ID の管理

```typescript
// ✅ spec ファイル先頭で一元管理
const REPORT_URL = 'https://script.google.com/macros/s/.../exec';
```

---

## 6. 認証・セッション管理のルール

### 6-1. セッション再利用

```typescript
// ✅ 正しいセッション再利用
test.use({ storageState: 'auth/session.json' });
```

### 6-2. 初回セットアップ

**Cursor のターミナルはサンドボックス環境でブラウザが起動できない。**  
`setup.js` は必ず通常の PowerShell ウィンドウで実行する。

```powershell
cd c:\yk-tool\playwright-test
npm run setup    # = node auth/setup.js
```

### 6-3. セッション切れの対処

```
症状：テスト実行時にログイン画面が表示される
対処：npm run setup を再実行（通常の PowerShell で）
周期：数週間〜数ヶ月で期限切れ
```

---

## 7. タイムアウト設定のルール

```typescript
// playwright.config.ts 推奨設定（変更時にコメントを残すこと）
export default defineConfig({
  use: {
    actionTimeout: 10000,     // クリック・入力などのアクション上限
    navigationTimeout: 30000, // ページ遷移の上限
  },
  expect: {
    timeout: 5000,            // アサーションのリトライ上限（デフォルト 5s）
  },
  timeout: 30000,             // 1テストの上限（デフォルト 30s）
});
```

> GAS・Google Sheets は外部サービスのため、個別テストで `timeout` を延長してもよい。

---

## 8. Spreadsheet 操作のルール

### 8-1. `waitUntil` の使い分け

| 対象 URL | 推奨 `waitUntil` | 理由 |
|---------|----------------|------|
| GAS Web アプリ（`.../exec`） | `networkidle` | 初期ロード後は通信が止まる |
| Google スプレッドシート（`docs.google.com/...`） | `load` | 常時 Ajax 通信が続くため `networkidle` にならない |

```typescript
// ✅ GAS
await page.goto(GAS_URL, { waitUntil: 'networkidle', timeout: 30000 });

// ✅ スプレッドシート
await page.goto(SPREADSHEET_URL, { waitUntil: 'load', timeout: 30000 });
// ❌ これは 30 秒でタイムアウトする
await page.goto(SPREADSHEET_URL, { waitUntil: 'networkidle', timeout: 30000 });
```

### 8-2. 並列実行と書き込み競合

```typescript
// ✅ 書き込みテストは直列実行に設定
test.describe.configure({ mode: 'serial' });
```

### 8-3. キーボードショートカット（Windows 専用）

```typescript
// ✅ 正しい
await page.keyboard.press('Control+a');
await page.keyboard.type(cellAddress);
await page.keyboard.press('Enter');

// ❌ 存在しない API
await page.keyboard.selectAll();
```

> **日本語 IME がオンの状態**で `keyboard.type` を使うと意図した文字が入らないことがある。  
> テスト前に英数モードを確認するか、名前ボックス等には `fill()` を使う方が安定する。

---

## 9. Google ログイン設定（Playwright）

```typescript
const browser = await chromium.launch({
  headless: false,
  channel: 'chrome',
  args: ['--disable-blink-features=AutomationControlled'],
  ignoreDefaultArgs: ['--enable-automation'],
});
const context = await browser.newContext({
  userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 ...',
});
```

> **注意**: これは Google の検出を回避するための設定だが、ポリシー変更で効果が変わる可能性がある。  
> テスト専用の Google アカウントを使うことを強く推奨する。

---

## 10. コマンドリファレンス

すべて `c:\yk-tool\playwright-test` で実行する。

| コマンド | 内容 | 実行環境 |
|----------|------|----------|
| `npm test` | 全テスト実行 | Cursor ターミナル可 |
| `npm run screenshot` | スクリーンショット保存 | Cursor ターミナル可 |
| `npm run spreadsheet` | スプレッドシート自動入力 | Cursor ターミナル可 |
| `npm run test:headed` | ブラウザ表示ありで実行（デバッグ用） | Cursor ターミナル可 |
| `npm run test:ui` | Playwright UI モードで実行（ステップ確認に最適） | Cursor ターミナル可 |
| `npm run report` | HTML レポートを表示 | Cursor ターミナル可 |
| `npm run setup` | Google ログイン状態を保存 | **別窓 PowerShell のみ** |
| `npx playwright test --debug` | デバッグモード（ステップ実行） | Cursor ターミナル可 |
| `npx playwright install chromium` | Chromium ブラウザをインストール（初回 or 環境構築時） | Cursor ターミナル可 |

### 10-1. PowerShell でのコマンド連結

**シェルにより `&&` の有無が変わる。** **Windows PowerShell 5.1** では **`&&` が使えない**（エラーになる）。**PowerShell 7（`pwsh`）以降**では **`&&` が使える**。Cursor の既定が 5.1 の場合が多いため、**互換性重視なら `;` で連結**する。

```powershell
# ❌ Windows PowerShell 5.1：&& は構文エラーになりうる
cd c:\yk-tool\playwright-test && npx playwright test

# ✅ 互換：; で連結（5.1 / 7 共通）
cd c:\yk-tool\playwright-test; npx playwright test

# ✅ PowerShell 7+（pwsh）のみ：&& 可
# cd c:\yk-tool\playwright-test && npx playwright test
```

**テストが失敗したら**: `npm run test:ui` または `npx playwright show-trace` でトレースを確認する。  
推測で `waitForTimeout` を増やすより、Trace Viewer でどこで止まっているかを確認する方が確実。

---

## 11. よくあるエラーと対処

| エラー | 原因 | 対処 |
|--------|------|------|
| `Test timeout of 30000ms exceeded` | Sheets で `networkidle` 待機がタイムアウト | `waitUntil: 'load'` に変更 |
| `TypeError: page.keyboard.selectAll is not a function` | 存在しない API | `page.keyboard.press('Control+a')` を使う |
| ログイン画面が表示される | `session.json` が無効 | `npm run setup` を別 PowerShell で再実行 |
| `frames()[2]` が取得できない | GAS の iframe 構造変更 | URL パターンやコンテンツ要素でフレームを特定する |
| テストは通るがアサーションが検証されていない | `await` の付け忘れ | `await expect(locator)...` と記載する |
| 並列実行でスプレッドシートのデータが壊れる | 書き込みテストの競合 | `test.describe.configure({ mode: 'serial' })` を追加 |
| IME が ON で `type` がおかしい | 日本語入力モードの干渉 | `fill()` を使うか IME OFF を確認 |
| `トークン '&&' は...有効なステートメント区切りではありません` | **Windows PowerShell 5.1** では `&&` 非対応 | コマンド連結は `;` を使うか **`pwsh`（7+）** に切り替える（`10-1` 参照） |
| `EPERM: operation not permitted, unlink '.../test-results/.last-run.json'` | サンドボックス環境でのファイル書き込み制限 | `required_permissions: ["all"]` でサンドボックスを解除して実行 |
| `Executable doesn't exist at .../chrome-headless-shell.exe` | Chromium が未インストール | `npx playwright install chromium` を実行 |

---

## 12. エージェント運用 — UI 確認は Playwright 優先

**目的:** エージェントが「ブラウザで何度もリロードしてスクショ依頼」を繰り返すより、**再現可能な Playwright 検証**で完了判定する。

### 12-1. いつ Playwright を使うか（優先順）

| 確認したいこと | 第一選択 | 補足 |
|----------------|----------|------|
| 純ロジック（座標計算・分岐） | Vitest 等の単体テスト | DOM 不要 |
| 表示・クリック・文言・件数 | Playwright + `getByRole` / `getByText` | 公式 Best Practices に沿う |
| レイアウト（重なり・左右関係） | Playwright + `boundingBox` / `page.evaluate` | 下記 §12-3 |
| ピクセル単位の見た目全体 | `toHaveScreenshot` | OS・フォント差に弱い。必要時のみ |
| GAS iframe / Sheets | 本ファイル §4 · §7 | 既存パターン |

**原則:** ユーザーに「画面を見てください」を繰り返す前に、**同じ手順を spec に固定**し `npm run test:e2e`（またはプロジェクトの script）を実行する。失敗時は [Trace Viewer](https://playwright.dev/docs/trace-viewer)（§12-5）で原因を特定する。

### 12-2. 手動ブラウザ反復を避ける理由（調査要約）

- Playwright の **web-first アサーション**は自動リトライ付きで、固定 `waitForTimeout` より安定（[Best Practices](https://playwright.dev/docs/best-practices)）。
- テストは **ユーザーが見える出力**（role・label・text）に寄せ、CSS クラス依存を減らす（[Locators](https://playwright.dev/docs/locators)）。
- **テスト分離**（コンテキスト・認証 state）で「前のテストの影響」を排除（同上）。
- エージェントの手動確認は再現性・CI 共有・回帰検知に不利。**一度書いた spec は以降の修正でも使い回せる**。

### 12-3. レイアウト・重なりの検証パターン

1. **契約属性** — `data-testid` または `data-*`（例: `data-edge-label-branch`）。§1 の CSS クラスは最終手段。
2. **2要素の相対位置** — まず `locator.boundingBox()`（null チェック後に gap 比較）。
3. **複数 path / ライブラリ DOM** — `page.evaluate` + `getBoundingClientRect()`。**対象縦線が見つかったか**（`matchedVertical` 等）を必ず検証し、見つからなければ失敗。
4. **安定待ち** — 幾何の単発 `expect` はリトライなし。`await expect(...).toBeVisible()` の後、`expect(async () => { ... }).toPass()` または `expect.poll` で evaluate。
5. **スクリーンショット** — 要素単位の `toHaveScreenshot`（[Visual comparisons](https://playwright.dev/docs/test-snapshots)）。全体スクショは最終手段。`animations: 'disabled'` · `mask` · `maxDiffPixelRatio` を検討。

```typescript
// 2要素（契約属性があるとき）
const labelBox = await page.locator('[data-edge-label-branch="yes"]').boundingBox();
expect(labelBox).not.toBeNull();
// edgeBox も同様 · labelBox!.left >= edgeBox!.right + MIN_GAP_PX

// 複数 path（flowchart 例 — canonical: flowchart-web-reactflow/e2e/edge-label-placement.spec.ts）
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

→ React Flow の表駆動 E2E ゲート: [`REACTFLOW_RULES.md`](../35_reactflow/REACTFLOW_RULES.md) §6

### 12-4. プロジェクト配置

| リポジトリ | テスト置き場 | 起動例 |
|------------|--------------|--------|
| `c:/yk-tool/playwright-test/` | `tests/*.spec.ts` | `cd ...; npx playwright test` |
| `flowchart-web-reactflow` | `e2e/*.spec.ts` | `npm run test:e2e` · ラベルのみ `npm run test:e2e:labels` · E2E は **:3001** + `AUTH_DISABLED=1`（日常 dev :3000 と別）· [`docs/LOCAL_DEV.md`](../../../yk-tool/flowchart-web-reactflow/docs/LOCAL_DEV.md) |
| その他 Next アプリ | `e2e/*.spec.ts` | 各 `docs/LOCAL_DEV.md` |

**エージェント:** Shell は [`AGENT_SHELL_RULES.md`](../60_tooling/AGENT_SHELL_RULES.md) §3-2（test / E2E / 確認して の明示、**または** UI 修正で spec を追加した同一ターン）。Cursor からは `required_permissions: ["all"]`。

### 12-5. 実装時チェックリスト

- [ ] 再現手順（サンプル読込・再生成など）を spec に含めた
- [ ] 幾何 assert の前に web-first で準備完了（文言・件数・契約属性の visible）
- [ ] 認証が要るアプリは `AUTH_DISABLED` / `storageState` を config で明示した
- [ ] Trace が**実際に残る**設定（`on-first-retry` は **`retries >= 1` が前提**。`retries: 0` なら `retain-on-failure` または `trace: 'on'`）
- [ ] ユーザーへの依頼は「spec を直して green にする」に寄せ、スクショ依頼は最終手段

### 12-6. flowchart-web — レイアウト E2E の落とし穴（2026-05）

| 落とし穴 | 対策 |
|----------|------|
| **サンプル読込だけ E2E** し、**モジュール選択**を試さない | 実利用は左ナビのモジュール復元が多い → spec に **モジュールクリック → 生成完了 → halo** を含める（`REACTFLOW_RULES` §5.6-4） |
| コード修正後 **`:3000` の dev だけ**見る | E2E は `build` + `:3001` `next start`。手元確認は dev 再起動 + ハードリロード |
| `edge.label` 残存で白 pill が線上に見える | `toReactFlow` は `data.edgeLabel` のみ · `.react-flow__edge-text` が 0 件であることを assert |
| 幾何のみ pass で **halo スタイル未検証** | `[data-edge-label-branch]` が `bg-transparent` かを併用 |

→ 実装 SSOT: [`REACTFLOW_RULES.md`](../35_reactflow/REACTFLOW_RULES.md) §5.6-4
