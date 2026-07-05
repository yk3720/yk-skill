---
name: creating-briefmap-yk
description: >
  上司・意思決定者向け HTML ブリーフ図解（briefmap）。状況報告と判断依頼を簡潔に。詳細はテキスト+面談。
  「briefmapで図解」「上司向け図解」「調査報告図解」「判断依頼図解」、routing-diagram-yk 委譲時に使用。
  Do NOT use for curiositymap/techmap/proposalmap/visual/FB、技術詳細図解、mermaid/flowchart-web、writing-proposals 単独。
---

# BriefMap（上司向けブリーフ図解）

## 目次

- [設計 SSOT](references/DESIGN.md) · [Phase 0](references/intake-checklist.md)
- [supervisor（既定）](references/html-structure-supervisor.md) · [hybrid 詳細](references/html-structure-hybrid.md) · [report](references/html-structure-report.md)
- [パーツ](references/brief-parts.md) · [文体](references/tone-checklist.md) · [文言洗練](references/copy-refinement.md)

**一文:** 上司向けに **状況とお願いだけ** を HTML で渡す。詳細は正本テキスト + 面談。**既定はローカル保存。**

## 対象読者

- **読者:** 上司（同僚エンジニア想定 · Web 非専門）
- **前提知識:** 「部下が◯◯を検討している」程度のみ想定
- **文体:** 報告書調 → [tone-checklist.md](references/tone-checklist.md)

## プリセット

| preset | 用途 | SSOT |
|--------|------|------|
| `supervisor`（**既定**） | 状況 + お願いのみ | [html-structure-supervisor.md](references/html-structure-supervisor.md) |
| `hybrid` | 比較表 · サービス構成等を載せる**厚い版**（明示時のみ） | [html-structure-hybrid.md](references/html-structure-hybrid.md) |
| `report-only` | 判断依頼なし · 共有のみ | [html-structure-report.md](references/html-structure-report.md) |

## ワークフロー

### Phase 0: 必須確認

[intake-checklist.md](references/intake-checklist.md) — 不足時は停止 · 一般論で穴埋め禁止

### Phase 1: HTML 生成

1. [base.html](references/base.html) を `output/{slug}.html` にコピー
2. preset に従い CONTENT 生成（**supervisor 既定**）
3. [brief-parts.md](references/brief-parts.md) · Lucide のみ · 絵文字禁止

### Phase 2: ブラッシュアップ

1. [tone-checklist.md](references/tone-checklist.md)
2. 本文の短文化・リスト整備 → [copy-refinement.md](references/copy-refinement.md)（**全文 Read 後**に整合チェック）
3. ユーザーが **「文章を洗練」** と明示したとき → `refining-copy-yk` に委譲（ループはそちら。HTML 固有は copy-refinement §2〜§5 を併用）
4. 「サブエージェントでレビュー」のみで修正まで不要なとき → copy-refinement §3

### Phase 3: 保存（既定: ローカル）

```powershell
Copy-Item -Force "output/{slug}.html" "{ユーザー指定パス}"
```

- パス未指定時はユーザーに確認
- **surge 公開:** ユーザーが**当ターンで明示**したときのみ Phase 4 へ

### Phase 4: surge（明示時のみ）

```powershell
$slug = "{slug}"
$deployDir = "output/_deploy-$slug"
New-Item -ItemType Directory -Force -Path $deployDir | Out-Null
Copy-Item -Force "output/$slug.html" "$deployDir/index.html"
Set-Content -Path "$deployDir/robots.txt" -Value "User-agent: *`nDisallow: /" -Encoding utf8
npx --yes surge $deployDir --domain briefmap-$slug.surge.sh
Copy-Item -Force "output/$slug.html" "c:/yk-tool/publish/briefmap-$slug.html"
```

`surge-published-list.md` を更新。

### Phase 5: 完了報告

```
完成: 【タイトル】（BriefMap · supervisor）

保存先: {ローカルパス}

伝えること:
- 状況（1行）
- お願い（N点）

詳細: {正本テキスト} · 面談
```

## 境界

| 使う | 使わない |
|------|----------|
| 上司向け · 状況+お願い | proposalmap · techmap |
| ローカル HTML | 毎回 surge（明示時のみ） |
| 正本 txt/md | 図解に技術詳細を全部載せる |
