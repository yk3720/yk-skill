---
name: using-playwright
description: Playwrightを使ったE2Eテスト・ブラウザ自動化・スクリーンショット取得を行うスキル。プロジェクト固有のルールとベストプラクティスを適用する。「Playwrightでテストして」「スクリーンショットを撮って」「ブラウザ自動化して」「E2Eテストを書いて」「spec ファイルを作って」などの依頼で使用する。Google Sheets・GAS のブラウザ操作にも対応。
---

# Using Playwright

`c:\yk-tool\playwright-test` でのブラウザ自動化・E2Eテスト作成を支援する。

## 必読ルール（作業開始前に必ず読む）

**コードを書く前に以下を読み込むこと。省略禁止。**

```
c:/yk-skill/rule/50_gas_html_test/PLAYWRIGHT_RULES.md
```

ルールには以下が含まれる：ロケーター優先順位 / 待機処理 / アサーション / GAS iframe アクセス / セキュリティ / 認証 / タイムアウト / Spreadsheet操作 / コマンドリファレンス / よくあるエラーと対処

## 依存

- `c:/yk-skill/rule/50_gas_html_test/PLAYWRIGHT_RULES.md` — 設計ルール・コマンドリファレンス・エラー対処（SSoT）
- `c:/yk-skill/rule/10_meta/SECRETS_HYGIENE_RULES.md` — Secrets 横断（コミット・チャット貼付禁止）
- `c:/yk-skill/rule/10_meta/GIT_WORKFLOW_RULES.md` — Git 方針（commit / push）
- `c:\yk-tool\playwright-test\` — テスト実行環境
- `c:\yk-tool\playwright-test\auth\session.json` — Google セッション（Git コミット禁止 — 上記 GIT_WORKFLOW §2）

## ワークフロー

### Step 1: ルールを読む

`c:/yk-skill/rule/50_gas_html_test/PLAYWRIGHT_RULES.md` を読み込む。

### Step 2: spec ファイルを作成・編集する

- `c:\yk-tool\playwright-test\tests\` 配下に `.spec.ts` として配置
- ファイル先頭に URL 定数を一元管理する
- ロケーター・待機・アサーションは PLAYWRIGHT_RULES.md のルールに従う

### Step 3: テストを実行する

```powershell
# ディレクトリ移動は ; で連結（&& は PowerShell で使えない）
cd c:\yk-tool\playwright-test; npx playwright test tests/<ファイル名>.spec.ts --reporter=line
```

> **初回 or 環境構築時**: ブラウザが未インストールの場合は先に実行する
> ```powershell
> cd c:\yk-tool\playwright-test; npx playwright install chromium
> ```

### Step 4: 失敗時のデバッグ

| 状況 | 対処 |
|------|------|
| スクリーンショット確認 | `tests/screenshots/YYYY-MM-DD/` を確認 |
| ステップ確認 | `npm run test:ui` で Playwright UI モードを使う |
| トレース確認 | `npx playwright show-trace` |

## 禁止事項

- Secrets — `c:/yk-skill/rule/10_meta/SECRETS_HYGIENE_RULES.md`（`auth/session.json` 等）· PLAYWRIGHT_RULES §5-1
- `page.waitForTimeout()` を固定待機として使わない（GAS iframe 例外あり。詳細はルール参照）
- `&&` でコマンドを連結しない（PowerShell では `;` を使う）
- `required_permissions: ["all"]` なしで Cursor サンドボックスからブラウザテストを実行しない
