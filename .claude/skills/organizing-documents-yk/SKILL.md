---
name: organizing-documents-yk
description: >
  プロジェクト資料の整合（M1）と Web 鮮度更新（M2）。M1 発火例「資料整合して」「矛盾を直して」「doc-sync」。
  M2 発火例「資料を最新化して」「古い記述を整理して」。横断は「四リポ横断で整合」等の明示時のみ。
  Do NOT use for handoffs 終了・アーカイブ（handoff-session-work）、L1 ルール追記（distilling-rules-yk）、
  コード修正（creating-*-yk / optimizing-code-yk）、commit/push のみ（committing-with-git-yk）。
---

# Organizing Documents（YK）

プロジェクト資料の **内部整合（M1）** と **外部鮮度・旧情報整理（M2）** をモード分離で扱う。

**応答の先頭ラベル:** `[整合]` `[更新]` のいずれかを付ける。

## モード選択（先に 1 つだけ）

| モード | 発火例 | v1 |
|--------|--------|-----|
| **M1 整合** | 資料整合 · 矛盾を直して · doc-sync · 資料の不整合 | **本実装** |
| **M2 更新** | 資料最新化 · 資料更新 · 古い記述を整理 | 骨格のみ → [refresh.md](references/refresh.md) |

曖昧時は **1 問**: M1（資料同士の矛盾）か M2（Web 最新化）か。

**M1 と M2 を同一依頼で連続実行しない**（「整合して最新化して」と明示されたときのみ M1 完了後に M2 へ）。

## 依存

| 用途 | 参照 |
|------|------|
| 読む範囲 Tier | [references/scope-tiers.md](references/scope-tiers.md) |
| M1 手順・判定表 | [references/reconcile.md](references/reconcile.md) |
| M2 手順（v1 骨格） | [references/refresh.md](references/refresh.md) |
| ドキュメント種別・正本 | `c:/yk-skill/rule/10_meta/PROJECT_DOCUMENT_RULES.md` |
| handoffs フォルダ整合 | `handoff-session-work`（確認 Tier-1）— 本スキルは置換しない |
| M2 の Web 調査 | `researching-web`（M2 実装時に委譲） |
| Git commit | **しない** — `committing-with-git-yk` はユーザー明示時のみ |

## 使わない場面

| 依頼 | 正しい扱い |
|------|------------|
| 引き継ぎ終了 · archive · commit+push | `handoff-session-work` |
| 実装の気づきをルールへ | `distilling-rules-yk` |
| コード最適化・リファクタ | `optimizing-code-yk` |
| 図解 HTML · surge | 図解スキル群 |

---

## M1 整合（Reconcile）

[references/reconcile.md](references/reconcile.md) に従う。

### 要約

1. **Tier 決定** — デフォルト **Tier P**（[scope-tiers.md](references/scope-tiers.md)）
2. **スコープ確定** — プロジェクト slug / リポ（ユーザー指定 · `@` パス · 文脈）
3. **Read 範囲を列挙**してから読む（全文一括 Read 禁止 · Grep 優先）
4. **矛盾検出** — reconcile.md のチェック ID
5. **修正方針**
   - **機械的** → 即修正（ステータス語 · 完了済み「次:」· 実装有無とボタン一覧 等）
   - **意味的** → 報告のみ（正本不明 · 方針 A vs B）
6. **報告** — 修正一覧 · WARN 一覧 · 触っていないファイル
7. **Git** — commit しない。変更ファイルを列挙し、必要なら「コミットして」を提案

**禁止:** Tier C をユーザー明示なしで勝手に実行 · 意味的矛盾の独断解決 · `git commit` / `git push`

---

## M2 更新（Refresh）— v1 骨格

[references/refresh.md](references/refresh.md) を Read。v1 では手順の骨格とゲートのみ。実装完了まで **報告中心** でよい。

旧情報は **削除よりアーカイブ優先**（`99_アーカイブ/` 等 · `PROJECT_DOCUMENT_RULES` §5）。

---

## スキル改善時

`creating-skills` · `SKILL_AUTHORING_RULES.md` に従う。M2 本実装時は `refresh.md` を拡張し `researching-web` 委譲を明記する。
