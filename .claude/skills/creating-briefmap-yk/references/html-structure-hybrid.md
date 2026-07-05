# BriefMap — HTML 構造（preset: hybrid · 詳細版）

**用途:** ユーザーが**明示**したときのみ。比較表 · サービス構成等。**上司単独阅读の既定ではない** — 既定は [html-structure-supervisor.md](html-structure-supervisor.md)。

`references/base.html` の `<!-- CONTENT_START -->` 〜 `<!-- CONTENT_END -->` に挿入。

## ヘッダー（main 先頭）

- バッジ: `BriefMap · 【提案】` または `【相談】`（Phase 0 確定値）
- `h1`: テーマ名
- `p`: 1文結論（正本の調査結果1行）
- メタ: 対象読者 · 正本パス · 更新日

## セクション id 一覧

| 順 | id | ラベル | 種別 | 必須 |
|----|-----|--------|------|------|
| 0 | notice | 資料種別帯 | — | yes |
| 1 | ask | お願い（判断 N 点） | 提案 | yes |
| 2 | summary | 結論（1行）+ 5分要約 | 解釈 | yes |
| 3 | facts | 調査結果（現状 · 事実） | 事実 | yes |
| 4 | recommend | 推奨と理由 | 解釈+提案 | 正本にあれば |
| 5 | options | 選択肢比較（表 · フロー） | 事実 | 正本にあれば |
| 6 | compare | Web vs 代替 等の対比 | 事実 | 正本にあれば |
| 7 | arch | サービス構成図 | 事実 | 正本にあれば |
| 8 | risks | リスクと対策 | 事実+解釈 | 正本にあれば |
| 9 | terms | 用語（本文に出た語のみ） | — | 任意 · 最大7語 |
| 10 | refs | 正本 · URL | — | yes |

正本に無いセクションは **省略**（空見出しを置かない）。

## notice 帯（固定文の骨子）

> 本資料は **調査結果の報告** と **運用方針のご判断依頼** 用です。正本: `{正本ファイル名}`

## ask セクション

- 番号付きリスト（正本のお願い項目をそのまま）
- Copilot 等 **別議題** の注記が正本にあれば1行

## 事実/解釈/提案ラベル

各 `section` 見出し横または直下に小ラベル:

```html
<span class="text-xs font-medium text-ads-dim uppercase tracking-wide">事実</span>
```

パーツ → [brief-parts.md](brief-parts.md)
