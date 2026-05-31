---
name: using-playwright
description: >
  Playwright E2E・UI レイアウト検証。発火例「Playwrightでテスト」「E2E」「spec を書いて」「重なりを確認」。
  UI 確認は手動ブラウザ反復より Playwright（PLAYWRIGHT_RULES §12 · always `playwright-agent-yk`）。
  表駆動フロー実装は creating-reactflow-yk、本スキルは spec 執筆・実行のみ。
  Do NOT use for 単発 Web 調査（researching-web）、図解 HTML、Python のみ。
---

# Using Playwright

## Step 0（必読）

```
c:/yk-skill/rule/50_gas_html_test/PLAYWRIGHT_RULES.md
```

- **§12** — エージェント運用（Vitest→Playwright、幾何 assert、`toPass`、Trace、配置表）
- **§1–11** — GAS/Sheets・ロケーター・待機・アサーション（GAS 時のみ深読）

## ワークフロー（要約）

1. ロジックは Vitest、描画・重なりは Playwright（§12-1）
2. 契約 `data-*` / `getByRole` → spec にユーザー操作と同じ手順を固定
3. 幾何前に `toBeVisible` 等で準備完了 → `toPass` / `expect.poll`（§12-3）
4. `npm run test:e2e` 等を実行（Shell: `AGENT_SHELL_RULES` §3-2 · `all`）
5. 失敗 → `npx playwright show-trace`（§12-5）

## 配置

| 対象 | spec | 実行 |
|------|------|------|
| GAS / Sheets | `c:/yk-tool/playwright-test/tests/` | `cd c:/yk-tool/playwright-test; npx playwright test tests/<name>.spec.ts --reporter=line` |
| Next（flowchart 等） | `<repo>/e2e/` | 各 `docs/LOCAL_DEV.md`（flowchart: `:3001` · `test:e2e:labels`） |

## 依存

`SECRETS_HYGIENE_RULES.md` · `GIT_WORKFLOW_RULES.md` · `AGENT_SHELL_RULES.md`

## 禁止

`session.json` コミット · 固定 `waitForTimeout` · PowerShell `&&` · サンドボックスのまま E2E · **UI 完了を手動スクショだけに依存**
