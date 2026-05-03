# Playwright 設計ルール
## E2E テスト・ブラウザ自動化 — Design & Development Rules v2

作成日：2026-05-03（v2 更新）  
対象環境：`c:\yk-memo\playwright-test`（@playwright/test v1.59.1 / TypeScript / Chromium / Windows）

---

## ⚡ エージェント必読チェックリスト

コードを書く前に必ず確認する。

- [ ] `auth/session.json` を Git にコミットしていない（`.gitignore` 確認）
- [ ] 認証テストは毎回ログインせず `storageState: 'auth/session.json'` を使う
- [ ] `await expect(locator).toBeVisible()` の `await` が漏れていない
- [ ] Google Sheets の `goto` には `waitUntil: 'networkidle'` を使っていない（`'load'` を使う）
- [ ] スプレッドシートへの書き込みテストを並列実行していない（データ競合の恐れ）
- [ ] `page.waitForTimeout()` は使わず、locator/assertion ベースの待機を使っている

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

### 2-2. 固定待機を使わざるを得ない場合

GAS の iframe 読み込みなど、明確な完了イベントがない場合に**限り**使用可。  
必ずコメントで理由を記載すること。

```typescript
// GAS の iframe が完全にレンダリングされるまでの待機（DOM 完了イベントなし）
// 代替手段: expect で特定要素が出現するまで待つ方が堅牢
await page.waitForTimeout(2000);
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
import type { Frame, Page } from '@playwright/test';

async function getContentFrame(page: Page): Promise<Frame> {
  await page.goto(GAS_URL, { waitUntil: 'networkidle', timeout: 30000 });
  // GAS の iframe が完全にレンダリングされるまでの待機（DOM 完了イベントなし）
  await page.waitForTimeout(2000);

  // ① URL パターンで特定（最も堅牢）
  const byUrl = page.frames().find((f) => f.url().includes('userHtmlFrame'));
  if (byUrl) return byUrl;

  // ② コンテンツの特定要素が存在するフレームを探す
  for (const f of page.frames()) {
    if ((await f.locator('#reportTitle').count()) > 0) return f;
  }

  // ③ 最終手段：インデックス（GAS の実装変更で壊れる可能性あり）
  const byIndex = page.frames()[2];
  if (byIndex) return byIndex;

  // デバッグ用：全フレームのURLを出力してから例外
  page.frames().forEach((f, i) => console.log(`frames[${i}]: ${f.url()}`));
  throw new Error(`content frame not found; total=${page.frames().length}`);
}
```

### 4-2. ヘルパーの配置方針

- 共通ヘルパー → `tests/helpers/` 配下に置く（複数 spec から使う場合）
- ファイル内限定ヘルパー → spec ファイル内で定義（1 ファイルしか使わない場合）

---

## 5. セキュリティルール

### 5-1. session.json の取り扱い（最重要）

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
cd c:\yk-memo\playwright-test
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

すべて `c:\yk-memo\playwright-test` で実行する。

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
