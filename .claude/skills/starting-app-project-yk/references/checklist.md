# 新規 · 整理チェックリスト

SSOT: `c:/yk-skill/rule/10_meta/APP_PROJECT_RULES.md` §4–§8

---

## 新規アプリ

| # | 成果物 | 完了条件 |
|---|--------|----------|
| 1 | **slug** | ユーザー確認済み |
| 2 | `handoffs/{slug}/HANDOFF.md` | 企画パス · コードパス · §6 ロードマップ |
| 3 | `handoffs/{slug}/README.md` | 索引（任意だが推奨） |
| 4 | 企画フォルダ構成 | `01_product/` `02_spec/` `03_plan/` `04_decisions/` `99_archive/`（[APP_PROJECT_RULES §6](c:/yk-skill/rule/10_meta/APP_PROJECT_RULES.md)） |
| 5 | 企画ルート `README.md` | 再開 3 ファイル · サブフォルダ索引 |
| 6 | `01_product/プロジェクト概要.md` | 一文 · やる/やらない |
| 7 | `01_product/MVP定義.md` または `完成チェックリスト.md` | 受け入れ条件が測定可能 |
| 8 | **`AGENTS.md`（ルート）** | [agents-template.md](agents-template.md) §必須項目すべて |
| 9 | `新チャット依頼.md`（ルート） | handoffs + AGENTS のコピペのみ |
| 10 | `handoffs/README.md` + `routing.md` §既知プロジェクト | slug 1 行追加 |
| 11 | `00.ai-driven-school/README.md` | プロジェクト一覧 1 行（該当時） |
| 12 | コード置き場 | リポ · パスを HANDOFF と AGENTS に一致 |

**任意（後から可）:** `02_spec/*` · `04_decisions/ADR` · `03_plan/フェーズ計画.md`

**実例:** [flowchart-web 企画](c:/yk-memo/00.ai-driven-school/個人テーマ_フローチャートアプリ/)

---

## 既存プロジェクト整理

| # | 作業 | 完了条件 |
|---|------|----------|
| 1 | 進捗 SSOT を **handoffs** に一本化 | 企画 `再開メモ` は stub のみ |
| 2 | `README.md` 読む順序 | 0. HANDOFF → §4 → AGENTS |
| 3 | `新チャット依頼.md` 薄型化 | 長文 PRD 削除 |
| 4 | M3 / 完成 / C-2 定義統一 | 全 SSOT で同一 1 行 |
| 5 | C-2 等 **人間タスク** | §4 から除外 · HANDOFF §6 に担当明記 |
| 6 | 手動確認スナップショット | 冒頭に「正本は handoffs / チェックリスト」 |
| 7 | `AGENTS.md` | 未作成なら新規 · SSOT マップに `01_product/` 等のパス |
| 8 | **階層化**（任意） | フラット → `01_product/`〜`99_archive/` 移行 · リンク更新 |

**触らない:** handoffs archive 済みセッションの歴史本文 · ADR 番号体系

---

## 完了報告（ユーザー向け）

- slug · 企画パス · handoffs パス
- 作成/更新ファイル一覧
- 再開用 `@` 依頼文（3 ファイル）
- 未実施（意図的に残したこと）1〜3 行
