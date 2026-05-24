---
name: routing-diagram-yk
description: >
  HTML 図解（surge）の受付・形式選択のみ。読者・形式が未指定の「図解して」「図解を作って」「このテーマを図解して」で使用。
  明示キーワード（curiositymap/techmap/文系/技術/FB付き）時は子スキルへ直行し本スキルは使わない。
  Do NOT use for 図解の本文生成・mermaid/flowchart-web・チャット再説明（re-explaining-in-chat-yk）。
---

# Routing Diagram（YK）

**役割:** 図解スタイルを決め、実行スキルに委譲する。**HTML は本スキルでは作らない。**

## Step 0: 直行判定（質問より先）

依頼に次が含まれるときは **本スキルを完走せず**、該当 `SKILL.md` を Read してその手順のみ実行する。

| キーワード例 | 実行スキル |
|--------------|------------|
| curiositymap · 文系向け · 初心者向け（図解文脈） | `creating-curiosity-map` |
| techmap · 技術を図解 | `creating-diagram-techmap` |
| FB付き · コメント付き図解 · フィードバック付き · コメント収集 | `creating-visual-explainers-fb` |
| 両方 · 文系と技術 · curiositymap と techmap | **Step 2「両方」**（下記） |

詳細・パス一覧 → [references/ROUTER.md](references/ROUTER.md)

## Step 1: 形式を1問で決める（曖昧時のみ）

上記直行に当てはまらないとき、形式を **1 問だけ** 決める。

- **AskQuestion が使えるとき:** AskQuestion を 1 回（まとめて質問しない）
- **使えないとき:** チャットで下表の選択肢を提示し、ユーザーの返答を待つ（ROUTER §5 のテンプレ可）

| id（例） | ラベル | おすすめ |
|----------|--------|----------|
| curiosity | 文系・日常起点（curiositymap） | 非専門の読者向け |
| techmap | 理系・技術解説（techmap） | エンジニア向け |
| visual | 汎用（読者指定なし） | 形式が決まらないときの既定 |
| both | **文系＋技術の両方** | 同テーマを2種類の資料にしたいとき |
| fb | FBコメント付き図解 | フィードバック収集付き公開 |

**推奨の付け方:** ユーザーが読者を書いていなければ「文系＋技術の両方」または「汎用」のどちらかを理由付きで提案する。

## Step 2: 委譲（実行）

1. 選択に応じ、ROUTER のパスで **子スキルの `SKILL.md` を Read**
2. 子スキルのワークフローを **先頭から最後まで**実行（省略しない）
3. **「両方」**のとき:
   - テーマ名と slug 基底（例: `quantum-intro`）を1回だけ決める
   - `creating-curiosity-map` を完走 → URL1
   - `creating-diagram-techmap` を完走 → URL2（slug・ドメイン衝突回避は ROUTER §両方）
   - 終了時に **2 URL を表**で返す
4. 本スキル単独では `git commit` しない（子スキル・ユーザー明示に従う）

## 禁止

- 子スキルを読まずに図解 HTML を独自生成する
- 曖昧なのに質問せず visual だけで完結する
- mermaid · flowchart-web · 図解以外のタスクに広げる

## 参照

- 子スキル一覧 · slug · 台帳: [references/ROUTER.md](references/ROUTER.md)
- 公開一覧: `c:/yk-skill/metadata/surge-published-list.md`
