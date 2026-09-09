# Playwright 設計ルール
## E2E テスト・ブラウザ自動化 — Design & Development Rules v2

**ステータス:** active（横断 always · `playwright-agent-yk.mdc` · L2 `designing-playwright-tests-yk` · `using-playwright` · ROUTER: `using-playwright/references/ROUTER.md`）

**最終更新:** 2026-09-09（B4 · 旧 §4・§8・§9・§11 の GAS/Sheets 分を `references/PLAYWRIGHT_GAS.md` へ。L1 は横断原則 §1–3・§5–7 + 索引）  
**配置:** `c:\yk-tool\playwright-test\`（@playwright/test **v1.61.1** / TypeScript / Chromium / Windows）— [RULE_INDEX](../RULE_INDEX.md) リポジトリマップ参照

---

## ⚡ エージェント必読チェックリスト

コードを書く前に必ず確認する。

- [ ] Secrets チェックリスト済み（[`SECRETS_HYGIENE`](../10_meta/SECRETS_HYGIENE_RULES.md) · 本ファイル §5-1）
- [ ] 認証テストは毎回ログインせず `storageState: 'auth/session.json'` を使う
- [ ] `await expect(locator).toBeVisible()` の `await` が漏れていない
- [ ] Google Sheets の `goto` には `waitUntil: 'networkidle'` を使っていない（`'load'` を使う）
- [ ] スプレッドシートへの書き込みテストを並列実行していない（データ競合の恐れ）
- [ ] `page.waitForTimeout()` は使わず、locator/assertion ベースの待機を使っている
- [ ] UI の見え方・重なりをユーザーに手動確認させる前に、再現可能な Playwright 検証を検討した（→ §12 索引 · `references/PLAYWRIGHT_AGENT_OPS.md`）

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

GAS の iframe 読み込みでも **`waitForTimeout` は使わない**。`#reportTitle` 等の **web-first アサーション**で準備完了を待つ（`getContentFrame` ヘルパーは [`references/PLAYWRIGHT_GAS.md`](references/PLAYWRIGHT_GAS.md) §1-1）。

```typescript
// ❌ 悪い例（anti-pattern）— フラキーの原因。デバッグ時以外は使わない
await page.waitForTimeout(2000);

// ✅ 代わりに PLAYWRIGHT_GAS.md §1-1 の getContentFrame または expect(byUrl.locator('#reportTitle')).toBeVisible()
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

## 4. GAS レポート / Google Sheets 固有（→ references）

GAS Web アプリの**入れ子 iframe アクセス**（`getContentFrame` ヘルパー）· **Spreadsheet 操作**（§8 相当 · `waitUntil` 使い分け · 直列書き込み · キーボードショートカット）· **Google ログイン設定**（§9 相当 · chromium launch args）· **GAS/Sheets 固有エラー表** は [`references/PLAYWRIGHT_GAS.md`](references/PLAYWRIGHT_GAS.md)。

横断ルール（§1 ロケーター · §2 待機 · §3 アサーション · §5 セキュリティ · §6 セッション · §7 タイムアウト）は本ファイルが SSOT。

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

## 8. Spreadsheet 操作・Google ログイン（→ references）

`waitUntil` の使い分け（GAS = `networkidle` / Sheets = `load`）· 書き込みテストの直列実行 · Windows キーボードショートカット · Google ログイン設定は [`references/PLAYWRIGHT_GAS.md`](references/PLAYWRIGHT_GAS.md) §2・§3（旧 §8・§9）。

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

**GAS / Google Sheets 固有のエラー**（`networkidle` タイムアウト · `selectAll` · ログイン画面 · `frames()[2]` · Sheets 並列破損 · IME）→ [`references/PLAYWRIGHT_GAS.md`](references/PLAYWRIGHT_GAS.md) §4。

| エラー | 原因 | 対処 |
|--------|------|------|
| テストは通るがアサーションが検証されていない | `await` の付け忘れ | `await expect(locator)...` と記載する |
| `トークン '&&' は...有効なステートメント区切りではありません` | **Windows PowerShell 5.1** では `&&` 非対応 | コマンド連結は `;` を使うか **`pwsh`（7+）** に切り替える（`10-1` 参照） |
| `EPERM: operation not permitted, unlink '.../test-results/.last-run.json'` | サンドボックス環境でのファイル書き込み制限 | `required_permissions: ["all"]` でサンドボックスを解除して実行 |
| `Executable doesn't exist at .../chrome-headless-shell.exe` | Chromium が未インストール | `npx playwright install chromium` を実行 |
| `strict mode violation: getByRole('heading') resolved to 2 elements` | 同一テキストの見出しが nav（h2）と main（h1）等の複数ランドマークに存在 | ランドマークでスコープを絞る — `page.getByRole('main').getByRole('heading', { name: 'X' })` または `page.getByRole('complementary').getByRole('heading', { name: 'X' })`。ヘッダーをレイアウト外へ昇格した場合に発生しやすい |

---

## 12. エージェント運用 — UI 確認は Playwright 優先（索引）

**詳細:** L3 `references/` — Ref Plan / spec 執筆時は [`PLAYWRIGHT_AGENT_OPS.md`](references/PLAYWRIGHT_AGENT_OPS.md) を Read。

| 節 | 内容 |
|----|------|
| §12-1 | いつ Playwright を使うか（Vitest vs Playwright） |
| §12-2 | 手動ブラウザ反復を避ける理由 |
| §12-3 | レイアウト・重なりの検証パターン |
| §12-4 | プロジェクト配置 |
| §12-5 | 実装時チェックリスト |
| §12-6 | flowchart-studio レイアウト E2E 落とし穴 |
| §12-7 | Server Action E2E スタブ |
| §12-8 | flowchart-studio §E chrome 後の E2E 落とし穴 |
| §12-9 | flowchart-studio ADR-018 第2弾後の E2E パターン（hidden input 注入 · モーダル閉じ · boundingBox null · authDisabled ガード） |
| §12-10 | flowchart-studio 本番 auth UI E2E（`AUTH_E2E_STUB` · `test:e2e:import-auth` · import-bundle-auth spec 分離） |

**スキル:** `using-playwright` · **ROUTER:** [`using-playwright/references/ROUTER.md`](../../.claude/skills/using-playwright/references/ROUTER.md)

---

## 13. テスト戦略 — 何を Playwright でテストするか（索引）

**詳細:** [`PLAYWRIGHT_TEST_STRATEGY.md`](references/PLAYWRIGHT_TEST_STRATEGY.md) + `designing-playwright-tests-yk/references/decision-matrix.md`

| 段階 | 担当 |
|------|------|
| 設計（spec 前） | `designing-playwright-tests-yk` |
| 実装・実行 | `using-playwright` |

**行数監査:** `yk-tool/scripts/audit-rule-line-counts.ps1` — L1 理想 ~250行 · FAIL 500行超

