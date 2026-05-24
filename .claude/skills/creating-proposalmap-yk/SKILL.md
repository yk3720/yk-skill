---
name: creating-proposalmap-yk
description: >
  社内の非専門職向け HTML 図解（proposalmap）を surge.sh に公開。企画・提案書の型で「作ろうとしているもの」を周知する。
  「proposalmapで図解」「提案書形式で図解」「企画書形式で図解」「社内周知で図解」、routing-diagram-yk 委譲時に使用。
  Do NOT use for curiositymap/techmap/visual/FB、技術深掘り、決裁・予算依頼文、mermaid/flowchart-web。
---

# ProposalMap（社内提案図解・周知用）

## 目次

- [設計 SSOT](references/DESIGN.md) · [章立て](references/html-structure.md) · [パーツ](references/proposal-parts.md) · [文体](references/tone-checklist.md)

**一文:** 社内の非IT関係者に、「こんなものを作ろうとしています」を企画・提案書の型で伝える HTML 図解を生成し、surge に公開する。

## 対象読者・トーン

- **読者:** 社内の非専門職（管理職・業務担当など）
- **目的:** **周知**（決裁・予算依頼ではない — 冒頭帯で必ず明示）
- **文体:** です・ます。平易だがカジュアルすぎない → [tone-checklist.md](references/tone-checklist.md)

## ワークフロー

### Phase 0: ソース収集

1. ユーザー指定のパス・URL・貼り付けを読む（企画 MD・MVP 定義など）
2. 不足時は `WebSearch` を **1〜2回**（事実確認のみ）
3. [DESIGN.md](references/DESIGN.md) の必須ブロックに沿ってメモを整理

### Phase 1: 用語対応表（社内向け）

| 用語 | 業務での言い換え | 初出定義（です・ます） |
|------|------------------|------------------------|
| … | … | … |

- 技術語は**業務語を先**、括弧で補足
- 略称は初出で正式名称を添える

### Phase 2: HTML 生成

1. [references/base.html](references/base.html) を `output/{slug}.html` にコピー
2. `<!-- TITLE -->` · `<!-- DESCRIPTION -->` を置換
3. [html-structure.md](references/html-structure.md) の章順で `CONTENT` を生成
4. [proposal-parts.md](references/proposal-parts.md) のパターンを流用（絵文字禁止 · Lucide のみ）

**slug:** 英小文字・ハイフン（例: `flowchart-web`）

### Phase 3: レビュー（推奨）

`reviewing-with-subagents` を Read し、**報告先・編集・SME** の3レンズで並列レビュー（readonly）。致命的指摘は Phase 4 で修正。

### Phase 4: ブラッシュアップ

[tone-checklist.md](references/tone-checklist.md) を全項目確認。

### Phase 5: デプロイ

surge は**ディレクトリ**を指定する。`output/_deploy-{slug}/` に `index.html`（本体のコピー）と `robots.txt` を置いて公開する。

**PowerShell:**

```powershell
$slug = "{slug}"
$deployDir = "output/_deploy-$slug"
New-Item -ItemType Directory -Force -Path $deployDir | Out-Null
Copy-Item -Force "output/$slug.html" "$deployDir/index.html"
Set-Content -Path "$deployDir/robots.txt" -Value "User-agent: *`nDisallow: /" -Encoding utf8
npx --yes surge $deployDir --domain promap-$slug.surge.sh
```

**正本コピー:**

```powershell
Copy-Item -Force "output/{slug}.html" "c:/yk-tool/publish/promap-{slug}.html"
```

`c:/yk-skill/metadata/surge-published-list.md` を更新（ツール種別 **ProposalMap** · URL · ファイル名 · 統計）。

### Phase 6: 完了報告

```
完成・公開完了: 【タイトル】（ProposalMap · 周知用）

（1〜2文要約）

公開URL:
https://promap-{slug}.surge.sh

この資料で伝えること:
- （3〜5点）

ご意見・フィードバックがあればお知らせください。
```

## 品質チェックリスト（要約）

- [ ] 周知帯（決裁・予算依頼でない旨）
- [ ] 3分要約（5行以内）
- [ ] 背景・目的・作ろうとしているもの・やる/やらない・進捗・お願い
- [ ] です・ます · 業務語優先 · 用語最大5
- [ ] Lucide のみ · レスポンシブ

全文 → [tone-checklist.md](references/tone-checklist.md)

## ルール参照（必要時のみ）

| 状況 | 参照 |
|------|------|
| surge 認証 | `c:/yk-skill/rule/10_meta/SECRETS_HYGIENE_RULES.md` |
| スキル改善 | `c:/yk-skill/rule/10_meta/SKILL_AUTHORING_RULES.md` |

## 境界

| 使う | 使わない |
|------|----------|
| 社内周知・作ろうとしているものの説明 | curiositymap（学習・日常たとえ） |
| 非専門向け企画・提案の型 | techmap（技術解説） |
| | visual（形式未指定の汎用） |
