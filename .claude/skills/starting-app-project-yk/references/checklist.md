# 新規 · 整理チェックリスト

SSOT: `c:/yk-skill/rule/10_meta/APP_PROJECT_RULES.md` §4–§8 · `c:/yk-skill/rule/10_meta/PROJECT_DOCUMENT_RULES.md`（No 25）§7 · §11 · §12

---

## 新規アプリ

| # | 成果物 | 完了条件 |
|---|--------|----------|
| 1 | **slug** | ユーザー確認済み |
| 2 | `handoffs/{slug}/HANDOFF.md` | 企画パス · コードパス · §6 ロードマップ |
| 3 | `handoffs/{slug}/README.md` | 索引（任意だが推奨） |
| 4 | 企画フォルダ **最小 3 種** | `01_要求定義/` · `04_リポジトリ構造/` · `05_開発ガイドライン/`（[PROJECT_DOCUMENT_RULES §7](c:/yk-skill/rule/10_meta/PROJECT_DOCUMENT_RULES.md)） |
| 5 | 企画ルート `README.md` | 再開 3 ファイル · サブフォルダ索引 |
| 6 | `01_要求定義/プロジェクト概要.md` | 一文 · やる/やらない |
| 7 | `01_要求定義/MVP定義.md` または `完成チェックリスト.md` | 受け入れ条件が測定可能（AC 表 · [PROJECT_DOCUMENT_RULES §10.2](c:/yk-skill/rule/10_meta/PROJECT_DOCUMENT_RULES.md)） |
| 8 | `04_リポジトリ構造/リポジトリ構造.md` | コード置き場 · slug 対応 1 行 |
| 9 | `05_開発ガイドライン/エージェント憲法.md` | [agents-template.md](agents-template.md) §必須項目すべて · 500 行未満 |
| 10 | `05_開発ガイドライン/decision-log.md` | 初行または空テンプレ（推奨） |
| 11 | `新チャット依頼.md`（ルート） | handoffs + エージェント憲法のコピペのみ |
| 12 | `handoffs/README.md` + `routing.md` §既知プロジェクト | slug 1 行追加 |
| 13 | `00.ai-driven-school/README.md` | プロジェクト一覧 1 行（該当時） |
| 14 | コード置き場 | リポ · パスを HANDOFF と憲法に一致 |

**講座提出プロジェクトのみ追加:** `00_テーマ/`（`テーマ.md` · `選定表_記入稿.md`）— [PROJECT_DOCUMENT_RULES §12.2](c:/yk-skill/rule/10_meta/PROJECT_DOCUMENT_RULES.md)

**任意（§12 トリガー後）:** `02_機能設計/` · `03_技術仕様/` · `06_ユビキタス言語/` · `99_アーカイブ/`

**MUST NOT（新規）:** ルート `AGENTS.md` — 憲法は `05_開発ガイドライン/エージェント憲法.md` のみ（[PROJECT_DOCUMENT_RULES §4](c:/yk-skill/rule/10_meta/PROJECT_DOCUMENT_RULES.md)）

**実例:** [flowchart-web 企画](c:/yk-memo/00.ai-driven-school/個人テーマ_フローチャートアプリ/) · [エージェント憲法](c:/yk-memo/00.ai-driven-school/個人テーマ_フローチャートアプリ/05_開発ガイドライン/エージェント憲法.md)

---

## 既存プロジェクト整理

| # | 作業 | 完了条件 |
|---|------|----------|
| 1 | 進捗 SSOT を **handoffs** に一本化 | 企画 `再開メモ` は stub のみ |
| 2 | `README.md` 読む順序 | 0. HANDOFF → §4 → エージェント憲法 |
| 3 | `新チャット依頼.md` 薄型化 | 長文 PRD 削除 |
| 4 | M3 / 完成 / C-2 定義統一 | 全 SSOT で同一 1 行 |
| 5 | C-2 等 **人間タスク** | §4 から除外 · HANDOFF §6 に担当明記 |
| 6 | 手動確認スナップショット | 冒頭に「正本は handoffs / チェックリスト」→ `99_アーカイブ/evidence/` |
| 7 | `05_開発ガイドライン/エージェント憲法.md` | 未作成なら新規 · SSOT マップに 6 種パス |
| 8 | **6 種移行**（任意 · 成熟時） | [PROJECT_DOCUMENT_RULES §8](c:/yk-skill/rule/10_meta/PROJECT_DOCUMENT_RULES.md) — 旧 `01_product/` 等から吸収 · ルート `AGENTS.md` は stub 化 |

**触らない:** handoffs archive 済みセッションの歴史本文 · ADR 番号体系

---

## 完了報告（ユーザー向け）

- slug · 企画パス · handoffs パス
- 作成/更新ファイル一覧
- 再開用 `@` 依頼文（3 ファイル: HANDOFF · セッション §4 · エージェント憲法）
- 未実施（意図的に残したこと）1〜3 行
