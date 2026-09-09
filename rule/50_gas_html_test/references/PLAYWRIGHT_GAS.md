# Playwright — GAS レポート / Google Sheets 固有（L3 参照）

**SSOT:** 本ファイル · **索引:** [`PLAYWRIGHT_RULES.md`](../PLAYWRIGHT_RULES.md) §4 · §8
**対象:** GAS Web アプリ（`script.google.com/.../exec`）· Google スプレッドシート（`docs.google.com/...`）の E2E。
**横断（先に読む）:** [`PLAYWRIGHT_RULES.md`](../PLAYWRIGHT_RULES.md) §1 ロケーター · §2 待機 · §3 アサーション · §5 セキュリティ · §6 セッション · §7 タイムアウト
**最終更新:** 2026-09-09（B4 · `PLAYWRIGHT_RULES` 旧 §4 · §8 · §9 · §11 の GAS/Sheets 行を集約）

---

## 1. GAS レポート専用：iframe アクセス

GAS の Web アプリは複数の iframe が入れ子になっている。

```
frame[0] : GAS 外側ラッパー（script.google.com/...）
frame[1] : userCodeAppPanel（中間ラッパー）
frame[2] : 実際の HTML コンテンツ ← ここを操作する（インデックスは変わる可能性あり）
```

### 1-1. iframe 取得の優先順位（堅牢な順）

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

### 1-2. ヘルパーの配置方針

- 共通ヘルパー → `tests/helpers/` 配下に置く（複数 spec から使う場合）
- ファイル内限定ヘルパー → spec ファイル内で定義（1 ファイルしか使わない場合）

---

## 2. Spreadsheet 操作

### 2-1. `waitUntil` の使い分け

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

### 2-2. 並列実行と書き込み競合

```typescript
// ✅ 書き込みテストは直列実行に設定
test.describe.configure({ mode: 'serial' });
```

### 2-3. キーボードショートカット（Windows 専用）

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

## 3. Google ログイン設定（Playwright）

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

セッション保存（`npm run setup`）と再利用は [`PLAYWRIGHT_RULES.md`](../PLAYWRIGHT_RULES.md) §6。

---

## 4. GAS / Sheets 固有のエラーと対処

| エラー | 原因 | 対処 |
|--------|------|------|
| `Test timeout of 30000ms exceeded` | Sheets で `networkidle` 待機がタイムアウト | `waitUntil: 'load'` に変更（§2-1） |
| `TypeError: page.keyboard.selectAll is not a function` | 存在しない API | `page.keyboard.press('Control+a')` を使う（§2-3） |
| ログイン画面が表示される | `session.json` が無効 | `npm run setup` を別 PowerShell で再実行（`PLAYWRIGHT_RULES` §6-3） |
| `frames()[2]` が取得できない | GAS の iframe 構造変更 | URL パターンやコンテンツ要素でフレームを特定する（§1-1） |
| 並列実行でスプレッドシートのデータが壊れる | 書き込みテストの競合 | `test.describe.configure({ mode: 'serial' })` を追加（§2-2） |
| IME が ON で `type` がおかしい | 日本語入力モードの干渉 | `fill()` を使うか IME OFF を確認（§2-3） |

汎用エラー（`await` 付け忘れ · PowerShell `&&` · `EPERM` · Chromium 未インストール · strict mode violation）は [`PLAYWRIGHT_RULES.md`](../PLAYWRIGHT_RULES.md) §11。
