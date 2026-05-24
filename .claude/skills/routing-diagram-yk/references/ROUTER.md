# Routing Diagram — 子スキル・委譲 SSOT

本ファイルがパス・両方モード・slug の正本。`SKILL.md` に一覧を二重管理しない。

## 1. 子スキルパス（Read して実行）

| 形式 | skill_path |
|------|------------|
| curiositymap | `c:/yk-skill/.claude/skills/creating-curiosity-map/SKILL.md` |
| techmap | `c:/yk-skill/.claude/skills/creating-diagram-techmap/SKILL.md` |
| 汎用 visual | `c:/yk-skill/.claude/skills/creating-visual-explainers/SKILL.md` |
| proposalmap | `c:/yk-skill/.claude/skills/creating-proposalmap-yk/SKILL.md` |
| FB付き | `c:/yk-skill/.claude/skills/commenting-visual-explainers/.claude/skills/creating-visual-explainers-fb/SKILL.md` |

## 2. 使わないもの（境界）

| 依頼 | 使うスキル |
|------|------------|
| `.mmd` · mermaid で図 | `creating-mermaid-yk` |
| 表駆動フロー · flowchart-web-reactflow | `c:/yk-tool/flowchart-web-reactflow/README.md` |
| チャットで平易に再説明のみ | `re-explaining-in-chat-yk` |

## 3. 曖昧 → 本ルーター / 明確 → 子直行

| ユーザー例 | 扱い |
|------------|------|
| 「〇〇を図解して」（形式なし） | **routing-diagram-yk** → Step 1 質問 |
| 「〇〇を curiositymap で図解」 | curiosity **直行**（本ルーター不要） |
| 「〇〇を techmap で」 | techmap **直行** |
| 「〇〇を proposalmap で」 / 提案書形式 / 企画書形式 / 社内周知 | proposalmap **直行** |
| 「〇〇を文系と技術の両方で」 | **両方モード**（質問省略可） |
| 「図解を作って」（形式なし） | **routing-diagram-yk** |

## 4. 両方モード（同テーマ · 2 種類）

**実績例:** `ai-three-walls` — techmap + curimap（`surge-published-list.md` #14–15）

### 手順

1. **テーマ・slug 基底**をユーザーと合意（例: `topic-slug`、英小文字・ハイフン）
2. **curiositymap 完走** — ドメイン `curimap-{topic-slug}.surge.sh`（子スキル手順どおり）
3. **techmap 完走** — ドメイン `techmap-{topic-slug}.surge.sh`
4. `c:/yk-tool/publish/` のファイル名が衝突する場合は次を推奨:
   - curiosity 正本: `curimap-{topic-slug}.html`
   - techmap 正本: `{topic-slug}-techmap.html` または `techmap-{topic-slug}.html`（既存台帳の命名に合わせる）
5. `surge-published-list.md` を **2 行**更新
6. 報告は **2 URL の表**（タイトル · 形式 · URL）

### コスト

- リサーチは各子スキル内で行われる（**おおよそ2倍**）。将来 `creating-diagram-bundle-yk` で共通化可能。

## 5. AskQuestion テンプレ（Step 1）

質問文（例）:

> どの形式で図解しますか？（テーマ: {ユーザーが指定した題材}）

選択肢（`allow_multiple: false` を基本。ユーザーが「複数」と言ったときのみ検討）:

| id | label |
|----|-------|
| curiosity | 文系・日常起点（curiositymap） |
| techmap | 理系・技術解説（techmap） |
| visual | 汎用（読者指定なし） |
| both | 文系＋技術の両方（URL 2 本） |
| fb | FBコメント付き図解 |
| proposalmap | 社内提案図解（周知用）— 非専門の社内関係者へ「作ろうとしているもの」 |

## 6. visual との役割分担

- **曖昧な「図解して」:** 本ルーターが先に形式を決める
- **形式確定後の汎用:** `creating-visual-explainers` が実行
- visual の description は「形式未指定時は routing-diagram-yk」を参照 — 単独で曖昧依頼を取り込まない
