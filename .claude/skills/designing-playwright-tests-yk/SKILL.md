---
name: designing-playwright-tests-yk
description: >
  Playwright で何を・いつ E2E すべきか設計する。発火例「E2Eで何をテスト」「Playwrightのテスト方針」
  「テストピラミッド」「クリティカルパスを決めて」。正本索引 PLAYWRIGHT_RULES §13 · 詳細 decision-matrix.md。
  Vitest と E2E の切り分け後、実装・実行は using-playwright へ。
  Do NOT use for spec 執筆・npm run test:e2e（using-playwright）、
  ユーザーが再現手順・検証意図を1件に限定した spec 依頼、単発 Web 調査（researching-web）。
---

# Designing Playwright Tests（YK）

**目的:** spec を書く前に、**テスト種別・スコープ・優先度**を決める。実装・実行は `using-playwright`。

## Step 0（必読）

1. `c:/yk-skill/rule/50_gas_html_test/PLAYWRIGHT_RULES.md` **§13**（索引）
2. [decision-matrix.md](references/decision-matrix.md)（**SSOT · 必読**）

## ワークフロー

1. **シナリオ列挙** — ユーザーストーリー単位（ページ単位ではない）
2. **層の決定** — decision-matrix の選定フロー
3. **E2E 候補の絞り込み** — クリティカルパス · 下位層で代替不可
4. **スコープ固定** — 1 test = 1 検証意図 · 巨大ジャーニー spec は禁止
5. **契約を先に決める** — `data-*` / role / 文言（spec 写法は `using-playwright` / §12-3）
6. **実装委譲** — spec 執筆・実行 → `using-playwright`

## 参照

| 内容 | ファイル |
|------|----------|
| 決定マトリクス · チェックリスト | [decision-matrix.md](references/decision-matrix.md) |
| Web 調査要約（URL） | [web-research.md](references/web-research.md) |
| a11y（axe / keyboard） | [a11y.md](references/a11y.md) |
| ロケーター · 待機 · 幾何 · 実行 | `PLAYWRIGHT_RULES` §1–12 · `using-playwright` |

## 出力（設計完了時）

- **Vitest に残す**一覧
- **Playwright E2E に書く**一覧（優先度順）
- **書かない**（理由付き）
- 各 E2E の **再現手順の骨子**（サンプル名 · 操作系列）

## 禁止

- ロジックだけの検証を E2E に載せる
- 外部サイト・制御不能依存の E2E
- 設計なしで spec を量産する
