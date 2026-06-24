---
name: starting-app-project-yk
description: >
  個人アプリの企画パック新設・handoffs 一本化・エージェント憲法整備。発火例「新しいアプリを始めて」「企画フォルダを作って」「エージェント憲法を作って」「AGENTS.md を作って」「handoffs に移行して」。
  Do NOT use for セッション再開/引き継ぎ終了（→ handoff-session-work）、スタック実装（→ creating-nextjs-yk 等）、commit（→ committing-with-git-yk）、rule L1 新設のみ（→ PROGRESSIVE + RULE_INDEX）。
---

# Starting App Project（YK）

個人開発 × AI 向けの **企画パック設置**と **handoffs 一本化**。方針 SSOT は No 17 `APP_PROJECT_RULES.md` · No 25 `PROJECT_DOCUMENT_RULES.md` — 本スキルは手順のみ。

**応答の先頭ラベル:** `[新規]` `[整理]` `[憲法]` のいずれか。

## モード選択（先に 1 つ）

| モード | 発火例 | 成果物 |
|--------|--------|--------|
| **新規** | 新しいアプリ · 企画フォルダを作って · プロジェクトを始めて | slug · HANDOFF · 企画最小 3 種 · エージェント憲法 |
| **整理** | handoffs に移行 · 再開メモを廃止 · Phase 1 整理 | stub · README 読む順序 · 進捗表記統一 |
| **憲法** | エージェント憲法 · AGENTS.md · 憲法を書いて | `05_開発ガイドライン/エージェント憲法.md`（+ `新チャット依頼.md` 薄型化） |

曖昧なときは **1 問だけ**: 新規 / 既存整理 / 憲法のみ。

## 依存（Read 順）

| 順 | SSOT |
|----|------|
| 1 | `c:/yk-skill/rule/10_meta/APP_PROJECT_RULES.md` |
| 2 | `c:/yk-skill/rule/10_meta/PROJECT_DOCUMENT_RULES.md` §7 · §11 · §12 |
| 3 | 本スキル [references/checklist.md](references/checklist.md) |
| 4 | 憲法作成時 → [references/agents-template.md](references/agents-template.md) |
| 5 | handoffs 初回/整理 → スキル `handoff-session-work` · `references/routing.md` |

## 新規モード

1. **slug** をユーザーに確認（小文字 · ハイフン · 推測で新設しない）
2. [checklist.md §新規](references/checklist.md#新規アプリ) に従い Write
3. `handoffs/{slug}/HANDOFF.md` · `handoffs/README.md` · `routing.md` §既知プロジェクト例 を更新
4. 企画 `README.md` に再開 3 ファイル · handoffs リンク
5. **`新チャット依頼.md`** は handoffs + エージェント憲法の短いラッパのみ
6. スタックが決まっていれば `RULE_INDEX` クイック入口の No を憲法に列挙

**禁止:** 完成チェックリスト全項目の一括作成 · 122KB 級 HANDOFF · 企画にセッション進捗 SSOT · ルート `AGENTS.md`（新規）

## 整理モード

既存企画で `再開メモ.md` 等の二重 SSOT があるとき（[flowchart-studio 実例](c:/yk-memo/00.ai-driven-school/個人テーマ_フローチャートアプリ/)）。

1. [checklist.md §整理](references/checklist.md#既存プロジェクト整理) を実行
2. `再開メモ.md` → handoffs リダイレクト stub（削除しない）
3. M3 / C-2 / 完成の表記を **1 行定義**に統一
4. §4 は handoffs セッション MD のみ（企画フォルダに「次の1件」を置かない）
5. 人間専用タスクは §4 に載せず HANDOFF §6 に「担当: ユーザー」

引き継ぎ **終了/再開** そのもの → `handoff-session-work` に委譲。

## 憲法モード

1. [agents-template.md](references/agents-template.md) を Read
2. `05_開発ガイドライン/エージェント憲法.md` にプロジェクト値で Write（**500 行未満**）
3. slug ↔ 企画パス ↔ コードパスを 1 表に

## 使わない場面

| 依頼 | 正しい扱い |
|------|------------|
| 続きから · 引き継ぎして | `handoff-session-work` |
| Next.js / React Flow 実装 | `creating-nextjs-yk` · `creating-reactflow-yk` 等 |
| commit / push | `committing-with-git-yk` |
| No 17 / No 25 rule 本文の改訂のみ | 各 `*_RULES.md` 直接 |

## 制約

- **commit** — ユーザー明示までしない
- **v1 注意** — 実例は flowchart-studio のみ。2 アプリ目以降で checklist を [references/checklist.md](references/checklist.md) に追記

## 参照

- 実例: [flowchart-studio AGENTS.md](c:/yk-application/flowchart-studio/AGENTS.md)（企画側は [stub](c:/yk-memo/00.ai-driven-school/個人テーマ_フローチャートアプリ/AGENTS.md)）
- プレイブック: `RULE_ROUTING_PLAYBOOK.md` §個人アプリ
