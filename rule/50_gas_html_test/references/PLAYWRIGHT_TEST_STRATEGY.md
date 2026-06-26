# Playwright — テスト戦略（L3 参照）

**SSOT:** 本ファイル · **索引:** [`PLAYWRIGHT_RULES.md`](../PLAYWRIGHT_RULES.md) §13  
**スキル:** `designing-playwright-tests-yk` · **詳細:** `decision-matrix.md`  
**最終更新:** 2026-06-27（P14c · L1 から分割）

---

## 13. テスト戦略 — 何を Playwright でテストするか（索引）

**目的:** E2E の乱立を防ぐ。**戦略層（載せる/載せない）の SSOT は本節 + `designing-playwright-tests-yk/references/decision-matrix.md`。** 実装層（ツール選択）は [`PLAYWRIGHT_AGENT_OPS.md`](PLAYWRIGHT_AGENT_OPS.md) §12-1。

| 段階 | 担当 |
|------|------|
| 設計（spec 前） | L2 スキル **`designing-playwright-tests-yk`** |
| 実装・実行 | L2 スキル **`using-playwright`** |

**spec 新規追加前:** [decision-matrix.md のチェックリスト](../../../.claude/skills/designing-playwright-tests-yk/references/decision-matrix.md) を満たす。新規フロー追加・大規模なら `designing-playwright-tests-yk` を先に（バグ修正の回帰 1 本は §13-4 インライン可）。

### 13-1. 詳細 SSOT

| 内容 | 参照 |
|------|------|
| ピラミッド · 選定フロー · 向き/向かない · チェックリスト | `c:/yk-skill/.claude/skills/designing-playwright-tests-yk/references/decision-matrix.md` |
| Web 調査要約（URL） | 同 `references/web-research.md` |
| a11y（axe / keyboard） | 同 `references/a11y.md` |
| ロケーター · 待機 · 幾何 · 実行 | L1 §1–11 · [`PLAYWRIGHT_AGENT_OPS.md`](PLAYWRIGHT_AGENT_OPS.md) · `using-playwright` |

### 13-2. §12 との役割分担

| 節 | 層 | 内容 |
|----|-----|------|
| **§13 + decision-matrix** | 戦略 | E2E に載せる/載せない · 割合 · 優先度 |
| **§12-1** | 実装 | 確認種別ごとの第一選択ツール（Vitest vs Playwright） |
| **§12-3 以降** | 実装 | 幾何 assert · Trace · 配置 · 落とし穴 |
