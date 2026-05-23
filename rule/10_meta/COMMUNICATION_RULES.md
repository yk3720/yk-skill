# チャット応答・平易説明（YK 横断）

**目的:** Agent の**チャット応答**における口調と、作業後サマリの**最低ライン**を固定する。図解 HTML（`creating-visual-explainers` 等）とは別チャネル。

**関連:** `10_meta/SKILL_AUTHORING_RULES.md`（簡潔さ）· user rule「タスクに比例した長さ」· スキル `re-explaining-in-chat-yk`（Phase 1 · 明示依頼時の章立て）

**最終更新:** 2026-05-23（Phase 1）

---

## 1. 常時（すべての応答）

| 項目 | 規則 |
|------|------|
| 言語 | 日本語（user rule に従う） |
| 長さ | **タスクに比例**。一行修正・確認だけのターンは短く。既存 user rule の「簡潔」と矛盾させない |
| 専門用語 | **初出のみ**、括弧で短く平易に（例: API（他ソフトとやり取りする窓口）） |
| 読者ラベル | 見出し・本文に「初心者向け」「中学生向け」等を**付けない**（`creating-visual-explainers` と同型） |
| 口調 | 見下さない。丁寧だが冗長な敬語の連打は避ける |

---

## 2. 作業が「大きい」ときの締め（必須）

次のいずれかに当てはまるターンの**末尾**に、短く **3 点**を入れる（各 1 行で可）。

- 複数ファイル・複数リポを変更した
- 新規ドメイン・新規 rule 帯・初回試作を完了した
- ユーザーが「何をしたか」「振り返り」を求めた

| # | 内容 |
|---|------|
| 1 | **やったこと**（要約） |
| 2 | **まだやっていないこと**（意図的に残したもの） |
| 3 | **次の一手**（ユーザーが取れる 1 件） |

小さな修正（typo 1 件・Read のみの確認等）では **3 点ブロックは不要**。

---

## 3. ユーザーが「もう一度」「平易に」と明示したとき

- §2 の 3 点に加え、**たとえ話は 1 つまで**、必要なら表で整理してよい
- **図解 HTML・surge デプロイ**の依頼ではない — その場合は `creating-visual-explainers` / `creating-curiosity-map` / `creating-diagram-techmap` を使う
- フル章立てはスキル **`re-explaining-in-chat-yk`** → `references/structure.md` を Read して従う

---

## 4. やらないこと

- 毎ターン、長い再説明を自動で出す（誤発火・トークン浪費）
- 図解スキルの代替としてチャットだけで図解相当の HTML を書く
- 事実と異なる簡略化（わかりやすさのための嘘）

---

## 5. 配置

| 層 | パス |
|----|------|
| SSOT（本ファイル） | `c:/yk-skill/rule/10_meta/COMMUNICATION_RULES.md` |
| L0 alwaysApply | `yk-skill` · `yk-memo` の `.cursor/rules/communication-yk.mdc` |
| L2 スキル（明示時） | `.claude/skills/re-explaining-in-chat-yk/SKILL.md` |

Cursor **User Rules**（Settings）にも同趣旨を載せる場合は、本ファイル §1〜§2 を要約してコピー可（リポ外の単体プロジェクト用）。
