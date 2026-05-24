# ProposalMap — HTML 構造

`references/base.html` の `<!-- CONTENT_START -->` 〜 `<!-- CONTENT_END -->` に挿入する。

## ヘッダー（main 先頭）

- `h1`：プロジェクト名（副題に「社内周知」可）
- `p.text-ads-muted`：1文要約（です・ます）
- メタ行：対象読者 · 資料種別 · 更新日（任意）

## セクション id 一覧

| id | 必須 |
|----|------|
| notice | yes（帯） |
| summary | yes |
| background | yes |
| purpose | yes |
| solution | yes |
| scope | yes |
| status | yes |
| terms | 用語があるとき |
| closing | yes |

## デザイン

- 絵文字禁止 · Lucide のみ
- 色は `ads-*`（base.html の Tailwind 設定）
- 各 `section` に `mb-12` 前後
- スマホ可読（表は `overflow-x-auto`）
- PDF：`window.print()`（base 付属）

パーツ断片 → [proposal-parts.md](proposal-parts.md)
