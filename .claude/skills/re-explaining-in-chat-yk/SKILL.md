---
name: re-explaining-in-chat-yk
description: チャット上で直前の作業・技術内容を平易に再説明する。発火例「もう一度説明」「平易に」「さっきのを整理」「改めて説明」。Do NOT use for 図解HTML・surge・curiositymap・techmap・図解を作って・デプロイ（→ creating-visual-explainers / creating-curiosity-map / creating-diagram-techmap）。
---

# Re-explaining in Chat（YK）

直前ターンまでの**作業内容・技術トピック**を、チャット本文だけでわかりやすく整理し直す。ファイルは作らない（Read のみ可）。

## Step 0: 底線を読む

1. `c:/yk-skill/rule/10_meta/COMMUNICATION_RULES.md` — 常時の口調・大きな作業の3点サマリ
2. [references/structure.md](references/structure.md) — 本依頼の章立て SSOT

## Step 1: 対象を特定

- **会話履歴**（当セッションの実施内容）を正とする
- ユーザーが `@` でファイルを指した場合は、その範囲に絞る
- コード・設定の**事実**を変えない。わかりやすさのための嘘は禁止

## Step 2: 章立てで出力

[structure.md](references/structure.md) の順に書く。単純な再説明は短縮可。

末尾に **COMMUNICATION_RULES §2** の3点（やったこと / まだ / 次の一手）がまだ無ければ足す。

## やらないこと

- 新規実装・commit（別依頼）
- 図解 HTML 生成・surge デプロイ
- 毎ターン自動で本スキル相当の長文（ユーザー明示がない限り）

## 関連

| 用途 | スキル / rule |
|------|----------------|
| 図解ページ | `creating-visual-explainers` · `creating-curiosity-map` · `creating-diagram-techmap` |
| 設計の詰め | `grill-me` |
| 引き継ぎ俯瞰 | `handoff-session-work` 確認モード |
