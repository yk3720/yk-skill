# スキル作成ルール
## Cursor Agent Skills — Skill Authoring Rules v2

対象プロダクト: **Cursor IDE（Claude Sonnet エージェント）**  
参考: [Anthropic Skill Authoring Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) / [Agent Skills Overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)

---

## 1. スキルがコンテキストに載るタイミング（重要前提）

スキルは **3 段階のプログレッシブ開示**で読み込まれる：

| 段階 | 何が載るか | タイミング |
|------|-----------|-----------|
| **常時** | YAML `name` + `description`（全スキルのメタ） | 常にコンテキストにある |
| **トリガー後** | `SKILL.md` 本文 | スキルが選ばれた後に読み込まれる |
| **都度** | 参照ファイル・スクリプト | 指示で読み込んだ時のみ |

**これが「簡潔さが最優先」の理由**：
- `description` は全スキル分が常にコンテキストを占有する → 短く、キーワードを絞る
- `SKILL.md` 本文はトリガー後のみ載る → 冗長さより正確さを優先
- 重い処理・詳細はスクリプトや参照ファイルに逃がす

---

## 2. 核心原則

### 2-1. 簡潔さが最優先

> **「Claude はすでに賢い」を前提とせよ。Claude が知っていることは書かない。**

各記述に対して自問する：
- この説明は Claude に本当に必要か？
- このパラグラフはトークンコストに見合うか？

```python
# ✅ 良い例（約50トークン）
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
# ❌ 悪い例：PDF とは何か・なぜ pdfplumber を使うかの説明を長々と書く → 不要
```

### 2-2. 自由度を適切に設定する

| 自由度 | 使う場面 | 指示形式 |
|--------|----------|----------|
| 高 | 複数のアプローチが有効・文脈依存の判断 | テキストによる方針・手順 |
| 中 | 推奨パターンがある・設定で挙動が変わる | パラメータ付きの疑似コード |
| 低 | 操作が脆弱・一貫性が必須・順序固定 | 完全なコマンド・「このまま実行せよ」形式 |

---

## 3. スキルの構造

### 3-1. YAML フロントマター（必須）

```yaml
---
name: skill-name-here
description: スキルの説明文
---
```

**`name` の制約：** 最大64文字・小文字/数字/ハイフンのみ・XML タグ禁止・`anthropic`/`claude` 予約語禁止

**`description` の制約：** 必須（空不可）・最大1024文字・XML タグ禁止

> Cursor の `agent_skills` でフルパス指定される場合でも、**移植性・説明文品質**のためフロントマターは必須。

### 3-2. 命名規則

```
processing-pdfs        ✅ 動名詞形（動詞 + -ing）推奨
analyzing-spreadsheets ✅
helper / utils         ❌ 曖昧すぎ
anthropic-helper       ❌ 予約語使用
```

### 3-3. description の書き方

- **三人称で書く**（一人称・二人称禁止）
  - ✅ `Processes Excel files and generates reports`
  - ❌ `I can help you process Excel files`
- 「**何をするか**」と「**いつ使うか**（トリガーキーワード）」の両方を含める
- 可能なら「**使わない条件（負のトリガー）**」も短く書く（誤発火防止）

```yaml
description: Extract text and tables from PDF files, fill forms, merge documents.
  Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
  Do NOT use for image-only files (use OCR skill instead).
```

---

## 4. プログレッシブ開示パターン

### 4-1. SKILL.md は目次として機能させる

- **SKILL.md 本文は 500 行以内**を維持する
- 詳細情報は別ファイルに分離し、必要時のみ読み込ませる
- 参照は **1段階のみ**（SKILL.md → 参照ファイル）

```
pdf/
├── SKILL.md          # メイン（500行以内）
├── FORMS.md          # 詳細ガイド（必要時のみ）
└── scripts/
    └── analyze_form.py
```

### 4-2. 100行超えのファイルには目次を付ける

```markdown
## Contents
- 認証・セットアップ
- コアメソッド
- エラーハンドリング
```

### 4-3. 重い処理はスクリプトに逃がす

SKILL.md に長い手順を書くより、スクリプトに処理を書いて「実行してください」と指示する方がトークン効率が良い。

---

## 5. Cursor 固有の設定ルール

### 5-1. スキルのパス設定

```yaml
# RULES.md または settings での登録例
agent_skills:
  - fullPath: "c:/your-skill-dir/.claude/skills/your-skill/SKILL.md"
```

- パスは**フォワードスラッシュ**（`/`）を使う（Windows でも `\` は避ける）
- `fullPath` は絶対パスで指定する

### 5-2. ツール名は `サーバー名:ツール名` 形式で書く

```markdown
# ❌ ツール名だけだと "tool not found" になる
BigQuery でスキーマを確認する

