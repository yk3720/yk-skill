---
name: refining-copy-yk
description: >
  既存文章を多視点サブエージェントでレビューし、指摘がなくなるまで修正を繰り返して洗練する。
  発火例「文章を洗練」「文面を洗練」「この文章を洗練して」。
  文体は毎回ユーザーと確認してから着手する。
  Do NOT use for コード差分レビューのみ（reviewing-code-yk）、初稿ゼロからの起草のみ、
  図解 HTML の新規生成（creating-briefmap-yk 等）、レビューだけで修正しない依頼（reviewing-with-subagents）。
---

# Refining Copy（YK）

**発火:** ユーザーが **「文章を洗練」**（または同義の「文面を洗練」等）と依頼したとき。

**目的:** 対象テキストを、これ以上削っても足してもわかりにくくなる **必要十分な文** に整える（定義は [definition.md](references/definition.md)）。

**やらないこと:** 事実の捏造 · 方針の独断変更 · スコープ外の大幅な書き直し。

## 参照（着手順）

| 順 | ファイル | 役割 |
|----|----------|------|
| 1 | [definition.md](references/definition.md) | 洗練の定義 · 終了条件 |
| 2 | [style-routing.md](references/style-routing.md) | **文体確認（必須）** · ドメイン別 SSOT |
| 3 | [review-loop.md](references/review-loop.md) | サブエージェント並列 · 修正 · 再チェック |

並列レビューの共通手順: `reviewing-with-subagents`（視点カタログは同スキル `references/perspectives.md`）。

## ワークフロー

### Step 0: 文体の確認（毎回必須）

[style-routing.md](references/style-routing.md) に従い、**修正に入る前に** 文体・読者・トーンをユーザーと合意する。未指定なら選択肢を提示して確認する（推奨案＋理由）。

### Step 1: 材料を Read

- 対象全文（パスまたは貼り付け）
- 案件の方針 SSOT（例: `資料作成方針*.md`）· 正本テキスト · 設計メモ（あれば）
- Step 0 で選んだ文体の参照（例: `writing-internal-mail-yk` の patterns / exemplars）

### Step 2: レビュー → 修正ループ

[review-loop.md](references/review-loop.md) を **全文 Read 後** 実行する。

1. **3 体以上**のサブエージェントを **1 ターンで並列**起動（レンズは対象に合わせて選定）
2. 親が指摘を統合 · 優先度付け · **文章を修正**
3. **ブロッカー・中要修正が 0** になるまで 1〜2 を繰り返す（原則 **最大 3 ラウンド**）
4. 低のみ残る場合は 1 回統合修正 → 再チェック。まだ低が残ればユーザーに報告して終了可

### Step 3: 出力

- 洗練後の全文（指定パスがあればファイル更新）
- 変更サマリ（何を削った／足した／統一したか）
- 文体・正本との整合を 1 行で明記

### Step 4: 実例の更新（任意）

文体別の参照（例: `writing-internal-mail-yk/references/exemplars.md`）に、採用文面を追記するのは **ユーザー依頼時または creating-skills 完了時**。

## 境界

| 使う | 使わない |
|------|----------|
| メール · 報告書 · 提案の一部 · 図解の短文ブロック | コードレビュー · セキュリティ監査単体 |
| 多視点レビュー＋**親が修正まで担当** | サブ結果の貼り付けのみ（→ reviewing-with-subagents） |
| BriefMap HTML 本文 | BriefMap の新規生成 Phase 1（→ creating-briefmap-yk） |

BriefMap HTML を洗練するときは、本スキルのループに加え [creating-briefmap-yk/references/copy-refinement.md](../creating-briefmap-yk/references/copy-refinement.md) §2〜§5 を Read する。
