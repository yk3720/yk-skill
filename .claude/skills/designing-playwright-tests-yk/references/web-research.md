# Web 調査結果：Playwright で何をテストすべきか

## 要約

Playwright 公式は **E2E 割合の数値を規定しない**。業界のヒューリスティックとして E2E は全体の **5〜15%** に留め、クリティカルパス（ユーザーが実際に体験する重要フロー）を優先する。ロジック・バリデーション・API 契約は Vitest / API テストへ。描画・操作・レイアウト・認証フローは Playwright が適任。

**YK の採用値・決定フロー・シナリオ表の SSOT** → [decision-matrix.md](decision-matrix.md) · `PLAYWRIGHT_RULES` §13（索引）

## 調査で収束した論点（出典付き）

| 論点 | 出典 |
|------|------|
| ユーザー視点のロケーター（`getByRole` 等） | [Best Practices](https://playwright.dev/docs/best-practices) · [Locators](https://playwright.dev/docs/locators) |
| web-first アサーション | [Assertions](https://playwright.dev/docs/test-assertions) |
| テスト分離 · setup project（≒ storageState） | [Best Practices](https://playwright.dev/docs/best-practices) |
| E2E vs Component Test | [Components (experimental)](https://playwright.dev/docs/test-components) |
| axe 統合 | [Accessibility testing](https://playwright.dev/docs/accessibility-testing) |
| テスト種別の決定マトリクス（第三者整理） | [currents-dev test-architecture](https://github.com/currents-dev/playwright-best-practices-skill/blob/HEAD/architecture/test-architecture.md) |

## 実装規範（本ファイルに転記しない）

→ `PLAYWRIGHT_RULES` §1–12 · スキル `using-playwright`