# ✅ サーバー名付きで書く
BigQuery:bigquery_schema でスキーマを確認する
```

### 5-3. 読み取り専用モード（Ask モード）への配慮

Cursor の Ask モード / 読み取り専用セッションでは**変更系ツールが使えない**。  
スキルに「ファイルを書き込む」手順がある場合は、Agent モードでのみ有効と明記するか、代替手順（コードを提示して「コピーしてください」）を書く。

---

## 6. ワークフローとフィードバックループ

### 6-1. 複雑なタスクにはワークフローを使う

```markdown
## タスク進捗
- [ ] Step 1: フォームを解析する
- [ ] Step 2: フィールドマッピングを作成する
- [ ] Step 3: マッピングを検証する
- [ ] Step 4: フォームに記入する
- [ ] Step 5: 出力を確認する
```

### 6-2. フィードバックループを実装する

```markdown
1. ドキュメントを編集する
2. 即座に検証する: `python validate.py`
3. 検証失敗時 → エラーを確認して修正 → 再検証
4. 検証通過後のみ次へ進む
```

---

## 7. コンテンツガイドライン

### 7-1. 時間依存情報を書かない

```markdown
# ❌ 悪い例
2025年8月以前は旧 API を使用。それ以降は新 API を使用。

# ✅ 良い例
## 現在の方法
v2 API エンドポイントを使用

## 旧パターン（廃止: 2025-08 以降は不要）
...
```

### 7-2. 用語を統一する

1つの概念には1つの用語を使い続ける。`endpoint / URL / route / path` の混在は禁止。

---

## 8. スクリプトを含むスキル

### 8-1. エラーハンドリングをスクリプト内で完結させる

```python
# ✅ スクリプト内でエラーを処理する
try:
    with open(path) as f:
        return f.read()
except FileNotFoundError:
    return ""  # デフォルト値で続行
```

### 8-2. マジックナンバーを排除する

```python
# ❌
TIMEOUT = 47

# ✅（理由をコメントで）
REQUEST_TIMEOUT = 30  # 一般的な HTTP タイムアウト + 低速接続の余裕
```

### 8-3. パスは必ず Unix スタイル（`/`）で書く

```
✅ scripts/helper.py
❌ scripts\helper.py
```

---

## 9. アンチパターン

| アンチパターン | 理由 |
|--------------|------|
| 選択肢を多く提示しすぎる | 判断を迷わせる。デフォルトを示して「代替」として補足する |
| 時間依存の条件分岐を書く | スキルが古くなった時に誤動作する |
| 参照を 2 段階以上ネストする | Claude が情報を取りきれない可能性がある |
| Windows スタイルのパスを使う | Unix 環境でエラーになる |
| Claude がすでに知っていることを説明する | トークンの無駄 |
| ツール名をサーバー名なしで書く | 「tool not found」エラーになる |
| SKILL.md に README を置く | SSoT が分散して混乱する |

---

## 10. スキル開発のイテレーション

### 10-1. 評価ファーストで開発する

```
1. スキルなしで Claude にタスクを実行させる
2. 失敗点・不足するコンテキストを記録する
3. 3つ以上の評価シナリオを作成する
4. 最小限のスキルを書いてギャップを埋める
5. 評価を繰り返して改善する
```

### 10-2. 2 セッション方式で改善する

| 役割 | 作業 |
|------|------|
| 設計セッション | SKILL.md の作成・改善を検討する |
| 検証セッション | 実際のタスクでスキルを使ってテストする |

検証セッションの挙動を観察 → 問題を設計セッションで共有 → 改善 → 再テスト

### 10-3. モデル階層でテストする

| モデル階層 | 確認ポイント |
|-----------|------------|
| Haiku 系（高速・低コスト） | ガイダンスは十分か？ |
| Sonnet 系（バランス型） | 指示は明確で効率的か？ |
| Opus 系（強力な推論） | 過剰説明になっていないか？ |

> **Cursor 単体なら**: 利用しているモデル（通常 Sonnet 系）でシナリオ検証するのが最低限。

---

## 11. リリース前チェックリスト

### コア品質
- [ ] description に「何をするか」「いつ使うか」が両方含まれる
- [ ] SKILL.md 本文が 500 行以内
- [ ] 時間依存情報なし（あれば「旧パターン」セクションへ）
- [ ] 全体で用語が統一されている
- [ ] ファイル参照が 1 段階のみ
- [ ] YAML フロントマターあり（`name` と `description`）

### スクリプト・コード
- [ ] スクリプトがエラーを Claude に丸投げしていない
- [ ] マジックナンバーにコメントで根拠を記述している
- [ ] パスが Unix スタイル（`/`）
- [ ] ツール名にサーバー名が付いている

### Cursor 固有
- [ ] `fullPath` が絶対パス + フォワードスラッシュ
- [ ] 読み取り専用モードで実行不可な手順に注意書きがある
