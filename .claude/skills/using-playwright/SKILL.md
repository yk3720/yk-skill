---
name: using-playwright
description: >
  Playwright E2E の spec 執筆・実行。発火例「Playwrightでテスト」「E2E」「spec を書いて」「重なりを確認」。
  何を E2E に載せるかは designing-playwright-tests-yk（PLAYWRIGHT_RULES §13）を先に。
  UI 確認は手動ブラウザ反復より Playwright（§12 · always `playwright-agent-yk`）。
  表駆動フロー実装は creating-reactflow-yk、本スキルは spec 執筆・実行のみ。
  Do NOT use for テスト方針・ピラミッド設計（designing-playwright-tests-yk）、単発 Web 調査（researching-web）、図解 HTML、Python のみ。
---

# Using Playwright

## Step 0（必読）

```
c:/yk-skill/rule/50_gas_html_test/PLAYWRIGHT_RULES.md
```

**読み順:** UI レイアウト・重なりのみ → **§12 → §13（設計済み確認）→ spec**。GAS/Sheets 時のみ §1–11 深読。

- **§13** — 何を E2E に載せるか。**未設計なら** `designing-playwright-tests-yk` を先に。
  **省略可:** ユーザーが再現手順・検証意図を 1 件に限定 / UI 修正同一ターンでその修正の回帰 1 本のみ / decision-matrix チェックリストをインラインで満たす
- **§12** — エージェント運用（Vitest→Playwright、幾何 assert、`toPass`、Trace、配置表）
- **§1–11** — GAS/Sheets・ロケーター・待機・アサーション（GAS 時のみ深読）

## ワークフロー（要約）

0. **UI 修正同一ターン** — スコープが修正の回帰 1 意図なら designing 全文は不要。spec 追加後は **必ず** `npm run test:e2e`（Shell · `all` · `AGENT_SHELL_RULES` §3-2）
1. **designing 直後** — 出力の **E2E 一覧（優先度順）と骨子** を 1 test = 1 意図で spec に落とす
2. **層** — ロジックは Vitest、描画・重なりは Playwright（§12-1 · 戦略は §13）
3. 契約 `data-*` / `getByRole` → spec にユーザー操作と同じ手順を固定
4. 幾何前に `toBeVisible` 等で準備完了 → `toPass` / `expect.poll`（§12-3）
5. `npm run test:e2e` 等を実行（Shell: `AGENT_SHELL_RULES` §3-2 · `all`）
6. 失敗 → `npx playwright show-trace`（§12-5）

## 配置

| 対象 | spec | 実行 |
|------|------|------|
| GAS / Sheets | `c:/yk-tool/playwright-test/tests/` | `cd c:/yk-tool/playwright-test; npx playwright test tests/<name>.spec.ts --reporter=line` |
| Next（flowchart 等） | `<repo>/e2e/` | 各 `docs/LOCAL_DEV.md`（flowchart: `:3001` · `test:e2e:labels`） |

## 依存

`SECRETS_HYGIENE_RULES.md` · `GIT_WORKFLOW_RULES.md` · `AGENT_SHELL_RULES.md`

## 禁止

`session.json` コミット · 固定 `waitForTimeout` · PowerShell `&&` · サンドボックスのまま E2E · **UI 完了を手動スクショだけに依存**
