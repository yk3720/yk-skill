---
name: reviewing-with-subagents
description: Runs parallel subagent reviews from multiple explicit lenses (e.g. author vs reader vs auditor, engineer vs UX vs security). Use when the user asks for subagent review, multi-perspective critique, parallel reviewer agents, or debuts multiple reviewers at once. Do NOT use for simple single-pass proofreading without requested depth.
---

# サブエージェントによる多視点レビュー

## 目的

同じ成果物に対し **3 体以上のサブエージェント**を**同一ターンで並列起動**し、**互いに異なるレビュー視点**だけを担当させる。親エージェントが結果を統合する。

## 前提（必ず守る）

- **並列数**：レビュー用途では **3 体以上**（ユーザーが少数を明示した場合は従う）。
- **1 体 1 レンズ**：各サブエージェントに **1 つの視点**を固定し、万能レビュアーにしない。
- **文脈の埋め込み**：サブエージェントはユーザーメッセージを直接見られない。**対象全文またはパス・制約・用語**を各 `Task` の `prompt` に書き切る。
- **読み取りのみ**：ファイル変更が不要なら `subagent_type`: `explore` と `readonly`: `true` を検討する。
- **視点の開示**：各サブエージェントの報告の冒頭に、**どのレンズでレビューしたか**と、**そのレンズが何を見る視点か**（1〜3 文でよい）を必ず書かせる。親がユーザーへ返す最終報告でも、**レンズ名＋視点の要約**を所見と対応づけて示す。

## 手順

### Step 1: 対象と制約の確定

親が把握する：レビュー対象（パス／貼り付け）、目的（マージ可否・品質・安全・UX 等）、禁止事項（例：スコープ外のリファクタ禁止）。

スキル文書をレビューする場合は `c:\yk-skill\rule\SKILL_AUTHORING_RULES.md` を基準にできる（パスをプロンプトに含める）。

### Step 2: 視点の選定

→ [references/perspectives.md](references/perspectives.md) を読み、対象の種類とリスクに合わせて **3 つ以上のレンズ**を選ぶ。  
例：報告者・報告先・第三者／Staff・IxD・セキュリティ など。**同じ立場を二重に置かない。**

### Step 3: 並列起動

**1 回の応答で** `Task` を複数回並列呼び出す。各呼び出しで：

- `description`：短い識別名（例：`UX review`）
- `subagent_type`：`generalPurpose`（変更・調査が要る）または `explore`（読み取り中心）
- `prompt`：**レンズ名** + **その視点の定義（何を見るか）をプロンプト内に明記** + 対象 + **出力形式（下記）** + 他レンズへの越権禁止

各サブへの `prompt` に、次の**報告フォーマットをそのまま指示**する：

```markdown
## 採用レンズ
（例：報告先（受け手））

## この視点の内容
（このレンズが何を重視し、何を見ないか。1〜3 文。カタログの説明を要約してよい）

## 所見
（重大度・根拠・具体修正案）
```

### Step 4: 統合（親）

- 対立する所見は **根拠の強さ・重大度・スコープ**で整理し、単純平均しない。
- ユーザーには **合意点 / 対立点 / 推奨次アクション** を簡潔に返す。
- 統合文でも **サブごとに「レンズ名 → 視点の要約 → 主な所見」**が追えるようにする（視点が混ざって読めない状態にしない）。

## アンチパターン

- サブエージェントを **1 体だけ**で「多角的」と称する。
- プロンプトが **「なんでもレビューして」** で、視点が重複する。
- サブ結果を **貼るだけ**で親が判断・優先順位付けをしない。
- **採用レンズ**や**視点の内容**を省略した報告（どの立場の批評か判別不能なまま所見だけ並べる）。

## 参照

- 視点の具体例・表：**[perspectives.md](references/perspectives.md)**
- スキル執筆ルール（レビュー基準に使う場合）：`c:\yk-skill\rule\SKILL_AUTHORING_RULES.md`
- スキル作成手順・品質ゲート（パッケージレビュー時）：`c:\yk-skill\.claude\skills\creating-skills\SKILL.md`
