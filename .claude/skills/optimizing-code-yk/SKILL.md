---
name: optimizing-code-yk
description: >
  依頼リポのコード最適化・コードチェック。M1 発火例「コードチェックして」「コード最適化レビュー」「現状と比較して」「サブエージェントで最適化」。
  M2 発火例「最適化を適用して」「レビュー結果を修正して」（M1 所見または同ターン明示必須）。
  Do NOT use for 単一パス差分レビューのみ（reviewing-code-yk）、資料整合（organizing-documents-yk）、
  機能追加（creating-*-yk）、commit/push のみ（committing-with-git-yk）。
---

# Optimizing Code（YK）

依頼された **プロジェクト／リポ** のコードを、**公式推奨・ベストプラクティス**と照合してチェックし、必要なら修正する。 **レビュー（M1）** と **修正（M2）** はモード分離。

**応答の先頭ラベル:** `[最適化レビュー]` `[最適化修正]` のいずれかを付ける。

## モード選択（先に 1 つだけ）

| モード | 発火例 | 副作用 |
|--------|--------|--------|
| **M1 レビュー** | コードチェック · 最適化レビュー · 現状と比較 · ベストプラクティスと照合 | 報告のみ · **修正しない** |
| **M2 修正** | 最適化を適用 · レビュー結果を修正 · レビューして修正して | コード変更 · テスト実行可 |

曖昧時は **1 問**: チェックだけ（M1）か 直すまで（M2）か。

**M2 単独禁止** — M1 の所見があるか、同一依頼で「レビューして修正して」と明示されたときのみ M2。

**小さな差分だけ見たい** → `reviewing-code-yk`（単一パス · Web 調査なし）。

## 依存

| 用途 | 参照 |
|------|------|
| スコープ | [references/scope.md](references/scope.md) |
| スタック → L1 · 実装スキル | [references/routing.md](references/routing.md) |
| M1 手順・レンズ | [references/review-lenses.md](references/review-lenses.md) |
| M2 ゲート | [references/fix-gates.md](references/fix-gates.md) |
| Web 調査 | **`researching-web`** — M1 Step 2 で Read して委譲 |
| 多視点比較 | **`reviewing-with-subagents`** — M1 Step 4 で Read して委譲 |
| 品質ゲート | `c:/yk-skill/rule/60_tooling/QUALITY_GATE_RULES.md` |
| Git commit | **しない** — `committing-with-git-yk` はユーザー明示時のみ |

## 使わない場面

| 依頼 | 正しい扱い |
|------|------------|
| PR 前の差分レビュー単体（軽量） | `reviewing-code-yk` |
| 資料の矛盾 | `organizing-documents-yk` |
| 新機能・画面追加 | `creating-*-yk` |
| ルール追記 | `distilling-rules-yk` |

---

## M1 レビュー（Check）

[references/review-lenses.md](references/review-lenses.md) に従う。

### 要約

1. **スコープ** — デフォルトは依頼リポ全体（[scope.md](references/scope.md)）
2. **スタック特定** — `package.json` 等 · [routing.md](references/routing.md) で L1 を決める
3. **事前整理** — lint/typecheck はユーザー明示または変更が大きいときのみ（サブに渡さない）
4. **`researching-web`** — スタックの公式推奨・非推奨 API を調査（URL 必須）
5. **レンズ 2〜3 個**を選び、`Task` で **並列**起動（`reviewing-with-subagents` の形式）
6. **統合報告** — BLOCKER / MAJOR / MINOR · 所見 ID 付与 · **修正しない**

**禁止:** M2 と同時実行 · サブ 1 体だけで「多角的」 · `git commit` / `git push`

---

## M2 修正（Apply）

[references/fix-gates.md](references/fix-gates.md) に従う。

### 要約

1. **入口ゲート** — M1 所見 or 同一ターン明示
2. **対象所見** — ユーザー指定 or BLOCKER/MAJOR から優先
3. **`creating-*-yk` 委譲** — パスで選択（[routing.md](references/routing.md)）
4. **テスト** — リポに script があれば実行
5. **報告** — 対応所見 · テスト結果 · 未対応 · 変更ファイル一覧
6. **Git** — commit しない

---

## スキル改善時

`creating-skills` · `SKILL_AUTHORING_RULES.md` · 実運用後に `review-lenses.md` を拡張。
