# 段階的コンテキスト・ルーティング規則
## Progressive Context Routing — YK 共通パターン v1

**用途:** Python 以外を含む、**ドメイン別のコーディング規律・スキル**を新設・改修するときの共通設計 SSOT。  
**初回適用例:** `PYTHON_RULES.md` + `creating-pythoncode-yk` + `references/ROUTER.md`  
**関連:** `SKILL_AUTHORING_RULES.md` · 各 `*_RULES.md`

**最終更新:** 2026-05-23

**参照（外部）:**
- [Cursor: Agent Skills](https://cursor.com/docs/skills)
- [Anthropic: Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- [Anthropic: Equipping agents with Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)

---

## 1. 背景 — 解く問題

| 問題 | 症状 |
|------|------|
| **Eager loading** | 規律ファイルを毎回全読み → トークン枯渇・遅延 |
| **Pure lazy** | 何があるか分からず参照漏れ → 品質低下 |
| **分散したロード表** | `RULES` / `SKILL` / `README` に同じ表が3つ → 陳腐化 |

**目標:** 「毎回は軽く、必要なときだけ深く」かつ **再現可能** にする。

---

## 2. 標準アーキテクチャ（4層 + Ref Plan）

新ドメイン（例: TypeScript, GAS, Rust）を追加するとき、次の形を基本とする。

```text
L0  .cursor/rules/*-entry.mdc     … ファイル種別に自動適用（薄い入口・10〜20行）
L1  rule/{DOMAIN}_RULES.md       … 要約 SSOT（毎回・〜250行以内）
L2  .claude/skills/{skill}/SKILL.md … 手順・ゲート
L2.5 Ref Plan（チャット出力）    … コード編集前に読むファイルを固定
L3  skill/references/ + ROUTER.md … 詳細全文（Ref Plan に載ったものだけ Read）
```

| 層 | 載せる内容 | 載せない内容 |
|----|------------|--------------|
| L1 | 精神・MUST・tier 定義・索引 | KB 全文・テンプレ全文 |
| L2 | Step 0〜N・ゲート・ROUTER へのリンク | 重複したロード表 |
| L3 | テンプレ・KB・監査手順の全文 | — |
| ROUTER | tier floor + tag + シグナル推定 | 規律本文のコピー |

---

## 3. ルーティング方式 — Tier Floor + Tag 追加

### 3-1. Tier（作業の重さ）— floor

完了報告の重さと、**最低限読む references** を連動させる。

| tier | 目安 | floor（例: Python） |
|------|------|---------------------|
| **Light** | 1〜2ファイル・局所修正 | `ssot-audit` のみ |
| **Standard** | 機能追加・複数ファイル | floor + 開発規律 + **監査 KB** |
| **Full** | 新規・リリース・配布 | Standard + exemplar + テンプレ群 |

**原則:** Standard 以上では「監査・境界値」系ドキュメントを floor に含め、小さく見えても品質ゲートを落とさない。

### 3-2. Tag（技術・成果物）— 加算

tier の floor に **OR で足す**。同一ファイルは1回だけ。

| tag 例（Python） | 追加 references |
|------------------|-----------------|
| `excel` | KB 共通品質 + Excel |
| `streamlit` | KB Streamlit（+ UI なら共通品質） |
| `new_project` | ファイル構成 + テンプレ + 設計墓場 |
| `exe` | KB 環境・配布 + 操作メモ |

他ドメインでは `react`, `api`, `deploy` 等に置き換える。

### 3-3. コードシグナル → tag 推定（任意だが推奨）

エージェントが tag を付け忘れないよう、ROUTER に **キーワード表** を置く。

例: `openpyxl` / `.xlsx` → `excel` · `streamlit` → `streamlit` · `PyInstaller` → `exe`

### 3-4. パージ（過剰ロード防止）

- Light + tag なし + 特定 K-ID なし → **floor のみ**
- 目次ファイルを「常時全読み」しない（索引は ROUTER と L1 の ID 表で足りる）

---

## 4. Ref Plan ゲート（L2.5）

**コード・設定ファイルを Write/StrReplace する前に**、チャットへ短く出力する。

```markdown
## Ref Plan
- tier: Standard（理由を1行）
- tags: excel
- load: （読む references のパスまたは短名を列挙）
- skip: （読まないものと理由）
- ids: （該当ナレッジ ID があれば）
```

| ルール | 内容 |
|--------|------|
| 必須 | コード変更前に Ref Plan を出す（**Light は短形式**可 — Python は SKILL Step 0.1） |
| Light | `tier` + `load` のみで可。`tags` / `skip` / `ids` は省略可 |
| Standard 以上 | フル形式（`tags` · `load` · `skip` · `ids`） |
| 完了報告 | 「読んだ refs」を1行以上含める |
| 質問 | tag が不明なときだけユーザーに確認（毎回のアンケート禁止） |

---

## 5. SSOT の置き場所（新ドメイン追加チェックリスト）

| 成果物 | パス例 | SSOT か |
|--------|--------|---------|
| 要約ルール | `yk-skill/rule/{帯}/{DOMAIN}_RULES.md`（例: `40_python/PYTHON_RULES.md`） | ○ L1 |
| ルーティング | `.../references/ROUTER.md` | ○ ロード規則のみ |
| 手順 | `.../SKILL.md` | ○ 手順（ロード表は ROUTER リンク） |
| 詳細 KB | `.../references/*.md` | ○ 各トピック |
| アーカイブ | 別リポジトリの rev ファイル | △ 参照のみ・AI は原則編集しない |
| 調査メモ | 本ファイル | 設計パターン（ドメイン非依存） |

**禁止:**
- L1 に references 全文をコピー
- SKILL / RULES / README に **同一のロード表を3重記載**
- 「常時すべての KB を読め」と書く（索引の Step 0 手順は ROUTER に合わせて更新）

---

## 6. Cursor 固有の設定

| 手段 | 用途 |
|------|------|
| `paths: "**/*.py"`（SKILL frontmatter） | 該当ファイル作業時のみスキルを表面化 |
| `.cursor/rules/*-entry.mdc` + `globs` | L0 入口（PYTHON_RULES 等への誘導） |
| `disable-model-invocation: true` | 明示 `/skill` のみにしたいとき |

スキルは [Cursor Docs](https://cursor.com/docs/skills) の探索パス（`.cursor/skills/`, `.claude/skills/` 等）に置く。

---

## 7. 第2段階（任意）— 機械検証

| 手段 | 用途 |
|------|------|
| `load-manifest.yaml` | tag/tier → ファイル配列 |
| `route_refs.py` | manifest からパスを stdout（Ref Plan 自己チェック・CI） |

**原則:** スクリプト実行を毎タスク必須にしない（エージェントが忘れるため）。Ref Plan + ROUTER を主、スクリプトは補助。

---

## 8. サブスキル分割の判断

| 分割する | 分割しない（推奨） |
|----------|-------------------|
| ドメインが別製品（PDF 専用・デプロイ専用） | 同一 SDD・同一 KB 体系の言語違いだけ |
| description が明確に非重複 | 共通ゲート（SSoT 監査）が散らばる |

Python / TypeScript 等は **1 スキル + ROUTER の tag** で足りることが多い。

---

## 9. リスクと対策（運用）

| リスク | 対策 |
|--------|------|
| 参照スキップ | Ref Plan ゲート + 完了報告に refs 列挙 |
| tier の過小評価 | シグナル表 · Standard 既定を検討 |
| ROUTER 陳腐化 | ロード規則の更新は ROUTER のみ。他はリンク |
| アーカイブとのズレ | references を現行 SSOT、rev は人間向け |

---

## 10. 新ドメイン立ち上げ手順（テンプレ）

1. `rule/{帯}/{DOMAIN}_RULES.md` を L1 として作成（要約のみ。帯は `RULE_INDEX` の番号付きカタログ参照）
2. `.claude/skills/creating-{domain}-yk/` を作成（`SKILL.md` + `references/`）
3. `references/ROUTER.md` を ROUTER テンプレ（§3〜4）で起こす
4. `.cursor/rules/{domain}-dev-entry.mdc` を L0 として追加
5. `RULE_INDEX.md` に行を追加（クイック入口表の行も）
6. `RULE_ROUTING_PLAYBOOK.md` に読む順序節を追加
7. 本ファイル（PROGRESSIVE_CONTEXT_ROUTING_RULES）と `SKILL_AUTHORING_RULES` を参照してレビュー

**Python 実装の参照実装:** `creating-pythoncode-yk/references/ROUTER.md`
