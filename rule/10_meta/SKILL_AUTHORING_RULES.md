# スキル作成ルール
## Cursor Agent Skills — Skill Authoring Rules v2

対象プロダクト: **Cursor IDE（Claude Sonnet エージェント）**  
参考: [Anthropic Skill Authoring Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) / [Agent Skills Overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)

**実行ワークフロー:** スキルの新規作成・更新・改善は `c:/yk-skill/.claude/skills/creating-skills/SKILL.md`（Step 0〜8）。**本ファイルは執筆規範の SSOT**（Step 0 の第 1 必読）。

**最終更新:** 2026-06-27（P14e · §5–§10 · §12 を `references/` へ分割）

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

**Cursor：** `SKILL.md` を置く**直近の親フォルダ名**と YAML の `name` を**一致**させる（探索・識別の前提）。

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
- **英語トリガー**が必要なときは description に短い英語句を足してよい（例: `Also for English: ...`）。本文は日本語でも可

```yaml
description: Extract text and tables from PDF files, fill forms, merge documents.
  Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
  Do NOT use for image-only files (use OCR skill instead).
```

---

## 4. プログレッシブ開示パターン

**コーディング規律が大きいドメイン（Python 等）:** `PROGRESSIVE_CONTEXT_ROUTING_RULES.md` の **Tier + Tag + Ref Plan + ROUTER.md** パターンを併用する。SKILL 執筆（本書）と役割分担 — 本書はスキル形式、同ファイルはルール/参照の読み分け。

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

## 5. Cursor 固有（索引）

**詳細 SSOT:** [`references/SKILL_AUTHORING_CURSOR.md`](references/SKILL_AUTHORING_CURSOR.md) — 配置 · `fullPath` · フロントマター · MCP ツール名 · Ask モード

---

## 6–8. ワークフロー · コンテンツ · スクリプト（索引）

**詳細 SSOT:** [`references/SKILL_AUTHORING_WORKFLOWS.md`](references/SKILL_AUTHORING_WORKFLOWS.md)

| 節 | 内容 |
|----|------|
| §6 | タスク進捗 · フィードバックループ |
| §7 | 時間依存情報禁止 · 用語統一 |
| §8 | スクリプトのエラー処理 · パス規約 |

---

## 9–10. 品質 · イテレーション（索引）

**詳細 SSOT:** [`references/SKILL_AUTHORING_QUALITY.md`](references/SKILL_AUTHORING_QUALITY.md)

| 節 | 内容 |
|----|------|
| §9 | アンチパターン一覧 |
| §10 | 評価ファースト · 2 セッション方式 · モデル階層テスト |

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
- [ ] ツール名にサーバー名が付いている（→ [`SKILL_AUTHORING_CURSOR.md`](references/SKILL_AUTHORING_CURSOR.md) §5-3）

### Cursor 固有
- [ ] `name` と `SKILL.md` の親フォルダ名が一致している
- [ ] `fullPath` を使う場合は絶対パス + フォワードスラッシュ
- [ ] 読み取り専用モードで実行不可な手順に注意書きがある

---

## 12. Web スタック参照ルール（索引）

**詳細:** [`references/SKILL_AUTHORING_WEB_STACK.md`](references/SKILL_AUTHORING_WEB_STACK.md) — Next.js · Vercel · Tailwind · shadcn パス一覧

---

**行数監査:** `yk-tool/scripts/audit-rule-line-counts.ps1` — L1 理想 ~250行 · FAIL 500行超
